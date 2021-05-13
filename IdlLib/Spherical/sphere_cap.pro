; Returns the indices of all gridpoints within a spherical cap of
; width degrees around centre=[clon,clat]
; Optional weights variable is set to the area of each grid cell
; centred on clon,clat

; NOTE: only works for a uniform grid

FUNCTION SPHERE_CAP, lons,lats,clon,clat,width,weights

nlons = N_ELEMENTS(lons)
nlats = N_ELEMENTS(lats)
lon_array = FLTARR(nlons,nlats)
lat_array = FLTARR(nlons,nlats)

FOR i=0,nlons-1 DO BEGIN
    lon_array(i,*) = lons(i)
    lat_array(i,*) = lats
ENDFOR

locs = WHERE(SPHERE_ANG(lon_array,lat_array,clon,clat) LE WIDTH)

f = !PI/180
dlon = lons(1)-lons(0)
dlat = lats(1)-lats(0)
weights = cos(lat_array[locs]*f)-sin(lat_array[locs]*f)
weights = weights/TOTAL(weights)

RETURN, locs

END
