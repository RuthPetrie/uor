PRO seaice_cover_um

d = NCREAD('seaice_umdata.nc')
output = 'sea_ice_test.ps' 

; extract date
;date_time = TIMEGEN(10075, UNIT = 'Days',START = JULDAY(8, 1, 1981))
;round(d.t(0))-1; subract 1 due to half days rounding up!


PSOPEN, XPLOTS=2, YPLOTS=2, XSPACING=1800, YSPACING=2500, SPACE3=1000, $
        XOFFSET=3000, YOFFSET =0, FILE = output

;setup colour-scales and levels
CS, COLS=[112,122,121,120,119,116,115,444]
LEVS, MANUAL = ['0.0','0.01','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0'], /EXACT

POS, XPOS=1, YPOS=2
MAP, /NH, LATMIN=60, LATMAX=90
CON, F = d.iceconc(*,*,0,0), X= d.longitude, Y = d.latitude, /NOLINES, /NOCOLBAR, $
;     CB_TITLE='Sea ice fraction', $
     TITLE='30 August 1981';, $

POS, XPOS=2, YPOS=2
MAP, /NH, LATMIN=60, LATMAX=90
CON, F = d.iceconc(*,*,0,1), X= d.longitude, Y = d.latitude, /NOLINES, /NOCOLBAR, $
;     CB_TITLE='Sea ice fraction', $
     TITLE='1 March 1982';, $

POS, XPOS=1, YPOS=1
MAP, /NH, LATMIN=60, LATMAX=90
CON, F = d.iceconc(*,*,0,0), X= d.longitude, Y = d.latitude, /NOLINES, /NOCOLBAR, $
;     CB_TITLE='Sea ice fraction', $
     TITLE='30 August 1981';, $

POS, XPOS=2, YPOS=1
MAP, /NH, LATMIN=60, LATMAX=90
CON, F = d.iceconc(*,*,0,1), X= d.longitude, Y = d.latitude, /NOLINES, /NOCOLBAR, $
;     CB_TITLE='Sea ice fraction', $
     TITLE='1 March 1982';, $

;insert colorbar
COLBAR, COORDS = [25500, 4500, 26000, 17000], TITLE='Sea ice fraction'

;overlay continents in colour
CS, COLS=[306]

POS, XPOS=1, YPOS=1
MAP, /NH, LATMIN=60, LATMAX=90, LAND = 2, /DRAW
POS, XPOS=2, YPOS=1
MAP, /NH, LATMIN=60, LATMAX=90, LAND = 2, /DRAW

GPLOT, X=26700, Y=20000, TEXT=SYSTIME(), FONT=7, ALIGN=1.0, SIZE=150,/DEVICE
GPLOT, X=3000, Y=20000, TEXT='UM seaice forcing fields', FONT=7, ALIGN=0.0, SIZE=150,/DEVICE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;POS, XSIZE = 10000, YSIZE = 10000, XOFFSET = 6000, YOFFSET = 5000
;CS, SCALE=24, NCOLS=12, /REV, WHITE =11
;CS, COLS=[112,122,121,120,119,116,115,444]
;MAP, /NH, LATMIN=60, LATMAX=90
;LEVS, MIN = 0.0, MAX = 1, STEP = 0.1, NDECS = 1, /EXACT
;LEVS, MANUAL = ['0.0','0.01','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0'], /EXACT
;CON, F=SF('seaice_umdata.nc', 'iceconc', t = 10073.5),$
;CON, F = d.iceconc(*,*,0,0), X= d.longitude, Y = d.latitude, /NOLINES, $
;     CB_TITLE='Sea ice fraction', $
;     TITLE='30 August 1981';, $
;     /NOCOLBAR
;COLBAR, COORDS = [5000,3000, 17000, 3300], TITLE ='Sea ice fraction'   

;overlay continents in colour
;CS, COLS=[306]
;MAP, /NH, LATMIN=60, LATMAX=90, LAND = 2, /DRAW
                                                                                                                                        
PSCLOSE; /NOVIEW


;spawn, 'display -rotate -90 sea_ice_test.ps &'
spawn, 'ps2pdf sea_ice_test.ps'
;spawn, 'convert -density 400 -trim sea_ice_test.ps sea_ice_test.png' ; include rotate -90 for landscape figures
;spawn,'acroread sea_ice_test.pdf &'

END
