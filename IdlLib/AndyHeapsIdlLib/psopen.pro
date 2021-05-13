PRO PSOPEN, FILE=file, PORTRAIT=portrait, LETTER=letter, A5=a5, EPS=eps, $
            XPLOTS=xplots, YPLOTS=yplots, XOFFSET=xoffset, $
            YOFFSET=yoffset, XSIZE=xsize, YSIZE=ysize, MARGIN=margin, SPACING=spacing, $
            XSPACING=xspacing, YSPACING=yspacing, SPACE1=space1, SPACE2=space2, SPACE3=space3, $
            TICKLEN=ticklen, THICK=thick, CTHICK=cthick, CSTYLE=cstyle, CCOLOUR=ccolour, $
            CB_WIDTH=cb_width, CB_HEIGHT=cb_height, BORDER_THICK=border_thick, $
	    FONT=font, CHARSIZE=charsize, BOLD=bold, ITALIC=italic, $
	    CFONT=cfont, CCHARSIZE=ccharsize, CBOLD=cbold, CITALIC=citalic, $
	    TFONT=tfont, TCHARSIZE=tcharsize, TBOLD=tbold, TITALIC=titalic, $
	    AXISTYPE=axistype, DEF=def, SIZE=size, LAKES=lakes
;Procedure to set-up a postscript file.
;(C) NCAS 2010

windows_lib='C:\idl_guide5\lib'
windows_viewer='C:\Program Files\Ghostgum\gsview\gsview32.exe'
spawn, 'echo %HOMEDRIVE%', homedrive
spawn, 'echo %HOMEPATH%', homepath
windows_file=homedrive(0)+homepath(0)+'\..\..\idl.ps'

;valid system variables
validnames=['portrait', 'letter', 'xplots', 'yplots', 'xoffset', 'yoffset', $
            'margin', 'xspacing', 'yspacing', 'xsize', 'ysize', 'space1', $
	    'space2', 'space3', 'ticklen', 'thick', 'cthick', 'cstyle', 'ccolour',$
	    'cb_height', 'cb_width', 'border_thick', $
	    'font', 'charsize', 'bold', 'italic', $
	    'cfont', 'ccharsize', 'cbold', 'citalic', $
	    'tfont', 'tcharsize', 'tbold', 'titalic', 'axistype']

;Read in system and user setup files
file1=GETENV('GUIDE_LIB')+'/idl_guide5.def'
IF (STRLOWCASE(!version.os_family) EQ 'windows') THEN file1=windows_lib+'\idl_guide5.def'
file2=GETENV('HOME')+'/.idl_guide5.def'
files=[file1, file2]

;Check for def file.
IF (N_ELEMENTS(def) NE 0) THEN BEGIN
 path=[STRSPLIT(GETENV('IDL_PATH'), ':', /EXTRACT)]
 IF (FILE_TEST(def) EQ 1) THEN mypath=def
 FOR i=0, N_ELEMENTS(path)-1 DO BEGIN
  tfile=path(i)+'/'+def
  res=FILE_TEST(tfile)
  IF (res EQ 1) THEN BEGIN
   IF (N_ELEMENTS(mypath) GT 0) THEN mypath=[mypath, tfile]
   IF (N_ELEMENTS(mypath) EQ 0) THEN mypath=tfile
  ENDIF
 ENDFOR

 IF(N_ELEMENTS(mypath) EQ 0) THEN BEGIN
  PRINT, ''
  PRINT, 'NCREAD ERROR - ', def,' not found in directories: ', path
  PRINT, ''
  STOP
 ENDIF

 IF (N_ELEMENTS(mypath) GT 1) THEN BEGIN
  PRINT, ''
  PRINT, 'NCREAD ERROR - multiple versions of ', file, ' found:'
  FOR i=0, N_ELEMENTS(mypath)-1 DO BEGIN
   PRINT, mypath(i)
  ENDFOR
  PRINT, ''
  STOP
 ENDIF  
 files=[files, mypath]
ENDIF

FOR n=0,N_ELEMENTS(files)-1 DO BEGIN
 exist=FILE_TEST(files(n))
 IF (exist EQ 1) THEN BEGIN
  OPENR, lun, files(n), /GET_LUN
  line=''    
  WHILE ~ EOF(lun) DO BEGIN  
   READF, lun, line  
   line=SCROP(line)
   i=STRPOS(line, '=')  
   IF (i GT 0) THEN BEGIN
    uservar=STRMID(line, 0, i)
    userval=STRMID(line, i+1, STRLEN(line)-1)
    j=STRMATCH(validnames, uservar, /FOLD_CASE)
    com="guide_"+SCROP(uservar)+"="+SCROP(FLOAT(userval))
    IF (TOTAL(j) EQ 1) THEN res=EXECUTE(com)
    IF (TOTAL(j) NE 1) THEN PRINT, 'File=', files(n),' - Ignoring invalid parameter ',$
                                   uservar, ' = ', userval
   ENDIF  
  ENDWHILE  
  FREE_LUN, lun
 ENDIF ELSE BEGIN
  IF (n EQ 0) THEN BEGIN
   PRINT, 'PSOPEN ERROR - system defaults file ', files(n), " doesn't exist"
   STOP
  ENDIF
 ENDELSE
ENDFOR

;Use postscript
SET_PLOT, 'ps'

;Overlay routine definitions.
IF (N_ELEMENTS(PORTRAIT) EQ 1) THEN guide_portrait=1
IF (N_ELEMENTS(LETTER) EQ 1) THEN guide_letter=1
IF (N_ELEMENTS(XPLOTS) NE 0) THEN guide_xplots=FLOAT(xplots)
IF (N_ELEMENTS(YPLOTS) NE 0) THEN guide_yplots=FLOAT(yplots)
IF (N_ELEMENTS(XOFFSET) NE 0) THEN guide_xoffset=FLOAT(xoffset)
IF (N_ELEMENTS(YOFFSET) NE 0) THEN guide_yoffset=FLOAT(yoffset)
IF (N_ELEMENTS(MARGIN) NE 0) THEN guide_margin=FLOAT(margin)
IF (N_ELEMENTS(XSIZE) NE 0) THEN guide_xsize=FLOAT(xsize)
IF (N_ELEMENTS(YSIZE) NE 0) THEN guide_ysize=FLOAT(ysize)
IF (N_ELEMENTS(SPACING) EQ 1) THEN guide_xspacing=FLOAT(spacing)
IF (N_ELEMENTS(SPACING) EQ 1) THEN guide_yspacing=FLOAT(spacing)
IF (N_ELEMENTS(XSPACING) EQ 1) THEN guide_xspacing=FLOAT(xspacing)
IF (N_ELEMENTS(YSPACING) EQ 1) THEN guide_yspacing=FLOAT(yspacing)
IF (N_ELEMENTS(SPACE1) EQ 1) THEN guide_space1=FLOAT(space1)
IF (N_ELEMENTS(SPACE2) EQ 1) THEN guide_space2=FLOAT(space2)
IF (N_ELEMENTS(SPACE3) EQ 1) THEN guide_space3=FLOAT(space3)
IF (N_ELEMENTS(TICKLEN) EQ 1) THEN guide_ticklen=FLOAT(ticklen)
IF (N_ELEMENTS(THICK) EQ 1) THEN guide_thick=FLOAT(thick)
IF (N_ELEMENTS(CCOLOUR) EQ 1) THEN guide_ccolour=FLOAT(ccolour)
IF (N_ELEMENTS(CTHICK) EQ 1) THEN guide_cthick=FLOAT(cthick)
IF (N_ELEMENTS(CSTYLE) EQ 1) THEN guide_cstyle=FLOAT(cstyle)
IF (N_ELEMENTS(CB_WIDTH) EQ 1) THEN guide_cb_width=FLOAT(cb_width)
IF (N_ELEMENTS(CB_HEIGHT) EQ 1) THEN guide_cb_height=FLOAT(cb_height)
IF (N_ELEMENTS(BORDER_THICK) EQ 1) THEN guide_border_thick=FLOAT(border_thick)
IF (N_ELEMENTS(axistype) EQ 1) THEN guide_axistype=FLOAT(axistype)

IF (N_ELEMENTS(FONT) EQ 1) THEN BEGIN
 IF ((FONT GE 1) AND (FONT LE 7)) THEN BEGIN
  guide_font=FLOAT(font)
 ENDIF ELSE BEGIN
  PRINT, ''
  PRINT, 'PSOPEN ERROR - FONT not in range 1 to 7.'
  HELP, font
  PRINT, ''
  STOP
 ENDELSE
ENDIF
guide_charsize=100.0
guide_tcharsize=130.0
IF (N_ELEMENTS(BOLD) EQ 1) THEN guide_bold=FLOAT(bold)
IF (N_ELEMENTS(ITALIC) EQ 1) THEN guide_italic=FLOAT(italic)
IF (N_ELEMENTS(CFONT) EQ 1) THEN guide_cfont=FLOAT(cfont)
IF (N_ELEMENTS(CCHARSIZE) EQ 1) THEN guide_ccharsize=FLOAT(ccharsize)
IF (N_ELEMENTS(CBOLD) EQ 1) THEN guide_cbold=FLOAT(cbold)
IF (N_ELEMENTS(CITALIC) EQ 1) THEN guide_citalic=FLOAT(citalic)
IF (N_ELEMENTS(TFONT) EQ 1) THEN guide_tfont=FLOAT(tfont)
IF (N_ELEMENTS(TBOLD) EQ 1) THEN guide_tbold=FLOAT(tbold)
IF (N_ELEMENTS(TITALIC) EQ 1) THEN guide_titalic=FLOAT(titalic)
IF (N_ELEMENTS(FILE) EQ 0) THEN guide_psfile='idl.ps'
IF ((STRLOWCASE(!version.os_family) EQ 'windows') AND (N_ELEMENTS(file) EQ 0)) THEN guide_psfile=windows_file(0)
IF (N_ELEMENTS(FILE) EQ 1) THEN guide_psfile=file
guide_sector=0
guide_position=[0.0,0.0,0.0,0.0] ;Internal plot position.
guide_squareplot=0.0
guide_satellite=[-99.0, -99.0]

;Modify the character and line thickness parameters to suit IDL.
;Change the text, tickmark sizes if they are still at 100%.
nplots=MAX([guide_xplots, guide_yplots])
sf=100.0
IF (guide_charsize EQ 100.0) THEN BEGIN
 IF (nplots EQ 2) THEN sf=130.0
 IF (nplots EQ 3) THEN sf=140.0
 IF (nplots EQ 4) THEN sf=150.0
 IF (nplots GE 5) THEN sf=160.0
ENDIF
guide_charsize=guide_charsize/sf
guide_ccharsize=1.0*guide_ccharsize/sf
guide_tcharsize=guide_tcharsize/sf
IF (N_ELEMENTS(CHARSIZE) EQ 1) THEN guide_charsize=guide_charsize*charsize/100.0
IF (N_ELEMENTS(CCHARSIZE) EQ 1) THEN guide_ccharsize=guide_ccharsize*ccharsize/100.0
IF (N_ELEMENTS(TCHARSIZE) EQ 1) THEN guide_tcharsize=guide_tcharsize*tcharsize/100.0
guide_thick=3.0*guide_thick/sf
guide_cthick=3.0*guide_cthick/sf
guide_border_thick=3.0*guide_border_thick/sf
guide_ticklen=guide_ticklen*100.0/sf
guide_levels_text=''
guide_lower=0L
guide_upper=0L
guide_xlog=0
guide_ylog=0

;Set postscript size and orientation.
A4=1
IF KEYWORD_SET(GUIDE_A5) THEN A4=0
IF KEYWORD_SET(GUIDE_LETTER) THEN A4=0
IF KEYWORD_SET(A4) THEN BEGIN
 psxsize='21.0'
 psysize='29.7'
ENDIF
IF KEYWORD_SET(GUIDE_LETTER) THEN BEGIN
 psxsize='21.59'
 psysize='27.94'
ENDIF 
IF KEYWORD_SET(GUIDE_A5) THEN BEGIN
 psxsize='14.8'
 psysize='21.0'
ENDIF 
IF (N_ELEMENTS(size) EQ 2) THEN BEGIN
 psxsize=SCROP((size)(1)/1000.0)
 psysize=SCROP((size)(0)/1000.0)
ENDIF

;Make up the Postscript initialisation command.
com='DEVICE, FILE=guide_psfile, /COLOR, BITS=8,'
IF KEYWORD_SET(GUIDE_PORTRAIT) THEN com=com+'/PORTRAIT, XSIZE='+psxsize+',YSIZE='+psysize+$
                                  ',XOFFSET=0.0, YOFFSET=0.0'
IF NOT KEYWORD_SET(GUIDE_PORTRAIT) THEN com=com+'/LANDSCAPE, XSIZE='+psysize+',YSIZE='+psxsize+$
                                  ',XOFFSET=0.0, YOFFSET='+psysize
IF KEYWORD_SET(EPS) THEN com=com+', /ENCAPSULATED'
res=EXECUTE(com)


;Set the text font. 
com='DEVICE, '
IF (guide_font EQ 1) THEN com=com+'/HELVETICA'
IF (guide_font EQ 2) THEN com=com+'/TIMES'
IF (guide_font EQ 3) THEN com=com+'/PALATINO'
IF (guide_font EQ 4) THEN com=com+'/COURIER'
IF (guide_font EQ 5) THEN com=com+'/AVANTGARDE, /BOOK'
IF (guide_font EQ 6) THEN com=com+'/SCHOOLBOOK'
IF (guide_font EQ 7) THEN com=com+'/BKMAN, /LIGHT'
IF (guide_bold EQ 1) THEN BEGIN
 IF ((guide_font LE 4) OR (guide_font EQ 6)) THEN com=com+', /BOLD'
ENDIF
IF (guide_italic EQ 1) THEN BEGIN
 IF ((guide_font EQ 2) OR (guide_font EQ 3) OR (guide_font EQ 6) OR $
     (guide_font EQ 7)) THEN com=com+', /ITALIC'
 IF ((guide_font EQ 1) OR (guide_font EQ 4) OR (guide_font EQ 5)) THEN com=com+ ', /OBLIQUE'
ENDIF
guide_textfont=com

;Set the contour font. 
com='DEVICE, '
IF (guide_cfont EQ 1) THEN com=com+'/HELVETICA'
IF (guide_cfont EQ 2) THEN com=com+'/TIMES'
IF (guide_cfont EQ 3) THEN com=com+'/PALATINO'
IF (guide_cfont EQ 4) THEN com=com+'/COURIER'
IF (guide_cfont EQ 5) THEN com=com+'/AVANTGARDE, /BOOK'
IF (guide_cfont EQ 6) THEN com=com+'/SCHOOLBOOK'
IF (guide_cfont EQ 7) THEN com=com+'/BKMAN, /LIGHT'
IF (guide_cbold EQ 1) THEN BEGIN
 IF ((guide_cfont LE 4) OR (guide_cfont EQ 6)) THEN com=com+', /BOLD'
ENDIF
IF (guide_citalic EQ 1) THEN BEGIN
 IF ((guide_cfont EQ 2) OR (guide_cfont EQ 3) OR (guide_cfont EQ 6) OR $
     (guide_cfont EQ 7)) THEN com=com+', /ITALIC'
 IF ((guide_cfont EQ 1) OR (guide_cfont EQ 4) OR (guide_cfont EQ 5)) THEN com=com+ ', /OBLIQUE'
ENDIF
guide_contourfont=com

;Set the title font. 
com='DEVICE, '
IF (guide_tfont EQ 1) THEN com=com+'/HELVETICA'
IF (guide_tfont EQ 2) THEN com=com+'/TIMES'
IF (guide_tfont EQ 3) THEN com=com+'/PALATINO'
IF (guide_tfont EQ 4) THEN com=com+'/COURIER'
IF (guide_tfont EQ 5) THEN com=com+'/AVANTGARDE, /BOOK'
IF (guide_tfont EQ 6) THEN com=com+'/SCHOOLBOOK'
IF (guide_tfont EQ 7) THEN com=com+'/BKMAN, /LIGHT'
IF (guide_tbold EQ 1) THEN BEGIN
 IF ((guide_tfont LE 4) OR (guide_tfont EQ 6)) THEN com=com+', /BOLD'
ENDIF
IF (guide_titalic EQ 1) THEN BEGIN
 IF ((guide_tfont EQ 2) OR (guide_tfont EQ 3) OR (guide_tfont EQ 6) OR $
     (guide_tfont EQ 7)) THEN com=com+', /ITALIC'
 IF ((guide_tfont EQ 1) OR (guide_tfont EQ 4) OR (guide_tfont EQ 5)) THEN com=com+ ', /OBLIQUE'
ENDIF
guide_titlefont=com



;Set the font size in pixels.
scaling=0.85
IF ((guide_font GE 2) AND (guide_font LE 4))THEN scaling=0.80
IF (guide_font GE 5) THEN scaling=0.85
guide_ypix=!D.Y_CH_SIZE*guide_charsize*scaling      
guide_xpix=!D.X_CH_SIZE*guide_charsize
ncols=20
xmin=0.0
xmax=0.0
ymin=0.0
ymax=0.0

gstruct={guide, $
         PORTRAIT:guide_portrait, $
         LETTER:guide_letter, $
         XPLOTS:guide_xplots, $
         YPLOTS:guide_yplots, $
         XOFFSET:guide_xoffset, $
         YOFFSET:guide_yoffset, $
         MARGIN:guide_margin, $
         XSIZE:guide_xsize, $
         YSIZE:guide_ysize, $
         XSPACING:guide_xspacing, $
         YSPACING:guide_yspacing, $
         SPACE1:guide_space1, $
         SPACE2:guide_space2, $
         SPACE3:guide_space3, $
         TICKLEN:guide_ticklen, $
         THICK:guide_thick, $
         CCOLOUR:guide_ccolour, $
         CTHICK:guide_cthick, $
         CSTYLE:guide_cstyle, $
         CB_WIDTH:guide_cb_width, $
         CB_HEIGHT:guide_cb_height, $
         BORDER_THICK:guide_border_thick, $
         FONT:guide_font, $
         CHARSIZE:guide_charsize, $
         BOLD:guide_bold, $
         ITALIC:guide_italic, $
         CFONT:guide_cfont, $
         CCHARSIZE:guide_ccharsize, $
         CBOLD:guide_cbold, $
         CITALIC:guide_citalic, $
	 TFONT:guide_tfont, $
         TCHARSIZE:guide_tcharsize, $
         TBOLD:guide_tbold, $
         TITALIC:guide_titalic, $
	 TEXTFONT:guide_textfont, $
	 CONTOURFONT:guide_contourfont, $
	 TITLEFONT:guide_titlefont, $
	 AXISTYPE:guide_axistype, $
         PSFILE:guide_psfile, $
         POSITION:guide_position, $
         SQUAREPLOT:guide_squareplot, $
	 ISOTROPIC:0, $
	 coords_established:0, $
	 XMIN:0.0, $
	 XMAX:0.0, $
	 YMIN:0.0, $
	 YMAX:0.0, $
	 PROJECTION:0, $
	 XLOG:0, $
	 YLOG:0, $
	 XPIX:guide_xpix, $
	 YPIX:guide_ypix, $
	 LEVELS:STRARR(256), $
	 LEVELS_NPTS:0, $
	 LOWER:1, $
	 UPPER:1, $ 
         NH:0, $
	 SH:0, $
	 ORTHO:0, $
	 MOLLWEIDE:0, $
	 ROBINSON:0, $
	 SATELLITE:[-99.0, -99.0], $
	 HIRES:0, $
	 SECTOR:0, $
	 CYLINDRICAL:0, $
	 LAND:0, $
	 OCEAN:0, $
	 COUNTRIES:0, $
	 OVERPLOT:0, $      
 	 CS1:[BYTARR(3, 256)],$
 	 CS2:[BYTARR(3, 256)],$  
         CS3:[BYTARR(3, 256)],$        
	 CS4:[BYTARR(3, 256)],$        
	 CS5:[BYTARR(3, 256)],$        	
	 CS1_NCOLS:0,$
	 CS2_NCOLS:0,$
	 CS3_NCOLS:0,$
	 CS4_NCOLS:0,$
	 CS5_NCOLS:0,$
         WINDOWS_LIB:windows_lib,$
         WINDOWS_VIEWER:windows_viewer, $
         LAKES:0 $
   } 
defsysv, '!guide', gstruct
;Load standard set of line and character thickesses and a colour table
!P.COLOR=1   
!P.THICK=!guide.thick
POS, xpos=1, ypos=1  ;Set first plot area
CS, SCALE=1 ;Load a colour scale in case the user forgets.
res=EXECUTE(!guide.textfont) ;Set the font.
END

