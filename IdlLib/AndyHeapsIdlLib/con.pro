PRO CON, FIELD=field, X=xpts, Y=ypts, AUTOLEVS=autolevs, NOCOLBAR=nocolbar, NOFILL=nofill,$
         NOLINES=nolines, NOLINELABELS=nolinelabels, NOAXES=noaxes, TITLE=title,$
         LEFT_LABEL=left_label, RIGHT_LABEL=right_label, $
      	 BLOCK=block, LEFT_TITLE=left_title, RIGHT_TITLE=right_title, $
      	 STYLE=style, COL=col, THICK=THICK, $
      	 NEGATIVE_STYLE=negative_style, POSITIVE_STYLE=positive_style, $
      	 ZERO_STYLE=zero_style, NEGATIVE_THICK=negative_thick, $
      	 POSITIVE_THICK=positive_thick, ZERO_THICK=zero_thick, $
      	 NEGATIVE_COL=negative_col, POSITIVE_COL=positive_col, $
      	 ZERO_COL=zero_col, TRI=tri, NOMAP=nomap, $
      	 CB_LEFT=cb_left, CB_RIGHT=cb_right, CB_UNDER=cb_under, $
      	 CB_ALT=cb_alt, CB_WIDTH=cb_width, CB_HEIGHT=cb_height, $
      	 CB_TITLE=cb_title, CB_NVALS=cb_nvals, CB_NTH=cb_nth, $
      	 CB_NOLINES=cb_nolines, CB_LABELS=cb_labels, CB_VTEXT=cb_vtext, SPACING=spacing, $
      	 ORIENTATION=orientation, ORIG=orig, CFILL=cfill, IMG=img, $
      	 QP=qp, TOL=tol, MASK=mask, SH=sh, NH=nh, TEXTSIZE=textsize
;Procedure to make contour plots.
;(C) NCAS 2010

;**************************
; REP MODIFICATION June 2014
; 
; Includes a LEFT_LABEL and a RIGHT_LABEL OPTION
; 
;
; REP MODIFIED June 2013
; 
; to include TEXTSIZE option
; this set textsize of title
; in device size i.e 1.??
;
;**************************

COMPILE_OPT  DEFINT32 ;Use longword integers.

IF (N_ELEMENTS(TEXTSIZE) EQ 0) THEN tcharsize=!guide.charsize ELSE tcharsize=textsize

;Check if field is a structure and extract the contents if it is.
IF (SIZE(field, /TYPE) EQ 8) THEN BEGIN
 field_orig=field
 tagnames=TAG_NAMES(field)
 res=EXECUTE('xpts=field.'+tagnames(4))
 res=EXECUTE('ypts=field.'+tagnames(5))
 
 ;If a quick plot then open a postscript file and set the coordinate system.
 IF KEYWORD_SET(qp) THEN BEGIN
  PSOPEN
  IF ((STRUPCASE(STRMID(tagnames(4), 0, 3)) EQ 'LON') AND (STRUPCASE(STRMID(tagnames(5), 0, 3)) EQ 'LAT') AND $
     (!guide.projection EQ 0) AND (NOT KEYWORD_SET(NOMAP))) THEN BEGIN
    IF KEYWORD_SET(SH) THEN MAP, /SH
    IF KEYWORD_SET(NH) THEN MAP, /NH
    IF (NOT KEYWORD_SET(sh) AND NOT KEYWORD_SET(nh)) THEN MAP
  ENDIF ELSE BEGIN
   ymin=MIN(ypts)
   ymax=MAX(ypts)
   presplot=0
   IF (((ymin LE 50) AND (ymin GE 0)) AND ((ymax LE 1000) AND (ymax GT 950))) THEN presplot=1
   IF (presplot EQ 0) THEN GSET, XMIN=MIN(xpts), XMAX=MAX(xpts), YMIN=MIN(ypts), YMAX=MAX(ypts)
   IF (presplot EQ 1) THEN GSET, XMIN=MIN(xpts), XMAX=MAX(xpts), YMIN=MAX(ypts), YMAX=MIN(ypts)
  ENDELSE
 ENDIF
 tsum=N_ELEMENTS(title)+N_ELEMENTS(left_title)+N_ELEMENTS(right_title)+N_ELEMENTS(cb_title)
 IF (tsum EQ 0) THEN BEGIN 
  title=field.title
  left_title=field.title2
  right_title=field.units
 ENDIF

 ;Extract the field and set the levels.
 field=field.data
 IF ((STRUPCASE(STRMID(tagnames(4), 0, 3)) EQ 'LON') AND (STRUPCASE(STRMID(tagnames(5), 0, 3)) EQ 'LAT') AND $
     (!guide.projection EQ 0) AND (NOT KEYWORD_SET(NOMAP))) THEN MAP
 fmin=MIN(field)
 fmax=MAX(field)
 IF (!guide.levels_npts EQ 0) THEN BEGIN
  pts=WHERE(FINITE(field, /NAN), count)
  IF (count EQ N_ELEMENTS(field)) THEN BEGIN
   PRINT, ''
   PRINT, 'CON error - field contains just NaNs.'
   PRINT, ''
   STOP
  ENDIF
  fmin=FLOOR(MIN(field, /NAN))
  fmax=CEIL(MAX(field, /NAN))
  diff=(fmax-fmin)/18
  IF ((fmin LT 0) AND (fmax GT 0)) THEN start=0-8*diff ELSE start=fmin+diff
  IF (start+16*(diff+1) LT fmax) THEN diff=diff+1
  ndecs=0
  IF (diff LE 1) THEN BEGIN
   fmin=MIN(field, /NAN)
   fmax=MAX(field, /NAN)
   diff=(fmax-fmin)/18   
   ndecs=3
   IF (diff LE 1E-3) THEN ndecs=4
   IF (diff LE 1E-4) THEN ndecs=5
  ENDIF
  
  IF ((fmin LT 0) AND (fmax GT 0)) THEN start=0-8*diff ELSE start=fmin+diff
  ;STOP
  LEVS, MIN=start, MAX=start+16*diff, STEP=diff, NDECS=ndecs
  
 ENDIF
ENDIF


;Check !guide structure exists.
DEFSYSV, '!guide', exists=exists
IF (exists EQ 0) THEN BEGIN
 PRINT, ''
 PRINT, 'ERROR - PSOPEN must first be called to initiate a postscript file.
 PRINT, ''
 STOP
ENDIF
 
;Check coordinates are established.
IF (!guide.coords_established EQ 0) THEN BEGIN
 PRINT, ''
 PRINT, 'CON error - MAP or GSET must be called first to establish coordinates.'
 PRINT, ''
 STOP
ENDIF

IF ((N_ELEMENTS(field) EQ 0) OR (N_ELEMENTS(xpts) EQ 0) OR (N_ELEMENTS(ypts) EQ 0)) THEN BEGIN
 PRINT, ''
 PRINT, "CON ERROR - FIELD, X and Y must all be set."
 HELP, FIELD, X, Y
 PRINT, ''
 STOP
ENDIF


;Vector of irregular points.
irreg=0
IF (((SIZE(field))(0) EQ 1) AND ((SIZE(xpts))(0) EQ 1) AND ((SIZE(ypts))(0) EQ 1)) THEN BEGIN
 IF ((((SIZE(field))(1) EQ (SIZE(xpts))(1))) AND (((SIZE(field))(1) EQ (SIZE(xpts))(1)))) THEN irreg=1
ENDIF


s=(SIZE(xpts))(0)
IF ((N_ELEMENTS(tri) EQ 0) AND (irreg eq 0)) THEN BEGIN
 IF (((SIZE(field))(0) GT 2) OR  ((SIZE(field))(0) LT 2)) THEN BEGIN
  PRINT, ''
  PRINT, "CON ERROR - FIELD isn't 2 dimensional."
  HELP, FIELD
  PRINT, ''
  STOP
 ENDIF

 IF (S EQ 1) THEN BEGIN
  IF (((SIZE(xpts))(1) NE (SIZE(field))(1)) OR ((SIZE(ypts))(1) NE (SIZE(field))(2))) THEN BEGIN
   PRINT, ''
   PRINT, "CON ERROR - FIELD, X and Y mismatch."
   x=xpts
   y=ypts
   HELP, field, x, y
   PRINT, ''
   STOP 
  ENDIF 
 ENDIF
ENDIF


IF (S EQ 2) THEN BEGIN
 IF (N_ELEMENTS(xpts) NE N_ELEMENTS(ypts)) THEN BEGIN
  PRINT, ''
  PRINT, "CON ERROR - irregularly spaced data, X and Y don't match."
  HELP, xpts, ypts
  PRINT, ''
  STOP
 ENDIF
ENDIF



;Extract field, xpts and ypts for returning unmodified at the end.
IF (SIZE(field_orig, /TYPE) NE 8) THEN field_orig=field
xpts_orig=xpts
ypts_orig=ypts

;Set some defaults.
IF (N_ELEMENTS(TOL) EQ 0) THEN tol=1E-3 ;Tolerance for longitude differences.
IF (N_ELEMENTS(CB_TITLE) EQ 0) THEN cb_title=''
IF (N_ELEMENTS(CB_WIDTH) EQ 0) THEN cb_width=!guide.cb_width
IF (N_ELEMENTS(CB_HEIGHT) EQ 0) THEN cb_height=!guide.cb_height
IF ((SIZE(xpts))(0) NE 1) THEN irreg=1
IF (N_ELEMENTS(ORIG) EQ 0) THEN orig=0
XSIZE=!guide.xsize
YSIZE=!guide.ysize
SATVIEW=1
IF ((!guide.satellite(0) EQ -99.0) AND (!guide.satellite(1) EQ -99.0)) THEN satview=0
xpix=!guide.xpix              ;Width of text in pixels
ypix=!guide.ypix              ;Height of text in pixels 
cbsize=400.0  ;Default colour bar thickness
space1=!guide.space1
space2=!guide.space2
space3=!guide.space3
tlen=!guide.ticklen
map_type=!guide.projection
overplot=!guide.overplot
;Extract or setup levels.
IF NOT KEYWORD_SET(AUTOLEVS) THEN BEGIN
 levs=!guide.levels(0:!guide.levels_npts-1)
 nlevs=!guide.levels_npts
ENDIF ELSE BEGIN
 nlevs=18
 levs=MIN(field, /NAN)+FINDGEN(nlevs+1)*(MAX(field, /NAN)-MIN(field, /NAN))/nlevs
 CB_ALT=1
 !guide.lower=0
 !guide.upper=0
 !guide.levels_npts=18
 !guide.levels=levs
 PRINT, 'Field min=', MIN(field, /NAN), '  Field max=',MAX(field, /NAN)
 PRINT, 'Levels generated are: ',levs
ENDELSE

;Check on the number of levels, style and col.
npts=!guide.levels_npts
IF (N_ELEMENTS(col) EQ 0) THEN col=INTARR(npts)+1
IF (N_ELEMENTS(col) EQ 1) THEN col=INTARR(npts)+col
IF (N_ELEMENTS(col) NE npts) THEN BEGIN
 PRINT, ''
 PRINT, 'CON ERROR - Number of contours and number of line colours must be equal.'
 HELP, levs, col
 PRINT, ''
 STOP
ENDIF
IF (N_ELEMENTS(style) EQ 0) THEN style=INTARR(npts)
IF (N_ELEMENTS(style) EQ 1) THEN style=INTARR(npts)+style
IF (N_ELEMENTS(style) NE npts) THEN BEGIN
 PRINT, ''
 PRINT, 'CON ERROR - Number of contours and number of styles must be equal.'
 HELP, levs, style
 PRINT, ''
 STOP
ENDIF
IF (N_ELEMENTS(thick) EQ npts) THEN thick=thick*!guide.thick/100.0
IF (N_ELEMENTS(thick) EQ 0) THEN thick=INTARR(npts)+!guide.thick
IF (N_ELEMENTS(thick) EQ 1) THEN thick=INTARR(npts)+thick*!guide.thick/100.0
IF (N_ELEMENTS(thick) NE npts) THEN BEGIN
 PRINT, ''
 PRINT, 'CON ERROR - Number of contours and number of thicks must be equal.'
 HELP, levs, thick
 PRINT, ''
 STOP
ENDIF

IF (N_ELEMENTS(IMG) NE 0) THEN BEGIN
 IF ((map_type NE 0) AND (map_type NE 8)) THEN BEGIN
  PRINT, ''
  PRINT, 'CON ERROR - /IMG can only be used in cylindrical projection '
  PRINT, '            or in non-map contours.'
  PRINT, ''
  STOP
 ENDIF
ENDIF



;Set contour line properties if requested.
IF ((N_ELEMENTS(negative_style) NE 0) OR (N_ELEMENTS(positive_style) NE 0) OR $
   (N_ELEMENTS(zero_style) NE 0)) THEN style=INTARR(npts)
IF ((N_ELEMENTS(negative_style) NE 0)) THEN BEGIN
 pts=WHERE(!guide.levels LT 0.0, count)
 IF (count GE 1) THEN style(pts)=negative_style
ENDIF
IF ((N_ELEMENTS(positive_style) NE 0)) THEN BEGIN
 pts=WHERE(!guide.levels GT 0.0, count)
 IF (count GE 1) THEN style(pts)=positive_style
ENDIF  
IF ((N_ELEMENTS(zero_style) NE 0)) THEN BEGIN
 pts=WHERE(!guide.levels EQ 0.0, count)
 IF (count GE 1) THEN style(pts)=zero_style
ENDIF  

IF ((N_ELEMENTS(negative_thick) NE 0) OR (N_ELEMENTS(positive_thick) NE 0) OR $
   (N_ELEMENTS(zero_thick) NE 0)) THEN thick=FLTARR(!guide.levels_npts)+!guide.thick
IF ((N_ELEMENTS(negative_thick) NE 0)) THEN BEGIN
 pts=WHERE(!guide.levels LT 0.0, count)
 IF (count GE 1) THEN thick(pts)=negative_thick*!guide.thick/100.0
ENDIF
IF ((N_ELEMENTS(positive_thick) NE 0)) THEN BEGIN
 pts=WHERE(!guide.levels GT 0.0, count)
 IF (count GE 1) THEN thick(pts)=positive_thick*!guide.thick/100.0
ENDIF  
IF ((N_ELEMENTS(zero_thick) NE 0)) THEN BEGIN
 pts=WHERE(!guide.levels EQ 0.0, count)
 IF (count GE 1) THEN thick(pts)=zero_thick*!guide.thick/100.0
ENDIF 

IF ((N_ELEMENTS(negative_col) NE 0) OR (N_ELEMENTS(positive_col) NE 0) OR $
   (N_ELEMENTS(zero_col) NE 0)) THEN col=INTARR(!guide.levels_npts)
IF ((N_ELEMENTS(negative_col) NE 0)) THEN BEGIN
 pts=WHERE(!guide.levels LT 0.0, count)
 IF (count GE 1) THEN col(pts)=negative_col
ENDIF
IF ((N_ELEMENTS(positive_col) NE 0)) THEN BEGIN
 pts=WHERE(!guide.levels GT 0.0, count)
 IF (count GE 1) THEN col(pts)=positive_col
ENDIF  
IF ((N_ELEMENTS(zero_col) NE 0)) THEN BEGIN
 pts=WHERE(!guide.levels EQ 0.0, count)
 IF (count GE 1) THEN col(pts)=zero_col
ENDIF 

;Set the contour font.
res=EXECUTE(!guide.contourfont)    
font=!guide.cfont
charsize=tcharsize;!guide.ccharsize

;Get plot corners in pixels
x0=!guide.position(0)
x1=!guide.position(2)
y0=!guide.position(1)
y1=!guide.position(3)
pt=CONVERT_COORD(x0, y0, /NORMAL, /TO_DEVICE)
xmin=pt(0)
ymin=pt(1)
pt=CONVERT_COORD(x1, y1, /NORMAL, /TO_DEVICE)
xmax=pt(0)
ymax=pt(1)
 

;Default colour bar placement.
IF ((NOT KEYWORD_SET(CB_LEFT)) AND (NOT KEYWORD_SET(CB_RIGHT)) AND $
    (NOT KEYWORD_SET(CB_UNDER))) THEN BEGIN
 ;Nothing specified so set a default.
 IF (!guide.projection NE 0) THEN BEGIN
  IF ((!guide.nh EQ 1) OR (!guide.sh EQ 1)) THEN CB_RIGHT=1
  IF KEYWORD_SET(satview) THEN CB_RIGHT=1
 ENDIF
 IF (NOT KEYWORD_SET(CB_RIGHT)) THEN CB_UNDER=1
ENDIF  

;Modify plot position if user doesn't supply and XSIZE and YSIZE.
IF (((XSIZE EQ 0) AND (YSIZE EQ 0)) AND (NOT KEYWORD_SET(overplot))) THEN BEGIN
 ;Fix plotting area to be square for polar plots.
 IF (!guide.projection NE 0) THEN BEGIN
  IF ((!guide.nh EQ 1) OR (!guide.sh EQ 1) OR KEYWORD_SET(satview)) THEN BEGIN
   IF ((xmax-xmin) GT (ymax-ymin)) THEN xmax=xmin+(ymax-ymin)
   IF ((xmax-xmin) LT (ymax-ymin)) THEN ymax=ymin+(xmax-xmin)
  ENDIF
 ENDIF
 
 ;Allow space for the colour bar.
 IF (NOT KEYWORD_SET(NOCOLBAR)) THEN BEGIN
   ;Calculate the dimensions of the colour bar in pixels.
   IF (KEYWORD_SET(CB_LEFT) OR KEYWORD_SET(CB_RIGHT)) THEN BEGIN
    bs=0
    IF (!guide.lower EQ 1) THEN bs=1
    ts=!guide.levels_npts-1
    IF (!guide.upper EQ 1) THEN ts=ts-1
    barwidth=cbsize*cb_width/100.0
    width=barwidth+(MAX(STRLEN(SCROP(!guide.levels(bs:ts)))))*xpix+space1
   ENDIF
   IF KEYWORD_SET(CB_UNDER) THEN BEGIN
    barheight=cbsize*cb_height/100.0
    height=barheight
    IF KEYWORD_SET(CB_ALT) THEN height=barheight+ypix+space1
    IF ((map_type EQ 0) OR (map_type EQ 8)) THEN BEGIN
     height=height+ypix+space2
     IF (tlen GT 0) THEN height=height+tlen
    ENDIF
  ENDIF

  IF (NOT KEYWORD_SET(NOFILL)) THEN BEGIN
   ;Shift plot to right if a left colour bar.
   IF (!guide.projection NE 0) THEN BEGIN
    IF (KEYWORD_SET(CB_LEFT) AND (!guide.nh+!guide.sh NE 0)) THEN BEGIN
     xmin=xmin+width+space2
     xmax=xmax+width+space2
    ENDIF
    ;Shift and compress if left colour bar and not a polar or satellite plot.
    IF (KEYWORD_SET(CB_LEFT) AND (!guide.nh+!guide.sh EQ 0) AND (satview EQ 0)) THEN BEGIN
     xmin=xmin+width
    ENDIF  
    ;Shift and compress if right colour bar and not a polar or satellite plot.
    IF (KEYWORD_SET(CB_RIGHT) AND (!guide.nh+!guide.sh EQ 0) AND (satview EQ 0)) THEN BEGIN
     xmax=xmax-(width+space2)
    ENDIF      
    ;Shift up and compress plot if a horizontal colour bar.
    IF KEYWORD_SET(CB_UNDER) THEN BEGIN
     ymin=ymin+height+space2
     ;Polar or satellite plot adjustment.
     IF (!guide.squareplot EQ 1) THEN BEGIN
      xmax=xmin+(ymax-ymin)
     ENDIF
    ENDIF 
   ENDIF
   
    
   IF (!guide.projection EQ 0) THEN BEGIN
    ;Shift right and compress if left colour bar.
    IF KEYWORD_SET(CB_LEFT)  THEN xmin=xmin+width
    ;Shift left and compress if right colour bar.
    IF KEYWORD_SET(CB_RIGHT)  THEN xmax=xmax-(width+space2)    
    ;Shift up and compress plot if a horizontal colour bar.
    IF KEYWORD_SET(CB_UNDER) THEN ymin=ymin+height+space2
    ENDIF
   ENDIF
  ENDIF
  
 ;Modify if an isotropic plot is needed.   
 IF ((!guide.projection EQ 8) AND (!guide.isotropic EQ 1)) THEN BEGIN
  londiff=!guide.xmax-!guide.xmin
  latdiff=!guide.ymax-!guide.ymin
  xspacing=(xmax-xmin)/londiff
  yspacing=(ymax-ymin)/latdiff
  IF (xspacing LT yspacing) THEN ymax=ymin+xspacing*latdiff
  IF (yspacing LT xspacing) THEN xmax=xmin+yspacing*londiff
 ENDIF  
 
 ;Convert back to normalised units and set plot area.
 pt0=CONVERT_COORD(xmin, ymin, /DEVICE, /TO_NORMAL)
 pt1=CONVERT_COORD(xmax, ymax, /DEVICE, /TO_NORMAL)
 x0=pt0(0)
 x1=pt1(0)
 y0=pt0(1)
 y1=pt1(1)
ENDIF ELSE BEGIN
 barwidth=cbsize*cb_width/100.0
 barheight=cbsize*cb_height/100.0
 height=barheight
 width=barwidth
ENDELSE


;Wrap data if a map and not an irregular grid.
IF ((map_type NE 0) AND (NOT KEYWORD_SET(irreg))) THEN BEGIN
 IF (((MAX(xpts)-MIN(xpts)) NE 360.0)) THEN BEGIN
  diffx=xpts(1)-xpts(0)
  same=0
  FOR i=0, N_ELEMENTS(xpts)-2 DO BEGIN
   londiff=ABS(xpts(i+1)-xpts(i)-diffx)
   IF (londiff GT tol) THEN same=same+1
  ENDFOR
  IF (SAME EQ 0) THEN BEGIN
   IF (((MAX(xpts)+diffx) - MIN(xpts)) EQ 360) THEN BEGIN
    xpts=[xpts,xpts(N_ELEMENTS(xpts)-1)+diffx]
    field=[field, field(0,*)]
   ENDIF 
  ENDIF ELSE BEGIN
   orig=1
  ENDELSE
 ENDIF
ENDIF



;Extend data if a cylindrical projection.
IF ((MAX(xpts)-MIN(xpts) LT 300) AND (map_type NE 0)) THEN orig=1
IF ((orig EQ 0)  AND (NOT KEYWORD_SET(irreg))) THEN BEGIN
 IF ((map_type EQ 8) AND((SIZE(xpts))(0) EQ 1)) THEN BEGIN
 field_new=field
 field_new2=field
 xpts_new=xpts
 xpts_new2=(xpts+360.0) MOD 360.0
 plot_xmin=!guide.xmin
 plot_xmax=!guide.xmax
 plot_ymin=!guide.ymin
 plot_ymax=!guide.ymax
 diffx=xpts(1)-xpts(0)
 same=0
 FOR i=0, N_ELEMENTS(xpts)-2 DO BEGIN
  londiff=ABS(xpts(i+1)-xpts(i)-diffx)
  IF (londiff GT tol) THEN same=same+1
 ENDFOR  
 IF (SAME EQ 0) THEN BEGIN
  ;increase longitudes to span requested region if possible.
  IF (plot_xmax GT MAX(xpts)) THEN BEGIN
   success=0
   mycount=0
   WHILE (success NE 1) DO BEGIN
    newx=MAX(xpts_new)+diffx
    newx2=newx                 
    IF (newx2 GE 360.0) THEN newx2=(newx2+360.0) MOD 360.0
    ptslon=WHERE(ABS(xpts_new2-newx2) LE tol, count)
    IF (count LT 1) THEN BEGIN
     PRINT, ABS(xpts_new2-newx2)
     STOP
     xpts_new2=xpts_new2-(LONG(xpts_new2)/180)*360.0
     ptslon=WHERE(newx2 EQ xpts_new2, count)    
    ENDIF 
    IF (count GE 1) THEN BEGIN
     xpts_new=[xpts_new, newx]
     field_new=[field_new, field_new(ptslon(0), *)]
     IF (plot_xmax LE MAX(xpts_new)) THEN success=1 
    ENDIF ELSE BEGIN
     success=1 ;exit loop
    ENDELSE    
   ENDWHILE
  ENDIF
  ;decrease longitudes to span requested region if possible.
  IF (plot_xmin LT MIN(xpts_new)) THEN BEGIN
   success=0
   mycount=0
   WHILE (success NE 1) DO BEGIN
    newx=MIN(xpts_new)-diffx
    newx2=newx    
    IF (newx2 LE 0.0) THEN newx2=(newx2+360.0) MOD 360.0
    ptslon=WHERE(ABS(xpts_new2-newx2) LT tol, count)
    IF (count LT 1) THEN BEGIN
     xpts_new2=xpts_new2-(LONG(xpts_new2)/180)*360.0
     ptslon=WHERE(newx2 EQ xpts_new2, count)
    ENDIF 
    IF (count GE 1) THEN BEGIN
     xpts_new=[newx, xpts_new]
     field_new=[field_new(ptslon(0), *), field_new]
     IF (plot_xmin GE MIN(xpts_new)) THEN success=1 
     xpts_new2=(xpts_new+360.0) MOD 360.0
    ENDIF ELSE BEGIN
     success=1 ;exit loop
    ENDELSE    
   ENDWHILE
  ENDIF  
 ENDIF
 ;limit longitude data to that which spans plotting region.
 xminpt=MIN(WHERE(plot_xmin LE xpts_new, count))
 IF (count EQ -1) THEN xminpt=0
 IF ((xminpt GE 1) AND (count GE 1)) THEN xminpt=xminpt-1
 xmaxpt=MIN(WHERE(plot_xmax LE xpts_new, count))
 IF ((xmaxpt LT (N_ELEMENTS(xpts)-1)) AND (count GT 0)) THEN xmaxpt=xmaxpt+1 
 xpts=xpts_new(xminpt:xmaxpt)
 field=field_new(xminpt:xmaxpt, *)
 ENDIF
ENDIF


;Set up the position and mapping if needed.
!P.POSITION=[x0, y0, x1, y1]

;Set mapping if needed.
IF ((map_type NE 0) AND (NOT KEYWORD_SET(overplot))) THEN MAP, /NOSTORE

;Set area for plotting if this is not a map projection.
IF ((map_type EQ 0) AND (NOT KEYWORD_SET(overplot))) THEN BEGIN
 plot_xmin=!guide.xmin
 plot_ymin=!guide.ymin
 plot_xmax=!guide.xmax
 plot_ymax=!guide.ymax
 comset='PLOT, [plot_xmin, plot_xmax],[plot_ymin, plot_ymax], XSTYLE=5, YSTYLE=5,'
 comset=comset+'YRANGE=[plot_ymin, plot_ymax], XRANGE=[plot_xmin, plot_xmax], /NODATA,'
 comset=comset+'CLIP=[plot_xmin, plot_ymin, plot_xmax, plot_ymax], /NOERASE'
 IF KEYWORD_SET(!guide.xlog) THEN comset=comset+', /xlog'
 IF KEYWORD_SET(!guide.ylog) THEN comset=comset+', /ylog'
 res=EXECUTE(comset)
ENDIF

;Normal contours with the cylindrical projection.
IF ((map_type EQ 8) AND (NOT KEYWORD_SET(orig)) AND (NOT KEYWORD_SET(irreg))) THEN BEGIN
 plot_xmin=!guide.xmin
 plot_ymin=!guide.ymin
 plot_xmax=!guide.xmax
 plot_ymax=!guide.ymax
 comset='PLOT, [plot_xmin, plot_xmax],[plot_ymin, plot_ymax], XSTYLE=5, YSTYLE=5,'
 comset=comset+'YRANGE=[plot_ymin, plot_ymax], XRANGE=[plot_xmin, plot_xmax], /NODATA,'
 comset=comset+'CLIP=[plot_xmin, plot_ymin, plot_xmax, plot_ymax], /NOERASE'
 res=EXECUTE(comset)
ENDIF

IF ((map_type EQ 8) AND (!guide.xmax-!guide.xmin LT 300)) THEN BEGIN
 IF (NOT KEYWORD_SET(irreg)) THEN BEGIN
  plot_xmin=!guide.xmin
  plot_ymin=!guide.ymin
  plot_xmax=!guide.xmax
  plot_ymax=!guide.ymax
  comset='PLOT, [plot_xmin, plot_xmax],[plot_ymin, plot_ymax], XSTYLE=5, YSTYLE=5,'
  comset=comset+'YRANGE=[plot_ymin, plot_ymax], XRANGE=[plot_xmin, plot_xmax], /NODATA,'
  comset=comset+'CLIP=[plot_xmin, plot_ymin, plot_xmax, plot_ymax], /NOERASE'
  res=EXECUTE(comset)
 ENDIF
ENDIF

;Block plots.
IF KEYWORD_SET(BLOCK) THEN BEGIN
 NOPFIX=1
 IF ((SIZE(xpts))(0) GT 1) THEN BEGIN
  PRINT, 'CON ERROR - cannot use blockfill on non-regular grids.'
  PRINT, 'You will need to use the POLYFILL routine to do this manually as it is impossible'
  PRINT, 'to work out the fill area for non-regular grids.'
  STOP
 ENDIF
 bxpts=N_ELEMENTS(xpts)
 bypts=N_ELEMENTS(ypts)
 FOR ix=0, bxpts-1 DO BEGIN
  FOR iy=0, bypts-1 DO BEGIN
   ;x points
   IF (ix EQ 0) THEN xminblock=xpts(ix)-(xpts(1)-xpts(0))/2.0
   IF ((ix GT 0) AND (ix LT (bxpts-1))) THEN xminblock=xpts(ix)-(xpts(ix)-xpts(ix-1))/2.0
   IF (ix EQ bxpts-1) THEN xminblock=xpts(ix)-(xpts(ix)-xpts(ix-1))/2.0
   IF (ix EQ 0) THEN xmaxblock=xpts(ix)+(xpts(1)-xpts(0))/2.0
   IF ((ix GT 0) AND (ix LT (bxpts-1))) THEN xmaxblock=xpts(ix)+(xpts(ix+1)-xpts(ix))/2.0
   IF (ix EQ bxpts-1) THEN xmaxblock=xpts(ix)+(xpts(ix)-xpts(ix-1))/2.0         
   ;y points
   IF (iy EQ 0) THEN yminblock=ypts(iy)-(ypts(1)-ypts(0))/2.0
   IF ((iy GT 0) AND (iy LT (bypts-1))) THEN yminblock=ypts(iy)-(ypts(iy)-ypts(iy-1))/2.0
   IF (iy EQ bypts-1) THEN yminblock=ypts(iy)-(ypts(iy)-ypts(iy-1))/2.0
   IF (iy EQ 0) THEN ymaxblock=ypts(iy)+(ypts(1)-ypts(0))/2.0
   IF ((iy GT 0) AND (iy LT (bypts-1))) THEN ymaxblock=ypts(iy)+(ypts(iy+1)-ypts(iy))/2.0
   IF (iy EQ bypts-1) THEN ymaxblock=ypts(iy)+(ypts(iy)-ypts(iy-1))/2.0      

   ;Box to fill
   boxxpts=[xminblock,xminblock,xmaxblock,xmaxblock,xminblock]
   boxypts=[yminblock,ymaxblock,ymaxblock,yminblock,yminblock]
   IF (!guide.projection NE 0) THEN BEGIN
    pts=WHERE(boxypts LT -90.0, count)
    IF (count GE 1) THEN boxypts(pts)=-90.0
    pts=WHERE(boxypts GT 90.0, count)
    IF (count GE 1) THEN boxypts(pts)=90.0
   ENDIF
   mycol=MAX(WHERE(field(ix,iy) GE levs))
   IF (mycol GE 0) THEN POLYFILL, boxxpts, boxypts, COLOR=mycol+2, NOCLIP=0
  ENDFOR
 ENDFOR
ENDIF


;Calculate or read in triangulation data if an irregular grid.
IF (((SIZE(xpts))(0) GT 1) OR (irreg EQ 1)) THEN BEGIN
 IF (map_type NE 0) THEN BEGIN
  IF (N_ELEMENTS(tri) EQ 0) THEN QHULL, xpts, ypts, tri, SPHERE=s
 ENDIF 
 ;Modify high latitude points for Orca2 grid to stop stray filling in cylindrical projection.
 IF (((SIZE(xpts))(1) EQ 182) AND ((SIZE(xpts))(2) EQ 149)) THEN BEGIN 
  IF (map_type EQ 8) THEN BEGIN
   pts=WHERE(ypts GT 89.0)
   ypts(pts)=87.0
  ENDIF 
 ENDIF 
ENDIF



;Filled contours.
IF (KEYWORD_SET(NOFILL) AND (NOT KEYWORD_SET(BLOCK))) THEN NOCOLBAR=1
IF KEYWORD_SET(BLOCK) THEN NOFILL=1
IF (NOT KEYWORD_SET(NOFILL) AND (N_ELEMENTS(IMG) EQ 0)) THEN BEGIN
 com='CONTOUR, field, xpts, ypts, LEVELS=levs, XSTYLE=5, YSTYLE=5, /OVERPLOT'
 com=com+',/CELL_FILL, '
 IF KEYWORD_SET(cfill) THEN com=com+'C_COLORS=[INDGEN(nlevs-1)+2]' ELSE $
                            com=com+'C_COLORS=[INDGEN(nlevs-1)+2, INTARR(256)]'
 IF (((SIZE(xpts))(0) GT 1) AND (N_ELEMENTS(tri) EQ 0)) THEN com=com+', TRIANGULATION=triangulation'
 IF (N_ELEMENTS(tri) NE 0) THEN com=com+', TRIANGULATION=tri'
 IF KEYWORD_SET(!guide.xlog) THEN com=com+', /XLOG'
 IF KEYWORD_SET(!guide.ylog) THEN com=com+', /YLOG'
 res=execute(com)
ENDIF


;Image contours.
IF (N_ELEMENTS(IMG) NE 0) THEN BEGIN
 ;Set the image size.
 xsize=xmax-xmin
 ysize=ymax-ymin
 IF (img EQ 1) THEN sf=0.1 ELSE sf=img/1000.0
 xplotsize=FIX(xsize*sf)
 yplotsize=FIX(ysize*sf)

 ;Move into the Z-buffer.
 TVLCT, r, g, b, /GET 
 
 SET_PLOT, 'Z'
 DEVICE, SET_RESOLUTION=[xplotsize, yplotsize], DECOMPOSED=0
 TVLCT, r, g, b 
 !P.POSITION=[0.0, 0.0, 1.0, 1.0]

 res=EXECUTE(comset) 
 
 ;Contour the data.
 com='CONTOUR, field, xpts, ypts, LEVELS=levs, XSTYLE=5, YSTYLE=5, /OVERPLOT, /CELL_FILL,'
 IF KEYWORD_SET(cfill) THEN com=com+'C_COLORS=[INDGEN(nlevs-1)+2]' ELSE $
                            com=com+'C_COLORS=[INDGEN(nlevs-1)+2, INTARR(256)]'
 IF (((SIZE(xpts))(0) GT 1) AND (N_ELEMENTS(tri) EQ 0)) THEN com=com+', TRIANGULATION=triangulation'
 IF (N_ELEMENTS(tri) NE 0) THEN com=com+', TRIANGULATION=tri'
 IF KEYWORD_SET(!guide.xlog) THEN com=com+', /XLOG'
 IF KEYWORD_SET(!guide.ylog) THEN com=com+', /YLOG'
 res=execute(com) 
 image = TVRD()
 
 ;Clear the image - from Chris Holloway.
 comclear='PLOT, [plot_xmin, plot_xmax],[plot_ymin, plot_ymax], XSTYLE=5, YSTYLE=5,'
 comclear=comclear+'YRANGE=[plot_ymin, plot_ymax], XRANGE=[plot_xmin, plot_xmax], /NODATA,'
 comclear=comclear+'CLIP=[plot_xmin, plot_ymin, plot_xmax, plot_ymax]'
 clearres = execute(comclear) 

 ;Return to original device.
 SET_PLOT, 'PS'

 ;Display the image.
 TVLCT, r, g, b
 TV, image, xmin, ymin, XSIZE=xplotsize/sf, YSIZE=yplotsize/sf, /DEVICE
 
 ;Set the position and reestablish plotting coordinates.
 !P.POSITION=[x0, y0, x1, y1]
 res=EXECUTE(comset) 
 !P.COLOR=1   
 !P.THICK=!guide.thick
ENDIF


;Line contours.
IF (NOT KEYWORD_SET(NOLINES)) THEN BEGIN
 com="CONTOUR, field, xpts, ypts, LEVELS=levs, XSTYLE=5, YSTYLE=5, /OVERPLOT"
 IF (NOT KEYWORD_SET(NOLINELABELS)) THEN com=com+",C_ANNOTATION=SCROP(levs),FONT=0,"+$
                                "C_CHARSIZE=!guide.ccharsize"
 IF (N_ELEMENTS(STYLE) EQ N_ELEMENTS(levs)) THEN com=com+",C_LINESTYLE=style"
 IF (N_ELEMENTS(COL) EQ N_ELEMENTS(levs)) THEN com=com+",C_COLOR=col"
 IF (N_ELEMENTS(THICK) EQ N_ELEMENTS(levs)) THEN com=com+",C_THICK=thick"
 IF KEYWORD_SET(!guide.xlog) THEN com=com+', /XLOG'
 IF KEYWORD_SET(!guide.ylog) THEN com=com+', /YLOG'
 IF (((SIZE(xpts))(0) GT 1) AND (N_ELEMENTS(tri) EQ 0))  THEN com=com+', TRIANGULATION=triangulation'
 IF (N_ELEMENTS(tri) NE 0) THEN com=com+', TRIANGULATION=tri'
 res=EXECUTE(com) 
ENDIF

;Restore mapping.
;IF ((map_type EQ 8) AND (NOT KEYWORD_SET(orig))) THEN BEGIN
IF (map_type EQ 8) THEN MAP, /NOSTORE

;Retrieve plot position.
x0=!P.POSITION(0)
x1=!P.POSITION(2)
y0=!P.POSITION(1)
y1=!P.POSITION(3)

;Set the font for the titles.
res=EXECUTE(!guide.titlefont)	
font=!guide.tfont
charsize=tcharsize;!guide.tcharsize

; Add the axes and titles if appropriate.
IF ((NOT KEYWORD_SET(NOAXES)) AND (map_type NE 0)) THEN AXES  
font=!guide.tfont
charsize=tcharsize;!guide.tcharsize
IF (N_ELEMENTS(TITLE) GT 0) THEN XYOUTS, (xmax-xmin)/2.0+xmin, ymax+space3, ALIGN=0.5, $
              FONT=0, CHARSIZE=charsize, title, /DEVICE
IF (N_ELEMENTS(LEFT_TITLE) GT 0) THEN XYOUTS, xmin, ymax+100, ALIGN=0.0,  $
              FONT=0, CHARSIZE=charsize, left_title, /DEVICE
;IF (N_ELEMENTS(LEFT_TITLE) GT 0) THEN XYOUTS, xmin, ymax+space3, ALIGN=0.0,  $
;              FONT=0, CHARSIZE=charsize, left_title, /DEVICE
IF (N_ELEMENTS(RIGHT_TITLE) GT 0) THEN XYOUTS, xmax, ymax+space3, ALIGN=1.0,  $
              FONT=0, CHARSIZE=charsize, right_title, /DEVICE
IF (N_ELEMENTS(LEFT_LABEL) GT 0) THEN XYOUTS, xmin-(space3) ,(ymax-ymin)/2.0+ymin, ALIGN=0.5,  $
              FONT=0, CHARSIZE=charsize, left_label, ORIENTATION=90, /DEVICE
IF (N_ELEMENTS(RIGHT_LABEL) GT 0) THEN XYOUTS, xmax+space3 ,(ymax-ymin)/2.0+ymin, ALIGN=0.0,  $
              FONT=0, CHARSIZE=charsize, right_label, ORIENTATION=-90, /DEVICE
	            
;Set the font back again.
res=EXECUTE(!guide.textfont)    
font=!guide.font
charsize=!guide.charsize	
      
plotpos=!P.POSITION
	      
;Place colour bar on the plot.
extraspace=0
IF ((map_type EQ 0) OR (map_type EQ 1) OR (map_type EQ 2) OR (map_type EQ 8)) THEN extraspace=1
IF (NOT KEYWORD_SET(NOCOLBAR)) THEN BEGIN
 IF KEYWORD_SET(CB_UNDER) THEN BEGIN
  xoffset=(xmax-xmin)*(100-cb_width)/200.0
  cbxmin=xmin+xoffset
  cbxmax=xmax-xoffset
  ; MODIFIED HERE BY RP 10/06/2014
  cbymin=ymin-(height+space2)-800   
  cbymax=cbymin+(barheight)
 ENDIF
 IF KEYWORD_SET(CB_LEFT) THEN BEGIN
  cbxmin=xmin-space2-barwidth
  IF ((NOT KEYWORD_SET(NOAXES)) AND KEYWORD_SET(extraspace)) THEN cbxmin=cbxmin-(3*xpix+space1)
  IF (tlen GT 0) THEN cbxmin=cbxmin-tlen
  cbxmax=cbxmin+barwidth
  yoffset=(ymax-ymin)*(100-cb_height)/200.0
  cbymin=ymin+yoffset
  cbymax=ymax-yoffset
 ENDIF
 IF KEYWORD_SET(CB_RIGHT) THEN BEGIN
  cbxmin=xmax+space2
  IF ((NOT KEYWORD_SET(NOAXES) AND KEYWORD_SET(extraspace))) THEN cbxmin=cbxmin+(3*xpix+space1)
  IF (tlen GT 0) THEN cbxmin=cbxmin+tlen
  cbxmax=cbxmin+barwidth
  yoffset=(ymax-ymin)*(100-cb_height)/200.0
  cbymin=ymin+yoffset
  cbymax=ymax-yoffset
 ENDIF 
   
 com2="COLBAR, COORDS=[cbxmin,cbymin,cbxmax,cbymax], TITLE='"+CB_TITLE+"'"
 IF (KEYWORD_SET(CB_ALT)) THEN com2=com2+',/ALT'
 IF KEYWORD_SET(CB_RIGHT) THEN com2=com2+',/TEXTPOS'
 IF (N_ELEMENTS(cb_nvals) EQ 1) THEN com2=com2+', NVALS=cb_nvals'
 IF (N_ELEMENTS(cb_nth) EQ 1) THEN com2=com2+', NTH=cb_nth'
 IF KEYWORD_SET(cb_nolines) THEN com2=com2+', /NOLINES'
 IF KEYWORD_SET(cb_labels) THEN com2=com2+', LABELS=cb_labels'
 IF KEYWORD_SET(cb_vtext) THEN com2=com2+', /VTEXT'
 res=EXECUTE(com2)
 !P.POSITION=plotpos
ENDIF


;Overlay the continents if needed.
IF (map_type NE 0) THEN BEGIN
 IF (NOT KEYWORD_SET(NOMAP)) THEN BEGIN
  com="MAP_CONTINENTS, MLINETHICK=!guide.cthick, MLINESTYLE=!guide.cstyle, COLOR=!guide.ccolour "
  IF (!guide.hires EQ 1) THEN com=com+', /HIRES'
  res=EXECUTE(com)
  IF (!guide.countries EQ 1) THEN res=EXECUTE('MAP_CONTINENTS, /COUNTRIES')
 ENDIF
ENDIF


;Return field, xpts and ypts as original values.
field=field_orig
xpts=xpts_orig
ypts=ypts_orig
!guide.overplot=1
!guide.position=[x0, y0, x1, y1]

;Produce a quick plot if requested.
IF KEYWORD_SET(qp) THEN BEGIN
 IF (!guide.projection EQ 0) THEN AXES
 IF (tsum EQ 0) THEN GPLOT, X=14750, Y=18300, TEXT='Min='+SCROP(fmin)+'  Max='+SCROP(fmax), /DEVICE
 PSCLOSE
ENDIF

;Mask off everything apart from countries specified in COUNTRY procedure.
IF (N_ELEMENTS(mask) EQ 1) THEN BEGIN
 GET_LUN, unit 
 OPENR, unit, mask, /F77_UNFORMATTED
 xplotsize=1
 yplotsize=1
 READU, unit, xplotsize, yplotsize
 this_mask=BYTARR(xplotsize, yplotsize)
 READU, unit , this_mask
 FREE_LUN, unit

 nxpts=xplotsize
 nypts=yplotsize
 xmin=!guide.xmin
 xmax=!guide.xmax
 ymin=!guide.ymin
 ymax=!guide.ymax
 xstep=(xmax-xmin)/FLOAT(nxpts)
 ystep=(ymax-ymin)/FLOAT(nypts)
 
 pts=WHERE(this_mask EQ 0, count)
 mask_new=INTARR(nxpts, nypts)
 mask_new(pts)=1
 CS, COLS=[444, 444]
 LEVS, MANUAL=[0.001, 2], /UPPER
 CON, F=mask_new, X=xmin+FINDGEN(nxpts)*xstep, Y=ymin+FINDGEN(nypts)*ystep, /NOLINES, /NOCOLBAR, /NOMAP
   
ENDIF

END

