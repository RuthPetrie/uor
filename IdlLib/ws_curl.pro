FUNCTION WS_CURL, tx_file, ty_file, ice_ocean_flag

; INPUT VARIABLES

; 1: TAUX filename
; 2: TAUY filename
; 3: ice or ocean grid

print, tx_file, ice_ocean_flag

IF ice_ocean_flag EQ 'ice' THEN BEGIN
  taux=NCREAD(tx_file, VARS=['strocnx'])
  tx=taux.strocnx(*,*,0)
  tauy=NCREAD(ty_file, VARS=['strocny'])
  ty=tauy.strocny(*,*,0)
  
  lon=NCREAD('/net/quince/export/quince/data-05/wx019276/COUPLED_EXPTS/ice_lons.nc')
  lons=lon.TLON(*,*,0)
  nx=N_ELEMENTS(lons(*,0))

  lat=NCREAD('/net/quince/export/quince/data-05/wx019276/COUPLED_EXPTS/ice_lats.nc')
  lats=lat.TLAT(*,*,0)
  ny=N_ELEMENTS(REFORM(lats(0,*)))

ENDIF ELSE BEGIN

  taux=NCREAD(tx_file, VARS=['sozotaux'])
  tx=taux.sozotaux(*,*,0)
  tauy=NCREAD(ty_file, VARS=['sometauy'])
  ty=tauy.sometauy(*,*,0)

  lon=NCREAD('/net/elm/export/elm/data-06/wx019276/PABLO/windstress-curl/longitudes.nc')
  lons=lon.NAV_LON
  nx=N_ELEMENTS(lons(*,0))

  lat=NCREAD('/net/elm/export/elm/data-06/wx019276/PABLO/windstress-curl/latitudes.nc')
  lats=lat.NAV_LAT
  ny=N_ELEMENTS(REFORM(lats(0,*)))

ENDELSE

;------------------------
; CLEAR SPACE
DELVAR, taux,tauy,lon,lat
;------------------------

; Constants
londeg=2*3.141592*6371*1000*cos(lats*2*3.141592/360)/360
latdeg=2*3.141592*6371*1000/360

; Arrays
dtydx = FLTARR(nx,ny)
dtxdy = FLTARR(nx,ny)

; Calculate Derivatives
PRINT, 'CALCULATING WINDSTRESS CURL'
FOR i=1,nx-2 DO BEGIN
  FOR j=0,ny-1 DO BEGIN
    dtydx(i,j)=(ty(i+1,j)-ty(i-1,j))/( (lons(i+1,j)-lons(i-1,j))*londeg(i,j) )
  ENDFOR
ENDFOR

FOR i=0,nx-1 DO BEGIN
  FOR j=1,ny-2 DO BEGIN
    dtxdy(i,j)=( tx(i,j+1)-tx(i,j-1) )/( (lats(i,j+1)-lats(i,j-1))*latdeg )
  ENDFOR
ENDFOR

;print, size(dtydx), size(dtxdy) 

wscurl=(dtydx-dtxdy)*1e6

RETURN, wscurl

END

