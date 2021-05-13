;===================================================================================================
FUNCTION GET_LAT_END, latin, lats
;===================================================================================================
; longin is the longitude point to convert to an index
IF latin GT lats(N_ELEMENTS(lats)-1) THEN lat_end=N_ELEMENTS(lats)-1 ELSE BEGIN
  lat_end = 0  
  i = 0
  WHILE (lat_end EQ 0) DO BEGIN 
    IF (lats(i) GT latin) THEN lat_end = i
    i = i+1
  ENDWHILE
ENDELSE

RETURN, lat_end
END
;===================================================================================================


