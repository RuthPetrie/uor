FUNCTION SPHERE_DIV, u,v,lons,lats

a = 6.38e6
f = !PI/180

nlons = N_ELEMENTS(lons)
nlats = N_ELEMENTS(lats)

div = FLTARR(nlons,nlats)
FOR j=0,nlats-1 DO div[*,j] = div[*,j] + DERIV(lons,u[*,j])
FOR i=0,nlons-1 DO div[i,*] = div[i,*] + DERIV(lats,v[i,*]*COS(f*lats))
div = div/(a*f*COS(f*(REPLICATE(1,nlons)#lats)))

RETURN, div

END
