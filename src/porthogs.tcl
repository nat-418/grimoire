#!/usr/bin/env tclsh
# porthogs.tcl
# ============
#
# Find which processes are hogging what ports on your machine.
#
package require Tcl 8.6

set version 1.1.0

# Take the name of a system executable and return a boolean if it exists.
proc can_exec {program} {
  try {
    exec which $program
    return true
  } on error {error_message} {
    return false
  }
}

# Take a port number and return a dictionary like this:
# ```tcl
# {1222 {name nc pid 3535} 8080 {name whatever pid 5312}}
# ```
proc check {port} {
  set results {}

  # Iterating through all of /proc/net/tcp, /proc/net/udp, and /proc/*/fd/* 
  # is much slower than calling out to programs which *should* be available
  # on modern Unix-like enviornments. We prefer to use the more modern ss
  # command, but also support lsof for broader compatability.
  set ss_exists   [can_exec ss]
  set lsof_exists [can_exec lsof]
  
  # Quit if dependencies not met.
  if {!$ss_exists && !$lsof_exists} {
    puts stderr "Error: neither ss nor lsof installed."
    exit 1
  }

  if $ss_exists {
    set report [lindex [split [exec ss -ltp src ":$port"] "\n"] end]

    # Early return if nothing found.
    if {[lindex $report 0] eq "State"} {return ""}
  
    # Parse the data we care about.
    lassign [split $report {"",=()}] _ _ _ name _ _ pid

    dict set results $port name $name
    dict set results $port pid  $pid

    return $results
  }

  if $lsof_exists {
    set pid [split [exec lsof -ti:$port] "\n"]

    # Early return if nothing found.
    if {$pid eq ""} {return ""}

    # Parse the data we care about.
    set name [lindex [lindex [split [exec ps -f $pid] "\n"] end] 8]

    dict set results $port name $name
    dict set results $port pid  $pid

    return $results
  }
}

proc cli {argv} {
  global version

  set kill_mode false

  # First loop through to catch any flags / options given.
  foreach arg $argv {
    if {$arg in "version --version -version -v"} {
      return $version
    }

    if {$arg in "help --help -help -h"} {
      lappend help "porthogs v$version - Find port-hogging processes."
      lappend help {}
      lappend help {Usage:}
      lappend help {  $ porthogs [options] [ports...]}
      lappend help {}
      lappend help {Options:}
      lappend help {  -h, --help     Show this help message}
      lappend help {  -k, --kill     Terminate processes on ports}
      lappend help {  -v, --version  Show the application version}

      return [join $help "\n"]
    }

    if {$arg in "kill --kill -kill -k"} {
      set kill_mode true
      # Remove these flags for the next loop.
      set argv [lsearch -inline -all -not -exact $argv $arg]
    }
  }

  # Check to make sure we don't have bogus input.
  foreach arg $argv {
    if {![string is double $arg]} {
      puts "Error: '$arg' is not a valid port number."
      exit 1
    }
  }

  # Loop through and build up the results.
  try {
    set results [string trim [join [lmap port $argv {check $port}]]]
  } on error {error_message} {
    puts stderr $error_message
    exit 1
  }

  # Early exit if we got nothing.
  if {$results eq ""} {exit 0}

  lappend output "NAME\tPORT\tPID\tSTATUS"

  foreach key [dict keys $results] {
    set name [dict get $results $key name]
    set pid  [dict get $results $key pid]

    if $kill_mode {
      exec kill -9 $pid
      lappend output "$name\t$key\t$pid\tkilled"
    } else {
      lappend output "$name\t$key\t$pid\talive"
    }
  }

  return [join $output "\n"]
}

if {$argc eq 0} {
    set argv help
    set argc 1
}

puts [cli $argv]

