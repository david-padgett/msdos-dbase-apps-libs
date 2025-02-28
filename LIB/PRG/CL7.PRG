* File        : CL7.PRG
* Module      : CLIPPER
* System      : None
* Description :
* Modified    : 044/11/91 DWP Created.

* Procedure   : rpt_exit
* Description : Turns off the printer and restores output to the CRT.
* Expects     : Nothing.
* Returns     : Nothing.
* Modified    : 04/04/91 DWP Initial coding.
* Notes       :

procedure rpt_exit

   set print off
   set printer to
   set alternate off
   set alternate to
return
