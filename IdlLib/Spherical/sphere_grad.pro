FUNCTION SPHERE_GRAD, fn,lons,lats

a = 6.38e6
f = !PI/180

nlons = N_ELEMENTS(lons)
nlats = N_ELEMENTS(lats)

grad = FLTARR(nlons,nlats,2)
FOR j=0,nlats-1 DO grad[*,j,0] = DERIV(lons,fn[*,j])/COS(f*lats[j])
FOR i=0,nlons-1 DO grad[i,*,1] = DERIV(lats,fn[i,*])
grad = grad/(a*f)

RETURN, grad

END
