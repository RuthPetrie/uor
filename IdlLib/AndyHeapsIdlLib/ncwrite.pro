PRO NCWRITE, STRUCTURE=data, FILE=file
;Procedure to write a netCDF file.
;(C) NCAS 2010

IF (N_ELEMENTS(data) NE 1) THEN BEGIN
 PRINT, ''
 PRINT, 'NCWRITE ERROR - need to add STRUCTURE=structure keyword.'
 PRINT, ''
 STOP
ENDIF
IF (N_ELEMENTS(FILE) NE 1) THEN BEGIN
 PRINT, ''
 PRINT, 'NCWRITE ERROR - need to add FILE=file keyword.'
 PRINT, ''
 STOP
ENDIF

vars=TAG_NAMES(data)

;Check for guide_vars, exit if missing.
missing=WHERE(vars EQ 'GUIDE_VARS', count)
IF (count NE 1) THEN BEGIN
 PRINT, ''
 PRINT, "NCWRITE ERROR - the structure you have passed into NCWRITE doesn't"
 PRINT, 'have all the necessary attributes for writing a netCDF file.'
 PRINT, 'Please add the /ATT, /NOMOD flags to the NCREAD command and try again.'
 PRINT, ''
 STOP
ENDIF



;Open netCDF file for writing.
fid=NCDF_CREATE(file, /CLOBBER)

;Create dimension definitions.
FOR i=0, N_ELEMENTS(data.guide_dims)-1 DO BEGIN
 st=STRSPLIT(data.guide_dims(i), /EXTRACT)
 com=st(0)+"id=NCDF_DIMDEF(fid, '"+st(0)+"',"+st(1)+")"
 res=EXECUTE(com)
ENDFOR


;Create variable definitions.
FOR i=0, N_ELEMENTS(data.guide_vars)-1 DO BEGIN
 strs=STRSPLIT(data.guide_vars(i), /EXTRACT)
 com=strs(0)+"vid=NCDF_VARDEF(fid, '"+strs(0)+"', ["
 FOR j=1, N_ELEMENTS(strs)-1 DO BEGIN
  com=com+strs(j)+'id'
  IF (j LT N_ELEMENTS(strs)-1) THEN com=com+', '
 ENDFOR
 com2='type=SIZE(data.'+strs(0)+'.data, /TYPE)'
 res=EXECUTE(com2)
 IF (TYPE EQ 2) THEN com=com+"], /SHORT)"
 IF (TYPE EQ 3) THEN com=com+"], /LONG)"
 IF (TYPE EQ 4) THEN com=com+"], /FLOAT)"
 IF (TYPE EQ 5) THEN com=com+"], /DOUBLE)"
 res=EXECUTE(com)
ENDFOR


;Retrieve and write the variable attributes.
FOR i=0, N_ELEMENTS(data.guide_vars)-1 DO BEGIN
 strs=STRSPLIT(data.guide_vars(i), /EXTRACT)
 com='myatt2=TAG_NAMES(data.'+strs(0)+')'
 res=EXECUTE(com)
 FOR j=0, N_ELEMENTS(myatt2)-1 DO BEGIN
  IF (myatt2(j) NE 'DATA') THEN BEGIN
   com='NCDF_ATTPUT, fid, '+strs(0)+'vid, "'+STRLOWCASE(myatt2(j))+'" '
   com=com+', data.'+strs(0)+'.'+myatt2(j)
   res=EXECUTE(com)
  ENDIF
 ENDFOR
ENDFOR
 

;Write out the global attributes.
IF (WHERE('GUIDE_GATTS' EQ TAG_NAMES(data)) GE 0) THEN BEGIN
 FOR i=0, N_ELEMENTS(data.guide_gatts)-1 DO BEGIN
  com='NCDF_ATTPUT, fid, /GLOBAL, "'+data.guide_gatts(i)+'", data.'+data.guide_gatts(i)
  res=EXECUTE(com)
 ENDFOR
ENDIF

;Swap over to data mode.
NCDF_CONTROL, fid, /ENDEF

;Write out the data
FOR i=0, N_ELEMENTS(data.guide_vars)-1 DO BEGIN
 strs=STRSPLIT(data.guide_vars(i), /EXTRACT)
 com="NCDF_VARPUT, fid, "+ strs(0)+"vid, data."+strs(0)+".data"
 res=EXECUTE(com)
ENDFOR


;Close the netCDF file.
NCDF_CLOSE, fid


END
