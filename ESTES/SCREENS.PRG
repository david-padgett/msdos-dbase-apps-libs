* File        : SCREENS.PRG
* Module      : SCREENS
* System      : ESTES
* Description : The screen drawing routines for the ESTES program.
* Modified    : 04/04/91 DWP Created.

* Function    : process_screen
* Description : Processes the screen specified by format.
* Expects     : format      = The format, or screen, to process.
*               access_type =
* Returns     : A value in the range [-1 .. 1].
*                  -1 = Continue processing in the reverse direction.
*                   0 = Stop processing.
*                   1 = Continue processing in the forwar direction.
* Modified    : 04/07/91 DWP Initial coding.
* Notes       :

function process_screen
   parameters format, access_type

   private result

   * Initialize global variables.

   ignore_error = .f.

   begin sequence

      * Determine which screen to display and manipulate.

      do case

         case format = 1

            result = clients_screen(access_type)

         case format = 2

            result = accounts_screen(access_type)

         case format = 3

            result = products_screen(access_type)

         case format = 4

            result = county_codes_screen(access_type)

         otherwise

            result = 0

      endcase
   end

return (result)

* Function    : clients_screen
* Description : This is the add, edit, and delete screen for the CLIENTS
*               database.
* Expects     : id = The calling procedure, ['A' | 'E' | 'D'].
*                       'A' = Called from add_rec.
*                       'E' = Called from edit_rec.
*                       'D' = Called from del_rec.
* Returns     : A value in the range [-1 .. 1].
*                  -1 = Continue processing in the reverse direction.
*                   0 = Stop processing.
*                   1 = Continue processing in the forward direction.
* Modified    : 04/04/91 DWP Initial coding.
* Notes       :

function clients_screen
   parameters access_type

   private field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9, field_10, field_10a, field_11, field_12, field_13, field_14
   private add_mode_flag, update_flag, first_pass_flag, read_flag, draw_screen_flag, draw_options_flag
   private current_row, current_selection, screen_no, screen_no, field_no, direction, key, str, result

   begin sequence

      add_mode_flag = iif(access_type = 'A', .t., .f.)

      * Update the global variables.

      ignore_err = .f.

      * Initialize the temporary field variables.

      select 1

      field_1 = iif(add_mode_flag, 0, clientcode)
      field_2 = iif(add_mode_flag, space(30), last_name)
      field_3 = iif(add_mode_flag, space(20), first_name)
      field_4 = iif(add_mode_flag, space(1), middleinit)
      field_5 = iif(add_mode_flag, space(50), address)
      field_6 = iif(add_mode_flag, space(20), city)
      field_7 = iif(add_mode_flag, space(2), state)
      field_8 = iif(add_mode_flag, 0, zip)
      field_9 = iif(add_mode_flag, 0, zip_plus_4)
      field_10 = iif(add_mode_flag, 0, countycode)
      field_10a = iif(add_mode_flag, 0, locate_record(2, 'code', @field_10, 0))
      field_11 = iif(add_mode_flag, 0, phone)
      field_12 = iif(add_mode_flag, null_date, cust_since)
      field_13 = iif(add_mode_flag, null_date, last_act)
      field_14 = iif(add_mode_flag, space(50), comments)

      * Initialize the local variables.

      result = 0
      screen_no = 1
      field_no = 1
      update_flag = .t.
      first_pass_flag = .t.
      read_flag = .f.
      draw_screen_flag = .t.

      * Loop until there are no more screens and fields to process.

      do while .t.

         * Process the screen which is currently active.

         do case

            case screen_no = 1

               * Display the screen if necessary.

               if draw_screen_flag
                  draw_screen_flag = .f.
                  do borders with access_type, 'CLIENTS Database'
                  @ 5, 7 say 'Last Name'
                  @ 6, 7 say 'First Name'
                  @ 7, 7 say 'Middle Initial'
                  @ 9, 7 say 'Address'
                  @ 10, 7 say 'City'
                  @ 11, 7 say 'State'
                  @ 12, 7 say 'Zip'
                  @ 13, 7 say 'Zip Plus 4'
                  @ 14, 7 say 'County'
                  @ 15, 7 say 'Telephone'
                  @ 17, 7 say 'Customer Since'
                  @ 19, 7 say 'Last Activity'
                  @ 21, 7 say 'Comments'
               endif

               * Determine which field to process next.

               do case

                  case field_no = 1

                     if add_mode_flag
                        field_1 = config->clientcode
                     endif

                     read_flag = .f.

                  case field_no = 2

                     @ 5, 23 get field_2 picture '@!'

                  case field_no = 3

                     @ 6, 23 get field_3 picture '@!'

                  case field_no = 4

                     @ 7, 23 get field_4 picture '@!'

                  case field_no = 5

                     @ 9, 23 get field_5 picture '@!'

                  case field_no = 6

                     @ 10, 23 get field_6 picture '@!'

                  case field_no = 7

                     @ 11, 23 get field_7 picture '@!'

                  case field_no = 8

                     @ 12, 23 get field_8 picture '99999'

                  case field_no = 9

                     @ 13, 23 get field_9 picture '9999'

                  case field_no = 10

                     select 2

                     if .not. first_pass_flag
                        result = pick_list('Available Counties', @field_10a, '', '', 0, "state+'/'+county", 3, 50, 20, 27)
                     endif

                     if .not. field_10a = 0
                        go top
                        skip field_10a - 1
                        field_10 = code
                        str = county
                     else
                        str = space(23)
                     endif

                     @ 14, 23 get str
                     clear gets
                     read_flag = .f.
                     select 1

                  case field_no = 11

                     @ 15, 23 get field_11 picture '(999) 999-9999'

                  case field_no = 12

                     @ 17, 23 get field_12

                  case field_no = 13

                     @ 19, 23 get field_13

                  case field_no = 14

                     @ 21, 23 get field_14 picture '@!'

                  otherwise

                     if first_pass_flag
                        clear gets

                        if access_type = 'D'
                           update_flag = .f.
                           exit
                        endif

                        first_pass_flag = .f.
                        field_no = 0
                     else
                        result = iif(result = 0 .or. result = 2, 2, 3)
                        read_flag = .f.
                        first_pass_flag = .t.
                     endif

               endcase

            otherwise

               result = iif(result = 0 .or. result = 2, 1, -1)
               exit

         endcase

         * Determine what action to take depending on the last key pressed.

         if read_flag

            result = read_field()

            if access_type = 'A' .and. result = 3
               result = 6
            endif
         endif

         if .not. first_pass_flag
            read_flag = .t.
         endif

         do case

            * Move to next field.

            case result = 0

               field_no = field_no + 1

            * Move to previous field.

            case result = 1

               field_no = field_no - 1

            * Move to next screen.

            case result = 2

               screen_no = screen_no + 1
               field_no = 1
               draw_screen_flag = .t.

            * Move to previous screen.

            case result = 3

               screen_no = screen_no - 1
               field_no = 1
               draw_screen_flag = .t.

            * Abort or exit, do not save.

            case result = 4

               update_flag = .f.
               result = 0
               exit

            * Exit and save.

            case result = 5

               update_flag = .t.
               result = 0
               exit

         endcase
      enddo

      if update_flag
         if add_mode_flag
            append blank
            replace clientcode with field_1
            replace config->clientcode with config->clientcode + 1
         endif

         replace last_name with field_2, first_name with field_3, middleinit with field_4, address with field_5, city with field_6, state with field_7
         replace zip with field_8, zip_plus_4 with field_9, countycode with field_10, phone with field_11, cust_since with field_12, last_act with field_13, comments with field_14
      endif
   end

   release field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9, field_10, field_10a, field_11, field_12, field_13, field_14
   release add_mode_flag, update_flag, first_pass_flag, read_flag, draw_screen_flag, draw_options_flag
   release current_row, current_selection, screen_no, screen_no, field_no, direction, key, str

return (result)

* Procedure   : accounts_screen
* Description : This is the add, edit, and delete screen for the ACCOUNTS
*               database.
* Expects     : id = The calling procedure, ['A' | 'E' | 'D'].
*                       'A' = Called from add_rec.
*                       'E' = Called from edit_rec.
*                       'D' = Called from del_rec.
* Returns     : A value in the range [-1 .. 1].
*                  -1 = Continue processing in the reverse direction.
*                   0 = Stop processing.
*                   1 = Continue processing in the forward direction.
* Modified    : 04/04/91 DWP Initial coding.
* Notes       :

function accounts_screen
   parameters access_type

   private field_1, field_2, field_2a, field_3, field_3a, field_4, field_6, field_7, field_8
   private add_mode_flag, update_flag, first_pass_flag, read_flag, draw_screen_flag, draw_options_flag
   private current_row, current_selection, screen_no, screen_no, field_no, direction, key, str, item, result

   begin sequence

      add_mode_flag = iif(access_type = 'A', .t., .f.)

      * Update the global variables.

      ignore_err = .f.

      * Initialize the temporary field variables.

      select 1
      field_1 = iif(add_mode_flag, null_date, order_date)
      field_2 = iif(add_mode_flag, 0, clientcode)
      field_2a = iif(add_mode_flag, 0, locate_record(2, 'clientcode', @field_2, 0))
      field_3 = iif(add_mode_flag, 0, product)
      field_3a = iif(add_mode_flag, 0, locate_record(3, 'product', @field_3, 0))
      field_4 = iif(add_mode_flag, 0, price)
      field_5 = iif(add_mode_flag, 0, mach_hours)
      field_6 = iif(add_mode_flag, null_date, bill_date)
      field_7 = iif(add_mode_flag, null_date, paid_date)
      field_8 = iif(add_mode_flag, space(50), comments)

      * Initialize the local variables.

      result = 0
      screen_no = 1
      field_no = 1
      update_flag = .t.
      first_pass_flag = .t.
      read_flag = .f.
      draw_screen_flag = .t.

      * Loop until there are no more screens and fields to process.

      do while .t.

         * Process the screen which is currently active.

         do case

            case screen_no = 1

               * Display the screen if necessary.

               if draw_screen_flag
                  draw_screen_flag = .f.
                  do borders with access_type, 'ACCOUNTS Database'
                  @ 5, 4 say 'Order Date'
                  @ 7, 4 say 'Client'
                  @ 9, 4 say 'Product'
                  @ 11, 4 say 'Price'
                  @ 13, 4 say 'Machine Hours'
                  @ 15, 4 say 'Customer Billed '
                  @ 17, 4 say 'Received Payment'
                  @ 19, 4 say 'Comments'
               endif

               * Determine which field to process next.

               do case

                  case field_no = 1

                     @ 5, 21 get field_1

                  case field_no = 2

                     select 2

                     if .not. first_pass_flag
                        result = pick_list('Available Clients', @field_2a, '', '', 0, "alltrim(last_name)+', '+alltrim(first_name)+' '+alltrim(middleinit)+'.'", 3, 10, 20, 59)
                     endif

                     if .not. field_2a = 0
                        go top
                        skip field_2a - 1
                        field_2 = clientcode
                        str = alltrim(last_name) + ', ' + alltrim(first_name) + ' ' + middleinit + '.'
                     else
                        str = space(55)
                     endif

                     @ 7, 21 get str
                     clear gets
                     read_flag = .f.
                     select 1

                  case field_no = 3

                     select 3

                     if .not. first_pass_flag
                        result = pick_list('Available Products', @field_3a, '', '', 0, "name", 3, 13, 20, 54)
                     endif

                     if .not. field_3a = 0
                        go top
                        skip field_3a - 1
                        field_3 = product
                        str = name
                        field_4 = iif(hard_serv .and. (month(field_1) >= 11 .or. month(field_1) < 5), price * .85, price)
                     else
                        str = space(50)
                     endif

                     @ 9, 21 get str
                     clear gets
                     read_flag = .f.
                     select 1

                  case field_no = 4

                     @ 11, 21 get field_4 picture '9999999.99'

                  case field_no = 5

                     @ 13, 21 get field_5 picture '9999999.99'

                  case field_no = 6

                     @ 15, 21 get field_6

                  case field_no = 7

                     @ 17, 21 get field_7

                  case field_no = 8

                     @ 19, 21 get field_8 picture '@!'

                  otherwise

                     if first_pass_flag
                        clear gets

                        if access_type = 'D'
                           update_flag = .f.
                           exit
                        endif

                        first_pass_flag = .f.
                        field_no = 0
                     else
                        result = iif(result = 0 .or. result = 2, 2, 3)
                        read_flag = .f.
                        first_pass_flag = .t.
                     endif

               endcase

            otherwise

               result = iif(result = 0 .or. result = 2, 1, -1)
               exit

         endcase

         * Determine what action to take depending on the last key pressed.

         if read_flag

            result = read_field()

            if access_type = 'A' .and. result = 3
               result = 6
            endif
         endif

         if .not. first_pass_flag
            read_flag = .t.
         endif

         do case

            * Move to next field.

            case result = 0

               field_no = field_no + 1

            * Move to previous field.

            case result = 1

               field_no = field_no - 1

            * Move to next screen.

            case result = 2

               screen_no = screen_no + 1
               field_no = 1
               draw_screen_flag = .t.

            * Move to previous screen.

            case result = 3

               screen_no = screen_no - 1
               field_no = 1
               draw_screen_flag = .t.

            * Abort or exit, do not save.

            case result = 4

               update_flag = .f.
               result = 0
               exit

            * Exit and save.

            case result = 5

               update_flag = .t.
               result = 0
               exit

         endcase
      enddo

      if update_flag
         if add_mode_flag
            append blank
         endif

         replace order_date with field_1, clientcode with field_2, product with field_3, price with field_4, mach_hours with field_5, bill_date with field_6, paid_date with field_7, comments with field_8
      endif
   end

   release field_1, field_2, field_2a, field_3, field_3a, field_4, field_5, field_6, field_7, field_8
   release add_mode_flag, update_flag, first_pass_flag, read_flag, draw_screen_flag, draw_options_flag
   release current_row, current_selection, screen_no, screen_no, field_no, direction, key, str

return (result)

* Procedure   : products_screen
* Description : This is the add, edit, and delete screen for the PRODUCTS
*               database.
* Expects     : id = The calling procedure, ['A' | 'E' | 'D'].
*                       'A' = Called from add_rec.
*                       'E' = Called from edit_rec.
*                       'D' = Called from del_rec.
* Returns     : A value in the range [-1 .. 1].
*                  -1 = Continue processing in the reverse direction.
*                   0 = Stop processing.
*                   1 = Continue processing in the forward direction.
* Modified    : 04/04/91 DWP Initial coding.
* Notes       :

function products_screen
   parameters access_type

   private field_1, field_2, field_3, field_4, field_5, field_6, field_8
   private add_mode_flag, update_flag, first_pass_flag, read_flag, draw_screen_flag, draw_options_flag
   private current_row, current_selection, screen_no, screen_no, field_no, direction, key, str, item, result

   begin sequence

      add_mode_flag = iif(access_type = 'A', .t., .f.)

      * Update the global variables.

      ignore_err = .f.

      * Initialize the temporary field variables.

      select 1
      field_1 = iif(add_mode_flag, 0, product)
      field_2 = iif(add_mode_flag, space(50), name)
      field_3 = iif(add_mode_flag, space(50), desc)
      field_4 = iif(add_mode_flag, space(50), model_no)
      field_5 = iif(add_mode_flag, space(50), manufactr)
      field_6 = iif(add_mode_flag, 0, price)
      field_7 = iif(add_mode_flag, .f., hard_serv)
      field_8 = iif(add_mode_flag, space(50), comments)

      * Initialize the local variables.

      result = 0
      screen_no = 1
      field_no = 1
      update_flag = .t.
      first_pass_flag = .t.
      read_flag = .f.
      draw_screen_flag = .t.

      * Loop until there are no more screens and fields to process.

      do while .t.

         * Process the screen which is currently active.

         do case

            case screen_no = 1

               * Display the screen if necessary.

               if draw_screen_flag
                  draw_screen_flag = .f.
                  do borders with access_type, 'PRODUCTS Database'
                  @ 6, 1 say 'Product Name'
                  @ 8, 1 say 'Product Description'
                  @ 10, 1 say 'Model Number'
                  @ 12, 1 say 'Manufacturer'
                  @ 14, 1 say 'Price'
                  @ 16, 1 say 'Hard Servicing Ind.'
                  @ 18, 1 say 'Comments'
               endif

               * Determine which field to process next.

               do case

                  case field_no = 1

                     if add_mode_flag
                        field_1 = config->product
                     endif

                     read_flag = .f.

                  case field_no = 2

                     @ 6, 21 get field_2 picture '@!'

                  case field_no = 3

                     @ 8, 21 get field_3 picture '@!'

                  case field_no = 4

                     @ 10, 21 get field_4 picture '@!'

                  case field_no = 5

                     @ 12, 21 get field_5 picture '@!'

                  case field_no = 6

                     @ 14, 21 get field_6 picture '9999999.99'

                  case field_no = 7

                     @ 16, 21 get field_7

                  case field_no = 8

                     @ 18, 21 get field_8 picture '@!'

                  otherwise

                     if first_pass_flag
                        clear gets

                        if access_type = 'D'
                           update_flag = .f.
                           exit
                        endif

                        first_pass_flag = .f.
                        field_no = 0
                     else
                        result = iif(result = 0 .or. result = 2, 2, 3)
                        read_flag = .f.
                        first_pass_flag = .t.
                     endif

               endcase

            otherwise

               result = iif(result = 0 .or. result = 2, 1, -1)
               exit

         endcase

         * Determine what action to take depending on the last key pressed.

         if read_flag

            result = read_field()

            if access_type = 'A' .and. result = 3
               result = 6
            endif
         endif

         if .not. first_pass_flag
            read_flag = .t.
         endif

         do case

            * Move to next field.

            case result = 0

               field_no = field_no + 1

            * Move to previous field.

            case result = 1

               field_no = field_no - 1

            * Move to next screen.

            case result = 2

               screen_no = screen_no + 1
               field_no = 1
               draw_screen_flag = .t.

            * Move to previous screen.

            case result = 3

               screen_no = screen_no - 1
               field_no = 1
               draw_screen_flag = .t.

            * Abort or exit, do not save.

            case result = 4

               update_flag = .f.
               result = 0
               exit

            * Exit and save.

            case result = 5

               update_flag = .t.
               result = 0
               exit

         endcase
      enddo

      if update_flag
         if add_mode_flag
            append blank
            replace product with field_1
            replace config->product with config->product + 1
         endif

         replace name with field_2, desc with field_3, model_no with field_4, manufactr with field_5, price with field_6, hard_serv with field_7, comments with field_8
      endif
   end

   release field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8
   release add_mode_flag, update_flag, first_pass_flag, read_flag, draw_screen_flag, draw_options_flag
   release current_row, current_selection, screen_no, screen_no, field_no, direction, key, str

return (result)

* Procedure   : county_codes_screen
* Description : This is the add, edit, and delete screen for the CCODES
*               database.
* Expects     : id = The calling procedure, ['A' | 'E' | 'D'].
*                       'A' = Called from add_rec.
*                       'E' = Called from edit_rec.
*                       'D' = Called from del_rec.
* Returns     : A value in the range [-1 .. 1].
*                  -1 = Continue processing in the reverse direction.
*                   0 = Stop processing.
*                   1 = Continue processing in the forward direction.
* Modified    : 04/04/91 DWP Initial coding.
* Notes       :

function county_codes_screen
   parameters access_type

   private field_1, field_2, field_3
   private add_mode_flag, update_flag, first_pass_flag, read_flag, draw_screen_flag, draw_options_flag
   private current_row, current_selection, screen_no, screen_no, field_no, direction, key, str, item, result

   begin sequence

      add_mode_flag = iif(access_type = 'A', .t., .f.)

      * Update the global variables.

      ignore_err = .f.

      * Initialize the temporary field variables.

      select 1
      field_1 = iif(add_mode_flag, space(2), state)
      field_2 = iif(add_mode_flag, space(20), county)
      field_3 = iif(add_mode_flag, 0, code)

      * Initialize the local variables.

      result = 0
      screen_no = 1
      field_no = 1
      update_flag = .t.
      first_pass_flag = .t.
      read_flag = .f.
      draw_screen_flag = .t.

      * Loop until there are no more screens and fields to process.

      do while .t.

         * Process the screen which is currently active.

         do case

            case screen_no = 1

               * Display the screen if necessary.

               if draw_screen_flag
                  draw_screen_flag = .f.
                  do borders with access_type, 'COUNTY CODES Database'
                  @ 8, 24 say 'State'
                  @ 10, 24 say 'County'
               endif

               * Determine which field to process next.

               do case

                  case field_no = 1

                     @ 8, 36 get field_1 picture '@!'

                  case field_no = 2

                     @ 10, 36 get field_2 picture '@!'

                  case field_no = 3

                     if add_mode_flag
                        field_3 = config->countycode
                     endif

                     read_flag = .f.

                  otherwise

                     if first_pass_flag
                        clear gets

                        if access_type = 'D'
                           update_flag = .f.
                           exit
                        endif

                        first_pass_flag = .f.
                        field_no = 0
                     else
                        result = iif(result = 0 .or. result = 2, 2, 3)
                        read_flag = .f.
                        first_pass_flag = .t.
                     endif

               endcase

            otherwise

               result = iif(result = 0 .or. result = 2, 1, -1)
               exit

         endcase

         * Determine what action to take depending on the last key pressed.

         if read_flag

            result = read_field()

            if access_type = 'A' .and. result = 3
               result = 6
            endif
         endif

         if .not. first_pass_flag
            read_flag = .t.
         endif

         do case

            * Move to next field.

            case result = 0

               field_no = field_no + 1

            * Move to previous field.

            case result = 1

               field_no = field_no - 1

            * Move to next screen.

            case result = 2

               screen_no = screen_no + 1
               field_no = 1
               draw_screen_flag = .t.

            * Move to previous screen.

            case result = 3

               screen_no = screen_no - 1
               field_no = 1
               draw_screen_flag = .t.

            * Abort or exit, do not save.

            case result = 4

               update_flag = .f.
               result = 0
               exit

            * Exit and save.

            case result = 5

               update_flag = .t.
               result = 0
               exit

         endcase
      enddo

      if update_flag
         if add_mode_flag
            append blank
            replace code with field_3
            replace config->countycode with config->countycode + 1
         endif

         replace state with field_1, county with field_2
      endif
   end

   release field_1, field_2, field_3
   release add_mode_flag, update_flag, first_pass_flag, read_flag, draw_screen_flag, draw_options_flag
   release current_row, current_selection, screen_no, screen_no, field_no, direction, key, str

return (result)
