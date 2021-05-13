PRO read_row

;Open the file
OPENR, lun, GETENV('GUIDE_DATA')+'/comp.txt', /GET_LUN
mystr=' ' 
READF,lun, mystr  ; read the titles

; set up the internal arrays
mytime=INTARR(121)
temp1=FLTARR(121)
temp2=FLTARR(121)

; read into dummy variables - the right way
FOR i=0,120 DO BEGIN
 READF, lun, val1, val2, val3 
 READF, lun, mytime(i), temp1(i), temp2(i)
 mytime(i)=val1
 temp1(i)=val2
 temp2(i)=val3
ENDFOR
FREE_LUN, lun
PRINT,'The right way'
PRINT,'-------------'
PRINT, 'Read into dummy variables and then placed into the IDL arrays.'
PRINT, 'First two array values are:'
PRINT, mytime(0), temp1(0), temp2(0)
PRINT, mytime(1), temp1(1), temp2(1)

;read directly into the IDL arrays - the wrong way
OPENR, lun, GETENV('GUIDE_DATA')+'/comp.txt', /GET_LUN
mytime=INTARR(121)
temp1=FLTARR(121)
temp2=FLTARR(121)
FOR i=0,120 DO BEGIN
 READF, lun, mytime(i), temp1(i), temp2(i)
ENDFOR
FREE_LUN, lun
PRINT, ' '
PRINT, ' '
PRINT,'The wrong way'
PRINT,'-------------'
PRINT, 'Read directly into the IDL arrays - the wrong way'
PRINT, 'First two array values are:'
PRINT, mytime(0), temp1(0), temp2(0)
PRINT, mytime(1), temp1(1), temp2(1)

END

