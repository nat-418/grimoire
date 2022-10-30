#!/usr/bin/env tclsh
package require Tcl 8.6

set version 0.1.0

set local ~/.local/share/gnb

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
    puts stdout {Usage: [puts stdout] gnb subcommand [arguments]}
    puts stdout {}
    puts stdout {Subcommands:}
    puts stdout {  add     message?    Create a new note}
    puts stdout {  edit                Modify old notes}
    puts stdout {  git     [commands]  Perform arbitrary git commands}
    puts stdout {  help                Show this help message}
    puts stdout {  search  pattern     Find old notes by regex}
    puts stdout {  sync                Pull and push notes}
    puts stdout {  version             Show version number}
    puts stdout {}
    return true
}

proc search {args} {
    puts stdout [exec git log --all --regexp-ignore-case --grep=$args]
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
    exec git commit --allow-empty -m "Initial commit"
    if {$remote ne ""} {
        ##nagelfar ignore Found constant
        exec git remote add origin $remote
        exec -ignorestderr git push -u origin main

    }
    puts ""
    set argv "help"
    set argc 1
}

cd $local

set subcommand [lindex $argv 0]
set arguments  [lrange $argv 1 end]

switch -glob $subcommand {
    add     {return [add $arguments]}
    edit    {return [interactive git rebase --interactive --root]}
    git     {return [interactive $subcommand {*}$arguments]}
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
