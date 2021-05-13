PRO loop1
; show the use of string variables to construct filenames

FOR year=1979,2000 DO BEGIN
  stryear=STRTRIM(STRING(year),2)
  myfile='/export/charney/data-01/era-40/monthly_means/'+stryear+$
        '/ggapjan'+stryear+'.nc'
  PRINT, 'reading data for ',year, '  ', myfile
ENDFOR

END

