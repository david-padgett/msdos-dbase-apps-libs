* File        : CL10.PRG
* Module      : CLIPPER
* System      : None
* Description : A method for setting the destination of a report.
* Modified    : 044/11/91 DWP Created.

* Procedure   : print_to
* Description : Sets the destination of the report.
* Expects     : Nothing.
* Returns     : Nothing.
* Modified    : 04/04/91 DWP Initial coding.
* Notes       :

function print_to

   private p1, option, result

   begin sequence

      result = .t.

      @ 14, 21 to 22, 57
      @ 15, 22 clear to 21, 56
      @ 15, 32 say 'Send Report To'
      option = menu(1, 1, 0, 'File   PrinterScreen ', 'FPS', 1, 17, 36, 3, 7)

      do case

         case option = 0

            result = .f.

         case option = 1

            out_dev = 'file'
            out_file = space(50)
            @ 16, 22 clear to 21, 56
            @ 16, 34 say 'What File?'

            do while .t.
               do while out_file = space(50)

                  @ 18, 32 say '>' get out_file picture '@S12@!'
                  read

                  if lastkey() = 27
                     result = .f.
                     exit
                  endif
               enddo

               if .not. result
                  exit
               endif


               out_file = iif(at('.', out_file) = 0, alltrim(out_file) + '.txt', alltrim(out_file))

               if file(out_file)
                  p1 = ' '
                  @ 20, 23 say 'File Already Exists, Overwrite?' get p1 picture '@!'
                  read

                  if p1 = 'Y'
                     exit
                  else
                     out_file = space(50)
                  endif
               else
                  exit
               endif
            enddo

         case option = 2

            out_dev = 'printer'

         case option = 3

            out_dev = 'screen'

      endcase
   end

   release p1, option

return (result)
