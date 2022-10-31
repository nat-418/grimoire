#!/usr/bin/env tclsh
package require Tcl 8.6

set version 0.1.0

set local ~/.local/share/gnb

set green \u001b\[32m
set bold  \u001b\[1m
set reset \u001b\[0m

set log_format "$green%h$reset %ad\n\n%w(64,4,4)%-s%-b$bold \n%+N$reset"

# Helper functions
# ----------------

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

proc interactive {args} {
    try {
        puts -nonewline stdout [exec {*}$args <@stdin >@stdout 2>@stderr]
        return true
    } on error {error_message} {
        puts stderr $error_message
        exit 1
    }
}

# Subcommands
# -----------

proc add {arguments} {
    if {$arguments eq ""} {return [interactive git commit --allow-empty]}
    try {
        exec git commit --allow-empty --message "$arguments"
    } on error {error_message} {
        puts $error_message
        exit 1
    }
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
    puts stdout {  search  keywords     Show notes matching keywords}
    puts stdout {  sync                 Pull from and push to remote repository}
    puts stdout {  tag     tags [hash]  Set tags for last added note or by hash}
    puts stdout {  version              Show version number}
    puts stdout {}
    return true
}

proc search {arguments} {
    global log_format
    if {$arguments eq ""} {
        puts stderr "Error: bad input. Here is some help:\n"
        help
        return false
    }
    set flags {--regexp-ignore-case --notes --date=relative}
    foreach argument [split $arguments " "] {
        append flags " " --grep=$argument
    }
    puts [exec git log {*}$flags --pretty=$log_format]
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
    if {$message eq ""} {set message " "}
    if {$hash    eq ""} {set hash [exec git rev-parse HEAD]}
    try {
        exec git notes add --force --message "$message" $hash
    } on error {error_message} {
        if {![lsearch $error_message "overwriting existing notes"]} {a
            puts stderr $error_message
        }
    }
    return true
}

proc last {args} {
    global log_format
    set flags {--notes --date=short}
    if {[concat {*}$args] eq ""} {
        puts [exec git log -n 1 {*}$flags --pretty=$log_format]
        return true
    }
    if {[string is integer $args]} {
        puts [exec git log -n $args {*}$flags --pretty=$log_format]
        return true
    }
    switch $args {
        day   {set args "one day"}
        week  {set args "one week"}
        month {set args "one month"}
        year  {set args "one year"}
    }
    puts [exec git log --since=$args {*}$flags --pretty=$log_format]
    return true
}

proc sync {} {
    try {
        puts stdout [exec git pull]
    } on error {error_message} {
        puts $error_message
        exit 1
    }
    try {
        puts stdout [exec git push]
    } on error {error_message} {
        puts $error_message
        exit 1
    }
    return true
}

proc version {} {
    global version
    puts stdout $version
    return true
}

# Command-line interface
# ----------------------

if {$argv eq ""} {
    set ::argv help
    set ::argc 1
}

if {![file isdirectory $local/.git]} {
    puts stdout "👉 First-time gnb setup:"
    try {
        file mkdir $local
        cd $local
        exec -ignorestderr git init
        exec git config --local pull.ff false
        exec git config --local pull.rebase true

        set username [exec git config --get user.name]
        set email    [exec git config --get user.email]

        set remote   [prompt " • Remote git URL to sync with"]
        set username [prompt " • Username for git operations" $username] 
        set email    [prompt " • Email for git operations"    $email]

        exec git config --local user.name  $username
        exec git config --local user.email $email
        exec git commit --allow-empty -m "📓 gnb v$version root commit"

        if {$remote ne ""} {
            ##nagelfar ignore Found constant
            exec -ignorestderr git remote add origin $remote
            exec -ignorestderr git push -u origin main
        }

        puts "   First-time setup completed successfully. 👈\n"
    } on error {error_message} {
        puts stderr "Error: first-time setup failed."
        puts stderr $error_message
        exit 1
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
