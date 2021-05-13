PRO RGROT,  XIN=xin, YIN=yin,  XOUT=xout, YOUT=yout, XPOLE=xpole, YPOLE=ypole
;Procedure to convert lon-lat coordinates to rotated grid coordinates.
;(C) NCAS 2010

COMPILE_OPT  DEFINT32 ;Use longword integers.

;Basic error check.
IF (N_ELEMENTS(xin) EQ 0) THEN BEGIN
 PRINT, ''
 PRINT, 'RGROT ERROR - XIN not set.'
 PRINT, ''
 STOP
ENDIF
IF (N_ELEMENTS(yin) EQ 0) THEN BEGIN
 PRINT, ''
 PRINT, 'RGROT ERROR - YIN not set.'
 PRINT, ''
 STOP
ENDIF
IF (N_ELEMENTS(xpole) EQ 0) THEN BEGIN
 PRINT, ''
 PRINT, 'RGROT ERROR - XPOLE not set.'
 PRINT, ''
 STOP
ENDIF
IF (N_ELEMENTS(ypole) EQ 0) THEN BEGIN
 PRINT, ''
 PRINT, 'RGROT ERROR - YPOLE not set.'
 PRINT, ''
 STOP
ENDIF


;Define output arrays.
xout=fltarr(N_ELEMENTS(xin))
yout=fltarr(N_ELEMENTS(yin))


;PI is single precision if x is a float else it is double precision.
IF (SIZE(x, /TYPE) EQ 5) THEN PI=!DPI ELSE PI=!PI
;Tolerance limit.
TOL=1.0E-6 


;Scale xpole to range -180 to 180.
xpole_orig=xpole
IF (xpole GT 180.0) THEN  xpole=xpole-360.0

;Latitude of zero meridian.
x_zero=xpole+180.


;Sine and cosine of latitude of eq pole
IF (ypole GE 0.0) THEN BEGIN
  sin_ypole=SIN(ypole*pi/180.0)
  cos_ypole=COS(ypole*pi/180.0)
ENDIF ELSE BEGIN
  sin_ypole=-SIN(ypole*pi/180.0)
  cos_ypole=-COS(ypole*pi/180.0)
ENDELSE


;Transform to rotated grid.
npts=N_ELEMENTS(xin)
FOR ix=0, npts-1 DO BEGIN

 ;Scale longitude to range -180 to +180 degs
 xpt=xin(ix)-x_zero
 IF(xpt GT 180.0) THEN xpt=xpt-360.
 IF(xpt LE -180.0) THEN xpt=xpt+360.

 ;Convert latitude & longitude to radians
 xpt=xpt*pi/180.0
 ypt=yin(ix)*pi/180.0

 ;Calculate latitude.
 ARG=-cos_ypole*COS(xpt)*COS(ypt)+SIN(ypt)*sin_ypole
 ARG=MIN([ARG,1.0])
 ARG=MAX([ARG,-1.0])
 ypt2=ASIN(ARG)
 yout(ix)=ypt2*180.0/pi

 ;Calculate longitude.
 t1=(COS(ypt)*COS(xpt)*sin_ypole+SIN(ypt)*cos_ypole)
 t2=COS(ypt2)
 IF(t2 LT tol) THEN BEGIN
  xpt2=0.0
 ENDIF ELSE BEGIN
  ARG=t1/t2
  ARG=MIN([ARG,1.0])
  ARG=MAX([ARG,-1.0])
  xpt2=ACOS(ARG)*180.0/pi
  IF (xpt GE 0) THEN xpt2=ABS(xpt2) ELSE xpt2=-1.0*ABS(xpt2)
 ENDELSE

 ;Scale longitude to range 0 to 360 degs
 IF(xpt2 GE 360.0) THEN xpt2=xpt2-360.0
 IF(xpt2 LT 0.0) THEN xpt2=xpt2+360.0
 xout(ix)=xpt2

ENDFOR

;Reset xpole.
xpole=xpole_orig

;Return just one value if that is all there is.
IF (N_ELEMENTS(xout) EQ 1) THEN xout=xout(0)
IF (N_ELEMENTS(yout) EQ 1) THEN yout=yout(0)

END
