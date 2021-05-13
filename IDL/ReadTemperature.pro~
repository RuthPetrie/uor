PRO ReadTemperature

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Program to read in ERA-Interim Temperature data
; and output a single netcdf file with the monthly 
; Temperature data.
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

temp = fltarr(512,256,ntimes) ;[lon,lat,mth]
longitude = fltarr(512)
latitude = fltarr(256)

fileloc = '/net/rossby/export/rossby/raid/era-in/netc/monthly_means/'
t=0
FOR year = startyear, endyear DO BEGIN
  stryear = STRTRIM(STRING(year),2)
  FOR month = 01,12 DO BEGIN
    strmth = STRTRIM(STRING(month,FORMAT='(I02)'),2) 
    file = fileloc+stryear+'/ggas'+stryear+strmth+'.nc'
    d = NCREAD(file)
    temp(*,*,t) = d.T2(*,*)
    t = t+1
  ENDFOR
ENDFOR

longitude = d.longitude
latitude = d.latitude


;============================================================================
; Write data to file
print, 'WRITE TEMPERATURE TO A NETCDF FILE'

; open netcdf file
datafile = '/home/wx019276/IDL/era_temp2.nc'
fid = NCDF_CREATE(datafile, /CLOBBER)

; Define dimensions and attributes
lonid = NCDF_DIMDEF(fid, 'longitude', N_ELEMENTS(longitude))
latid = NCDF_DIMDEF(fid, 'latitude', N_ELEMENTS(latitude))
timeid = NCDF_DIMDEF(fid, 't', N_ELEMENTS(times))
tempvid = NCDF_VARDEF(fid, 'temp', [lonid, latid, timeid], /FLOAT)
lonvid = NCDF_VARDEF(fid, 'longitude', [lonid], /FLOAT)
latvid = NCDF_VARDEF(fid, 'latitude', [latid], /FLOAT)
timevid = NCDF_VARDEF(fid, 't', [timeid], /FLOAT)
NCDF_ATTPUT, fid, tempvid, 'units', 'K'

; finish define mode
NCDF_CONTROL, fid, /ENDEF

;write out the data and close the file
NCDF_VARPUT, fid, lonvid, longitude
NCDF_VARPUT, fid, latvid, latitude
NCDF_VARPUT, fid, timevid, times
NCDF_VARPUT, fid, tempvid, temp
NCDF_CLOSE, fid
;============================================================================
spawn, 'xconv /home/wx019276/IDL/era_temp.nc &'
END   
