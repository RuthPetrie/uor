FUNCTION ENS_AVG, data,dim,modnames,ENSEMBLE=ens,SINGLE=sin,titles

; Takes a multi-model dataset where some or all of the models have
; multiple runs and returns:
;         - given ENSEMBLE, an array holding the ensemble mean
;           for each model separately (default), or
;         - given SINGLE, an array holding only the first ensemble
;           member only.
; The ENSEMBLE and SINGLE keywords should be arrays of the same length as the
; dim dimension of data (i.e. the total number of members), but
; specify to which model they belong. The optional variable titles
; returns the subarray of the unique elements in ens.

; Put in checks: data=array(dimension dim must equal N_ELEMENTS(ens))

; Print banner
PRINT, ''
PRINT, 'Calling ENS_AVG'
PRINT, '---------------'

IF (NOT N_ELEMENTS(ens)) AND (NOT N_ELEMENTS(sin)) THEN ens=1

IF N_ELEMENTS(ens) THEN BEGIN
   PRINT, 'Calculating the ensemble means'
ENDIF ELSE IF N_ELEMENTS(sin) THEN BEGIN
   PRINT, 'Finding the single runs'
ENDIF

; Find the number of unique elements in modnames
nens = N_ELEMENTS(modnames)
titles = modnames[UNIQ(modnames)]
nuniq = N_ELEMENTS(titles)

; Print details
PRINT, 'There are '+STRTRIM(nens,2)+' ensemble members and '+STRTRIM(nuniq,2)+' models...'

; Setup up data_sub, an array like data but with the dim dimension
; reduced to the size nuniq
data_size = SIZE(data)
data_size[dim+1] = nuniq
data_sub = FLTARR(data_size[1:data_size[0]])

; Loop over the unique elements and calculate the average
com1='' & com2=''
FOR i=1,dim DO com1=com1+'*,'
FOR i=dim+1,data_size[0]-1 DO com2=com2+',*'

FOR e=0,nuniq-1 DO BEGIN
    locs = WHERE(modnames EQ titles[e])
    IF N_ELEMENTS(sin) THEN locs=locs[0]
    IF N_ELEMENTS(locs) EQ 1 THEN $
      com = 'data_sub['+com1+'e'+com2+'] = REFORM(data['+com1+'locs'+com2+'])' ELSE $
      com = 'data_sub['+com1+'e'+com2+'] = AVG(data['+com1+'locs'+com2+'],dim)'
    IF EXECUTE(com) NE 1 THEN STOP
    PRINT, '   '+titles[e]+' ['+STRTRIM(locs,2)+']'
 ENDFOR

PRINT, ''

RETURN, data_sub

END
