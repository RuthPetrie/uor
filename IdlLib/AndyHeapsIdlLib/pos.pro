PRO pos, XPOS=xpos, YPOS=ypos, XOFFSET=xoffset, YOFFSET=yoffset, XSIZE=xsize, YSIZE=ysize, $
         NP=np
;Procedure to position plots in a postscript file.
;(C) NCAS 2010

;Check !guide structure exists.
DEFSYSV, '!guide', exists=exists
IF (exists EQ 0) THEN BEGIN
 PRINT, ''
 PRINT, 'ERROR - PSOPEN must first be called to initiate a postscript file.'
 PRINT, ''
 STOP
ENDIF

;Get the paper size.
paper_xsize=FLOAT(!D.X_VSIZE) ;Plot x size
paper_ysize=FLOAT(!D.Y_VSIZE) ;Plot y size
IF (N_ELEMENTS(XPOS) EQ 0) THEN xpos=1
IF (N_ELEMENTS(YPOS) EQ 0) THEN ypos=1

 
IF (N_ELEMENTS(xoffset)+N_ELEMENTS(xoffset)+N_ELEMENTS(xoffset)+N_ELEMENTS(xoffset) EQ 0) THEN BEGIN
;Use settings from PSOPEN.

 ;Check xpos, ypos are valid
 IF ((xpos LE 0) OR (ypos LE 0)) THEN BEGIN
  PRINT, ''
  IF (xpos LE 0) THEN PRINT, 'ERROR IN POS - xpos='+SCROP(xpos)+', must be 1 or greater.'
  IF (ypos LE 0) THEN PRINT, 'ERROR IN POS - ypos='+SCROP(ypos)+', must be 1 or greater.'
  PRINT, ''
  STOP
 ENDIF
 IF (xpos GT !guide.xplots) THEN BEGIN
  PRINT, ''
  PRINT, 'ERROR IN POS - xpos='+SCROP(xpos)
  PRINT, 'This is greater than the number of XPLOTS specified to PSOPEN=', SCROP(FIX(!guide.xplots))
  PRINT, ''
  STOP
 ENDIF
 IF (ypos GT !guide.yplots) THEN BEGIN
  PRINT, ''
  PRINT, 'ERROR IN POS - ypos='+SCROP(ypos)
  PRINT, 'This is greater than the number of YPLOTS specified to PSOPEN=', SCROP(FIX(!guide.yplots))
  PRINT, ''
  STOP
 ENDIF

 IF KEYWORD_SET(np) THEN BEGIN
  ERASE
  IF (N_ELEMENTS(xpos) EQ 0) THEN xpos=1
  IF (N_ELEMENTS(ypos) EQ 0) THEN ypos=1
  POS, XPOS=xpos, YPOS=ypos
 ENDIF


 ;Retrieve parameters
 xoffset=!guide.xoffset
 yoffset=!guide.yoffset
 xspacing=!guide.xspacing
 yspacing=!guide.yspacing
 margin=!guide.margin
 xsize=!guide.xsize
 ysize=!guide.ysize
 xplots=!guide.xplots
 yplots=!guide.yplots

 ;Work out the normalised plot area.

 IF (xsize EQ 0) THEN xsize=(paper_xsize-(xoffset+2*margin+xspacing*(xplots-1)))/xplots
 IF (ysize EQ 0) THEN ysize=(paper_ysize-(yoffset+2*margin+yspacing*(yplots-1)))/yplots

 xmin=(margin+xoffset+(xsize+xspacing)*(xpos-1))/paper_xsize
 xmax=xmin+xsize/paper_xsize
 ymin=(margin+yoffset+(ysize+yspacing)*(ypos-1))/paper_ysize
 ymax=ymin+ysize/paper_ysize
 
ENDIF ELSE BEGIN
;Use POS settings
 xmin=xoffset/paper_xsize
 xmax=xmin+xsize/paper_xsize
 ymin=yoffset/paper_ysize
 ymax=ymin+ysize/paper_ysize
ENDELSE

; Set plot position in a system variable.
!guide.position=[xmin,ymin,xmax,ymax]
!p.position=[xmin,ymin,xmax,ymax]

;Reset mapping to be off.
!map.projection=0
!guide.projection=FLOAT(0)
!guide.squareplot=0
!guide.isotropic=0
!guide.coords_established=0
!guide.overplot=0

END

