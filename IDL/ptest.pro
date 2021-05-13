PRO PTEST, XVALS=xvals
;Program to show parameter passing.

IF (N_ELEMENTS(xvals) GT 0) THEN BEGIN
 PRINT, 'XVALS are ', xvals
 HELP, XVALS
ENDIF
IF (N_ELEMENTS(xvals) EQ 0) THEN PRINT, 'XVALS are unset'

END

