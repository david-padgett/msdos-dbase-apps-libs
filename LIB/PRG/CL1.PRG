* File        : CL1.PRG
* Module      : CLIPPER
* System      : None
* Description : A method for re-programming the F10 key.
* Modified    : 04/11/91 DWP Created.

* Procedure   : key_f10
* Description : Displays information about the current database and index
*               file, such as their names, the current record, the total
*               number of records, and the system date and time.
* Expects     : p = Required by CLIPPER, but not used.
*               l = Required by CLIPPER, but not used.
*               v = Required by CLIPPER, but not used.
* Returns     : Nothing.
* Modified    : 04/04/91 DWP Initial coding.
* Notes       :

procedure key_f10
   parameters p, l, v
   private scrn, xpos, ypos

   xpos = col()
   ypos = row()
   scrn = savescreen(6, 23, 16, 54)
   @ 6, 23 to 16, 54 double
   @ 7, 24 clear to 15, 53
   @ 8, 25 say  'File   - ' + iif(type('dbf_file') = 'C', upper(dbf_file), upper(dbf()))
   @ 9, 25 say  'Index  - ' + iif(type('ndx_file') = 'C', upper(ndx_file), 'Undefined')
   @ 10, 25 say 'Record - ' + ltrim(str(recno(), 9, 0)) + '/' + ltrim(str(reccount(), 9, 0))
   @ 14, 27 say 'Press Any Key To Continue.'
   set cursor off

   do while inkey() = 0
      @ 12, 29 say dtoc(date()) + '    ' + time()
   enddo

   set cursor on
   restscreen(6, 23, 16, 54, scrn)
   @ ypos, xpos say ''

   release scrn, xpos, ypos
return
