PRO UTF2NC, UTF=utf, FILE=file, LEVS=levs, THETAS=thetas, LONS=lons, QUIET=quiet
;Procedure to convert a UTF 1.4 file to netCDF.
;(C) NCAS 2010

COMPILE_OPT  DEFINT32 ;Use longword integers.

;You may need to change levs, thetas and lons if your UTF has a different grid.

;These are the levels in the UTF field headers.
IF (N_ELEMENTS(levs) EQ 0 ) THEN levs=[18.5, 59.6, 105.7, 152.0, 196.8, 240.7, 286.5, 338.2,$
      400.2, 476.5, 568.7, 674.0, 784.4, 887.1, 967.3]

;These are the theta levels in the UTF.
IF (N_ELEMENTS(thetas) EQ 0 ) THEN thetas=[350, 330]

;Define longitudes as the ones in the UTF header are truncated.
IF (N_ELEMENTS(lons) EQ 0 ) THEN lons=FINDGEN(128)*2.8125


;You shouldn't need to alter anything below this line.
;-----------------------------------------------------


;Check inputs are supplied.
IF (N_ELEMENTS(utf) EQ 0) THEN BEGIN
 PRINT, ''
 PRINT, 'UTF2NC ERROR - Need to specify the UTF file with UTF=utf'
 PRINT, ''
 STOP
ENDIF
IF (N_ELEMENTS(FILE) EQ 0) THEN BEGIN
 PRINT, ''
 PRINT, 'UTF2NC ERROR - Need to specify the output file name  with FILE=file'
 PRINT, ''
 STOP
ENDIF



;Define global and field header strings for reading data.
ghead1='' ;global header no 1.
ghead2='' ;global header no 2.
ghead3='' ;global header no 3.
ghead4='' ;global header no 4.
ghead5='' ;global header no 5.
fhead1='' ;field header no 1.
fhead2='' ;field header no 2.
fhead3='' ;field header no 3.
fhead4='' ;field header no 4.

head1=INTARR(15)

OPENR, 1, utf
READF, 1, ghead1
READF, 1, head1
lons_orig=FLTARR(head1(0))
lats=FLTARR(head1(1)*head1(3))
levs_orig=FLTARR(head1(2))
READF, 1, lons_orig
READF, 1, lats
READF, 1, levs_orig
READF, 1, ghead2
READF, 1, ghead3
READF, 1, ghead4
READF, 1, ghead5

;Replace longitudes if necessary as the ones in the UTF header are truncated.
IF (N_ELEMENTS(lons_orig) NE 128) THEN lons=lons_orig 

res=STRSPLIT(ghead2, /EXTRACT)
days=FINDGEN(FLOAT(res(1))-FLOAT(res(0))+1)

svals=0 ;Number of variables in the new data structure.


;Read in fields.
READF, 1, fhead1
WHILE (fhead1 NE '***END OF DATA***        ***UTF 1.4***            $') DO BEGIN
 READF, 1, fhead2
 READF, 1, fhead3
 READF, 1, fhead4
 res1=STRSPLIT(fhead1, /EXTRACT)
 res2=STRSPLIT(fhead2, /EXTRACT)
 res3=STRSPLIT(fhead3, /EXTRACT)
 res4=STRSPLIT(fhead4, /EXTRACT)
 ppos=(WHERE('PRESS=' EQ res1))(0)
 epos=(WHERE('ETA=' EQ res1))(0)
 IF (epos GT 0) THEN ppos=epos
 thetapos=WHERE(STRMATCH(res1, 'THETA=*') EQ 1)
 IF (thetapos GT 0) THEN ppos=thetapos(0)-1
 avpos=(WHERE('AVERAGE' EQ res2))(0)
 textpos=ppos
 dpos=N_ELEMENTS(res1)-1
 xpts=FIX(res3(0))
 ypts=FIX(res3(1))
 fmin=FLOAT(res4(0))
 fmax=FLOAT(res4(1))
 fcont=FLOAT(res4(2))
 ptype=FIX(res3(2))
 unitsstr=res1(ppos+2:dpos-1)
 dpack=res3(9)
 IF (textpos EQ -1) THEN BEGIN
  textpos=N_ELEMENTS(res1)-2
  unitsstr=(res1)(textpos)
  IF (res1(0) EQ 'TEMPERATURE') THEN textpos=0
  IF (res1(0) EQ 'TEMPERATURE') THEN unitsstr='DegC'
 ENDIF


 
 ;Define field type: 0=Average field - ignored.
 ;                   1=lon, lat, lev, day
 ;                   2=lat, lev, day.
 ;		     3=lon, lat, day.		     
 ftype=0
 IF (ptype EQ 4) THEN ftype=1
 IF (ptype EQ 11) THEN ftype=2
 IF ((ptype EQ 4) AND (ppos EQ -1)) THEN ftype=3
 IF (thetapos GT 0) THEN ftype=1
 IF (avpos NE -1) THEN ftype=0
 levtype=FIX(RES3(5))
 

 
 field=FLTARR(xpts, ypts)
 ifield1=INTARR(xpts, ypts)
 ifield2=INTARR(xpts, ypts)
 fieldstr=STRARR(xpts, ypts)
 UTFSTR=''
 rowstr=STRARR(32)
 icount=0
 nlines=xpts*ypts*dpack/64
 
 
 rowstr=''
 FOR ichar=0, nlines-1 DO BEGIN
  READF, 1, rowstr, FORMAT='(A64)'
  utfstr=utfstr+rowstr
 ENDFOR
 
 ;Split into the array values.
 format='('+SCROP(xpts*ypts)+'A'+SCROP(dpack)+')'
 READS, utfstr, fieldstr, FORMAT=format

  
  
  
 gamax=max([ABS(fmax), ABS(fmin)])
 range=fmax-fmin
 arange=62.0^dpack-1.0
 scale=range/arange
 
 ;Convert field characters to integers.
 c1=BYTE(STRMID(fieldstr, 0, 1)) ;First character of string data.
 pts=WHERE(c1 LE 57, count)
 IF (count GT 0) THEN ifield1(pts)=c1(pts)-48
 pts=WHERE((c1 GE 65) AND (c1 LE 90), count)
 IF (count GT 0) THEN ifield1(pts)=c1(pts)-55
 pts=WHERE(c1 GE 97, count)
 IF (count GT 0) THEN ifield1(pts)=c1(pts)-61
 
 c2=BYTE(STRMID(fieldstr, 1, 1)) ;Second character of string data.
 pts=WHERE(c2 LE 57, count)
 IF (count GT 0) THEN ifield2(pts)=c2(pts)-48
 pts=WHERE((c2 GE 65) AND (c2 LE 90), count)
 IF (count GT 0) THEN ifield2(pts)=c2(pts)-55
 pts=WHERE(c2 GE 97, count)
 IF (count GT 0) THEN ifield2(pts)=c2(pts)-61
 
 IF (dpack EQ 3) THEN BEGIN
  ifield3=INTARR(xpts, ypts)  
  c3=BYTE(STRMID(fieldstr, 2, 1)) ;Third character of string data.
  pts=WHERE(c3 LE 57, count)
  IF (count GT 0) THEN ifield3(pts)=c3(pts)-48
  pts=WHERE((c3 GE 65) AND (c3 LE 90), count)
  IF (count GT 0) THEN ifield3(pts)=c3(pts)-55
  pts=WHERE(c3 GE 97, count)
  IF (count GT 0) THEN ifield3(pts)=c3(pts)-61
 ENDIF
 
 ;Retrieve field.
 IF (dpack EQ 2) THEN integ=(ifield1)*62+(ifield2)
 IF (dpack EQ 3) THEN integ=(ifield1)*62*62+(ifield2)*62+(ifield3)
 field=FLOAT(integ)*scale+fmin


 ;Construct field name with spaces.
 fieldstr=STRLOWCASE(res1(0))
 FOR ix=1, textpos-1 DO BEGIN
  fieldstr=fieldstr+' '+STRLOWCASE(res1(ix))
 ENDFOR
 
 ;Remove undesireable characters from variable name.
 varname=fieldstr
 badchars=['(', ')', '[', ']', '_', '-', '*']
 FOR ichar=0,1 DO BEGIN
  FOR char=0, N_ELEMENTS(badchars)-1 DO BEGIN
   res=STRPOS(varname, badchars(char))
   IF (res NE -1) THEN STRPUT, varname, ' ', res
  ENDFOR
 ENDFOR
 varname=STRCOMPRESS(varname, /REMOVE_ALL)
  
  
  
 ;Write lon, lat, lev, days into the structure.
 IF (N_ELEMENTS(svars) EQ 0) THEN BEGIN
  lonstruct=CREATE_STRUCT('data', lons)
  data=CREATE_STRUCT('lon', lonstruct)   
  latstruct=CREATE_STRUCT('data', lats)
  data=CREATE_STRUCT(data, 'lat', latstruct)   
  levstruct=CREATE_STRUCT('data', levs_orig)
  data=CREATE_STRUCT(data, 'p', levstruct) 
  daystruct=CREATE_STRUCT('data', days)
  data=CREATE_STRUCT(data, 'day', daystruct) 
  IF (N_ELEMENTS(thetas) GT 0) THEN BEGIN
   thetastruct=CREATE_STRUCT('data', thetas)
   data=CREATE_STRUCT(data, 'theta', thetastruct)   
  ENDIF
 ENDIF 
   


 ;lon, lat, lev, time fields.
 IF (ftype EQ 1) THEN BEGIN
  IF (N_ELEMENTS(svars) EQ 0) THEN BEGIN
   svars=varname
   IF ((levtype EQ 2) OR (levtype EQ 0)) THEN vardata=FLTARR(N_ELEMENTS(lons),$
      N_ELEMENTS(lats), N_ELEMENTS(levs), N_ELEMENTS(days))
   IF (levtype EQ 3) THEN vardata=FLTARR(N_ELEMENTS(lons), N_ELEMENTS(lats), N_ELEMENTS(thetas), N_ELEMENTS(days))
   
   varstruct=CREATE_STRUCT('data', vardata)
   varstruct=CREATE_STRUCT(varstruct, 'LONG_NAME', fieldstr)
   varstruct=CREATE_STRUCT(varstruct, 'UNITS', unitsstr(0))
   data=CREATE_STRUCT(data, varname, varstruct)   
  ENDIF ELSE BEGIN
   res=WHERE(varname EQ svars)
   IF (res EQ -1) THEN BEGIN
    svars=[svars, varname]
    varstruct.long_name=fieldstr
    varstruct.units=unitsstr(0)
    data=CREATE_STRUCT(data, varname, varstruct)
   ENDIF
  ENDELSE  

  ;Insert data into the structure.
  IF (levtype NE 3) THEN BEGIN 
   lev=FLOAT(res1(ppos+1))     
   levid=WHERE(lev EQ levs)
  ENDIF
  IF (levtype EQ 3) THEN BEGIN
   lev=FLOAT(STRMID(res1(ppos+1), 6, 3))  
   levid=WHERE(lev EQ thetas)
  ENDIF 
  day=FLOAT(res2(3)) 
  dayid=WHERE(day EQ days)
  com='data.'+varname+'.data(*,*,'+SCROP((levid)(0))+','+SCROP((dayid)(0))+')=field'
  res=EXECUTE(com)  
  IF NOT KEYWORD_SET(quiet) THEN PRINT, varname, ' Day=',SCROP(day), ' Pressure=', SCROP(levs_orig(levid(0)))
 ENDIF

 ;lat, lev, time fields.
 IF (ftype EQ 2) THEN BEGIN
  varname='zm'+varname
  IF (N_ELEMENTS(zvars) EQ 0) THEN BEGIN
   zvars=varname
   zmdata=FLTARR(N_ELEMENTS(lats), N_ELEMENTS(levs), N_ELEMENTS(days))
   zmstruct=CREATE_STRUCT('data', zmdata)
   zmstruct=CREATE_STRUCT(zmstruct, 'LONG_NAME', fieldstr)
   zmstruct=CREATE_STRUCT(zmstruct, 'UNITS', unitsstr(0))
   data=CREATE_STRUCT(data, varname, zmstruct)   
  ENDIF ELSE BEGIN  
   res=WHERE(varname EQ zvars) 
   IF (res EQ -1) THEN BEGIN
    zvars=[zvars, varname]
    zmstruct.long_name=fieldstr
    zmstruct.units=unitsstr(0)
    data=CREATE_STRUCT(data, varname, zmstruct)
   ENDIF
  ENDELSE
  
  ;Insert data into the structure.  
  day=res2(3)
  dayid=WHERE(day EQ days)
  com='data.'+varname+'.data(*,*,'+SCROP(dayid(0))+')=field'
  res=EXECUTE(com) 
  
  IF NOT KEYWORD_SET(quiet) THEN PRINT, varname, ' Day=',SCROP(day)
 ENDIF
 
 ;lat, lon, time fields.
 IF (ftype EQ 3) THEN BEGIN
  IF (N_ELEMENTS(sfvars) EQ 0) THEN BEGIN
   sfvars=varname
   sfdata=FLTARR(N_ELEMENTS(lons), N_ELEMENTS(lats), N_ELEMENTS(days))
   sfstruct=CREATE_STRUCT('data', sfdata)
   sfstruct=CREATE_STRUCT(sfstruct, 'LONG_NAME', fieldstr)
   sfstruct=CREATE_STRUCT(sfstruct, 'UNITS', unitsstr(0))
   data=CREATE_STRUCT(data, varname, sfstruct)   
  ENDIF ELSE BEGIN  
   res=WHERE(varname EQ sfvars) 
   IF (res EQ -1) THEN BEGIN
    sfvars=[sfvars, varname]
    sfstruct.long_name=fieldstr
    sfstruct.units=unitsstr(0)
    data=CREATE_STRUCT(data, varname, sfstruct)
   ENDIF
  ENDELSE
  
  ;Insert data into the structure.  
  day=res2(3)
  dayid=WHERE(day EQ days)
  com='data.'+varname+'.data(*,*,'+SCROP(dayid(0))+')=field'
  res=EXECUTE(com) 
  
  IF NOT KEYWORD_SET(quiet) THEN PRINT, varname, ' Day=',SCROP(day)
 ENDIF 

 READF, 1, fhead1
ENDWHILE

CLOSE, 1


;Write data dimensions into the structure.
guide_dims=['lon '+SCROP(N_ELEMENTS(lons)),$
            'lat '+SCROP(N_ELEMENTS(lats)),$
            'p '+SCROP(N_ELEMENTS(levs_orig)),$
	    'day '+SCROP(N_ELEMENTS(days))]
data=CREATE_STRUCT(data, 'guide_dims', guide_dims)

;Write lon, lat, lev, day data dimensions into the structure. 
guide_vars=['lon lon', 'lat lat', 'p p', 'day day']
FOR ivar=0, N_ELEMENTS(svars)-1 DO BEGIN
 guide_vars=[guide_vars, svars(ivar)+' lon lat p day']
ENDFOR
FOR ivar=0, N_ELEMENTS(zvars)-1 DO BEGIN
 guide_vars=[guide_vars, zvars(ivar)+' lat p day']
ENDFOR
FOR ivar=0, N_ELEMENTS(sfvars)-1 DO BEGIN
 guide_vars=[guide_vars, sfvars(ivar)+' lon lat day']
ENDFOR
data=CREATE_STRUCT(data, 'guide_vars', guide_vars)

;Add the run name as a title.
runname=ghead4
res=STRPOS(runname, '$')
IF (res NE -1) THEN STRPUT, runname, ' ', res
guide_gatts=runname
data=CREATE_STRUCT(data, 'guide_gatts', 'runname')
data=CREATE_STRUCT(data, 'runname', runname)


;Create the netCDF file.
NCWRITE, STRUCTURE=data, FILE=file



END

