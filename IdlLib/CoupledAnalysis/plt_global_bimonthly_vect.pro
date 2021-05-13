PRO PLT_GLOBAL_BIMONTHLY_VECT, OFILE=ofile, CTRLEXPTX=ctrlx, CTRLEXPTY=ctrly, $
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
mons=['AM','JJ','AS','ON','DJ','FM']

nt=N_ELEMENTS(ctrlx(0,0,*))

;**************************************************************************************************
PSOPEN, XPLOTS=2, YPLOTS=nt, /EPS, CCOLOUR=7, XSPACING=200, YSPACING=200, $
        MARGIN=2000, CHARSIZE=150, SPACE3=200,/PORTRAIT, FILE=ofile
;**************************************************************************************************

x=1
s=0

mean_ncols=((ctrl_maxval - ctrl_minval)/ctrl_stepsize)+2


; MEAN VALUES
FOR y=nt,1,-1 DO BEGIN

  ;====================================================================================
  POS, XPOS=x, YPOS=y
  CS, SCALE=ctrl_cscale, NCOLS=mean_ncols, WHITE=2
  MAP
  LEVS, MIN=ctrl_minval, MAX=ctrl_maxval, STEP=ctrl_stepsize, NDECS=ctrl_ndecs, /UPPER

  IF y EQ nt THEN BEGIN
    CON, F=ctrlmag(*,*,s), X=longs, Y=lats, /NOLINES, /NOAXES, $
         /NOCOLBAR, TITLE='Surface wind stress',LEFT_LABEL = mons(s)
    
    VECT, U=ctrlx(*,*,s), V=ctrly(*,*,s), X=longs, Y=lats, mag='0.1', STRIDE=5, munits='(Nm!E2!N)',$
          LEGPOS=4, /NOLEGBOX
  ENDIF ELSE BEGIN
    CON, F=ctrlmag(*,*,s), X=longs, Y=lats, /NOLINES, /NOAXES, $
         /NOCOLBAR, LEFT_LABEL = mons(s)
    
    VECT, U=ctrlx(*,*,s), V=ctrly(*,*,s), X=longs, Y=lats, STRIDE=5, /NOLEGEND
  END
  AXES, /NOTICKS,/NOLABELS
  
  LEVS, MIN=0, MAX=ctrl_std_max, STEP=ctrl_std_step
  CON, F=ctrl_std(*,*,s), X=longs, Y=lats, /NOFILL, /NOAXES
  AXES, /NOTICKS,/NOLABELS

  CS, SCALE=7
  MAP, /DRAW
  AXES, /NOTICKS,/NOLABELS
  
  CS, SCALE=ctrl_cscale, NCOLS=mean_ncols
  LEVS, MIN=ctrl_minval, MAX=ctrl_maxval, STEP=ctrl_stepsize, NDECS=ctrl_ndecs
  COLBAR,COORDS=[1800,1000,10400,1300],TITLE=var+' '+ctrl_units
  ;====================================================================================
  s=s+1   ;increment season index 
ENDFOR
  
x=2
s=0
; DIFFERENCE PLOTS


FOR y=nt,1,-1 DO BEGIN

  ;====================================================================================
  POS, XPOS=x, YPOS=y

  ; SET UP FOR CONTOUR PLOT
  CS, SCALE=diff_cscale, NCOLS=diff_ncols
  MAP;, /NH, LATMIN=latmin, LATMAX=90
  LEVS, MANUAL=diff_levels, NDECS=diff_ndecs
  
  ; only include left label on lefthand plot.
  IF y EQ nt THEN BEGIN
    CON, F=diffmag(*,*,s), X=longs, Y=lats, /NOLINES, /NOAXES, $
         /NOCOLBAR, TITLE='Surface wind stress',LEFT_LABEL = mons(s)
    
    VECT, U=diffx(*,*,s), V=diffy(*,*,s), X=longs, Y=lats, mag='0.05', STRIDE=5, munits='(Nm!E2!N)',$
          LEGPOS=4, /NOLEGBOX
  ENDIF ELSE BEGIN
    CON, F=diffmag(*,*,s), X=longs, Y=lats, /NOLINES, /NOAXES, $
         /NOCOLBAR
    
    VECT, U=diffx(*,*,s), V=diffy(*,*,s), X=longs, Y=lats, STRIDE=5, /NOLEGEND
  END
  AXES, /NOTICKS,/NOLABELS

  
  IF flag_ttest EQ 'yes' THEN BEGIN
  ; STIPPLE SIGNIFICANCE
 ;   CS, SCALE = 28
 ;   PFILL, F=sig(*,*,s), X=longs, Y=lats, COL=8,    $
 ;           MIN=0.0, MAX=sig_level, STYLE=0, SIZE=125
  ; CONTOUR SIGNIFICANCE
    CS, SCALE=28
    MAP
    LEVS, MIN=0.0, MAX=sig_level
    CON, F=sig(*,*,s), X=longs, Y=lats, /NOFILL, /NOLINELABELS, /NOAXES, $
         /NOCOLBAR, POSITIVE_THICK=125, POSITIVE_COL=8
    AXES, /NOTICKS,/NOLABELS
  ENDIF

  CS, SCALE=7
  MAP, /DRAW;
  AXES, /NOTICKS,/NOLABELS


  CS, SCALE=diff_cscale, NCOLS=diff_ncols
  LEVS, MANUAL=diff_levels, NDECS=diff_ndecs
  COLBAR, COORDS=[10600,1000,19200,1300],TITLE=var+' '+ctrl_units, NTH=2
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
