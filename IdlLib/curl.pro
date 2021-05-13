PRO CURL,ucomp,vcomp,dummy,lons,lats,pflag,ans

; From Rowan 6 Feb 2004

;
; --------------------------------------------------------------------------
;   Given zonal and meridional components of a field this routine calculates 
;   in spherical coordinates the component of the curl normal to both.
;
;   It is assumed that the data are on a regularly spaced lat-lon grid.
;   If pflag is true it is assumed the grid is periodic in longitude
;   with lons(0) and nlons(imax) either size of the Greenwich Meridian.
;
;   Centred differencing is used to calculate the derivatives with
;   the result that dummy values are returned at the northernmost and
;   southernmost latitudes, and at the easternmost and westernmost
;   latitudes if pflag is false.
;
;   Input:  ucomp, vcomp  - 2D arrays
;           dummy         - scalar dummy value used in ucomp, vcomp
;           lons,lats     - 1D array
;           pflag         - logical flag; binary 0 is false, 1 is true
;
;   Output:  ans          - 2D array.  Units are 10^6 SI Units.
;
;   R. Sutton 2 May 1996
; --------------------------------------------------------------------------
;

    print,' '
    print,'PRO CURL:  Calculates the curl of a field'
    print,' '
;
    fac=!pi/180.
    radius=6380000.
    scale=-1.e6/radius
    dellon=(lons(2)-lons(0))*fac
    dellat=(lats(2)-lats(0))*fac
    imax=n_elements(lons)
    jmax=n_elements(lats)
    print,'Data dimensions: ',imax,jmax
    ans=fltarr(imax,jmax,/nozero)
    ans(*)=dummy
;
    print,'Calulating interior points'
    for i=1,imax-2 do begin
        for j=1,jmax-2 do begin
            if (ucomp(i,j+1) ne dummy and ucomp(i,j-1) ne dummy and $
                vcomp(i+1,j) ne dummy and vcomp(i-1,j) ne dummy) then begin
                    ans(i,j)=((cos(lats(j+1)*fac)*ucomp(i,j+1) - $
                       cos(lats(j-1)*fac)*ucomp(i,j-1))/dellat - $
                       (vcomp(i+1,j)-vcomp(i-1,j))/dellon)*$
                       (scale/cos(lats(j)*fac))
            endif
        endfor
    endfor
;
;   Wrap around points
  if (pflag) then begin
    print,'Calulating wrap-around points'
    for j=1,jmax-2 do begin
       if (ucomp(0,j+1) ne dummy and ucomp(0,j-1) ne dummy and $
           vcomp(1,j) ne dummy and vcomp(imax-1,j) ne dummy) then begin
                 ans(0,j)=((cos(lats(j+1)*fac)*ucomp(0,j+1) - $
                    cos(lats(j-1)*fac)*ucomp(0,j-1))/dellat - $
                    (vcomp(1,j)-vcomp(imax-1,j))/dellon)*$
                    (scale/cos(lats(j)*fac))
       endif
       if (ucomp(imax-1,j+1) ne dummy and ucomp(imax-1,j-1) ne dummy and $
           vcomp(0,j) ne dummy and vcomp(imax-2,j) ne dummy) then begin
                 ans(imax-1,j)=((cos(lats(j+1)*fac)*ucomp(imax-1,j+1)-$
                    cos(lats(j-1)*fac)*ucomp(imax-1,j-1))/dellat - $
                    (vcomp(0,j)-vcomp(imax-2,j))/dellon)*$
                       (scale/cos(lats(j)*fac))
       endif
    endfor
  endif
;
end
