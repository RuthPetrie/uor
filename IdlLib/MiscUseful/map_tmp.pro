PRO MAP, LATMIN=latmin, LATMAX=latmax, LONMIN=lonmin, LONMAX=lonmax, $
         NH=nh, SH=sh, ORTHO=ortho, LAMBERT=lambert, ROBINSON=robinson, $
	 MOLLWEIDE=mollweide, CYLINDRICAL=cylindrical, SATELLITE=satellite, $
	 SECTOR=sector, LAND=land, OCEAN=ocean, HIRES=hires, NOSTORE=nostore, $
	 DRAW=draw, SET=set, LAKES=lakes, ISOTROPIC=isotropic, COUNTRIES=countries
;Procedure for setting up a map projection.
;(C) NCAS 2010
  	  

;Check !guide structure exists.
DEFSYSV, '!guide', exists=exists
IF (exists EQ 0) THEN BEGIN
 PRINT, ''
 PRINT, 'ERROR - PSOPEN must first be called to initiate a postscript file.'
 PRINT, ''
 STOP
ENDIF

IF (N_ELEMENTS(lonmin) EQ 0) THEN lonmin=-180
IF (N_ELEMENTS(lonmax) EQ 0) THEN lonmax=180
IF (N_ELEMENTS(latmin) EQ 0) THEN latmin=-90
IF (N_ELEMENTS(latmax) EQ 0) THEN latmax=90
!guide.squareplot=0 ;Turn squaring off.
IF NOT KEYWORD_SET(nh) THEN nh=0
IF KEYWORD_SET(nh) THEN !guide.squareplot=1
IF NOT KEYWORD_SET(sh) THEN sh=0
IF KEYWORD_SET(sh) THEN !guide.squareplot=1
IF (N_ELEMENTS(ortho) EQ 0) THEN ortho=0
cylindrical=0
IF ((N_ELEMENTS(robinson) EQ 0) AND (N_ELEMENTS(mollweide) EQ 0) AND (NH+SH EQ 0) AND $
     (N_ELEMENTS(satellite) EQ 0)) THEN cylindrical=1
IF (N_ELEMENTS(robinson) EQ 0) THEN robinson=0
IF (N_ELEMENTS(lambert) EQ 0) THEN lambert=0
IF (N_ELEMENTS(mollweide) EQ 0) THEN mollweide=0
IF (N_ELEMENTS(satellite) EQ 0) THEN satellite=[-99.0, -99.0]
IF (N_ELEMENTS(satellite) EQ 1) THEN satellite=[0.0, 50.0]
IF ((SATELLITE(0) NE -99.0) AND (SATELLITE(1) NE -99.0)) THEN !guide.squareplot=1
IF (N_ELEMENTS(sector) EQ 0) THEN sector=0
IF (N_ELEMENTS(land) EQ 0) THEN land=-1
IF (N_ELEMENTS(ocean) EQ 0) THEN ocean=-1
IF (N_ELEMENTS(hires) EQ 0) THEN hires=0
IF (N_ELEMENTS(countries) EQ 0) THEN countries=0

IF ((NH+SH EQ 0) AND (ORTHO EQ 1)) THEN BEGIN
 PRINT, ''
 PRINT, 'MAP ERROR - need to select either /NH or /SH as well as /ORTHO'
 PRINT, ''
 STOP
ENDIF
IF (lonmax-lonmin GT 360) THEN BEGIN
 PRINT, ''
 PRINT, 'MAP ERROR - longitude extent greater than 360 degrees.'
 PRINT, 'lonmin=', SCROP(lonmin), ' lonmax=', SCROP(lonmax)
 PRINT, 'Please set to 360 degrees or less.'
 PRINT, ''
 STOP
ENDIF
IF (lonmax GT 360) THEN BEGIN
 PRINT, ''
 PRINT, 'MAP ERROR - LONMAX greater than 360 degrees.'
 PRINT, 'Maximum allowed value=360.'
 PRINT, ''
 STOP
ENDIF
 IF (lonmin LT -360) THEN BEGIN
 PRINT, ''
 PRINT, 'MAP ERROR - LONMIN less than -360 degrees.'
 PRINT, 'Minimum allowed value=-360.'
 PRINT, ''
 STOP
ENDIF
IF (lonmax LE lonmin) THEN BEGIN
 PRINT, ''
 PRINT, 'MAP ERROR - LONMIN must be less than LONMAX.'
 PRINT, 'lonmin=', SCROP(lonmin), ' lonmax=', SCROP(lonmax)
 PRINT, ''
 STOP
ENDIF

store=1 ; switch for storing variables for later use from CON.
IF KEYWORD_SET(NOSTORE) THEN store=0

IF (STORE EQ 1) THEN BEGIN
 ;store variables
 !guide.xmin=FLOAT(lonmin)
 !guide.xmax=FLOAT(lonmax)
 !guide.ymin=FLOAT(latmin)
 !guide.ymax=FLOAT(latmax)
 !guide.nh=nh
 !guide.sh=sh
 !guide.ortho=ortho
 !guide.lambert=lambert
 !guide.mollweide=mollweide
 !guide.robinson=robinson
 !guide.satellite=FLOAT(satellite)
 !guide.cylindrical=cylindrical
 !guide.hires=hires
 !guide.sector=sector
 !guide.land=land
 !guide.ocean=ocean
 IF KEYWORD_SET(isotropic) THEN !guide.isotropic=1
 !guide.coords_established=1
 !guide.countries=countries
 IF (!guide.cylindrical EQ 1) THEN !guide.projection=8
 IF ((nh EQ 1) OR (sh EQ 1)) THEN !guide.projection=1
 IF (!guide.ortho EQ 1) THEN !guide.projection=2
 IF (((!guide.satellite(0) NE -99.0) AND (!guide.satellite(1) NE -99.0))) THEN !guide.projection=7
 IF (!guide.mollweide EQ 1) THEN !guide.projection=10
 IF (!guide.robinson EQ 1) THEN !guide.projection=17
 IF (!guide.sector EQ 1) THEN !guide.projection=1
ENDIF 

IF (KEYWORD_SET(DRAW)) THEN store=0
IF (KEYWORD_SET(SET)) THEN store=0

IF (NOT KEYWORD_SET(STORE)) THEN BEGIN
 ;retrieve variables and do mapping now.
 lonmin=!guide.xmin
 lonmax=!guide.xmax
 latmin=!guide.ymin
 latmax=!guide.ymax
 nh=!guide.nh
 sh=!guide.sh
 ortho=!guide.ortho
 lambert=!guide.lambert
 mollweide=!guide.mollweide
 robinson=!guide.robinson
 satellite=!guide.satellite
 cylindrical=!guide.cylindrical
 hires=!guide.hires
 sector=!guide.sector
 land=!guide.land
 ocean=!guide.ocean
 SATVIEW=1
 IF ((SATELLITE(0) EQ -99.0) AND (SATELLITE(1) EQ -99.0)) THEN SATVIEW=0
 
 
 ;Reset position to a square plot if polar.
 IF ((sh EQ 1) OR (nh EQ 1)) THEN BEGIN
  ;Get plot corners in pixels
  mx0=!guide.position(0)
  mx1=!guide.position(2)
  my0=!guide.position(1)
  my1=!guide.position(3)
  pt=CONVERT_COORD(mx0, my0, /NORMAL, /TO_DEVICE)
  mxmin=pt(0)
  mymin=pt(1)
  pt=CONVERT_COORD(mx1, my1, /NORMAL, /TO_DEVICE)
  mxmax=pt(0)
  mymax=pt(1)
  IF ((mxmax-mxmin) GT (mymax-mymin)) THEN mxmax=mxmin+(mymax-mymin)
  IF ((mxmax-mxmin) LT (mymax-mymin)) THEN mymax=mymin+(mxmax-mxmin)
  pt0=CONVERT_COORD(mxmin, mymin, /DEVICE, /TO_NORMAL)
  pt1=CONVERT_COORD(mxmax, mymax, /DEVICE, /TO_NORMAL)
  !guide.xmin=pt0(0)
  !guide.xmax=pt1(0)
  !guide.ymin=pt0(1)
  !guide.ymax=pt1(1) 
  !P.POSITION=[pt0(0), pt0(1), pt1(0), pt1(1)]
  !guide.position=[pt0(0), pt0(1), pt1(0), pt1(1)]
 ENDIF
 
 
 ;Polar
 IF (NH+SH NE 0) THEN BEGIN
  ;Set map region.
  IF ((NH EQ 1) AND (latmin LT 0)) THEN latmin=0
  IF ((SH EQ 1) AND (latmax GT 0)) THEN latmax=0
  hem=90
  IF (SH EQ 1) THEN hem=-90
  map_centre=(lonmax-ABS(lonmin))/2
  IF ((lonmin GE 0) AND (lonmax GE 0)) THEN map_centre=map_centre+lonmin
  com='MAP_SET, hem, map_centre, LIMIT=[latmin, lonmin, latmax, lonmax], /NOERASE, /NOBORDER'
  IF (ORTHO EQ 0) THEN com=com+',/STEREOGRAPHIC'
  IF (ORTHO EQ 1) THEN com=com+',/ORTHOGRAPHIC'
  res=EXECUTE(com)
 ENDIF

 ;Cylindrical, Robinson and Mollweide.
 IF ((NH+SH EQ 0) AND (SATVIEW EQ 0) AND (NOT KEYWORD_SET(sector))) THEN BEGIN
  map_centre=(lonmax-ABS(lonmin))/2
  IF ((lonmin GE 0) AND (lonmax GE 0)) THEN map_centre=map_centre+lonmin
  com='MAP_SET, 0.0, map_centre, LIMIT=[latmin, lonmin, latmax, lonmax], /NOERASE, /NOBORDER'
  IF KEYWORD_SET(ROBINSON) THEN com=com+', /ROBINSON'
  IF KEYWORD_SET(MOLLWEIDE) THEN com=com+', /MOLLWEIDE'
  IF KEYWORD_SET(LAMBERT) THEN com=com+', /LAMBERT'
  IF KEYWORD_SET(CYLINDRICAL) THEN com=com+', /CYLINDRICAL'
  res=EXECUTE(com)
 ENDIF

 ;Satellite.
 IF (SATVIEW EQ 1) THEN MAP_SET, satellite(1), satellite(0), /SATELLITE, /NOBORDER, /NOERASE

 ;Sector - uses clipping method from ITT-VIS.
 IF KEYWORD_SET(SECTOR)  THEN BEGIN
  IF ((lonmin EQ -180) AND (lonmax EQ 180) AND (latmin EQ -90) AND (latmax EQ 90)) THEN BEGIN
   lonmin=-20
   lonmax=20
   latmin=0
   latmax=80
  ENDIF
  map_centre=(lonmax-ABS(lonmin))/2
  IF ((lonmin GE 0) AND (lonmax GE 0)) THEN map_centre=map_centre+lonmin
  pole=90.0
  IF ((latmin LE 0) AND (latmax LE 0)) THEN pole=-90.0
  MAP_SET, pole, map_centre, LIMIT=[latmin, lonmin, latmax, lonmax], $
          /STEREOGRAPHIC, /NOBORDER, /NOERASE

  ; Clip a map to the left side of the great circle between 2 given points.
  ; Inputs:
  ;Left side
  P1 = [lonmin, latmax] ;of first point (degrees).
  P2 = [lonmin, latmin] ;of 2nd point.
  ;Right side
  P3 = [lonmax, latmin] ;of first point (degrees).
  P4 = [lonmax, latmax] ;of 2nd point.

  ;To radians
  p1r = !dtor * p1                
  p2r = !dtor * p2
  p3r = !dtor * p3
  p4r = !dtor * p4
  ;Convert lon/lat to cartesian 3D coords
  c1 = [ cos(p1r[1]) * cos(p1r[0]), cos(p1r[1]) * sin(p1r[0]), sin(p1r[1])]
  c2 = [ cos(p2r[1]) * cos(p2r[0]), cos(p2r[1]) * sin(p2r[0]), sin(p2r[1])]
  c3 = [ cos(p3r[1]) * cos(p3r[0]), cos(p3r[1]) * sin(p3r[0]), sin(p3r[1])]
  c4 = [ cos(p4r[1]) * cos(p4r[0]), cos(p4r[1]) * sin(p4r[0]), sin(p4r[1])]
  ;Cross product = eqn of plane thru points
  map_clip_set, CLIP_PLANE=[crossp(c1, c2), 0]
  map_clip_set, CLIP_PLANE=[crossp(c3, c4), 0]

  ;Crop excess latitudes.
  MAP_CLIP_SET, CLIP_PLANE= [ 0, 0, 1, -sin(latmin * !DTOR)]
  MAP_CLIP_SET, CLIP_PLANE= [ 0, 0, -1, sin(latmax * !DTOR)] 
 ENDIF



 ;Fill for ocean.
 com='MAP_CONTINENTS'
 IF KEYWORD_SET(HIRES) THEN com=com+', /HIRES'
 IF ((OCEAN GE 0) AND KEYWORD_SET(DRAW)) THEN BEGIN
  FOR ix=0,355 DO BEGIN
  FOR iy=-90,85 DO BEGIN
   xpts=[ix,ix,ix+5, ix+5, ix]
   ypts=[iy, iy+5, iy+5., iy, iy]
   POLYFILL, xpts, ypts, COLOR=ocean
  ENDFOR
  ENDFOR  
  FOR ix=0,355 DO BEGIN
   FOR iy=89.0,89.8, 0.2 DO BEGIN
    xpts=[ix,ix,ix+5, ix+5, ix]
    ypts=[iy, iy+0.2, iy+0.2, iy, iy]
    POLYFILL, xpts, ypts, COLOR=ocean
   ENDFOR
  ENDFOR
  IF (LAND EQ -1) THEN BEGIN
   com2=com+', /FILL_CONTINENTS, COLOR=0'
   res=execute(com2)   
  ENDIF  
 ENDIF
 

 ;Fill for land.
 IF ((LAND NE -1) AND KEYWORD_SET(DRAW)) THEN BEGIN
  com2=com+', /FILL_CONTINENTS, COLOR='+SCROP(land)
  res=execute(com2)  
 ENDIF 

 ;Overlay the continents if needed.
 IF (KEYWORD_SET(DRAW) AND (!guide.cthick GT 0)) THEN BEGIN
  com="MAP_CONTINENTS, MLINETHICK=!guide.cthick, MLINESTYLE=!guide.cstyle, COLOR=!guide.ccolour "
  IF (!guide.hires EQ 1) THEN com=com+', /HIRES'
  IF (!guide.countries EQ 1) THEN com=com+', /CONTINENTS, /COUNTRIES'
  res=EXECUTE(com)
 ENDIF
 
 ;Add lakes if requested. 
 IF (KEYWORD_SET(LAKES) AND KEYWORD_SET(DRAW) AND (!guide.cthick GT 0)) THEN BEGIN
  stateFile = Filepath(Subdirectory=['resource', 'maps', 'shape'], 'lakes.shp')
  shapefile = Obj_New('IDLffShape', stateFile)
  shapefile -> GetProperty, ATTRIBUTE_NAMES=theNames
  theNames = StrUpCase(StrTrim(theNames, 2))
  entities = Ptr_New(/Allocate_Heap)
  *entities = shapefile -> GetEntity(/All, /Attributes)
  attribute_name='ISO'
  attIndex = Where(theNames EQ attribute_name, count)
  FOR j=0,N_Elements(*entities)-1 DO BEGIN
   thisentity=(*entities)[j]
   cuts = [*thisentity.parts, thisentity.n_vertices]
   FOR k=0, thisentity.n_parts-1 DO BEGIN 
    lons=(*thisentity.vertices)[0, cuts[k]:cuts[k+1]-1]
    lats=(*thisentity.vertices)[1, cuts[k]:cuts[k+1]-1]
    GPLOT, X=reform(lons), Y=reform(lats), COL=!guide.ccolour, /CLIP
   ENDFOR
  ENDFOR 
 ENDIF

ENDIF

  
END


