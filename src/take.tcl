#!/usr/bin/env tclsh
package require Tcl 8.6

set version 0.1.0

proc bail {message {details ""}} {
    puts stderr "Error: $message."
    if {$details ne ""} {puts stderr $details}
    exit 1
}

# Parse Takefile
# --------------

if {![file exists ./Takefile]} {bail "no Takefile found"}

try {
    set opened_takefile [open ./Takefile r]
    set takefile_data [read $opened_takefile]
    close $opened_takefile
} on error {message} {
    bail "failed to read Takefile" $message
}

proc take {task} {
    global takefile_data

    try {
        switch $task $takefile_data
    } on error {message} {
        bail $message
    }
}

# Parse command-line options
# --------------------------

proc ifopt {long short script} {
    if {[string match "*-$long*" $::argv]
        || [string match "-*$short*" $::argv]} $script
}

ifopt help h {
    puts stdout "take v$::version | A simple task-runner\n"
    puts stdout "Usage: take \[options] \[task]\n"
    puts stdout "Options:"
    puts stdout "  -h, --help         Show this help message."
    puts stdout "  -l, --list         Show available tasks."
    puts stdout "  -v, --version      Show program version."
    puts stdout ""
    exit 0
}

ifopt list l {
    foreach task [dict keys $::takefile_data] {puts $task}
    exit 0
}

##nagelfar ignore
ifopt version v {
    puts stdout $::version
    exit 0
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
