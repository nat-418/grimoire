package require tcltest
namespace import ::tcltest::*

set script ../src/perdiff.tcl

loadFile [file normalize [file join [file dirname [info script]] $script]]

loadTestedCommands

configure -verbose line

test input-1 {Bad first argument} -body {
    calculate a 1
} -returnCodes error -result "bad input"

test input-2 {Bad second argument} -body {
    calculate 2 b
} -returnCodes error -result "bad input"

test bad-input-3 {Bad both arguments} -body {
    calculate d c
} -returnCodes error -result "bad input"

test bad-input-4 {Big bad numbers} -body {
    calculate \
        27840123498712340964364657567564756474567546754674574574567546706140234.00 \
        7000000000300000490572049857203476127986965780958345700004567456856786383568358334023742173417
} -returnCodes error -result "bad input"

test bad-input-5 {Nothing given for input} -body {
    calculate "" ""
} -returnCodes error -result "bad input"

test calculate-1 {Correctly calculate no change}   {calculate 100 100}      0%
test calculate-2 {Correctly calculate an increase} {calculate 100 200}   +100%
test calculate-3 {Correctly calculate a  decrease} {calculate 200 100}    -50%
test calculate-4 {Correctly rounds off one third}  {calculate 3.0 2.0} -33.33%

test calculate-5 {Handle a big quarter} {calculate 4000000000 3000000000} -25%

test calculate-6 {Handle an even bigger quarter} {
    calculate \
      40000000000000000000000000000000000000000000000000000000000000000000000 \
      30000000000000000000000000000000000000000000000000000000000000000000000
} -25.00%

test calculate-7 {Handle a huge random calculation} {
    calculate \
        27840123498712340964364657567564756474567546754674574574567546706140234.00 \
        70000000003490572049857203476127986965780958345700004567456856786383568358334023742173417
} +251435666248851980288.00%


cleanupTests
