PRO COLBAR, COORDS=coords, TITLE=title, TEXTPOS=textpos, ALT=alt, NTH=nth, $
            NOLINES=nolines, NOTEXT=notext, LABELS=labels, VTEXT=vtext, CBYOFFSET=cbyoffset
;Simple colourbar program using lines, text and polygons.
;(C) NCAS 2010

;
;  MODIFIED R. PETRIE 15-10-2013
;  INCLUDES CBYOFFSET - colourbar y-offset
;  allows second colourbar labels to be included below 
;  original using the same colourbar 
;  *** ONLY FOR HORIZONTAL COLOURBARS WITHOUT ALT ***
;  NEGATIVE cbyoffset allows placement of labels above colourbar




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
 PRINT, 'COLBAR error - MAP or GSET must be called first to establish coordinates.'
 PRINT, ''
 STOP
ENDIF

;Variable assigment and some basic checks
IF (N_ELEMENTS(coords) NE 4) THEN BEGIN
  PRINT, 'COLBAR ERROR - coords not defined correctly.'
  PRINT, 'COORDS=coords needs 4 elements but received ', SCROP(N_ELEMENTS(coords))
  STOP
ENDIF

levs=!guide.levels(0:!guide.levels_npts-1)
lower=!guide.lower
upper=!guide.upper


x0=FLOAT(coords(0))
y0=FLOAT(coords(1))
x1=FLOAT(coords(2))
y1=FLOAT(coords(3))


IF (N_ELEMENTS(cbyoffset) EQ 0) THEN cbyoffset=0
IF (N_ELEMENTS(alt) EQ 0) THEN alt=0
IF (N_ELEMENTS(lower) EQ 0) THEN lower=0
IF (N_ELEMENTS(upper) EQ 0) THEN upper=0
IF (N_ELEMENTS(textpos) EQ 0) THEN textpos=0
IF (N_ELEMENTS(title) EQ 0) THEN title=''
IF (N_ELEMENTS(nolines) EQ 0) THEN nolines=0

font=!guide.font
charsize=!guide.charsize

ydiff=y1-y0
xdiff=x1-x0
IF (xdiff LE 0) THEN BEGIN
  PRINT, 'COLBAR ERROR - X1 must be greater than X0.'
  STOP
ENDIF

IF (ydiff LE 0) THEN BEGIN
  PRINT, 'COLBAR ERROR - Y1 must be greater than Y0.'
  STOP
ENDIF

ncontour=N_ELEMENTS(levs)-1
IF (ncontour LT 1) THEN BEGIN
  PRINT, 'COLBAR ERROR - Number of levels must be two or greater.'
  STOP
ENDIF


;Select labels to plot
plotlabels=INTARR(N_ELEMENTS(levs))
IF (N_ELEMENTS(nth) EQ 0) THEN BEGIN
 plotlabels(*)=1
ENDIF ELSE BEGIN
 count=0 
 WHILE (count LE N_ELEMENTS(levs)-1) DO BEGIN
  plotlabels(count)=1
  count=count+nth
 ENDWHILE
ENDELSE
IF (N_ELEMENTS(labels) NE 0) THEN BEGIN
 plotlabels(*)=0
 FOR ilab=0, N_ELEMENTS(labels)-1 DO BEGIN
  pts=WHERE(levs EQ FLOAT(labels(ilab)), count)
  IF (count EQ -1) THEN PRINT, 'Label ',labels(ilab), ' not found in levels.'
  IF (count EQ 1) THEN BEGIN
   IF (lower EQ 0) THEN plotlabels(pts)=1 ELSE plotlabels(pts-1)=1
  ENDIF
 ENDFOR
ENDIF
IF KEYWORD_SET(notext) THEN plotlabels(*)=0

;Some plot definitions
space1=!guide.space1 ;space between colour bar and text.
xpix=!guide.xpix         ;Width of text in pixels
ypix=!guide.ypix         ;Height of text in pixels 


;Horizontal colourbar
;--------------------
IF (xdiff GT ydiff) THEN BEGIN
 nticks=ncontour
 IF (lower) THEN nticks=nticks-1
 IF (upper) THEN nticks=nticks-1
 
 xint = xdiff/ncontour
 yint = ydiff
 xstart=x0
 icol=2

 IF (lower) THEN BEGIN
  xpts=[x0, x0+xint, x0+xint, x0]
  ypts=[y1-yint/2,y1,y1-yint,y1-yint/2]
  GPLOT, X=xpts, Y=ypts, FILLCOL=icol, /DEVICE
  xstart=xstart+xint
  icol=icol+1
 ENDIF

 iplotlabel=0
 FOR ix=0, nticks-1 DO BEGIN
  plotlabel=plotlabels(ix)
  IF (plotlabel EQ 1) THEN iplotlabel=iplotlabel+1
  myx=xstart+ix*xint
  xpts=[myx, myx+xint, myx+xint, myx, myx]
  ypts=[y1,y1, y1-yint,y1-yint,y1]
  GPLOT, X=xpts, Y=ypts, FILLCOL=icol+ix, /NOLINES, /DEVICE
  GPLOT, X=[myx, myx+xint], Y=[y1,y1], /DEVICE
  GPLOT, X=[myx, myx+xint], Y=[y1-yint,y1-yint], /DEVICE
  PLOTS, [myx, myx+xint], [y1-yint,y1-yint], COLOR=1, /DEVICE  
  IF (plotlabel EQ 1) THEN BEGIN
   GPLOT, X=[myx,myx], Y=[y1, y1-yint], /DEVICE
  ENDIF ELSE BEGIN
   IF (nolines EQ 0) THEN GPLOT, X=[myx,myx], Y=[y1, y1-yint], /DEVICE
  ENDELSE
  
  mylev=STRTRIM(STRING(levs(ix+icol-2)),2)
 
  IF (ALT EQ 0) THEN BEGIN
   IF (plotlabel EQ 1) THEN GPLOT, X=myx, Y=y0-space1-ypix-cbyoffset, TEXT=mylev , /DEVICE
  ENDIF ELSE BEGIN
    IF (iplotlabel MOD 2 EQ 0) THEN BEGIN
     IF (plotlabel EQ 1) THEN GPLOT, X=myx, Y=y0-space1-ypix-cbyoffset, TEXT=mylev, /DEVICE
    ENDIF ELSE BEGIN
     IF (plotlabel EQ 1) THEN GPLOT, X=myx, Y=y1+space1-cbyoffset, TEXT=mylev, /DEVICE
    ENDELSE
  ENDELSE  
 ENDFOR

 ;Plot last label.
 myx=xstart+nticks*xint
 mylev=STRTRIM(STRING(levs(ix+icol-2)),2)
 plabel=0
 IF (NOT KEYWORD_SET(NOTEXT) AND (plotlabels(N_ELEMENTS(plotlabels)-1) EQ 1)) THEN plabel=1
 ;
 ;  IF NTH is set last element in plotlabels may be 0 and therefore last label maynot be plotted!
 ;
 ; 
 IF (N_ELEMENTS(labels) NE 0) THEN BEGIN
  pts=WHERE(mylev EQ labels, count)
  IF (count EQ 1) THEN plabel=1
  ENDIF
 IF KEYWORD_SET(plabel) THEN BEGIN
  IF (ALT EQ 0) THEN BEGIN
   XYOUTS, myx, y0-space1-ypix-cbyoffset, mylev, ALIGNMENT=0.5, FONT=0, COLOR=1, CHARSIZE=charsize, /DEVICE
  ENDIF ELSE BEGIN
   IF (iplotlabel MOD 2 EQ 1) THEN BEGIN
    XYOUTS, myx, y0-space1-ypix, mylev, ALIGNMENT=0.5, FONT=0, COLOR=1, CHARSIZE=charsize, /DEVICE
   ENDIF ELSE BEGIN
    XYOUTS, myx, y1+space1, mylev, ALIGNMENT=0.5, FONT=0, COLOR=1, CHARSIZE=charsize, /DEVICE
   ENDELSE
  ENDELSE
 ENDIF

 IF (upper) THEN BEGIN
  xpts=[x1-xint, x1, x1-xint, x1-xint]
  ypts=[y1,y1-yint/2.0,y1-yint,y1]
  GPLOT, X=xpts, Y=ypts, FILLCOL=icol+nticks, /DEVICE  
 ENDIF ELSE BEGIN
  GPLOT, X=[x1, x1], Y=[ y1, y1-yint], /DEVICE ;Draw line across bar at upper limit. 
 ENDELSE

 xstart=x0-xint
 mystart=0
 IF (lower) THEN BEGIN
  mystart=1
 ENDIF

 ;Add the title
 XYOUTS, x0+xdiff/2, y0-2*(space1+ypix)-2*cbyoffset, title, ALIGNMENT=0.5,  $
         FONT=0, COLOR=1, CHARSIZE=charsize, /DEVICE

ENDIF


;Vertical colourbar
;------------------
IF (ydiff GT xdiff) THEN BEGIN
 nticks=ncontour
 IF (upper) THEN nticks=nticks-1
 IF (lower) THEN nticks=nticks-1 

 yint = ydiff/ncontour
 xint = xdiff
 ystart=y0
 icol=2

 IF (lower) THEN BEGIN
  xpts=[x0+xint/2, x0, x0+xint, x0+xint/2]
  ypts=[y0,y0+yint,y0+yint,y0]
  GPLOT, X=xpts, Y=ypts, FILLCOL=icol, /DEVICE
  ystart=ystart+yint
  icol=icol+1
 ENDIF


 myalign=1.0
 myx=x0-xint*0.25
 IF TEXTPOS then myalign=0.0
 IF TEXTPOS THEN myx=x0+xint*1.25
 FOR iy=0, nticks-1 DO BEGIN
  plotlabel=plotlabels(iy)
  myy=ystart+iy*yint
  xpts=[x0, x0, x0+xint, x0+xint, x0]
  ypts=[myy,myy+yint, myy+yint, myy, myy]
  ;POLYFILL, xpts, ypts, COLOR=icol+iy, /DEVICE  
  ;PLOTS, [x0, x0], [myy,myy+yint], COLOR=1, /DEVICE
  ;PLOTS, [x0+xint, x0+xint], [myy,myy+yint], COLOR=1, /DEVICE
  GPLOT, X=xpts, Y=ypts, FILLCOL=icol+iy, /NOLINES, /DEVICE  
  GPLOT, X=[x0, x0], Y=[myy,myy+yint], /DEVICE
  GPLOT, X=[x0+xint, x0+xint], Y=[myy,myy+yint], /DEVICE
  
  IF ((plotlabel EQ 1) OR (NOLINES EQ 0)) THEN PLOTS, [x0, x0+xint], [myy,myy], COLOR=1, /DEVICE
  myy=ystart+iy*yint
  mylev=STRTRIM(STRING(levs(iy+icol-2)),2)
  IF (plotlabel EQ 1) THEN XYOUTS, myx, myy-ypix/2.0, mylev, ALIGNMENT=myalign, FONT=0, COLOR=1, CHARSIZE=charsize, /DEVICE
 ENDFOR
 myy=ystart+nticks*yint
 mylev=STRTRIM(STRING(levs(iy+icol-2)),2)
 XYOUTS, myx, myy-ypix/2.0, mylev, ALIGNMENT=myalign, FONT=0, COLOR=1, CHARSIZE=charsize, /DEVICE


 IF (upper) THEN BEGIN
  xpts=[x0+xint/2, x0, x0+xint, x0+xint/2]
  ypts=[y1,y1-yint,y1-yint,y1]
  GPLOT, X=xpts, Y=ypts, FILLCOL=icol+nticks, /DEVICE  
 ENDIF ELSE BEGIN
  GPLOT, X=[x0, x0+xint], Y=[ y1, y1], /DEVICE ;Draw line across bar at upper limit.
 ENDELSE


 ;Add the title
 IF KEYWORD_SET(vtext) THEN BEGIN
  XYOUTS, x0+xint/2, y1+(space1+ypix), title, ALIGNMENT=0.5, FONT=0, COLOR=1, CHARSIZE=charsize, /DEVICE
 ENDIF ELSE BEGIN
  XYOUTS, x0+xint/2, y0-2*(space1+ypix), title, ALIGNMENT=0.5, FONT=0, COLOR=1, CHARSIZE=charsize, /DEVICE
 ENDELSE
 
ENDIF

END


