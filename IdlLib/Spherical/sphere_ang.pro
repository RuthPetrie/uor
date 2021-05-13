; Returns the great-circle distance in degrees between two [lon,lat]
; points

FUNCTION SPHERE_ANG, lon1,lat1,lon2,lat2

f = !PI/180

; There is sometimes a problem if two identical positions are entered,
; as ACOS returns NaN if the roundoff error falls the wrong side of 1.

; Correction: set all NaNs to equal 0.

sphang = ACOS(SIN(lat1*f)*SIN(lat2*f)+COS(lat1*f)*COS(lat2*f)*COS((lon2-lon1)*f))/f
nanlocs = WHERE(FINITE(sphang,/NAN))
IF MAX(nanlocs) NE -1 THEN sphang[nanlocs] = 0. 

RETURN, sphang

END
