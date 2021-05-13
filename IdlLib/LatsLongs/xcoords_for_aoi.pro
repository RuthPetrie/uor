
;===================================================================================================
FUNCTION XCOORDS_FOR_AOI, long_min, long_max
;===================================================================================================
; Create array to draw section on plot

;lmx = INTARR(1)
;IF long_min GT long_max THEN lmx = long_max & long_max = long_min & long_min = lmx
long_length = long_max-long_min
xtmp = INDGEN(long_length) + long_min
xtmp2 = INDGEN(long_length)*(-1) + long_max
xcoords = [long_min, xtmp, xtmp2]

RETURN, xcoords
END
;===================================================================================================

