FUNCTION REGRID, field, x, y, xnew, ynew
;Perform bi-linear data regridding on a grid
;See http://en.wikipedia.org/wiki/Bilinear_interpolation for details on bilinear interpolation.
;
;field, x, y are the original field and coordinates.
;xnew, ynew are the output field and coordinates.
;(C) NCAS 2010


IF ((N_ELEMENTS(field) EQ 0) OR (N_ELEMENTS(x) EQ 0)  OR (N_ELEMENTS(y) EQ 0) $
     OR (N_ELEMENTS(xnew) EQ 0) OR (N_ELEMENTS(ynew) EQ 0) ) THEN BEGIN
 PRINT, ''
 PRINT, 'REGRID ERROR - field, , x, y, xnew, ynew must all be supplied'
 PRINT, ''
 IF (N_ELEMENTS(field) EQ 0) THEN PRINT, 'field not supplied'
 IF (N_ELEMENTS(x) EQ 0) THEN PRINT, 'x orig not supplied' 
 IF (N_ELEMENTS(y) EQ 0) THEN PRINT, 'y orig not supplied'
 IF (N_ELEMENTS(xnew) EQ 0) THEN PRINT, 'xnew not supplied'
 IF (N_ELEMENTS(ynew) EQ 0) THEN PRINT, 'ynew not supplied'
 STOP
ENDIF 

orig_field=field
orig_x=x
orig_y=y
orig_xnew=xnew
orig_ynew=ynew

fieldout=FLTARR(N_ELEMENTS(xnew), N_ELEMENTS(ynew))

;Set global flag if global data is input.
global=0
diffx=MAX(x)-MIN(x)
diffy=MAX(y)-MIN(y)
IF ((diffx GT 330) AND (diffx LE 360)) THEN BEGIN
 IF ((diffy GT 160) AND (diffy LE 180)) THEN BEGIN
  global=1
 ENDIF
ENDIF 

;Try to wrap data if not 360 degrees of longitude in data.
IF (KEYWORD_SET(global) AND ((MAX(x)-MIN(x)) NE 360.0)) THEN BEGIN
 diffx=x(1)-x(0)
 same=0
 FOR i=0, N_ELEMENTS(x)-2 DO BEGIN
  thisdiff=x(i+1)-x(i)-diffx
  IF (ABS(thisdiff) GT 0.1) THEN same=same+1
 ENDFOR
 IF (SAME EQ 0) THEN BEGIN
  IF (((MAX(x)+diffx) - MIN(x)) EQ 360) THEN BEGIN
   x=[x,orig_x(N_ELEMENTS(x)-1)+diffx]
   field=[field, field(0,*)]
  ENDIF
 ENDIF ELSE BEGIN
  PRINT, ''
  PRINT, 'REGRID ERROR - irregular spacing in longitude - cannot wrap this data.'
  PRINT, ''
  STOP
 ENDELSE
ENDIF


;Reverse y and field if necessary.
IF (y(0) GT y(N_ELEMENTS(y)-1)) THEN field=REVERSE(field,2)
IF (y(0) GT y(N_ELEMENTS(y)-1)) THEN y=REVERSE(y)

;Some basic checks on the input fields.

s=SIZE(field,/DIMENSIONS)
IF (N_ELEMENTS(s) NE 2) THEN BEGIN
  PRINT, ''
  PRINT, 'REGRID ERROR - Input grid has ', N_ELEMENTS(s), ' dimensions - only 2 dimensions allowed'
  PRINT, ''
  STOP
ENDIF
IF (s(0) NE N_ELEMENTS(x)) THEN BEGIN
  PRINT, ''
  PRINT, 'REGRID ERROR - Input field and input x dimension incorrect'
  PRINT, 'Input field has ',s(0),' columns and x dimension is ', N_ELEMENTS(x)
  STOP
ENDIF
IF (s(1) NE N_ELEMENTS(y)) THEN BEGIN
  PRINT, ''
  PRINT, 'REGRID ERROR - Input field and input y dimension incorrect'
  PRINT, 'Input field has ',s(1),' rows and y dimension is ', N_ELEMENTS(y)
  STOP
ENDIF




;Stop if outside limits of input grid.
;Try to adjust for longitude wrapping if outside of limits.
FOR ix=0,N_ELEMENTS(xnew)-1 DO BEGIN
 IF ((xnew(ix) LT  MIN(x)) OR (xnew(ix) GT MIN(x))) THEN BEGIN
  IF (xnew(ix) LT  MIN(x)) THEN BEGIN
     xnew(ix)=xnew(ix)+360.0
     IF ((xnew(ix) LT  MIN(x)) OR (xnew(ix) GT  MAX(x))) THEN BEGIN
       PRINT, 'Warning - requested regrid x= ', xnew(ix)-360.0,' is less than the minimum longitude.'
       ;PRINT, 'Fix input grid or requested regrid values'
       ;PRINT, 'Grid x values are ', x
       ;STOP
     ENDIF
  ENDIF
  IF (xnew(ix) GE  MAX(x)) THEN BEGIN
     xnew(ix)=xnew(ix)-360.0
     IF ((xnew(ix) LT  MIN(x))  OR (xnew(ix) GT  MAX(x))) THEN BEGIN
       PRINT, 'Warning - requested regrid longitude ', xnew(ix)+360.0,' is greater than the maximum longitude'
       ;PRINT, 'Fix input grid or requested regrid values'
       ;PRINT, 'Longitudes are ', x
       ;STOP
     ENDIF
  ENDIF  
 ENDIF
ENDFOR

IF KEYWORD_SET(global) THEN BEGIN
 ;Stop if outside limits of latitude - i.e. past the pole
 FOR iy=0,N_ELEMENTS(ynew)-1 DO BEGIN
  IF ((ynew(iy) LT  -90.0) OR (ynew(iy) GT 90.0)) THEN BEGIN
    PRINT, 'Requested regrid latitude ', ynew(iy), ' past the pole'
    STOP
  ENDIF
 ENDFOR

 ;Add an extra row at the top and bottom to cope with poles
 ;Rotate data around and calcluate the extra latitude points
 extrarow1=SHIFT(field(*,0), ROUND(N_ELEMENTS(x)/2.0))
 extrarow2=SHIFT(field(*,N_ELEMENTS(y)-1), ROUND(N_ELEMENTS(x)/2.0))
 field=[[extrarow1],[field],[extrarow2]]
 y=[-90.0-(ABS(-90.0-MIN(y))),y,90.0+ABS(90.0-y(N_ELEMENTS(y)-1))]
ENDIF


;Now we're ready to do the bi-linear interpolation.
xpts=N_ELEMENTS(xnew)
ypts=N_ELEMENTS(ynew)


;Circle over the input grid to get the new grid values.
FOR ix=0,xpts-1 DO BEGIN
 FOR iy=0,ypts-1 DO BEGIN

 myxpos=SIZE(WHERE(xnew(ix) GE x), /N_ELEMENTS)-1
 myypos=SIZE(WHERE(ynew(iy) GE y), /N_ELEMENTS)-1
 IF (myxpos EQ N_ELEMENTS(x)-1) THEN myxpos2=myxpos ELSE myxpos2=myxpos+1
 IF (myypos EQ N_ELEMENTS(y)-1) THEN myypos2=myypos ELSE myypos2=myypos+1 


  IF (ynew(iy) NE 90.0) THEN BEGIN
   IF (myxpos2 NE myxpos) THEN alpha=(xnew(ix)-x(myxpos))/(x(myxpos2)-(x(myxpos))) ELSE $
                           alpha=(xnew(ix)-x(myxpos))/1E-30
   newval1=field(myxpos,myypos)-(field(myxpos,myypos)-field(myxpos2,myypos))*alpha
   newval2=field(myxpos,myypos2)-(field(myxpos,myypos2)-field(myxpos2,myypos2))*alpha
   IF (myypos2 NE myypos) THEN alpha2=(ynew(iy)-y(myypos))/(y(myypos2)-(y(myypos))) ELSE $
                               alpha2=(ynew(iy)-y(myypos))/1E-30   
   newval3=newval1-(newval1-newval2)*alpha2
  ENDIF ELSE BEGIN
   newval3=field(0,N_ELEMENTS(y)-1)
  ENDELSE
  
  fieldout(ix,iy)=newval3
 ENDFOR
ENDFOR

;Return just a float if a single point.  Returning an array when a float is expected
;can cause unexpected array problems.
IF (N_ELEMENTS(fieldout) EQ 1) THEN fieldout=fieldout(0)

;Reset field, x, y and return interpolated field.
field=orig_field
x=orig_x
y=orig_y
xnew=orig_xnew
ynew=orig_ynew

RETURN, fieldout

END


