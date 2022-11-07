#!/usr/bin/env tclsh
package require Tcl 8.6

set version   1.0.0

proc bail {message {details ""}} {
    puts stderr "Error: $message."
    if {$details ne ""} {puts stderr $details}
    exit 1
}

proc parseFlags {input flags} {
    foreach {long short script} $flags {
        if {[regexp ".*$long.*|.*$short.*" $input]} {eval $script}
    }
}

proc parseTakefile {path} {
    if {![file exists $path]} {bail "no Takefile found"}

    try {
        set opened_takefile [open ./Takefile r]
        set takefile_data   [read $opened_takefile]
        close $opened_takefile
    } on error {message} {
        bail "failed to read Takefile" $message
    }

    return $takefile_data
}

proc take {task} {
    global tasks 

    if {$task eq ""} {
        set task default
    }

    if {$task in [dict keys $tasks] && $task ne "default"} {
        puts stdout "🥡 $task"
    }

    set last_task $task

    try {
        switch $task $tasks
    } on error {message} {
        bail $message
    }
}

parseFlags $argv {
    --help -h {
        global version
        puts stdout "🥡 take v$version | A simple Tcl task-runner\n"
        puts stdout "Usage: take \[options] \[task]\n"
        puts stdout "Options:"
        puts stdout "  -h, --help         Show this help message."
        puts stdout "  -l, --list         Show available tasks."
        puts stdout "  -v, --version      Show program version."
        puts stdout ""
        exit 0
    }
    --list -l {
        global takefile_data
        foreach task [dict keys $takefile_data] {puts $task}
        exit 0
    }
    --version -v {
        global version
        puts stdout $version
        exit 0
    }
}

set tasks [parseTakefile ./Takefile]

take $argv
