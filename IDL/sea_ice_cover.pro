PRO sea_ice_cover

;d = NCREAD('SIC_NDJ_2011_ECMWF_ERAI.nc')
output = 'sea_ice_test.ps' 


PSOPEN, FILE = output
;POS, XSIZE = 10000, YSIZE = 10000, XOFFSET = 6000, YOFFSET = 5000
;CS, SCALE=24, NCOLS=12
CS, COLS=[444,444,115,130,126,121,106,100]
MAP, /NH, LATMIN=60, LATMAX=90
;LEVS, MIN = 0.0001, MAX = 1, STEP = 0.1, NDECS = 1; /EXACT
LEVS, MANUAL = ['0.0','0.01','0.2','0.4','0.6','0.8','1.0']
CON, F=SF('SIC_NDJ_2011_ECMWF_ERAI.nc', 'ci', time = 980304.),$
     CB_TITLE='Sea ice fraction', $
     TITLE='November monthly mean 2011';, $
;     /NOCOLBAR
;COLBAR, COORDS = [5000,3000, 17000, 3300], TITLE ='Sea ice fraction'                                                                                                                                           
PSCLOSE; /NOVIEW


;spawn, 'display -rotate -90 sea_ice_test.ps &'
spawn, 'ps2pdf sea_ice_test.ps'
;spawn, 'convert -density 400 -trim sea_ice_test.ps sea_ice_test.png' ; include rotate -90 for landscape figures
;spawn,'acroread sea_ice_test.pdf &'

END
