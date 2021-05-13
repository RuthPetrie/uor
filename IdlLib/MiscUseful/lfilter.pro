FUNCTION LFILTER, data,FILTER=filter,KT=kt, $               ; Required
                  NOPROGBAR=npb                             ; Optional
; BJH 12/2012

; Applies the Lanczos filter to the array data.
;    data can have any number of dimensions, but the time must be in
;    the final dimension
;    FILTER (string) specifies the filter identifier
;    KT (integer) specifies the number of weights (=2*kt-1)
;    NOPROGBAR stops calls to STATUSLINE.pro which are a nuissance if
;        run in the background

; Note: This code requires the weights to be generated before calling,
;       using Paul's code in /home/ben/lanczos/output/
;       It also using the routine STATUSLINE.pro

; Check both required keywords are set
IF N_ELEMENTS(filter) NE 1 OR N_ELEMENTS(kt) NE 1 THEN $
  STOP, 'LFILTER usage: LFILTER, data,FILTER=filter,KT=kt'

; Get the dimensions of data and reform data to (space,time)
dsize = SIZE(data)
ndims = dsize[0]
gpts = PRODUCT(dsize[1:ndims-1],/INTEGER)
tpts = dsize[ndims]
data = REFORM(data,gpts,tpts)

; Check there are sufficient time points for the filter
IF tpts LT 2*kt-1 THEN STOP, $
  'Not enough time points for the '+STRTRIM(2*kt-1,2)+' weight filter'

; Print message to screen
PRINT, ''
PRINT, 'Calling LFILTER'
PRINT, '---------------'
PRINT, '   Filter: '+filter+', '+STRTRIM(2*kt-1,2)+' weights'
PRINT, '   Variable size: '+STRTRIM(gpts,2)+' spatial points, '+STRTRIM(tpts,2)+' time points'

; Read in lanczos weights data
lanc_dir = '/home/ben/lanczos/output/'
weights = DBLARR(2*kt-1)
OPENR, lun,lanc_dir+filter+STRTRIM(kt,2)+'/weights.dat',/GET_LUN
READF, lun,weights
FREE_LUN, lun

; Loop over time points and apply the filter
wmat = REPLICATE(1d,gpts)#weights
datal = FLTARR(gpts,tpts)
PRINT, FORMAT='("   Progress: ",$)'
IF NOT KEYWORD_SET(npb) THEN STATUSLINE, '',0
sc = FLOAT(100)/(tpts-kt)
FOR t=kt-1L,tpts-kt DO BEGIN
   tlocs = t-kt+1+INDGEN(2*kt-1)
   datal[*,t] = TOTAL(data[*,tlocs]*wmat,2)
   IF NOT KEYWORD_SET(npb) THEN IF ROUND(t*sc) GT ROUND((t-1)*sc) THEN $
     STATUSLINE, STRING(t*sc,FORMAT='(I3)')+'%',14
ENDFOR
IF NOT KEYWORD_SET(npb) THEN STATUSLINE, /CLOSE
PRINT, ''
PRINT, ''

; Pad the ends with NaNs
datal[*,0:(kt-2)] = !VALUES.F_NAN
datal[*,(tpts-kt+1):(tpts-1)] = !VALUES.F_NAN

; Return the filter values, with array structure the same as the
; input, also reforms data back to its original structure
data = REFORM(data,dsize[1:ndims])
RETURN, REFORM(datal,dsize[1:ndims])

END
