PRO MASK_EOF_WRAP,data,mask,lons,lats,dataeof,fve,LAND=land,CUTOFF=cutoff

; This routine acts as a wrapper for eofcalc.pro.
; The first EOF of data is calculated, but only over the region
; specified by mask.
; If land is set then all points holding the value of land at any time
; or else are nan at any time are set to land in the EOF. All other 0
; points in mask are set to 0.

; Input:
;
; data - (nlon,nlat,ntim) the data 
; mask - (nlon,nlat) an array of 0s and 1s speciying which gridpoints
;        to use for EOF
; lons,lats - (nlon),(nlat) the dimension arrays
; eof,fve - (nlon,nlat),(1) the output
; land - (1) the value used of data to be ignored

nlon = N_ELEMENTS(lons)
nlat = N_ELEMENTS(lats)
ntim = N_ELEMENTS(data(0,0,*))

lats2 = FLTARR(nlon,nlat)
FOR i=0,nlon-1 DO lats2(i,*) = lats
locs = WHERE(mask EQ 1)
latmax = MAX(lats2(locs))
latmin = MIN(lats2(locs))
latrange = WHERE(lats GE latmin AND lats LE latmax)
nlat_sub = N_ELEMENTS(latrange)
IF N_ELEMENTS(land) EQ 0 THEN land = !VALUES.F_NAN

data_sub = data(*,latrange,*)

; Set all land values and all other non mask values to 0.0
FOR i=0,nlon-1 DO BEGIN & FOR j=0,nlat_sub-1 DO BEGIN
   IF(MAX(WHERE(data_sub(i,j,*) EQ land OR FINITE(data_sub(i,j,*),/NAN))) NE -1 $
            OR mask(i,latrange(j)) EQ 0) $
            THEN data_sub(i,j,*) = 0.0
ENDFOR & ENDFOR

; Calculate eofs:
IF N_ELEMENTS(cutoff) EQ 0 THEN cutoff = 1
EOFCALC, data_sub,eofs,pcs,svls,fve,CUTOFF=cutoff,LATS=lats(latrange)

; Scale EOFs so that their pc timseries have standard deviation of unity:
FOR i=0,cutoff-1 DO BEGIN
   eofs(*,*,i) = eofs(*,*,i)*svls(i)/sqrt(N_ELEMENTS(data(0,0,*))-1)
ENDFOR

; Check orthogonality:
;dot1 = 0.0
;dot2 = 0.0
;FOR i=0,N_ELEMENTS(lats)-1 DO BEGIN
;   dot1 = dot1+TOTAL(eofs(*,i,0)*eofs(*,i,0))*COS(lats(i)*!pi/180)
;   dot2 = dot2+TOTAL(eofs(*,i,0)*eofs(*,i,1))*COS(lats(i)*!pi/180)
;ENDFOR
;PRINT, 'CHECK. AREA-WEIGHTED SUM(E1*E1) = ',dot1
;PRINT, 'CHECK. AREA-WEIGHTED SUM(E1*E2) = ',dot2

; Return the relevant values:
dataeof = FLTARR(nlon,nlat,cutoff)
dataeof(*,latrange,*) = eofs
FOR i=0,nlon-1 DO BEGIN & FOR j=0,nlat-1 DO BEGIN
   IF(MAX(WHERE(data(i,j,*) EQ land OR FINITE(data(i,j,*),/NAN))) NE -1) THEN dataeof(i,j,*) = land
ENDFOR & ENDFOR
fve = fve(0)

END
