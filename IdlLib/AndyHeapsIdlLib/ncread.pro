FUNCTION ncstat, file

CATCH, estatus
IF (estatus NE 0) THEN BEGIN
 CATCH, /CANCEL
 RETURN, -1
ENDIF
fid=NCDF_OPEN(file)

IF (fid EQ -1 ) THEN BEGIN
 RETURN, -1
ENDIF

CATCH, /CANCEL
NCDF_CLOSE, fid
RETURN, 1
END

FUNCTION ncread, file, VARS=vars, SILENT=silent, ATT=att, OFFSET=OFFSET, $
                       COUNT=COUNT, STRIDE=stride, ONLY=only, NOMOD=nomod, VALID=valid
;FUNCTION to read netCDF files.
;(C) NCAS 2010

;Based on ideas from other NetCDF reading programs on the web:
;Alan Geer's program from http://darc.nerc.ac.uk/asset/assic/code/netcdf_read.pro
;shows how to deal with case insensitivity in IDL and hyperslabbing.
;Paul van Delst's method of data and attribute ordering was adopted as that looked
;elegant. Paul's program is available from http://www.dfanning.com/documents/programs.html#File%20Programs
;This method of data organisation also looks to be used in the Met Office IDL wave library.

;Check for file.
CD, CURRENT=present_path
path=[GETENV('GUIDE_DATA'), STRSPLIT(GETENV('IDL_PATH'), ':', /EXTRACT)]

IF (FILE_TEST(file) EQ 1) THEN mypath=file
FOR i=0, N_ELEMENTS(path)-1 DO BEGIN
 tfile=path(i)+'/'+file
 res=FILE_TEST(tfile)
 IF (res EQ 1) THEN BEGIN
  IF (N_ELEMENTS(mypath) GT 0) THEN mypath=[mypath, tfile]
  IF (N_ELEMENTS(mypath) EQ 0) THEN mypath=tfile
 ENDIF
ENDFOR

IF(N_ELEMENTS(mypath) EQ 0) THEN BEGIN
 PRINT, ''
 PRINT, 'NCREAD ERROR - ', file,' not found in the IDL_PATH directories: ', path, present_path
 PRINT, ''
 STOP
ENDIF

IF (N_ELEMENTS(mypath) GT 1) THEN BEGIN
 PRINT, ''
 PRINT, 'NCREAD ERROR - multiple versions of ', file, ' found:'
 FOR i=0, N_ELEMENTS(mypath)-1 DO BEGIN
  PRINT, mypath(i)
 ENDFOR
 PRINT, ''
 PRINT, 'Please rename one of these to another file so that the correct '
 PRINT, 'netCDF file is read.'
 PRINT, ''
 STOP
ENDIF

;Check file is a netCDF file.
estat=NCSTAT(mypath)
IF (estat EQ -1) THEN BEGIN
 PRINT, ''
 PRINT, 'NCREAD ERROR - file ', mypath, ' is not a netCDF file.'
 PRINT, ''
 STOP
ENDIF


;Store original vars.
IF (N_ELEMENTS(vars) NE 0) THEN vars_orig=vars


IF (NOT KEYWORD_SET(silent)) THEN BEGIN
 PRINT, 'Reading ', mypath
 pad=''
 FOR i=0, STRLEN(mypath)+7 DO BEGIN
  pad=pad+'-'
 ENDFOR
 PRINT, pad
ENDIF

;Select all variables unless already set.
fid=NCDF_OPEN(mypath)
res=ncdf_inquire(fid)
FOR i=0, res.nvars-1 DO BEGIN
 varinfo=NCDF_VARINQ(fid, i)
 varid=NCDF_VARID(fid, varinfo.name) 
 IF (i EQ 0) THEN vars_all=varinfo.name
 IF (i GE 1) THEN vars_all=[vars_all, varinfo.name]
ENDFOR

IF (NOT KEYWORD_SET(vars)) THEN BEGIN
 vars=vars_all
 ;vars_orig=vars
 vars_set=1
ENDIF 

vars_orig=vars
;Select all dependencies as well as listed variables
IF (NOT KEYWORD_SET(only)) THEN BEGIN
 depstr=STRARR(N_ELEMENTS(vars)) ;Dependency strings for COORDINATES.
 FOR i=0, N_ELEMENTS(vars)-1 DO BEGIN
  var=vars(i)
  ;Check variables exist.
  res=WHERE(vars_all EQ var, chk)
  IF (chk NE 1) THEN BEGIN
   PRINT, ''
   PRINT, 'NCREAD error - VAR=', var, ' not in netCDF file ', file
   PRINT, 'Variables available are: ', vars_all
   PRINT, ''
   STOP
  ENDIF
  
  ;Add dependencies.
  IF NOT KEYWORD_SET(vars_set) THEN BEGIN
   varid=NCDF_VARID(fid, var)
   res = NCDF_VARINQ(fid, varid) 
   FOR idim=0, res.ndims-1 DO BEGIN
    NCDF_DIMINQ, fid, res.dim(idim), dimname, dimsize
    IF ((i EQ 0) AND (idim EQ 0)) THEN BEGIN
     pts=WHERE(vars EQ dimname, dimcount)
     IF (dimcount EQ 0) then dep=dimname
    ENDIF ELSE BEGIN
     pts=WHERE(dep EQ dimname, dimcount)
     IF (dimcount EQ 0)  THEN dep=[dep, dimname]
    ENDELSE
   ENDFOR 
  depstr=[depstr, STRARR(N_ELEMENTS(dep))]
  ENDIF
  
  
  ;Add in coordinates if they exist.
  varid=NCDF_VARID(fid, var)
  varinfo=NCDF_VARINQ(fid, varid)
  natts=varinfo.natts
  cmatch=0
  FOR iatt=0, natts-1 DO BEGIN
   attname=NCDF_ATTNAME(fid, var,iatt)
   attname=STRING(attname)
   IF (STRUPCASE(attname) EQ 'COORDINATES') THEN cmatch=1
  ENDFOR
  IF (cmatch EQ 1) THEN BEGIN
   NCDF_ATTGET, fid, var,'coordinates' , attval
   attval=STRSPLIT(STRING(attval), /EXTRACT)
   depstr(i)=' Coordinates are '+STRJOIN(attval, ' ')
   ;Add to dependencies if they don't already exist.
   IF NOT KEYWORD_SET(vars_set) THEN BEGIN
    FOR ic=0, N_ELEMENTS(attval)-1 DO BEGIN
     myatt=attval(ic)
     pts=WHERE(myatt EQ dep, depcount)
     IF (depcount EQ 0) THEN dep=[dep, attval(ic)]
    ENDFOR
   ENDIF
  ENDIF
 ENDFOR
ENDIF

 ;Check all dependencies are valid and discard any that aren't.
 IF (N_ELEMENTS(dep) GE 1) THEN BEGIN
  FOR i=0, N_ELEMENTS(dep)-1 DO BEGIN
   res=WHERE(vars_all EQ dep(i), depcount)
   IF ((depcount EQ 1) AND (N_ELEMENTS(dep_valid) GT 0)) THEN dep_valid=[dep_valid, dep(i)]
   IF ((depcount EQ 1) AND (N_ELEMENTS(dep_valid) EQ 0)) THEN dep_valid=dep(i)
   ENDFOR
 ENDIF
 IF (N_ELEMENTS(dep_valid) GE 1) THEN vars=[vars, dep_valid]
;ENDELSE

;Set-up array for data association if /ATT specified.
IF KEYWORD_SET(att) THEN guide_vars=STRARR(N_ELEMENTS(vars))

;Main reading loop
FOR i=0, N_ELEMENTS(vars)-1 do BEGIN
 var=vars(i)
 varid=NCDF_VARID(fid, var)
 
 ;Read the data.
 ;if count, offset or stride are defined then get this slab of data for the passed in variables.
 com='NCDF_VARGET, fid, varid, vardata'
 IF KEYWORD_SET(COUNT) THEN com=com+', COUNT=count'
 IF KEYWORD_SET(OFFSET) THEN com=com+', OFFSET=offset'
 IF KEYWORD_SET(STRIDE) THEN com=com+', STRIDE=stride'
 pts=WHERE(VARS_ORIG EQ var, varcount)
 IF ((varcount EQ 0) OR (STRLEN(com) EQ 32)) THEN BEGIN
  NCDF_VARGET, fid, varid, vardata
 ENDIF ELSE BEGIN
  res=EXECUTE(com)
 ENDELSE
 

 ;Check for illegal characters in the variable name and replace with underscores.
 thisvar=vars(i)
 dodgy_chars=['-']
 FOR ichar=0, N_ELEMENTS(dodgy_chars)-1 DO BEGIN
  ilen=STRLEN(thisvar)
  FOR ic=0, ilen-1 DO BEGIN
   char=STRMID(thisvar, ic, 1)
   IF (char EQ dodgy_chars(ichar)) THEN STRPUT, thisvar, '_', ic
  ENDFOR
 ENDFOR
 
 
 ;Check for duplicate names and rename if necessary.
 ;This can occur when using t for time and T for temperature for example.
 ;This is allowed in NetCDF but IDL cannot cope with this as it is internally case insensitive.
 dupcount=0
 IF (i GT 0) THEN BEGIN
  d=WHERE(STRLOWCASE(vars(0:i-1)) EQ STRLOWCASE(vars(i)), dupcount)
  IF (dupcount GT 0) THEN BEGIN
    PRINT, '----------WARNING-------------'
    PRINT, 'Duplicate variable name for ', var, ' , renamed to ', var+'_1'
    PRINT, '------------------------------'
    thisvar=var+'_1'
  ENDIF
 ENDIF
 
 IF (thisvar EQ 'xor') THEN BEGIN
   PRINT, 'Renaming xor to xor2 as xor is a reserved name'
   thisvar='xor2'
 ENDIF
 
 varinfo=NCDF_VARINQ(fid, varid)
 natts=varinfo.natts
 
 ;Find out how the variable is defined in terms of dimensions.
 res = NCDF_VARINQ(fid, varid) 
 FOR idim=0, res.ndims-1 DO BEGIN
  NCDF_DIMINQ, fid, res.dim(idim), dimname, dimsize
  IF (idim EQ 0) THEN BEGIN
   vardef=['['+dimname] 
   IF KEYWORD_SET(att) THEN guide_vars(i)=thisvar+' '+dimname
  ENDIF
  IF (idim GT 0) THEN BEGIN
   vardef=[vardef+','+dimname]
   IF KEYWORD_SET(att) THEN guide_vars(i)=guide_vars(i)+' '+dimname  
  ENDIF
 ENDFOR 
 IF (res.ndims-1 GE 0) THEN vardef=[vardef+']']
 IF (N_ELEMENTS(vardef) EQ 0) THEN vardef=thisvar
 IF (NOT KEYWORD_SET(silent)) THEN BEGIN
  IF (N_ELEMENTS(depstr) EQ 0) THEN PRINT, thisvar, ' ', vardef ELSE PRINT, thisvar, ' ', vardef+depstr(i)
 ENDIF
 
 ;Reset attribute values.
 scale_factor=1.0
 add_offset=0.0
 IF (N_ELEMENTS(valid_min) NE 0) THEN tmp=temporary(valid_min)
 IF (N_ELEMENTS(valid_max) NE 0) THEN tmp=temporary(valid_max)
 IF (N_ELEMENTS(missing_value) NE 0) THEN tmp=temporary(missing_value)
 IF (N_ELEMENTS(_FillValue) NE 0) THEN tmp=temporary(_FillValue)

 ;Load the attributes.
 FOR j=0, natts-1 DO BEGIN
  attname=ncdf_attname(fid, var, j)
  NCDF_ATTGET, fid, var, attname, attval
  IF (attname EQ 'scale_factor') THEN scale_factor=attval
  IF (attname EQ 'add_offset') THEN add_offset=attval
  IF (attname EQ 'valid_min') THEN valid_min=attval
  IF (attname EQ 'valid_max') THEN valid_max=attval
  IF (attname EQ 'missing_value') THEN missing_value=attval
  IF (attname EQ '_FillValue') THEN _FillValue=attval
  IF (attname EQ 'valid_range') THEN valid_min=attval(0)
  IF (attname EQ 'valid_range') THEN valid_max=attval(1)
  res=NCDF_ATTINQ(fid, var, attname)
  IF (res.datatype EQ 'CHAR') THEN attval=STRING(BYTE(attval))
  IF (KEYWORD_SET(att) AND (j EQ 0)) THEN varstruct=CREATE_STRUCT(attname, attval)
  IF (KEYWORD_SET(att) AND (j GT 0)) THEN varstruct=CREATE_STRUCT(varstruct, attname, attval)
 ENDFOR 
  
  
 ;Modify data according to netCDF attributes.
 ;Reset counters and check data.
 count1=0
 count2=0
 count3=0
 count4=0
 IF (N_ELEMENTS(valid_min) NE 0) THEN pts1=WHERE(vardata LT valid_min, count1)
 IF (N_ELEMENTS(valid_max) NE 0) THEN pts2=WHERE(vardata GT valid_max, count2)  
 IF (N_ELEMENTS(missing_value) NE 0) THEN pts3=WHERE(vardata EQ missing_value, count3)   
 IF (N_ELEMENTS(_FillValue) NE 0) THEN pts4=WHERE(vardata EQ _FillValue, count4)

 ;IF (thisvar EQ 'mrsos') THEN STOP
 ;Modify data unless requested otherwise.
 ;Scale_factor and add_offset.
 IF NOT KEYWORD_SET(nomod) THEN vardata=vardata*scale_factor+add_offset 
  
 ;The default is to ignore valid_min and valid_max.
 ;These are often set incorrectly and so are ignored by default.
 IF (KEYWORD_SET(valid) AND (count1 GT 0)) THEN vardata(pts1)=!values.f_nan
 IF (KEYWORD_SET(valid) AND (count2 GT 0)) THEN vardata(pts2)=!values.f_nan
    
    
    
 ;missing_value and _FillValue
 IF NOT KEYWORD_SET(nomod) THEN BEGIN 
  IF (count3 GT 0) THEN vardata(pts3)=!values.f_nan
  IF (count4 GT 0) THEN vardata(pts4)=!values.f_nan
 ENDIF

 

 ;Place variable data into a structure.
 IF (NOT KEYWORD_SET(att)) THEN BEGIN
  IF (i EQ 0) THEN data=CREATE_STRUCT(thisvar, vardata)
  IF (i GT 0) THEN  data=CREATE_STRUCT(data, thisvar, vardata)
 ENDIF ELSE BEGIN
  IF (j EQ 0) THEN varstruct=CREATE_STRUCT('data', vardata)
  IF (j NE 0) THEN varstruct=CREATE_STRUCT(varstruct, 'data', vardata)
  IF (i EQ 0) THEN data=CREATE_STRUCT(thisvar, varstruct)
  IF (i GT 0) THEN data=CREATE_STRUCT(data, thisvar, varstruct)
 ENDELSE 
ENDFOR


;Add in dimensions if /ATT set.
IF KEYWORD_SET(att) THEN BEGIN
 res=ncdf_inquire(fid)
 ndims=res.ndims
 guide_dims=STRARR(ndims)
 FOR dimid=0, ndims-1 DO BEGIN
  NCDF_DIMINQ, fid, dimid, dimname, dimsize
  guide_dims(dimid)=SCROP(dimname)+' '+SCROP(dimsize)
 ENDFOR
 IF (ndims GT 0) THEN data=CREATE_STRUCT(data, 'guide_dims', guide_dims)
ENDIF


;Add in global attributes if /ATT set.
IF KEYWORD_SET(att) THEN BEGIN
res=ncdf_inquire(fid)
ngatts=res.ngatts
IF (ngatts GT 0) THEN guide_gatts=STRARR(ngatts)
 FOR i=0, ngatts-1 DO BEGIN
  attname=NCDF_ATTNAME(fid, i, /GLOBAL)
  NCDF_ATTGET, fid, attname, attval, /GLOBAL
  res=NCDF_ATTINQ(fid, attname, /GLOBAL)
  IF (res.datatype EQ 'CHAR') THEN attval=STRING(BYTE(attval))
  ;Check for illegal characters in the variable name and replace with underscores.
  attname=BYTE(attname)
  pts=WHERE(attname EQ 45, count)
  IF (count GT 0) THEN attname(pts)=95
  attname=STRING(attname)
  IF (i EQ 0) THEN attstruct=CREATE_STRUCT(attname, attval) ELSE attstruct=CREATE_STRUCT(attstruct, attname, attval)
  IF (ngatts GT 0) THEN guide_gatts(i)=attname
 ENDFOR
ENDIF

;Join the data and attribute structures together if the attribute structure exists.
IF (N_ELEMENTS(attstruct) GT 0) THEN data=CREATE_STRUCT(data, attstruct)


NCDF_CLOSE, fid

IF (NOT KEYWORD_SET(silent)) THEN PRINT, ''

;Add the variable data association if required.
IF KEYWORD_SET(att) THEN BEGIN
  data=CREATE_STRUCT(data, 'guide_vars', guide_vars)
  IF (ngatts GT 0) THEN data=CREATE_STRUCT(data, 'guide_gatts', guide_gatts)
ENDIF

;Reset vars if required.
IF (N_ELEMENTS(vars_orig) NE 0) THEN vars=vars_orig


RETURN, data

END
