; Modified version of Dan's EOF code (taken from
; http://www.met.rdg.ac.uk/~dan/work/H2EOF.html (14/2/2011))

PRO EOFCALC, field,eofs,pcs,svls,fve,CUTOFF=cutoff,LATS=lats,COMPLEX=complex

;-----------------------------------------------------------------------------
; Calculates the EOFs of a given field.
; Options: latitudinal weighting and complex EOF calculation


; INPUT:
;
; field    = array containing input field (assumed to be (lon,lat,time))
; 
; OPTIONAL INPUT:
;
; cutoff   = number of EOFs to retain (optional: all are retained if not
;            given; max=no. time points)
; lats     = latitude values (optional: no weighting is used if not
;            given)
; complex  = returns the complex EOF (calculated with imaginary part
;            equal to the Hilbert transform of the real part (see
;            Hannachi et al 2007)
;
; OUTPUT:
;
; eofs     = output array containing eofs (lon,lat,cutoff)
; pcs      = output array containing pcs  (time,cutoff)
; svls     = output array containing the singular values (cutoff)
; fve      = output array containing the fractional variance of the
;            input array explained by a given EOF (cutoff)


; METHOD:
;
; See also Dan's website (at top of this page)
; 
; The EOFs of a series of vectors are the eignvectors of the covarince
; matrix. Suppose we have a series of data vectors of length N and
; that we put them into a matrix X of size an N x ntimes, then we want
; the matrix E such that
;
;                 C.E = E.L
;
; where the covariance matrix C=X.X^H/(N-1) and the diagonal matrix L
; contains the eigenvalues (H=complex conjugate transpose).
;
; Here the singular value decomposition routine SVDC is used to express
; X as
;
;                 X = U.W.V^H
;
; where U and V are orthogonal martices and W is diagonal. Then the
; covariance matrix C satifies
;
;                 C = U.W^2.U^H
;
; so that the eigenvectors we're after are just U, and the eigenvalues
; are the square root of the elements in W. V contains the principal
; component coefficients.
;
; The eigenvalues given by W are related to the fraction of variance
; explained by each EOF. This is used to sort the EOFs in decreasing
; FVE order with the routine SVDSRT.

;------------------------------------------------------------------------------

PRINT, ''
PRINT, 'Calling EOFCALC'
PRINT, '---------------'

; Find out the dimensions of field
  s=SIZE(field)
  nlons=s[1]
  nlats=s[2]
  ntims=s[3]

; Applying latitude weighting if lats is given
  IF N_ELEMENTS(lats) NE 0 THEN BEGIN
     PRINT, 'Using latitudinal weighting'
     fac=!pi/180.
     FOR j=0,nlats-1 DO BEGIN
        cfac=SQRT(ABS(COS(lats[j]*fac)))
        field[*,j,*]=field[*,j,*]*cfac
     ENDFOR
  ENDIF ELSE PRINT, 'Not using latitudinal weighting'

; Reform data into a 2d array and remove time mean (data is X)
  data=REFORM(field,nlons*nlats,ntims)
  FOR i=0,nlons*nlats-1 DO $
     data[i,*]=data[i,*]-TOTAL(data[i,*])/ntims

; If complex EOF is required then set the imaginary part of X equal to
; the Hilbert transform of X (from now on data is a complex variable)
  IF N_ELEMENTS(complex) NE 0 THEN BEGIN
     PRINT, 'Calculating complex EOF'
     datatemp = COMPLEXARR(nlons*nlats,ntims)
     FOR i=0,nlons*nlats-1 DO $
        datatemp[i,*] = COMPLEX(data[i,*],HILBERT(data[i,*]))
     data = datatemp
  ENDIF        

; Find the total sum of variances (Tr(X.X^T))
  tr=0
  FOR i=0,nlons*nlats-1 DO $
     tr=tr+TOTAL(ABS(data[i,*])^2)

; Perform the SVD and sort the output
;IF N_ELEMENTS(complex) THEN BEGIN
   LA_SVD, TRANSPOSE(data),w,u,v         ; Complex version (check have done the transpose right!)
   u = TRANSPOSE(u)
   v = TRANSPOSE(v)
;ENDIF ELSE BEGIN
;   SVDC, data,w,u,v,/COLUMN     ; A faster routine for real arguments (this is Dan's original version)
;ENDELSE
SVDSRT,w,u,v,/COLUMN

; Keep only a subset of the EOFs if cutoff is given
  IF N_ELEMENTS(cutoff) GT 0 THEN BEGIN
     u=u[*,0:cutoff-1]
     w=w[0:cutoff-1]
     v=v[*,0:cutoff-1]
  ENDIF ELSE cutoff = ntims

  eofs=REFORM(u,nlons,nlats,cutoff)
  pcs=v
  svls=w
  FVE=(svls*svls)/tr

; Print a check to screen
  PRINT, 'CHECK. Sum of the first '+STRTRIM(cutoff,2)+' space variance(s): ',total(w*w)/(ntims-1)
  PRINT, '       Trace of the covariance matrix:       ',tr/(ntims-1)

; Latitude de-weight if lats is given 
  IF N_ELEMENTS(lats) NE 0 THEN BEGIN
     FOR j=0,nlats-1 DO BEGIN
        cfac=1./SQRT(ABS(COS(lats[j]*fac))) 
        eofs[*,j,*]=eofs[*,j,*]*cfac 
        field[*,j,*]=field[*,j,*]*cfac
     ENDFOR
  ENDIF

END
