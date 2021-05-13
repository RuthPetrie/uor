PRO make_model_anims

;****************************************
; PROGRAM TO MAKE AN ANIMATION OF THE 
; TIME EVOLVING MODEL FIELDS OF 
; u,v,w,b' and rho' FROM THE CONV MODEL
;
;
; Version
;----------
; 1.0 - R. Petrie: 29 OCT 2013
;****************************************

; Declare directories
data_dir = '/export/quince/data-05/wx019276/TOYMODELDATA/'
figs_dir = '/home/wx019276/MODELLING/FIGS/

; file input
filename = 'ModelOutput.nc'

; read in data file
d = NCREAD(data_dir+filename)

; figure output name
figname = 'test'

; axes
xlen=360
ylen=60
xaxis=INDGEN(xlen)
yaxis=INDGEN(ylen)

xspacing=30
xpts = xlen/xspacing
xlabels=[INTARR(xpts+1)+INDGEN(xpts+1)*xspacing]

yspacing=10
ypts=ylen/yspacing
ylabels=[INTARR(ypts+1)+INDGEN(ypts+1)*yspacing]

u_scale=5 & u_step=1
v_scale=5 & v_step=1
w_scale=1 & w_step=0.2
rp_scale=1 & rp_step=0.2
bp_scale=0.15 & bp_step=0.03
beff_scale=1 & beff_step=0.2
g_scale=10 & g_step = 2
h_scale=1 & h_step = 0.2


FOR t = 0, N_ELEMENTS(d.time)-1 DO BEGIN

  time_label = STRTRIM(STRING(t, FORMAT='(I02)'),2)
  time_stamp = STRTRIM(STRING((d.time(t))/60, FORMAT='(I06)'),2)
  print, time_label
  cb_scale_fact = 50
  
  
  fileout = figs_dir+figname+'_'+time_label
  ;==================================
  PSOPEN, XPLOTS=2, YPLOTS=4, YSPACING=900, MARGIN=1000, SPACE3=100,$
          SPACE2=200, FILE=fileout+'.eps', /EPS

    ;-----------------------
    ; u
    POS, XPOS=1, YPOS=4
    CS , SCALE=6, NCOLS=12
    LEVS, MIN=-u_scale, MAX=u_scale, STEP=u_step, NDECS=0
    GSET, XMIN=0, XMAX=xlen-1, YMIN=0, YMAX=ylen-1
    CON, F=d.u(*,*,t), X=xaxis, Y=yaxis, /BLOCK, $
         /NOLINES, TITLE='u wind ms!E-1!N', CB_HEIGHT=cb_scale_fact
    AXES, XLABELS=xlabels, XSTEP=xspacing, YLABELS=ylabels, YSTEP=yspacing
    ;-----------------------

    ;-----------------------
    ; v
    POS, XPOS=1, YPOS=3
    CS , SCALE=6, NCOLS=12
    LEVS, MIN=-v_scale, MAX=v_scale, STEP=v_step, NDECS=0
    GSET, XMIN=0, XMAX=xlen-1, YMIN=0, YMAX=ylen-1
    CON, F=d.v(*,*,t), X=xaxis, Y=yaxis, /BLOCK, $
         /NOLINES, TITLE='v wind ms!E-1!N', CB_HEIGHT=cb_scale_fact
    AXES, XLABELS=xlabels, XSTEP=xspacing, YLABELS=ylabels, YSTEP=yspacing
    ;-----------------------

    ;-----------------------
    ; w
    POS, XPOS=1, YPOS=2
    CS , SCALE=6, NCOLS=12
    LEVS, MIN=-w_scale, MAX=w_scale, STEP=w_step, NDECS=1
    GSET, XMIN=0, XMAX=xlen-1, YMIN=0, YMAX=ylen-1
    CON, F=d.w(*,*,t)*10, X=xaxis, Y=yaxis, /BLOCK, $
         /NOLINES, TITLE='w wind x10 ms!E-1!N', CB_HEIGHT=cb_scale_fact
    AXES, XLABELS=xlabels, XSTEP=xspacing, YLABELS=ylabels, YSTEP=yspacing
    ;-----------------------
 
    ;-----------------------
    ; rp
    POS, XPOS=1, YPOS=1
    CS , SCALE=6, NCOLS=12
    LEVS, MIN=-rp_scale, MAX=rp_scale, STEP=rp_step, NDECS=1
    GSET, XMIN=0, XMAX=xlen-1, YMIN=0, YMAX=ylen-1
    CON, F=d.rho_prime(*,*,t)*5000, X=xaxis, Y=yaxis, /BLOCK, $
         /NOLINES, TITLE='density perturbation 5x10!E2!N', CB_HEIGHT=cb_scale_fact
    AXES, XLABELS=xlabels, XSTEP=xspacing, YLABELS=ylabels, YSTEP=yspacing
    ;-----------------------

    ;-----------------------
    ; bp
    POS, XPOS=2, YPOS=4
    CS , SCALE=6, NCOLS=12
    LEVS, MIN=-bp_scale, MAX=bp_scale, STEP=bp_step, NDECS=2
    GSET, XMIN=0, XMAX=xlen-1, YMIN=0, YMAX=ylen-1
    CON, F=d.b_prime(*,*,t), X=xaxis, Y=yaxis, /BLOCK, $
         /NOLINES, TITLE='buoyancy perturbation', CB_HEIGHT=cb_scale_fact
    AXES, XLABELS=xlabels, XSTEP=xspacing, YLABELS=ylabels, YSTEP=yspacing
    ;-----------------------

    ;-----------------------
    ; Effective Buoyancy
    POS, XPOS=2, YPOS=3
    CS , SCALE=6, NCOLS=12
    LEVS, MIN=-beff_scale, MAX=beff_scale, STEP=beff_step, NDECS=1
    GSET, XMIN=0, XMAX=xlen-1, YMIN=0, YMAX=ylen-1
    CON, F=d.b_effective(*,*,t)*1000, X=xaxis, Y=yaxis, /BLOCK, $
         /NOLINES, TITLE='Effective Buoyancy x10!E3!N', CB_HEIGHT=cb_scale_fact
    AXES, XLABELS=xlabels, XSTEP=xspacing, YLABELS=ylabels, YSTEP=yspacing
    ;-----------------------

    ;-----------------------
    ; geostrophic imbalance
    POS, XPOS=2, YPOS=2
    CS , SCALE=6, NCOLS=12
    LEVS, MIN=-g_scale, MAX=g_scale, STEP=g_step, NDECS=1
    GSET, XMIN=0, XMAX=xlen-1, YMIN=0, YMAX=ylen-1
    CON, F=d.geo_imbal(*,*,t), X=xaxis, Y=yaxis, /BLOCK, $
         /NOLINES, TITLE='Geostrophic Imbalance', CB_HEIGHT=cb_scale_fact
    AXES, XLABELS=xlabels, XSTEP=xspacing, YLABELS=ylabels, YSTEP=yspacing
    ;-----------------------

    ;-----------------------
    ; hydrostatic imbalance
    POS, XPOS=2, YPOS=1
    CS , SCALE=6, NCOLS=12
    LEVS, MIN=-h_scale, MAX=h_scale, STEP=h_step, NDECS=1
    GSET, XMIN=0, XMAX=xlen-1, YMIN=0, YMAX=ylen-1
    CON, F=d.hydro_imbal(*,*,t), X=xaxis, Y=yaxis, /BLOCK, $
         /NOLINES, TITLE='Hydrostatic Imbalance', CB_HEIGHT=cb_scale_fact
    AXES, XLABELS=xlabels, XSTEP=xspacing, YLABELS=ylabels, YSTEP=yspacing
    ;-----------------------


    GPLOT,X=15000,Y=20400,TEXT='Time: '+time_stamp+' mins', /DEVICE
  PSCLOSE, /NOVIEW
  ;==================================
  
  ; convert eps to gif  
  convertcmd = 'convert -rotate -90 '+fileout+'.eps'+' '+fileout+'.gif'
  SPAWN, convertcmd

ENDFOR

; make animation and view
makeanim = 'convert -loop 50 -delay 40 '+figs_dir+'test*.gif '+figs_dir+'anim_'+figname+'.gif'
SPAWN, makeanim
SPAWN, 'rm -f '+figs_dir+'*.eps'
SPAWN, 'xanim '+figs_dir+'anim_test.gif &'
SPAWN, 'rm -f '+figs_dir+'test_*.gif'

; END OF PROGRAM
END
