PRO show_cs_cols

scale=INTARR(3, 3)
scale(*, 0)=255
scale(*, 1)=0

col=1
rgbname=''
hsize=1000
ysize=400
xoffset=1500
yoffset=7000
csfile=GETENV('GUIDE_LIB')+'/colour_scales/colournames.txt' 
OPENR, lun, csfile, /GET_LUN

PSOPEN, /PORTRAIT
GSET, XMIN=0, XMAX=10, YMIN=10, YMAX=10
FOR x=0, 9 DO BEGIN
 FOR y=33, 0, -1 DO BEGIN
  IF (col LE 334) THEN BEGIN
   READF,lun, rgbname
   split=STRSPLIT(rgbname, /EXTRACT)
   scale(0,2)=split(1)
   scale(1,2)=split(2)
   scale(2,2)=split(3)
   TVLCT, scale(0, *), scale(1, *), scale(2, *)
   xpts=[x*2000+xoffset, x*2000+xoffset, x*2000+hsize+xoffset, x*2000+hsize+xoffset, x*2000+xoffset]
   ypts=[y*500+yoffset, y*500+ysize+yoffset, y*500+ysize+yoffset, y*500+yoffset, y*500+yoffset]
   GPLOT, X=xpts, Y=ypts, FILLCOL=2, /DEVICE
   GPLOT, X=x*2000+xoffset-100, Y=y*500+yoffset+160, TEXT=SCROP(col), ALIGN=1.0, VALIGN=0.5, /DEVICE
   col=col+1
  ENDIF
 ENDFOR
ENDFOR


FREE_LUN, lun
PSCLOSE

END
