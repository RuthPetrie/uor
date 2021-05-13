PRO PFILL, FIELD=field, X=xpts, Y=ypts, MIN=min, MAX=max, SPACE=space, $
           COL=col, SIZE=size, SYM=sym, STYLE=style, RES=res, LATMIN=latmin, LATMAX=latmax
;Procedure to make pattern filled plots.
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
 PRINT, 'PFILL error - MAP or GSET must be called first to establish coordinates.'
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
 PRINT, "PFILL ERROR - FIELD, X and Y must all be set."
 HELP, FIELD, X, Y
 PRINT, ''
 STOP
ENDIF
s=(SIZE(xpts))(0)
IF (S EQ 1) THEN BEGIN
 IF (((SIZE(xpts))(1) NE (SIZE(field))(1)) OR ((SIZE(ypts))(1) NE (SIZE(field))(2))) THEN BEGIN
  PRINT, ''
  PRINT, "PFILL ERROR - FIELD, X and Y mismatch."
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
  PRINT, "PFILL ERROR - X and Y don't match."
  HELP, xpts, ypts
  PRINT, ''
  STOP
 ENDIF
ENDIF
IF ((N_ELEMENTS(min) EQ 0) OR (N_ELEMENTS(max) EQ 0)) THEN BEGIN
 PRINT, ''
 PRINT, 'PFILL ERROR - Must define a MIN and MAX value to pattern fill.'
 HELP, min, max
 PRINT, ''
 STOP
ENDIF

;Check X-coordinate is increasing - reject if otherwise.
IF (xpts(0) GT xpts(N_ELEMENTS(xpts)-1)) THEN BEGIN
 PRINT, ''
 PRINT, 'PFILL error - X coordinate must increase rather than descend in value.'
 PRINT, 'Use REVERSE to swap around the X coordinate and data.'
 PRINT, ''
 STOP
ENDIF

;Set defaults if unspecified.
IF (N_ELEMENTS(style) EQ 0) THEN style=0
IF (N_ELEMENTS(space) EQ 0) THEN space=200.0 ELSE space=200.0*space/100
IF (style GE 4) THEN space=space*2
IF (N_ELEMENTS(col) EQ 0) THEN col=1
IF (N_ELEMENTS(size) EQ 0) THEN size=20 ELSE size=20*size/100
IF (N_ELEMENTS(sym) EQ 0) THEN sym=3
IF (N_ELEMENTS(res) EQ 0) THEN res=4

;Work out region to test for data filling.
pt0=CONVERT_COORD(!P.POSITION(0), !P.POSITION(1), /NORMAL, /TO_DEVICE)
pt1=CONVERT_COORD(!P.POSITION(2), !P.POSITION(3), /NORMAL, /TO_DEVICE)
pxmin=pt0(0)
pxmax=pt1(0)
pymin=pt0(1)
pymax=pt1(1)


xloc=pxmin
yloc=pymin
vals=!values.f_nan
IF (style EQ 0) THEN BEGIN
 FOR iy=pymin+space/2, pymax, space DO BEGIN
  FOR ix=pxmin+space/2, pxmax, space DO BEGIN
   xval=ix
   yval=iy
   xtest=(ix-space/2-pxmin)/space
   IF ((xtest/2) EQ FIX(xtest/2)) THEN yval=yval-space/2 
   xloc=[xloc, xval]
   yloc=[yloc, yval]  
   pt=CONVERT_COORD(xval, yval, /DEVICE, /TO_DATA)
   val=REGRID(field, xpts, ypts, pt(0), pt(1))
   vals=[vals, val]   
  ENDFOR
 ENDFOR   
ENDIF ELSE BEGIN
 FOR iy=pymin, pymax, space DO BEGIN
  FOR ix=pxmin, pxmax, space DO BEGIN
   xloc=[xloc, ix]
   yloc=[yloc, iy]
   pt=CONVERT_COORD(ix, iy, /DEVICE, /TO_DATA)
   val=REGRID(field, xpts, ypts, pt(0), pt(1))
   vals=[vals, val]
  ENDFOR
 ENDFOR   
ENDELSE
pts=WHERE((vals GE min) AND (vals LE max), count)

;Restrict points to those above latmin or below latmax if they are specified.
IF ((N_ELEMENTS(latmin) EQ 1) OR (N_ELEMENTS(latmax) EQ 1)) THEN BEGIN
 data_pts=CONVERT_COORD(xloc(pts), yloc(pts), /DEVICE, /TO_DATA)
 IF (N_ELEMENTS(latmin) EQ 1) THEN valid_pts=WHERE(data_pts(1,*) GT latmin)
 IF (N_ELEMENTS(latmax) EQ 1) THEN valid_pts=WHERE(data_pts(1,*) LT latmax)
 pts=pts(valid_pts)
 count=N_ELEMENTS(pts)
ENDIF


IF (count GT 0) THEN BEGIN
 ;Stipple plots.
 
 IF (style EQ 0) THEN GPLOT, X=xloc(pts), Y=yloc(pts), SYM=sym, SIZE=size, COL=col, /NOLINES, /DEVICE


 ;Vertical lines.
 IF ((style EQ 1) OR (style EQ 3)) THEN BEGIN
  FOR i=0, count-1 DO BEGIN
   x=xloc(pts(i))
   y=yloc(pts(i))
   FOR iy=1, res-1 DO BEGIN
    ynew=y+iy*space/res
    pt=CONVERT_COORD(x, ynew, /DEVICE, /TO_DATA)
    val=REGRID(field, xpts, ypts, pt(0), pt(1))
    pt2=CONVERT_COORD(x, y, /DEVICE, /TO_DATA)
    IF ((val GE min) AND (val LE max)) THEN BEGIN
     plotpts=1
      IF (N_ELEMENTS(latmin) EQ 1) THEN BEGIN
       IF ((pt(1) LT latmin) OR (pt2(1) LT latmin)) THEN plotpts=0
      ENDIF
      IF (N_ELEMENTS(latmax) EQ 1) THEN BEGIN
       IF ((pt(1) GT latmax) OR (pt2(1) GT latmax)) THEN plotpts=0
      ENDIF       
      IF (plotpts EQ 1) THEN GPLOT, X=[x, x], Y=[y, ynew], COL=col, /DEVICE
    ENDIF    
    ynew=y-iy*space/res
    pt=CONVERT_COORD(x, ynew, /DEVICE, /TO_DATA)
    val=REGRID(field, xpts, ypts, pt(0), pt(1))
    pt2=CONVERT_COORD(x, y, /DEVICE, /TO_DATA)
    IF ((val GE min) AND (val LE max)) THEN BEGIN
     plotpts=1
      IF (N_ELEMENTS(latmin) EQ 1) THEN BEGIN
       IF ((pt(1) LT latmin) OR (pt2(1) LT latmin)) THEN plotpts=0
      ENDIF
      IF (N_ELEMENTS(latmax) EQ 1) THEN BEGIN
       IF ((pt(1) GT latmax) OR (pt2(1) GT latmax)) THEN plotpts=0
      ENDIF       
      IF (plotpts EQ 1) THEN GPLOT, X=[x, x], Y=[y, ynew], COL=col, /DEVICE
    ENDIF 
   ENDFOR 
  ENDFOR
 ENDIF
 
 ;Horizontal lines.
 IF ((style EQ 2) OR (style EQ 3))  THEN BEGIN
  FOR i=0, count-1 DO BEGIN
   x=xloc(pts(i))
   y=yloc(pts(i))
   FOR ix=1, res-1 DO BEGIN
    xnew=x+ix*space/res
    pt=CONVERT_COORD(xnew, y, /DEVICE, /TO_DATA)
    val=REGRID(field, xpts, ypts, pt(0), pt(1))
    pt2=CONVERT_COORD(x, y, /DEVICE, /TO_DATA)
    IF ((val GE min) AND (val LE max)) THEN BEGIN
     plotpts=1
      IF (N_ELEMENTS(latmin) EQ 1) THEN BEGIN
       IF ((pt(1) LT latmin) OR (pt2(1) LT latmin)) THEN plotpts=0
      ENDIF
      IF (N_ELEMENTS(latmax) EQ 1) THEN BEGIN
       IF ((pt(1) GT latmax) OR (pt2(1) GT latmax)) THEN plotpts=0
      ENDIF       
      IF (plotpts EQ 1) THEN GPLOT, X=[x, xnew], Y=[y, y], COL=col, /DEVICE
    ENDIF
    xnew=x-ix*space/res
    pt=CONVERT_COORD(xnew, y, /DEVICE, /TO_DATA)
    val=REGRID(field, xpts, ypts, pt(0), pt(1))
    pt2=CONVERT_COORD(x, y, /DEVICE, /TO_DATA)
    IF ((val GE min) AND (val LE max)) THEN BEGIN
     plotpts=1
      IF (N_ELEMENTS(latmin) EQ 1) THEN BEGIN
       IF ((pt(1) LT latmin) OR (pt2(1) LT latmin)) THEN plotpts=0
      ENDIF
      IF (N_ELEMENTS(latmax) EQ 1) THEN BEGIN
       IF ((pt(1) GT latmax) OR (pt2(1) GT latmax)) THEN plotpts=0
      ENDIF       
      IF (plotpts EQ 1) THEN GPLOT, X=[x, xnew], Y=[y, y], COL=col, /DEVICE
    ENDIF
   ENDFOR 
  ENDFOR
 ENDIF
 
 ;Diagonal / lines.
 IF ((style EQ 4) OR (style EQ 6)) THEN BEGIN
  FOR i=0, count-1 DO BEGIN
   x=xloc(pts(i))
   y=yloc(pts(i))
   FOR iy=1, res DO BEGIN
    theta=0.85
    xnew=x+theta*iy*space/res
    ynew=y+theta*iy*space/res
    pt=CONVERT_COORD(xnew, ynew, /DEVICE, /TO_DATA)
    val=REGRID(field, xpts, ypts, pt(0), pt(1))
    pt2=CONVERT_COORD(x, y, /DEVICE, /TO_DATA)
    IF ((val GE min) AND (val LE max)) THEN BEGIN
     plotpts=1
      IF (N_ELEMENTS(latmin) EQ 1) THEN BEGIN
       IF ((pt(1) LT latmin) OR (pt2(1) LT latmin)) THEN plotpts=0
      ENDIF
      IF (N_ELEMENTS(latmax) EQ 1) THEN BEGIN
       IF ((pt(1) GT latmax) OR (pt2(1) GT latmax)) THEN plotpts=0
      ENDIF       
      IF (plotpts EQ 1) THEN GPLOT, X=[x, xnew], Y=[y, ynew], COL=col, /DEVICE
    ENDIF
    xnew=x-theta*iy*space/res
    ynew=y-theta*iy*space/res
    pt=CONVERT_COORD(xnew, ynew, /DEVICE, /TO_DATA)
    val=REGRID(field, xpts, ypts, pt(0), pt(1))
    pt2=CONVERT_COORD(x, y, /DEVICE, /TO_DATA)
    IF ((val GE min) AND (val LE max)) THEN BEGIN
     plotpts=1
      IF (N_ELEMENTS(latmin) EQ 1) THEN BEGIN
       IF ((pt(1) LT latmin) OR (pt2(1) LT latmin)) THEN plotpts=0
      ENDIF
      IF (N_ELEMENTS(latmax) EQ 1) THEN BEGIN
       IF ((pt(1) GT latmax) OR (pt2(1) GT latmax)) THEN plotpts=0
      ENDIF       
      IF (plotpts EQ 1) THEN GPLOT, X=[x, xnew], Y=[y, ynew], COL=col, /DEVICE
    ENDIF
   ENDFOR 
  ENDFOR
 ENDIF
 
 ;Diagonal \ lines.
 IF ((style EQ 5) OR (style EQ 6)) THEN BEGIN
  FOR i=0, count-1 DO BEGIN
   x=xloc(pts(i))
   y=yloc(pts(i))
   FOR iy=1, res DO BEGIN
    theta=0.85
    xnew=x-theta*iy*space/res
    ynew=y+theta*iy*space/res
    pt=CONVERT_COORD(xnew, ynew, /DEVICE, /TO_DATA)
    val=REGRID(field, xpts, ypts, pt(0), pt(1))
    pt2=CONVERT_COORD(x, y, /DEVICE, /TO_DATA)
    IF ((val GE min) AND (val LE max)) THEN BEGIN
     plotpts=1
      IF (N_ELEMENTS(latmin) EQ 1) THEN BEGIN
       IF ((pt(1) LT latmin) OR (pt2(1) LT latmin)) THEN plotpts=0
      ENDIF
      IF (N_ELEMENTS(latmax) EQ 1) THEN BEGIN
       IF ((pt(1) GT latmax) OR (pt2(1) GT latmax)) THEN plotpts=0
      ENDIF       
      IF (plotpts EQ 1) THEN GPLOT, X=[x, xnew], Y=[y, ynew], COL=col, /DEVICE
    ENDIF
    xnew=x+theta*iy*space/res
    ynew=y-theta*iy*space/res
    pt=CONVERT_COORD(xnew, ynew, /DEVICE, /TO_DATA)
    val=REGRID(field, xpts, ypts, pt(0), pt(1))
    pt2=CONVERT_COORD(x, y, /DEVICE, /TO_DATA)
    IF ((val GE min) AND (val LE max)) THEN BEGIN  
     plotpts=1
      IF (N_ELEMENTS(latmin) EQ 1) THEN BEGIN
       IF ((pt(1) LT latmin) OR (pt2(1) LT latmin)) THEN plotpts=0
      ENDIF
      IF (N_ELEMENTS(latmax) EQ 1) THEN BEGIN
       IF ((pt(1) GT latmax) OR (pt2(1) GT latmax)) THEN plotpts=0
      ENDIF 
      IF (plotpts EQ 1) THEN GPLOT, X=[x, xnew], Y=[y, ynew], COL=col, /DEVICE
    ENDIF
   ENDFOR 
  ENDFOR
 ENDIF
 
 
 
ENDIF



END

