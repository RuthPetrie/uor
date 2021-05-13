PRO GPLOT, X=x, Y=y, COL=col, STYLE=style, LABELS=labels, SYM=sym, $
           LEGPOS=legpos, NOLEGENDBOX=nolegendbox, LEGEND=legend, $
	   THICK=thick_orig, NOLINES=nolines, LEGCOL=legcol, $
	   LEGXOFFSET=legxoffset, LEGYOFFSET=legyoffset, BORDERSPACE=borderspace, $
	   BELOW=below, ABOVE=above, DEVICE=device, $
	   TEXT=text, ALIGN=align, SIZE=size, CHARSIZE=charsize, FONT=font, FILLCOL=fillcol, $
	   BOLD=bold, ITALIC=italic, ORIENTATION=orientation, LINEFILL=LINEFILL, $
	   SPACING=spacing, VALIGN=valign, CLIP=clip     
;Procedure to plot lines, text and filled polygons on plots.
;(C) NCAS 2010

;Check !guide structure exists.
DEFSYSV, '!guide', exists=exists
IF (exists EQ 0) THEN BEGIN
 PRINT, ''
 PRINT, 'ERROR - PSOPEN must first be called to initiate a postscript file.'
 PRINT, ''
 STOP
ENDIF

;Check coordinates are established.
IF NOT KEYWORD_SET(device) THEN BEGIN
 IF (!guide.coords_established EQ 0) THEN BEGIN
  PRINT, ''
  PRINT, 'GPLOT error - MAP or GSET must be called first to establish coordinates.'
  PRINT, ''
  STOP
 ENDIF
ENDIF

;Some basic checks
sz=N_ELEMENTS(SIZE(X, /DIMENSIONS))
sz2=N_ELEMENTS(SIZE(Y, /DIMENSIONS))
IF ((sz EQ 1) AND (sz2 EQ 1)) THEN xy=1
IF ((sz EQ 1) AND (sz2 EQ 2)) THEN xy=1
IF ((sz EQ 2) AND (sz2 EQ 1)) THEN yx=1
IF ((sz EQ 2) AND (sz2 EQ 2)) THEN BEGIN
 X=REFORM(X, N_ELEMENTS(X))
 Y=REFORM(Y, N_ELEMENTS(Y))
 sz=1
 sz2=1
 xy=1
ENDIF


IF KEYWORD_SET(xy) THEN BEGIN
 IF (sz2 EQ 1) THEN nlines=1
 IF (sz2 EQ 2) THEN nlines=(SIZE(Y))(2)
ENDIF
IF KEYWORD_SET(yx) THEN BEGIN
 IF (sz EQ 1) THEN nlines=1
 IF (sz EQ 2) THEN nlines=(SIZE(X))(2)
ENDIF

IF ((sz EQ 0) OR (sz GT 2) OR (sz2 EQ 0) OR (sz2 GT 2)) THEN BEGIN
 PRINT, ''
 PRINT, 'GPLOT ERROR - X and Y have incorrect dimensions:
 PRINT, 'X=', N_ELEMENTS(sz), ' dimensions.'
 PRINT, 'Y=', N_ELEMENTS(sz2), ' dimensions.'
 PRINT, 'The input data needs to have 1 or 2 dimensions to use GPLOT.'
 PRINT, ''
 STOP
ENDIF
IF (((N_ELEMENTS(x) EQ 1) AND (N_ELEMENTS(y) NE 1)) OR $
    ((N_ELEMENTS(y) EQ 1) AND (N_ELEMENTS(x) NE 1))) THEN BEGIN
 PRINT, ''
 PRINT, 'GPLOT ERROR - X and Y need the same number of points:
 HELP, x, y
 PRINT, ''
 STOP
ENDIF    


IF (N_ELEMENTS(thick_orig) EQ 0) THEN thick_orig=INTARR(nlines)+100
thick=thick_orig
IF (N_ELEMENTS(THICK) EQ 1) THEN THICK=INTARR(nlines)+thick(0)
IF (N_ELEMENTS(COL) EQ 0) THEN COL=INTARR(nlines)+1
IF (N_ELEMENTS(COL) EQ 1) THEN COL=INTARR(nlines)+col(0)
IF (N_ELEMENTS(STYLE) EQ 0) THEN STYLE=INTARR(nlines)
IF (N_ELEMENTS(STYLE) EQ 1) THEN STYLE=INTARR(nlines)+style(0)
IF KEYWORD_SET(nolines) THEN style=INTARR(nlines)-1
IF (N_ELEMENTS(LABELS) EQ 0) THEN LABELS=STRARR(nlines)
IF (nlines NE N_ELEMENTS(labels)) THEN BEGIN
 PRINT, ''
 PRINT, 'GPLOT ERROR - number of lines not equal to the number of labels'
 PRINT, 'No of lines=', SCROP(nlines), ', No of labels=', SCROP(N_ELEMENTS(labels))
 PRINT, ''
 STOP
ENDIF
IF (nlines NE N_ELEMENTS(thick)) THEN BEGIN
 PRINT, ''
 PRINT, 'GPLOT ERROR - number of lines not equal to the number of THICK'
 PRINT, 'No of lines=', SCROP(nlines), ', No of THICK=', SCROP(N_ELEMENTS(thick))
 PRINT, ''
 STOP
ENDIF
IF (nlines NE N_ELEMENTS(style)) THEN BEGIN
 PRINT, ''
 PRINT, 'GPLOT ERROR - number of lines not equal to the number of STYLE'
 PRINT, 'No of lines=', SCROP(nlines), ', No of STYLE=', SCROP(N_ELEMENTS(style))
 PRINT, ''
 STOP
ENDIF
IF (nlines NE N_ELEMENTS(col)) THEN BEGIN
 PRINT, ''
 PRINT, 'GPLOT ERROR - number of lines not equal to the number of COL'
 PRINT, 'No of lines=', SCROP(nlines), ', No of COL=', SCROP(N_ELEMENTS(col))
 PRINT, '' 
 STOP
ENDIF
IF ((N_ELEMENTS(sym) GT 0) AND (nlines NE N_ELEMENTS(sym))) THEN BEGIN
 PRINT, ''
 PRINT, 'GPLOT ERROR - number of lines not equal to the number of STYLE'
 PRINT, 'No of lines=', SCROP(lines), ', No of symbols=', SCROP(N_ELEMENTS(sym))
 PRINT, '' 
 STOP
ENDIF
IF (N_ELEMENTS(text) GT 0) THEN BEGIN
 IF ((N_ELEMENTS(X) NE N_ELEMENTS(y))  OR (N_ELEMENTS(X) NE N_ELEMENTS(text))) THEN BEGIN
  PRINT, ''
  PRINT, 'GPLOT ERROR - number of elements of x, y, text must be the same.'
  HELP, x, y, text
  PRINT, ''
  STOP
 ENDIF
ENDIF

IF (N_ELEMENTS(COL) EQ 0) THEN COL=INTARR(nlines)+1
IF (N_ELEMENTS(FONT) EQ 0) THEN font=!guide.font
IF (N_ELEMENTS(CHARSIZE) EQ 1) THEN charsize=!guide.charsize*charsize/100.0
IF (N_ELEMENTS(CHARSIZE) EQ 0) THEN charsize=!guide.charsize
IF (N_ELEMENTS(ALIGN) EQ 0) THEN align=0.5
IF (N_ELEMENTS(ORIENTATION) EQ 0) THEN orientation=0.0
IF (N_ELEMENTS(SIZE) EQ 1) THEN symsize=1.5*size/100.0 ELSE symsize=1.5
thick=thick*!guide.thick/100.0
IF (N_ELEMENTS(EBARLEN) EQ 0) THEN ebarlen=400
IF (N_ELEMENTS(CLIP) EQ 0) THEN clip=0

;Set the font if necessary.
IF (N_ELEMENTS(TEXT) NE 0) THEN BEGIN
 com='DEVICE, '
 IF (FONT EQ 1) THEN com=com+'/HELVETICA'
 IF (FONT EQ 2) THEN com=com+'/TIMES'
 IF (FONT EQ 3) THEN com=com+'/PALATINO'
 IF (FONT EQ 4) THEN com=com+'/COURIER'
 IF (FONT EQ 5) THEN com=com+'/AVANTGARDE, /BOOK'
 IF (FONT EQ 6) THEN com=com+'/SCHOOLBOOK'
 IF (FONT EQ 7) THEN com=com+'/BKMAN, /LIGHT'
 IF KEYWORD_SET(BOLD) THEN BEGIN
  IF ((FONT LE 4) OR (FONT EQ 6)) THEN com=com+', /BOLD'
 ENDIF
 IF KEYWORD_SET(ITALIC) THEN BEGIN
  IF ((FONT EQ 2) OR (FONT EQ 3) OR (FONT EQ 6) OR (FONT EQ 7)) THEN com=com+', /ITALIC'
  IF ((FONT EQ 1) OR (FONT EQ 4) OR (FONT EQ 5)) THEN com=com+ ', /OBLIQUE'
 ENDIF
 res=EXECUTE(com)
ENDIF

;Fill below and fill above section.
IF ((N_ELEMENTS(ABOVE) GE 1) OR (N_ELEMENTS(BELOW) GE 1)) THEN BEGIN
 FOR ix=0, N_ELEMENTS(X)-2 DO BEGIN
  x0=X(ix)
  x1=X(ix+1)
  y0=Y(ix)
  y1=Y(ix+1)
  
  ;Below section.
  IF (N_ELEMENTS(BELOW) GE 1) THEN BEGIN
   BCOL=BELOW(0)
   BVAL=0.0
   IF (N_ELEMENTS(BELOW) EQ 2) THEN BVAL=BELOW(1)
   xcoords=[x0,x0,x1,x1,x0]
   ycoords=[BVAL, y0, y1, BVAL, BVAL]
   IF ((y0 LE BVAL) AND (y1 LE BVAL)) THEN POLYFILL, xcoords, ycoords, COLOR=BCOL, NOCLIP=0
   IF ((y0 LT BVAL) AND (y1 GT BVAL)) THEN BEGIN
    theta=(ATAN((y1-y0)/(x1-x0)))
    x2=(BVAL-y0)/TAN(theta)+x0
    xcoords=[x0, x0, x2, x0]
    ycoords=[y0, BVAL, BVAL, y0]
    POLYFILL, xcoords, ycoords, COLOR=BCOL, NOCLIP=0
   ENDIF
   IF ((y0 GT BVAL) AND (y1 LT BVAL)) THEN BEGIN
    theta=(ATAN((y1-y0)/(x1-x0)))
    x2=(BVAL-y0)/TAN(theta)+x0
    xcoords=[x2, x1, x1, x2]
    ycoords=[BVAL, BVAL, y1, BVAL]
    POLYFILL, xcoords, ycoords, COLOR=BCOL, NOCLIP=0
   ENDIF   
  ENDIF
  
  ;Above section.
  IF (N_ELEMENTS(ABOVE) GE 1) THEN BEGIN
   ACOL=ABOVE(0)
   AVAL=0.0
   IF (N_ELEMENTS(ABOVE) EQ 2) THEN AVAL=ABOVE(1)
   xcoords=[x0,x0,x1,x1,x0] 
   ycoords=[AVAL, y0, y1, AVAL, AVAL]  
   IF ((y0 GE AVAL) AND (y1 GE AVAL)) THEN POLYFILL, xcoords, ycoords, COLOR=ACOL, NOCLIP=0  
   IF ((y0 LT AVAL) AND (y1 GT AVAL)) THEN BEGIN
    theta=(ATAN((y1-y0)/(x1-x0)))
    x2=(AVAL-y0)/TAN(theta)+x0
    xcoords=[x2, x1, x1, x2]
    ycoords=[AVAL, y1, AVAL, AVAL]
    POLYFILL, xcoords, ycoords, COLOR=ACOL, NOCLIP=0
   ENDIF  
   IF ((y0 GT AVAL) AND (y1 LT AVAL)) THEN BEGIN
    theta=(ATAN((y1-y0)/(x1-x0)))
    x2=(AVAL-y0)/TAN(theta)+x0
    xcoords=[x0, x0, x2, x0]
    ycoords=[AVAL, y0, AVAL, AVAL]
    POLYFILL, xcoords, ycoords, COLOR=ACOL, NOCLIP=0
   ENDIF   
  ENDIF
  
 ENDFOR
ENDIF



;Polygon filling - colour.
IF (N_ELEMENTS(FILLCOL) EQ 1) THEN BEGIN
 com='POLYFILL, X, Y, COLOR=fillcol'
 IF KEYWORD_SET(clip) THEN com=com+',CLIP=[!guide.xmin, !guide.ymin, !guide.xmax, !guide.ymax]'
 IF KEYWORD_SET(clip) THEN com=com+', NOCLIP=0'
 IF KEYWORD_SET(DEVICE) THEN com=com+', /DEVICE'
 res=EXECUTE(com)
ENDIF

;Polygon filling - line filling.
IF KEYWORD_SET(LINEFILL) THEN BEGIN
 com='POLYFILL, X, Y, /LINE_FILL, THICK=THICK, COLOR=col(0)'
 ;IF (N_ELEMENTS(COL) EQ 1) THEN com=com+', COLOR=col'
 IF (N_ELEMENTS(SPACING) EQ 1) THEN com=com+', SPACING=spacing'
 IF (N_ELEMENTS(ORIENTATION) EQ 1) THEN com=com+', ORIENTATION=orientation'
 IF KEYWORD_SET(DEVICE) THEN com=com+', /DEVICE'
 res=EXECUTE(com)
ENDIF

;Text plotting.
IF (N_ELEMENTS(TEXT) GT 0) THEN BEGIN
 FOR i=0, N_ELEMENTS(text)-1 DO BEGIN
  y_extra=0.0
  IF (N_ELEMENTS(valign) EQ 0) THEN valign=0.0
  scaling=0.85
  IF ((font GE 2) AND (font LE 3)) THEN scaling=0.75
  IF (font EQ 4) THEN scaling=0.70
  ysize=!D.Y_CH_SIZE*charsize*scaling
  IF (valign EQ 0.0) THEN y_extra=0.0
  IF (valign EQ 0.5) THEN y_extra=ysize/2.0
  IF (valign EQ 1.0) THEN y_extra=ysize
  IF KEYWORD_SET(DEVICE) THEN BEGIN
   xpt=x(i)
   ypt=y(i)
  ENDIF ELSE BEGIN
   pt=CONVERT_COORD(x(i), y(i), /DATA, /TO_DEVICE)
   xpt=pt(0)
   ypt=pt(1)
  ENDELSE  
  com='XYOUTS, xpt, ypt-y_extra, text(i)'
  com=com+', FONT=0, CHARSIZE=charsize, ALIGN=align, ORIENTATION=orientation, /DEVICE'
  IF (N_ELEMENTS(col) EQ 1) THEN com=com+', COLOR=col'
  res=EXECUTE(com)
 ENDFOR
ENDIF


;Symbol plotting.
IF ((N_ELEMENTS(SYM) EQ 1) AND (N_ELEMENTS(X) EQ 1) AND (N_ELEMENTS(Y) EQ 1)) THEN BEGIN
; print, 'in symbol plotting - symsize is ', symsize
 com='PLOTS, X, Y, THICK=thick, COLOR=col, PSYM=GSYM(sym)'
 com=com+', SYMSIZE=symsize'
 IF KEYWORD_SET(clip) THEN com=com+', CLIP=[!guide.xmin, !guide.ymin, !guide.xmax, !guide.ymax], NOCLIP=0 '
 IF KEYWORD_SET(DEVICE) THEN com=com+', /DEVICE'
 res=EXECUTE(com)
 nlines=-1
ENDIF

;Line plotting.
symmult=1
IF (N_ELEMENTS(text) EQ 0) THEN BEGIN
 IF ((N_ELEMENTS(SYM) GE 1) AND (NOT KEYWORD_SET(NOLINES))) THEN symmult=-1
 FOR i=0, nlines-1 DO BEGIN
  linecol=COL(i) 
  IF KEYWORD_SET(xy) THEN com='PLOTS, X, Y(*,i), '
  IF KEYWORD_SET(yx) THEN com='PLOTS, X(*,i), Y, '
  IF KEYWORD_SET(clip) THEN com=com+'CLIP=[!guide.xmin, !guide.ymin, !guide.xmax, !guide.ymax]'
  IF KEYWORD_SET(clip) THEN com=com+', NOCLIP=0, '
  com=com+'THICK=thick(i), COLOR=linecol'
  symmult2=symmult
  IF (N_ELEMENTS(STYLE) GT 0) THEN BEGIN
   com=com+', LINESTYLE=STYLE(i)'
   IF (style(i) EQ -1) THEN symmult2=1
  ENDIF 
  IF (N_ELEMENTS(SYM) GE 1) THEN com=com+', PSYM=symmult2*GSYM(sym(i))'
  com=com+', SYMSIZE=symsize'
  IF KEYWORD_SET(DEVICE) THEN com=com+', /DEVICE'
  IF ((NOT KEYWORD_SET(NOLINES)) OR (N_ELEMENTS(SYM) GT 0)) THEN res=EXECUTE(com)
 ENDFOR
ENDIF

;Plot legend if required
IF KEYWORD_SET(LEGEND) THEN BEGIN
 IF (NOT KEYWORD_SET(LEGPOS)) THEN legpos=12
 com='GLEGEND, LABELS=labels, COL=col, LEGPOS=legpos'
 IF KEYWORD_SET(STYLE) THEN com=com+', STYLE=style'
 IF KEYWORD_SET(SYM) THEN com=com+', SYM=sym, SIZE=size'
 IF KEYWORD_SET(LEGXOFFSET) THEN com=com+', LEGXOFFSET=legxoffset'
 IF KEYWORD_SET(LEGYOFFSET) THEN com=com+', LEGYOFFSET=legyoffset'
 IF KEYWORD_SET(BORDERSPACE) THEN com=com+', BORDERSPACE=borderspace'
 res=EXECUTE(com)	      
ENDIF


;Set the font back again.
IF (N_ELEMENTS(TEXT) NE 0) THEN BEGIN
 com=!guide.textfont
 res=EXECUTE(com)	      
ENDIF

END


