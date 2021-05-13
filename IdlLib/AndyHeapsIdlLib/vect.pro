PRO PLOT_VECT, u, v, x, y, TYPE=type, ANGLE=angle, HEAD_LEN=head_len, $
                 MAG=mag, ALIGN=align, LENGTH=length, $
		 COL=col, DEVICE=device, SIZE=size, CLIP=clip
;Procedure to plot a vector.
;(C) NCAS 2010

COMPILE_OPT DEFINT32

mylen=300.0 ;Length of default arrow in pixels.
defhead=200.0 ;Default head size in pixels when using the SIZE parameter.
IF (N_ELEMENTS(size) EQ 1) THEN defhead=defhead*size/100.0
IF (N_ELEMENTS(TYPE) EQ 0) THEN TYPE=0
mymag=FLOAT(mag)
rev=1.0    
x0=0.0
y0=0.0
x1=u/mymag(0)*mylen*length(0) 
y1=v/mymag(1)*mylen*length(1)
r=SQRT(x1^2+y1^2)
;Avoid divide by zero errors.
IF (x1 EQ 0.0) THEN  theta=1.57080 ELSE theta=ATAN(y1/x1) 
map_type=!guide.projection
dx=x1
IF (dx LT 0.0) THEN rev=-1.0
dy=y1


phi=angle*!dtor
rfrac=head_len 
inhead=0
IF (N_ELEMENTS(SIZE) EQ 0) THEN BEGIN
 x2=x1-r*rfrac*rev*COS(theta-phi)
 y2=y1-r*rfrac*rev*SIN(theta-phi)
 x3=x1-r*rfrac*rev*COS(theta+phi)
 y3=y1-r*rfrac*rev*SIN(theta+phi)
ENDIF ELSE BEGIN
 x2=x1-defhead*rev*COS(theta-phi)
 y2=y1-defhead*rev*SIN(theta-phi)
 x3=x1-defhead*rev*COS(theta+phi)
 y3=y1-defhead*rev*SIN(theta+phi)
  vlen=SQRT(x1^2+y1^2)
  IF (vlen LE defhead) THEN BEGIN
    pt=CONVERT_COORD(x,y, /DATA, /TO_DEVICE)

    dx2=rev*defhead*COS(theta)
    dy2=rev*defhead*SIN(theta)
    IF (vlen LT defhead/2) THEN BEGIN
     dx=dx-dx2
     dy=dy-dy2    
    ENDIF
  ENDIF
ENDELSE

x4=x1-rfrac/2*r*rev*COS(theta)
y4=y1-rfrac/2*r*rev*SIN(theta)
;Calculate intersection of vector shaft and head points either
;side of the shaft - see
;http://astronomy.swin.edu.au/~pbourke/geometry/lineline2d
;for more details.
ua=((x3-x2)*(y0-y2)-(y3-y2)*(x0-x2))/((y3-y2)*(x1-x0)-(x3-x2)*(y1-y0))
x5=x0+ua*(x1-x0)
y5=y0+ua*(y1-y0) 

;Position and align vector.
IF KEYWORD_SET(DEVICE) THEN BEGIN
 xpts=[x0,x1,x2,x3,x4,x5]+x-x1*align
 ypts=[y0,y1,y2,y3,y4,y5]+y-y1*align     
ENDIF ELSE BEGIN
 pt1=CONVERT_COORD(x,y, /DATA, /TO_DEVICE)
 xpts=[x0,x1,x2,x3,x4,x5]+pt1[0]-align*dx
 ypts=[y0,y1,y2,y3,y4,y5]+pt1[1]-align*dy
 pts=CONVERT_COORD(xpts,ypts, /DEVICE, /TO_DATA)
 xpts=pts[0,*]
 ypts=pts[1,*]  
ENDELSE   

;Extract vector points.
x0=xpts[0]
x1=xpts[1]
x2=xpts[2]
x3=xpts[3]
x4=xpts[4]
x5=xpts[5]
y0=ypts[0]
y1=ypts[1]
y2=ypts[2]
y3=ypts[3]
y4=ypts[4]
y5=ypts[5]	



; Plot the vectors omiting any vectors with NaNs.
z=[xpts, ypts] 	 
IF (TOTAL(FINITE(z)) EQ 12) THEN BEGIN
 com=''
 ;Plot filled in vector heads for type 3 or 4.
 IF ((TYPE EQ 3) OR (TYPE EQ 4)) THEN BEGIN
  IF (TYPE EQ 3) THEN com='POLYFILL, [x1,x2,x3,x1], [y1,y2,y3,y1], COLOR=col'
  IF (TYPE EQ 4) THEN com='POLYFILL, [x1,x2,x4,x3,x1], [y1,y2,y4,y3,y1], COLOR=col'
  IF KEYWORD_SET(DEVICE) THEN com=com+', /DEVICE'
  res=EXECUTE(com)
 ENDIF
 
 ;Plot lines to make the vector.
 IF (TYPE EQ 0) THEN com='[x0,x1,x2,x1,x3], [y0,y1,y2,y1,y3]'
 IF (TYPE EQ 1) THEN com='[x0,x5,x3,x1,x2,x5], [y0,y5,y3,y1,y2,y5]'
 IF (TYPE EQ 2) THEN com='[x0,x4,x2,x1,x3,x4], [y0,y4,y2,y1,y3,y4]'
 IF (TYPE EQ 3) THEN com='[x0,x1], [y0,y1]'
 IF (TYPE EQ 4) THEN com='[x0,x4], [y0,y4]'
 com='PLOTS, '+com+', THICK=!guide.thick, COLOR=col'
 IF KEYWORD_SET(clip) THEN com=com+',CLIP=[!guide.xmin, !guide.ymin, !guide.xmax, !guide.ymax]'
 IF KEYWORD_SET(clip) THEN com=com+', NOCLIP=0'
 IF KEYWORD_SET(DEVICE) THEN com=com+', /DEVICE'
 res=EXECUTE(com)
ENDIF
 	
END


PRO VECT, U=u,V=v,F=f, X=x,Y=y, LENGTH = veclen,$
          COL=col, STRIDE=stride, ALIGN=align, $
	  MAG=mag, TYPE=type, ANGLE=angle, HEAD_LEN=head_len,$
	  MUNITS=munits, PTS=pts, $
	  LEGPOS=legpos, NOLEGBOX=nolegbox, NOLEGEND=nolegend, $
	  LEGCOL=legcol, LEGXOFFSET=legxoffset, LEGYOFFSET=legyoffset, $
	  SIZE=size, MIN=min, MAX=max, BORDERSPACE=borderspace, LEGSPACE=legspace, $
	  MAP=map, AXES=axes, TITLE=title, $
	  LEFT_TITLE=left_title, RIGHT_TITLE=right_title, QP=qp, NOMAP=nomap, CLIP=clip
	  
;Procedure to plot vectors.
;(C) NCAS 2010

COMPILE_OPT DEFINT32


;Check if field is a structure and extract the contents if it is.
IF (SIZE(f, /TYPE) EQ 8) THEN u=f
IF (SIZE(u, /TYPE) EQ 8) THEN BEGIN
 tagnames=TAG_NAMES(u)
 res=EXECUTE('x=u.'+tagnames(4))
 res=EXECUTE('y=u.'+tagnames(5))

 IF KEYWORD_SET(qp) THEN BEGIN
  PSOPEN
  IF ((STRUPCASE(STRMID(tagnames(4), 0, 3)) EQ 'LON') AND (STRUPCASE(STRMID(tagnames(5), 0, 3)) EQ 'LAT') AND $
     (!guide.projection EQ 0)) THEN BEGIN
    IF NOT KEYWORD_SET(NOMAP) THEN MAP, /DRAW 
  ENDIF ELSE BEGIN
    GSET, XMIN=MIN(xpts), XMAX=MAX(xpts), YMIN=MIN(ypts), YMAX=MAX(ypts)
  ENDELSE
 ENDIF
 
 tsum=N_ELEMENTS(title)+N_ELEMENTS(left_title)+N_ELEMENTS(right_title)+N_ELEMENTS(cb_title)
 IF (tsum EQ 0) THEN BEGIN 
  IF (SIZE(f, /TYPE) EQ 8) THEN title=u.title ELSE title=u.title+v.title
  left_title=u.title2
  right_title=u.units
 ENDIF

 IF (SIZE(f, /TYPE) EQ 8) THEN BEGIN
  u=f.data
  v=f.data2
 ENDIF ELSE BEGIN
  u=u.data
  v=v.data
 ENDELSE 
 IF ((STRUPCASE(STRMID(tagnames(4), 0, 3)) EQ 'LON') AND (STRUPCASE(STRMID(tagnames(5), 0, 3)) EQ 'LAT') AND $
     (!guide.projection EQ 0)) THEN BEGIN
   IF NOT KEYWORD_SET(NOMAP) THEN MAP, /DRAW
 ENDIF
 IF (!guide.levels_npts EQ 0) THEN BEGIN
  vpts=WHERE(FINITE(u+v, /NAN), count)
  IF (count EQ N_ELEMENTS(u)) THEN BEGIN
   PRINT, ''
   PRINT, 'VECT error - field contains just NaNs.'
   PRINT, ''
   STOP
  ENDIF
 IF (N_ELEMENTS(mag) EQ 0) THEN BEGIN
   mag=MAX(FLOOR(SQRT(u^2+v^2)))
   ndecs=0
   IF ((mag) LE 1) THEN BEGIN
    mag=MAX(SQRT(u^2+v^2))
    ndecs=2
   ENDIF
  ENDIF
 ENDIF
ENDIF





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
 PRINT, 'VECT error - MAP or GSET must be called first to establish coordinates.'
 PRINT, ''
 STOP
ENDIF

;Draw map if a map plot.
IF (!guide.projection NE 0) THEN BEGIN
  IF NOT KEYWORD_SET(nomap) THEN MAP, /NOSTORE, /DRAW
  IF KEYWORD_SET(nomap) THEN MAP, /NOSTORE
ENDIF


	
;Basic checks of the input data.          
IF ((N_ELEMENTS(u) EQ 0) OR (N_ELEMENTS(u) EQ 0) OR (N_ELEMENTS(x) EQ 0) $
     OR (N_ELEMENTS(y) EQ 0)) THEN BEGIN
 PRINT, ''
 PRINT, "VECT ERROR - U, V, X and Y must all be set."
 HELP, U, V, X, Y
 PRINT, ''
 STOP
ENDIF
IF ((N_ELEMENTS(u) EQ 1) AND (N_ELEMENTS(v) EQ 1) AND (N_ELEMENTS(x) EQ 1)  AND $
    (N_ELEMENTS(x) EQ 1)) THEN BEGIN 
 ;Single vector.
    
ENDIF ELSE BEGIN
 ;Multiple vectors.
 IF (((SIZE(u))(0) NE 2) OR ((SIZE(v))(0) NE 2) OR ((SIZE(x))(0) NE 1) $
       OR ((SIZE(x))(0) NE 1)) THEN BEGIN
  PRINT, ''
  PRINT, "VECT ERROR - U, V must be two dimensional fields and"
  PRINT, "             X, Y must be one dimensional."
  HELP, U, V, X, Y
  PRINT, ''
  STOP
 ENDIF  
 IF (((SIZE(x))(1) NE (SIZE(u))(1)) OR ((SIZE(y))(1) NE (SIZE(u))(2))) THEN BEGIN
  PRINT, ''
  PRINT, "VECT ERROR - U, X and Y mismatch."
  HELP, u, x, y
  PRINT, ''
  STOP 
 ENDIF 
 IF (((SIZE(x))(1) NE (SIZE(v))(1)) OR ((SIZE(y))(1) NE (SIZE(v))(2))) THEN BEGIN
  PRINT, ''
  PRINT, "VECT ERROR - V, X and Y mismatch."
  HELP, v, x, y
  PRINT, ''
  STOP 
 ENDIF 
 IF (N_ELEMENTS(col) GT 1) THEN BEGIN
  IF (((SIZE(x))(1) NE (SIZE(col))(1)) OR ((SIZE(y))(1) NE (SIZE(col))(2))) THEN BEGIN
   PRINT, ''
   PRINT, 'VECT ERROR - COL incorrectly specified.'
   PRINT, 'COL must have either one value i.e. the same colour for all vectors, or'
   PRINT, 'have the same size as the U, V arrays.'
   HELP, col, u, v
   PRINT, ''
   STOP 
  ENDIF 
 ENDIF
ENDELSE

;Put orignal values of u,v, x, y into arrays for returning to calling routine.
u_orig=u
v_orig=v
x_orig=x
y_orig=y

;Convert to floats if the inputs are integers.
IF ((SIZE(u, /TYPE) EQ 2) OR (SIZE(u, /TYPE) EQ 3)) THEN u=FLOAT(u)
IF ((SIZE(v, /TYPE) EQ 2) OR (SIZE(v, /TYPE) EQ 3)) THEN v=FLOAT(v)
IF ((SIZE(x, /TYPE) EQ 2) OR (SIZE(x, /TYPE) EQ 3)) THEN x=FLOAT(x)
IF ((SIZE(y, /TYPE) EQ 2) OR (SIZE(y, /TYPE) EQ 3)) THEN y=FLOAT(y)


;Check mapping is cylindrical, orthographic, stereographic or not set - reject if otherwise.
map_type=!guide.projection
IF (WHERE(map_type EQ [0, 1, 2, 8]) LT 0) THEN BEGIN
 PRINT, ''
 PRINT, 'Mapping must be cylindrical, stereographic, orthographic or unset to use the VECT routine'
 PRINT, 'If you want to use vectors with another projection then please use the IDL routine VELOVECT.'
 PRINT, ''
 STOP
ENDIF

;Check input doesn't have both /axis and /map set at the same time.
IF (KEYWORD_SET(axes) and KEYWORD_SET(map)) THEN BEGIN
 PRINT, ''
 PRINT, 'VECT ERROR - /MAP and /AXES cannot both be set.
 PRINT, ''
 STOP
ENDIF

;Initialise parameters if undefined.
IF (N_ELEMENTS(borderspace) EQ 0) THEN BEGIN
 IF (N_ELEMENTS(mag) EQ 2) THEN borderspace=500 ELSE borderspace=200
ENDIF
IF (N_ELEMENTS(STRIDE) EQ 0) THEN stridex=0
IF (N_ELEMENTS(STRIDE) EQ 0) THEN stridey=0
IF (N_ELEMENTS(STRIDE) EQ 1) THEN stridex=stride
IF (N_ELEMENTS(STRIDE) EQ 1) THEN stridey=stride
IF (N_ELEMENTS(STRIDE) EQ 2) THEN stridex=stride(0)
IF (N_ELEMENTS(STRIDE) EQ 2) THEN stridey=stride(1)



IF (N_ELEMENTS(veclen) GE 1 ) THEN veclen=veclen/100.0 ELSE veclen=1.0
IF (N_ELEMENTS(COL) EQ 0) THEN col=LONARR((SIZE(x))(1), (SIZE(y))(1))+1
IF (N_ELEMENTS(COL) EQ 1) THEN col=LONARR((SIZE(x))(1), (SIZE(y))(1))+col


IF (N_ELEMENTS(ANGLE) EQ 0) THEN angle=22.5
IF (N_ELEMENTS(HEAD_LEN) EQ 0) THEN head_len=0.3
IF (N_ELEMENTS(TYPE) EQ 0) THEN TYPE=0
IF (N_ELEMENTS(ALIGN) EQ 0) THEN align=0.5	
IF (N_ELEMENTS(MAG) EQ 0) THEN mag=MAX(ABS(SQRT(u^2.+v^2.))) 
scale=2
mag_orig=mag
IF (N_ELEMENTS(MAG) EQ 1) THEN BEGIN
 ;Set to have one scale for u and v.
 scale=1
 mag=[mag, mag]
ENDIF
IF (N_ELEMENTS(veclen) EQ 1) THEN veclen=[veclen, veclen]
IF (N_ELEMENTS(LEGSPACE) EQ 0) THEN legspace=400 ;Space between the axis and the legend.
IF ((N_ELEMENTS(MIN) EQ 1) OR (N_ELEMENTS(MAX) EQ 1)) THEN BEGIN
 IF (N_ELEMENTS(MIN) EQ 0) THEN min=-1e38
 IF (N_ELEMENTS(MAX) EQ 0) THEN max=1e38
 minmax=1
ENDIF
 
 
;Check for polar plot and set POLAR_INT accordingly.
POLAR_INT=0
IF (WHERE(map_type EQ [1, 2]) GE 0) THEN BEGIN
 IF (!guide.nh EQ 1) THEN hem=1
 IF (!guide.sh EQ 1) THEN hem=-1
 POLAR_INT=-1
 IF (N_ELEMENTS(pts) EQ 1) THEN POLAR_INT=1 
ENDIF

;Regrid if requested.
IF ((WHERE(map_type EQ [0, 8]) GE 0) AND (N_ELEMENTS(pts) GE 1)) THEN BEGIN
 IF (N_ELEMENTS(pts) EQ 1) THEN pts=[pts, pts]
 xmin=!guide.xmin
 xmax=!guide.xmax
 ymin=!guide.ymin
 ymax=!guide.ymax
 newx=xmin+(xmax-xmin)*FINDGEN(pts(0))/(pts(0)-1)
 newy=ymin+(ymax-ymin)*FINDGEN(pts(1))/(pts(1)-1)
 newu=REGRID(u, x, y, newx, newy)
 newv=REGRID(v, x, y, newx, newy)
 
 ;Assign to input arrays.
 x=newx
 y=newy
 u=newu
 v=newv  
 
 ;Make a new col array with just black.
 col=LONARR((SIZE(x))(1), (SIZE(y))(1))+1
ENDIF


;If /MAP specified and a cylindrical plot then correct for latitude.
IF KEYWORD_SET(map) THEN BEGIN
 IF (map_type EQ 8) THEN BEGIN
 ;Get paper size
 paper_xsize=FLOAT(!D.X_VSIZE) ;Plot x size
 paper_ysize=FLOAT(!D.Y_VSIZE) ;Plot y size
 xscale=(!guide.position(2)-!guide.position(0))*paper_xsize/ABS(!guide.xmax-!guide.xmin)
 yscale=(!guide.position(3)-!guide.position(1))*paper_ysize/ABS(!guide.ymax-!guide.ymin) 
 
 FOR ix=0, N_ELEMENTS(x)-1 DO BEGIN
  FOR iy=0, N_ELEMENTS(y)-1 DO BEGIN 
   uval=xscale/cos(y(iy)/!radeg)*u(ix,iy)
   IF (uval EQ 0.0) THEN  theta=1.57080 ELSE theta=ATAN(yscale*v(ix,iy), uval) 
   vmag=SQRT(u(ix,iy)^2+v(ix,iy)^2)
   u(ix, iy)=vmag*COS(theta)
   v(ix, iy)=vmag*SIN(theta)
  ENDFOR
 ENDFOR 
 ENDIF ELSE BEGIN
  PRINT, ''
  PRINT, 'VECT error - /MAP only available when in the cylindrical projection.'
  PRINT, ''
  STOP
 ENDELSE
ENDIF
 
 
;If /AXES specified then correct u and v for data coordinates.
IF KEYWORD_SET(axes) THEN BEGIN
 ;Get paper size
 paper_xsize=FLOAT(!D.X_VSIZE) ;Plot x size
 paper_ysize=FLOAT(!D.Y_VSIZE) ;Plot y size
 xscale=(!guide.position(2)-!guide.position(0))*paper_xsize/ABS(!guide.xmax-!guide.xmin)
 yscale=(!guide.position(3)-!guide.position(1))*paper_ysize/ABS(!guide.ymax-!guide.ymin)
 
 FOR ix=0, N_ELEMENTS(x)-1 DO BEGIN
  FOR iy=0, N_ELEMENTS(y)-1 DO BEGIN 
   IF (xscale*u(ix,iy) EQ 0.0) THEN  theta=1.57080 ELSE theta=ATAN(yscale*v(ix,iy), xscale*u(ix,iy)) 
   vmag=SQRT(u(ix, iy)^2+v(ix,iy)^2)
   u(ix, iy)=vmag*COS(theta)
   v(ix, iy)=vmag*SIN(theta)
  ENDFOR
 ENDFOR
ENDIF


IF KEYWORD_SET(!guide.sector) THEN BEGIN
 IF ((!guide.ymin GE 0) AND (!guide.ymax GT 0)) THEN hem=1
 IF ((!guide.ymin LT 0) AND (!guide.ymax LE 0)) THEN hem=-1 
ENDIF


;Normal vector plot
IF ((WHERE(map_type EQ [0, 8]) GE 0) OR (POLAR_INT EQ -1)) THEN BEGIN  
 ;Do stride data reduction if requested.	
 IF (N_ELEMENTS(stride) GT 0) THEN BEGIN
  a=SIZE(u)
  mypts=FLTARR(a[1], a[2])
  mypts[*,*]=0.0	   
  FOR iy=0,a[2]-1,stridey DO BEGIN
   FOR ix=0,a[1]-1,stridex DO BEGIN
    IF ( ((ix/stridex) EQ FIX(ix/stridex)) AND $
         ((iy/stridey) EQ FIX(iy/stridey)) ) THEN mypts[ix,iy]=1.0
   ENDFOR
  ENDFOR
  pts=WHERE(mypts LT 1.0)
  u[pts]=!values.f_nan
  v[pts]=!values.f_nan
 ENDIF 



 ;Main vector plotting loop
 FOR ix=0, N_ELEMENTS(x)-1 DO BEGIN
  FOR iy=0, N_ELEMENTS(y)-1 DO BEGIN  
   myu=u(ix,iy)
   myv=v(ix,iy)
   IF (POLAR_INT EQ -1) THEN BEGIN
    ;rotate vectors for a polar plot.
    IF KEYWORD_SET(!guide.sector) THEN BEGIN
     ;centre longitude
     clon=!guide.xmin+(!guide.xmax-!guide.xmin)/2.0
     vlon=x(ix)-clon
    ENDIF ELSE BEGIN
     vlon=x(ix)
    ENDELSE
    udev=myu*cos(vlon*!dtor)-hem*myv*sin(vlon*!dtor)
    vdev=myv*cos(vlon*!dtor)+hem*myu*sin(vlon*!dtor)
    myu=udev
    myv=vdev
   ENDIF
   
   valid=1 
   mymag=SQRT((DOUBLE(myu)^2+DOUBLE(myv)^2))
   IF (KEYWORD_SET(minmax)) THEN BEGIN
    IF ((mymag LT MIN) OR (mymag GT MAX)) THEN valid=0
   ENDIF
   com='PLOT_VECT, myu, myv, x(ix), y(iy), TYPE=type, ANGLE=angle, HEAD_LEN=head_len,'
   com=com+'MAG=mag, ALIGN=align, LENGTH=veclen, COL=col(ix, iy)'
   IF (N_ELEMENTS(SIZE) EQ 1) THEN com=com+', SIZE=size'
   IF KEYWORD_SET(clip) THEN com=com+', /CLIP'
   IF KEYWORD_SET(valid) THEN res=EXECUTE(com)
  ENDFOR
 ENDFOR
ENDIF

;Polar grid - interpolated version.
;IF ((WHERE(map_type EQ [1, 2]) GE 0) AND (N_ELEMENTS(pts) EQ 1)) THEN BEGIN
IF (POLAR_INT EQ 1) THEN BEGIN
 cen=CONVERT_COORD(0.0,hem*90.0, /DATA, /TO_DEVICE) ;Centre point.
 bottom=CONVERT_COORD(0.0,0.0, /DATA, /TO_DEVICE) ;Bottom of plot.
 myrad=ABS(cen(1)-bottom(1)) ;Radius in device coordinates.
 del=0.5 ; side of square for plotting box.
 npts=pts ; number of plotting points across plot diameter.
 FOR ix=0, npts-1 DO BEGIN
  FOR iy=0, npts-1 DO BEGIN
   myx=ix*2*myrad/(npts-1)+cen(0)-myrad
   myy=iy*2*myrad/(npts-1)+cen(1)-myrad
   ;Select points that are within the plot.
   IF (SQRT((myx-cen(0))^2+(myy-cen(1))^2) LT myrad) THEN BEGIN
  
    new=CONVERT_COORD(myx, myy, /DEVICE, /TO_DATA)
    xpts=[new(0)-del, new(0)-del, new(0)+del, new(0)+del, new(0)-del]
    ypts=[new(1)-del, new(1)+del, new(1)+del, new(1)-del, new(1)-del]

    newlong=new(0)
    IF (newlong LT 0) THEN newlong=360.0+newlong
    newlat=new(1)
    ;Use bi-linear interpolation to find new value at this point.
    newu=REGRID(u, x, y, newlong, newlat)
    newv=REGRID(v, x, y, newlong, newlat)
    IF KEYWORD_SET(!guide.sector) THEN BEGIN
     ;centre longitude
     clon=!guide.xmin+(!guide.xmax-!guide.xmin)/2.0
     vlon=newlong-clon
    ENDIF ELSE BEGIN
     vlon=newlong
    ENDELSE
    udev=newu*cos(vlon*!dtor)-hem*newv*sin(vlon*!dtor)
    vdev=newv*cos(vlon*!dtor)+hem*newu*sin(vlon*!dtor)  
    
    ;Determine u and v in device coordinate space.
    ;udev=newu*cos(newlong*!dtor)-hem*newv*sin(newlong*!dtor)
    ;vdev=newv*cos(newlong*!dtor)+hem*newu*sin(newlong*!dtor)
    
    ;Plot the vector
    valid=1 
    mymag=SQRT((udev^2+vdev^2))
    IF (KEYWORD_SET(minmax)) THEN BEGIN
     IF ((mymag LT MIN) OR (mymag GT MAX)) THEN valid=0
    ENDIF
    com='PLOT_VECT, udev, vdev, newlong, newlat, TYPE=type, ANGLE=angle, '
    com=com+'HEAD_LEN=head_len,MAG=mag, ALIGN=align, LENGTH=veclen, COL=col'
    IF (N_ELEMENTS(SIZE) EQ 1) THEN com=com+', SIZE=size'
    IF KEYWORD_SET(clip) THEN com=com+', /CLIP'
    IF KEYWORD_SET(valid) THEN res=EXECUTE(com)  
   ENDIF
  ENDFOR
 ENDFOR
ENDIF

;Plot a reference vector if unless otherwise requested.
IF (NOT KEYWORD_SET(nolegend)) THEN BEGIN
 space1=!guide.space1 
 xpix=!guide.xpix         ;Width of text in pixels
 ypix=!guide.ypix         ;Height of text in pixels 
 pt=CONVERT_COORD(!P.POSITION(0), !P.POSITION(1), /NORMAL, /TO_DEVICE)
 xmin=pt(0)
 ymin=pt(1)
 pt=CONVERT_COORD(!P.POSITION(2), !P.POSITION(3), /NORMAL, /TO_DEVICE)
 xmax=pt(0)
 ymax=pt(1)
 font=!guide.font
 charsize=!guide.charsize

    
 ;Set the legend position if not passed in.
 IF (NOT KEYWORD_SET(LEGPOS)) THEN BEGIN
  legpos=11
  IF (WHERE(map_type EQ [1, 2]) GE 0) THEN legpos=12
 ENDIF
 
 ;Calculate the legend position.
 ;Y position.
 IF (scale EQ 1) THEN BEGIN
  ;Single reference vector.
  legheight=2*borderspace+2*ypix+space1
  IF (WHERE(legpos EQ [3, 7, 11, 15]) GE 0) THEN ylegmin=ymin+legspace
  IF (WHERE(legpos EQ [1, 5, 9, 13]) GE 0) THEN ylegmin=ymax-legspace-legheight
  IF (WHERE(legpos EQ [2, 6, 10, 14]) GE 0) THEN ylegmin=(ymax-ymin)/2+ymin-legheight/2
  IF (WHERE(legpos EQ [4, 8, 12, 16]) GE 0) THEN ylegmin=ymin-legspace-legheight
  ylegmax=ylegmin+legheight
 ENDIF ELSE BEGIN
  ;Two reference vectors.
  legheight=2*borderspace+3*ypix+space1+veclen(1)*300
  IF (WHERE(legpos EQ [3, 7, 11, 15]) GE 0) THEN ylegmin=ymin+legspace
  IF (WHERE(legpos EQ [1, 5, 9, 13]) GE 0) THEN ylegmin=ymax-legspace-legheight
  IF (WHERE(legpos EQ [2, 6, 10, 14]) GE 0) THEN ylegmin=(ymax-ymin)/2+ymin-legheight/2
  IF (WHERE(legpos EQ [4, 8, 12, 16]) GE 0) THEN ylegmin=ymin-legspace-legheight
  ylegmax=ylegmin+legheight
 ENDELSE
 IF (N_ELEMENTS(legxoffset) EQ 1) THEN ylegmin=ylegmin+legyoffset
 IF (N_ELEMENTS(legyoffset) EQ 1) THEN ylegmax=ylegmax+legyoffset


 ;X position.
 ;Calculate width of the reference label by plotting the text once.
 ref_text=SCROP(mag(0)) 
 IF (N_ELEMENTS(MUNITS) GE 1) THEN ref_text=ref_text+munits(0)
 XYOUTS, 0, 0, ref_text, FONT=0, CHARSIZE=charsize, WIDTH=width, $
         ALIGNMENT=0.0, COLOR=0, /DEVICE

 IF (N_ELEMENTS(mag) EQ 2) THEN BEGIN
  ref_text2=SCROP(mag(1)) 
  IF (N_ELEMENTS(MUNITS) EQ 2) THEN ref_text2=ref_text2+munits(1)
  XYOUTS, 0, 0, ref_text2, FONT=0, CHARSIZE=charsize, WIDTH=width2, $
          ALIGNMENT=0.0, COLOR=0, /DEVICE
  IF (width2 GT width) THEN width=width2	 
 ENDIF	 

 	 
 width=width*!d.x_size ;Convert to pixels. 	 
 maxwidth=MAX([width, veclen(0)*300]) ;Find the maximum width of text and arrow. 
 
 IF (WHERE(legpos EQ [1, 2, 3, 4]) GE 0) THEN xlegmin=xmin+legspace
 IF (WHERE(legpos EQ [5, 6, 7, 8]) GE 0) THEN xlegmin=(xmax-xmin)/2+xmin-(maxwidth+2*borderspace)/2
 IF (WHERE(legpos EQ [9, 10, 11, 12]) GE 0) THEN xlegmin=xmax-(legspace+maxwidth+2*borderspace)
 IF (WHERE(legpos EQ [13, 14, 15, 16]) GE 0) THEN xlegmin=xmax+legspace
 xlegmax=xlegmin+2*borderspace+maxwidth
 IF (N_ELEMENTS(legxoffset) EQ 1) THEN xlegmin=xlegmin+legxoffset
 IF (N_ELEMENTS(legyoffset) EQ 1) THEN xlegmax=xlegmax+legxoffset


 ;Blank the legend box plotting area.
 xbox=[xlegmin, xlegmin, xlegmax, xlegmax, xlegmin]
 ybox=[ylegmin, ylegmax, ylegmax, ylegmin, ylegmin]
 IF (N_ELEMENTS(legcol) NE 1) THEN legcol=0
 IF KEYWORD_SET(NOLEGBOX) THEN  GPLOT, X=xbox, Y=ybox, FILLCOL=legcol, /NOLINES, /DEVICE 
 IF (NOT KEYWORD_SET(NOLEGBOX)) THEN  GPLOT, X=xbox, Y=ybox, FILLCOL=legcol, /DEVICE 
   
 ;Draw vector and annotation.
 xpt=xlegmin+borderspace
 ypt=ylegmin+borderspace
 
 ;Horizontal vector.
 XYOUTS, xpt, ypt, ref_text, FONT=0, CHARSIZE=charsize, ALIGNMENT=0.0, /DEVICE
 ypt=ypt+ypix+1.5*space1
 IF (scale EQ 1) THEN xpt=xpt+width/2
 com='PLOT_VECT, mag(0), 0, xpt, ypt, TYPE=type, ANGLE=angle, HEAD_LEN=head_len, '
 com=com+'MAG=mag, LENGTH=veclen, /DEVICE'
 IF (N_ELEMENTS(SIZE) EQ 1) THEN com=com+', SIZE=size'
 IF (scale EQ 1) THEN com=com+', ALIGN=0.5' ELSE com=com+', ALIGN=0.0'
 res=EXECUTE(com)
		
 ;Vertical vector. 
 IF (scale EQ 2) THEN BEGIN
  com='PLOT_VECT, 0, mag(1), xpt, ypt, TYPE=type, ANGLE=angle, HEAD_LEN=head_len, '
  com=com+'MAG=mag, ALIGN=0.0, LENGTH=veclen, /DEVICE'
  IF (N_ELEMENTS(SIZE) EQ 1) THEN com=com+', SIZE=size'
  res=EXECUTE(com)
  XYOUTS, xpt, ypt+veclen(1)*300+space1, ref_text2, FONT=0, CHARSIZE=charsize, ALIGNMENT=0.0, /DEVICE
 ENDIF
 
 			
ENDIF

;Add titles if requested.
;Retrieve plot position.
pt=CONVERT_COORD(!guide.position(0), !guide.position(1) , /NORMAL, /TO_DEVICE)
xmin=pt(0)
ymin=pt(1)
pt=CONVERT_COORD(!guide.position(2), !guide.position(3), /NORMAL, /TO_DEVICE)
xmax=pt(0)
ymax=pt(1)
space3=!guide.space3
com=!guide.titlefont
res=EXECUTE(com)
font=!guide.tfont
charsize=!guide.tcharsize

IF (N_ELEMENTS(TITLE) GT 0) THEN XYOUTS, (xmax-xmin)/2.0+xmin, ymax+space3, ALIGN=0.5, $
              FONT=0, CHARSIZE=charsize, title, /DEVICE
IF (N_ELEMENTS(LEFT_TITLE) GT 0) THEN XYOUTS, xmin, ymax+space3, ALIGN=0.0,  $
              FONT=0, CHARSIZE=charsize, left_title, /DEVICE
IF (N_ELEMENTS(RIGHT_TITLE) GT 0) THEN XYOUTS, xmax, ymax+space3, ALIGN=1.0,  $
              FONT=0, CHARSIZE=charsize, right_title, /DEVICE
	      
	    
;Exit after resetting u, v, x, y.
u=u_orig
v=v_orig
x=x_orig
y=y_orig
mag=mag_orig

IF KEYWORD_SET(qp) THEN BEGIN
 AXES
 PSCLOSE
ENDIF

END


