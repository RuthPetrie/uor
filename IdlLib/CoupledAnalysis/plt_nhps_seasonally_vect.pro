PRO PLT_NHPS_SEASONALLY_VECT, OFILE=ofile, CTRLEXPTX=ctrlx, CTRLEXPTY=ctrly, $
          CTRLEXPTMAG=ctrlmag, CTRL_STDS=ctrl_std, $
          DIFFX=diffx, DIFFY=diffy, DIFFVARMAG=diffmag, $
          LONGS=longs, LATS=lats, TITLE=title, VAR=var, $
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

nt=N_ELEMENTS(ctrlx(0,0,*))

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
  CS, SCALE=ctrl_cscale, NCOLS=mean_ncols, WHITE=2
  MAP, /NH, LATMIN=latmin
  LEVS, MIN=ctrl_minval, MAX=ctrl_maxval, STEP=ctrl_stepsize, NDECS=ctrl_ndecs, /UPPER

  IF x EQ 1 THEN BEGIN
    CON, F=ctrlmag(*,*,s), X=longs, Y=lats, /NOLINES, /NOAXES, $
         /NOCOLBAR, LEFT_LABEL='Surface!c!cwind!c!cstress',TITLE = seasons(s)
    
    MAP, /NH, LATMIN=latmin
    VECT, U=ctrlx(*,*,s), V=ctrly(*,*,s), X=longs, Y=lats, mag='0.1', PTS=40, munits='(Nm!E2!N)',$
          LEGPOS=4, /NOLEGBOX
  ENDIF ELSE BEGIN
    CON, F=ctrlmag(*,*,s), X=longs, Y=lats, /NOLINES, /NOAXES, $
         /NOCOLBAR, TITLE = seasons(s)

    MAP, /NH, LATMIN=latmin
    VECT, U=ctrlx(*,*,s), V=ctrly(*,*,s), X=longs, Y=lats,  PTS=40, /NOLEGEND
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
    CON, F=diffmag(*,*,s), X=longs, Y=lats, /NOLINES, /NOAXES, $
         /NOCOLBAR, LEFT_LABEL='Surface!c!cwind!c!cstress',TITLE = seasons(s)
    
    MAP, /NH, LATMIN=latmin
    VECT, U=diffx(*,*,s), V=diffy(*,*,s), X=longs, Y=lats, mag='0.05', PTS=40, munits='(Nm!E2!N)',$
          LEGPOS=4, /NOLEGBOX
  ENDIF ELSE BEGIN
    CON, F=diffmag(*,*,s), X=longs, Y=lats, /NOLINES, /NOAXES, $
         /NOCOLBAR,TITLE = seasons(s)
    
    MAP, /NH, LATMIN=latmin
    VECT, U=diffx(*,*,s), V=diffy(*,*,s), X=longs, Y=lats,  PTS=40, /NOLEGEND
  END
  AXES, /NOTICKS,/NOLABELS
  
  IF flag_ttest EQ 'yes' THEN BEGIN
    ; STIPPLE SIGNIFICANCE
;    CS, SCALE = 28
;    PFILL, F=sig(*,*,s), X=longs, Y=lats, COL=8,    $
;            MIN=0.0, MAX=sig_level, STYLE=0, SIZE=125, LATMIN=latmin
 ;   AXES, /NOTICKS,/NOLABELS

    ; CONTOUR SIGNIFICANCE
    CS, SCALE=28
    MAP, /NH, LATMIN=latmin
    LEVS, MIN=0.0, MAX=sig_level
    CON, F=sig(*,*,s), X=longs, Y=lats, /NOFILL, /NOLINELABELS, /NOAXES, $
         /NOCOLBAR, POSITIVE_THICK=125, POSITIVE_COL=8
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
