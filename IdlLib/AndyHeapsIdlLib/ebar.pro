PRO EBAR, X=x, Y=y, COL=col, THICK=thick,  DEVICE=device, $
	  ERROR_X=error_x, ERROR_y=error_y, WIDTH=width, $
	  BOX=box, PROB=prob, FILLCOL=fillcol 	  
;Procedure to plot error bars on plots.
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
IF (!guide.coords_established EQ 0) THEN BEGIN
 PRINT, ''
 PRINT, 'EBAR error - MAP or GSET must be called first to establish coordinates.'
 PRINT, ''
 STOP
ENDIF

;Setup some parameters and do a basic check of X and Y.
IF (N_ELEMENTS(COL) EQ 0) THEN COL=1
IF (N_ELEMENTS(THICK) EQ 0) THEN thick=100
thick=thick*!guide.thick/100.0
IF (N_ELEMENTS(WIDTH) EQ 0) THEN width=100.0
width=200.0*width/100
IF (N_ELEMENTS(X) NE 1) THEN BEGIN
 PRINT, ''
 PRINT, 'EBAR ERROR - data has incorrect dimensions:
 PRINT, 'X has ', N_ELEMENTS(X), ' points.'
 PRINT, 'and only one point can be plotted at a time.
 PRINT, ''
 STOP
ENDIF
IF ((N_ELEMENTS(BOX) EQ 0) AND (N_ELEMENTS(PROB) EQ 0)) THEN BEGIN
 IF (N_ELEMENTS(Y) NE 1) THEN BEGIN
  PRINT, ''
  PRINT, 'EBAR ERROR - data has incorrect dimensions:
  PRINT, 'Y has ', N_ELEMENTS(Y), ' points.'
  PRINT, 'and only one point can be plotted at a time.
  PRINT, ''
  STOP
 ENDIF
ENDIF 
IF (N_ELEMENTS(BOX) EQ 5) THEN BEGIN
 ;Check in ascending order.
 FOR iy=1,4 DO BEGIN
  IF (BOX(iy)-BOX(iy-1) LT 0) THEN BEGIN
   PRINT, ''
   PRINT, 'EBAR error - BOX not in ascending order.'
   PRINT, 'Routine requires min, 25%, median, 75%, max.'
   PRINT, 'Parameters passed are ', BOX
   PRINT, ''
   STOP
  ENDIF
 ENDFOR
ENDIF
IF (N_ELEMENTS(PROB) EQ 7) THEN BEGIN
 ;Check in ascending order.
 FOR iy=1,6 DO BEGIN
  IF (PROB(iy)-prob(iy-1) LT 0) THEN BEGIN
   PRINT, ''
   PRINT, 'EBAR error - PROB not in ascending order.'
   PRINT, 'Routine requires min, 10%, 25%, median, 75%, 90%, max.'
   PRINT, 'Parameters passed are ', PROB
   PRINT, ''
   STOP
  ENDIF
 ENDFOR
ENDIF
 
 
 
 
 
 ;Basic error bar plotting.
;X error bars.
IF (N_ELEMENTS(ERROR_X) NE 0) THEN BEGIN
 sz=N_ELEMENTS(ERROR_X)
 IF (sz EQ 1) THEN BEGIN
  exmin=X-ERROR_X
  exmax=X+ERROR_X
 ENDIF
 IF (sz EQ 2) THEN BEGIN
  exmin=X-ERROR_X(0)
  exmax=X+ERROR_X(1)
 ENDIF    
 pt=CONVERT_COORD(exmin, Y, /DATA, /TO_DEVICE)
 xmin=pt(0)
 pt=CONVERT_COORD(exmax, Y, /DATA, /TO_DEVICE)
 xmax=pt(0)
 ypt=pt(1)  
 PLOTS, [xmin, xmax], [ypt, ypt], THICK=thick, COLOR=col, /DEVICE
 PLOTS, [xmin, xmin], [ypt-width, ypt+width], THICK=thick, COLOR=col, /DEVICE
 PLOTS, [xmax, xmax], [ypt-width, ypt+width], THICK=thick, COLOR=col, /DEVICE
ENDIF 

;Y error bars.
IF (N_ELEMENTS(ERROR_Y) NE 0) THEN BEGIN
 sz=N_ELEMENTS(ERROR_Y)
 IF (sz EQ 1) THEN BEGIN
  eymin=Y-ERROR_Y
  eymax=Y+ERROR_Y
 ENDIF
 IF (sz EQ 2) THEN BEGIN
  eymin=Y-ERROR_Y(0)
  eymax=Y+ERROR_Y(1)
 ENDIF    
 pt=CONVERT_COORD(X, eymin, /DATA, /TO_DEVICE)
 ymin=pt(1)
 pt=CONVERT_COORD(X, eymax, /DATA, /TO_DEVICE)
 xpt=pt(0)
 ymax=pt(1)  
 PLOTS, [xpt, xpt], [ymin, ymax], THICK=thick, COLOR=col, /DEVICE
 PLOTS, [xpt-width, xpt+width], [ymin, ymin], THICK=thick, COLOR=col, /DEVICE
 PLOTS, [xpt-width, xpt+width], [ymax, ymax], THICK=thick, COLOR=col, /DEVICE
ENDIF 



;Box and whisker error bars.
IF (N_ELEMENTS(BOX) EQ 5) THEN BEGIN
 ;Get device coordinates of XY point.
 pts=CONVERT_COORD(REPLICATE(X,5), BOX, /DATA, /TO_DEVICE)
 ypts=pts(1, *)
 xpt=pts(0,0)
 PLOTS, [xpt-width/2, xpt+width/2], [ypts(0), ypts(0)], THICK=thick, COLOR=col, /DEVICE
 PLOTS, [xpt-width/2, xpt+width/2], [ypts(4), ypts(4)], THICK=thick, COLOR=col, /DEVICE
 PLOTS, [xpt, xpt], [ypts(0), ypts(1)], THICK=thick, COLOR=col, /DEVICE
 PLOTS, [xpt, xpt], [ypts(3), ypts(4)], THICK=thick, COLOR=col, /DEVICE
 xptsbox=[xpt-width, xpt-width, xpt+width, xpt+width, xpt-width]
 yptsbox=[ypts(1), ypts(3), ypts(3), ypts(1), ypts(1)]
 IF (N_ELEMENTS(FILLCOL) EQ 1) THEN POLYFILL, xptsbox, yptsbox, COLOR=fillcol , /DEVICE
 PLOTS, xptsbox, yptsbox, THICK=thick, COLOR=col, /DEVICE
 PLOTS, [xpt-width, xpt+width], [ypts(2), ypts(2)], THICK=thick, COLOR=col, /DEVICE
ENDIF


;Proability error bars.
IF (N_ELEMENTS(PROB) EQ 7) THEN BEGIN
 ;Get device coordinates of XY point.
 pts=CONVERT_COORD(REPLICATE(X,7), PROB, /DATA, /TO_DEVICE)
 ypts=pts(1, *)
 xpt=pts(0,0)
 
 ;min-10%.
 PLOTS, [xpt, xpt], [ypts(0), ypts(1)], THICK=thick, COLOR=col, /DEVICE
 
  ;90%-max.
 PLOTS, [xpt, xpt], [ypts(5), ypts(6)], THICK=thick, COLOR=col, /DEVICE
 
 ;10%-25%.
 xptsbox=[xpt-width*0.5, xpt-width*0.5, xpt+width*0.5, xpt+width*0.5, xpt-width*0.5]
 yptsbox=[ypts(1), ypts(2), ypts(2), ypts(1), ypts(1)]
 IF (N_ELEMENTS(FILLCOL) EQ 1) THEN POLYFILL, xptsbox, yptsbox, COLOR=fillcol , /DEVICE
 PLOTS, xptsbox, yptsbox, THICK=thick, COLOR=col, /DEVICE
 
 ;75%-90%.
 yptsbox=[ypts(4), ypts(5), ypts(5), ypts(4), ypts(4)]
 IF (N_ELEMENTS(FILLCOL) EQ 1) THEN POLYFILL, xptsbox, yptsbox, COLOR=fillcol , /DEVICE
 PLOTS, xptsbox, yptsbox, THICK=thick, COLOR=col, /DEVICE
 
 ;25%-75%.
 xptsbox=[xpt-width, xpt-width, xpt+width, xpt+width, xpt-width]
 yptsbox=[ypts(2), ypts(4), ypts(4), ypts(2), ypts(2)] 
 IF (N_ELEMENTS(FILLCOL) EQ 1) THEN POLYFILL, xptsbox, yptsbox, COLOR=fillcol , /DEVICE
 PLOTS, xptsbox, yptsbox, THICK=thick, COLOR=col, /DEVICE
 
 ;Median.
  PLOTS, [xpt-width, xpt+width], [ypts(3), ypts(3)], THICK=thick, COLOR=col, /DEVICE

 
ENDIF


END
