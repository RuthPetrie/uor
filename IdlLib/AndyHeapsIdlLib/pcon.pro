FUNCTION PCON, input, TO_MB=to_mb, TO_KM=to_km
;Function to convert pressure to height and vice-versa.
;(C) NCAS 2010

IF ((NOT KEYWORD_SET(TO_KM)) AND (NOT KEYWORD_SET(TO_MB))) THEN BEGIN
 PRINT, ''
 PRINT, 'PCON ERROR - need to specify one of /TO_KM or /TO_MB.'
 PRINT, ''
 STOP
ENDIF

IF KEYWORD_SET(TO_KM) THEN output=7.0*(ALOG(1000.)-ALOG(input))
IF KEYWORD_SET(TO_MB) THEN output=EXP(-1.0*(input/7.0-ALOG(1000.0)))
RETURN, output

END
