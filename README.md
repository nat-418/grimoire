# Grimoire 📖
![Semver badge](https://flat.badgen.net/badge/semantic%20versioning/2.0.0/blue)
![CC badge](https://flat.badgen.net/badge/conventional%20commits/1.0.0/blue)

This is a collection of scripts I have written primarily for
my own personal use. Feel free to borrow or improve them.

## Installing
## With Nix
Test the scripts out in `$ nix-shell` and install with
`$ nix-env -if default.nix`.

## Without Nix
1. To install all the scripts, first run `$ tclsh ./src/take.tcl install`.
2. To reinstall from there, just run `$ take install`.
3. To test them, run `$ take test`.
4. To install a single script, call `$ take install ./src/example.tcl`

## Script index
### dotctl 🎛️
A git wrapper to manage configuration files in a bare repository.

#### Requirements
- Tcl v8.6+
- git v2.38.0+

#### Example
```fish
$ dotctl status
On branch main
nothing to commit (use -u to show untracked files)
```
### gnb 📓
A command-line notebook using git. In memoriam
[hnb](https://hnb.sourceforge.net/). With gnb you can:
- Quickly add notes without context-switching to some dedicated
  note-taking application.
- Find notes by searching for keywords or over a time range.
- Easily sync notes across machines—it is just another git repository.

#### Requirements
- Tcl v8.6+
- git v2.38.0+

#### Examples
```fish
$ gnb search root
b4c09ae 3 minutes ago

    📓 gnb v0.1.0 root commit 
```

### perdiff 📉
Calculate the percent difference between two numbers.

#### Requirements
- Tcl v8.6+
- `tcllib`

#### Example
```fish
$ perdiff 1 2
+50%
```

### porthogs 🐷
Find which processes are hogging what ports, and optionally kill them.

#### Requirements
- Tcl v8.6+
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
A simple Tcl task-runner. Tasks are specified in a Takefile using standard
Tcl syntax. Tasks can call each other, e.g., `take task`.

#### Requirements
- Tcl v8.6+

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
    take test
}
```

