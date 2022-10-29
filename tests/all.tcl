package require tcltest
namespace import ::tcltest::*

configure -testdir [file dirname [info script]]
configure -file    *.test.tcl

runAllTests

