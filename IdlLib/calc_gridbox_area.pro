PRO calc_gridbox_area

;*************************************************
; Program to calculate the area of a grid box
; and output areas as a file
;
; R. Petrie
; 14 November 2012
;
;*************************************************

file = '/export/quince/data-06/wx019276/hadisst/ice/hadisst_seaice.nc'

d = NCREAD(file)

nx = N_ELEMENTS(d.longitude)
ny = N_ELEMENTS(d.latitude)
lats = FLTARR(nx)
lons = FLTARR(ny)
lons = d.longitude
lats = d.latitude

area = FLTARR(nx,ny)

FOR x=0, nx-1 DO BEGIN
  FOR y=0, ny-1 DO BEGIN
    
    lat1 = lats(y)
    IF y EQ ny-1 THEN lat2=-90 ELSE lat2 = lats(y+1)
    lon1 = lons(x)
    IF x EQ nx-1 THEN lon2 = 180 ELSE lon2 = lons(x+1)
    area(x,y) = CALC_GRID_AREA(lat1, lat2, lon1, lon2)
  
  ENDFOR
ENDFOR

; WRITE TO FILE 
;--------------

areafile = '/export/quince/data-06/wx019276/hadisst/ice/hadisst_grid_area.nc'
strvarid = 'grid_box_area'
strunits = 'km**2'

; open netcdf file
fid = NCDF_CREATE(areafile, /CLOBBER)

; Define dimensions and attributes
lonid = NCDF_DIMDEF(fid, 'longitude', nx)
latid = NCDF_DIMDEF(fid, 'latitude', ny)
varid = NCDF_VARDEF(fid, strvarid, [lonid, latid], /FLOAT)
lonvid = NCDF_VARDEF(fid, 'longitude', [lonid], /FLOAT)
latvid = NCDF_VARDEF(fid, 'latitude', [latid], /FLOAT)
NCDF_ATTPUT, fid, varid, 'units', strunits

; finish define mode
NCDF_CONTROL, fid, /ENDEF

;write out the data and close the file
NCDF_VARPUT, fid, lonvid, lons
NCDF_VARPUT, fid, latvid, lats
NCDF_VARPUT, fid, varid, area
NCDF_CLOSE, fid

END
