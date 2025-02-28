* File        : CL8.PRG
* Module      : CLIPPER
* System      : None
* Description :
* Modified    : 044/11/91 DWP Created.

* Procedure   : rpt_msg
* Description : Displays a message informing the user of what action needs to
*               be taken before processing actually starts.  Also initializes
*               the destination device, and opens it, if necessary.
* Expects     : Nothing.
* Returns     : Nothing.
* Modified    : 04/04/91 DWP Initial coding.
* Notes       :

procedure rpt_msg

   do case

      case out_dev = 'file'

         @ 10, 23 to 16, 55 double
         @ 11, 24 clear to 15, 54
         @ 12, 27 say 'Insert Disk If Necessary.'
         @ 14, 27 say 'Press Any Key When Ready.'

         do while inkey() = 0
         enddo

         @ 11, 24 clear to 15, 54
         @ 13, 25 say 'Writing To File, Please Wait.'
         set console off
         set alternate to &out_file
         set alternate on

      case out_dev = 'printer'

         @ 10, 20 to 16, 60 double
         @ 11, 21 clear to 15, 59
         @ 12, 23 say 'Make Sure Your Printer Is On-Line.'
         @ 14, 27 say 'Press Any Key When Ready.'

         do while inkey() = 0
         enddo

         @ 11, 21 clear to 15, 59
         @ 13, 28 say 'Printing, Please Wait.'
         set console off
         set printer to &print_dev
         set print on

      case out_dev = 'screen'
   endcase
return
