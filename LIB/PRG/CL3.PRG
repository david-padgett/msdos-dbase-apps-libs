* File        : CL3.PRG
* Module      : CLIPPER
* System      : None
* Description : A method for displaying a pick list.
* Modified    : 04/11/91 DWP Created.

* Function    : pick_list
* Description : Displays a list of options and allows one of the options to
*               be selected via the keyboard directional keys.
* Expects     : title             = The title of the pick list.
*               default_selection = The first item to highlight in the
*                                   pick list.
*               dbf_file          = The database file that contains items
*                                   to be chosen from.  If this parameter
*                                   is blank, then the file in the current
*                                   work area will be used.
*               ndx_file          = The index file to use in conjunction with
*                                   the database file.  This parameter is not
*                                   used if the database file field is blank.
*               work_area         = The work area to use while manipulating
*                                   the specified database file.  This
*                                   parameter is not used if the database
*                                   file field is blank.
*               expression        = The expression to use when constructing
*                                   each of the items in the pick list.
*               start_row         = The row in which the pick list starts on.
*               start_col         = The column which the pick list starts in.
*               height            = The height of the pick list window.
*               length            = The length of the pick list window.
* Returns     : A value in the range [0 .. 6] depending on the action that
*               should be taken.
*                  0 = Continue with next field.
*                  1 = Continue with previous field.
*                  2 = Continue with next screen.
*                  3 = Continue with previous screen.
*                  4 = Abort or exit, do not save.
*                  5 = Exit and save.
*                  6 = Repeat last entry.
* Modified    : 04/09/91 DWP Initial coding.
* Notes       :

function pick_list
   parameters title, default_selection, dbf_file, ndx_file, work_area, expression, start_row, start_col, height, length

   private i, item, key, direction, screen, read_flag, update_flag, current_selection, current_row, start_item, result

   ignore_err = .f.
   help_type = 'P'

   begin sequence

      * Initialize the local variables.

      result = 0

      * If a database file was specified, attempt to open it.  If the
      * database file cannot be opened, then exit.

      if len(dbf_file) > 0
         if .not. open_database(1, dbf_file, ndx_file, '', work_area) = 0
            result = 4
         endif
      endif

      if result = 0

         * Display the pick list window.

         screen = savescreen(start_row, start_col, start_row + height, start_col + length)
         @ start_row, start_col to start_row + height - 1, start_col + length - 1 double
         @ start_row + 1, start_col + 1 clear to start_row + height - 2, start_col + length - 2
         @ start_row + 1, start_col + int((length - len(title)) / 2) say substr(title, 1, length - 2)
         @ start_row + 2, start_col say 'Ç' + replicate('Ä', length - 2) + '¶'

         * Initialize the remaining local variables.

         if default_selection > 0
	    store default_selection to current_selection, start_item
         else
	    store 1 to current_selection, start_item
         endif

         store .t. to update_flag, read_flag
         current_row = 1
         direction = 0

         * Loop until either ENTER, ESC, the Left Arrow, or the Right Arrow
         * is pressed.

         do while .t.

            * Update the contents of the pick list window, if necessary.

            if update_flag
               update_flag = .f.
               i = 1
               go top
	       skip start_item - 1

               * Loop until the pick list window has been filled.

               do while i < height - 3
		  item = iif(eof(), space(length - 4), substr(&expression + space(length - 4), 1, length - 4))
		  @ start_row + i + 2, start_col + 2 say item
                  i = i + 1
                  skip
               enddo

               * Re-position the database to the current selection.

               go top
               skip current_selection - 1
            endif

            * Invert the current selection, accept input from the keyboard,
            * and then normalize the current selection, if necessary.

            if read_flag
               skip direction
               direction = 0
	       item = substr(&expression + space(length - 4), 1, length - 4)
	       @ start_row + current_row + 2, start_col + 2 get item
               clear gets
               key = inkey(0)
	       @ start_row + current_row + 2, start_col + 2 say item
            else
               read_flag = .t.
            endif

            * Take action based on the last key pressed.

            do case

               case key = 13  && ENTER

                  result = 0
                  exit

               case key = 27  && ESC

                  result = 4
                  exit

               case key = 5   && Up Arrow

                  if current_selection > 1

                     current_selection = current_selection - 1

                     if current_row > 1
                        direction = -1
                        current_row = current_row - 1
                     else
			start_item = start_item - 1
                        update_flag = .t.
                     endif
                  endif

               case key = 24  && Down Arrow

                  if current_selection < reccount()

                     current_selection = current_selection + 1

                     if current_row < height - 4
                        direction = 1
                        current_row = current_row + 1
                     else
			start_item = start_item + 1
                        update_flag = .t.
                     endif
                  endif

               case key = 18  && PgUp

                  if current_selection - height - 4 > 1
                     update_flag = .t.
                     current_selection = current_selection - height - 4
		     start_item = start_item - height - 4
                  else
                     read_flag = .f.
                     key = 1
                  endif

               case key = 3   && PgDn

                  if current_selection + height - 4 < reccount()
                     update_flag = .t.
                     current_selection = current_selection + height - 4
		     start_item = start_item + height - 4
                  else
                     read_flag = .f.
                     key = 6
                  endif

               case key = 1   && Home

                  update_flag = .t.
		  store 1 to current_selection, start_item, current_row

               case key = 6   && End

                  update_flag = .t.
                  current_selection = reccount()
		  start_item = current_selection - height + 5

		  if .not. start_item > 0
		     start_item = 0
                  endif

                  current_row = iif(current_seleciton < height - 4, current_selection, height - 4)

               case key = 19  && Left Arrow

                  result = 1
                  exit

               case key = 4   && Right Arrow

                  result = 0
                  exit

               case key = 9   && Tab

                 result = 0
                 current_selection = 0
                 exit

               case key = 271 && Shift-Tab

                  result = 1
                  current_selection = 0
                  exit

               case key = 28  && F1

                  do help_system with '', 0, ''

            endcase
         enddo

         * Restore the screen to its previous state.

         restscreen(start_row, start_col, start_row + height, start_col + length, screen)
      endif

      * Close the database file currently in use if it was opened
      * by pick_list().

      if len(dbf_file) > 0
         use
      endif
   end

   * Update the default selection if no serious errors occurred.  The
   * default_selection parameter should be passed by reference.

   if .not. result = 4
      default_selection = current_selection
   endif

   release i, item, key, direction, screen, read_flag, update_flag, current_selection, current_row, start_item, error_flag

return (result)
