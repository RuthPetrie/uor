PRO PLT_NHPS_SEASONALLY, OFILE=ofile, CTRLEXPT=ctrl, CTRL_STDS=ctrl_std, $
          DIFFVAR=diff, LONGS=longs, LATS=lats, TITLE=title, VAR=var, $
          CBCTRL_TITLE=cb_ctrl_title, CBDIFFTITLE=cb_diff_title,$
          LATMIN=latmin, SIGNIF=sig, SIGLEVEL=sig_level, $
          CTRLCSCALE=ctrl_cscale, CTRLMINVAL=ctrl_minval, CTRLMAXVAL=ctrl_maxval, $
          CTRLSTEPSIZE=ctrl_stepsize, CTRLUNITS=ctrl_units, CTRLNDECS=ctrl_ndecs, $
          CTRLSTD_MAX=ctrl_std_max, CTRLSTDSTEP=ctrl_std_step, $
          DIFFCSCALE=diff_cscale, DIFFLEVS=diff_levels, DIFFNCOLS=diff_ncols, $
          DIFFNDECS=diff_ndecs, FLAGTTEST=flag_ttest, SEASONS=seasons

;**************************************************************************************************
;
;  PLOT GLOBAL BIMONTHLY PLOTS 
;  IN A PORTRAIT ORIENTATION
;  WITH TWO COLUMNS WHERE 
;  COL 1 = CTRL
;  COL 2 = PERT-CTRL
;  
;
;**************************************************************************************************
;-------------------------------------------------------------------------------------------------

nt=N_ELEMENTS(CTRL(0,0,*))

;**************************************************************************************************
PSOPEN, XPLOTS=nt, YPLOTS=2, /EPS, CCOLOUR=7, XSPACING=200, YSPACING=3200, MARGIN=2000,$
        CHARSIZE=130, SPACE3=200, FILE=ofile
;**************************************************************************************************

y=2
s=0

mean_ncols=((ctrl_maxval - ctrl_minval)/ctrl_stepsize)+2


; MEAN VALUES
FOR x=1,nt DO BEGIN

  ;====================================================================================
  POS, XPOS=x, YPOS=y
  CS, SCALE=ctrl_cscale, NCOLS=mean_ncols
  MAP, /NH, LATMIN=latmin
  LEVS, MIN=ctrl_minval, MAX=ctrl_maxval, STEP=ctrl_stepsize, NDECS=ctrl_ndecs

  IF x EQ 1 THEN BEGIN
    CON, F=ctrl(*,*,s), X=longs, Y=lats, $
        /NOLINES, /NOAXES, /NOCOLBAR, $
        LEFT_LABEL=STRUPCASE(var)+'!c!cCTRL', TITLE = seasons(s)
  ENDIF ELSE BEGIN
    CON, F=ctrl(*,*,s), X=longs, Y=lats, $
        /NOLINES, /NOAXES, /NOCOLBAR, $
        TITLE = seasons(s)
  END
  AXES, /NOTICKS,/NOLABELS
  
  LEVS, MIN=0, MAX=ctrl_std_max, STEP=ctrl_std_step
;  MAP, /NH, LATMIN=latmin
  CON, F=ctrl_std(*,*,s), X=longs, Y=lats, /NOFILL, /NOAXES
  AXES, /NOTICKS,/NOLABELS

  CS, SCALE=7
  MAP, /NH, LATMIN=latmin,/DRAW
  AXES, /NOTICKS,/NOLABELS
  
  CS, SCALE=ctrl_cscale, NCOLS=mean_ncols
  LEVS, MIN=ctrl_minval, MAX=ctrl_maxval, STEP=ctrl_stepsize, NDECS=ctrl_ndecs
  COLBAR, COORDS=[4200,11200,25200,11500],TITLE=var+' '+ctrl_units
  ;====================================================================================
  s=s+1   ;increment season index 
ENDFOR
  
y=1
s=0
; DIFFERENCE PLOTS


FOR x=1,nt DO BEGIN

  ;====================================================================================
  POS, XPOS=x, YPOS=y

  ; SET UP FOR CONTOUR PLOT
  CS, SCALE=diff_cscale, NCOLS=diff_ncols
  MAP, /NH, LATMIN=latmin, LATMAX=90
  LEVS, MANUAL=diff_levels, NDECS=diff_ndecs
  
  ; only include left label on lefthand plot.
  IF x EQ 1 THEN BEGIN
    CON, F=diff(*,*,s), X=longs, Y=lats, $
        /NOLINES, TITLE = seasons(s), $
        LEFT_LABEL=STRUPCASE(var)+'!c!cDIFF', /NOAXES, /NOCOLBAR
  ENDIF ELSE BEGIN
    CON, F=diff(*,*,s), X=longs, Y=lats, $
        /NOLINES, /NOAXES, /NOCOLBAR, $
        TITLE = seasons(s)
  END
  AXES, /NOTICKS,/NOLABELS
  
  IF flag_ttest EQ 'yes' THEN BEGIN
    PFILL, F=sig(*,*,s), X=longs, Y=lats,     $
            MIN=0.0, MAX=sig_level, STYLE=0, SIZE=75, LATMIN=latmin
    AXES, /NOTICKS,/NOLABELS
  ENDIF

  CS, SCALE=7
  MAP, /NH, LATMIN=latmin, /DRAW;
  AXES, /NOTICKS,/NOLABELS


  CS, SCALE=diff_cscale, NCOLS=diff_ncols
  LEVS, MANUAL=diff_levels, NDECS=diff_ndecs
  COLBAR, COORDS=[4200,1500,25200,1800],TITLE=var+' '+ctrl_units
  ;====================================================================================
  s=s+1 ; increment seasonal index
ENDFOR


;**************************************************************************************************
PSCLOSE, /BACK
PRINT, 'OUTPUT FILE:'
PRINT, ofile

;===================================================================================================
; END OF ROUTINE
END
