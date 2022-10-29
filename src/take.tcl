#!/usr/bin/env tclsh
package require Tcl 8.6

set version 0.1.0

proc bail {message} {
    puts stderr "Error: $message."
    exit 1
}

# Parse command-line options
# --------------------------

proc ifopt {long short script} {
    if {[string match "*-$long*" $::argv]
        || [string match "-*$short*" $::argv]} $script
}

##nagelfar ignore
ifopt version v {
    puts stdout $::version
    exit 0
}

ifopt help h {
    puts stdout "take v$::version | A simple task-runner\n"
    puts stdout "Usage: take \[options] \[task]\n"
    puts stdout "Options:"
    puts stdout "  -h, --help         Show this help message."
    puts stdout "  -v, --version      Show program version."
    puts stdout ""
    exit 0
}

# Parse Takefile
# --------------

if {![file exists ./Takefile]} {bail "no Takefile found"}

set opened_takefile [open ./Takefile r]
set takefile_data [read $opened_takefile]
close $opened_takefile

proc take {task} {
    global takefile_data

    try {
        switch $task $takefile_data
    } on error {message} {
        bail $message
    }
}

# Extend Tcl so that Takefile task names and system commands can be run
# without extra syntax.
rename unknown original_unknown
proc unknown args {
    global takefile_data original_unknown

    if {$args in [dict keys $takefile_data]} {
        return [take $args]
    }

    try {
        return [puts [exec {*}$args]]
    } on error _ {
        return [uplevel 1 original_unknown $args]
    }
}

take [lindex $argv 0]
