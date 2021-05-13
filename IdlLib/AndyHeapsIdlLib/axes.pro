PRO AXES, XVALS=xvals, XLABELS=xlabels, YVALS=yvals, YLABELS=ylabels, $
          STEP=step, XSTEP=xstep, YSTEP=ystep, NDECS=ndecs, $
	  MINOR=minor, XMINOR=xminor, XMLABELS=xmlabels, YMINOR=yminor, YMLABELS=ymlabels, $
	  XTITLE=xtitle, YTITLE=ytitle, AXISTYPE=axistype, $
	  NOUPPER=noupper, NOLOWER=nolower, NOLEFT=noleft, NORIGHT=noright, $
	  ONLYUPPER=onlyupper, ONLYLOWER=onlylower, $
	  ONLYLEFT=onlyleft, ONLYRIGHT=onlyright, GRID=grid,$
	  HGRID=hgrid, VGRID=vgrid, GSTYLE=gstyle, GTHICK=gthick, GCOL=gcol, $
	  OFFSET=offset, COL=col, ORIENTATION=orientation, NOTICKS=noticks, $
	  NOLABELS=nolabels, BORDER=border
;Procedure to draw axes.
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
 PRINT, 'AXES error - MAP or GSET must be called first to establish coordinates.'
 PRINT, ''
 STOP
ENDIF

;Set the default font.
com=!guide.textfont
res=EXECUTE(com)
font=!guide.font
charsize=!guide.charsize
space1=!guide.space1
space2=!guide.space2
space3=!guide.space3
IF NOT KEYWORD_SET(noticks) THEN tlen=!guide.ticklen ELSE tlen=0 ;Our tick length in pixels
xpix=!guide.xpix
ypix=!guide.ypix
IF (N_ELEMENTS(GRID) EQ 0) THEN GRID=0
IF (N_ELEMENTS(HGRID) EQ 0) THEN HGRID=0
IF (N_ELEMENTS(VGRID) EQ 0) THEN VGRID=0
IF (N_ELEMENTS(GSTYLE) EQ 0) THEN GSTYLE=0
IF (N_ELEMENTS(GTHICK) EQ 0) THEN GTHICK=100
IF (N_ELEMENTS(GCOL) EQ 0) THEN GCOL=1
IF (N_ELEMENTS(ORIENTATION) EQ 0) THEN orientation=0
IF (N_ELEMENTS(AXISTYPE) EQ 0) THEN axistype=!guide.axistype
IF (orientation EQ 0) THEN alignment=0.5
IF (orientation GT 0) THEN alignment=1.0
IF (orientation LT 0) THEN alignment=0.0
IF (orientation EQ 0) THEN textoffset=0
IF (orientation GT 0) THEN textoffset=ypix/2.0
IF (orientation LT 0) THEN textoffset=-ypix/2.0

axisoffset=0
IF (N_ELEMENTS(offset) NE 0) THEN axisoffset=offset
border_thick=!guide.border_thick

map_type=!MAP.projection
;Projection types
;0 = None
;1 = Polar stereographic
;2 = Othographic
;7 = Satellite
;8 = Cylindrical
;10 = Mollweide
;17 = Robinson

IF ((map_type NE 1) AND (map_type NE 2) AND (map_type NE 17) AND (map_type NE 10)) THEN BEGIN

pt=CONVERT_COORD(!guide.xmin, !guide.ymin, /DATA, /TO_DEVICE)
xmin=pt(0)
ymin=pt(1)
pt=CONVERT_COORD(!guide.xmax, !guide.ymax, /DATA, /TO_DEVICE)
xmax=pt(0)
ymax=pt(1)
;take care of cylindrical projection wrapping
IF (map_type EQ 8) THEN BEGIN
 pt=CONVERT_COORD(!P.POSITION(0), !P.POSITION(1), /NORM, /TO_DEVICE)
 xmin=pt(0)
 pt=CONVERT_COORD(!P.POSITION(2), !P.POSITION(1), /NORM, /TO_DEVICE)
 xmax=pt(0)
ENDIF

IF KEYWORD_SET(BORDER) THEN BEGIN
 NOLEFT=1
 NORIGHT=1
 NOLOWER=1
 NOUPPER=1
 IF KEYWORD_SET(ONLYLOWER) THEN NOLOWER=0
 IF KEYWORD_SET(ONLYUPPER) THEN NOUPPER=0
 IF KEYWORD_SET(ONLYLEFT) THEN NOLEFT=0
 IF KEYWORD_SET(ONLYRIGHT) THEN NORIGHT=0 
ENDIF


;Axis omission
IF (KEYWORD_SET(ONLYLOWER) OR KEYWORD_SET(ONLYUPPER) OR $
    KEYWORD_SET(ONLYLEFT) OR KEYWORD_SET(ONLYRIGHT)) THEN BEGIN
 NOLOWER=1
 NOUPPER=1
 NOLEFT=1
 NORIGHT=1
 IF KEYWORD_SET(ONLYLOWER) THEN NOLOWER=0
 IF KEYWORD_SET(ONLYUPPER) THEN NOUPPER=0
 IF KEYWORD_SET(ONLYLEFT) THEN NOLEFT=0
 IF KEYWORD_SET(ONLYRIGHT) THEN NORIGHT=0
ENDIF


;Generate labels for cylindrical projection maps
IF (map_type EQ 8) THEN BEGIN 
 latmin=!guide.ymin
 lonmin=!guide.xmin
 latmax=!guide.ymax
 lonmax=!guide.xmax 
 extra=''
 IF ((AXISTYPE EQ 2) OR (AXISTYPE EQ 3))  THEN extra="!Eo!N"
 ;Take care of going over the dateline.
 IF (lonmin GT lonmax) THEN BEGIN
  lonmin=(lonmin+360.0) MOD 360.0 ; Convert longitudes to 0 to 360.
  lonmax=(lonmax+360.0) MOD 360.0 
 ENDIF
 IF (NOT KEYWORD_SET(STEP)) THEN BEGIN
  xstep2=30
  IF (lonmax-lonmin LE 150) THEN xstep2=20
  IF (lonmax-lonmin LE 90) THEN xstep2=10
  IF (lonmax-lonmin LE 30) THEN xstep2=5
  IF (lonmax-lonmin LE 10) THEN xstep2=1
 ENDIF
 IF KEYWORD_SET(XSTEP) THEN xstep2=xstep
 IF KEYWORD_SET(STEP) THEN xstep2=step
 xn=360/xstep2+1
 xarr=[REVERSE(0-INDGEN(xn)*xstep2), INDGEN(xn-1)*xstep2+xstep2]
 xarr=xarr(MIN(WHERE(xarr GE lonmin)):MAX(WHERE(xarr LE lonmax)))
 lonmin=xarr(0)
 npts=N_ELEMENTS(xarr)
 xlabels=STRARR(npts)
 xvals=FINDGEN(npts)

 mydeg=FIX(lonmin-(LONG(lonmin)/180)*360.0)
 ;IF (mydeg LT lonmin) THEN mydeg=mydeg+xstep2 ;Commented out for PLV problem of 27/6/2012
 IF (lonmin EQ -180) THEN  mydeg=FIX(lonmin)
 IF ((mydeg EQ -360) OR (mydeg EQ 360)) THEN mydeg=0
 FOR i=0, npts-1 DO BEGIN
  IF ((mydeg LT -180) OR (mydeg GT 180)) THEN mydeg=FIX(mydeg-(LONG(mydeg)/180)*360.0)
  xlabels(i)=SCROP(ABS(mydeg), NDECS=ndecs)+extra
  IF ((mydeg LT 0) AND ((axistype EQ 1) OR (axistype EQ 3))) THEN xlabels(i)='-'+xlabels(i)
  IF ((axistype EQ 0) OR (axistype EQ 2)) THEN BEGIN
   IF (mydeg LT 0) THEN xlabels(i)=xlabels(i)+'W'
   IF (mydeg GT 0) THEN xlabels(i)=xlabels(i)+'E'
  ENDIF  
  IF (mydeg EQ 0) THEN xlabels(i)='0'
  IF ((mydeg EQ -180) AND (i NE 0)) THEN xlabels(i)='180'
  IF ((mydeg EQ 180) AND (i NE npts-1)) THEN xlabels(i)='180'
  xvals(i)=mydeg
  mydeg=mydeg+xstep2
 ENDFOR


;stop
 IF (NOT KEYWORD_SET(STEP)) THEN BEGIN
  ystep2=30
  IF (latmax-latmin LT 90) THEN ystep2=10
  IF (latmax-latmin LE 30) THEN ystep2=5
  IF (latmax-latmin LE 10) THEN ystep2=1
 ENDIF
 IF KEYWORD_SET(YSTEP) THEN ystep2=ystep
 IF KEYWORD_SET(STEP) THEN ystep2=step
 yn=180/ystep2+1
 yarr=[REVERSE(0-INDGEN(yn)*ystep2), INDGEN(yn-1)*ystep2+ystep2]
 yarr=yarr(MIN(WHERE(yarr GE latmin)):MAX(WHERE(yarr LE latmax)))
 latmin=yarr(0)
 npts=N_ELEMENTS(yarr)
 ylabels=STRARR(npts)
 yvals=FINDGEN(npts)
 
 mydeg=FIX(latmin)
 IF (mydeg LT latmin) THEN mydeg=mydeg+ystep2
 FOR i=0, npts-1 DO BEGIN
  ylabels(i)=SCROP(ABS(mydeg), NDECS=ndecs)+extra
  IF ((mydeg LT 0) AND ((axistype EQ 1) OR (axistype EQ 3))) THEN ylabels(i)='-'+ylabels(i)
  IF ((axistype EQ 0) OR (axistype EQ 2)) THEN BEGIN  
   IF (mydeg LT 0) THEN ylabels(i)=ylabels(i)+'S'
   IF (mydeg GT 0) THEN ylabels(i)=ylabels(i)+'N'
  ENDIF
  IF (mydeg EQ 0) THEN ylabels(i)='0'
  yvals(i)=mydeg
  mydeg=mydeg+ystep2
 ENDFOR


ENDIF ELSE BEGIN
 ;Labels for graphs
 ;If no options then generate xvals and yvals
 IF ((N_ELEMENTS(STEP)+N_ELEMENTS(XSTEP)+N_ELEMENTS(XVALS)) EQ 0) THEN BEGIN
  xpts=4
  FOR npts=4, 10 DO BEGIN
   spacing=(!guide.xmax-!guide.xmin)/FLOAT(npts)
   IF (spacing EQ FIX(spacing)) THEN xpts=npts
  ENDFOR 
  spacing=(!guide.xmax-!guide.xmin)/FLOAT(xpts)
  xvals=FLTARR(xpts+1)
  FOR ix=0, xpts DO BEGIN
   xvals(ix)=!guide.xmin+ix*spacing
  ENDFOR
  IF (spacing EQ FIX(spacing)) THEN xvals=FIX(xvals) 
  IF (spacing EQ FIX(spacing)) THEN xstep=FIX(spacing) ELSE xstep=spacing 
 ENDIF
 IF ((N_ELEMENTS(STEP)+N_ELEMENTS(YSTEP)+N_ELEMENTS(YVALS)) EQ 0) THEN BEGIN
  ypts=4
  FOR npts=4, 10 DO BEGIN
   spacing=(!guide.ymax-!guide.ymin)/FLOAT(npts)
   IF (spacing EQ FIX(spacing)) THEN ypts=npts
  ENDFOR 
  spacing=(!guide.ymax-!guide.ymin)/FLOAT(ypts)
  yvals=FLTARR(ypts+1)
  FOR iy=0, ypts DO BEGIN
   yvals(iy)=!guide.ymin+iy*spacing
  ENDFOR 
  IF (spacing EQ FIX(spacing)) THEN yvals=FIX(yvals)
  IF (spacing EQ FIX(spacing)) THEN ystep=FIX(spacing) ELSE ystep=spacing    
 ENDIF


 IF (N_ELEMENTS(STEP) NE 0) THEN xstep=step
 IF (N_ELEMENTS(STEP) NE 0) THEN ystep=step
 IF (N_ELEMENTS(NDECS) NE 0) THEN fmt='(f0.'+SCROP(ndecs(0))+')'
 IF ((N_ELEMENTS(XSTEP) NE 0)) THEN BEGIN
  nvals=ABS((!guide.xmax-!guide.xmin)/xstep+1)
  IF (SIZE(xstep, /TYPE) EQ 2) THEN BEGIN
   xvals=INTARR(nvals)
   nxdecs=0
  ENDIF
  IF (SIZE(xstep, /TYPE) EQ 4) THEN BEGIN
   xvals=FLTARR(nvals)
   IF (N_ELEMENTS(ndecs) NE 0) THEN nxdecs=ndecs(0) ELSE nxdecs=6
  ENDIF
  FOR ix=0, nvals-1 do begin
   xvals(ix)=!guide.xmin+ix*xstep
  ENDFOR
  IF (N_ELEMENTS(nxdecs) NE 0) THEN BEGIN
   IF (nxdecs GT 0) THEN xvals=STRING(xvals, FORMAT=fmt)
   IF (nxdecs EQ 0) THEN xvals=FIX(xvals)
  ENDIF
 ENDIF
 IF ((N_ELEMENTS(YSTEP) NE 0)) THEN BEGIN
  IF (N_ELEMENTS(NDECS) EQ 2) THEN fmt='(f0.'+SCROP(ndecs(1))+')'
  nvals=ABS((!guide.ymax-!guide.ymin)/ystep+1)
  IF (SIZE(ystep, /TYPE) EQ 2) THEN BEGIN
   yvals=INTARR(nvals)
   nydecs=0
  ENDIF
  IF (SIZE(ystep, /TYPE) EQ 4) THEN BEGIN
   yvals=FLTARR(nvals)
   nydecs=6
   IF (N_ELEMENTS(ndecs) EQ 1) THEN nydecs=ndecs(0)
   IF (N_ELEMENTS(ndecs) EQ 2) THEN nydecs=ndecs(1)
  ENDIF
  FOR iy=0, nvals-1 do begin
   yvals(iy)=!guide.ymin+iy*ystep
  ENDFOR
  IF (N_ELEMENTS(nydecs) NE 0) THEN BEGIN
   IF (nydecs GT 0) THEN yvals=STRING(yvals, FORMAT=fmt)
   IF (nydecs EQ 0) THEN yvals=FIX(yvals)
  ENDIF
 ENDIF

ENDELSE

;Draw the border first.
;Cylindrical projection.
IF (map_type EQ 8) THEN BEGIN
 pt=CONVERT_COORD(!guide.xmin, !guide.ymin, /DATA, /TO_DEVICE)
 ymin=pt(1)
 pt=CONVERT_COORD(!guide.xmax, !guide.ymax, /DATA, /TO_DEVICE)
 ymax=pt(1)
 pt=CONVERT_COORD(!P.POSITION(0), !P.POSITION(1), /NORM, /TO_DEVICE)
 xmin=pt(0)
 pt=CONVERT_COORD(!P.POSITION(2), !P.POSITION(1), /NORM, /TO_DEVICE)
 xmax=pt(0)
 IF (KEYWORD_SET(BORDER) OR (NOT KEYWORD_SET(NOLOWER))) THEN PLOTS, [xmin, xmax], [ymin, ymin], THICK=border_thick, /DEVICE
 IF (KEYWORD_SET(BORDER) OR (NOT KEYWORD_SET(NOUPPER))) THEN PLOTS, [xmin, xmax], [ymax, ymax], THICK=border_thick, /DEVICE
 IF (KEYWORD_SET(BORDER) OR (NOT KEYWORD_SET(NOLEFT)))  THEN PLOTS, [xmin, xmin], [ymin, ymax], THICK=border_thick, /DEVICE
 IF (KEYWORD_SET(BORDER) OR (NOT KEYWORD_SET(NORIGHT))) THEN PLOTS, [xmax, xmax], [ymin, ymax], THICK=border_thick, /DEVICE
ENDIF


;X-axes.
IF (N_ELEMENTS(MINOR) EQ 1) THEN xminor=minor

;Lower X-axis
IF (NOT KEYWORD_SET(NOLOWER)) THEN BEGIN
 IF (NOT KEYWORD_SET(XLABELS)) THEN xlabels=SCROP(XVALS)
 FOR ix=0, N_ELEMENTS(XVALS)-1 DO BEGIN
  pt=CONVERT_COORD(xvals(ix), !guide.ymin, /DATA, /TO_DEVICE)
  IF (map_type EQ 8) THEN BEGIN 
   ;Next two lines take care of longitude wrapping
   IF ((ix EQ 0) AND (SCROP(pt(0)) EQ SCROP(xmax))) THEN pt(0)=xmin
   IF ((ix EQ N_ELEMENTS(XVALS)-1) AND (SCROP(pt(0)) EQ SCROP(xmin)) ) THEN pt(0)=xmax
  ENDIF
  PLOTS, [pt(0), pt(0)], [pt(1)-axisoffset, pt(1)-tlen-axisoffset], COLOR=col, /DEVICE
  IF (tlen LT 0) THEN offset=space1+ypix ELSE offset=tlen+space1+ypix
  IF NOT KEYWORD_SET(NOLABELS) THEN  XYOUTS, pt(0)+textoffset, pt(1)-offset-axisoffset+ABS(textoffset), $
                                             XLABELS(ix), ALIGNMENT=alignment, ORIENTATION=orientation, FONT=0, $
	                                     CHARSIZE=charsize, COLOR=col, /DEVICE					     
 ENDFOR
 ;Add minor tickmarks and labels.
 IF (N_ELEMENTS(XMLABELS) EQ 0) THEN xlablen=0 ELSE xlablen=1
 IF (N_ELEMENTS(XMINOR) EQ 1) THEN BEGIN
  FOR ix=!guide.xmin, !guide.xmax, xminor DO BEGIN
   pts=WHERE(ix EQ xvals, count)
   IF (count EQ 0) THEN BEGIN
    IF (N_ELEMENTS(xmlabs) GE 1) THEN xmlabs=[xmlabs, ix]
    IF (N_ELEMENTS(xmlabs) EQ 0) THEN xmlabs=ix 
   ENDIF 
  ENDFOR
  vtype=SIZE(xminor, /TYPE)
  xmlabels=xmlabs
  IF ((vtype EQ 2) OR (vtype EQ 3)) THEN xmlabels=SCROP(xmlabels, NDECS=0)
  IF (N_ELEMENTS(ndecs) EQ 1) THEN xmlabels=SCROP(xmlabels, NDECS=ndecs)
  IF (N_ELEMENTS(ndecs) EQ 2) THEN xmlabels=SCROP(xmlabels, NDECS=ndecs(0))
  xminor=xmlabs
  IF (xlablen EQ 0) THEN xmlabels=STRARR(N_ELEMENTS(xmlabels))
 ENDIF
 IF (N_ELEMENTS(XMINOR) GT 1) THEN BEGIN
  FOR ix=0, N_ELEMENTS(xminor)-1 DO BEGIN
   pt=CONVERT_COORD(xminor(ix), !guide.ymin, /DATA, /TO_DEVICE)
   PLOTS, [pt(0), pt(0)], [pt(1)-axisoffset, pt(1)-tlen*0.5-axisoffset], COLOR=col, /DEVICE
   IF (N_ELEMENTS(xmlabels) GE 1) THEN XYOUTS, pt(0)+textoffset, pt(1)-offset*0.7-axisoffset+ABS(textoffset), $
                                       SCROP(XMLABELS(ix)), ALIGNMENT=alignment, ORIENTATION=orientation, FONT=0, $
	                               CHARSIZE=charsize*0.8, COLOR=col, /DEVICE			  
  ENDFOR
 ENDIF
 ;Add title.
 IF (N_ELEMENTS(XTITLE) NE 0) THEN BEGIN
  xmid=(xmin+xmax)/2.0
  IF (tlen LT 0) THEN offset=2*ypix+3*space1 ELSE offset=tlen+2*ypix+3*space1
  IF NOT KEYWORD_SET(NOLABELS) THEN XYOUTS, xmid, pt(1)-offset-axisoffset, xtitle, ALIGNMENT=0.5, $
                                            FONT=0, CHARSIZE=charsize, COLOR=col, /DEVICE
 ENDIF  
ENDIF

;Top X-axis
IF (NOT KEYWORD_SET(NOUPPER)) THEN BEGIN
 IF (NOT KEYWORD_SET(XLABELS)) THEN xlabels=SCROP(XVALS)
 FOR ix=0, N_ELEMENTS(XVALS)-1 DO BEGIN
  pt=CONVERT_COORD(xvals(ix), !guide.ymax, /DATA, /TO_DEVICE)
  IF (map_type EQ 8) THEN BEGIN 
   ;Next two lines take care of longitude wrapping
   IF ((ix EQ 0) AND (SCROP(pt(0)) EQ SCROP(xmax))) THEN pt(0)=xmin
   IF ((ix EQ N_ELEMENTS(XVALS)-1) AND (SCROP(pt(0)) EQ SCROP(xmin)) ) THEN pt(0)=xmax
  ENDIF
  PLOTS, [pt(0), pt(0)], [pt(1)+axisoffset, pt(1)+tlen+axisoffset], COLOR=col, /DEVICE
  IF (KEYWORD_SET(ONLYUPPER)) THEN BEGIN
   IF (tlen LT 0) THEN offset=space1 ELSE offset=tlen+space1
   IF NOT KEYWORD_SET(NOLABELS) THEN XYOUTS, pt(0), pt(1)+offset+axisoffset, XLABELS(ix), ALIGNMENT=0.5, $
                                             FONT=0, CHARSIZE=charsize, COLOR=col, /DEVICE
  ENDIF
 ENDFOR
 IF (KEYWORD_SET(ONLYUPPER)) THEN BEGIN
  IF (N_ELEMENTS(XTITLE) NE 0) THEN BEGIN
   xmid=(xmin+xmax)/2.0
   IF (tlen LT 0) THEN offset=ypix+2*space1 ELSE offset=tlen+ypix+2*space1
   IF NOT KEYWORD_SET(NOLABELS) THEN XYOUTS, xmid, pt(1)+offset+axisoffset, xtitle, $
                                             ALIGNMENT=0.5, FONT=0, CHARSIZE=charsize, $
					     COLOR=col, /DEVICE
  ENDIF
 ENDIF
 IF (N_ELEMENTS(XMINOR) GT 1) THEN BEGIN
  FOR ix=0, N_ELEMENTS(xminor)-1 DO BEGIN
   pt=CONVERT_COORD(xminor(ix), !guide.ymax, /DATA, /TO_DEVICE)
   PLOTS, [pt(0), pt(0)], [pt(1)+axisoffset, pt(1)+tlen*0.5+axisoffset], COLOR=col, /DEVICE 
  ENDFOR
 ENDIF 
ENDIF


;Y-axes.
IF (N_ELEMENTS(MINOR) EQ 1) THEN yminor=minor

;Left Y-axis
IF (NOT KEYWORD_SET(NOLEFT)) THEN BEGIN
 IF (N_ELEMENTS(YLABELS) EQ 0) THEN ylabels=SCROP(YVALS) ELSE ylabels=SCROP(YLABELS)
 FOR iy=0, N_ELEMENTS(YVALS)-1 DO BEGIN
  pt=CONVERT_COORD(!guide.xmin, yvals(iy), /DATA, /TO_DEVICE)
  PLOTS, [xmin-axisoffset, xmin-tlen-axisoffset], [pt(1), pt(1)], COLOR=col, /DEVICE
  IF (tlen LT 0) THEN offset=space1 ELSE offset=tlen+space1
  IF NOT KEYWORD_SET(NOLABELS) THEN XYOUTS, xmin-offset-axisoffset, pt(1)-ypix/2.0, YLABELS(iy), $
                                            ALIGNMENT=1.0, FONT=0, CHARSIZE=charsize, COLOR=col, $
					    /DEVICE
 ENDFOR
 ;Add minor tickmarks and labels.
 IF (N_ELEMENTS(YMLABELS) EQ 0) THEN ylablen=0 ELSE ylablen=1
 IF (N_ELEMENTS(YMINOR) EQ 1) THEN BEGIN
  FOR iy=!guide.ymin, !guide.ymax, yminor DO BEGIN
   pts=WHERE(iy EQ yvals, count)
   IF (count EQ 0) THEN BEGIN
    IF (N_ELEMENTS(ymlabs) GE 1) THEN ymlabs=[ymlabs, iy]
    IF (N_ELEMENTS(ymlabs) EQ 0) THEN ymlabs=iy 
   ENDIF 
  ENDFOR
  vtype=SIZE(yminor, /TYPE)
  ymlabels=ymlabs
  IF ((vtype EQ 2) OR (vtype EQ 3)) THEN ymlabels=SCROP(ymlabels, NDECS=0)
  IF (N_ELEMENTS(ndecs) EQ 1) THEN ymlabels=SCROP(ymlabels, NDECS=ndecs)
  IF (N_ELEMENTS(ndecs) EQ 2) THEN ymlabels=SCROP(ymlabels, NDECS=ndecs(1))
  yminor=ymlabs
  IF (ylablen EQ 0) THEN ymlabels=STRARR(N_ELEMENTS(ymlabels))
 ENDIF
 IF (N_ELEMENTS(YMINOR) GT 1) THEN BEGIN
  FOR iy=0, N_ELEMENTS(yminor)-1 DO BEGIN
   pt=CONVERT_COORD(!guide.xmin, yminor(iy), /DATA, /TO_DEVICE)
   PLOTS, [xmin-axisoffset, xmin-tlen*0.6-axisoffset], [pt(1), pt(1)], COLOR=col, /DEVICE
   IF (N_ELEMENTS(ymlabels) GE 1) THEN XYOUTS, xmin-offset*0.7-axisoffset, pt(1)-ypix/2.0, ymlabels(iy), $
	                                       ALIGNMENT=1.0, FONT=0, CHARSIZE=charsize*0.8, COLOR=col, $
	                                      /DEVICE                            
  ENDFOR
 ENDIF 
 ;Add title.
 IF (N_ELEMENTS(YTITLE) NE 0) THEN BEGIN
  ;Calculate width of ylabels by plotting the text once.
  maxwidth=0.0
  FOR i=0, N_ELEMENTS(ylabels)-1 DO BEGIN
   IF NOT KEYWORD_SET(NOLABELS) THEN XYOUTS, 0, 0, ylabels(i), FONT=0, CHARSIZE=charsize, $
                                             WIDTH=width, ALIGNMENT=0.0, COLOR=0, /DEVICE
   IF (width*!d.x_size GT maxwidth) THEN maxwidth=width*!d.x_size
  ENDFOR 
  IF (tlen LT 0) THEN offset=4*space1+maxwidth ELSE offset=tlen+4*space1+maxwidth
  ymid=(ymax-ymin)/2.0+ymin
  IF NOT KEYWORD_SET(NOLABELS) THEN XYOUTS, xmin-offset-axisoffset, ymid, ytitle, $
                                            FONT=0, CHARSIZE=charsize, $
                                            ORIENTATION=90.0, ALIGNMENT=0.5, COLOR=col, /DEVICE
 ENDIF
ENDIF

;Right Y-axis
IF (NOT KEYWORD_SET(NORIGHT)) THEN BEGIN
 IF (N_ELEMENTS(YLABELS) EQ 0) THEN ylabels=SCROP(YVALS) ELSE ylabels=SCROP(YLABELS)
  FOR iy=0, N_ELEMENTS(YVALS)-1 DO BEGIN
  pt=CONVERT_COORD(!guide.xmax, yvals(iy), /DATA, /TO_DEVICE)
  IF (map_type EQ 8) THEN BEGIN 
   ;Take care of longitude wrapping
   IF ((SCROP(pt(0)) EQ SCROP(xmin))) THEN pt(0)=xmax
  ENDIF 
  PLOTS, [pt(0)+axisoffset, pt(0)+tlen+axisoffset], [pt(1), pt(1)], COLOR=col, /DEVICE
  IF (KEYWORD_SET(ONLYRIGHT)) THEN BEGIN
   IF (tlen LT 0) THEN offset=space1 ELSE offset=tlen+space1
   IF NOT KEYWORD_SET(NOLABELS) THEN XYOUTS, pt(0)+offset+axisoffset, pt(1)-ypix/2.0, YLABELS(iy), $
                                             ALIGNMENT=0.0, FONT=0, CHARSIZE=charsize, COLOR=col, $
					     /DEVICE
  ENDIF
 ENDFOR
 IF (KEYWORD_SET(ONLYRIGHT)) THEN BEGIN
  IF (N_ELEMENTS(YTITLE) NE 0) THEN BEGIN
   ;Calculate width of ylabels by plotting the text once.
   maxwidth=0.0
   FOR i=0, N_ELEMENTS(ylabels)-1 DO BEGIN
    IF NOT KEYWORD_SET(NOLABELS) THEN XYOUTS, 0, 0, ylabels(i), FONT=0, CHARSIZE=charsize, $
                                              WIDTH=width, ALIGNMENT=0.0, COLOR=0, /DEVICE
    IF (width*!d.x_size GT maxwidth) THEN maxwidth=width*!d.x_size
   ENDFOR 
   IF (tlen LT 0) THEN offset=5*space1+maxwidth ELSE offset=tlen+5*space1+maxwidth
   ymid=(ymax-ymin)/2.0+ymin
   IF NOT KEYWORD_SET(NOLABELS) THEN XYOUTS, xmax+offset+axisoffset, ymid, ytitle, $
                                             FONT=0, CHARSIZE=charsize, $
                                             ORIENTATION=90.0, ALIGNMENT=0.5, COLOR=col, /DEVICE
  ENDIF
 ENDIF
 ;Add minor tickmarks 
 IF (N_ELEMENTS(YMINOR) EQ 1) THEN BEGIN
  FOR iy=!guide.ymin, !guide.ymax, yminor DO BEGIN
   pt=CONVERT_COORD(!guide.xmax, iy, /DATA, /TO_DEVICE)
   PLOTS, [pt(0)+axisoffset, pt(0)+tlen*0.6+axisoffset], [pt(1), pt(1)], COLOR=col, /DEVICE
  ENDFOR
 ENDIF
 IF (N_ELEMENTS(YMINOR) GT 1) THEN BEGIN
  FOR iy=0, N_ELEMENTS(yminor)-1 DO BEGIN
   pt=CONVERT_COORD(!guide.xmax, yminor(iy), /DATA, /TO_DEVICE)
   PLOTS, [pt(0)+axisoffset, pt(0)+tlen*0.6+axisoffset], [pt(1), pt(1)], COLOR=col, /DEVICE
  ENDFOR
 ENDIF 
ENDIF
;ENDIF

ENDIF 

;Polar stereo or Orthograthic
sector=0
IF (N_ELEMENTS(!guide.sector) GT 0) THEN sector=!guide.sector
IF ((map_type EQ 1) OR (map_type EQ 2) AND (sector NE 1)) THEN BEGIN
 latmin=!map.ll_box(0)
 lonmin=(!map.ll_box(1)+360.0) MOD 360.0 ; Convert longitudes to 0 to 360.
 latmax=!map.ll_box(2)
 lonmax=(!map.ll_box(3)+360.0) MOD 360.0 ; Convert longitudes to 0 to 360.
 map_centre=(lonmax-lonmin)/2
 IF (lonmin EQ lonmax) THEN map_centre=lonmin-180
 
 IF (latmax EQ 90) THEN BEGIN
  eqlat=latmin 
  plat=90
 ENDIF ELSE BEGIN
  eqlat=latmax 
  plat=-90
 ENDELSE 
 hem=1
 IF (latmin EQ -90.0) THEN hem=-1 
 ;Calculate the labels to use
 d=CONVERT_COORD(0.0,plat, /DATA, /TO_DEVICE)
 xmid=d(0)
 ymid=d(1)
 
 d=CONVERT_COORD(map_centre, eqlat, /DATA, /TO_DEVICE)
 rad=ABS(ymid-d(1))

 IF (N_ELEMENTS(STEP) EQ 0) THEN step=30
 IF (N_ELEMENTS(XSTEP) NE 0) THEN step=xstep
 npts=360/step
 mydeg=-180
 extra=''
 IF ((AXISTYPE EQ 2) OR (AXISTYPE EQ 3)) THEN extra="!Eo!N"

 FOR i=0, npts-1 DO BEGIN
  IF (mydeg*hem GT 0) THEN label=SCROP(ABS(mydeg))+extra+'W'
  IF (mydeg*hem LT 0) THEN label=SCROP(ABS(mydeg))+extra+'E'
  IF (mydeg EQ 0) THEN label='0'+extra
  IF ((MYDEG EQ -180) OR (MYDEG EQ 180)) THEN label='180'+extra
  
  ;x and y position of start of tickmarks.
  xpt=xmid+hem*rad*SIN((mydeg+lonmax*hem)*!DTOR) 
  ypt=ymid+hem*rad*COS((mydeg+lonmax*hem)*!DTOR)

  ;x and y position of end of the tickmarks.
  xpt2=xmid+hem*(rad+tlen)*SIN((mydeg+lonmax*hem)*!DTOR) ;x and y pos
  ypt2=ymid+hem*(rad+tlen)*COS((mydeg+lonmax*hem)*!DTOR)  
     
  ;x and y position of text position.
  trad=rad+space1
  IF (tlen GT 0) THEN trad=rad+tlen+space1
  xpt3=xmid+hem*trad*SIN((mydeg+lonmax*hem)*!DTOR)
  ypt3=ymid+hem*trad*COS((mydeg+lonmax*hem)*!DTOR)      
     
  ;Plot the tickmark.
  IF (tlen GT 0) THEN PLOTS, [xpt, xpt2], [ypt, ypt2], /DEVICE 
  
  ;Align text properly
  IF (ABS(xpt3-xmid) LE 1.0) THEN BEGIN
   IF NOT KEYWORD_SET(NOLABELS) THEN BEGIN
    IF (ypt GT ymid) THEN XYOUTS, xpt3, ypt3, label, ALIGNMENT=0.5, $
                                  FONT=0, CHARSIZE=charsize, /DEVICE
    IF (ypt LT ymid) THEN XYOUTS, xpt3, ypt3-ypix, label, ALIGNMENT=0.5, $
                                   FONT=0, CHARSIZE=charsize, /DEVICE
   ENDIF
  ENDIF 
  IF ((xpt3 - xmid) LE -20.0) THEN BEGIN
   IF NOT KEYWORD_SET(NOLABELS) THEN XYOUTS, xpt3, ypt3-ypix/2.0, label, ALIGNMENT=1.0, $
                                             FONT=0, CHARSIZE=charsize, /DEVICE
  ENDIF   
  IF ((xpt3 - xmid) GE 20.0) THEN BEGIN
   IF NOT KEYWORD_SET(NOLABELS) THEN XYOUTS, xpt3, ypt3-ypix/2.0, label, ALIGNMENT=0.0, $
                                             FONT=0, CHARSIZE=charsize, /DEVICE
  ENDIF     
   
  mydeg=mydeg+step
 ENDFOR  
ENDIF


;Add a grid if requested
IF (GRID+HGRID+VGRID NE 0) THEN BEGIN
 IF (GRID EQ 1) THEN HGRID=1
 IF (GRID EQ 1) THEN VGRID=1
 
 IF (!MAP.PROJECTION EQ 0) THEN BEGIN
  IF (VGRID EQ 1) THEN BEGIN
   FOR ix=0, N_ELEMENTS(xvals)-1 DO BEGIN
    PLOTS, [xvals(ix), xvals(ix)], [!guide.ymin, !guide.ymax], LINESTYLE=gstyle,$
           THICK=!guide.thick*FLOAT(gthick)/100, COLOR=gcol
   ENDFOR
  ENDIF
  IF (HGRID EQ 1) THEN BEGIN
   FOR iy=0, N_ELEMENTS(yvals)-1 DO BEGIN
    PLOTS, [!guide.xmin, !guide.xmax], [yvals(iy), yvals(iy)], LINESTYLE=gstyle,$
           THICK=!guide.thick*FLOAT(gthick)/100, COLOR=gcol
   ENDFOR
  ENDIF 
 ENDIF ELSE BEGIN
  IF (N_ELEMENTS(XSTEP) EQ 1) THEN XSTEP=xstep
  IF (N_ELEMENTS(YSTEP) EQ 1) THEN YSTEP=ystep
  IF ((N_ELEMENTS(STEP) EQ 1) AND (N_ELEMENTS(XSTEP) EQ 0)) THEN xstep=step
  IF ((N_ELEMENTS(STEP) EQ 1) AND (N_ELEMENTS(YSTEP) EQ 0)) THEN ystep=step  
  IF (GRID EQ 1) THEN MAP_GRID, LONDEL=xstep, LATDEL=ystep, GLINESTYLE=gstyle, $
                                GLINETHICK=!guide.thick*gthick/100, COLOR=gcol
 ENDELSE
ENDIF 


;Sector plot axis labelling.
IF (!guide.sector EQ 1) THEN BEGIN
 ;Axis labels.
 hem=1
 latmin=!map.ll_box(0)
 lonmin=!map.ll_box(1)
 latmax=!map.ll_box(2)
 lonmax=!map.ll_box(3) 
 IF (latmin LT 0) THEN hem=-1
 
 ;Longitude labels.
 IF (N_ELEMENTS(XSTEP) EQ 0) THEN xstep=10
 IF (N_ELEMENTS(STEP) NE 0) THEN xstep=step
 IF (hem EQ 1) THEN valign=1.0 ELSE valign=0.0
 lat1=latmin
 lat2=latmax
 IF (hem EQ -1) THEN lat1=latmax
 IF (hem EQ -1) THEN lat2=latmin 
 FOR ix=lonmin, lonmax, xstep DO BEGIN
  pt=CONVERT_COORD(ix, lat1, /DATA, /TO_DEVICE)
  pt2=CONVERT_COORD(ix, lat2, /DATA, /TO_DEVICE)
  IF ((pt2(0)-pt(0)) EQ 0.0) THEN theta=1.57 ELSE theta=ATAN((pt2(1)-pt(1))/(pt2(0)-pt(0)))
  rev=1
  IF (theta LT 0 ) THEN rev=-1
  IF NOT KEYWORD_SET(noticks) THEN GPLOT, X=[pt(0), pt(0)-rev*hem*tlen*COS(theta)], Y=[pt(1), pt(1)-rev*hem*tlen*SIN(theta)], /DEVICE
  IF NOT KEYWORD_SET(nolabels) THEN GPLOT, X=[pt(0)-rev*hem*(tlen+space1)*COS(theta)], Y=[pt(1)-rev*hem*(tlen+space1)*SIN(theta)], $
 	 TEXT=SCROP(ix, NDECS=0), VALIGN=valign, /DEVICE
 ENDFOR
 
 ;Latitude labels.
 IF (N_ELEMENTS(YSTEP) EQ 0) THEN ystep=10
 IF (N_ELEMENTS(STEP) NE 0) THEN ystep=step
 IF (hem EQ 1) THEN valign=0.0 ELSE valign=1.0
 FOR iy=latmin, latmax, ystep DO BEGIN
  pt=CONVERT_COORD(lonmin, iy, /DATA, /TO_DEVICE)
  pt2=CONVERT_COORD(lonmin+5, iy, /DATA, /TO_DEVICE)
  theta=ATAN((pt2(1)-pt(1))/(pt2(0)-pt(0)))
  IF NOT KEYWORD_SET(noticks) THEN GPLOT, X=[pt(0), pt(0)-tlen*COS(theta)], Y=[pt(1), pt(1)-tlen*SIN(theta)], /DEVICE
  IF NOT KEYWORD_SET(nolabels) THEN GPLOT, X=[pt(0)-(tlen+space1)*COS(theta)], Y=[pt(1)-(tlen+space1)*SIN(theta)], $
 	 TEXT=SCROP(iy, NDECS=0), VALIGN=valign, /DEVICE
 ENDFOR
 FOR iy=latmin, latmax, ystep DO BEGIN
  pt=CONVERT_COORD(lonmax, iy, /DATA, /TO_DEVICE)
  pt2=CONVERT_COORD(lonmax-5, iy, /DATA, /TO_DEVICE)
  theta=ATAN((pt2(1)-pt(1))/(pt2(0)-pt(0)))

  IF NOT KEYWORD_SET(noticks) THEN GPLOT, X=[pt(0), pt(0)+tlen*COS(theta)], Y=[pt(1), pt(1)+tlen*SIN(theta)], /DEVICE
  IF NOT KEYWORD_SET(nolabels) THEN GPLOT, X=[pt(0)+(tlen+space1)*COS(theta)], Y=[pt(1)+(tlen+space1)*SIN(theta)], $
 	 TEXT=SCROP(iy, NDECS=0), VALIGN=valign, /DEVICE
 ENDFOR    
ENDIF


;Add a border if not a map
IF (border_thick GT 0) THEN BEGIN
 IF (map_type EQ 0) THEN BEGIN
  IF (NOT KEYWORD_SET(NOLOWER)) THEN PLOTS, [xmin, xmax], [ymin-axisoffset, ymin-axisoffset], THICK=!guide.thick, COLOR=col, /DEVICE
  IF (NOT KEYWORD_SET(NOUPPER)) THEN PLOTS, [xmin, xmax], [ymax+axisoffset, ymax+axisoffset], THICK=!guide.thick, COLOR=col, /DEVICE
  IF (NOT KEYWORD_SET(NOLEFT))  THEN PLOTS, [xmin-axisoffset, xmin-axisoffset], [ymin, ymax], THICK=!guide.thick, COLOR=col, /DEVICE
  IF (NOT KEYWORD_SET(NORIGHT)) THEN PLOTS, [xmax+axisoffset, xmax+axisoffset], [ymin, ymax], THICK=!guide.thick, COLOR=col, /DEVICE 
 ENDIF
 
 ;Add a border to the plot.
 border_thick=!guide.border_thick
 IF (border_thick GT 0) THEN BEGIN
  latmin=!map.ll_box(0)
  lonmin=!map.ll_box(1)
  latmax=!map.ll_box(2)
  lonmax=!map.ll_box(3) 

  ;Sector plot.
  IF (!guide.sector EQ 1) THEN BEGIN
   ;Boundary
   offset=0.1
   PLOTS, [lonmin+offset, lonmin+offset], [latmin, latmax], THICK=border_thick
   PLOTS, [lonmax-offset, lonmax-offset], [latmin, latmax], THICK=border_thick
   FOR ix=lonmin, lonmax, 1 DO BEGIN
    PLOTS, [ix, ix+1], [latmin+offset, latmin+offset], THICK=border_thick
    PLOTS, [ix, ix+1], [latmax-offset, latmax-offset], THICK=border_thick
   ENDFOR
  ENDIF

  ;Polar plot boundary
  IF ((map_type EQ 1) OR (map_type EQ 2) AND (!guide.sector NE 1)) THEN BEGIN
   IF (latmax EQ 90) THEN BEGIN
    eqlat=latmin 
    offset=0.1
   ENDIF ELSE BEGIN
    eqlat=latmax 
    offset=-0.1
   ENDELSE 
   FOR ix=0, 359 DO BEGIN
    PLOTS, [ix, ix+1], [eqlat+offset, eqlat+offset], THICK=border_thick
   ENDFOR
  ENDIF
  
  ;Mollweide=10 or Robinson=17
  IF ((map_type EQ 10) OR (map_type EQ 17)) THEN BEGIN
   offset=0.1
   FOR iy=-90, 89 DO BEGIN
    PLOTS, [lonmin+offset, lonmin+offset], [iy, iy+1], THICK=border_thick
    PLOTS, [lonmax-offset, lonmax-offset], [iy, iy+1], THICK=border_thick
   ENDFOR
   ;Put a line at top and bottom to complete the boundary.
   IF (map_type EQ 10) THEN BEGIN
    offset=500
    pt=CONVERT_COORD(!guide.xmax, !guide.ymax, /DATA, /TO_DEVICE)
    PLOTS, [pt(0)-offset,pt(0)+offset], [pt(1), pt(1)], THICK=border_thick, /DEVICE
    pt=CONVERT_COORD(!guide.xmin, !guide.ymin, /DATA, /TO_DEVICE)
    PLOTS, [pt(0)-offset,pt(0)+offset], [pt(1), pt(1)], THICK=border_thick, /DEVICE  
   ENDIF
   IF (map_type EQ 17) THEN BEGIN
    pt1=CONVERT_COORD(!guide.xmin, !guide.ymax, /DATA, /TO_DEVICE)  
    pt2=CONVERT_COORD(!guide.xmax, !guide.ymax, /DATA, /TO_DEVICE)  
    PLOTS, [pt1(0),pt2(0)], [pt1(1), pt2(1)], THICK=border_thick, /DEVICE
    pt1=CONVERT_COORD(!guide.xmin, !guide.ymin, /DATA, /TO_DEVICE)  
    pt2=CONVERT_COORD(!guide.xmax, !guide.ymin, /DATA, /TO_DEVICE)  
    PLOTS, [pt1(0),pt2(0)], [pt1(1), pt2(1)], THICK=border_thick, /DEVICE  
   ENDIF
  ENDIF
 
  ;Satellite
  IF (map_type EQ 7) THEN BEGIN
   pt1=CONVERT_COORD(!P.POSITION(0), !P.POSITION(1), /NORMAL, /TO_DEVICE)  
   pt2=CONVERT_COORD(!P.POSITION(2), !P.POSITION(3), /NORMAL, /TO_DEVICE)  
   rad=ABS((pt2(0)-pt1(0))/2.0)
   xmid=pt1(0)+rad
   ymid=pt1(1)+rad
   FOR mydeg=-180, 179 DO BEGIN
    xpt1=xmid+rad*SIN((mydeg)*!DTOR)
    ypt1=ymid+rad*COS((mydeg)*!DTOR)
    xpt2=xmid+rad*SIN((mydeg+1)*!DTOR)
    ypt2=ymid+rad*COS((mydeg+1)*!DTOR)    
    PLOTS, [xpt1, xpt2], [ypt1, ypt2], THICK=border_thick, /DEVICE  
   ENDFOR
  ENDIF
 ENDIF
 
ENDIF

END


