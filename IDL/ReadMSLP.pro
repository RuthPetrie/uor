PRO ReadMSLP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Program to read in ERA-Interim MSLP data
; and out put a single netcdf file with the monthly 
; MSLP data.
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

mslp = fltarr(512,256,ntimes) ;[lon,lat,mth]
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
    mslp(*,*,t) = d.MSL(*,*)
    t = t+1
  ENDFOR
ENDFOR

longitude = d.longitude
latitude = d.latitude


;============================================================================
; Write data to file
print, 'WRITE MSLP TO A NETCDF FILE'

; open netcdf file
datafile = '/home/wx019276/IDL/era_mslp.nc'
fid = NCDF_CREATE(datafile, /CLOBBER)

; Define dimensions and attributes
lonid = NCDF_DIMDEF(fid, 'longitude', N_ELEMENTS(longitude))
latid = NCDF_DIMDEF(fid, 'latitude', N_ELEMENTS(latitude))
timeid = NCDF_DIMDEF(fid, 't', N_ELEMENTS(times))
mslpvid = NCDF_VARDEF(fid, 'mslp', [lonid, latid, timeid], /FLOAT)
lonvid = NCDF_VARDEF(fid, 'longitude', [lonid], /FLOAT)
latvid = NCDF_VARDEF(fid, 'latitude', [latid], /FLOAT)
timevid = NCDF_VARDEF(fid, 't', [timeid], /FLOAT)
NCDF_ATTPUT, fid, mslpvid, 'units', 'Pa'

; finish define mode
NCDF_CONTROL, fid, /ENDEF

;write out the data and close the file
NCDF_VARPUT, fid, lonvid, longitude
NCDF_VARPUT, fid, latvid, latitude
NCDF_VARPUT, fid, timevid, times
NCDF_VARPUT, fid, mslpvid, mslp
NCDF_CLOSE, fid
;============================================================================
spawn, 'xconv /home/wx019276/IDL/era_mslp.nc &'
END   
