* File        : CL4.PRG
* Module      : CLIPPER
* System      : None
* Description : A method for taking action on the exit key of a call to read.
* Modified    : 04/11/91 DWP Created.

* Function    : read_field
* Description : Determines what action to take depending on the key pressed
*               to exit the read command.
* Expects     : Nothing.
* Returns     : A value in the range [0 .. 6] depending on the action that
*               should be taken.
*                  0 = Continue with next field.
*                  1 = Continue with previous field.
*                  2 = Continue with next screen.
*                  3 = Continue with previous screen.
*                  4 = Abort or exit, do not save.
*                  5 = Exit and save.
*                  6 = Repeat last entry.
* Modified    : 04/07/91 DWP Initial coding.
* Notes       :

function read_field

   private key, result

   begin sequence

      read
      key = lastkey()

      if key >= 32 .and. key <= 126
         result = 0
      else

         do case

            * Continue with next field.

            case key = 13 .or. key = 24

               result = 0

            * Continue with previous field.

            case key = 5

               result = 1

            * Continue with next screen.

            case key = 3

               result = 2

            * Continue with previous screen.

            case key = 18

               result = 3

            * Abort or exit, do not save.

            case key = 27

               result = 4

            * Exit and save.

            case key = 23

               result = 5

            otherwise

               result = 6

         endcase
      endif
   end

   release key

return (result)
