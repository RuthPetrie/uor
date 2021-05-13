;===================================================================================================
FUNCTION GET_LONG_START, longin, longs
;===================================================================================================
; Function converts longin a longitude to a grid index, longs is the array of longitude points
;
; R. Petrie
; April 2013

long_start =0  
i = 0
WHILE (long_start EQ 0) DO BEGIN 
  IF (longs(i) GT longin) THEN long_start  = i
  i = i+1
ENDWHILE

RETURN, long_start 
END
;===================================================================================================

