PRO FIND_FEAT, SEP=sep, MATCH=match, FEAT=feat, XWRAP=xwrap
;Procedure to find features in a field.
;(C) NCAS 2010

s=SIZE(match)
mask=INTARR(s(1), s(2)) ;Array for storing the mask array.
fmatch=INTARR(s(1), s(2)) ;Array for storing this feature.
pts=WHERE(match EQ 1, count)
fpts=pts
ifeat=0 ;Feature counter.
imatch=1 ;Number of matching points.
IF (N_ELEMENTS(xwrap) EQ 0) THEN xwrap=0

WHILE (count GT 0) DO BEGIN
 fpts=WHERE(match EQ 1, imatch)
 
 WHILE (imatch GT 0) DO BEGIN
  thispt=fpts(0)
  match(thispt)=0 
  fmatch(thispt)=0
  feat(thispt)=ifeat
 
  ;Find points to check for inclusion in feature.
  ind=ARRAY_INDICES(match, thispt) 
  ix=ind(0, 0)
  iy=ind(1, 0)    
  ixmin=ix-sep
  ixmax=ix+sep
  iymin=iy-sep
  iymax=iy+sep
  mask(MAX([ixmin, 0]):MIN([ixmax, s(1)-1]), MAX([iymin, 0]):MIN([iymax, s(2)-1]))=1
  IF (xwrap EQ 1) THEN BEGIN
   IF (ixmin LT 0) THEN $
       mask(s(1)+ixmin:s(1)-1, MAX([iymin, 0]):MIN([iymax, s(2)-1]))=1
   IF (ixmax GT s(1)-1) THEN $
       mask(0:ixmax-s(1), MAX([iymin, 0]):MIN([iymax, s(2)-1]))=1
  ENDIF
    
  ;Check whether these points are in this feature.
  cpts=WHERE(mask*match GT 0, matching)  
  IF (matching GT 0) THEN BEGIN
   feat(cpts)=ifeat
   match(cpts)=0
   fmatch(cpts)=1
  ENDIF  
  fpts=WHERE(fmatch EQ 1, imatch)    
 ENDWHILE  
 ifeat=ifeat+1 ;Increment the feature counter. 
 pts=WHERE(match EQ 1, count) 
ENDWHILE
 
END



FUNCTION features, FIELD=field_in, MIN=min, MAX=max, SEP=sep, X=x, Y=y, DRAW=draw, $
                   LABEL=label, CHARSIZE=charsize, FONT=font, ITALIC=italic, COL=col, $
		   BOLD=bold, NDECS=ndecs, THRESHOLD=threshold, V=v
		   
;Function to find features in a field.
;(C) NCAS 2010

field=field_in

;Check input fields look okay.
IF (N_ELEMENTS(FIELD) EQ 0) THEN BEGIN
 PRINT, ''
 PRINT, 'FEATURE error - no input field.'
 HELP, field
 PRINT, ''
 STOP
ENDIF


;Check whether wrapping of field is required.
IF (N_ELEMENTS(x) GT 0) THEN BEGIN
 xwrap=1
 ywrap=1 
 ;Unwrap data if it is already wrapped.
 IF (MAX(x)-MIN(x) EQ 360.0) THEN BEGIN
  step=x(1)-x(0)
  xs=SIZE(field)
  IF (x(xs(1)-2)+step - x(0) EQ 360.0) THEN BEGIN
   field=field(0:xs(1)-2, *)
   x=x(0:xs(1)-2)
   xwrap=1
   PRINT, ''
   PRINT, 'FEATURES - field supplied is wrapped in longitude.'
   PRINT, 'The data has been unwrapped and now has the longitudes:'
   PRINT, x
   HELP, field, x
   PRINT, ''
  ENDIF
 ENDIF
ENDIF 


s=SIZE(field)
IF (s(0) NE 2) THEN BEGIN
 PRINT, ''
 PRINT, 'FEATURE error - input field must have two dimensions only.'
 HELP, field
 PRINT, ''
 STOP
ENDIF

IF ((N_ELEMENTS(MIN) EQ 0) AND (N_ELEMENTS(MAX) EQ 0)) THEN BEGIN
  PRINT, ''
  PRINT, 'FEATURE error - Either MIN, MAX or both must be supplied.'
  PRINT, ''
  STOP
ENDIF
IF (N_ELEMENTS(sep) EQ 0) THEN sep=1 ;Define separation if not specified.
match=INTARR(s(1), s(2)) ;Matching points array.
feat=INTARR(s(1), s(2))-1


;Min defined.
IF (N_ELEMENTS(MIN) EQ 1) THEN BEGIN
 pts=WHERE(field LE min, count)
 IF (count GT 0) THEN BEGIN
  match(pts)=1 
  feat_min=INTARR(s(1), s(2))-1
  FIND_FEAT, MATCH=MATCH, FEAT=feat_min, SEP=sep, XWRAP=xwrap
 ENDIF ELSE BEGIN
  PRINT, ''
  PRINT, 'FEATURE error - No points <= ', SCROP(min), ' in the field supplied.'
  PRINT, ''
  STOP
 ENDELSE
ENDIF


;Max defined.
IF (N_ELEMENTS(MAX) EQ 1) THEN BEGIN
 pts=WHERE(field GE max, count)
 IF (count GT 0) THEN BEGIN
  match(pts)=1
  feat_max=INTARR(s(1), s(2))-1
  FIND_FEAT, MATCH=MATCH, FEAT=feat_max, SEP=sep, XWRAP=xwrap
 ENDIF ELSE BEGIN
  PRINT, ''
  PRINT, 'FEATURE error - No points >= ', SCROP(max), ' in the field supplied.'
  PRINT, ''
  STOP
 ENDELSE 
ENDIF


;Construct the feature array for return to the calling procedure.
IF (N_ELEMENTS(min) NE 0) THEN struct=CREATE_STRUCT('min', feat_min)
IF (N_ELEMENTS(max) NE 0) THEN BEGIN
 IF (N_ELEMENTS(min) NE 0) THEN struct=CREATE_STRUCT(struct, 'max', feat_max)
 IF (N_ELEMENTS(min) EQ 0) THEN struct=CREATE_STRUCT('max', feat_max)
ENDIF


;Draw features if requested.
IF KEYWORD_SET(draw) THEN BEGIN
 xd=(x(1)-x(0))/2.0
 yd=(y(1)-y(0))/2.0
 FOR ix=0, s(1)-1 DO BEGIN
  FOR iy=0, s(2)-1 DO BEGIN
   IF (N_ELEMENTS(x) NE 0) THEN BEGIN
    xpts=[x(ix)-xd, x(ix)-xd, x(ix)+xd, x(ix)+xd, x(ix)-xd]
    ypts=[y(iy)-yd, y(iy)+yd, y(iy)+yd, y(iy)-yd, y(iy)-yd]
   ENDIF ELSE BEGIN
    xpts=[ix, ix, ix+1, ix+1, ix]
    ypts=[iy, iy+1, iy+1, iy, iy]
   ENDELSE
   IF (N_ELEMENTS(min) GT 0) THEN BEGIN
    IF (feat_min(ix, iy) GE 0) THEN GPLOT, X=xpts, Y=ypts, COL=1, FILL=feat_min(ix, iy)+2
   ENDIF
   IF (N_ELEMENTS(max) GT 0) THEN BEGIN
    IF (feat_max(ix, iy) GE 0) THEN  GPLOT, X=xpts, Y=ypts, COL=1, FILL=feat_max(ix, iy)+2
   ENDIF
  ENDFOR
 ENDFOR
ENDIF


;Plot feature labels if requested.
IF (N_ELEMENTS(LABEL) NE 0) THEN BEGIN
 IF (N_ELEMENTS(threshold) EQ 0) THEN threshold=0
 IF (N_ELEMENTS(ndecs) EQ 0) THEN ndecs=0
 xd=(x(1)-x(0))/2.0
 yd=(y(1)-y(0))/2.0
 
 com='GPLOT, X=x(ix)+xd, Y=y(iy)+yd, TEXT=mlabel, VALIGN=0.5'
 IF (N_ELEMENTS(font) NE 0) THEN com=com+', FONT='+SCROP(font)
 IF (N_ELEMENTS(charsize) NE 0) THEN com=com+', CHARSIZE='+SCROP(charsize)
 IF (N_ELEMENTS(bold) NE 0) THEN com=com+', /BOLD'
 IF (N_ELEMENTS(ITALIC) NE 0) THEN com=com+', /ITALIC'
 IF (N_ELEMENTS(COL) NE 0) THEN com=com+', COL='+SCROP(col)
 
 IF (N_ELEMENTS(max) GT 0) THEN BEGIN
  mlabel='H'
  IF (label eq 1) THEN mlabel='High'
  FOR i=0, MAX(feat_max) DO BEGIN
   pts=WHERE(feat_max EQ i, count)
   maxval=MAX(field(pts))
   mloc=WHERE(field(pts) EQ maxval)
   maxloc=pts(mloc(0))   
   ind=ARRAY_INDICES(field, maxloc) 
   ix=ind(0, 0)
   iy=ind(1, 0) 
   IF (count GT threshold) THEN BEGIN
    IF (label EQ 2) THEN mlabel=SCROP(maxval, NDECS=ndecs)
    res=EXECUTE(com) 
   ENDIF
  ENDFOR
 ENDIF

 IF (N_ELEMENTS(min) GT 0) THEN BEGIN
  mlabel='L'
  IF (label eq 1) THEN mlabel='Low'
  FOR i=0, MAX(feat_min) DO BEGIN
   pts=WHERE(feat_min EQ i, count)
   minval=MIN(field(pts))
   mloc=WHERE(field(pts) EQ minval)
   minloc=pts(mloc(0))   
   ind=ARRAY_INDICES(field, minloc) 
   ix=ind(0, 0)
   iy=ind(1, 0) 
   IF (count GT threshold) THEN BEGIN
    IF (label EQ 2) THEN mlabel=SCROP(minval, NDECS=ndecs)
    res=EXECUTE(com) 
   ENDIF
  ENDFOR
 ENDIF
 
ENDIF


;Print out feature information if requested.
IF (N_ELEMENTS(min) GT 0) THEN BEGIN
 minpts=INTARR(MAX(feat_min)+1)
 IF KEYWORD_SET(v) THEN PRINT, ''
 IF KEYWORD_SET(v) THEN PRINT, 'Minimum features'
 IF KEYWORD_SET(v) THEN PRINT, '----------------'
 FOR i=0, MAX(feat_min) DO BEGIN
  pts=WHERE(feat_min EQ i, count)
  IF KEYWORD_SET(v) THEN PRINT, 'Feature=', SCROP(i), ' has ', SCROP(count), ' points.'
  minpts(i)=count
 ENDFOR
 IF KEYWORD_SET(v) THEN PRINT, ''
 struct=CREATE_STRUCT(struct, 'minpts', minpts)
ENDIF
IF (N_ELEMENTS(max) GT 0) THEN BEGIN
 maxpts=INTARR(MAX(feat_max)+1)
 IF KEYWORD_SET(v) THEN PRINT, ''
 IF KEYWORD_SET(v) THEN PRINT, 'Maximum features'
 IF KEYWORD_SET(v) THEN PRINT, '----------------'
 FOR i=0, MAX(feat_max) DO BEGIN
  pts=WHERE(feat_max EQ i, count)
  IF KEYWORD_SET(v) THEN PRINT, 'Feature=', SCROP(i), ' has ', SCROP(count), ' points.'
  maxpts(i)=count
 ENDFOR
 IF KEYWORD_SET(v) THEN PRINT, ''
 struct=CREATE_STRUCT(struct, 'maxpts', maxpts)
ENDIF 



RETURN, struct

END



