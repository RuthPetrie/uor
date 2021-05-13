
PRO seaice2

d = NCREAD('seaice_umdata.nc')
output = 'sea_ice_test.ps' 

; extract date
;date_time = TIMEGEN(10075, UNIT = 'Days',START = JULDAY(8, 1, 1981))
;round(d.t(0))-1; subract 1 due to half days rounding up!


PSOPEN, SPACE3=1000, FILE = output
           
POS, XSIZE = 10000, YSIZE = 10000, XOFFSET = 6000, YOFFSET = 5000
;CS, SCALE=24, NCOLS=12, /REV, WHITE =11
CS, COLS=[470,122,119,140,115,444]
MAP, /NH, LATMIN=60, LATMAX=90
;LEVS, MIN = 0.0, MAX = 1, STEP = 0.1, NDECS = 1, /EXACT
LEVS, MANUAL = ['0.0','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0'], /EXACT
CON, F=SF('seaice_umdata.nc', 'iceconc', t = 10073.5), /NOLINES,$
;CON, F = d.iceconc(*,*,0,0), X= d.longitude, Y = d.latitude, /NOLINES, $
     CB_TITLE='Sea ice fraction', $
     TITLE='24 July 2007';, $
;     /NOCOLBAR
;COLBAR, COORDS = [5000,3000, 17000, 3300], TITLE ='Sea ice fraction'   

;overlay continents in colour
CS, COLS=[308]
MAP, /NH, LATMIN=60, LATMAX=90, LAND = 2, /DRAW                                                                             
GPLOT, X=26700, Y=20000, TEXT=SYSTIME(), FONT=7, ALIGN=1.0, SIZE=150,/DEVICE
GPLOT, X=3000, Y=20000, TEXT='UM seaice AMIP boundary conditions', FONT=7, ALIGN=0.0, SIZE=150,/DEVICE                                        
PSCLOSE; /NOVIEW


;spawn, 'display -rotate -90 sea_ice_test.ps &'
spawn, 'ps2pdf sea_ice_test.ps'
;spawn, 'convert -density 400 -trim sea_ice_test.ps sea_ice_test.png' ; include rotate -90 for landscape figures
;spawn,'acroread sea_ice_test.pdf &'

END
