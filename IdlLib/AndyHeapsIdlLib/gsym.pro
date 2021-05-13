FUNCTION GSYM, sym, FILL=fill
;Function to set a symbol for plotting.
;(C) NCAS 2010

IF ((sym LT 0) OR (sym GT 20)) THEN BEGIN
 PRINT, ''
 PRINT, 'SYM ERROR - ', sym, ' not in range 0-20'
 PRINT, ''
 STOP
ENDIF

A = FINDGEN(33) * (!PI*2/32.) 
delta=0.2
delta2=0.22
cross_xpts=[-delta, -delta, -1, -1, -delta, -delta, delta, delta, 1, 1, delta, delta,-delta]
cross_ypts=[-1, -delta, -delta, delta, delta, 1, 1, delta, delta, -delta, -delta, -1, -1]
cross2_xpts=[-1+delta, -1, -delta2, -1, -1+delta, 0, 1-delta, 1, delta2, 1, 1-delta, 0, -1+delta]
cross2_ypts=[-1, -1+delta, 0, 1-delta, 1, delta2, 1, 1-delta, 0, -1+delta, -1, -delta2, -1]
star_xpts=[-1+delta2, -delta2*1.5, -1, -delta2, 0, delta2,  1, delta2*1.5, 1-delta2, 0, -1+delta2]
star_ypts=[-1, -delta2, delta2, delta2, 1, delta2, delta2, -delta2, -1, -2*delta2, -1]

IF (sym EQ 0) THEN pts='[0,0], [0,0]'  
IF (sym EQ 1) THEN pts='[-1, -1, 1, 1, -1], [-1, 1, 1, -1,-1], /FILL'  
IF (sym EQ 2) THEN pts='[-1, 0, 1, 0, -1], [0, 1, 0, -1, 0], /FILL'  
IF (sym EQ 3) THEN pts='COS(A), SIN(A), /FILL'
IF (sym EQ 4) THEN pts='[-1, 0, 1, -1], [-1, 1, -1, -1], /FILL'  
IF (sym EQ 5) THEN pts='cross_xpts, cross_ypts, /FILL'
IF (sym EQ 6) THEN pts='cross2_xpts, cross2_ypts, /FILL'
IF (sym EQ 7) THEN pts='star_xpts, star_ypts, /FILL'
IF (sym EQ 8) THEN pts='[-1, 1, 0, -1], [1, 1, -1, 1], /FILL'  
IF (sym EQ 9) THEN pts='[-1, 1, 1, -1], [0, 1, -1, 0], /FILL'   
IF (sym EQ 10) THEN pts='[-1, 1, -1, -1], [1, 0, -1, 1], /FILL'   
IF (sym EQ 11) THEN pts='[-1, -1, 1, 1, -1], [-1, 1, 1, -1,-1]'  
IF (sym EQ 12) THEN pts='[-1, 0, 1, 0, -1], [0, 1, 0, -1, 0]'  
IF (sym EQ 13) THEN pts='COS(A), SIN(A)'
IF (sym EQ 14) THEN pts='[-1, 0, 1, -1], [-1, 1, -1, -1]' 
IF (sym EQ 15) THEN pts='cross_xpts, cross_ypts'
IF (sym EQ 16) THEN pts='cross2_xpts, cross2_ypts'
IF (sym EQ 17) THEN pts='star_xpts, star_ypts'
IF (sym EQ 18) THEN pts='[-1, 1, 0, -1], [1, 1, -1, 1]'  
IF (sym EQ 19) THEN pts='[-1, 1, 1, -1], [0, 1, -1, 0]'   
IF (sym EQ 20) THEN pts='[-1, 1, -1, -1], [1, 0, -1, 1]'   

com='USERSYM, '+pts
RES=EXECUTE(com)
RETURN, 8

END

