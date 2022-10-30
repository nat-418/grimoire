#!/usr/bin/env tclsh
package require Tcl 8.6

set version 0.1.0

set config_file ~/.config/gnb/config.tcl

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

if {[file exists $config_file]} {
    source $config_file
} else {
    puts stdout "First-time gnb setup…"
    set local    [prompt "Path for the local git repository" ~/.local/share/gnb]
    set remote   [prompt "Remote git URL to sync with"]
    set username [prompt "Username for git operations"]
    set email    [prompt "Email for git operations"]

    file mkdir [file dirname $config_file]
    set open_config [open $config_file w]
    foreach line {
        {set local    $local}
        {set remote   $remote}
        {set username $username}
        {set email    $email}
    } {
        set config_line [string trim [subst -nobackslashes -nocommands $line]]
        puts $open_config $config_line
    }
    close $open_config
    puts "Wrote configuration to $config_file"

    puts ""
    set argv "help"
    set argc 1
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
    puts stdout [exec git commit --allow-empty --message $args]
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
    puts stdout {  add      message?  Create a new note}
    puts stdout {  edit               Modify old notes}
    puts stdout {  help               Show this help message}
    puts stdout {  search   pattern   Find old notes by regex}
    puts stdout {  sync               Pull and push notes}
    puts stdout {  version            Show version number}
    puts stdout {}
    puts stdout {  All other input is passed through to the git command.}
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
    file mkdir $local
    cd $local
    exec -ignorestderr git init
    exec git branch -m main
    exec git config --local pull.ff false
    exec git config --local pull.rebase true
    exec git config --local user.name  $username
    exec git config --local user.email $email
    ##nagelfar ignore Found constant
    exec git remote add origin $remote
    exec git commit --allow-empty -m "Initial commit"
    exec -ignorestderr git push -u origin main
}

if {$argc eq 0} {return [help]}

cd $local

set subcommand [lindex $argv 0]
set arguments  [lrange $argv 1 end]

switch -glob $subcommand {
    add     {return [add $arguments]}
    edit    {return [interactive git rebase --interactive --root]}
    search  {return [search $arguments]}
    sync    {return [sync]}
    help    {return [help]}
    version {return [version]}
    default {return [interactive git $subcommand {*}$arguments]}
}

puts stderr "Error: failed to process command-line input."
exit 1
