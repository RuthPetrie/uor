PRO RGUNROT, XIN=xin, YIN=yin,  XOUT=xout, YOUT=yout, XPOLE=xpole, YPOLE=ypole
;Procedure to convert rotated grid to lon-lat coordinates.
;(C) NCAS 2010

;Basic error check.
IF (N_ELEMENTS(xin) EQ 0) THEN BEGIN
 PRINT, ''
 PRINT, 'RGUNROT ERROR - XIN not set.'
 PRINT, ''
 STOP
ENDIF
IF (N_ELEMENTS(yin) EQ 0) THEN BEGIN
 PRINT, ''
 PRINT, 'RGUNROT ERROR - YIN not set.'
 PRINT, ''
 STOP
ENDIF
IF (N_ELEMENTS(xpole) EQ 0) THEN BEGIN
 PRINT, ''
 PRINT, 'RGUNROT ERROR - XPOLE not set.'
 PRINT, ''
 STOP
ENDIF
IF (N_ELEMENTS(ypole) EQ 0) THEN BEGIN
 PRINT, ''
 PRINT, 'RGUNROT ERROR - YPOLE not set.'
 PRINT, ''
 STOP
ENDIF

time1=SYSTIME(/SECONDS)
;Form x and y arrays to hold grid coordinates.
nx=N_ELEMENTS(xin)
ny=N_ELEMENTS(yin)
x=FLTARR(nx, ny)
FOR iy=0, ny-1 DO BEGIN
 x(*, iy)=xin
ENDFOR
y=FLTARR(nx, ny)
FOR ix=0, nx-1 DO BEGIN
 y(ix, *)=yin
ENDFOR

;PI is single precision if x is a float else PI is double precision.
IF (SIZE(x, /TYPE) EQ 5) THEN PI=!DPI ELSE PI=!PI
;Tolerance limit.
TOL=1.0E-6
X0=XPOLE+180.0 MOD 360.0
IF (YPOLE GE 0.0) THEN BEGIN
 SINYPOLE=SIN(PI*YPOLE/180.0)
 COSYPOLE=COS(PI*YPOLE/180.0)
ENDIF ELSE BEGIN
 SINYPOLE=-SIN(PI*YPOLE/180.0)
 COSYPOLE=-COS(PI*YPOLE/180.0)
ENDELSE


XX=X MOD 360.0
pts=WHERE(XX GT 180, count)
IF (count GT 0) THEN XX(pts)=XX(pts)-360.0
pts=WHERE(xx LT -180, count)
IF (count GT 0) THEN XX(pts)=XX(pts)+360.0
XX=PI*XX/180.0
YY=PI*Y/180.0


ARG=COSYPOLE*COS(XX)*COS(YY)+SIN(YY)*SINYPOLE
pts=WHERE(arg GE 1.0, count)
IF (count GT 0) THEN arg(pts)=1.0
pts=WHERE(arg LE -1.0, count)
IF (count GT 0) THEN arg(pts)=-1.0
AY=ASIN(ARG)
Y=180.0*AY/PI


T1=COS(YY)*COS(XX)*SINYPOLE-SIN(YY)*COSYPOLE
T2=COS(AY)


AX=FLTARR(nx, ny)

pts=WHERE(T2 LT tol, count)
IF (count GT 0) THEN AX(pts)=0.0

pts=WHERE(T2 GE tol, count)
IF (count GT 0) THEN BEGIN
 ARG=T1/T2
 pts2=WHERE(arg GT 1.0, count)
 IF (count GT 0) THEN arg(pts2)=1.0
 pts2=WHERE(arg LT -1.0, count)
 IF (count GT 0) THEN arg(pts2)=-1.0
 ARG=180.0*ACOS(ARG)/PI
 AX(pts)=arg
 pts3=WHERE(xx GE 0.0, count)
 IF (count GE 0) THEN ax(pts3)=ABS(ax(pts3))
 pts3=WHERE(xx LT 0.0, count)
 IF (count GT 0) THEN ax(pts3)=-1.0*ABS(ax(pts3)) 
 AX=AX+X0
 ;pts2=WHERE(arg GE 1.0-T1, count)
 ;IF (count GT 0) THEN ax(pts2)=1.0-T1
 ;AX(pts2)=180.0*ACOS(AX(pts2))/PI
 ;pts3=WHERE(xx GE 0.0, count)
 
ENDIF

                                           

;Scale x between 0 and 360
pts=WHERE(AX GE 360.0, count) 
IF (count GT 0) THEN AX(pts)=AX(pts)-360.0
pts=WHERE(AX LT 0.0, count) 
IF (count GT 0) THEN AX(pts)=AX(pts)+360.0
X=AX


;Return grid locations to calling routine.
XOUT=x
YOUT=y
;Return just one value if that is all there is.
IF (N_ELEMENTS(xout) EQ 1) THEN xout=xout(0)
IF (N_ELEMENTS(yout) EQ 1) THEN yout=yout(0)

END

