;===================================================================================================
FUNCTION GET_LAT_START, latin, lats
;===================================================================================================
; longin is the longitude point to convert to an index

lat_start =0  
i = 0
WHILE (lat_start EQ 0) DO BEGIN 
  IF (lats(i) GT latin) THEN lat_start  = i
  i = i+1
ENDWHILE

RETURN, lat_start 
END
;===================================================================================================


