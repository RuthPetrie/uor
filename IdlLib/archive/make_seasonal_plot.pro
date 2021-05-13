FUNCTION MAKE_SEASONAL_PLOT, variable, latitudes, longitudes, filename, projection, $
                             colourscale, latminimum, view, colbartitle, fig_title


PSOPEN, XPLOTS=2 ,YPLOTS=2, XOFFSET= 1000,  YSPACING = 1500, XSPACING = 1500, MARGIN=2500,  $  
        SPACE2 = 100, SPACE3 = 100, TICKLEN = 0, FILE = filename
  
  
  ; Loop over all plot positions and months
  ;---------------------------------------         
  t = -1 
  FOR yy = 0,1 DO BEGIN 

  IF yy EQ 0 THEN yp = 2
  IF yy EQ 1 THEN yp = 1

    FOR xx = 0,1 DO BEGIN
      xp = xx+1
      t = t+1
      
      ; Set colour scale
      ;------------------
      IF colourscale EQ 'ice' THEN BEGIN
        CS, SCALE=24, NCOLS = 10, WHITE = 2
        LEVS, MANUAL=['0.0','0.15','0.3','0.4','0.5','0.6','0.7','0.8','0.9'], /UPPER
      ENDIF
      
      IF colourscale EQ 'icediff' THEN BEGIN
        CS, SCALE=6, NCOLS=13
        LEVS, MANUAL = [-0.5, -0.4, -0.3, -0.15, -0.1, -0.05, 0.05, 0.1, 0.15, 0.3, 0.4, 0.5], NDECS = 2
      ENDIF
      
      IF colourscale EQ 'temp' THEN BEGIN
         CS, SCALE=1, NCOLS =22 
         LEVS, MIN = -40, MAX = 40, STEP = 4, NDECS = 0
      ENDIF

      IF colourscale EQ 'tempdiff' THEN BEGIN
         CS, SCALE=6, NCOLS = 15, WHITE = 8 
         LEVS, MIN = -3, MAX = 3, STEP = 0.5, NDECS = 1
      ENDIF

      IF colourscale EQ 'mslp' THEN BEGIN
         CS, SCALE=1, NCOLS =22 
         LEVS, MIN = 990, MAX = 1030, STEP = 2, NDECS = 0
      ENDIF

      IF colourscale EQ 'mslpdiff' THEN BEGIN
         CS, SCALE=6, NCOLS = 11
         LEVS, MANUAL = [-6,-4, -2, -1, -0.5, 0.5, 1, 2, 4, 6], NDECS = 1
     ENDIF
      
      IF colourscale EQ 'z' THEN BEGIN
         CS, SCALE=1, NCOLS =22 
         LEVS, MIN = 4900, MAX = 5900, STEP =50, NDECS = 0
      ENDIF

      IF colourscale EQ 'zdiff' THEN BEGIN
         CS, SCALE=6, NCOLS = 11
         LEVS, MANUAL = [-40,-30, -20, -10, -5, 5, 10, 20, 30, 40], NDECS=1
      ENDIF

      IF colourscale EQ 'signif' THEN BEGIN
         CS, SCALE=1, NCOLS = 6, WHITE = 2 
         LEVS, MIN = 0.0, MAX = 0.25, STEP = 0.05, NDECS=2, /UPPER
      ENDIF


      ; Set Position
      ;--------------
      POS, XPOS=xp, YPOS=yp 
  
      ; Set map/plot
      ;------------------
      IF projection EQ 'global' THEN MAP, LATMIN= -90, LATMAX=90  
      IF projection EQ 'polar' THEN MAP, /NH, LATMIN= latminimum, LATMAX=90  
      ;GSET, XMIN = -90, XMAX = 90, YMIN = 1000, YMAX = 0 
      
      ; Make plot
      ;----------
      PRINT, STR_SEAS(t)
      CON, F= variable(*,*,t), X = longitudes, Y = latitudes, $
          TITLE=STR_SEAS(t), /NOCOLBAR, /NOAXES, /NOLINES
      IF projection EQ 'polar' THEN AXES, /NOLABELS
      IF projection EQ 'global' THEN AXES

    ENDFOR
  ENDFOR
  
;Insert colourbar
COLBAR, COORDS=[6850,1200,22850,1500], TITLE=colbartitle, /ALT
  
GPLOT, X =3500,  Y = 19500, TEXT = fig_title, FONT = 1, ALIGN =0.0, CHARSIZE = 150, /DEVICE
GPLOT, X =27000, Y = 19500, TEXT = SYSTIME(/UTC), FONT = 1, ALIGN =1.0, CHARSIZE = 85, /DEVICE
GPLOT, X =27000, Y = 19100, TEXT = filename, FONT = 1, ALIGN =1.0, CHARSIZE = 85, /DEVICE

IF view EQ 'yes' THEN PSCLOSE
IF view EQ 'no' THEN PSCLOSE, /NOVIEW

complete = 'yes'

RETURN, complete

END

