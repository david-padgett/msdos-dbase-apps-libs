* File        : ESTES.PRG
* Module      : ESTES
* System      : ESTES
* Description : The main file for the ESTES program.
* Modified    : 04/04/91 DWP Created.

   private option

   clear
   option = 1
   do error_init
   do init_sys

   * Make sure key_f10 is properly linked in.

   if .f.
      do key_f10
   endif

   do while .t.

      if iscolor()
         set color to bg/n+,w/rb+
      endif

      do borders with ' ', 'Main Menu'
      option = menu(1, 1, 0, 'A - Add Records Menu   E - Edit Records Menu  D - Delete Records MenuR - Reports Menu       U - Utilities Menu     I - System Information Q - Quit               ', 'AEDRUIQ', option, 7, 28, 7, 23)

      do case

         case option = 0 .or. option = 7

            @ 9, 20 to 16, 58 double
	    @ 10, 21 clear to 15, 57
            @ 12, 23 say 'Exit this program, are you sure?'

            if menu(1, 0, 0, 'YesNo ', 'YN', 1, 14, 37, 1, 6) = 1
               exit
            endif

         case option = 1

            do add_menu

         case option = 2

	    do edit_menu

         case option = 3

            do del_menu

	 case option = 4

            do rpt_menu

         case option = 5

            do util_menu

         case option = 6

            set cursor off
            do borders with 'O', 'System Information'
            @ 7, 10 say 'System Date: ' + dtoc(date())
            @ 7, 48 say 'System Time: ' + time()
            @ 10, 28 say 'Current Printer      : ' + print_dev
            @ 11, 28 say 'Operating System     : ' + os()
            @ 12, 28 say 'Disk Space Available : ' + ltrim(str(diskspace()))
            @ 16, 0 say 'Program By:  CSFX'
	    @ 17, 13 say '1921 Haverhill'
	    @ 18, 13 say 'Normal, IL  61761'

            do while inkey() = 0
               @ 7, 23 say dtoc(date())
               @ 7, 61 say time()
            enddo

            set cursor on

      endcase
   enddo

   release option

   close all
   clear all
   clear

quit
