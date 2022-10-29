package require tcltest
namespace import ::tcltest::*
##nagelfar syntax configure x*
##nagelfar syntax runAllTests
##nagelfar variable exitCode

proc tcltest::cleanupTestsHook {} {
    variable numTests
    set ::exitCode [expr {$numTests(Failed) > 0}]
}

configure -testdir [file dirname [info script]]
configure -file    *.test.tcl

runAllTests

exit $exitCode
