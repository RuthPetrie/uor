PRO show_where_use
;Show the use of WHERE to speed up array computations

ix=10000
iy=10000
b=INTARR(ix,iy)
c=INTARR(ix,iy)
d=INTARR(ix,iy)


;Make a random set of numbers
PRINT, 'Making an array of random numbers ', ix, ' * ', iy
seed=5L
a=RANDOMN(seed, ix,iy)
PRINT, 'maximum/minimum of array is ', MAX(a), MIN(a)
PRINT, ''

;First method using x, y loops
sec=SYSTIME(/SECONDS)
FOR i=0,ix-1 DO BEGIN
 FOR j=0,iy-1 DO BEGIN
  IF a(i,j) GT 0 THEN b(i,j)=1
 ENDFOR
ENDFOR

sec2=SYSTIME(/SECONDS)
PRINT, 'Using x, y loops the time taken is ', sec2-sec, ' seconds'
PRINT,''

;Second method using y, x loops
sec=SYSTIME(/SECONDS)
FOR j=0,iy-1 DO BEGIN
 FOR i=0,ix-1 DO BEGIN
  IF a(i,j) GT 0 THEN c(i,j)=1
 ENDFOR
ENDFOR

sec2=SYSTIME(/SECONDS)
PRINT, 'Using y, x loops the time taken is ', sec2-sec, ' seconds'
PRINT,''

;Third method using where
sec=SYSTIME(/SECONDS)
land=WHERE(a GT 0)
d(land)=1
sec2=SYSTIME(/SECONDS)
PRINT, 'Using where time taken is ', sec2-sec, ' seconds'

;Count number of times where array is ne 0 and display
index=WHERE(c-b NE 0, count)
index2=WHERE(d-c NE 0, count2)

print, ''
IF (count+count EQ 0) THEN PRINT, 'The results of the three methods are the same'
IF (count+count NE 0) THEN PRINT, 'The results of the three methods differ'

END

