PRO PLT_NHPS_BIMONTHLY, OFILE=ofile, CTRLEXPT=ctrl, CTRL_STDS=ctrl_std, $
          DIFFVAR=diff, LONGS=longs, LATS=lats, TITLE=title, VAR=var, $
          CBCTRL_TITLE=cb_ctrl_title, CBDIFFTITLE=cb_diff_title,$
          LATMIN=latmin, SIGNIF=sig, SIGLEVEL=sig_level, $
          CTRLCSCALE=ctrl_cscale, CTRLMINVAL=ctrl_min, CTRLMAXVAL=ctrl_max, $
          CTRLSTEPSIZE=ctrl_step, CTRLUNITS=units, CTRLNDECS=ctrl_ndecs, $
          CTRLSTD_MAX=ctrl_std_max, CTRLSTDSTEP=ctrl_std_step, $
          DIFFCSCALE=diff_cscale, DIFFLEVS=diff_levels, DIFFNCOLS=diff_ncols, $
          DIFFNDECS=diff_ndecs, FLAGTTEST=flag_ttest 

;**************************************************************************************************
;
;  PLOT NORTHERN HEMISHPERE POLAR STEREOGRAPHIC
;  BIMONTHLY PLOTS IN A LANDSCAPE ORIENTATION
;  WITH TWO ROWS WHERE 
;  ROW 1 = CTRL
;  ROW 2 = PERT-CTRL
;  
;
;**************************************************************************************************
;-------------------------------------------------------------------------------------------------
mons=['AM','JJ','AS','ON','DJ','FM']
nt=N_ELEMENTS(CTRL(0,0,*))

PSOPEN, XPLOTS=nt, YPLOTS=2, XSPACING=100, YSPACING=0, MARGIN=1500, $
        XOFFSET=500, YOFFSET=2500, CHARSIZE=150, SPACE3=400, /EPS, FILE=ofile
;-------------------------------------------------------------------------------------------------
; Set up for plotting
y=2
s=0
mean_ncols=((ctrl_max-ctrl_min)/ctrl_step )+2
FOR x=1,nt DO BEGIN

  ;====================================================================================
  POS, XPOS=x, YPOS=y
                    
  ; SET UP FOR CONTOUR PLOT
  CS, SCALE=ctrl_cscale, NCOLS=mean_ncols
  MAP, /NH, LATMIN=latmin, LATMAX=90
  LEVS, MIN=ctrl_min, MAX=ctrl_max, STEP=ctrl_step, NDECS=ctrl_ndecs
 
  ; MAKE CONTOUR PLOT OF SAT, INCLUDE TITLE ON TOP PLOT ONLY
  IF x EQ 1 THEN BEGIN
    CON, F=ctrl(*,*,s), X=longs, Y=lats, $
        /NOLINES, /NOAXES, /NOCOLBAR, $
        LEFT_LABEL=' CTRL', TITLE = mons(s)
  ENDIF ELSE BEGIN
  CON, F=ctrl(*,*,s), X=longs, Y=lats, $
        /NOLINES, /NOAXES, /NOCOLBAR, $
        TITLE = mons(s)
  ENDELSE
  AXES, /NOTICKS,/NOLABELS
  
  ; LINE PLOT OF STANDARD DEVIATIONS
  LEVS, MIN=0, MAX=ctrl_std_max, STEP=ctrl_std_step
  CON, F=ctrl_std(*,*,s), X=longs, Y=lats, $
       /NOFILL, /NOAXES
  AXES, /NOTICKS,/NOLABELS

  ; ADD CONTINENTS IN GREY SHADE
  CS, SCALE=7
  MAP, /NH, LATMIN=latmin, LATMAX=90, /DRAW
  AXES, /NOTICKS,/NOLABELS
  
  ; ADD COLOUR BAR 
  CS, SCALE=ctrl_cscale, NCOLS=mean_ncols
  LEVS, MIN=ctrl_min, MAX=ctrl_max, STEP=ctrl_step, NDECS=ctrl_ndecs
  COLBAR, COORDS=[4300,10000,25400,10300],TITLE=VAR+' '+units
  ;====================================================================================
  s = s+1   ; increment season index
ENDFOR

; ROW 2 THE DIFFERENCES
 
y=1 ; set col number
s=0 ; reset monthly index 

FOR x=1,nt DO BEGIN

  ;====================================================================================
  POS, XPOS=x, YPOS=y
  
  ; SET UP FOR CONTOUR PLOT
  CS, SCALE=diff_cscale, NCOLS=diff_ncols
  MAP, /NH, LATMIN=latmin, LATMAX=90
  LEVS, MANUAL=diff_levels, NDECS=diff_ndecs

  ; DO CONTOUR PLOT, TITLE ON TOP PLOT ONLY
  IF x EQ 1 THEN BEGIN
    CON, F=diff(*,*,s), X=longs, Y=lats, $
        /NOLINES,  /NOCOLBAR, /NOAXES, $
        LEFT_LABEL ='PERT!c    -    !cCTRL'
  ENDIF ELSE BEGIN
    CON, F=diff(*,*,s), X=longs, Y=lats, $
        /NOLINES,  /NOCOLBAR, /NOAXES
  ENDELSE
  AXES, /NOTICKS,/NOLABELS

  IF flag_ttest EQ 'yes' THEN BEGIN
; STIPPLE SIGNIFICANCE
  PFILL, F=sig(*,*,s), X=longs, Y=lats,     $
          MIN=0.0, MAX=sig_level, STYLE=0, SIZE=75, LATMIN=latmin
  AXES, /NOTICKS,/NOLABELS
  ENDIF
  
  ; ADD CONTINENTS OUTLINE IN GREY SCALE
  CS, SCALE=7
  MAP, /NH, LATMIN=latmin, LATMAX=90,/DRAW
  AXES, /NOTICKS,/NOLABELS

  ; ADD COLOUR BAR
  CS, SCALE=diff_cscale, NCOLS=diff_ncols
  LEVS, MANUAL=diff_levels, NDECS=diff_ndecs
  COLBAR, COORDS=[4300,2500,25400,2800],TITLE=VAR+' '+units
  ;====================================================================================
  s=s+1     ; increment bimonthly index
ENDFOR

GPLOT, X=4000, Y=19000, TEXT=title, ALIGN=0.0, /DEVICE

;**************************************************************************************************
PSCLOSE, /BACK
PRINT, 'OUTPUT FILE:'
PRINT, ofile
;**************************************************************************************************


END 


