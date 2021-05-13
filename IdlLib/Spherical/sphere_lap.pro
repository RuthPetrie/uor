FUNCTION SPHERE_LAP, fn,lons,lats

a = 6.38e6
f = !PI/180

nlons = N_ELEMENTS(lons)
nlats = N_ELEMENTS(lats)

lap = FLTARR(nlons,nlats)
FOR j=0,nlats-1 DO lap[*,j] = lap[*,j] + DERIV(lons,DERIV(lons,fn[*,j]))
FOR i=0,nlons-1 DO lap[i,*] = lap[i,*] + DERIV(lats,DERIV(lats,fn[i,*])*COS(f*lats))*COS(f*lats)
lap = lap/(a*f*COS(f*(REPLICATE(1,nlons)#lats)))^2

RETURN, lap

END
