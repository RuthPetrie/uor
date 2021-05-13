PRO STIPPLE, FIELD=field, X=xpts, Y=ypts, MIN=min, MAX=max, SPACE=space, COL=col, SIZE=size, SYM=sym 
;Procedure to make stipple plots.
;(C) NCAS 2010

;Check !guide structure exists.
DEFSYSV, '!guide', exists=exists
IF (exists EQ 0) THEN BEGIN
 PRINT, ''
 PRINT, 'ERROR - PSOPEN must first be called to initiate a postscript file.'
 PRINT, ''
 STOP
ENDIF

;Basic data checks.
IF (((SIZE(field))(0) GT 2) OR  ((SIZE(field))(0) LT 2)) THEN BEGIN
  PRINT, ''
  PRINT, "CON ERROR - FIELD isn't 2 dimensional."
  HELP, FIELD
  PRINT, ''
  STOP
ENDIF
IF ((N_ELEMENTS(field) EQ 0) OR (N_ELEMENTS(xpts) EQ 0) OR (N_ELEMENTS(ypts) EQ 0)) THEN BEGIN
 PRINT, ''
 PRINT, "STIPPLE ERROR - FIELD, X and Y must all be set."
 HELP, FIELD, X, Y
 PRINT, ''
 STOP
ENDIF
s=(SIZE(xpts))(0)
IF (S EQ 1) THEN BEGIN
 IF (((SIZE(xpts))(1) NE (SIZE(field))(1)) OR ((SIZE(ypts))(1) NE (SIZE(field))(2))) THEN BEGIN
  PRINT, ''
  PRINT, "STIPPLE ERROR - FIELD, X and Y mismatch."
  x=xpts
  y=ypts
  HELP, field, x, y
  PRINT, ''
  STOP 
 ENDIF 
ENDIF
IF (S EQ 2) THEN BEGIN
 IF (N_ELEMENTS(xpts) NE N_ELEMENTS(ypts)) THEN BEGIN
  PRINT, ''
  PRINT, "STIPPLE ERROR - X and Y don't match."
  HELP, xpts, ypts
  PRINT, ''
  STOP
 ENDIF
ENDIF
IF ((N_ELEMENTS(min) EQ 0) OR (N_ELEMENTS(max) EQ 0)) THEN BEGIN
 PRINT, ''
 PRINT, 'STIPPLE ERROR - Must define a MIN and MAX value to stipple inbetween.'
 HELP, min, max
 PRINT, ''
 STOP
ENDIF

;Set defaults if unspecified.
IF (N_ELEMENTS(space) EQ 0) THEN space=200.0 ELSE space=200.0*space/100
IF (N_ELEMENTS(col) EQ 0) THEN col=1
IF (N_ELEMENTS(size) EQ 0) THEN size=20 ELSE size=20*size/100
IF (N_ELEMENTS(sym) EQ 0) THEN sym=3


;Work out region to test for data stippling.
pt0=CONVERT_COORD(!P.POSITION(0), !P.POSITION(1), /NORMAL, /TO_DEVICE)
pt1=CONVERT_COORD(!P.POSITION(2), !P.POSITION(3), /NORMAL, /TO_DEVICE)
pxmin=pt0(0)
pxmax=pt1(0)
pymin=pt0(1)
pymax=pt1(1)


;Loop over the data region in device coordinates plotting a symbol if point is within range min to max.
FOR iy=pymin+space/2, pymax, space DO BEGIN
 FOR ix=pxmin+space/2, pxmax, space DO BEGIN
  xval=ix
  yval=iy
  xtest=(ix-space/2-pxmin)/space
  IF ((xtest/2) EQ FIX(xtest/2)) THEN yval=yval-space/2
  pt=CONVERT_COORD(xval, yval, /DEVICE, /TO_DATA)
  IF (TOTAL(FINITE(pt)) EQ 3) THEN BEGIN
   val=REGRID(field, xpts, ypts, pt(0), pt(1))
   IF ((val GE min) AND (val LE max)) THEN GPLOT, X=pt(0), Y=pt(1), SYM=sym, SIZE=size, COL=col  
  ENDIF
 ENDFOR
ENDFOR

END

