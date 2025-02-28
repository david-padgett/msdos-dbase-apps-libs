* File        : PROC.PRG
* Module      : ESTES
* System      : ESTES
* Description : The procedure file for the ESTES program.
* Modified    : 04/04/91 DWP Created.

* Procedure   : initialize_system
* Description : Initializes the DBASE/Clipper environment.
* Expects     : Nothing.
* Returns     : Nothing.
* Modified    : 04/04/91 DWP Initial coding.
* Notes       :

procedure init_sys

   begin sequence

      close all
      set bell off
      set color to
      set deleted on
      set escape on
      set exclusive off
      set menu off
      set safety off
      set scoreboard off
      set status off
      set talk off
      set unique off

      readexit(.t.)

      public esc_flag, print_flag
      public null_cdate, null_date
      public program, system
      public printcode1, printcode2, printcode3, printcode4, print_dev, out_file, out_dev
      public loc_fltr, ndx_fltr
      public scrn_no, key, move
      public help_type

      null_cdate = '  /  /  '
      null_date = ctod(null_cdate)
      program = 'ESTES Manufacturing Customer Log V1.3a'
      system = 'est'
      printcode1 = chr(27) + '(s16.7H'
      printcode2 = printcode1 + chr(27) + '&l1O'
      printcode3 = ''
      printcode4 = ''
      print_dev = 'LPT1'
      out_file = ''
      out_dev = ''
      store '' to loc_fltr, ndx_fltr
      help_type = ' '

      store 0 to scrn_no, key, move

      set key 28 to help_system
   end

return

* Procedure   : help_system
* Description : Displays the context sensitive help system screen.
* Expects     : p = A required parameter, but not used.
*               l = A required parameter, but not used.
*               v = A required parameter, but not used.
* Returns     : Nothing.
* Modified    : 04/10/91 DWP Initial coding.
* Notes       :

procedure help_system
   parameters p, l, v

   private screen, read_flag

   begin sequence

      if .not. help_type = 'H'

         screen = savescreen(0, 0, 25, 80)
         do borders with 'H', 'Help System'
         @ 4, 0 say ''
         read_flag = .t.

         do case
            case help_type = ' ' .or. help_type = 'M'

               text
                                This is a Menu.

        Menus allow you to quickly and easily navigate this system.  A menu
   consists of one or more selections, which may be displayed either
   vertically or horizontally.  Vertical, or up and down menus, display their
   information in a single column, while horizontal, or side to side menus,
   display their information in a single row.  Menus consist of a list of
   choices.  The choice, or option, that is currently selected appears
   differently on the screen than do the remaining options that are not
   currently selected.  The keys available for use while navigating a menu
   are as follows:

      F1    - Help
      ENTER - Invoke the currently selected option.
          - The arrow keys allow you to move the cursor so that a different
              option may become the currently selected option.
               endtext

            case help_type = 'A'

               text
                        This is the Add Records Process.

        The Add Records Process allows you to add new information to the
   information already stored in the system.  The keys available during the
   Add Records Process are as follows:

      ENTER,  - Accept current entry, proceed to next entry.
              - Accept current entry, proceed to previous entry.
      PgDn     - Accept current entry, proceed to next screen.
      Home     - Move to the beginning of the current entry.
      End      - Move to the end of the current entry.
               endtext
               ? space(5), chr(27), chr(26), space(4), '- Move cursor backwards or forwards in current entry.'
               text
      BS       - Backspace or delete character to immediate left.
      DEL      - Delete character underneath the cursor.
      CTRL-W   - Save current entry and go to previous screen.
      ESC      - Abort current entry and go to previous screen.
      F10      - Display the Status window.
               endtext

            case help_type = 'E'

               text
                       This is the Edit Records Process.

        The Edit Records Process allows you to change or modify information
   already stored in your system.  The keys available during the Edit Records
   Process are as follows:

      ENTER,  - Accept current entry, proceed to next entry.
              - Accept current entry, proceed to previous field.
      PgDn     - Accept current entry, proceed to next screen.
      PgUp     - Accept current entry, proceed to previous screen.
      Home     - Move to the beginning of the current entry.
      End      - Move to the end of the current entry.
               endtext
               ? space(5), chr(27), chr(26), space(4), '- Move cursor backwards or forwards in current entry.'
               text
      BS       - Backspace or delete character to immediate left.
      DEL      - Delete character underneath the cursor.
      CTRL-W   - Save current entry and go to previous screen.
      ESC      - Abort current entry and go to previous screen.
      F10      - Display the Status window.
               endtext

            case help_type = 'D'

               text
                      This is the Delete Records Process.

        The Delete Records Process allows you to remove information that is
   stored in your system.  The keys available during the Delete Records
   Process are as follows:

      F10      - Display the Status window.

      Ok to Delete(Y/N/Q) :

         Y - Delete the screen, proceed to the next scren.
         N - Do not delete the screen, proceed to the next screen.
         Q - Quit, stop deleting screens.

      Ok to Pack(Y/N) :

         Y - Permanently remove deleted screens from system.
         N - Do not permanently remove deleted screens from system.
               endtext

            case help_type = 'Q'

               text
                       This is the Define Query Process.

        The Define Query Process allows you to define a query that allows
   access to only certain entries in your system.  The questions asked will
   vary depending on the database currently in use.  The keys available
   during the Define Query Process are as follows:

      ENTER,      - Accept current entry, proceed to next entry.
                  - Accept current entry, proceed to prev. entry.
      PgDn, CTRL-W - Accept current query and continue.
      Home         - Move to the beginning of the current entry.
      End          - Move to the end of the current entry.
               endtext
               ? space(5), chr(27), chr(26), space(8), '- Move cursor backwards or forwards.'
               text
      BS           - Backspace or delete char. to immediate left.
      DEL          - Delete character underneath the cursor.
      CTRL-W       - Accept current query and continue.
      ESC          - Abort, return to previous screen.
               endtext

            case help_type = 'P'

               text
                              This is a Pick List.

        A Pick List is tool used for selecting one piece of information from
   a large list of information that is currently in your system.  The keys
   available for use while navigating a Pick List are as follows:

      ENTER     - Select the current item, return to the prev. screen.
              - Modify or change the currently selected item.
      PgUp      - Display previous screen of items in the Pick List.
      PgDn      - Display next screen of items in the Pick List.
      Home      - Move to the beginning of the Pick List.
      End       - Move to the end of the Pick List.
               endtext
               ? space(5), chr(27), chr(26), space(6), '- Select current item, return to the previous screen and'
               text
                  place cursor on the previous/next entry.
      TAB       - Make no selection, return to prev. screen and place cursor on
                  next entry.
      Shift-TAB - Make no selection, return to prev. screen and place cursor on
                  previous entry.
               endtext

           otherwise

              read_flag = .f.

         endcase

         if read_flag
            inkey(0)
         endif

         restscreen(0, 0, 25, 80, screen)
      endif
   end

   release screen

return

* Function    : open_database
* Description : Opens a database file in the specified access mode.
* Expects     : access     = Type of access, [1 | 2].
*                               1 = Exclusive.
*                               2 = Shared.
*               dbf_file   = The name of the database file to open.
*               ndx_file   = The name of the index file, or, use index file flag.
*               alias_name = Alias name for the database file.
*               work_area  = The work area to use.
* Returns     : Nothing.
* Modified    : 04/04/91 DWP Initial coding.
* Notes       :

function open_database
   parameters access, dbf_file, ndx_file, alias_name, work_area

   private ndx_flag, str, result

   begin sequence

      * Initialize the local variables.

      result = 0

      * Make sure there is no database file in use in the specified work
      * area.

      str = chr(asc('a') - 1 + work_area)

      select &str
      use

      * Determine if the specified database file exists.

      dbf_file = iif(at('.', dbf_file) = 0, alltrim(dbf_file) + '.dbf', dbf_file)

      if .not. file(dbf_file)

         * The specified database does not exist.

         result = 1
      else

         * Validate the alias name, if none was specified, set the alias
         * name to the name of the specified database file.

         alias_name = iif(len(alias_name) = 0, left(dbf_file, at('.', dbf_file) - 1), alias_name)
         alias_name = iif(at(':', alias_name) > 0, substr(alias_name, at(':', alias_name) + 1, 255), alias_name)

         do while at('\', alias_name) > 0
            alias_name = substr(alias_name, at('\', alias_name) + 1, 255)
         enddo

         * If ndx_file is a string, then verify the existence of the
         * specified index file, otherwise, do not use an index file.

         ndx_flag = type('ndx_file') = 'C'

         if ndx_flag

            * Verify the existence of the specified index file.

            if len(ndx_file) = 0

               * No index file was specified.  Determine if there is an index
               * file with the same name as the database file, if so, it will
               * be used.

               if file(left(dbf_file, at('.', dbf_file) - 1) + '.ntx')
                  ndx_file = left(dbf_file, at('.', dbf_file) - 1) + '.ntx'
               endif
            else

               * An index file was specified.  Determine if the specified
               * index file exists, if so, it will be used.

               ndx_file = iif(at('.', ndx_file) = 0, ltrim(alltrim(ndx_file)) + '.ntx', ndx_file)
               result = iif(file(ndx_file), 0, 2)
            endif
         endif

         * If no errors have occurred, then continue, otherwise exit.

         if result = 0

            * Loop until either the specified files are in use, or until
            * the user aborts.

            do while .t.

               * Initialize the global variable that contains the value of
               * the last error that occurred.

               err = 0

               do case

                  * Exclusive use of the database file was requested.

                  case access = 1

                     use &dbf_file alias &alias_name exclusive

                  * Non-exclusive, or shared use of the database file was
                  * specified.

                  case access = 2

                     use &dbf_file alias &alias_name

                  otherwise

                     result = 3

               endcase

               * Update the return code if an error occurred.

               if .not. (err = 0 .and. result = 0)
                  result = 3
               else

                  * No errors occurred while opening the database.  Attempt
                  * to open the associated index file, if one was specified.

                  if ndx_flag

                     set index to &ndx_file

                     if .not. err = 0
                        result = 2
                     endif
                  endif
               endif

               * Exit if no errors occurred.

               if err = 0
                  exit
               endif

            enddo
         endif
      endif
   end

   release ndx_flag

return (result)

* Procedure   : get_file
* Description : Reads in a list of database files, specified in a .DIR file.
* Expects     : dbffile   = The dbf file that was selected.
*               ndxfile   = The ndx file associated with the dbf file.
*               format_1  = Specifies the file list.
*               format_2  = Not used.
*               aliasname = The alias of the dbf file.
*               workarea  = The work area to open selected file in.
* Returns     : Nothing.
* Modified    : 04/04/91 DWP Initial coding.
* Notes       :

procedure get_file
   parameters dbf_file, ndx_file, format_1, format_2, alias_name, work_area

   private i, option, str

   begin sequence

      str = system + right('000' + ltrim(str(format_1, 3, 0)), 3) + '.dir'

      if open_database(1, str, 0, 'filelist', 10) = 0

         i = 0
         str = ''

         do while .not. eof()

            str = str + filelist->dbf_file
            i = i + 1
            skip
         enddo

         use
         option = menu(2, 0, 1, str, space(i), 1, 5, 10, iif(mod(i, 4) = 0, int(i / 4), int(i / 4) + 1), 37)

         if option <> 0
            dbf_file = ltrim(rtrim(substr(str, (option - 1) * 8 + 1, 8))) + '.dbf'
            open_database(1, dbf_file, ndx_file, alias_name, work_area)
         endif
      endif
   end

   release i, option, str

return

* Procedure   : borders
* Description : Draws the screen border.
*               screens.
* Expects     : type        = The calling function type, ['A' | 'E' | 'D' |
*                             'O'].
*               description = A user-defined description that will be placed
*                             on line 3 of the screen.
* Returns     : Nothing.
* Modified    : 04/04/91 DWP Initial coding.
* Notes       :

procedure borders
   parameters type, description

   private str

   begin sequence

      * Clear the screen and draw the title and the horizontal lines.

      clear
      @ 1, 0 to 1, 79
      @ 23, 0 to 23, 79
      @ 0, int((79 - len(program)) / 2) say program

      * Build the sub-title/description text.

      do case
         case type = 'A'
            str = 'Adding to '
         case type = 'E'
            str = 'Editing '
         case type = 'D'
            str = 'Deleting from '
         otherwise
            str = ''
      endcase

      str = str + description
      @ 3, (79 - len(str)) / 2 say str
      do display_function_key with type
   end

   release str

return

* Procedure   : display_function_keys
* Description : Displays the function keys at the bottom of the screen.
* Expects     : type = The type of activity currently in progress, [' ' |
*                      'M' | 'A' | 'E' | 'D' | 'F' | 'P'].
*                         ' ' - Main menu is active.
*                         'M' - A menu other than the main menu is active.
*                         'A' - An add record(s) screen is active.
*                         'E' - An edit record(s) screen is active.
*                         'D' - A delete record(s) screen is active.
*                         'Q' - A set query screen is active.
*                         'R' - A report is being generated.
*                         'P' - A pick list is active.
* Returns     : Nothing.
* Modified    : 04/10/91 DWP Initial coding.
* Notes       :

procedure display_function_keys
   parameters access_type

   begin sequence

      @ 24, 0 clear to 24, 79
      @ 24, 0 say 'F1-Help'

      do case

         case access_type = 'M'

            @ 24, 10 say '-Move Cursor'
            @ 24, 27 say 'ENTER-Select Option'
            @ 24, 61 say 'ESC-Previous Screen'

         case access_type = 'A'

            @ 24, 27 say 'PgDn-New Entry'
            @ 24, 43 say 'CTRL W-Save/Exit'
            @ 24, 66 say 'ESC-Abort/Exit'

         case access_type = 'E'

            @ 24, 10 say 'PgUp-Prev Entry'
            @ 24, 28 say 'PgDn-Next Entry'
            @ 24, 46 say 'CTRL W-Save/Exit'
            @ 24, 66 say 'ESC-Abort/Exit'

         case access_type = 'D'

         case access_type = 'Q'

            @ 24, 10 say 'CTRL W-Accept'
            @ 24, 27 say 'PgDn-Accept'
            @ 24, 61 say 'ESC-Bypass/Continue'

         case access_type = 'R'

            @ 24, 65 say 'ESC-Stop Report'

         case access_type = 'P'

            @ 24, 10 say 'PgUp-Prev Screen'
            @ 24, 27 say 'PgDn-Next Screen'
            @ 24, 43 say 'ENTER-Accept'
            @ 24, 56 say '-Move'
            @ 24, 66 say 'ESC-Abort/Exit'

         case access_type = 'H'

            @ 24, 0 say 'ENTER-Continue'

      endcase
   end

return

* Procedure   : add_menu
* Description : The add records menu.
* Expects     : Nothing.
* Returns     : Nothing.
* Modified    : 04/04/91 DWP Initial coding.
* Notes       :

procedure add_menu

   private option, current_help

   begin sequence

      option = 1
      prev_help = help_type
      help_type = 'M'
      set key -9 to key_f10

      if iscolor()
         set color to g+/n, w+/g
      endif

      do while .t.

         ignore_err = .f.
         do borders with 'M', 'Add Records Menu'
         option = menu(1, 1, 0, '1 - Clients                 2 - Accounts                3 - Products                4 - County Codes            Q - Quit/Return To Main Menu', '1234Q', option, 8, 25, 5, 28)

         do case

            case option = 0 .or. option = 5

               exit

            case option = 1

               if open_database(1, 'ccodes', 'ccodes', '', 2) = 0 .and. open_database(1, 'config', '', 'config', 3) = 0
                  do add_rec with 'clients', 'clients', 'last_name+first_name+middleinit', 1, 1, '', 1
               endif

               select 2
               use
               select 3
               use

            case option = 2

               if open_database(1, 'clients', 'clients', '', 2) = 0 .and. open_database(1, 'products', 'products', '', 3) = 0
                  do add_rec with 'accounts', 'accounts', 'clientcode', 2, 1, '', 1
               endif

               select 2
               use
               select 3
               use

            case option = 3

               if open_database(1, 'config', '', 'config', 2) = 0
                  do add_rec with 'products', 'products', 'name', 3, 1, '', 1
               endif

               select 2
               use

            case option = 4

               if open_database(1, 'config', '', 'config', 2) = 0
                  do add_rec with 'ccodes', 'ccodes', 'county', 4, 1, '', 1
               endif

               select 2
               use

         endcase
      enddo

      help_type = prev_help
      set key -9 to
   end

   release option, prev_help
return

* Procedure   : add_rec
* Description : Adds records to the specified dbf file.  Updates the ndx file
*               if one is specified.
* Expects     : dbf_file   = The name of the dbf file to add records to.  If
*                            it is not specified, the appropriate .DIR file
*                            will be searched for file names.  If the .DIR
*                            file doesn't exist, no further action is taken.
*               ndx_file   = The name of the ndx file to use with the dbf
*                            file.  If no ndx file is specified, a search is
*                            performed for an ndx file with the same name as
*                            the dbf file.  If the ndx file is found, it is
*                            used, otherwise, no ndx file is maintained.
*               ndx_arg    = The index key phrase.
*               format_1   = The format the dbf file is in.  This specifies
*                            what .DIR file to search, the type of dbf file
*                            in use, and the screen to use while adding.
*               format_2   = Used to distinguish different formats for the
*                            same file.
*               alias_name = The alias of the dbf file in use.
*               work_area  = The work area of the file.  Area 10 is reserved.
* Returns     : Nothing.
* Modified    : 04/04/91 DWP Initial coding.
* Notes       :

procedure add_rec
   parameters dbf_file, ndx_file, ndx_arg, format_1, format_2, alias_name, work_area

   private prev_help

   begin sequence

      prev_help = help_type
      ignore_err = .f.
      help_type = 'A'

      if open_database(1, dbf_file, ndx_file, alias_name, work_area) = 0

         do while process_screen(format_1, 'A') = 1
         enddo

         if len(ndx_file) > 0
            reindex
         endif

      endif

      use
      help_type = prev_help
   end

   release prev_help

return

* Procedure   : query_fields
* Description : Sets the locate and index seek filters.
* Expects     : format_1 = The format of the database file in use.
*               format_2 = The sub-format of the databae file in use.
* Returns     : Nothing.
* Modified    : 04/04/91 DWP Initial coding.
* Notes       :

procedure query_fields
   parameters format_1, format_2

   private field_1, field_2, field_2a, field_3, field_3a, field_4, field_5, field_5a
   private screen_no, field_no, loc_expr, set_filter_flag, loc_fltr_flag, draw_screen_flag, first_pass_flag, read_flag, str, prev_help, result

   begin sequence

      prev_help = help_type
      ignore_err = .f.
      help_type = 'Q'

      * Initialize the local variables.

      store .f. to loc_fltr_flag, read_flag
      loc_expr = ''
      store 1 to screen_no, field_no
      store .t. to draw_screen_flag, first_pass_flag, set_filter_flag
      result = 0

      * Draw the query window.

      @ 10, 5 to 20, 73 double
      @ 11, 6 clear to 19, 72
      @ 12, 28 say 'Enter Query (Optional)'
      do display_function_key with 'Q'

      do while .t.

         do case

            case format_1 = 1

               do case

                  case screen_no = 1

                     if draw_screen_flag
                        draw_screen_flag = .f.
                        field_1 = space(30)
                        field_2 = space(20)
                        field_3 = space(2)
                        store 0 to field_4, field_5, field_5a
                        @ 14, 16 say 'Last Name'
                        @ 15, 16 say 'City'
                        @ 16, 16 say 'State'
                        @ 17, 16 say '5 Digit Zip Code'
                        @ 18, 16 say 'County'
                     endif

                     do case

                        case field_no = 1

                           @ 14, 33 get field_1 picture '@!'

                        case field_no = 2

                           @ 15, 33 get field_2 picture '@!'

                        case field_no = 3

                           @ 16, 33 get field_3 picture '@!'

                        case field_no = 4

                           @ 17, 33 get field_4 picture '99999'

                        case field_no = 5

                           select 2

                           if .not. first_pass_flag
                              result = pick_list('Available Counties', @field_5a, '', '', 0, "state+'/'+county", 3, 50, 20, 27)
                           endif

                           if .not. field_5a = 0
                              go top
                              skip field_5a - 1
                              field_5 = code
                              str = county
                           else
                              str = space(23)
                           endif

                           @ 18, 33 get str
                           clear gets
                           read_flag = .f.
                           select 1

                        otherwise

                           if first_pass_flag
                              clear gets
                              first_pass_flag = .f.
                              field_no = 0
                           else
                              exit
                           endif
                     endcase

                  otherwise

                     exit

               endcase

            case format_1 = 2

               do case

                  case screen_no = 1

                     if draw_screen_flag
                        draw_screen_flag = .f.
                        store 0 to field_2, field_2a, field_3, field_3a
                        store ctod(null_cdate) to field_1, field_4, field_5
                        @ 14, 7 say 'Order Date'
                        @ 15, 7 say 'Client'
                        @ 16, 7 say 'Product'
                        @ 17, 7 say 'Bill Date'
                        @ 18, 7 say 'Paid Date'
                     endif

                     do case

                        case field_no = 1

                           @ 14, 17 get field_1

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

                           @ 15, 17 get str
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
                           else
                              str = space(50)
                           endif

                           @ 16, 17 get str
                           clear gets
                           read_flag = .f.
                           select 1

                        case field_no = 4

                           @ 17, 17 get field_4

                        case field_no = 5

                           @ 18, 17 get field_5

                        otherwise

                           if first_pass_flag
                              clear gets
                              first_pass_flag = .f.
                              field_no = 0
                           else
                              exit
                           endif

                     endcase

                  otherwise

                     exit

               endcase


            case format_1 = 3

               do case

                  case screen_no = 1

                     if draw_screen_flag
                        draw_screen_flag = .f.
                        field_1 = space(50)
                        field_2 = space(50)
                        @ 14, 8 say 'Product Name'
                        @ 15, 8 say 'Manufacturer'
                     endif

                     do case

                        case field_no = 1

                           @ 14, 21 get field_1 picture '@!'

                        case field_no = 2

                           @ 15, 21 get field_2 picture '@!'

                        otherwise

                           if first_pass_flag
                              clear gets
                              first_pass_flag = .f.
                              field_no = 0
                           else
                              exit
                           endif

                     endcase

                  otherwise

                     exit

               endcase

            case format_1 = 4

               do case

                  case screen_no = 1

                     if draw_screen_flag
                        draw_screen_flag = .f.
                        field_1 = space(20)
                        @ 14, 26 say 'County'
                     endif

                     do case

                        case field_no = 1

                           @ 14, 33 get field_1 picture '@!'

                        otherwise

                           if first_pass_flag
                              clear gets
                              first_pass_flag = .f.
                              field_no = 0
                           else
                              exit
                           endif

                     endcase

                  otherwise

                     exit

               endcase

            otherwise

               set_filter_flag = .f.
               exit

         endcase

         * Accept input from the user, if necessary.

         if read_flag
            result = read_field('A')
         else
            if .not. first_pass_flag
               read_flag = .t.
            endif
         endif

         do case

            case result = 0

               field_no = field_no + 1

            case result = 1

               field_no = field_no - 1

            case result = 2

               screen_no = screen_no + 1
               field_no = 1
               draw_screen_flag = .t.

            case result = 3

               screen_no = screen_no - 1
               field_no = 1
               draw_screen_flag = .t.

            case result = 4

               set_filter_flag = .f.
               exit

            case result = 5

               set_filter_flag = .t.
               exit

         endcase
      enddo

      do case

         case format_1 = 1

            loc_fltr = 'clientcode <> 0'

            if set_filter_flag

               if field_1 <> space(30)
                  loc_fltr = 'last_name'
                  loc_expr = field_1
                  loc_fltr_flag = .t.
               endif

               if field_2 <> space(20)
                  loc_fltr = iif(loc_fltr_flag, loc_fltr + '+', '') + 'city'
                  loc_expr = loc_expr + field_2
                  loc_fltr_flag = .t.
               endif

               if field_3 <> space(2)
                  loc_fltr = iif(loc_fltr_flag, loc_fltr + '+', '') + 'state'
                  loc_expr = loc_expr + field_3
                  loc_fltr_flag = .t.
               endif

               if field_4 <> 0
                  loc_fltr = iif(loc_fltr_flag, loc_fltr + '+', '') + 'alltrim(str(zip))'
                  loc_expr = loc_expr + alltrim(str(field_4))
                  loc_fltr_flag = .t.
               endif

               if field_5 <> 0
                  loc_fltr = iif(loc_fltr_flag, loc_fltr + '+','') + 'alltrim(str(countycode))'
                  loc_expr = loc_expr + alltrim(str(field_5))
                  loc_fltr_flag = .t.
               endif
            endif

            ndx_fltr = ''

         case format_1 = 2

            loc_fltr = 'clientcode <> 0'

            if set_filter_flag

               if field_1 <> null_date
                  loc_fltr = 'dtoc(order_date)'
                  loc_expr = dtoc(field_1)
                  loc_fltr_flag = .t.
               endif

               if field_2 <> 0
                  loc_fltr = iif(loc_fltr_flag, loc_fltr + '+', '') + 'alltrim(str(clientcode))'
                  loc_expr = loc_expr + alltrim(str(field_2))
                  loc_fltr_flag = .t.
               endif

               if field_3 <> 0
                  loc_fltr = iif(loc_fltr_flag, loc_fltr + '+', '') + 'alltrim(str(product))'
                  loc_expr = loc_expr + alltrim(str(field_3))
                  loc_fltr_flag = .t.
               endif

               if field_4 <> null_date
                  loc_fltr = iif(loc_fltr_flag, loc_fltr + '+', '') + 'dtoc(bill_date)'
                  loc_expr = loc_expr + dtoc(field_4)
                  loc_fltr_flag = .t.
               endif

               if field_5 <> null_date
                  loc_fltr = iif(loc_fltr_flag, loc_fltr + '+', '') + 'dtoc(paid_date)'
                  loc_expr = loc_expr + dtoc(field_5)
                  loc_fltr_flag = .t.
               endif
            endif

            ndx_fltr = ''

         case format_1 = 3

            loc_fltr = 'product <> 0'

            if set_filter_flag

               if field_1 <> space(50)
                  loc_fltr = 'name'
                  loc_expr = field_1
                  loc_fltr_flag = .t.
               endif

               if field_2 <> space(50)
                  loc_fltr = iif(loc_fltr_flag, loc_fltr + '+', '') + 'manufactr'
                  loc_expr = loc_expr + field_2
                  loc_fltr_flag = .t.
               endif
            endif

            ndx_fltr = ''

         case format_1 = 4

            loc_fltr = 'code <> 0'

            if set_filter_flag

               if field_1 <> space(20)
                  loc_fltr = 'county'
                  loc_expr = field_1
                  loc_fltr_flag = .t.
               endif
            endif

            ndx_fltr = ''

      endcase

      if loc_fltr_flag
         loc_fltr = loc_fltr + "='" + loc_expr + "'"
      endif

      set filter to &loc_fltr
      help_type = prev_help
   end

   release field_1, field_2, field_2a, field_3, field_3a, field_4, field_5, field_5a
   release screen_no, field_no, loc_expr, loc_fltr_flag, draw_screen_flag, first_pass_flag, read_flag, str, prev_help, result

return

* Procedure   : edit_menu
* Description : The edit records menu.
* Expects     : Nothing.
* Returns     : Nothing.
* Modified    : 04/04/91 DWP Initial coding.
* Notes       :

procedure edit_menu

   private option, prev_help

   begin sequence

      option = 1
      prev_help = help_type
      help_type = 'M'
      set key -9 to key_f10

      if iscolor()
         set color to gr+/n, w+/gr
      endif

      do while .t.

         ignore_err = .f.
         do borders with 'M', 'Edit Records Menu'
         option = menu(1, 1, 0, '1 - Clients                 2 - Accounts                3 - Products                4 - County Codes            Q - Quit/Return To Main Menu', '1234Q', option, 8, 25, 5, 28)

         do case

            case option = 0 .or. option = 5

               exit

            case option = 1

            if open_database(1, 'ccodes', 'ccodes', '', 2) = 0
               do edit_rec with 'clients', 'clients', 1, 1, '', 1
            endif

            select 2
            use

            case option = 2

               if open_database(1, 'clients', 'clients', '', 2) = 0 .and. open_database(1, 'products', 'products', '', 3) = 0
                  do edit_rec with 'accounts', 'accounts', 2, 1, '', 1
               endif

               select 2
               use
               select 3
               use

            case option = 3

               do edit_rec with 'products', 'products', 3, 1, '', 1

            case option = 4

               do edit_rec with 'ccodes', 'ccodes', 4, 1, '', 1

         endcase
      enddo

      help_type = prev_help
      set key -9 to
   end

   release option, prev_help
return

* Procedure   : edit_rec
* Description : Edits records in the specified database file.  The index
*               files associated with the database are not updated.
* Expects     : dbf_file   = The database file to edit.
*               ndx_file   = The index file to use with the database file.
*               format_1   = The format of the database file.
*               format_2   = The sub-format of the database file.
*               alias_name = The alias name of the database file.
*               work_area  = The work area to use.
* Returns     : Nothing.
* Modified    : 04/04/91 DWP Initial coding.
* Notes       :

procedure edit_rec
   parameters dbf_file, ndx_file, format_1, format_2, alias_name, work_area

   private direction, prev_help

   begin sequence

      prev_help = help_type
      ignore_err = .f.
      help_type = 'E'

      if open_database(1, dbf_file, ndx_file, alias_name, work_area) = 0

         do query_fields with format_1, format_2

         if len(ndx_file) > 0 .and. len(ndx_fltr) > 0
            seek ndx_fltr
         else
            locate for &loc_fltr
         endif

         if found()

            do while .t.

               direction = process_screen(format_1, 'E')

               if direction = 0
                  exit
               endif

               if .not. (bof() .and. direction = -1) .and. .not. (eof() .and. direction = 1)

                  skip direction

                  if eof()
                     skip -1
                  endif
               endif
            enddo
         endif
      endif

      use

      help_type = prev_help
   end

   release direction, prev_help

return

* Procedure   : del_menu
* Description : The delete records menu.
* Expects     : Nothing.
* Returns     : Nothing.
* Modified    : 04/04/91 DWP Initial coding.
* Notes       :

procedure del_menu

   private option, prev_help

   begin sequence

      option = 1
      prev_help = help_type
      help_type = 'M'
      set key -9 to key_f10

      if iscolor()
         set color to r+/n, w+/r
      endif

      do while .t.

         ignore_err = .f.
         do borders with 'M', 'Delete Records Menu'
         option = menu(1, 1, 0, '1 - Clients                 2 - Accounts                3 - Products                4 - County Codes            Q - Quit/Return To Main Menu', '1234Q', option, 8, 25, 5, 28)

         do case

            case option = 0 .or. option = 5

               exit

            case option = 1

               if open_database(1, 'ccodes', 'ccodes', '', 2) = 0
                  do del_rec with 'clients', 'clients', 1, 1, '', 1
               endif

               select 2
               use

            case option = 2

               if open_database(1, 'clients', 'clients', '', 2) = 0 .and. open_database(1, 'products', 'products', '', 3) = 0
                  do del_rec with 'accounts', 'accounts', 2, 1, '', 1
               endif

               select 2
               use
               select 3
               use

            case option = 3

               do del_rec with 'products', 'products', 3, 1, '', 1

            case option = 4

               do del_rec with 'ccodes', 'ccodes', 4, 1, '', 1

         endcase
      enddo

      help_type = prev_help
      set key -9 to
   end

   release option, prev_help
return

* Procedure   : del_rec
* Description : Deletes records from the specified database file.
* Expects     : dbf_file   = The database file to delete records from.
*               ndx_file   = The index file associated with the dbf file.
*               format_1   = The format of the databse file.
*               format_2   = The sub-format of the database file.
*               alias_name = The alias name of the database file.
*               work_area  = The work area to use while deleting records.
* Returns     : Nothing.
* Modified    : 04/04/91 DWP Initial coding.
* Notes       :

procedure del_rec
   parameters dbf_file, ndx_file, format_1, format_2, alias_name, work_area

   private str, prev_help

   begin sequence

      prev_help = help_type
      ignore_err = .f.
      help_type = 'D'

      if open_database(1, dbf_file, ndx_file, alias_name, work_area) = 0

         do query_fields with format_1, format_2

         if len(ndx_file) > 0 .and. len(ndx_fltr) > 0
            seek ndx_fltr
         else
            locate for &loc_fltr
         endif

         if found()
            do while .not. eof()

               process_screen(format_1, 'D')

               if iscolor()
                  set color to w+/r,n/w+
               endif

               @ 11, 27 to 15, 52 double
               @ 12, 28 clear to 14, 51
               str = ' '
               @ 13, 29 say 'Ok to DELETE(Y/N/Q):'

               do while .not. str $ 'YNQ'
                  @ 13, 50 get str picture '!'
                  read
               enddo

               if iscolor()
                  set color to r+/n, w+/r
               endif

               do case

                  case str = 'Y'

                     delete
                     skip

                  case str = 'N'

                     skip

                  case str = 'Q'

                     exit

               endcase
            enddo

            if iscolor()
               set color to w+/r,n/w+
            endif

            @ 12, 28 clear to 14, 51
            @ 13, 31 say 'Ok to PACK(Y/N): '
            str = ' '

            do while .not. str $ 'YN'
               @ 13, 49 get str picture '!'
               read
            enddo

            if str = 'Y' .and. open_database(1, dbf_file, ndx_file, alias_name, work_area) = 0
               @ 11, 27 to 15, 52 double
               @ 12, 28 clear to 14, 51
               @ 13, 34 say 'Please Wait...'
               pack
               reindex
               use
            endif

            if iscolor()
               set color to r+/n, w+/r
            endif
         endif
      endif

      help_type = prev_help
   end

   release str, prev_help

return

* Procudure   : util_menu
* Description : The utilities menu.
* Expects     : Nothing.
* Returns     : Nothing.
* Modified    : 04/04/91 DWP Initial coding.
* Notes       :

procedure util_menu

   private option, prev_help
   private s1, s2, s3, s4, s5, t1, t2, t3, t4, t5, l1, l2

   begin sequence

      prev_help = help_type
      help_type = 'M'

      option = 1
      set color to

      do while .t.

	 ignore_err = .f.
	 do borders with 'M', 'Utilities Menu'
	 option = menu(1, 1, 0, '1 - Index Database Files    2 - Sort Database Files     3 - Backup Database Files   Q - Quit/Return To Main Menu', '123Q', option, 8, 23, 4, 28)

	 begin sequence

	    do case

	       case option = 0 .or. option = 4

		  exit

	       case option = 1 .or. option = 2 .or. option = 3

		  if open_database(1, 'estes.dir', '', 'filelist', 10) = 0

		     t1 = 0
		     s1 = ''

		     do while .not. eof()

			t1 = t1 + 1
			s1 = s1 + '  ' + filelist->dbf_file
			skip

		     enddo

		     t2 = 1
		     @ 3, 5 to 9 + t1, 29
		     @ 4, 6 clear to 8 + t1, 28
		     @ 4, 7 say 'Use Arrow Keys/ENTER'
		     @ 5, 10 say 'To Select Files'
		     @ 8 + t1, 8 say 'Press ESC to Start'

		     do while t2 > 0

			t2 = menu(1, 1, 0, s1, space(t1), t2, 7, 12, t1, 10)

			if t2 > 0

			   s1 = iif(substr(s1, (t2 - 1) * 10 + 1, 1) = ' ', stuff(s1, (t2 - 1) * 10 + 1, 1, '*'), stuff(s1, (t2 - 1) * 10 + 1, 1, ' '))

			endif

		     enddo

		     if option = 3

			@ 18, 14 to 22, 63 double
			@ 19, 15 clear to 21, 62
			s3 = space(50)
			@ 20, 16 say 'Enter Target Drive and Directory:' get s3 picture '@S12@!'
			read
			s3 = alltrim(s3) + iif(right(alltrim(s3), 1) <> '\', '\', '')
			@ 18, 14 clear to 22, 63

		     endif

		     t2 = 1

		     do while t2 <= t1

			s2 = substr(s1, (t2 - 1) * 10 + 1,10)

			if left(s2, 1) = '*'

			   s2 = stuff(s2, 1, 2, '')

			   do case

			      case option = 1

				 if open_database(1, s2, 0, '', 1) = 0

				    @ 20, 0 clear to 20, 79
				    @ 20, int((79 - len(s2) - 9) / 2) say 'Indexing ' + s2

				    do case

				       case s2 = 'CLIENTS'

					  index on last_name + first_name + middleinit to &s2

				       case s2 = 'ACCOUNTS'

					  index on clientcode to &s2

				       case s2 = 'PRODUCTS'

					  index on name to &s2

				       case s2 = 'CCODES'

					  index on state + county to &s2

				    endcase

				    use

				 endif

			      case option = 2


				 if open_database(1, s2, 0, '', 1) = 0

				    @ 20, 0 clear to 20, 79
				    @ 20, int((79 - len(s2) - 9) / 2) say 'Sorting ' + s2

				    do case

				       case s2 = 'CLIENTS'

					  sort on last_name, first_name, middleinit to clients.srt
					  zap
					  append from clients.srt
					  reindex
					  erase clients.srt

				       case s2 = 'ACCOUNTS'

					  sort on clientcode, bill_date, paid_date to accounts.srt
					  zap
					  append from accounts.srt
					  reindex
					  erase accounts.srt

				       case s2 = 'PRODUCTS'

					  sort on product to products.srt
					  zap
					  append from products.srt
					  reindex
					  erase products.srt

				       case s2 = 'CCODES'

					  sort on state, county to ccodes.srt
					  zap
					  append from ccodes.srt
					  reindex
					  erase ccodes.srt

				    endcase

				    use

				 endif

			      case option = 3

				 s2 = alltrim(s2) + '.DBF'
				 s4 = s3 + s2
				 @ 20, 0 clear to 20, 79
				 @ 20, int((79 - len(s2) - len(s4) - 12) / 2) say 'Copying ' + s2 + ' to ' + s4
				 copy file &s2 to &s4

			   endcase

			endif

			t2 = t2 + 1

		     enddo

		  endif

	    endcase

	 end

      enddo

      help_type = prev_help
   end

   release s1, s2, s3, s4, s5, t1, t2, t3, t4, t5, l1, l2, option, prev_help

return

* Procedure   : rpt_menu
* Description : The reports menu.
* Expects     : Nothing.
* Returns     : Nothing.
* Modified    : 04/04/91 DWP Initial coding.
* Notes       :

procedure rpt_menu

   private option, prev_help

   begin sequence

      prev_help = help_type
      help_type = 'M'

      option = 1

      if iscolor()
         set color to rb+/n, w+/r
      endif

      do while .t.

         ignore_err = .f.
         do borders with 'M', 'Reports Menu'
         option = menu(1, 1, 0, '1 - CLIENTS Listing 2 - ACCOUNTS Listing3 - PRODUCTS Listing4 - CCODES Listing  5 - ACCOUNTS/Zip    6 - ACCOUNTS/County 7 - CLIENTS/Product U - Utilities Menu  Q - Quit            ', '1234567UQ', option, 8, 27, 9, 21)

         do case

            case option = 0 .or. option = 9

               exit

            case option >= 1 .and. option <= 7

               do rpt_1 with option

            case option = 8

               do pr_util

         endcase
      enddo

      help_type = prev_help
   end

   release option, prev_help
return

* Procedure   : rpt_1
* Description : This procedure passes control to the actual report.
* Expects     : rpt_no = The report to run.
* Returns     : Nothing.
* Modified    : 04/04/91 DWP Initial coding.
* Notes       :

procedure rpt_1
   parameters rpt_no

   private rpt_cno, prev_help
   public page_no,line_no

   begin sequence
      prev_help = help_type
      help_type = 'R'
      rpt_cno = ltrim(rtrim(str(rpt_no, 2, 0)))
      page_no = 1
      line_no = 1
      do rpt&rpt_cno
      set printer to
      help_type = prev_help
   end

   release rpt_cno, page_no, line_no
return

* Procedure   : pr_util
* Description : The printer utilities menu.
* Expects     : Nothing.
* Returns     : Nothing.
* Modified    : 04/04/91 DWP Initial coding.
* Notes       :

procedure pr_util

   private option, out_dev_option, prev_help
   private prnt_list1, prnt_col, prnt_row, prnt_x, prnt_y, prnt_z, prnt_s1, prnt_s2

   begin sequence

      prev_help = help_type
      help_type = 'M'

      if iscolor()
         set color to gr+/n
      endif

      store 0 to option, prnt_col, prnt_row, prnt_x, prnt_y, prnt_z
      prnt_list1 = '1503Before Document:1561After Document: 2003Before Page:    2061After Page:     '
      store '' to prnt_s1, prnt_s2

      do while .t.

         ignore_err = .f.
         do borders with 'M', 'Printer Utilities Menu'
         option = menu(1, 1, 0, '1 - LIST Previous Report 2 - Set Print DestinationQ - Quit                 ', '12Q', option, 5, 27, 3, 25)

         do case

            case option = 0 .or. option = 3

                exit

            case option = 1

               @ 14, 22 to 18, 56 double
               @ 15, 23 clear to 17, 55
               @ 16, 24 say 'LIST Which Report:'
               prnt_s1 = space(50)
               @ 16, 43 get prnt_s1 picture '@S12'
               read
               prnt_s1 = alltrim(prnt_s1)

               if file(prnt_s1)
                  ignore_err = .t.
                  set console off
                  ! list &prnt_s1
                  set console on
                  ignore_err = .f.
               endif

            case option = 2
               @ 14, 22 to 22, 56
               @ 15, 23 clear to 21, 55
               @ 16, 25 say 'Select NEW Print Destination:'
               @ 18, 32 say 'Current = ' + print_dev
               out_dev_option = menu(1, 0, 0, 'LPT1LPT2LPT3COM1COM2', space(5), 1, 20, 25, 1, 28)
               print_dev = iif(out_dev_option > 0, iif(out_dev_option < 4, 'LPT' + ltrim(str(out_dev_option, 1, 0)), 'COM' + ltrim(str(out_dev_option - 3, 1, 0))), print_dev)

            case option = 3

            case option = 4

         endcase
      enddo

      if iscolor()
         set color to rb+/n, w+/r
      endif

      help_type = prev_help
   end

   release option, prev_help
   release prnt_list1, prnt_s1, prnt_s2, prnt_row, prnt_col, prnt_x, prnt_y, prnt_z
return
