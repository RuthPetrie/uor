PRO show_cs
;Procedure to show the colour scales in the cs routine

PSOPEN, /PORTRAIT
GSET, XMIN=0, XMAX=10, YMIN=0, YMAX=10
n_scales=44

ncols=[18, 16, 15, 12, 8, 3, 8, 8, 3, 16, 12, 18, 12, 18, 14, 10, 12, 8, 8, 10, 12, 14, 11, 10, 7, 28, 35, 9, 15, 23, $
       14, 15, 12, 17, 16, 16, 20, 22, 14, 16, 20, 18, 12, 12]

;ncols=[18, 17, 14, 14, 18, 16, 12, 17, 17, 14, 19, 18, 18, 23, 10, 25, 26, 23, 23, 20, 14, 14, 18, 12, 30, 37, 11, 17, 25, 10]
;       14, 15, 12, 17, 16, 16, 20, 22, 14, 16, 20, 18, 12, 12]
 
vert=350
space=300
FOR iscale=1, n_scales DO BEGIN
 n=iscale
 CS,SCALE=n
 ;levs=INDGEN(ncols(n-1)+1)
 LEVS, MANUAL=INDGEN(ncols(n-1)+1), /EXACT
 barlimits=[4600,30000-((n+1)*(vert))-n*space,20000,30000-n*(vert)-n*space] 
 
 GPLOT, X=500, Y= barlimits(1)+30, TEXT='SCALE='+SCROP(n)+ ' - '+SCROP(ncols(n-1))+' colours', $
        CHARSIZE=90, FONT=3, ALIGN=0.0, /BOLD, /DEVICE

 COLBAR, COORDS=barlimits, /NOTEXT
ENDFOR

PSCLOSE

END

