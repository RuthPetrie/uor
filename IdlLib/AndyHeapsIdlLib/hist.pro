PRO HIST, X=x, Y=y, COL=col, WIDTH=width, OFFSET=offset, TOWER=tower, $
	  THICK=thick, HORIZONTAL=horizontal, FILLCOL=fillcol, NOBORDER=noborder
;Procedure to plot histograms.
;(C) NCAS 2010

;Check !guide structure exists.
DEFSYSV, '!guide', exists=exists
IF (exists EQ 0) THEN BEGIN
 PRINT, ''
 PRINT, 'ERROR - PSOPEN must first be called to initiate a postscript file.'
 PRINT, ''
 STOP
ENDIF

IF (NOT KEYWORD_SET(HORIZONTAL)) THEN vertical=1
IF (N_ELEMENTS(WIDTH) EQ 1) THEN bwidth=200*FLOAT(width)/100
IF (N_ELEMENTS(WIDTH) EQ 0) THEN bwidth=200
IF (N_ELEMENTS(THICK) EQ 0) THEN thick=100
thick=thick*!guide.thick/100.0
IF (N_ELEMENTS(FILLCOL) EQ 1) THEN fillcol=INTARR(N_ELEMENTS(X))+fillcol
IF (NOT KEYWORD_SET(TOWER)) THEN BEGIN
 IF (N_ELEMENTS(X) NE N_ELEMENTS(Y)) THEN BEGIN
  PRINT, ''
  PRINT, 'HIST ERROR - Number of points in X and Y must be the same.'
  PRINT, 'X HAS ', SCROP(N_ELEMENTS(X)),' points and Y has ', SCROP(N_ELEMENTS(Y)), ' points.'
  PRINT, ''
  STOP
 ENDIF
 IF (N_ELEMENTS(offset) EQ 0) THEN offset=FLTARR(N_ELEMENTS(x))
 IF (N_ELEMENTS(offset) EQ 1) THEN offset=FLTARR(N_ELEMENTS(x))+offset
 IF (N_ELEMENTS(col) EQ 0) THEN col=1
 IF (N_ELEMENTS(FILLCOL) NE 0) AND (N_ELEMENTS(FILLCOL) NE N_ELEMENTS(X)) THEN BEGIN
  PRINT, ''
  PRINT, 'HIST ERROR - FILLCOL HAS ', SCROP(N_ELEMENTS(FILLCOL)),' elements and ', $
  	 'number of points is ', SCROP(N_ELEMENTS(x))
  PRINT, ''
  STOP
 ENDIF
 IF (N_ELEMENTS(OFFSET) NE 0) AND(N_ELEMENTS(OFFSET) NE N_ELEMENTS(X)) THEN BEGIN
  PRINT, ''
  PRINT, 'HIST ERROR - OFFSET HAS ', SCROP(N_ELEMENTS(OFFSET)),' elements and ', $
	 'number of points is ', SCROP(N_ELEMENTS(x))
  PRINT, ''
  STOP
 ENDIF
ENDIF


;Call HIST again if the TOWER keyword is set.
IF KEYWORD_SET(TOWER) THEN BEGIN
 s=SIZE(y)
 IF KEYWORD_SET(VERTICAL) THEN BEGIN
  FOR itower=0, s(2)-1 DO BEGIN
   IF (itower EQ 0) THEN offset=0 
   IF (itower EQ 1) THEN offset=y(*,0)
   IF (itower GT 1) THEN offset=TOTAL(y(*, 0:itower-1),2)
   HIST, X=x, Y=Y(*, itower), FILLCOL=fillcol(itower), WIDTH=width, OFFSET=offset
  ENDFOR
 ENDIF
 IF KEYWORD_SET(HORIZONTAL) THEN BEGIN
  s=SIZE(x)
  FOR itower=0, s(2)-1 DO BEGIN
   IF (itower EQ 0) THEN offset=0 
   IF (itower EQ 1) THEN offset=x(*, 0)
   IF (itower GT 1) THEN offset=TOTAL(x(*, 0:itower-1),2)
   HIST, X=x(*, itower), Y=y, FILLCOL=fillcol(itower), WIDTH=width, OFFSET=offset, /HORIZONTAL
  ENDFOR
 ENDIF 
ENDIF




;Vertical bars.
IF ((KEYWORD_SET(VERTICAL)) AND (NOT KEYWORD_SET(TOWER))) THEN BEGIN
 pt1=CONVERT_COORD(!P.POSITION(0), !P.POSITION(1), /NORMAL, /TO_DEVICE)
 pt2=CONVERT_COORD(!P.POSITION(0), !P.POSITION(1), /NORMAL, /TO_DATA)
 pt3=CONVERT_COORD(pt1(0)+bwidth, pt1(1), /DEVICE, /TO_DATA)
 barwidth=pt3(0)-pt2(0)
 FOR ix=0, N_ELEMENTS(X)-1 DO BEGIN
  xboxpts=[X(ix)-barwidth, X(ix)-barwidth, X(ix)+barwidth, X(ix)+barwidth, X(ix)-barwidth]
  yboxpts=[offset(ix), Y(ix)+offset(ix), Y(ix)+offset(ix), offset(ix), offset(ix)]
  IF (N_ELEMENTS(fillcol) NE 0) THEN POLYFILL, xboxpts, yboxpts, COLOR=FILLCOL(ix), NOCLIP=0
  IF (N_ELEMENTS(noborder) EQ 0) THEN PLOTS, xboxpts, yboxpts, COLOR=COL, NOCLIP=0, THICK=thick
 ENDFOR
ENDIF


;Horizontal bars.
IF ((KEYWORD_SET(HORIZONTAL)) AND (NOT KEYWORD_SET(TOWER))) THEN BEGIN
 pt1=CONVERT_COORD(!P.POSITION(0), !P.POSITION(1), /NORMAL, /TO_DEVICE)
 pt2=CONVERT_COORD(!P.POSITION(0), !P.POSITION(1), /NORMAL, /TO_DATA)
 pt3=CONVERT_COORD(pt1(0), pt1(1)+bwidth, /DEVICE, /TO_DATA)
 barwidth=pt3(1)-pt2(1)
 FOR iy=0, N_ELEMENTS(Y)-1 DO BEGIN
  xboxpts=[offset(iy), offset(iy), X(iy)+offset(iy), X(iy)+offset(iy), offset(iy)]
  yboxpts=[Y(iy)-barwidth, Y(iy)+barwidth, Y(iy)+barwidth, Y(iy)-barwidth, Y(iy)-barwidth]
  IF (N_ELEMENTS(fillcol) NE 0) THEN POLYFILL, xboxpts, yboxpts, COLOR=FILLCOL(iy), NOCLIP=0
  IF (N_ELEMENTS(noborder) EQ 0) THEN PLOTS, xboxpts, yboxpts, COLOR=COL, NOCLIP=0, THICK=thick
 ENDFOR
ENDIF


END
