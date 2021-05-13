PRO ncwex
;Program to show the writing out of data in netCDF format

d=NCREAD('gdata.nc')
e=NCREAD('climatology_t.nc')

;Regrid data to ERA40 grid.
tnew=REGRID(d.temp(*,*,0), d.lon, d.lat, e.lon, e.lat)

;Open the netCDF file.
fid=NCDF_CREATE('era_new.nc', /CLOBBER)

;Define the dimensions and attributes.
lonid=NCDF_DIMDEF(fid, 'longitude', N_ELEMENTS(e.lon))
latid=NCDF_DIMDEF(fid, 'latitude',N_ELEMENTS(e.lat))
tempvid=NCDF_VARDEF(fid, 'temperature', [lonid,latid], /FLOAT)
lonvid=NCDF_VARDEF(fid, 'longitude', [lonid], /FLOAT)
latvid=NCDF_VARDEF(fid, 'latitude', [latid], /FLOAT)
NCDF_ATTPUT, fid, tempvid, 'units', 'Degrees Celsius' 

;Finish define mode.
NCDF_CONTROL, fid, /ENDEF

;Write out the data and close the netCDF file.
NCDF_VARPUT, fid, lonvid, e.lon
NCDF_VARPUT, fid, latvid, e.lat
NCDF_VARPUT, fid, tempvid, tnew
NCDF_CLOSE, fid

END


