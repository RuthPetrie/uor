
;===================================================================================================
FUNCTION YCOORDS_FOR_AOI, long_min, long_max, lat_min, lat_max
;===================================================================================================
; Create array to draw section on plot
;lmx = INTARR(1)
;IF long_min GT long_max THEN lmx = long_max & long_max = long_min & long_min = lmx

long_length = long_max-long_min
ytemp = INTARR(long_length) + lat_min
ytemp2 = INTARR(long_length) +lat_max
ycoords = [lat_max, ytemp, ytemp2]


RETURN, ycoords
END
;===================================================================================================

