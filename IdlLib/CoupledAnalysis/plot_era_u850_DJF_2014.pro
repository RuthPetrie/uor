PRO plot_era_u850_DJF_2014

;===================================================================================================
; DECLARATIONS
;===================================================================================================
@common_variables

;===================================================================================================
; READ DATA
;===================================================================================================
PRINT, 'READING DATA'
PRINT, ' '
era_u_dir='/net/quince/export/quince/data-06/wx019276/era/NEWDATA/U/'

file = era_u_dir+'erai_u850_7905_sm_DJF.nc'
ctrl_u = NCREAD(file)

file = era_u_dir+'erai_u850_0714_sm_DJF.nc'
pert_u = NCREAD(file)

nx=N_ELEMENTS(ctrl_u.longitude)
ny=N_ELEMENTS(ctrl_u.latitude)
ntc=N_ELEMENTS(ctrl_u.t)
ntp=N_ELEMENTS(pert_u.t)
ns=4
ctrl=FLTARR(nx,ny,ns,ntc)
ctrl_sm=FLTARR(nx,ny,ns)
ctrl_std=FLTARR(nx,ny,ns)

pert=FLTARR(nx,ny,ns,ntp)
pert_sm=FLTARR(nx,ny,ns)

snr=FLTARR(nx,ny,ns)
diff=FLTARR(nx,ny,ns)



;===================================================================================================
; READ IN DATA AND CALACULATE STATISTICS
;===================================================================================================
s=0
  seas=strseas(s)

  file = era_u_dir+'erai_u850_7905_sm_'+seas+'.nc'
  PRINT, file
  ctrl_u= NCREAD(file)

  file = era_u_dir+'erai_u850_0714_sm_'+seas+'.nc' 
  pert_u = NCREAD(file)

  ctrl(*,*,s,*)=ctrl_u.U(*,*,0,*)
  pert(*,*,s,*)=pert_u.U(*,*,0,*)
  
  FOR x=0,nx-1 DO BEGIN
    FOR y=0,ny-1 DO BEGIN
  
    ctrl_sm(x,y,s)  = MEAN  ( ctrl(x,y,s,*) )
    ctrl_std(x,y,s) = STDDEV( ctrl(x,y,s,*) )
    pert_sm(x,y,s)  = MEAN  ( pert(x,y,s,*) )
   
    diff(x,y,s) = pert_sm(x,y,s) - ctrl_sm(x,y,s)    
 
    snr(x,y,s) = ABS( diff(x,y,s) ) / ctrl_std(x,y,s)
  
    ENDFOR
  ENDFOR


;===================================================================================================
; PLOT ANNUAL MSLP CYCLE
;===================================================================================================
odir='/home/wx019276/figures/era/u/'
ofile=odir+'u850_'+strseas(s)+'_era_2014_clim.eps'
projection='polar'
latmin=30
plot_var=FLTARR(nx,ny)

PSOPEN, XPLOTS=2 ,YPLOTS=1,/EPS, FILE = ofile, CHARSIZE=125
  

  
FOR x = 1,2 DO BEGIN
   
    ; Set Position
    ;--------------
    POS, XPOS=x, YPOS=1 


;u850_diff_levs = [-5, -3, -2, -1, -0.5, 0.5, 1, 2,3, 5]

    ; Set colour scale
    ;------------------
    IF x EQ 1 THEN BEGIN
      CS, SCALE=u850_nh_cscale, NCOLS=FIX(((u850_nh_maxval - u850_nh_minval)/u850_nh_stepsize))+2
      LEVS, MIN=u850_nh_minval, MAX=u850_nh_maxval, STEP=u850_nh_stepsize, NDECS=globnmslpdecs   
    ENDIF
    IF x EQ 2 THEN BEGIN
      CS, SCALE=u850_diff_cscale, NCOLS=u850_diff_cols_req
      LEVS, MANUAL=u850_diff_levs, NDECS=u850_diff_ndecs
    ENDIF
    
    ; Set map/plot
    ;------------------
    IF projection EQ 'global' THEN MAP, LATMIN= -90, LATMAX=90
    IF projection EQ 'polar' THEN MAP, /NH, LATMIN= latmin, LATMAX=90  

    ; Make Plot
    ;------------------
    IF x EQ 1 THEN plot_var = ctrl_sm(*,*,s) 
    IF x EQ 2 THEN plot_var = diff(*,*,s)
    CON, F=plot_var, X = ctrl_u.longitude, Y = ctrl_u.latitude, $
         /NOAXES, /NOLINES, TITLE=strseas(s)
    AXES, /NOTICKS,/NOLABELS
   
    ; Insert colourbar
    ;-------------------
    IF x EQ 1 THEN cont_snr = 'no'
    IF x EQ 2 THEN cont_snr = 'yes'
    IF cont_snr EQ 'yes' THEN BEGIN
      PFILL, F=snr(*,*,s), X=ctrl_u.longitude, Y=ctrl_u.latitude,     $
            MIN=1.0, MAX=MAX(snr), STYLE=0, SIZE=75, LATMIN=latmin
      AXES, /NOTICKS,/NOLABELS

    ENDIF
  ENDFOR
  PSCLOSE, /BACK  
  print, ofile


;===================================================================================================
; END OF PROGRAM
END
