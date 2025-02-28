* File        : CL9.PRG
* Module      : CLIPPER
* System      : None
* Description : A method for displaying statistics about a report in
*               progress.
* Modified    : 044/11/91 DWP Created.

* Procedure   : rpt_stat
* Description : Displays statistics during the processing of a report.
* Expects     : p1 = The status type.
*               p2 = Initialize (1) or update only (2).
*               p3 = The report number.
*               p4 = The report name.
*               p5 = The page number.
*               p6 = The line number.
* Returns     :
* Modified    :
* Notes       :

procedure rpt_stat
   parameters p1, p2, p3, p4, p5, p6

   do case

      case p1 = 1

         if p2 = 1
            @ 17, 0 to 17, 79
            @ 18, 0 clear to 23, 79
            @ 19, int((79 - 19 - len(ltrim(str(p3, 2, 0)) + p4)) / 2) say 'Running Report #' + ltrim(str(p3, 2, 0)) + ' - ' + p4
            @ 21, 6 say 'File  :'
            @ 22, 6 say 'Record:'
            @ 21, 61 say 'Page  :'
            @ 22, 61 say 'Line  :'
         else
            @ 21, 14 say dbf()
            @ 22, 14 say ltrim(str(recno(), 9, 0)) + '/' + ltrim(str(reccount(), 9, 0)) + space(9)
            @ 21, 69 say str(p5, 5, 0)
            @ 22, 69 say str(p6, 5, 0)
         endif

      case p1 = 2
   endcase

   do display_function_key with 'R'

return
