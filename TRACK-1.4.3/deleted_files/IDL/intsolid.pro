      pro intsolid,lreg,alonin,alatin,func,gs,limits,intfield
;
;     Return the integral of a field over a spherical surface given
;     a set of NEST estimation points which maybe irregularly
;     distributed in longitude and latitude.
;
      alon=alonin
      alat=alatin
      field=func*cos(alat*!pi/180.)

      iplot=0

      if lreg eq 0 then begin   
      
         triangulate,alon,alat,tr,fvalue=field,sphere=soutput,/degrees
         regf=trigrid(field,gs,limits,sphere=soutput,/degrees,/QUINTIC)

         nlon=(limits(2)-limits(0))/gs(0)+1
         nlat=(limits(3)-limits(1))/gs(1)+1
         longrid=findgen(nlon)*gs(0)+limits(0)
         latgrid=findgen(nlat)*gs(1)+limits(1)


         if iplot eq 1 then begin
	    levs=findgen(16)*.5+.5
   	    mlats=findgen(10)*10.
	    map_set,90.,0.,/stereographic,/continents,/isotropic
   	    map_grid,londel=30.,lats=mlats
            contour,regf,longrid,latgrid,/overplot $
                   ,levels=levs

;            plots,alon,alat,psym=4
         endif

      endif else begin

         alat0=alat(0)
         longrid=alon(where(alat eq alat0))
         nlon=n_elements(longrid)
         nlat=n_elements(alat)/nlon
         latgrid=fltarr(nlat)
	 regf=dblarr(nlon,nlat)

         for j=0,nlat-1 do begin
	    latgrid(j)=alat(j*nlon)
            regf(*,j)=field(j*nlon:(j+1)*nlon-1)
         endfor

         if iplot eq 1 then begin
	    levs=findgen(16)*.5+.5
   	    mlats=findgen(10)*10.
	    map_set,0.,0.,/cylindrical,/continents
   	    map_grid,londel=30.,lats=mlats
            contour,regf,longrid,latgrid,/overplot $
                   ,levels=levs
         endif
      
      endelse
;
;     Note that the integrations of the regularly gridded field
;     use a CLOSED Newton-Cotes formula.
;
      intlon=dblarr(nlat)
      for i=0,nlat-1 do begin
         intlon(i)=int_tabulated(longrid*!pi/180.,regf(*,i))
      endfor
      intfield=int_tabulated(latgrid*!pi/180.,intlon)

      return
      end
