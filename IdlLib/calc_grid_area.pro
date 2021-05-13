FUNCTION CALC_GRID_AREA, lat1, lat2, long1, long2

;*************************************************
; Function to calculate the area of a grid box
; given the lats and longs
;
; R. Petrie
; 14 November 2012
;
;*************************************************

; Define constant
;-----------------
R = 6371
pi = 3.1415927
C = pi * R * R /180
;PRINT, 'C', C

; Convert lats to radians, since sin function in idl work in radians
;---------------------------------------------------------------------
lat1r = lat1 * pi /180
lat2r = lat2 * pi /180

; Calculate sin of lats 
;----------------------
sinlats = ABS(SIN(lat1r) - SIN(lat2r))
;PRINT, 'sinlats', sinlats

; Calculate area
;----------------------
area = C * sinlats * ABS(long1 - long2)
;PRINT, 'area',area

RETURN,  area ;Area returned in km sq

END
