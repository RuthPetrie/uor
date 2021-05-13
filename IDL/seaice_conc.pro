PRO seaice_conc
PSOPEN 
CS, SCALE=1
MAP
LEVS, MIN=0, MAX=1, STEP=0.1, NDECS =1
CON, F=SF('seaice_24_07_2009.nc', 'iceconc', t=10073.5), TITLE='Jan 1987', CB_TITLE='Temperature (Celsius)'
PSCLOSE
END

