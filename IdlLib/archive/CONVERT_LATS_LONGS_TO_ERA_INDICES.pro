;
;  .compile CONVERT_LATS_LONGS_TO_ERA_INDICES
;
;===================================================================================================
FUNCTION GET_LONG_START, longin
;===================================================================================================
@common_variables
; longin is the longitude point to convert to an index

long_start =0  
i = 0
WHILE (long_start EQ 0) DO BEGIN 
  IF (erai_longs(i) GT longin) THEN long_start  = i
  i = i+1
ENDWHILE

RETURN, long_start 
END
;===================================================================================================


;===================================================================================================
FUNCTION GET_LONG_END, longin
;===================================================================================================

@common_variables
; longin is the longitude point to convert to an index

long_end = 0  
i = 0
WHILE (long_end EQ 0) DO BEGIN 
  IF (erai_longs(i) GT longin) THEN long_end = i
  i = i+1
ENDWHILE

RETURN, long_end
END
;===================================================================================================

;===================================================================================================
FUNCTION GET_LAT_START, latin
;===================================================================================================

@common_variables
; longin is the longitude point to convert to an index

lat_start =0  
i = 0
WHILE (lat_start EQ 0) DO BEGIN 
  IF (erai_lats(i) LT latin) THEN lat_start  = i
  i = i+1
ENDWHILE

RETURN, lat_start 
END
;===================================================================================================

;===================================================================================================
FUNCTION GET_LAT_END, latin
;===================================================================================================

@common_variables
; longin is the longitude point to convert to an index

lat_end = 0  
i = 0
WHILE (lat_end EQ 0) DO BEGIN 
  IF (erai_lats(i) LT latin) THEN lat_end = i
  i = i+1
ENDWHILE

RETURN, lat_end
END
;===================================================================================================

;===================================================================================================
FUNCTION XCOORDS_FOR_AOI, long_min, long_max
;===================================================================================================

; Create array to draw section on plot
long_length = long_max-long_min
xtmp = INDGEN(long_length) + long_min
xtmp2 = INDGEN(long_length)*(-1) + long_max
xcoords = [long_min, xtmp, xtmp2]

RETURN, xcoords
END
;===================================================================================================

;===================================================================================================
FUNCTION YCOORDS_FOR_AOI, lat_min, lat_max, long_min, long_max
;===================================================================================================

; Create array to draw section on plot
long_length = long_max-long_min
ytemp = INTARR(long_length) + lat_min
ytemp2 = INTARR(long_length) +lat_max
ycoords = [lat_max, ytemp, ytemp2]


RETURN, ycoords
END
;===================================================================================================

