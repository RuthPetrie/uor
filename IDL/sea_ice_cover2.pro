PRO sea_ice_cover

;d = NCREAD('seaice_24_07_2009.nc')
output = 'sea_ice_test.ps' 


PSOPEN, FILE = output
;POS, XSIZE = 10000, YSIZE = 10000, XOFFSET = 6000, YOFFSET = 5000
CS, SCALE=24, NCOLS=12
MAP; /NH; LATMIN=50, LATMAX=90
LEVS, MIN = 0, MAX = 1, STEP = 0.1, NDECS = 1; /EXACT
CON, F=SF('seaice_24_07_2009.nc', 'iceconc', t = 10073.5),$
     CB_TITLE='Sea ice fraction', $
     TITLE='July 24 2011';, $
;     /NOCOLBAR
;COLBAR, COORDS = [5000,3000, 17000, 3300], TITLE ='Sea ice fraction'                                                                                                                                           
PSCLOSE, /NOVIEW


spawn, 'display -rotate -90 sea_ice_test.ps &'
spawn, 'ps2pdf sea_ice_test.ps'
;spawn, 'convert -density 400 -trim sea_ice_test.ps sea_ice_test.png' ; include rotate -90 for landscape figures
;spawn,'acroread sea_ice_test.pdf &'

END
