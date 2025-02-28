* File        : CL2.PRG
* Module      : CLIPPER
* System      : None
* Description : A method for determining the logical record number of a
*               record that matches a certain criteria.
* Modified    : 04/11/91 DWP Created.

* Function    : locate_record
* Description : Locates the first logical record number in which the
*               specified expression matches the specified search data.
*               If the search data cannot be found, it is re-initialized with
*               the specified new value.
* Expects     : work_area   = The work area to use while searching, or zero
*                             if the current work area is to be used.
*               search_expr = The expression that is used to construct
*                             items that could possibly match the specified
*                             search data.
*               search_data = The data to search for.
*               new_value   = The value to place in search_data if it is not
*                             present in the database being searched.
* Returns     : The record number in which search_expr matches exactly
*               search_data, or zero if no matches were found.
* Modified    : 04/11/91 DWP Initial coding.
* Notes       :

function locate_record
   parameter work_area, search_expr, search_data, new_value

   private current_area, record_number, str

   * Initialize local variables.

   current_area = select()
   record_number = 1

   * Switch to new work area, if necessary.

   if work_area > 0
      str = chr(asc('a') - 1 + work_area)
      select &str
   endif

   go top

   * Loop until the specified search expression matches the specified
   * search data or until the end of file is encountered.

   do while .not. &search_expr = search_data

      * Go to the next record.

      record_number = record_number + 1
      skip

      * If the end of file was encountered, then no match was found, so exit.

      if eof()
         search_data = new_value
         record_number = 0
         exit
      endif
   enddo

   * Return to the previous work area, if necessary.

   if work_area > 0
      str = chr(asc('a') - 1 + current_area)
      select &str
   endif

return (record_number)
