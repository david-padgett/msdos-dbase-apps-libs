* File         : REPORTS.PRG
* Module       : REPORTS
* System       : ESTES
* Description  : The reports module for the ESTES program.
* Modified     : 04/04/91 DWP Created.

* Procedure   : rpt1
* Description : The CLIENTS Database Listing report.
* Expects     : Nothing.
* Returns     : Nothing.
* Modified    : 04/04/91 DWP Initial coding.
* Notes       :

procedure rpt1

   begin sequence

      if open_database(1, 'clients', 'clients', '', 1) = 0 .and. open_database(1, 'ccodes', 'ccodes', '', 2) = 0 .and. print_to()

         do query_field with 1, 1
	 do rpt_msg
         locate for &loc_fltr

         if found()
            do rpt_stat with 1, 1, 1, 'CLIENTS Database Listing', page_no, line_no
            do rpt1_a with page_no

            do while .not. eof()

               do rpt_stat with 1, 2, 1, 'CLIENTS Database Listing', page_no, line_no

               if inkey() = 27
                  exit
               endif

               if line_no > 50
                  ? chr(12)
                  line_no = 1
                  page_no = page_no + 1
                  do rpt1_a with page_no
	       else
                  do rpt1_b
                  skip
                  line_no = line_no + 1
               endif
            enddo

            do rpt_exit
         endif
      endif

      select 2
      use
      select 1
      use
   end

return

* Procedure   : rpt1_a
* Description : Generates the page header for the CLIENTS Database Listing
*               report.
* Expects     : r1 = The current page number.
* Returns     : Nothing.
* Modified    : 04/04/91 DWP Initial coding.
* Notes       :

procedure rpt1_a
   parameters r1

   ? 'CLIENTS Database Listing'
   ? 'Page' + str(r1, 4, 0)
   ? 'Date: ' + dtoc(date())
   ? 'Time: ' + time()
   ?
   ? '                                                                                                                                                                                Customer Last'
   ? 'Last Name                      First Name           M Address                                            City                 St Zip  + 4   County               Phone          Since    Activity'
   ? '------------------------------ -------------------- - -------------------------------------------------- -------------------- -- ----- ---- -------------------- -------------- -------- --------'
return

* Procedure   : rpt1_b
* Description : Generates the body of the CLIENTS Database Listing report.
* Expects     : Nothing.
* Returns     : Nothing.
* Modified    : 04/04/91 DWP Initial coding.
* Notes       :

procedure rpt1_b

   private str

   select 2
   locate for code = clients->countycode
   str = iif(found(), county, 'Unknown')
   select 1

   ? last_name + ' ' + first_name + ' ' + middleinit + ' ' + address + ' ' + city + ' ' + state + ' ' + str(zip) + ' ' + str(zip_plus_4) + ' ' + substr(str, 1, 20)
   ?? ' (' + left(alltrim(str(phone / 10000000)), 3) + ') ' + left(alltrim(str(mod(phone, 10000000) / 10000)), 3) + '-' + left(alltrim(str(mod(phone, 10000))), 4) + ' ' + dtoc(cust_since) + ' ' + dtoc(last_act)

   release str

return

* Procedure   : rpt2
* Description : The ACCOUNTS Database Listing report.
* Expects     : Nothing.
* Returns     : Nothing.
* Modified    : 04/04/91 DWP Initial coding.
* Notes       :

procedure rpt2

   begin sequence

      if open_database(1, 'accounts', 'accounts', '', 1) = 0 .and. open_database(1, 'clients', 'clients', '', 2) = 0 .and. open_database(1, 'products', 'products', '', 3) = 0 .and. print_to()

         do query_field with 2, 1
         do rpt_msg
         locate for &loc_fltr

	 if found()
            do rpt_stat with 1, 1, 2, 'ACCOUNTS Database Listing', page_no, line_no
            do rpt2_a with page_no

            do while .not. eof()

               do rpt_stat with 1, 2, 2, 'ACCOUNTS Database Listing', page_no, line_no

               if inkey() = 27
                  exit
               endif

               if line_no > 50
                  ? chr(12)
                  line_no = 1
                  page_no = page_no + 1
                  do rpt2_a with page_no
               else
                  do rpt2_b
                  skip
		  line_no = line_no + 1
               endif
            enddo

            do rpt_exit
         endif
      endif

      select 3
      use
      select 2
      use
      select 1
      use
   end

return

* Procedure   : rpt2_a
* Description : Generates the page header for the ACCOUNTS Database Listing
*               report.
* Expects     : r1 = The current page number.
* Returns     : Nothing.
* Modified    : 04/04/91 DWP Initial coding.
* Notes       :

procedure rpt2_a
   parameters r1

   ? 'ACCOUNTS Database Listing'
   ? 'Page' + str(r1, 4, 0)
   ? 'Date: ' + dtoc(date())
   ? 'Time: ' + time()
   ?
   ? '                                                          Date                                                                  Machine     Date     Date'
   ? 'Client                                                  Ordered  Product Name                                         Price      Hours     Billed    Paid'
   ? '------------------------------------------------------- -------- -------------------------------------------------- ---------- ---------- -------- --------'

return

* Procedure   : rpt2_b
* Description : Generates the body of the ACCOUNTS Database Listing report.
* Expects     : Nothing.
* Returns     : Nothing.
* Modified    : 04/04/91 DWP Initial coding.
* Notes       :

procedure rpt2_b

   private str1, str2

   select 3
   locate for product = accounts->product
   str1 = iif(found(), name, 'Unknown')
   select 2
   locate for clientcode = accounts->clientcode
   str2 = iif(found(), alltrim(last_name) + ', ' + alltrim(first_name) + ' ' + middleinit + '.', 'Unknown')
   select 1

   ? substr(str2 + space(55), 1, 55) + ' ' + dtoc(order_date) + ' ' + substr(str1 + space(50), 1, 50) + ' ' + str(price, 10, 2) + ' ' + str(mach_hours, 10, 2) + ' ' + dtoc(bill_date) + ' ' + dtoc(paid_date)

   release str1, str2

return

* Procedure   : rpt3
* Description : The ACCOUNTS Database Listing report.
* Expects     : Nothing.
* Returns     : Nothing.
* Modified    : 04/04/91 DWP Initial coding.
* Notes       :

procedure rpt3

   begin sequence

      if open_database(1, 'products', 'products', '', 1) = 0 .and. print_to()

         do query_field with 3, 1
         do rpt_msg
	 locate for &loc_fltr

         if found()
            do rpt_stat with 1, 1, 3, 'PRODUCTS Database Listing', page_no, line_no
            do rpt3_a with page_no

            do while .not. eof()

               do rpt_stat with 1, 2, 3, 'PRODUCTS Database Listing', page_no, line_no

               if inkey() = 27
                  exit
               endif

               if line_no > 50
                  ? chr(12)
                  line_no = 1
                  page_no = page_no + 1
                  do rpt3_a with page_no
               else
		  do rpt3_b
                  skip
                  line_no = line_no + 1
               endif
            enddo

            do rpt_exit
         endif
      endif

      select 1
      use
   end

return

* Procedure   : rpt3_a
* Description : Generates the page header for the PRODUCTS Database Listing
*               report.
* Expects     : r1 = The current page number.
* Returns     : Nothing.
* Modified    : 04/04/91 DWP Initial coding.
* Notes       :

procedure rpt3_a
   parameters r1

   ? 'PRODUCTS Database Listing'
   ? 'Page' + str(r1, 4, 0)
   ? 'Date: ' + dtoc(date())
   ? 'Time: ' + time()
   ?
   ? 'Product Name                                       Product Description                                Model Number                                       Manufacturer                                         Price    HSI'
   ? '-------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- ---------- ---'

return

* Procedure   : rpt3_b
* Description : Generates the body of the PRODUCTS Database Listing report.
* Expects     : Nothing.
* Returns     : Nothing.
* Modified    : 04/04/91 DWP Initial coding.
* Notes       :

procedure rpt3_b

   ? name + ' ' + desc + ' ' + model_no + ' ' + manufactr + ' ' + str(price, 10, 2) + ' ' + iif(hard_serv, 'YES', 'NO')

return

* Procedure   : rpt4
* Description : The CCODES Database Listing report.
* Expects     : Nothing.
* Returns     : Nothing.
* Modified    : 04/04/91 DWP Initial coding.
* Notes       :

procedure rpt4

   begin sequence

      if open_database(1, 'ccodes', 'ccodes', '', 1) = 0 .and. print_to()

         do query_field with 4, 1
         do rpt_msg
         locate for &loc_fltr

         if found()
            do rpt_stat with 1, 1, 4, 'COUNTY CODES Database Listing', page_no, line_no
            do rpt4_a with page_no

            do while .not. eof()

               do rpt_stat with 1, 2, 4, 'COUNTY CODES Database Listing', page_no, line_no

               if inkey() = 27
                  exit
               endif

               if line_no > 50
		  ? chr(12)
                  line_no = 1
                  page_no = page_no + 1
                  do rpt4_a with page_no
               else
                  do rpt4_b
                  skip
                  line_no = line_no + 1
               endif
            enddo

            do rpt_exit
         endif
      endif

      select 1
      use
   end

return

* Procedure   : rpt4_a
* Description : Generates the page header for the CCODES Database Listing
*               report.
* Expects     : r1 = The current page number.
* Returns     : Nothing.
* Modified    : 04/04/91 DWP Initial coding.
* Notes       :

procedure rpt4_a
   parameters r1

   ? 'COUNTY CODES Database Listing'
   ? 'Page' + str(r1, 4, 0)
   ? 'Date: ' + dtoc(date())
   ? 'Time: ' + time()
   ?
   ? 'State County               Code '
   ? ' --   -------------------- -----'

return

* Procedure   : rpt4_b
* Description : Generates the body of the CCODES Database Listing report.
* Expects     : Nothing.
* Returns     : Nothing.
* Modified    : 04/04/91 DWP Initial coding.
* Notes       :

procedure rpt4_b

   ? ' ' + state + '   ' + county + ' ' + str(code, 5, 0)

return

* Procedure   : rpt5
* Description : The ACCOUNTS Listing By Zip Code report.
* Expects     : Nothing.
* Returns     : Nothing.
* Modified    : 04/15/91 DWP Initial coding.
* Notes       :

procedure rpt5

   private exit_flag

   begin sequence

      exit_flag = .f.

      * Open the databases.

      if open_database(1, 'accounts', 'accounts', '', 1) = 0 .and. open_database(1, 'clients', 'clients', '', 2) = 0 .and. open_database(1, 'products', 'products', '', 3) = 0 .and. print_to()

	 * Allow the user to specify a query on the ACCOUNTS database.

	 select 1
	 do query_field with 2, 1
	 do rpt_msg

	 * Create Zip Code index file for CLIENTS database.

	 select 2
	 index on str(zip) + last_name + first_name + middleinit to zip
	 set index to zip

	 * Initialize the Report Status screen.  Print the header for the
	 * first page of the report.

	 do rpt_stat with 1, 1, 5, 'ACCOUNTS Listing by Zip Code', page_no, line_no
	 do rpt5_a with page_no

	 * Process the CLIENTS database in zip code/client name order.

	 select 2

	 do while .not. eof() .and. .not. exit_flag

	    * Process the ACCOUNTS database in clientcode order.

	    select 1
	    go top

	    do while .not. eof() .and. .not. exit_flag

	       * Update the Report status screen.

	       do rpt_stat with 1, 2, 5, 'ACCOUNTS Listing By Zip Code', page_no, line_no

	       * Exit if ESC was pressed.

	       if inkey() = 27
		  exit_flag = .t.
	       endif

	       * If the total number of data lines is greater than 50,
	       * start a new page.

	       if line_no > 50
		  ? chr(12)
		  line_no = 1
		  page_no = page_no + 1
		  do rpt5_a with page_no
	       else

		  * If the current ACCOUNTS record belongs to the current
		  * CLIENTS record, print the information.

		  if clientcode = clients->clientcode
		     do rpt5_b
		     line_no = line_no + 1
		  endif

		  * Go to the next ACCOUNTS record.

		  select 1
		  skip
	       endif
	    enddo

	    * Go to the next CLIENTS record.

	    select 2
	    skip
	 enddo

	 * Restore the system to the state it was in before the report
	 * was processed.

	 do rpt_exit
      endif

      * Close all open databases.

      select 3
      use
      select 2
      use
      select 1
      use
   end

   release exit_flag

return

* Procedure   : rpt5_a
* Description : Displays the report header for the ACCOUNTS Listing By Zip
*               Code report.
* Expects     : r1 = The current page number.
* Returns     : Nothing.
* Modified    : 04/15/91 DWP Initial coding.
* Notes       :

procedure rpt5_a
   parameters r1

   ? 'ACCOUNTS Listing by Zip Code'
   ? 'Page' + str(r1, 4, 0)
   ? 'Date: ' + dtoc(date())
   ? 'Time: ' + time()
   ?
   ? 'Zip                                                                            Date'
   ? 'Code  Client                                                   Phone Number  Ordered  Product Name                                         Price'
   ? '----- ------------------------------------------------------- -------------- -------- -------------------------------------------------- ----------'

return

* Procedure   : rpt5_b
* Description : Displays one line of data for the ACCOUNTS Listing By Zip
*               Code report.
* Expects     : Nothing.
* Returns     : Nothing.
* Modified    : 04/15/91 DWP Initial coding.
* Notes       :

procedure rpt5_b

   private client_name, product_name

   select 3
   locate for product = accounts->product
   product_name = iif(found(), name, 'Unknown Product')
   client_name = alltrim(clients->last_name) + iif(len(alltrim(clients->first_name)) > 0, ', ' + alltrim(clients->first_name), '') + iif(len(alltrim(clients->middleinit)) > 0, ' ' + clients->middleinit + '.', '')
   select 1

   ? str(clients->zip, 5) + ' ' + left(client_name + space(55), 55)
   ?? ' (' + left(alltrim(str(clients->phone / 10000000)), 3) + ') ' + left(alltrim(str(mod(clients->phone, 10000000) / 10000)), 3) + '-' + left(alltrim(str(mod(clients->phone, 10000))), 4) + ' '
   ?? dtoc(order_date) + ' ' + left(product_name + space(50), 50) + ' ' + str(price, 10, 2)

   release client_name, product_name

return

* Procedure   : rpt6
* Description : The ACCOUNTS Listing by County report.
* Expects     : Nothing.
* Returns     : Nothing.
* Modified    : 04/15/91 DWP Initial coding.
* Notes       :

procedure rpt6

   private exit_flag

   begin sequence

      exit_flag = .f.

      * Open the databases.

      if open_database(1, 'accounts', 'accounts', '', 1) = 0 .and. open_database(1, 'clients', 'clients', '', 2) = 0 .and. open_database(1, 'products', 'products', '', 3) = 0 .and. open_database(1, 'ccodes', 'ccodes', '', 4) = 0 .and. print_to()

	 * Allow the user to entry a query on for use with the ACCOUNTS
	 * database.

	 select 1
	 do query_field with 2, 1
	 do rpt_msg

	 * Initialize the Reports Status screen.  Also output first header
	 * of report.

	 do rpt_stat with 1, 1, 6, 'ACCOUNTS Listing by County', page_no, line_no
	 do rpt6_a with page_no

	 * Process CCODES database in county name order.

	 select 4
	 go top

	 do while .not. eof() .and. .not. exit_flag

	    * Process CLIENTS database in client name order.

	    select 2
	    set filter to countycode = ccodes->code
	    go top

	    do while .not. eof() .and. .not. exit_flag

	       * Process the ACCOUNTS database in clientcode order.

	       select 1
	       set filter to clientcode = clients->clientcode
	       go top

	       do while .not. eof() .and. .not. exit_flag

		  * Update the Reports Status screen.

		  do rpt_stat with 1, 2, 6, 'ACCOUNTS Listing By County', page_no, line_no

		  * Exit if ESC was pressed.

		  if inkey() = 27

		     exit_flag = .t.

		  endif

		  * Start a new page if the number of data lines printed
		  * is greater than 50.

		  if line_no > 50

		     ? chr(12)
		     line_no = 1
		     page_no = page_no + 1
		     do rpt6_a with page_no

		  endif

		  * Output a line of information.

		  do rpt6_b
		  line_no = line_no + 1

		  * Go to the next ACCOUNTS record.

		  select 1
		  skip

	       enddo

	       * Go to the next CLIENTS record.

	       select 2
	       skip

	    enddo

	    * Go to the next CCODES record.

	    select 4
	    skip

	 enddo

	 * Restore system to state it was in before the report was processed.

	 do rpt_exit

      endif

      * Close all open databases.

      select 4
      use
      select 3
      use
      select 2
      use
      select 1
      use

   end

   release exit_flag

return

* Procedure   : rpt6_a
* Description : Displays the report header for the ACCOUNTS Listing By County
*               report.
* Expects     : r1 = The current page number.
* Returns     : Nothing.
* Modified    : 04/15/91 DWP Initial coding.
* Notes       :

procedure rpt6_a
   parameters r1

   ? 'ACCOUNTS Listing by County'
   ? 'Page' + str(r1, 4, 0)
   ? 'Date: ' + dtoc(date())
   ? 'Time: ' + time()
   ?
   ? '                                                                                                                                                                                                      Date     Machine'
   ? 'State/County            Client Name                                             Address/City/Zip Code                                                         Phone        Product Name              Ordered    Hours'
   ? '----------------------- ------------------------------------------------------- ----------------------------------------------------------------------------- ------------ ------------------------- -------- ----------'

return

* Procedure   : rpt6_b
* Description : Displays one line of data for the ACCOUNTS Listing By County
*               report.
* Expects     : Nothing.
* Returns     : Nothing.
* Modified    : 04/15/91 DWP Initial coding.
* Notes       :

procedure rpt6_b

   private client_name, client_address, client_phone, product_name

   select 3
   locate for product = accounts->product
   product_name = iif(found(), name, 'Unknown Product')
   client_name = alltrim(clients->last_name) + iif(len(alltrim(clients->first_name)) > 0, ', ' + alltrim(clients->first_name), '') + iif(len(alltrim(clients->middleinit)) > 0, ' ' + clients->middleinit + '.', '')
   client_address = alltrim(clients->address) + ', ' + alltrim(clients->city) + ', ' + str(clients->zip, 5, 0)
   client_phone = left(alltrim(str(clients->phone / 10000000)), 3) + '/' + left(alltrim(str(mod(clients->phone, 10000000) / 10000)), 3) + '-' + left(alltrim(str(mod(clients->phone, 10000))), 4)
   select 1

   ? ccodes->state + '/' + ccodes->county + ' '
   ?? left(client_name + space(55), 55) + ' '
   ?? left(client_address + space(77), 77) + ' '
   ?? left(client_phone + space(12), 12) + ' '
   ?? left(product_name + space(25), 25) + ' '
   ?? dtoc(order_date) + ' '
   ?? mach_hours

   release client_name, client_address, client_phone, product_name

return

* Procedure   : rpt7
* Description : The CLIENTS & PRODUCTS Listing report.
* Expects     : Nothing.
* Returns     : Nothing.
* Modified    : 05/06/91 DWP Initial coding.
* Notes       :

procedure rpt7

   private exit_flag

   begin sequence

      exit_flag = .f.

      * Open the databases.

      if open_database(1, 'clients', 'clients', '', 1) = 0 .and. open_database(1, 'accounts', 'accounts', '', 2) = 0 .and. open_database(1, 'products', 'products', '', 3) = 0 .and. open_database(1, 'ccodes', 'ccodes', '', 4) = 0 .and. print_to()

	 * Allow the user to entry a query on for use with the CLIENTS
	 * database.

	 select 1
	 do query_field with 1, 1
	 do rpt_msg

	 * Initialize the Reports Status screen.  Also output first header
	 * of report.

	 do rpt_stat with 1, 1, 7, 'CLIENTS & PRODUCTS Listing', page_no, line_no
	 do rpt7_a with page_no

	 * Process CLIENTS database in client name order.

	 select 1
	 go top

	 do while .not. eof() .and. .not. exit_flag

	    * Process the ACCOUNTS database in client number order.

	    select 2
	    go top
	    locate for clientcode = clients->clientcode

	    * Process all of the ACCOUNTS records for the current CLIENT
	    * record.

	    do while clientcode = clients->clientcode .and. .not. exit_flag

	       * Update the Reports Status screen.

	       do rpt_stat with 1, 2, 7, 'CLIENTS & PRODUCTS Listing', page_no, line_no

	       * Exit if ESC was pressed.

	       if inkey() = 27
		  exit_flag = .t.
	       endif

	       * Start a new page if the number of data lines printed
	       * is greater than 50.

	       if line_no > 50
		  ? chr(12)
		  line_no = 1
		  page_no = page_no + 1
		  do rpt7_a with page_no
	       else

		  * Output a line of information if the current account
		  * belongs to the client currently being processed.

		  do rpt7_b
		  line_no = line_no + 1

		  * Go to the next ACCOUNTS record.

		  select 2
		  skip
	       endif
	    enddo

	    * Go to the next CLIENTS record.

	    select 1
	    skip
	 enddo

	 * Restore system to state it was in before the report was processed.

	 do rpt_exit
      endif

      * Close all open databases.

      select 4
      use
      select 3
      use
      select 2
      use
      select 1
      use
   end

   release exit_flag

return

* Procedure   : rpt7_a
* Description : Displays the report header for the CLIENTS & PRODUCTS Listing
*               report.
* Expects     : r1 = The current page number.
* Returns     : Nothing.
* Modified    : 05/06/91 DWP Initial coding.
* Notes       :

procedure rpt7_a
   parameters r1

   ? 'CLIENTS & PRODUCTS Listing'
   ? 'Page' + str(r1, 4, 0)
   ? 'Date: ' + dtoc(date())
   ? 'Time: ' + time()
   ?
   ? '                                                                                                                                                                                                                              Order   '
   ? 'Last Name                      First Name           M Address                                            City                 St  Zip  County               Phone          Product Name                                       Date    '
   ? '------------------------------ -------------------- - -------------------------------------------------- -------------------- -- ----- -------------------- -------------- -------------------------------------------------- --------'

return

* Procedure   : rpt7_b
* Description : Displays one line of data on the CLIENTS & PRODUCTS Listing report.
* Expects     : Nothing.
* Returns     : Nothing.
* Modified    : 05/06/91 DWP Initial coding.
* Notes       :

procedure rpt7_b
   private county_name, product_name, date_ordered

   select 4
   locate for code = clients->countycode
   county_name = iif(found(), county, left('Unknown' + space(20), 20))
   select 3
   locate for product = accounts->product
   product_name = iif(found(), name, left('Unknown' + space(50), 50))
   select 2
   date_ordered = iif(found(), order_date, null_date)

   ? clients->last_name + ' ' + clients->first_name + ' ' + clients->middleinit + ' ' + clients->address + ' ' + clients->city + ' ' + clients->state + ' ' + str(clients->zip, 5) + ' ' + county_name
   ?? ' (' + left(alltrim(str(clients->phone / 10000000)), 3) + ') ' + left(alltrim(str(mod(clients->phone, 10000000) / 10000)), 3) + '-' + left(alltrim(str(mod(clients->phone, 10000))), 4) + ' ' + product_name + ' ' + dtoc(date_ordered)

return
