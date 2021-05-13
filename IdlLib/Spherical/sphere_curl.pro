FUNCTION SPHERE_CURL, u,v,lons,lats

a = 6.38e6
f = !PI/180

nlons = N_ELEMENTS(lons)
nlats = N_ELEMENTS(lats)

curl = FLTARR(nlons,nlats)
FOR j=0,nlats-1 DO curl[*,j] = curl[*,j] + DERIV(lons,v[*,j])
FOR i=0,nlons-1 DO curl[i,*] = curl[i,*] - DERIV(lats,u[i,*]*COS(f*lats))
curl = curl/(a*f*COS(f*(REPLICATE(1,nlons)#lats)))

RETURN, curl

END
