; Implements the unix display command with antialiasing

PRO DISPLAY, filename,SCALE=scale,ROTATE=rotate

; Set default options
IF NOT N_ELEMENTS(scale) THEN scale=60
IF NOT N_ELEMENTS(rotate) THEN rotate=90

com = 'display +antialias -density 150 -resize '+STRTRIM(ROUND(scale),2)+'% -rotate -'+STRTRIM(ROUND(rotate),2)+' '+filename+'&'
PRINT, com
SPAWN, com

END
