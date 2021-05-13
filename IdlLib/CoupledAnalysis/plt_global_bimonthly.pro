PRO PLT_GLOBAL_BIMONTHLY, OFILE=ofile, CTRLEXPT=ctrl, CTRL_STDS=ctrl_std, $
          DIFFVAR=diff, LONGS=longs, LATS=lats, TITLE=title, VAR=var, $
          CBCTRL_TITLE=cb_ctrl_title, CBDIFFTITLE=cb_diff_title,$
          LATMIN=latmin, SIGNIF=sig, SIGLEVEL=sig_level, $
          CTRLCSCALE=ctrl_cscale, CTRLMINVAL=ctrl_minval, CTRLMAXVAL=ctrl_maxval, $
          CTRLSTEPSIZE=ctrl_stepsize, CTRLUNITS=ctrl_units, CTRLNDECS=ctrl_ndecs, $
          CTRLSTD_MAX=ctrl_std_max, CTRLSTDSTEP=ctrl_std_step, $
          DIFFCSCALE=diff_cscale, DIFFLEVS=diff_levels, DIFFNCOLS=diff_ncols, $
          DIFFNDECS=diff_ndecs, FLAGTTEST=flag_ttest 

test_inputs='no'

IF test_inputs EQ 'yes' THEN BEGIN
PRINT, 'OFILE',ofile
;PRINT, 'CTRLEXPT',ctrl
;PRINT, 'CTRL_STDS',ctrl_std
;PRINT, 'DIFFVAR',diff
;PRINT, 'LONGS',longs
;PRINT, 'LATS',lats
PRINT, 'TITLE ',title
PRINT, 'VAR ',var
PRINT, 'CBCTRL_TITLE ',cb_ctrl_title
PRINT, 'CBDIFFTITLE ',cb_diff_title
PRINT, 'LATMIN ',latmin
;PRINT, 'SIGNIF ',sig
PRINT, 'SIGLEVEL ',sig_level
PRINT, 'CTRLCSCALE ',ctrl_cscale
PRINT, 'CTRLMINVAL ',ctrl_minval
PRINT, 'CTRLMAXVAL ',ctrl_maxval
PRINT, 'CTRLSTEPSIZE ',ctrl_stepsize
PRINT, 'CTRLUNITS ',ctrl_units
PRINT, 'CTRLNDECS ',ctrl_ndecs
PRINT, 'CTRLSTD_MAX ',ctrl_std_max
PRINT, 'CTRLSTDSTEP ',ctrl_std_step
PRINT, 'DIFFCSCALE ',diff_cscale
PRINT, 'DIFFLEVS ',diff_levels
PRINT, 'DIFFNCOLS ',diff_ncols
PRINT, 'DIFFNDECS ',diff_ndecs
PRINT, 'FLAGTTEST ',flag_ttest 
STOP
ENDIF



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
nt=N_ELEMENTS(CTRL(0,0,*))



;**************************************************************************************************
PSOPEN, XPLOTS=2, YPLOTS=nt, /EPS, CCOLOUR=7, XSPACING=200, YSPACING=200, $
        MARGIN=2000, CHARSIZE=150, SPACE3=200,/PORTRAIT, FILE=ofile
;**************************************************************************************************

s=0
x=1

mean_ncols=FIX(((ctrl_maxval - ctrl_minval)/ctrl_stepsize))+2

FOR y=nt,1,-1 DO BEGIN

  ;====================================================================================
  POS, XPOS=x, YPOS=y
  
  ; SET UP FOR CONTOUR PLOT
  CS, SCALE=ctrl_cscale, NCOLS=mean_ncols
  MAP
  LEVS, MIN=ctrl_minval, MAX=ctrl_maxval, STEP=ctrl_stepsize, NDECS=ctrl_ndecs
 
  ; MAKE CONTOUR PLOT OF SAT, INCLUDE TITLE ON TOP PLOT ONLY
  IF y EQ nt THEN BEGIN
    CON, F=ctrl(*,*,s), X=longs, Y=lats, $
        /NOLINES, /NOAXES, /NOCOLBAR, $
        LEFT_LABEL=mons(s), TITLE = var+': CTRL'
  ENDIF ELSE BEGIN
    CON, F=ctrl(*,*,s), X=longs, Y=lats, $
        /NOLINES, /NOAXES, /NOCOLBAR, $
        LEFT_LABEL=mons(s)
  ENDELSE
  AXES, /NOTICKS,/NOLABELS
  
  ; LINE PLOT OF STANDARD DEVIATIONS
  LEVS, MIN=0, MAX=ctrl_std_max, STEP=ctrl_std_step
  CON, F=ctrl_std(*,*,s), X=longs, Y=lats, /NOFILL, /NOAXES
  AXES, /NOTICKS,/NOLABELS

  ; ADD CONTINENTS IN GREY SHADE
  CS, SCALE=7
  MAP, /DRAW;, /NH, LATMIN=latmin, LATMAX=90, LAND=4,/DRAW
  AXES, /NOTICKS,/NOLABELS
  
  ; ADD COLOUR BAR 
  CS, SCALE=ctrl_cscale, NCOLS=mean_ncols
  LEVS, MIN=ctrl_minval, MAX=ctrl_maxval, STEP=ctrl_stepsize, NDECS=ctrl_ndecs
  COLBAR, COORDS=[1800,1000,10400,1300],TITLE=var+' '+ctrl_units, NTH=2
  ;====================================================================================
  s=s+1     ; increment season index
ENDFOR

; COLUMN 2 THE DIFFERENCES


x=2 ; set col number
s=0 ; reset monthly index 

FOR y=nt,1,-1 DO BEGIN

  ;====================================================================================
  POS, XPOS=x, YPOS=y

  ; SET UP FOR CONTOUR PLOT
  CS, SCALE=diff_cscale, NCOLS=diff_ncols
  MAP;, /NH, LATMIN=latmin, LATMAX=90
  LEVS, MANUAL=diff_levels, NDECS=diff_ndecs

  ; DO CONTOUR PLOT, TITLE ON TOP PLOT ONLY
  IF y EQ nt THEN BEGIN
    CON, F=diff(*,*,s), X=longs, Y=lats, /NOLINES,  /NOCOLBAR, /NOAXES, $
        TITLE =var+': PERT - CTRL'
  ENDIF ELSE BEGIN
    CON, F=diff(*,*,s), X=longs, Y=lats, /NOLINES, /NOCOLBAR, /NOAXES
  ENDELSE
  AXES, /NOTICKS,/NOLABELS

  IF flag_ttest EQ 'yes' THEN BEGIN
  ; STIPPLE SIGNIFICANCE
  PFILL, F=sig(*,*,s), X=longs, Y=lats,     $
          MIN=0.0, MAX=sig_level, STYLE=0, SIZE=75
  AXES, /NOTICKS,/NOLABELS
  ENDIF
  
  ; ADD CONTINENTS OUTLINE IN GREY SCALE
  CS, SCALE=7
  MAP, /DRAW;, /NH, LATMIN=latmin, LATMAX=90, LAND=4,/DRAW
  AXES, /NOTICKS,/NOLABELS

  ; ADD COLOUR BAR
  CS, SCALE=diff_cscale, NCOLS=diff_ncols
  LEVS, MANUAL=diff_levels, NDECS=diff_ndecs
  COLBAR, COORDS=[10600,1000,19200,1300],TITLE=var+' '+ctrl_units
  ;====================================================================================
  s=s+1     ; increment bimonthly index
ENDFOR


PSCLOSE, /BACK
;**************************************************************************************************
PRINT, 'OUTPUT FILE:'
PRINT, ofile
;**************************************************************************************************
END 


