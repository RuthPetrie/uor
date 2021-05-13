FUNCTION LOC, XVEC=xvec, XVALS=xvals, YVEC=yvec, YVALS=yvals
;Function to locate the positions of a set of points in a vector.
;(C) NCAS 2010
nvals=N_ELEMENTS(xvals)
xarr=FLTARR(nvals)
yarr=FLTARR(nvals)


;Convert to -180 to 180.
xvec=((xvec + 180) MOD 360)-180 
xvals=((xvals + 180) MOD 360)-180 

;Centre around 180 degrees longitude if needed.
IF (MAX(xvec) GT 150) THEN BEGIN
 xvec=(xvec+360.0) MOD 360.0
 pts=WHERE(xvec LT 0.0, count)
 IF (count GT 0) THEN xvec(pts)=xvec(pts)+360.0 
 xvals=(xvals+360.0) MOD 360.0 
 pts=WHERE(xvals LT 0.0, count)
 IF (count GT 0) THEN xvals(pts)=xvals(pts)+360.0  
ENDIF


FOR i=0, nvals-1 DO BEGIN
 xpts=WHERE(xvals(i) GE xvec)
 xpt=MAX(xpts)
 IF ((xvals(i) LT MIN(xvec)) OR (xvals(i) GT MAX(xvec))) THEN xpt=-1
 IF (xpt GE N_ELEMENTS(xvec)-1) THEN xpt=-1
 
 ypts=WHERE(yvals(i) GE yvec)
 ypt=MAX(ypts)
 IF ((yvals(i) LT MIN(yvec)) OR (yvals(i) GT MAX(yvec))) THEN ypt=-1
 
 IF (xpt GE 0) THEN xarr(i)=xpt+(xvals(i)-xvec(xpt))/(xvec(xpt+1)-xvec(xpt)) ELSE xarr(i)=!VALUES.F_NAN  
 IF (ypt GE 0) THEN yarr(i)=ypt+(yvals(i)-yvec(ypt))/(yvec(ypt+1)-yvec(ypt)) ELSE yarr(i)=!VALUES.F_NAN 
ENDFOR

RETURN, [[xarr],[yarr]]
END



PRO RGAXES, XIN=xin, YIN=yin_orig, XPOLE=xpole, YPOLE=ypole, XLAB=xlab, YLAB=ylab, $
            DEGSPACING=degspacing, COUNTRIES=countries, CONTINENTS=continents, $
	    CSTYLE=cstyle, CTHICK=cthick, CCOL=ccol, $
	    GSTYLE=gstyle, GTHICK=gthick, GCOL=gcol, HIRES=hires
;Procedure to draw rotated grid axes.
;(C) NCAS 2010

IF (N_ELEMENTS(degspacing) EQ 0) THEN degspacing=0.125
IF (N_ELEMENTS(xlab) EQ 0) THEN xlab=1
IF (N_ELEMENTS(ylab) EQ 0) THEN ylab=1
IF (N_ELEMENTS(countries) EQ 0) THEN countries=0
IF (N_ELEMENTS(continents) EQ 0) THEN continents=0
IF (N_ELEMENTS(cstyle) EQ 0) THEN cstyle=0
IF (N_ELEMENTS(cthick) EQ 0) THEN cthick=100
IF (N_ELEMENTS(ccol) EQ 0) THEN ccol=1
IF (N_ELEMENTS(gstyle) EQ 0) THEN gstyle=1
IF (N_ELEMENTS(gthick) EQ 0) THEN gthick=100
IF (N_ELEMENTS(gcol) EQ 0) THEN gcol=1
yin=yin_orig
xpts=N_ELEMENTS(xin)
ypts=N_ELEMENTS(yin)

;Flip y axis if data upside down.
IF (yin(0) GT yin(ypts-1)) THEN BEGIN
 yin=REVERSE(yin)
ENDIF

;Draw a box around the plot.
pt=CONVERT_COORD(!P.POSITION(0), !P.POSITION(1), /NORMAL, /TO_DEVICE)
xmin=pt(0)
ymin=pt(1)
pt=CONVERT_COORD(!P.POSITION(2), !P.POSITION(3), /NORMAL, /TO_DEVICE)
xmax=pt(0)
ymax=pt(1)
GPLOT, X=[xmin, xmin, xmax, xmax, xmin], Y=[ymin, ymax, ymax, ymin, ymin], /DEVICE


RGUNROT, XIN=xin, YIN=yin, XOUT=xout, YOUT=yout, XPOLE=xpole, YPOLE=ypole
;Convert longs to -180 to 180 if necessary.
xwrap=0
IF (xout(0,0) LT xout(xpts-1)) THEN xwrap=1
IF (xwrap EQ 0) THEN lonpts=((xout + 180) MOD 360)-180 ELSE lonpts=xout


lonmin=FLOAT(FIX(MIN(lonpts))-2)
lonmax=FLOAT(FIX(MAX(lonpts))+2)
latmin=FLOAT(FIX(MIN(yout))-2)
latmax=FLOAT(FIX(MAX(yout))+2)
xrange=FIX(lonmax-lonmin)
yrange=FIX(latmax-latmin)


xstep=10
IF (xrange LE 50) THEN xstep=5
IF (xrange LE 20) THEN xstep=4
ystep=10
IF (yrange LE 50) THEN ystep=5
IF (yrange LE 20) THEN ystep=4


IF (xwrap EQ 0) THEN lons=INDGEN(360/xstep+1)*xstep-180 ELSE lons=INDGEN(360/xstep+1)*xstep
pts=WHERE(lons GE lonmin, count)
IF (count GT 0) THEN lons=lons(pts)
pts=WHERE(lons LE lonmax, count)
IF (count GT 0) THEN lons=lons(pts)
lats=INDGEN(180/ystep+1)*ystep-90
pts=WHERE(lats GE latmin, count)
IF (count GT 0) THEN lats=lats(pts)
pts=WHERE(lats LE latmax, count)
IF (count GT 0) THEN lats=lats(pts)


;Longitudes.
FOR ix=0, N_ELEMENTS(lons)-1 DO BEGIN
 ipts=(latmax-latmin)/degspacing
 lona=FLTARR(ipts)+lons(ix)
 lata=latmin+FINDGEN(ipts)*degspacing
 RGROT, XIN=lona, YIN=lata, XOUT=xout, YOUT=yout, XPOLE=xpole, YPOLE=ypole
 ;xin=((xin + 180) MOD 360)-180 ;Convert to -180 to 180.
 ;xout=((xout + 180) MOD 360)-180 ;Convert to -180 to 180.
 xyloc=LOC(XVEC=xin, XVALS=xout, YVEC=yin, YVALS=yout)
 
 ;Plot grid points if valid.
 GPLOT, x=xyloc(*,0), Y=xyloc(*,1), STYLE=gstyle, THICK=gthick, COL=gcol
 
 ;Plot lower axis labels if required.
 IF ((ylab EQ 1) or (ylab EQ 3)) THEN BEGIN
  pts=WHERE(xyloc(*,1) GE 0.0, count)
  IF (count GE 1) THEN BEGIN
   ipt=MIN(pts)
   IF (xyloc(ipt,0) GE 0) THEN BEGIN
    y0=ymin-200
    x0=xmin+xyloc(ipt,0)/(xpts-1)*(xmax-xmin)
    GPLOT, X=[x0, x0], Y=[ymin, ymin-150], /DEVICE
    GPLOT, X=x0, Y=y0-50 , TEXT=SCROP(((lons(ix) + 180) MOD 360)-180), ALIGN=0.5, VALIGN=1.0, /DEVICE
   ENDIF
  ENDIF
 ENDIF
 
 ;Plot upper axis labels if required.
 IF ((ylab EQ 2) or (ylab EQ 3)) THEN BEGIN
  pts=WHERE(xyloc(*,1) GE 0.0, count1)
  IF (count1 GE 1) THEN BEGIN
   ipt=MAX(pts)
   IF (xyloc(ipt,0) GE 1) THEN BEGIN
    y0=ymax+200
    x0=xmin+xyloc(ipt,0)/(xpts-1)*(xmax-xmin)
    GPLOT, X=[x0, x0], Y=[ymax, ymax+150], /DEVICE
    GPLOT, X=x0, Y=y0+50 , TEXT=SCROP(((lons(ix) + 180) MOD 360)-180), ALIGN=0.5, VALIGN=0.0, /DEVICE
   ENDIF
  ENDIF
 ENDIF
ENDFOR


;Latitudes.
FOR iy=0, N_ELEMENTS(lats)-1 DO BEGIN
 ipts=(lonmax-lonmin)/degspacing
 lona=lonmin+FINDGEN(ipts)*degspacing
 lata=FLTARR(ipts)+lats(iy)
 RGROT, XIN=lona, YIN=lata, XOUT=xout, YOUT=yout, XPOLE=xpole, YPOLE=ypole
 xyloc=LOC(XVEC=xin, XVALS=xout, YVEC=yin, YVALS=yout)
 
 ;Plot grid points if valid.
 GPLOT, x=xyloc(*,0), Y=xyloc(*,1), STYLE=gstyle, THICK=gthick, COL=gcol
 
 ;Plot left axis labels if required.
 IF ((xlab EQ 1) or (xlab EQ 3)) THEN BEGIN
  pts=WHERE(xyloc(*,0) GE 0.0, count)
  IF (count GE 1) THEN BEGIN
   ipt=MIN(pts)
   IF (xyloc(ipt,1) GE 1) THEN BEGIN
    y0=ymin+xyloc(ipt,1)/(ypts-1)*(ymax-ymin)
    x0=xmin-200
    GPLOT, X=[xmin, xmin-150], Y=[y0, y0], /DEVICE
    GPLOT, X=x0-30, Y=y0 , TEXT=SCROP(lats(iy)), ALIGN=1.0, VALIGN=0.5, /DEVICE
   ENDIF
  ENDIF
 ENDIF
 
  ;Plot right axis labels if required.
 IF ((xlab EQ 2) or (xlab EQ 3)) THEN BEGIN
  pts=WHERE(xyloc(*,0) GE 0.0, count)
  IF (count GE 1) THEN BEGIN
   ipt=MAX(pts)
   IF (xyloc(ipt,1) GE 1) THEN BEGIN
    y0=ymin+xyloc(ipt,1)/(ypts-1)*(ymax-ymin)
    x0=xmax+200
    GPLOT, X=[xmax, xmax+150], Y=[y0, y0], /DEVICE
    GPLOT, X=x0+30, Y=y0 , TEXT=SCROP(lats(iy)), ALIGN=0.0, VALIGN=0.5, /DEVICE
   ENDIF
  ENDIF
 ENDIF
ENDFOR



;Plot countries if requested.
IF KEYWORD_SET(countries) THEN BEGIN
 IF KEYWORD_SET(hires) THEN stateFile = Filepath(Subdirectory=['resource', 'maps', 'shape'], 'cntry02') ELSE $
                            stateFile = Filepath(Subdirectory=['resource', 'maps', 'shape'], 'country.shp')
 attribute_name='ISO_3DIGIT'
 shapefile = Obj_New('IDLffShape', stateFile)
 shapefile -> GetProperty, ATTRIBUTE_NAMES=theNames
 theNames = StrUpCase(StrTrim(theNames, 2))
 attIndex = Where(theNames EQ attribute_name, count)
 entities = Ptr_New(/Allocate_Heap)
 *entities = shapefile -> GetEntity(/All, /Attributes)
 count=0
 FOR j=0,N_Elements(*entities)-1 DO BEGIN
  thisEntity = (*entities)[j]
  theCountry = StrUpCase(StrTrim((*thisEntity.attributes).(attIndex), 2))
  ;index = Where(countries EQ theCountry, test)
  count=count+1
  cuts = [*thisentity.parts, thisentity.n_vertices]
  FOR k=0, thisentity.n_parts-1 DO BEGIN
   lons=(*thisentity.vertices)[0, cuts[k]:cuts[k+1]-1]
   lats=(*thisentity.vertices)[1, cuts[k]:cuts[k+1]-1]
   lons=REFORM(lons)
   lats=REFORM(lats)
   RGROT, XIN=lons, YIN=lats, XOUT=xout, YOUT=yout, XPOLE=xpole, YPOLE=ypole  
   xyloc=LOC(XVEC=xin, XVALS=xout, YVEC=yin, YVALS=yout)
   GPLOT, x=xyloc(*,0), Y=xyloc(*,1), STYLE=cstyle, THICK=cthick, COL=ccol
  ENDFOR
 ENDFOR
ENDIF


;Plot continents if requested.
IF KEYWORD_SET(continents) THEN BEGIN
 stateFile = Filepath(Subdirectory=['resource', 'maps', 'shape'], 'continents.shp')
 attribute_name='CNT'
 shapefile = Obj_New('IDLffShape', stateFile)
 shapefile -> GetProperty, ATTRIBUTE_NAMES=theNames
 theNames = StrUpCase(StrTrim(theNames, 1))
 attIndex = Where(theNames EQ attribute_name, count)
 entities = Ptr_New(/Allocate_Heap)
 *entities = shapefile -> GetEntity(/All, /Attributes)
 count=0
 FOR j=0,N_Elements(*entities)-1 DO BEGIN
  thisEntity = (*entities)[j]
  theCountry = StrUpCase(StrTrim((*thisEntity.attributes).(attIndex), 2))
  ;index = Where(countries EQ theCountry, test)
  count=count+1
  cuts = [*thisentity.parts, thisentity.n_vertices]
  FOR k=0, thisentity.n_parts-1 DO BEGIN
   lons=(*thisentity.vertices)[0, cuts[k]:cuts[k+1]-1]
   lats=(*thisentity.vertices)[1, cuts[k]:cuts[k+1]-1]
   lons=REFORM(lons)
   lats=REFORM(lats)
   RGROT, XIN=lons, YIN=lats, XOUT=xout, YOUT=yout, XPOLE=xpole, YPOLE=ypole    
   xyloc=LOC(XVEC=xin, XVALS=xout, YVEC=yin, YVALS=yout)
   GPLOT, x=xyloc(*,0), Y=xyloc(*,1), STYLE=cstyle, THICK=cthick, COL=ccol     
  ENDFOR
 ENDFOR
ENDIF

END

