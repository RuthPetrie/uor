FUNCTION sf, data, field, MEAN=mean, _EXTRA=extra, SILENT=silent
;Function to select fields for plotting.
;(C) NCAS 2010


;Check inputs look okay.
IF (N_ELEMENTS(data) EQ 0) THEN emessage='SF error - must specify the netCDF file for selecting field from.'
IF (N_ELEMENTS(field) EQ 0) THEN emessage='SF error - must specify field for selection.'
IF ((N_ELEMENTS(data) EQ 0) OR (N_ELEMENTS(field) EQ 0)) THEN BEGIN
 PRINT, ''
 PRINT, emessage
 PRINT, 'For example:
 PRINT, "SF('gdata.nc', 'temp', p=1000)"
 PRINT, 'to select the 1000mb temperature from the netCDF file or structure specified.
 PRINT, ''
 PRINT, 'See SF documentation for further information.'
 PRINT, ''
 STOP
ENDIF

ncfile=data

;Read in the data.
vfield=field(0)
com='data=NCREAD(data, VAR=vfield, /ATT'
IF KEYWORD_SET(silent) THEN com=com+',/SILENT)' ELSE com=com+')'
res=EXECUTE(com)
;data=NCREAD(data, VAR=vfield, /ATT, /SILENT)
dtags=TAG_NAMES(data)


IF (N_ELEMENTS(extra) GE 1) THEN BEGIN
 ;Check the specified data exists.
 tnames=TAG_NAMES(extra)
 FOR i=0, N_TAGS(extra)-1 DO BEGIN
  dtags=TAG_NAMES(data)
  pts=WHERE(tnames(i) EQ dtags, count)
 
  ;Check the specified data exists.
  IF (count LT 1) THEN BEGIN
   PRINT, ''
   PRINT, 'SF error - dimension ',tnames(i), " doesn't exist."
   PRINT, 'Available dimensions are: '
   FOR it=0, N_ELEMENTS(dtags)-1 DO BEGIN
    fs=STRMID(dtags(it), 0, 5)
    IF (fs NE 'GUIDE') THEN PRINT, dtags(it)
   ENDFOR
   PRINT, ''
   STOP
  ENDIF  
 
  res=EXECUTE('val=extra.'+tnames(i))
  res=EXECUTE('dvals=data.'+tnames(i)+'.data')
  pts=WHERE(ABS(dvals-val) LT 1E-3, count)

  ;Check the specified point exists.
  IF (count LT 1) THEN BEGIN
   PRINT, ''
   PRINT, 'SF error - point ', tnames(i), ' = ', SCROP(val), " doesn't exist."
   PRINT, 'Available values are: '
   PRINT, dvals
   PRINT, ''
   STOP
  ENDIF 
 ENDFOR

 
 
 ;Select the data for return.
 res=EXECUTE('retdata=data.'+vfield(0)+'.data')
 com='retdata=retdata('

 ;Find out the variables in this field.
 gvars=STRSPLIT(data.guide_vars(0), /EXTRACT)
 gvars=gvars(1:N_ELEMENTS(gvars)-1)


 ;Loop to construct the selection of the dimensions.
 FOR i=0, N_ELEMENTS(gvars)-1 DO BEGIN
  mydim=(STRSPLIT(gvars(i), /EXTRACT))(0)
  chk=WHERE(STRUPCASE(gvars(i)) EQ tnames, count) 
  IF (count EQ 0) THEN BEGIN
   com=com+'*'
   IF (N_ELEMENTS(dnames) EQ 1) THEN dnames=[dnames, gvars(i)]
   IF (N_ELEMENTS(dnames) EQ 0) THEN dnames=gvars(i)
  ENDIF
  IF (count EQ 1) THEN BEGIN
   res=EXECUTE('val=extra.'+mydim)
   res=EXECUTE('dvals=data.'+mydim+'.data')
   pts=WHERE(ABS(dvals-val) LT 1E-3, count)
   com=com+SCROP(pts)
   IF (N_ELEMENTS(title2) EQ 1) THEN title2=title2+', '+gvars(i)+'='+SCROP(val)
   IF (N_ELEMENTS(title2) EQ 0) THEN title2=gvars(i)+'='+SCROP(val)
   pts=WHERE(dtags NE STRUPCASE(mydim))
   dtags=dtags(pts)   
  ENDIF
  IF (i NE N_ELEMENTS(gvars)-1) THEN com=com+','
 ENDFOR
 com=com+')'


 ;Select the final data for return.
 res=EXECUTE((com)(0))
 
ENDIF ELSE BEGIN
 ;dnames=vfield(1:N_ELEMENTS(vfield)-1)
 res=EXECUTE('retdata=data.'+vfield(0)+'.data')
 ;dtags=dtags(1:N_ELEMENTS(s))
ENDELSE


;Form data and dimension for return.
retdata=REFORM(retdata)
s=SIZE(retdata, /DIMENSIONS)
dataname=dtags(0) 
dtags=dtags(1:N_ELEMENTS(s))

 
;Do meaning if requested.
IF (N_ELEMENTS(mean) GE 1) THEN BEGIN
 FOR ix=0, N_ELEMENTS(mean)-1 DO BEGIN
  pts=WHERE(dtags EQ STRUPCASE(mean(ix)), count)
  IF (count NE 1) THEN BEGIN
   PRINT, ''
   PRINT, 'SF error - mean = ', mean(ix), ' not found.'
   PRINT, 'Available values are ', dtags
   PRINT, ''
   STOP
  ENDIF
  retdata=TOTAL(retdata, pts+1)/FLOAT((s(pts))(0))
  s=SIZE(retdata, /DIMENSIONS) 
  pts=WHERE(dtags NE STRUPCASE(mean(ix)), count)
  dtags=dtags(pts)
 ENDFOR
ENDIF 

;Check return data is 2D and reject if otherwise.
IF (N_ELEMENTS(s) NE 2) THEN BEGIN
 PRINT, ''
 PRINT, 'SF error - return data array is not two dimensional.'
 PRINT, 'Array dimensions are: '
 FOR idim=0, N_ELEMENTS(s)-1 DO BEGIN
  PRINT, dtags(idim), s(idim)
 ENDFOR
 PRINT, ''
 STOP
ENDIF


;Construct the structure for return.
retstruct=CREATE_STRUCT('data', REFORM(retdata))
res=EXECUTE('tagnames=TAG_NAMES(data.'+dataname+')')
pts=WHERE('LONG_NAME' EQ STRUPCASE(tagnames), count)
IF (count EQ 1) THEN res=EXECUTE('title=data.'+dataname+'.long_name')
IF (N_ELEMENTS(title) EQ 1) THEN title=title+' - '+ dataname ELSE title=dataname
retstruct=CREATE_STRUCT(retstruct, 'title', title)
IF (N_ELEMENTS(title2) EQ 0) THEN title2=''
retstruct=CREATE_STRUCT(retstruct, 'title2', title2)
pts=WHERE('UNITS' EQ STRUPCASE(tagnames), count)
IF (count EQ 1) THEN res=EXECUTE('units=data.'+dataname+'.units')
IF (N_ELEMENTS(units) EQ 0) THEN units='' ELSE units='units='+units
retstruct=CREATE_STRUCT(retstruct, 'units', units)
res=EXECUTE('x=data.'+dtags(0)+'.data')
retstruct=CREATE_STRUCT(retstruct, dtags(0), x)
res=EXECUTE('y=data.'+dtags(1)+'.data')
retstruct=CREATE_STRUCT(retstruct, dtags(1), y)


;Add in extra data for a UV field.
IF (N_ELEMENTS(field) EQ 2) THEN BEGIN
 f1=field(0)
 f2=field(1)
 com='field2=SF(ncfile, field(1)'
 if KEYWORD_SET(silent) THEN com=com+', /SILENT'
 FOR i=0, N_ELEMENTS(tnames)-1 DO BEGIN
  res=EXECUTE('val=extra.'+tnames(i))
  com=com+', '+tnames(i)+'='+SCROP(val)
 ENDFOR
 com=com+')'
 res=EXECUTE(com)
 retstruct=CREATE_STRUCT(retstruct, 'data2', REFORM(field2.data))  
 retstruct.title=f1+' '+f2
ENDIF


;Return the data.
RETURN, retstruct

END


