# File        : CLIPPER.MAK
# Module      : CLIPPER
# System      : None
# Description : The makefile for the library procedures and function for
#               CLIPPER.
# Modified    : 04/11/91 DWP Created.

.AUTODEPEND

TRANSLATOR=c:\clipper\clipper
TRANSLATOR_SWITCHES=
LINKER=tlink
LINKER_SWITCHES=/c /x
LIBRARIAN=tlib
LIBRARIAN_SWITCHES=/c

OUTPUT=clipper.lib
OBJ1=cl1.obj cl2.obj cl3.obj cl4.obj cl5.obj cl6.obj cl7.obj cl8.obj cl9.obj \
     cl10.obj
OBJ2=
LIB1=
LIB2=

$(OUTPUT): $(OBJ1) $(OBJ2) $(LIB1) $(LIB2)
	$(LIBRARIAN) $(LIBRARIAN_SWITCHES) $(OUTPUT) @lib.mak

.prg.obj:
	$(TRANSLATOR) $(TRANSLATOR_SWITCHES) $<
