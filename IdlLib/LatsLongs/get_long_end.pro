;===================================================================================================
FUNCTION GET_LONG_END, longin, longs
;===================================================================================================
; Function converts longin a longitude to a grid index, longs is the array of longitude points
;
; R. Petrie
; April 2013

long_end = 0  
i = 0
WHILE (long_end EQ 0) DO BEGIN 
  IF (longs(i) GT longin) THEN long_end = i
  i = i+1
ENDWHILE

RETURN, long_end
END
;===================================================================================================

