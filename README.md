Grimoire 📖
===========
This is a collection of scripts I have written primarily for
my own personal use, mostly written in Tcl.

To install the scripts, first run `$ tclsh ./src/take.tcl install`.
To reinstall from there, just run `$ take install`.
To test them, run `$ take test`.

perdiff 📉
----------
Calculate the percent difference between two numbers.
```bash
$ perdiff 1 2
+50%
```

porthogs 🐷
-----------
Find which processes are hogging what ports, and optionally kill them.
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

take 🥡
-------
A task-runner program implemented in Tcl. Tasks are
specified in a Takefile using standard Tcl syntax extended
to support system commands (e.g., `ls`) and running other tasks.

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

