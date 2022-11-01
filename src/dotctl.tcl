#!/usr/bin/env tclsh
package require Tcl 8.6

set version    0.1.0
set home       $::env(HOME)
set local      $home/.local/share/dotctl.git
set git_prefix "git --git-dir=$local --work-tree=$home"

proc init {path} {
    try {
        file mkdir $path
        cd $path
        exec git init --bare 
        exec git config --local pull.ff false
        exec git config --local pull.rebase true
        exec git config --local status.showUntrackedFiles no
        return true
    } on error {error_message} {
        puts stderr "Error: init failed."
        puts stderr $error_message
        exit 1
    }
}

proc clone {path url} {
    try {
        file mkdir $path
        cd $path
        exec git clone --bare  {*}$url .
        exec git config --local status.showUntrackedFiles no
        exec git fetch --all
        return true
    } on error {error_message} {
        if {[lsearch $error_message "cloning"]} {
            return true
        }
        puts stderr "Error: clone failed."
        puts stderr $error_message
        exit 1
    }
}

if {![file isdirectory $local/hooks]} {
    try {
        puts stdout "No local repository found at $local."
        puts stdout "What would you like to do?"
        puts -nonewline stdout "(c)lone a remote, (i)nitialize a new "
        puts -nonewline stdout "repository, or (q)uit: "
        flush stdout
        switch [gets stdin] {
            c {
                puts -nonewline stdout "URL for the remote repository: "
                flush stdout
                clone $local [gets stdin]
            }
            i {init $local}
            default {exit 0}
        }
    } on error {error_message} {
        puts stderr $error_message
        exit 1
    }
}

switch [lindex $argv 0] {
    -help {
        puts "dotctl v$version - Manage dotfiles in a git bare repository.\n"
        puts {Usage: dotctl options [git commands]}
        puts {}
        puts {Options:}
        puts {  -help      Show this help message}
        puts {  -ls        Show what files are tracked in the repository}
        puts {  -path      Return the path to the repository}
        puts {}
        exit 0
    }
    -ls {
        set dirs [exec {*}$git_prefix ls-tree --full-tree -r --name-only HEAD]
        foreach dir $dirs {puts ~/$dir}
        exit 0
    }
    -path {
        puts $local
        exit 0
    }
    {} {exit 0}
    default {
        try {
            set results [exec {*}$git_prefix {*}$argv]
            if {$results ne ""} {puts $results}
            exit 0
        } on error {error_message} {
            puts stderr $error_message
            exit 1
        }
    }
}

