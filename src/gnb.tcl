#!/usr/bin/env tclsh
package require Tcl 8.6

set version 0.1.0

set local ~/.local/share/gnb

lappend log_format {---}
lappend log_format {id:     %h}
lappend log_format {author: %aN}
lappend log_format {date:   %aD}
lappend log_format {title:  %s}
lappend log_format {tags:   %N}
lappend log_format {---}
lappend log_format {%b}
lappend log_format { }
set log_format [join $log_format \n]

proc prompt {message {default {}}} {
    if {$default ne ""} {
        puts -nonewline stdout "$message? Defaults to $default if blank: " 
        flush stdout
        gets stdin input
        if {$input eq ""} {return $default}
        return $input
    }
    puts -nonewline stdout "$message? "
    flush stdout
    puts -nonewline $default
    gets stdin result
    return $result
}

proc config {} {
    set username [exec git config --get user.name]
    set email    [exec git config --get user.email]

    return [list [prompt "Remote git URL to sync with"]           \
                 [prompt "Username for git operations" $username] \
                 [prompt "Email for git operations"    $email]]
}

proc interactive {args} {
    try {
        puts -nonewline stdout [exec {*}$args <@stdin >@stdout 2>@stderr]
        return true
    } on error {message} {
        puts stderr $message
        exit 1
    }
}

proc add {args} {
    if {$args eq "{}"} {return [interactive git commit --allow-empty]}
    puts stdout [exec git commit --allow-empty --message {*}$args]
    return true
}

proc edit {} {
    return [interactive git rebase --interactive --root]
}

proc help {} {
    global version
    puts stdout "gnb v$version - Command-line interface for a git notebook"
    puts stdout {}
    puts stdout {Usage: gnb subcommand [arguments]}
    puts stdout {}
    puts stdout {Subcommands:}
    puts stdout {  add     message?     Create a new note}
    puts stdout {  edit                 Modify notes}
    puts stdout {  git     […]          Perform arbitrary git commands}
    puts stdout {  help                 Show this help message}
    puts stdout {  last    range        Show notes by range like "1" or "year"}
    puts stdout {  search  pattern      Show notes matching pattern}
    puts stdout {  sync                 Pull from and push to remote repository}
    puts stdout {  tag     tags [hash]  Set tags for last added note or by hash}
    puts stdout {  version              Show version number}
    puts stdout {}
    return true
}

proc search {args} {
    global log_format
    set args [string map {{ } {\ }} {*}$args]
    puts [exec git log --regexp-ignore-case --grep=$args --pretty=$log_format]
    return true
}

proc tag {arguments} {
    if {$arguments eq ""} {
        puts stderr "Error: bad input. Here is some help:\n"
        help
        return false
    }
    set message [lindex $arguments 0]
    set hash    [lindex $arguments 1]
    puts $message
    puts $hash
    if {$message eq ""} {set message " "}
    if {$hash    eq ""} {set hash [exec git rev-parse HEAD]}
    try {
        puts stdout [exec git notes add --force --message $message $hash]
    } on error {message} {
        puts stderr $message
    }
    return true
}

proc last {args} {
    global log_format
    if {[concat {*}$args] eq ""} {
        puts [exec git log -n 1 --pretty=$log_format]
        return true
    }
    if {[string is integer $args]} {
        puts [exec git log -n $args --pretty=$log_format]
        return true
    }
    switch $args {
        day   {set args "one day"}
        week  {set args "one week"}
        month {set args "one month"}
        year  {set args "one year"}
    }
    puts [exec git log --since=$args --pretty=$log_format]
    return true
}

proc sync {} {
    puts stdout [exec git pull]
    puts stdout [exec git push]
    return true
}

proc version {} {
    global version
    puts stdout $version
    return true
}

if {![file isdirectory $local/.git]} {
    puts stdout "First-time gnb setup…"
    file mkdir $local
    cd $local
    exec -ignorestderr git init
    exec git config --local pull.ff false
    exec git config --local pull.rebase true
    lassign [config] remote username email
    exec git config --local user.name  $username
    exec git config --local user.email $email
    exec git commit --allow-empty -m "📓 gnb v$version root commit"
    if {$remote ne ""} {
        ##nagelfar ignore Found constant
        exec git remote add origin $remote
        exec -ignorestderr git push -u origin main

    }
}

cd $local

set subcommand [lindex $argv 0]
set arguments  [lrange $argv 1 end]

switch -glob $subcommand {
    add     {return [add $arguments]}
    edit    {return [interactive git rebase --interactive --root]}
    git     {return [interactive $subcommand {*}$arguments]}
    last    {return [last   $arguments]}
    search  {return [search $arguments]}
    sync    {return [sync]}
    tag     {return [tag $arguments]}
    help    {return [help]}
    version {return [version]}
    default {
        puts stderr "Error: bad input. Here is some help: \n"
        help
        exit 1
    }
}

puts stderr "Error: failed to process command-line input."
exit 1
