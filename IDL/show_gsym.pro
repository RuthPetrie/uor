PRO show_gsym

PSOPEN
CS, SCALE=1
offset=2000
space=600
FOR ix=1, 20 DO BEGIN
 i=ix
 PLOTS, i*700+space*ix+offset, offset*2, PSYM=GSYM(i), $
        SYMSIZE=3.0, COLOR=1, /DEVICE
 GPLOT, X= i*700+space*ix+offset, Y=offset*2-1500, TEXT=SCROP(i), $
        ALIGN=0.5, CHARSIZE=200, /DEVICE
 ;XYOUTS, i*700+space*ix+offset, offset*2-1500, SCROP(i), $
 ;       ALIGNMENT=0.5, CHARSIZE=200, COLOR=1, /DEVICE
ENDFOR
PSCLOSE

END
