;===================================================================================================
FUNCTION GET_LAT_END_ERA, latin, lats
;===================================================================================================
; longin is the longitude point to convert to an index

lat_end = 0  
i = 0
WHILE (lat_end EQ 0) DO BEGIN 
  IF (lats(i) LT latin) THEN lat_end = i
  i = i+1
ENDWHILE

RETURN, lat_end
END
;===================================================================================================

