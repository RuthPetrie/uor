FUNCTION BSTRAP, values,dim,NBOOT=nboot,CONFLIMIT=conflimit,NAN=nan,SILENT=silent

; Get array size and set defaults
s = SIZE(values)
n = s[dim+1]
IF N_ELEMENTS(nboot) EQ 0 THEN nboot=1000
IF N_ELEMENTS(conflimit) EQ 0 THEN conflimit=0.68
lowindex = LONG(((1.0-conflimit)/2)*nboot)
highindex = nboot-lowindex-1

; Print banner
IF N_ELEMENTS(silent) NE 1 THEN BEGIN
   PRINT, ''
   PRINT, 'Calling BSTRAP'
   PRINT, '--------------'
   PRINT, '   Dimension size: '+STRTRIM(n,2)
   PRINT, '   Taking '+STRTRIM(nboot,2)+' random samples'
   PRINT, '   Confidence interval limit: '+STRING(conflimit,FORMAT='(F4.2)')
ENDIF

; Create the array bootvalues with the same dimensions as values
; except that the size of dimension dim is set to nboot, and the array
; retvals with the same dimensions as values except that the size of
; dimension dim is set to 3.
a1='' & a2='' & c1='' & c2=''
IF dim GT 0 THEN BEGIN
   a1 = STRING(STRTRIM(s[1:dim],2)+',',FORMAT='('+STRING(dim)+'A)')
   c1 = STRING(REPLICATE('*,',dim),FORMAT='('+STRING(dim)+'A)')
ENDIF
IF dim LT s[0]-1 THEN BEGIN
   a2 = STRING(','+STRTRIM(s[dim+2:s[0]],2),FORMAT='('+STRING(s[0]-1-dim)+'A)')
   c2 = STRING(REPLICATE(',*',s[0]-1-dim),FORMAT='('+STRING(s[0]-1-dim)+'A)')
ENDIF
IF EXECUTE('bootvals=FLTARR('+a1+'nboot'+a2+')') NE 1 THEN STOP
IF EXECUTE('retvals=FLTARR('+a1+'3'+a2+')') NE 1 THEN STOP

; Get the samples and calculate their means
mix = FLOOR(RANDOMU(seed,nboot,n)*n)
FOR i=0,nboot-1 DO $
   IF EXECUTE('bootvals['+c1+'i'+c2+'] = AVG(values['+c1+'mix[i,*]'+c2+'],dim,NAN=nan)') NE 1 THEN STOP

; Sort the sample means and find the indices of the upper and lower
; confidence ranges
bsort = SORT_ND(bootvals,dim+1)

; Assign the relevant values to the array retvals
IF EXECUTE('retvals['+c1+'0'+c2+']=AVG(values,dim,NAN=nan)') NE 1 THEN STOP
IF EXECUTE('retvals['+c1+'1'+c2+']=bootvals[bsort['+c1+'lowindex'+c2+']]') NE 1 THEN STOP
IF EXECUTE('retvals['+c1+'2'+c2+']=bootvals[bsort['+c1+'highindex'+c2+']]') NE 1 THEN STOP

RETURN, retvals

END 
