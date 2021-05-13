pro country, NAME=name, ISO=iso, COL=col, FILLCOL=fillcol, NOBORDER=noborder, THICK=thick, $   
             LIST=list, MASK=mask
;Procedure to plot and fill countries.
;Based on ITT-VIS code I think.
;NCAS 2010.

IF (N_ELEMENTS(name) NE 0) THEN attribute_name='LONG_NAME'
IF (N_ELEMENTS(iso) NE 0) THEN attribute_name='ISO_3DIGIT'
IF (N_ELEMENTS(attribute_name) EQ 0) THEN attribute_name='ISO_3DIGIT'
IF (N_ELEMENTS(iso) NE 0) THEN name=iso
IF (N_ELEMENTS(col) EQ 0) THEN col=1
IF (N_ELEMENTS(col) NE N_ELEMENTS(name)) THEN col=INTARR(N_ELEMENTS(name))+col(0)
IF (N_ELEMENTS(THICK) EQ 0) THEN thick=100


;Country outlines.
statefile=FILEPATH(SUBDIRECTORY=['resource', 'maps', 'shape'], 'country.shp')

;Open the shape file and create the shape object.
shapefile=OBJ_NEW('IDLffShape', stateFile)

;Get the attribute names from the shape file.
shapefile -> GETPROPERTY, ATTRIBUTE_NAMES=names
names=STRUPCASE(STRTRIM(names, 2))

;Find the attribute index.
attind=WHERE(names EQ attribute_name, count)

;Get all the attribute pointers from the file. 
ent = PTR_NEW(/ALLOCATE_HEAP)
*ent=shapefile -> GETENTITY(/ALL, /ATTRIBUTES)

;List country names and ISO allocation if requested.
IF KEYWORD_SET(list) THEN BEGIN
 attind1=WHERE(names EQ 'ISO_3DIGIT', count)
 ent1=PTR_NEW(/ALLOCATE_HEAP)
 *ent1=shapefile -> GETENTITY(/ALL, /ATTRIBUTES)
 attind2=WHERE(names EQ 'LONG_NAME', count)
 ent2=PTR_NEW(/ALLOCATE_HEAP)
 *ent2=shapefile -> GETENTITY(/ALL, /ATTRIBUTES) 
 PRINT, ''
 PRINT, 'ISO    LONG NAME'
 PRINT, '----------------'
 FOR j=0,N_Elements(*ent)-1 DO BEGIN
  e1=(*ent1)[j]
  country1=STRUPCASE(SCROP((*e1.attributes).(attind1)))
  e2=(*ent2)[j]
  country2=STRUPCASE(SCROP((*e2.attributes).(attind2)))  
  PRINT, country1, '    ', country2
 ENDFOR 
 RETURN
ENDIF



IF (N_ELEMENTS(mask) EQ 1) THEN BEGIN
 ;Make an image plot of the region.
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

 ;Set the image size.
 plot_xmin=!guide.xmin
 plot_xmax=!guide.xmax
 plot_ymin=!guide.ymin
 plot_ymax=!guide.ymax
 xsize=plot_xmax-plot_xmin
 ysize=plot_ymax-plot_ymin

 sf=20
 xplotsize=FIX(xsize*sf)
 yplotsize=FIX(ysize*sf)

 comset='PLOT, [plot_xmin, plot_xmax],[plot_ymin, plot_ymax], XSTYLE=5, YSTYLE=5,'
 comset=comset+'YRANGE=[plot_ymin, plot_ymax], XRANGE=[plot_xmin, plot_xmax], /NODATA,'
 comset=comset+'CLIP=[plot_xmin, plot_ymin, plot_xmax, plot_ymax], /NOERASE'

 ;Move into the Z-buffer.
 TVLCT, r, g, b, /GET 
 SET_PLOT, 'Z'
 DEVICE, SET_RESOLUTION=[xplotsize, yplotsize], DECOMPOSED=0
 TVLCT, r, g, b 
 !P.POSITION=[0.0, 0.0, 1.0, 1.0]

 res=EXECUTE(comset) 

ENDIF


;Cycle through each entity and draw it, if required.
count=0
FOR j=0,N_ELEMENTS(*ent)-1 DO BEGIN
 ent1=(*ent)[j]
 country=STRUPCASE(SCROP((*ent1.attributes).(attind)))
 ind=WHERE(name EQ country, test)
 
 IF (test EQ 1) THEN BEGIN
  count=count+1
  FOR c=0,N_ELEMENTS(name)-1 DO BEGIN
   IF c EQ ind THEN BEGIN
    cuts=[*ent1.parts, ent1.n_vertices]
     FOR k=0, ent1.n_parts-1 DO BEGIN
      lons=(*ent1.vertices)[0, cuts[k]:cuts[k+1]-1]
      lats=(*ent1.vertices)[1, cuts[k]:cuts[k+1]-1]
      IF (N_ELEMENTS(fillcol) NE 0) THEN GPLOT, X=REFORM(lons), Y=REFORM(lats), FILLCOL=fillcol(c), /NOLINES, /CLIP
      IF NOT KEYWORD_SET(fillcol) THEN GPLOT, X=REFORM(lons), Y=REFORM(lats), COL=col(c), THICK=thick, /CLIP
      IF NOT KEYWORD_SET(noborder) THEN GPLOT, X=REFORM(lons), Y=REFORM(lats), COL=col(c), THICK=thick, /CLIP
     ENDFOR
    ENDIF
   ENDFOR

 ENDIF
ENDFOR

IF (N_ELEMENTS(mask) EQ 1) THEN BEGIN
 this_mask=TVRD()
 GET_LUN, unit 
 OPENW, unit, mask, /F77_UNFORMATTED
 WRITEU, unit, LONG(xplotsize), LONG(yplotsize)
 WRITEU, unit , this_mask
 FREE_LUN, unit
 ;Return to original device.
 SET_PLOT, 'PS'
 !P.POSITION=[x0, y0, x1, y1]
 res=EXECUTE(comset) 
 !P.COLOR=1   
 !P.THICK=!guide.thick
ENDIF

END
