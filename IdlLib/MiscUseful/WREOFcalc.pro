PRO	WR_EOFcalc, fname1,fout,lonnm,latnm,timnm,fieldnm,ll,cut_off 

;modified to avoid missingvalues
; 20 Jun 2008 - Dan


; reads in NetCDF file and writes out EOFs

; fname1    = file name of input field
; fout      = file name of output field
; lonnm     = name of longitude variable
; latnm     = name of latitude variable
; timnm     = name of time variable
; fieldnm   = name of field variable
; ll        = vector of coordinates of subset of data (lon1,lon2,lat1,lat2)
; cut_off   = number of EOFs to retain (max: the number of time
;             points)


	ID=ncdf_open(fname1)
	NCDF_ATTGET,ID,timnm,'units',timun

	timun=string(timun)

        read_data,fname1,fieldnm,lonnm,latnm,timnm,ll,field,lons,lats,tims


; calculate EOFs

	EOFcalc,field,lats,eofs,pcs,svls,FVE,cut_off;,MISSING=missing_value

; write out EOFS

	wr_eof,lats,lons,tims,eofs,pcs,svls(0:cut_off-1,*),FVE,fout,timun,fun,cut_off
	

END



; read data
PRO read_data,fname1,fieldnm,lonnm,latnm,timnm,ll,field,lons,lats,tims



id=NCDF_OPEN(fname1)

ncdf_varget,id,lonnm,lons
ncdf_varget,id,latnm,lats
ncdf_varget,id,timnm,tims

;work out subset of coordinates
i0=where(float(lons) eq ll(0))
i1=where(float(lons) eq ll(1))
j0=where(float(lats) eq ll(2))
j1=where(float(lats) eq ll(3))

lons=lons(i0:i1)
lats=lats(j0:j1)

nlons=n_elements(lons)
nlats=n_elements(lats)
ntims=n_elements(tims)

;read subset of data
ncdf_varget,id,fieldnm,field,offset=[i0,j0,0],count=[nlons,nlats,ntims]

END



PRO wr_eof,lats,lons,tims,eofs,pcs,svls,FVE,fname,timun,fun,cut_off
        print,'Writing netcdf file'

	Id	= NCDF_CREATE(fname,/CLOBBER)


	rank=findgen(cut_off)
        nlons=n_elements(lons)
        nlats=n_elements(lats)
        ntims=n_elements(tims)
	

	Londim	= NCDF_DIMDEF(Id,'Lons',nlons)
	Latdim	= NCDF_DIMDEF(Id,'Lats',nlats)
	Timdim	= NCDF_DIMDEF(Id,'Tims',ntims)
	Rankdim = NCDF_DIMDEF(Id,'Rank',cut_off)

	LonId	= NCDF_VARDEF(Id,'Lons', [Londim], /FLOAT)
	LatId	= NCDF_VARDEF(Id,'Lats', [Latdim], /FLOAT)
	TimId	= NCDF_VARDEF(Id,'Tims', [Timdim], /FLOAT)
	RankId  = NCDF_VARDEF(Id,'Rank', [Rankdim],/FLOAT)
	EOFId	= NCDF_VARDEF(Id,'EOFS', [Londim,Latdim,Rankdim], /FLOAT)
	
	PCId	= NCDF_VARDEF(Id,'PCS', [Rankdim,Timdim], /FLOAT)

	FVEId	= NCDF_VARDEF(Id,'FVE', [Rankdim], /FLOAT)
	SVLSId	= NCDF_VARDEF(Id,'SVLS', [Rankdim], /FLOAT)


	;	Create some attributes (to tell about our variable)

	NCDF_ATTPUT, Id, LonId, "units", "degrees_east"
	NCDF_ATTPUT, Id, LonId, "modulo", " "
	NCDF_ATTPUT, Id, LonId, "point_spacing", "even"
	NCDF_ATTPUT, Id, LatId, "units", "degrees_north"
	NCDF_ATTPUT, Id, LatId, "point_spacing", "even"
	NCDF_ATTPUT, Id, TimId, "units", timun


	NCDF_ATTPUT, Id, SVLSId, "long_name", "sqrt(variances)"
	NCDF_ATTPUT, Id, FVEId, "long_name", "Frac. of Variance explained by EOF"



	;	Leave definition mode and enter data write mode
	NCDF_CONTROL, Id, /ENDEF

	;	Write the data
	NCDF_VARPUT, Id, LonId, lons
	NCDF_VARPUT, Id, LatId, lats
	NCDF_VARPUT, Id, TimId, tims
	NCDF_VARPUT, Id, RankId,rank
	NCDF_VARPUT, Id, EOFId, eofs
	NCDF_VARPUT, Id, PCId, transpose(pcs)
	NCDF_VARPUT, Id, SVLSId, svls
	NCDF_VARPUT, Id, FVEId, FVE



	;	Done
	NCDF_CLOSE, Id
        print,'The data has been written out'
END



