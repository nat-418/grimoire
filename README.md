# Grimoire 📖
![License badge](https://flat.badgen.net/badge/license/0BSD/blue)
![Language badge](https://flat.badgen.net/badge/language/Tcl/blue)
![CC badge](https://flat.badgen.net/badge/conventional%20commits/1.0.0/blue)
![Release badge](https://flat.badgen.net/github/release/nat-418/grimoire)
![Checks badge](https://flat.badgen.net/github/checks/nat-418/grimoire/main)

This is a collection of scripts I have written primarily for
my own personal use, mostly written in Tcl.

## Installing
- To install the scripts, first run `$ tclsh ./src/take.tcl install`.
- To reinstall from there, just run `$ take install`.
- To test them, run `$ take test`.

## Script index
## perdiff 📉
Calculate the percent difference between two numbers.

### Requirements
- `tcllib`

### Example
```bash
$ perdiff 1 2
+50%
```

### porthogs 🐷
Find which processes are hogging what ports, and optionally kill them.

#### Requirements
- `ss` or `lsof`

#### Example
```bash
$ nc -l -p 1222 &
[1] 11899
$ porthogs 1222
NAME	PORT	PID	STATUS
nc	1222	11899	alive
$ porthogs 1222 --kill
NAME	PORT	PID	STATUS
nc	1222	11899	killed
[1]+  Killed   nc -l -p 1222
```

### take 🥡
A simple task-runner. Tasks are specified in a Takefile using standard
Tcl syntax extended to support system commands (e.g., `ls`) and running
other tasks.

#### Example
```tcl
install {
    package require fileutil
    foreach file [glob ./src/*] {
        ::fileutil::install -m +x $file ~/.local/bin/
    }
}

test {
    set argv ""
    set argc 0
    source ./tests/all.tcl
}

default {
    test
    ls
    puts "Eureka!"
}
```

