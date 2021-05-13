PRO Read500Geopotential

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Program to read in ERA-Interim 500 hPa Geopotential data
; and out put a single netcdf file with the monthly 
; 500 hPa geopotential data.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Declare arrays
startyear = 1979
endyear = 2011
ntimes = (endyear - startyear+1)*12
print, ntimes

times = INTARR(ntimes)
FOR t = 0, ntimes-1 DO BEGIN
 times(t) = t
ENDFOR

geopt = fltarr(512,256,ntimes) ;[lon,lat,mth]
longitude = fltarr(512)
latitude = fltarr(256)

fileloc = '/net/rossby/export/rossby/raid/era-in/netc/monthly_means/'
t=0
FOR year = startyear, endyear DO BEGIN
  stryear = STRTRIM(STRING(year),2)
  FOR month = 01,12 DO BEGIN
    strmth = STRTRIM(STRING(month,FORMAT='(I02)'),2) 
    file = fileloc+stryear+'/ggap'+stryear+strmth+'.nc'
    d = NCREAD(file)
    geopt(*,*,t) = d.Z(*,*,15)
    t = t+1
  ENDFOR
ENDFOR

longitude = d.longitude
latitude = d.latitude


;============================================================================
; Write data to file
print, 'WRITE MSLP TO A NETCDF FILE'

; open netcdf file
datafile = '/home/wx019276/IDL/era_500_geopotential.nc'
fid = NCDF_CREATE(datafile, /CLOBBER)

; Define dimensions and attributes
lonid = NCDF_DIMDEF(fid, 'longitude', N_ELEMENTS(longitude))
latid = NCDF_DIMDEF(fid, 'latitude', N_ELEMENTS(latitude))
timeid = NCDF_DIMDEF(fid, 't', N_ELEMENTS(times))
geoptvid = NCDF_VARDEF(fid, 'Z', [lonid, latid, timeid], /FLOAT)
lonvid = NCDF_VARDEF(fid, 'longitude', [lonid], /FLOAT)
latvid = NCDF_VARDEF(fid, 'latitude', [latid], /FLOAT)
timevid = NCDF_VARDEF(fid, 't', [timeid], /FLOAT)
NCDF_ATTPUT, fid, geoptvid, 'units', 'm**2 s**-2'

; finish define mode
NCDF_CONTROL, fid, /ENDEF

;write out the data and close the file
NCDF_VARPUT, fid, lonvid, longitude
NCDF_VARPUT, fid, latvid, latitude
NCDF_VARPUT, fid, timevid, times
NCDF_VARPUT, fid, geoptvid, geopt
NCDF_CLOSE, fid
;============================================================================
spawn, 'xconv /home/wx019276/IDL/era_500_geopotential.nc &'
END   
