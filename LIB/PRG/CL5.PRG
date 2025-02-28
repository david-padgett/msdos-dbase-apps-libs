* File        : CL5.PRG
* Module      : CLIPPER
* System      : None
* Description : A method for displaying either a 1 or 2 dimensional menu
*               either vertically or horizontally.
* Modified    :

* Function    : menu
* Description : Builds and allows the user to manipulate either a one or
*               two dimensional menu.  The menu can be displayed vertically
*               or horizontally.
* Expects     : dimension      = The dimension of the menu, [1 | 2].
*               axis           = The axis of the menu, [0 | 1].
*                                   0 - The x axis.
*                                   1 - The y axis.
*               box_type       = The type of box to draw around the menu,
*                                [0 | 1 | 2].
*                                   0 - No box.
*                                   1 - Single line box.
*                                   2 - Double line box.
*               options_list   = The list of menu options that will be
*                                displayed.  This list is formatted as a
*                                string.  Each option in the list must be
*                                left-justified and padded with spaces to the
*                                right, if necessary.  All options in the
*                                list must be the same length.
*               hot_keys_list  = A list containing hot key selections, or
*                                short-cut keys, for each of the options
*                                in the list.  Each option in the list
*                                must have a short-cut key associated with
*                                it.
*               default_option = The option that will be highlighted first.
*               start_row      = The first, or top-most, row the menu be on.
*               start_column   = The first, or left-most, column the menu
*                                will be in.
*               height         = The height of the menu, in the vertical
*                                direction.
*               length         = The length of the menu, in the horizontal
*                                direction.
* Returns     : The option that was chosen, or zero if ESC was pressed.
* Modified    : 04/04/91 DWP Initial coding.
* Notes       :

function menu
   parameters dimension, axis, box_type, options_list, hot_keys_list, default_option, start_row, start_column, height, length

   private i, j, option_length, total_options, current_column, current_row, first_column, first_row, total_rows, total_columns, str, result

   * Initialize local variables.

   set cursor off
   total_options = len(hot_keys_list)
   option_length = int(len(options_list) / total_options)
   first_column = start_column
   first_row = start_row
   total_columns = iif(length <= option_length, 1, int(length / (option_length + 2) + 1))
   total_rows = iif(mod(total_options, total_columns) = 0, int(total_options / total_columns), int(total_options / total_columns) + 1)

   * Draw the box, if necessary.

   do case
      case box_type = 1
         @ start_row - 2, start_column - 2 to start_row + height + 1, start_column + length + 1
      case box_type = 2
         @ start_row - 2, start_column - 2 to start_row + height + 1, start_column + length + 1 double
   endcase

   * Clear the portion of the screen that will be occupied by the menu.

   @ start_row - 1, start_column - 1 clear to start_row + height, start_column + length

   * Display all of the options in the menu.

   i = 1
   current_column = 0
   current_row = 0

   do while i <= total_options
      @ first_row + current_row, first_column + current_column say substr(options_list, (i - 1) * option_length + 1, option_length)
      current_row = iif(dimension = 1, iif(axis = 0, current_row, current_row + 1), iif(mod(i, total_columns) = 0, current_row + 1, current_row))
      current_column = iif(dimension = 1, iif(axis = 0, current_column + option_length + 2, current_column), iif(mod(i, total_columns) = 0, 0, current_column + option_length + 2))
      i = i + 1
   enddo

   * Loop until an option has been selected or ESC has been pressed.

   i = iif(default_option > 0 .and. default_option <= total_options, default_option, 1)
   str = ''
   current_column = iif(dimension = 1, iif(axis = 0, (i - 1) * option_length, 0), 0)
   current_row = iif(dimension = 1, iif(axis = 0, 0, i - 1), 0)
   result = 0

   do while .t.

      * Display the current option and get the user input, and then normalize
      * the currently selected option.

      str = substr(options_list, (i - 1) * option_length + 1, option_length)
      @ first_row + current_row, first_column + current_column get str
      clear gets
      key = inkey(0)
      @ first_row + current_row, first_column + current_column say str
      j = i

      do case

         case key = 19  && Left arrow.

            i = iif(dimension = 1, iif(j - 1 > 0, j - 1, total_options), iif(mod(j, total_columns) = 1, iif((j + total_columns - 1) > total_options, j, j + total_columns - 1), j - 1))

            if j <> i
               current_row = iif(dimension = 1 .and. axis = 1, iif(current_row - 1 >= 0, current_row - 1, total_options - 1), current_row)
               current_column = iif((dimension = 1 .and. axis = 0) .or. dimension = 2, iif(mod(j, total_columns) = 1, (option_length + 2) * (total_columns - 1), current_column - option_length - 2), current_column)
            endif

         case key = 5   && Up arrow.

            if dimension = 1
               i = iif(j - 1 > 0, j - 1, total_options)
            else
               if j - total_columns > 0
                  i = j - total_columns
               else
                  i = iif(((total_rows - 1) * total_columns + mod(j - 1, total_columns) + 1) > total_options, j, (total_rows - 1) * total_columns + mod(j - 1, total_columns) + 1)
               endif
            endif

            if j <> i
               current_row = iif((dimension = 1 .and. axis = 1) .or. dimension = 2, iif(current_row - 1 >= 0, current_row - 1, total_rows - 1), current_row)
               current_column = iif(dimension = 1 .and. axis = 0, iif(mod(j, total_columns) = 1, (option_length + 2) * (total_columns - 1), current_column - option_length - 2), current_column)
            endif

         case key = 4   && Right arrow.

            i = iif(dimension = 1, iif(j + 1 <= total_options, j + 1, 1), iif(mod(j, total_columns) = 0, j - total_columns + 1, iif(j + 1 <= total_options, j + 1, j)))

            if j <> i
               current_row = iif(dimension = 1 .and. axis = 1, iif(current_row + 1 <= total_options - 1, current_row + 1, 0), current_row)
               current_column = iif((dimension = 1 .and. axis = 0) .or. dimension = 2, iif(mod(j, total_columns) = 0, 0, current_column + option_length + 2), current_column)
            endif

         case key = 24  && Down arrow.

            i = iif(dimension = 1, iif(j + 1 <= total_options, j + 1, 1), iif(j + total_columns <= total_options, j + total_columns, mod(j - 1, total_columns) + 1))

            if j <> i
               current_row = iif((dimension = 1 .and. axis = 1) .or. dimension = 2, iif((current_row + 1) > (total_rows - 1), 0, current_row + 1), current_row)
               current_column = iif(dimension = 1 .and. axis = 0, iif(mod(j, total_columns) = 0, 0, current_column + option_length + 2), current_column)
            endif

         case key = 27  && ESC.

            exit

         case key = 18  && PgUp.

         case key = 3   && PgDn.

         case key = 28  && F1

            do help_system with '',  0,  ''

         otherwise

            if (key <> 32 .and. upper(chr(key)) $ hot_keys_list) .or. key = 13

               result = iif(key = 13, i, at(upper(chr(key)), hot_keys_list))
               @ first_row + current_row, first_column + current_column say str
               str = substr(options_list, (result - 1) * option_length + 1, option_length)
               current_row = iif(dimension = 1, iif(axis = 0, 0, result - 1), int((result - 1) / total_columns))
               current_column = iif(dimension = 1, iif(axis = 0, (result - 1) * (option_length + 2), 0), mod(result - 1, total_columns) * (option_length + 2))
               @ first_row + current_row, first_column + current_column get str
               clear gets
               exit
            endif

      endcase
   enddo

   set cursor on

   release i, j, option_length, total_options, current_column, current_row, first_column, first_row, total_rows, total_columns, str

return (result)
