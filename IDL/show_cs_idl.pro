PRO show_cs_idl
;Procedure to show the colour scales in the cs routine

PSOPEN, /PORTRAIT
n_scales=40
 
vert=350
space=300
FOR iscale=0, n_scales-1 DO BEGIN
 n=iscale
 CS,IDL=n
 levs=INDGEN(253)
 barlimits=[2700,29000-((n+1)*(vert))-n*space,20000,29000-n*(vert)-n*space] 
 GPLOT, X=500, Y=barlimits(1)+30, TEXT='IDL='+SCROP(n), FONT=3, /BOLD, CHARSIZE=75, ALIGN=0.0, /DEVICE
 COLBAR, COORDS=barlimits ,  LEVS=STRARR(N_ELEMENTS(levs)), /NOLINES
ENDFOR

PSCLOSE

END

