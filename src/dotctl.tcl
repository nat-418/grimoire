#!/usr/bin/env tclsh
package require Tcl 8.6

set version    0.1.0
set local      ~/.local/share/dotctl.git
set git_prefix "git --git-dir=$local --work-tree=$env(HOME)"

if {![file isdirectory $local/hooks]} {
    try {
        file mkdir $local
        cd $local
        exec git init --bare 
        exec git config --local pull.ff false
        exec git config --local pull.rebase true
    } on error {error_message} {
        puts stderr $error_message
        exit 1
    }
}

switch [lindex $argv 0] {
    dirname {
        puts $local
        exit 0
    }
    ls {
        set dirs [exec {*}$git_prefix ls-tree --full-tree -r --name-only HEAD]
        foreach dir $dirs {puts ~/$dir}
        exit 0
    }
    status {
        puts [exec {*}$git_prefix status -uno]
        exit 0
    }
    {} {exit 0}
}

try {
    set results [exec {*}$git_prefix {*}$argv]
    if {$results ne ""} {puts $results}
    exit 0
} on error {error_message} {
    puts stderr $error_message
    exit 1
}
