PRO GSET, XMIN=xmin, XMAX=xmax, YMIN=ymin, YMAX=ymax, XLOG=xlog, $
          YLOG=ylog, TITLE=title, BCOL=bcol
;Procedure to set plotting area for non map plots.
;(C) NCAS 2010

;Check !guide structure exists.
DEFSYSV, '!guide', exists=exists
IF (exists EQ 0) THEN BEGIN
 PRINT, ''
 PRINT, 'ERROR - PSOPEN must first be called to initiate a postscript file.'
 PRINT, ''
 STOP
ENDIF

;Some basic check for keywords
IF (N_ELEMENTS(XMIN) EQ 0) THEN BEGIN
 PRINT, ''
 PRINT, 'SETPLOT ERROR - XMIN needs setting.'
 STOP
ENDIF
IF (N_ELEMENTS(XMAX) EQ 0) THEN BEGIN
 PRINT, ''
 PRINT, 'SETPLOT ERROR - XMAX needs setting.'
 STOP
ENDIF
IF (N_ELEMENTS(YMIN) EQ 0) THEN BEGIN
 PRINT, ''
 PRINT, 'SETPLOT ERROR - YMIN needs setting.'
 STOP
ENDIF
IF (N_ELEMENTS(YMAX) EQ 0) THEN BEGIN
 PRINT, ''
 PRINT, 'SETPLOT ERROR - YMAX needs setting.'
 STOP
ENDIF
IF ((YMAX EQ 0) AND KEYWORD_SET(YLOG)) THEN BEGIN
 PRINT, ''
 PRINT, 'SETPLOT ERROR - YMAX=0 and /YLOG specified.'
 PRINT, 'Cannot have a log of zero.'
 PRINT, ''
 STOP
ENDIF
IF ((XMAX EQ 0) AND KEYWORD_SET(XLOG)) THEN BEGIN
 PRINT, ''
 PRINT, 'SETPLOT ERROR - XMAX=0 and /XLOG specified.'
 PRINT, 'Cannot have a log of zero.'
 PRINT, ''
 STOP
ENDIF


;Put the plotting area into guide variables.
!guide.xmin=FLOAT(xmin)
!guide.xmax=FLOAT(xmax)
!guide.ymin=FLOAT(ymin)
!guide.ymax=FLOAT(ymax)
!map.projection=0

;Set area for plotting.
com='PLOT, [xmin, xmax],[ymin, ymax], XSTYLE=5, YSTYLE=5,'
com=com+'YRANGE=[ymin, ymax], XRANGE=[xmin, xmax], /NODATA,'
com=com+'CLIP=[xmin, ymin, xmax, ymax], /NOERASE'
!guide.xlog=0
!guide.ylog=0
IF KEYWORD_SET(xlog) THEN BEGIN
 com=com+', /XLOG'
 !guide.xlog=1
ENDIF
IF KEYWORD_SET(ylog) THEN BEGIN
 com=com+', /YLOG'
 !guide.ylog=1
ENDIF
res=EXECUTE(com)

;Fill with background colour if requested.
IF (N_ELEMENTS(BCOL) EQ 1) THEN BEGIN
 xpts=[xmin, xmin, xmax, xmax, xmin]
 ypts=[ymin, ymax, ymax, ymin, ymin]
 POLYFILL, xpts,ypts, COLOR=bcol 
ENDIF

;Add a title if requested.
IF KEYWORD_SET(TITLE) THEN BEGIN
 res=EXECUTE(!guide.titlefont)  ;Set the title font .
 
 charsize=!guide.tcharsize
 tlen=!guide.ticklen  ;Our tick length in pixels
 xpix=!guide.xpix     ;Width of text in pixels
 ypix=!guide.ypix     ;Height of text in pixels
 space1=!guide.space1
 space2=!guide.space2
 space3=!guide.space3
 IF (tlen LT 0) THEN offset=2*ypix+space3 ELSE offset=tlen+2*ypix+space3
 pt1=CONVERT_COORD(!P.POSITION(0), !P.POSITION(1), /NORM, /TO_DEVICE)
 pt2=CONVERT_COORD(!P.POSITION(2), !P.POSITION(3), /NORM, /TO_DEVICE)
 xmid=(pt2(0)-pt1(0))/2.0+pt1(0)
 XYOUTS, xmid, pt2(1)+offset, title, FONT=0, CHARSIZE=charsize, ALIGNMENT=0.5, /DEVICE	 
 
 res=EXECUTE(!guide.textfont) ;Set the font back again.
ENDIF

;Set the font back again.
com=!guide.textfont
res=EXECUTE(com)

;Flags that the coordinateds are established.
!guide.coords_established=1

END
