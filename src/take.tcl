#!/usr/bin/env tclsh
package require Tcl 8.6

set version 0.1.1

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
    global argv 
    if {[regexp ".*--$long.*"  $argv]} {eval $script}
    if {[regexp ".*-$short.*" $argv]}  {eval $script}
    return false
}

ifopt help h {
    global version
    puts stdout "take v$version | A simple task-runner\n"
    puts stdout "Usage: take \[options] \[task]\n"
    puts stdout "Options:"
    puts stdout "  -h, --help         Show this help message."
    puts stdout "  -l, --list         Show available tasks."
    puts stdout "  -v, --version      Show program version."
    puts stdout ""
    exit 0
}

ifopt list l {
    global takefile_data
    foreach task [dict keys $takefile_data] {puts $task}
    exit 0
}

##nagelfar ignore Found constant
ifopt version v {
    global version
    puts stdout $version
    exit 0
}

# Extend Tcl so that Takefile task names can be used without extra syntax.
rename unknown original_unknown
proc unknown args {
    global takefile_data original_unknown

    if {$args in [dict keys $takefile_data]} {
        return [take $args]
    }

    return [uplevel 1 original_unknown $args]
}

take $argv
