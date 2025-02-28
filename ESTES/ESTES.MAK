# File        : ESTES.MAK
# Module      : ESTES
# System      : ESTES
# Description : The makefile for the ESTES program.
# Modified    : 04/07/91 DWP Created.

.AUTODEPEND

TRANSLATOR=c:\clipper\clipper
TRANSLATOR_SWITCHES=-m
LINKER=tlink
LINKER_SWITCHES=/c /x
LIBRARIAN=tlib
LIBRARIAN_SWITCHES=/c

OUTPUT=estes.exe
OBJ1=estes.obj proc.obj reports.obj screens.obj
OBJ2=
LIB1=..\lib\prg\clipper.lib
LIB2=c:\clipper\clipper.lib c:\clipper\extend.lib

$(OUTPUT) : $(OBJ1) $(OBJ2) $(LIB1) $(LIB2)
     $(LINKER) $(LINKER_SWITCHES) @estes.lnk

.prg.obj:
     $(TRANSLATOR) $< $(TRANSLATOR_SWITCHES)

estes.obj     : estes.prg
proc.obj      : proc.prg
reports.obj   : reports.prg
screens.obj   : screens.prg
