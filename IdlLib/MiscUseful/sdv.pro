FUNCTION SDV, array,dimension, NAN=nan,DOUBLE=double

; An adapted version of avg.pro which returns the standard deviation
; of an array, or an array holding the standard deviations along a
; given dimension of the array.

 s = SIZE(array,/STRUCTURE)
 IF s.n_elements EQ 0 THEN $
        MESSAGE, 'Variable must be an array, name= ARRAY'

    IF N_PARAMS() EQ 1 THEN BEGIN
        IF KEYWORD_SET(nan) THEN npts = TOTAL(FINITE(array)) $
                            ELSE npts = N_ELEMENTS(array)
        IF npts EQ 0 OR npts EQ 1 THEN std = !VALUES.D_NAN $
                      ELSE BEGIN sum1 = TOTAL(array^2,NAN=nan,/DOUBLE)
                                 sum2 = TOTAL(array,NAN=nan,/DOUBLE)^2
                                 std = SQRT((sum1-sum2/npts)/(npts-1)) & ENDELSE
    ENDIF ELSE BEGIN
        IF ((dimension GE 0) AND (dimension LT s.n_dimensions)) THEN BEGIN
                                 sum1 = TOTAL(array^2,dimension+1,NAN=nan,/DOUBLE)
                                 sum2 = TOTAL(array,dimension+1,NAN=nan,/DOUBLE)^2
                
; Install a bug workaround since TOTAL(A,/NAN) returns 0 rather than NAN if 
; all A values are NAN. 
                IF KEYWORD_SET(nan) THEN BEGIN
                     npts = TOTAL(FINITE(array),dimension+1) 
                     bad = WHERE(npts EQ 0 OR npts EQ 1,nbad)
                     std = SQRT((sum1-sum2/(npts>1))/(npts>2-1))
                     IF nbad GT 0 THEN std[bad] = !VALUES.D_NAN
                 ENDIF ELSE BEGIN
                     npts = s.dimensions[dimension]
                     IF npts EQ 0 OR npts EQ 1 THEN std = sum1*!VALUES.D_NAN $
                     ELSE std = SQRT((sum1-sum2/npts)/(npts-1)) & ENDELSE
        END ELSE $
                MESSAGE,'*** Dimension out of range, name= ARRAY'
    ENDELSE

; Convert to floating point unless of type double, complex, or L64, or
; if /DOUBLE is set.

 IF NOT KEYWORD_SET(double) THEN BEGIN 
    CASE s.type OF
     5: RETURN, std
     6: RETURN, COMPLEXARR(FLOAT(std),FLOAT(IMAGINARY(std)) )
     9: RETURN, std
    14: RETURN, std
    15: RETURN, std
    ELSE: RETURN, FLOAT(std)
  ENDCASE
  ENDIF ELSE RETURN, std
 END
