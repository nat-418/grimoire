#!/usr/bin/env tclsh
package require Tcl 8.6

set version 0.1.0

set local ~/.local/share/gnb

proc parseGitLog {args} {
    set raw [exec git log {*}$args --pretty={%h}\ {%s}\ {%b}\ {%aN}\ {%aE}\ {%aD}]
    set results {}
    foreach line [split $raw \n] {
        set result {}
        dict set result hash    [lindex $line 0]
        dict set result subject [lindex $line 1]
        dict set result body    [lindex $line 2]
        dict set result name    [lindex $line 3]
        dict set result email   [lindex $line 4]
        dict set result date    [lindex $line 5]
        lappend results $result
    }
    return $results
}

proc prettyGitLog {logs_list}  {
    foreach log_dict $logs_list {
        dict with log_dict {
            ##nagelfar ignore Unknown variable
            puts stdout "$hash $subject"
            ##nagelfar ignore Unknown variable
            if {$body ne ""} {
                ##nagelfar ignore Unknown variable
                puts stdout $body
            }
        }
    }
    return true
}

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
    puts stdout {  add     message?  Create a new note}
    puts stdout {  edit              Modify notes}
    puts stdout {  git     […]       Perform arbitrary git commands}
    puts stdout {  help              Show this help message}
    puts stdout {  last    range     Show notes by range, e.g., "1" or "year"}
    puts stdout {  search  pattern   Show notes matching pattern}
    puts stdout {  sync              Pull from and push to remote repository}
    puts stdout {  version           Show version number}
    puts stdout {}
    return true
}

proc search {args} {
    return [prettyGitLog [parseGitLog --regexp-ignore-case --grep=$args]]
}

proc last {args} {
    if {[string is integer $args]} {
        return [prettyGitLog [parseGitLog --regexp-ignore-case -n $args]]
    }
    switch $args {
        day   {set args "one day"}
        week  {set args "one week"}
        month {set args "one month"}
        year  {set args "one year"}
    }
    return [prettyGitLog [parseGitLog --regexp-ignore-case --since=$args]]
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
    help    {return [help]}
    version {return [version]}
    default {
        puts stderr "Error: bad input. Try asking for help"
        exit 1
    }
}

puts stderr "Error: failed to process command-line input."
exit 1
