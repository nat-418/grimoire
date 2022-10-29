#!/usr/bin/env tclsh
package require cmdline
namespace import ::tcl::mathop::*

set version 0.1.0

set usage [string trim "
v$version - Calculate the percent difference between two numbers.

Usage: \$ perdiff \[options] \[n1 n2]

Options:
"]

set options {
    {old.arg "n1" "Number to compare from"}
    {new.arg "n2" "Number to compare to"}
}

proc calculate {x y} {
    # Cowardly refuse to calculate nonsense.
    if {$x eq "" || $y eq ""} {error "bad input"}

    if {[string length $x] > 90 || [string length $y] > 90} {error "bad input"}

    if {![string is digit $x] || ![string is digit $y]} {
        if {![string is double $x] || ![string is double $y]} {
            error "bad input"
        }
    }

    # How many decimals should we print?
    set precision %.2f
    if {[string is integer $x] || [string is integer $y]} {
        set precision %.0f
    }

    # Convert numeric input to floating-point.
    set x [* 1.0 $x]
    set y [* 1.0 $y]

    if {$x eq $y} {return 0%}
    # The Nagelfar syntax checker doesn't like this Lisp-y math style.
    ##nagelfar ignore
    if {$x > $y}  {return -[format $precision [* 100 [/ [- $x $y] $x]]]%}
    ##nagelfar ignore
    if {$x < $y}  {return +[format $precision [* 100 [/ [- $y $x] $x]]]%}

    error "calculation failed"
}

# Stop execution if we are being `source`d.
if {[info frame] eq 3} {return -code 0}

# Handle user input
try {
    if {$argv eq ""} {set argv "-help"}

    array set params [::cmdline::getoptions ::argv $options $usage]

    lassign $::argv old new

    if {$params(old) ne "n1"} {set old $params(old)}
    if {$params(new) ne "n2"} {set new $params(new)}

    puts stdout [calculate $old $new]
} trap {CMDLINE} {msg o} {
   puts stderr $msg
   exit 1
} on error {msg o} {
   puts stderr "Error: $msg."
   exit 1
}
