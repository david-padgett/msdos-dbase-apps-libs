* File        : CL6.PRG
* Module      : CLIPPER
* System      : None
* Description : An alternate error handling routine.
* Modified    : 04/11/91 DWP Created.

* Procedure   : error_init
* Description : Initializes the alternate error system.
* Expects     : Nothing.
* Returns     : Nothing.
* Modified    : 04/11/91 DWP Initial coding.
* Notes       : 1) This procedure must be called if the alternate error
*                  system is to be used.  If it is not called, then the
*                  alternate error system will not be properly linked into
*                  the program that is using it.

procedure error_init

   public err, ignore_err

   err = 0
   ignore_err = .f.

return

* Procedure   : error_p1
* Description : Initializes the error message string.
* Expects     : Nothing.
* Returns     : Nothing.
* Modified    : 04/04/91 DWP Initial coding.
* Notes       :

procedure error_p1
   private err_t1,err_t2,err_t3

   if type('m->model')<>'C'
      release m->model
      m->model=''
   endif

   m->err_t3=1
   do while m->err_t3<6
      m->err_t1='m->_'+ltrim(str(m->err_t3))
      m->err_t2="'"+err_t1+"'"

      do case
         case type(&err_t2)='U'
            release &err_t1
            &err_t1=''
         case type(&err_t2)='N'
            err_t2=ltrim(str(&err_t1))
            release &err_t1
            &err_t1=m->err_t2
         case type(&err_t2)='L'
            err_t2=iif(&err_t1,'T','F')
            release &err_t1
            &err_t1=m->err_t2
         case type(&err_t2)='D'
            err_t2=dtoc(&err_t1)
            release &err_t1
            &err_t1=m->err_t2
      endcase

      if len(m->err_t1)>0
         if at(m->err_t1,m->model)>0
            m->model=strtran(m->model,ltrim(m->err_t1),&err_t1)
         else
            m->model=m->model+' '+&err_t1
         endif
      endif
      m->err_t3=m->err_t3+1
   enddo

   release err_t1,err_t2,err_t3
return

* Function    : db_error
* Description : An alternate method for displaying database related errors.
* Expects     : name  = The base name.
*               line  = The line number the error occurred on.
*               info  = The error message.
*               model = Text that may contain the cause of the error.
*               _1    = Reference parameter 1.
*               _2    = Reference parameter 2.
*               _3    = Reference parameter 3.
*               _4    = Reference parameter 4.
*               _5    = Reference parameter 5.
* Returns     : A value of FALSE, if the error is to be unrecoverable, or
*               TRUE if recovery is possible.
* Modified    : 04/04/91 DWP Initial coding.
* Notes       :

function db_error
   parameters name,line,info,model,_1,_2,_3,_4,_5

   private err_xpos, err_ypos, err_scrn, err_msg, option

   do error_p1
   do case
      case upper(m->info)='DATABASE REQUIRED'
         m->err=1
      case upper(m->info)='EXCLUSIVE REQUIRED'
         m->err=2
      case upper(m->info)='FIELD NUMERIC OVERFLOW'
         m->err=3
      case upper(m->info)='INDEX FILE CORRUPTED'
         m->err=4
      case upper(m->info)='LOCK REQUIRED'
         m->err=5
      otherwise
         m->err=100
   endcase

   if .not. m->ignore_err
      m->err_xpos=col()
      m->err_ypos=row()
      m->err_scrn=savescreen(7,0,15,79)
      m->err_msg='In '+procfile()+'/'+m->name+'/'+ltrim(str(m->line))+iif(len(alltrim(m->model))>0,' Cause '+upper(m->model),'')

      @ 7,0 to 7,79 double
      @ 15,0 to 15,79 double
      @ 8,0 clear to 14,79
      @ 9,int((63-len(m->info))/2) say 'Database Error: '+upper(m->info)
      @ 11,int((79-len(m->err_msg))/2) say m->err_msg

      do while .t.

         m->option = menu(1,0,0,'ContinueAbort   ','CA',1,13,29,1,10)

         if m->option > 0
            exit
         endif
      enddo

      restscreen(7,0,15,79,m->err_scrn)
      @ m->err_ypos,m->err_xpos say ''

      if m->option = 2
         break
      endif
   else
      m->option = 1
      break
   endif

   release err_xpos, err_ypos, err_scrn, err_msg, option
return (.t.)

* Function    : expr_error
* Description : An alternate method for displaying expression related errors.
* Expects     : name  = The base name.
*               line  = The line number the error occurred on.
*               info  = The error message.
*               model = Text that may contain the cause of the error.
*               _1    = Reference parameter 1.
*               _2    = Reference parameter 2.
*               _3    = Reference parameter 3.
*               _4    = Reference parameter 4.
*               _5    = Reference parameter 5.
* Returns     : A value of FALSE, if the error is to be unrecoverable, or
*               TRUE if recovery is possible.
* Modified    : 04/04/91 DWP Initial coding.
* Notes       :

function expr_error
   parameters name, line, info, model, _1, _2, _3, _4, _5

   private err_xpos, err_ypos, err_scrn, err_msg, option

   do error_p1

   do case
      case upper(m->info)='EXPRESSION ERROR'
         m->err=6
      case upper(m->info)='TYPE MISMATCH'
         m->err=7
      case upper(m->info)='SUBSCRIPT RANGE'
         m->err=8
      case upper(m->info)='ZERO DIVIDE'
         m->err=9
      otherwise
         m->err=100
   endcase

   if .not. m->ignore_err
      m->err_xpos=col()
      m->err_ypos=row()
      m->err_scrn=savescreen(7,0,15,79)
      m->err_msg='In '+procfile()+'/'+m->name+'/'+ltrim(str(m->line))+iif(len(alltrim(m->model))>0,' Cause '+upper(m->model),'')

      @ 7,0 to 7,79 double
      @ 15,0 to 15,79 double
      @ 8,0 clear to 14,79
      @ 9,int((61-len(m->info))/2) say 'Expression Error: '+upper(m->info)
      @ 11,int((79-len(m->err_msg))/2) say m->err_msg

      do while .t.

         m->option = menu(1, 0, 0, 'ContinueAbort   ', 'CA', 1, 13, 29, 1, 10) > 0

         if m->option > 0
            exit
         endif
      enddo

      restscreen(7,0,15,79,m->err_scrn)
      @ m->err_ypos,m->err_xpos say ''

      if m->option = 2
         break
      endif
   else
      m->option = 1
      break
   endif

   release err_xpos, err_ypos, err_scrn, err_msg, option
return (.t.)

* Function    : misc_error
* Description : An alternate method for displaying miscellaneous errors.
* Expects     : name  = The base name.
*               line  = The line number the error occurred on.
*               info  = The error message.
*               model = Text that may contain the cause of the error.
*               _1    = Reference parameter 1.
*               _2    = Reference parameter 2.
*               _3    = Reference parameter 3.
*               _4    = Reference parameter 4.
*               _5    = Reference parameter 5.
* Returns     : A value of FALSE, if the error is to be unrecoverable, or
*               TRUE if recovery is possible.
* Modified    : 04/04/91 DWP Initial coding.
* Notes       :

function misc_error
   parameters name, line, info, model, _1, _2, _3, _4, _5

   private err_xpos, err_ypos, err_scrn, err_msg, option

   do error_p1

   do case
      case upper(m->info)='RUN ERROR'
         m->err=10
      case upper(m->info)='TYPE MISMATCH'
         m->err=11
      otherwise
         m->err=100
   endcase

   if .not. m->ignore_err
      m->err_xpos=col()
      m->err_ypos=row()
      m->err_scrn=savescreen(7,0,15,79)
      m->err_msg='In '+procfile()+'/'+m->name+'/'+ltrim(str(m->line))+iif(len(alltrim(m->model))>0,' Cause '+upper(m->model),'')

      @ 7,0 to 7,79 double
      @ 15,0 to 15,79 double
      @ 8,0 clear to 14,79
      @ 9,int((58-len(m->info))/2) say 'Miscellaneous Error: '+upper(m->info)
      @ 11,int((79-len(m->err_msg))/2) say m->err_msg

      do while .t.

         m->option = menu(1,0,0,'ContinueAbort   ','CA',1,13,29,1,10)

         if m->option > 0
            exit
         endif
      enddo

      restscreen(7,0,15,79,m->err_scrn)
      @ m->err_ypos,m->err_xpos say ''

      if m->option = 2
         break
      endif
   else
      m->option = 1
      break
   endif

   release err_xpos, err_ypos, err_scrn, err_msg, option
return (.t.)

* Function    : undef_error
* Description : An alternate method for displaying undefined errors.
* Expects     : name  = The base name.
*               line  = The line number the error occurred on.
*               info  = The error message.
*               model = Text that may contain the cause of the error.
*               _1    = Reference parameter 1.
*               _2    = Reference parameter 2.
*               _3    = Reference parameter 3.
*               _4    = Reference parameter 4.
*               _5    = Reference parameter 5.
* Returns     : A value of FALSE, if the error is to be unrecoverable, or
*               TRUE if recovery is possible.
* Modified    : 04/04/91 DWP Initial coding.
* Notes       :

function undef_error
   parameters name, line, info, model, _1, _2, _3, _4, _5

   private err_xpos, err_ypos, err_scrn, err_msg, option

   do error_p1

   do case
      case upper(m->info)='UNDEFINED IDENTIFIER'
         m->err=12
      case upper(m->info)='NOT AN ARRAY'
         m->err=13
      case upper(m->info)='MISSING EXTERNAL'
         m->err=14
      otherwise
         m->err=100
   endcase

   if .not. m->ignore_err
      m->err_xpos=col()
      m->err_ypos=row()
      m->err_scrn=savescreen(7,0,15,79)
      m->err_msg='In '+procfile()+'/'+m->name+'/'+ltrim(str(m->line))+iif(len(alltrim(m->model))>0,' Cause '+upper(m->model),'')

      @ 7,0 to 7,79 double
      @ 15,0 to 15,79 double
      @ 8,0 clear to 14,79
      @ 9,int((62-len(m->info))/2) say 'Undefined Error: '+upper(m->info)
      @ 11,int((79-len(m->err_msg))/2) say m->err_msg

      do while .t.

         m->option = menu (1,0,0,'ContinueAbort   ','CA',1,13,29,1,10)

         if m->option > 0
            exit
         endif
      enddo

      restscreen(7,0,15,79,m->err_scrn)
      @ m->err_ypos,m->err_xpos say ''

      if m->option = 2
         break
      endif
   else
      m->option = 1
      break
   endif

   release err_xpos, err_ypos, err_scrn, err_msg, option
return (.t.)

* Function    : open_error
* Description : An alternate method for displaying errors that occur during
*               file open operations.
* Expects     : name  = The base name.
*               line  = The line number the error occurred on.
*               info  = The error message.
*               model = Text that may contain the cause of the error.
*               _1    = Reference parameter 1.
*               _2    = Reference parameter 2.
*               _3    = Reference parameter 3.
*               _4    = Reference parameter 4.
*               _5    = Reference parameter 5.
* Returns     : A value of FALSE, if the error is to be unrecoverable, or
*               TRUE if recovery is possible.
* Modified    : 04/04/91 DWP Initial coding.
* Notes       :

function open_error
   parameters name, line, info, model, _1, _2, _3, _4, _5
   private err_xpos, err_ypos, err_scrn, err_msg, option

   do error_p1
   do case
      case upper(m->info)='OPEN ERROR'
         m->err=15
      otherwise
         m->err=100
   endcase

   if .not. m->ignore_err
      m->err_xpos=col()
      m->err_ypos=row()
      m->err_scrn=savescreen(7,0,15,79)
      m->err_msg='In '+procfile()+'/'+m->name+'/'+ltrim(str(m->line))+iif(len(alltrim(m->model))>0,' Cause '+upper(m->model),'')

      @ 7,0 to 7,79 double
      @ 15,0 to 15,79 double
      @ 8,0 clear to 14,79
      @ 9,int((67-len(m->info))/2) say 'Open Error: '+upper(m->info)
      @ 11,int((79-len(m->err_msg))/2) say m->err_msg

      do while .t.

         m->option = menu(1,0,0,'ContinueAbort   ','CA',1,13,29,1,10)

         if m->option > 0
            exit
         endif
      enddo

      restscreen(7,0,15,79,m->err_scrn)
      @ m->err_ypos,m->err_xpos say ''

      if m->option = 2
         break
      endif
   else
      m->option = 1
      break
   endif

   release err_xpos, err_ypos, err_scrn, err_msg, option
return (.t.)

* Function    : print_error
* Description : An alternate method for displaying errors that occur during
*               printing operations.
* Expects     : name  = The base name.
*               line  = The line number the error occurred on.
*               info  = The error message.
*               model = Text that may contain the cause of the error.
*               _1    = Reference parameter 1.
*               _2    = Reference parameter 2.
*               _3    = Reference parameter 3.
*               _4    = Reference parameter 4.
*               _5    = Reference parameter 5.
* Returns     : A value of FALSE, if the error is to be unrecoverable, or
*               TRUE if recovery is possible.
* Modified    : 04/04/91 DWP Initial coding.
* Notes       :

function print_error
   parameters name, line, info, model, _1, _2, _3, _4, _5
   private err_xpos, err_ypos, err_scrn, err_msg, option

   do error_p1

   do case
      case upper(m->info)='PRINT ERROR'
         m->err=16
      otherwise
         m->err=100
   endcase

   if .not. m->ignore_err
      m->err_xpos=col()
      m->err_ypos=row()
      m->err_scrn=savescreen(7,0,15,79)
      m->err_msg='In '+procfile()+'/'+m->name+'/'+ltrim(str(m->line))+iif(len(alltrim(m->model))>0,' Cause '+upper(m->model),'')

      @ 7,0 to 7,79 double
      @ 15,0 to 15,79 double
      @ 8,0 clear to 14,79
      @ 9,int((66-len(m->info))/2) say 'Print Error: '+upper(m->info)
      @ 11,int((79-len(m->err_msg))/2) say m->err_msg

      do while .t.

         m->option = menu(1,0,0,'ContinueAbort   ','CA',1,13,29,1,10)

         if m->option > 0
            exit
         endif
      enddo

      restscreen(7,0,15,79,m->err_scrn)
      @ m->err_ypos,m->err_xpos say ''

      if m->option = 2
         break
      endif
   else
      m->option = 1
      break
   endif

   release err_xpos, err_ypos, err_scrn, err_msg, option
return (.t.)

