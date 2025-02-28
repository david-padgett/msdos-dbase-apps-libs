# msdos-dbase-apps-libs

## About
This repository contains source code for [MS-DOS](https://en.wikipedia.org/wiki/MS-DOS)-based apps and libraries built with the [dBase](https://en.wikipedia.org/wiki/DBase) DBMS.  The apps and libraries in this repo are written in the dBase programming language and compiled with [Clipper](https://en.wikipedia.org/wiki/Clipper_(programming_language)) compiler.  The source code was created with the [Borland C++](https://en.wikipedia.org/wiki/Borland_C%2B%2B) IDE.

Almost all of this code was written at the end of the golden age of MS-DOS.  Among the goals of this repo is to preserve as much as possible of the original code.  The most significant changes are in the project makefiles and Borland IDE project configuration files, and are primarily related to location of dependencies, binaries, etc.  In a few cases, it was necessary to re-create source code that was lost during the transition from 5.25" and 3.5" floppy disks to ZIP files, hard drives, and eventually cloud storage.  In one or two cases, minor changes were made to eliminate build errors.

## OS
* [MS-DOS](https://en.wikipedia.org/wiki/MS-DOS)

## Toolchain
* [DosBox](https://www.dosbox.com)
* [Clipper Summer 1987](https://winworldpc.com/product/clipper/5x)
* [Borland C++ Version 3.1](https://winworldpc.com/product/borland-c/30)

## Setup

### DosBox
The build scripts, project makefiles, and Borland project configuration files (e.g.: PRJ, DSK) expect the Borland and Clipper tools to be installed on drive C:.  Choose a local directory as the mount point for the C: drive, and then mount it via the DosBox command line:
```
mount c /path/to/msdos/c-drive
```

The contents of this repo were tested after being mounted to drive D:.  While this isn't an absolute requirement, relocating the projects may break builds implemented via project makefiles.  The contents of the repo may be mounted in DosBox via the following command:
```
mount d /path/to/this/repo
```

### Clipper Summer 1987
Installing the Clipper compiler should be done via copying files in the disk images to ```C:\CLIPPER```.  Download and mount these disk images, then copy their contents to ```C:\CLIPPER```.

### Borland C++ Version 3.1
Installing the Borland tools should be done via ```INSTALL.EXE```, which is included with the disk images available [here](https://winworldpc.com/product/borland-c/30).  Download and mount these disk images, then copy their contents to a temporary directory on the C: drive.  For example ```C:\TEMP```.

## Build Scripts

### BUILD.BAT
Individual projects that have a corresponding [makefile](https://en.wikipedia.org/wiki/Make_(software)) can be built with the ```BUILD.BAT``` script.  This script adds variables expected by the project makefiles, and builds all targets regardless dependency timestamps.  In most cases, <project-name> matches the directory in which the project exists.

**Usage**
```
cd \<project-directory>
\build <project-name>
```

### CLEAN.BAT
Individual projects may be cleaned (e.g.: ```make clean```) via the ```CLEAN.BAT``` script.  This script is used in place of ```make clean``` because the project makefiles did not originally include a ```clean``` rule, and, as described above I chose to minimize changes to the original source code.

**Usage**
```
cd \<project-directory>
\clean
```

## Projects

### LIB
The ```LIB``` directory contains a series of projects - based on the dBase programming language - that collectively implement a series of APIs, which are packaged as libraries that are in turn dependencies of other MS-DOS based apps in this repo.

Individual projects can be built via the ```BUILD.BAT``` script.  For example,
```
cd \lib\prg
\build lib
```
will build ```ARRAY.LIB``` via the makefile ```ARRAY.MAK```.

### ESTES
The ```ESTES``` directory contains the source code used to track data for a small business.

## License

[MIT](https://opensource.org/license/mit)