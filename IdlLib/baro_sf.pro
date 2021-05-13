FUNCTION baro_sf, file, save_flag


;====================================================
; DEFINE GRIDPOINT IDS OF ORCA GRID TO SUBSELECT
i0 = 0;750
j0 = 766;520
k0 = 0
ni = 1442
nj = 255
nk = 75
nt = 1
voffset = [i0, j0, k0, 0]
vcount = [ni, nj, nk, 1]
vcount2 = [ni, nj, nk, nt]
soffset = [i0, j0, 0, 0]
scount = [ni, nj, 1, 1]
;====================================================

;====================================================
PRINT, ' READING MESH MASK DATA'
PRINT, ' '
;READ SUBSET OF MESHFILE
mesh_dir='/net/elm/export/elm/data-06/wx019276/PABLO/barot-streamfunction/'
mesh_file = mesh_dir+'amqlf_mesh_mask_orca025L75_thinned.nc'  ;file with e1v (2D) and e3v (3D) data

mesh_fid = NCDF_OPEN(mesh_file)
e1_vid = NCDF_VARID(mesh_fid, 'e1v')
e3_vid = NCDF_VARID(mesh_fid, 'e3v')
NCDF_VARGET, mesh_fid, e1_vid, e1v, offset=voffset[[0, 1, 3]], count=vcount[[0, 1, 3]]
NCDF_VARGET, mesh_fid, e3_vid, e3v, offset=voffset, count=vcount
NCDF_CLOSE, mesh_fid
;====================================================


;====================================================
; Edited the mask file to remove the Mediterranean, Hudson Bay, and the Baltic by Pablo Ortega
maskfile = mesh_dir+'mask.nc' ;mask file with the basin info.
mask_fid = NCDF_OPEN(maskfile)
maskid = NCDF_VARID(mask_fid, 'tmaskatl')
smaskid = NCDF_VARID(mask_fid, 'vosaline')
nav_latid = NCDF_VARID(mask_fid, 'nav_lat')
nav_lonid = NCDF_VARID(mask_fid, 'nav_lon')
NCDF_VARGET, mask_fid, nav_latid, sublats, offset=voffset[[0, 1]], count=vcount[[0, 1]]
NCDF_VARGET, mask_fid, nav_lonid, sublons, offset=voffset[[0, 1]], count=vcount[[0, 1]]
NCDF_VARGET, mask_fid, maskid, mask, offset=voffset[[0, 1]], count=vcount[[0, 1]]
NCDF_VARGET, mask_fid, smaskid, salmask, offset=soffset[[0,1,2,3]], count=scount[[0,1,2,3]]
NCDF_CLOSE, mask_fid

IF save_flag EQ 'yes' THEN BEGIN
 SAVE, sublats, FILENAME='/home/wx019276/teacosi/idl_plotting/coupled_um_expts/ocean_analysis/sublats.sav'
 SAVE, sublons, FILENAME='/home/wx019276/teacosi/idl_plotting/coupled_um_expts/ocean_analysis/sublons.sav'
ENDIF

;
PRINT, ' END GETTING MESH MASK DATA'
PRINT, ' '
;====================================================


;====================================================
PRINT, ' READING FILE: '

bsf = FLTARR(ni, nj)
fid = NCDF_OPEN(file)
vid = NCDF_VARID(fid, 'vomecrty')
NCDF_VARGET, fid, vid, vvel, offset=voffset, count=vcount2
NCDF_CLOSE, fid
PRINT, ' READ'
PRINT, ' '
;====================================================

;====================================================
;MAKE A MASK USING VELOCITY DATA

vvel_mask = vvel
ind = WHERE(vvel_mask GT 9e36, count)
vvel_mask[*] = 1.0
IF count GT 0 THEN vvel_mask[ind] = 0.0
vvel_mask = total(vvel_mask, 3, /NAN)
ind = WHERE(vvel_mask lt 0.5, count)
vvel_mask[*] = 1

; This only needs to be rough as coasts are always greater than one grid point thick
vvel_mask = byte(vvel_mask) * mask 

;-----------------------------------------------------------------------------
; Make some changes to remove small islands which mess up the streamfunction
; ----------------------------------------------------------------------------
vvel_mask2=vvel_mask
vvel_mask2(WHERE(salmask GT 50))=1

;====================================================

;====================================================
PRINT, 'CALCULATING STREAMFUNCTION'

ind = WHERE(vvel GT 9e30, count)
IF count GT 0 THEN vvel[ind] = 0.

baro_in = vvel[*, *,0]

FOR jj=0, nj-1 DO BEGIN

  vert_tot = TOTAL(vvel[*,jj,*] * e3v[*,jj,*], 3, /NAN)

  FOR ii=1, ni-1 DO BEGIN
 
    IF vvel_mask2[ii, jj] EQ 0 THEN baro_in[ii, jj] = 0. ELSE baro_in[ii, jj] = baro_in[ii-1, jj] + vert_tot[ii] * e1v[ii, jj]
   
  ENDFOR
ENDFOR

bsf[*,*,0] = baro_in[*, *]*mask / 1e6
;====================================================


RETURN, bsf


END

