PRO CS, SCALE=scale, COLS=cols, MIN=min, MAX=max, NCOLS=ncols, VCS=vcs, IDL=idl,$
        FILE=file, OUTFILE=outfile, DRAW=draw, WHITE=white, REV=rev, SAVE=save, $
	MERGE=merge, CLEAR=clear
;Procedure to select colour scales.
;(C) NCAS 2010


; RUTH PETRIE, MODIFIED ON 27th NOVEMBER 2014, TO INCLUDE 45th COLOURSCALE - IT DOESN'T WORK
; IT HAS 5 COLOURS scalecols HAS BEEN AMENDED TO ACCOUNT FOR THIS ALSO CHECK LIMITS HAVE BEEN CHANGED
; csfile ALSO MODIFIED TO PICK UP COLOURSCALES FROM LOCAL DIRECTORY.

;Check !guide structure exists.
DEFSYSV, '!guide', exists=exists
IF ((exists EQ 0)) THEN BEGIN
 PSOPEN
 PSCLOSE, /NOVIEW
ENDIF


;Load selected colour scale if requested.
IF (N_ELEMENTS(scale) NE 0) THEN BEGIN
 IF ((scale LT 1) OR (scale GT 45)) THEN BEGIN
  PRINT, ''
  PRINT, 'CS ERROR - scale not in range 1-45'
  PRINT, ''
  STOP
 ENDIF
 
; csfile=GETENV('GUIDE_LIB')+'/colour_scales/cs'+SCROP(scale)+'.txt'
 csfile='/home/wx019276/IdlLib/AndyHeapsIdlLib/colour_scales/cs'+SCROP(scale)+'.txt'
 IF (STRLOWCASE(!version.os_family) EQ 'windows') THEN csfile=!guide.windows_lib+'\colour_scales\cs'+SCROP(scale)+'.txt'
 rgb=INTARR(256,3)+255
 rgb1=INTARR(3)
 ic=0
 OPENR, lun, csfile, /GET_LUN
 WHILE ~ EOF(lun) DO BEGIN  
  READF, lun, rgb1
  rgb(ic,*)=rgb1
  ic=ic+1
 ENDWHILE
 FREE_LUN, lun
 scalecols=[18, 16, 15, 12, 8, 3, 8, 8, 3, 16, 12, 18, 12, 18, 14, 10, 12, 8, 8, 10, 12, 14, 11, 10, 7, 28, 35, 9, 15, 23, $
            14, 15, 12, 17, 16, 16, 20, 22, 14, 16, 20, 18, 12, 9,5]
 ;scalecols=[18, 17, 14, 14, 18, 16, 12, 17, 17, 14, 19, 18, 18, 23, 10, 25, 26, 23, 23, 20, 14, 14, 18, 12, 30, 37, 11, 17, 25, 10]
 scols=scalecols(scale-1)
 red=rgb(*,0)
 green=rgb(*,1)
 blue=rgb(*,2)
 TVLCT, red, green, blue
ENDIF

;Load an IDL or VCS colour scale.
IF ((N_ELEMENTS(idl) NE 0) OR KEYWORD_SET(VCS)) THEN BEGIN
 IF (N_ELEMENTS(idl) NE 0) THEN BEGIN
  IF ((idl LT 0) OR (idl GT 40)) THEN BEGIN
   PRINT, ''
   PRINT, 'CS ERROR - idl not in range 0-40'
   PRINT, ''
   STOP
  ENDIF
  csfile=GETENV('GUIDE_LIB')+'/colour_scales/idl'+SCROP(idl)+'.txt'
 ENDIF
 scols=254
 IF KEYWORD_SET(VCS) THEN csfile=GETENV('GUIDE_LIB')+'/colour_scales/vcs.txt'
 
 rgb=INTARR(256,3)
 OPENR, lun, csfile, /GET_LUN
 READF, lun, rgb
 FREE_LUN, lun
 plot_cscale=reform(rgb, 3, N_ELEMENTS(rgb)/3)
 red=[255,0, REFORM(plot_cscale(0, 1:254))]
 green=[255,0, REFORM(plot_cscale(1, 1:254))]
 blue=[255,0, REFORM(plot_cscale(2, 1:254))]
 TVLCT, red, green, blue
ENDIF



;Choose colours by number.
IF (N_ELEMENTS(cols) NE 0) THEN BEGIN
 rgbnames=STRARR(549,4)
 rgbname=''
 csfile=GETENV('GUIDE_LIB')+'/colour_scales/colournames.txt' 
 IF (STRLOWCASE(!version.os_family) EQ 'windows') THEN csfile=!guide.windows_lib+'\colour_scales\colournames.txt'
 OPENR, lun, csfile, /GET_LUN
 FOR i=0, 548 DO BEGIN
  READF,lun, rgbname
  split=STRSPLIT(rgbname, /EXTRACT)
  rgbnames(i,*)=split
 ENDFOR
 FREE_LUN, lun

 red=INTARR(255)
 red(0)=255
 green=red
 blue=red
 scols=N_ELEMENTS(cols)
 FOR i=0, scols-1 DO BEGIN
  IF ((cols(i) LT 1) OR (cols(i) GT 549)) THEN BEGIN
   PRINT, ''
   PRINT, 'CS ERROR - requested colour ', cols(i), ' out of range 1-549.'
   PRINT, ''
   STOP
  ENDIF
  red(i+2)=rgbnames(cols(i)-1,1)
  green(i+2)=rgbnames(cols(i)-1,2)
  blue(i+2)=rgbnames(cols(i)-1,3)
 ENDFOR
 ;Change all remaining colours to white.
 red(N_ELEMENTS(cols)+2:254)=255
 green(N_ELEMENTS(cols)+2:254)=255
 blue(N_ELEMENTS(cols)+2:254)=255  
 TVLCT, red, green, blue 
ENDIF


;Interpolate colours.
IF (N_ELEMENTS(ncols) NE 0) THEN BEGIN
 IF (N_ELEMENTS(min) EQ 0) THEN min=2
 IF (N_ELEMENTS(max) EQ 0) THEN max=255
 IF ((MIN LT 2) OR (max GT 255) OR (ncols GT 254)) THEN BEGIN 
  PRINT, ''
  PRINT, 'CS ERROR - MIN, MAX or NCOLS incorrect.'
  PRINT, ''
  PRINT, 'MIN must be >=2 and is ', min
  PRINT, 'MAX must be <=254 and is ', max
  PRINT, 'NCOLS must be <=254 and is ', ncols
  PRINT, ''
  STOP
 ENDIF
 
 step=(scols-1)/253.0
 x1=FINDGEN(scols)
 x2=FINDGEN(254)*step
 red2=[255, 0, INTERPOL(red(2:scols+1), x1, x2)]
 green2=[255, 0, INTERPOL(green(2:scols+1), x1, x2)]
 blue2=[255, 0, INTERPOL(blue(2:scols+1), x1, x2)]
 red3=INTARR(256)+255
 red3(1)=0
 green3=red3
 blue3=red3
 step=(max-min)/FLOAT(ncols-1)
 red2=[255, 0, INTERPOL(red(2:scols+1), x1, x2)]
 green2=[255, 0, INTERPOL(green(2:scols+1), x1, x2)]
 blue2=[255, 0, INTERPOL(blue(2:scols+1), x1, x2)] 
 FOR ix=0, ncols-1 DO BEGIN
  icol=min+ix*step
  red3(ix+2)=red2(icol)
  green3(ix+2)=green2(icol)
  blue3(ix+2)=blue2(icol)
 ENDFOR
 TVLCT, red3, green3, blue3
 scols=ncols
ENDIF


IF (N_ELEMENTS(cols) GT 0) THEN ncols=scols
IF (N_ELEMENTS(scale) EQ 1) AND (N_ELEMENTS(ncols) EQ 0) THEN ncols=scols

;Output scale to a file.
IF (N_ELEMENTS(outfile) NE 0) THEN BEGIN
 TVLCT, red, green, blue, /GET
 OPENW, lun, outfile, /GET_LUN
 FOR j=0, 255 DO BEGIN
  PRINTF, lun, red(j), green(j), blue(j)
 ENDFOR
 FREE_LUN,lun
ENDIF


;Reading in scale from a file.
IF (N_ELEMENTS(file) NE 0) THEN BEGIN
 red=INTARR(256)
 green=INTARR(256)
 blue=INTARR(256)
 OPENR, lun, file, /GET_LUN
 FOR j=0, 255 DO BEGIN
  READF, lun, val1, val2, val3
  red(j)=val1
  green(j)=val2
  blue(j)=val3
 ENDFOR
 FREE_LUN, lun
 TVLCT, red, green, blue
ENDIF


;Reverse colours if requested.
IF (N_ELEMENTS(REV) EQ 1) THEN BEGIN
 scols=254
 ;scalecols=[18, 16, 15, 12, 8, 3, 8, 8, 3, 16, 12, 18, 12, 18, 14, 10, 12, 8, 8, 10, 12, 14, 11, 10, 7, 28, 35, 9, 15, 23]
 scalecols=[18, 16, 15, 12, 8, 3, 8, 8, 3, 16, 12, 18, 12, 18, 14, 10, 12, 8, 8, 10, 12, 14, 11, 10, 7, 28, 35, 9, 15, 23, $
            14, 15, 12, 17, 16, 16, 20, 22, 14, 16, 20, 18, 12, 9,5]
 IF (N_ELEMENTS(SCALE) NE 0) THEN scols=scalecols(scale-1)
 IF (N_ELEMENTS(ncols) NE 0) THEN scols=ncols
 IF (rev NE 1) THEN scols=rev
 TVLCT, red, green, blue, /GET ;Get current colour scale.
 r=[red(0:1),reverse(red(2:scols+1))]
 g=[green(0:1),reverse(green(2:scols+1))]
 b=[blue(0:1),reverse(blue(2:scols+1))]
 IF (scols LT 254) THEN BEGIN
  r=[r, red(scols+2:255)]
  g=[g, green(scols+2:255)]
  b=[b, blue(scols+2:255)]
 ENDIF
 TVLCT, r, g, b 
ENDIF


;Setting selected colours to white
IF (N_ELEMENTS(white) NE 0) THEN BEGIN
 TVLCT, r, g, b, /GET ;Get current colour scale.
 FOR icol=0, N_ELEMENTS(white)-1 DO BEGIN
  r(white(icol))=255
  g(white(icol))=255
  b(white(icol))=255
 ENDFOR
 TVLCT, r, g, b
ENDIF


;Saving a colour scale.
IF (N_ELEMENTS(save) NE 0) THEN BEGIN
 IF ((save GT 5) OR (save LT 1)) THEN BEGIN
  PRINT, ''
  PRINT, 'CS ERROR - SAVE must be in range 1-5'
  PRINT, ''
  STOP
 ENDIF
 TVLCT, r, g, b, /GET ;Get current colour scale.
 res=EXECUTE('!guide.cs'+SCROP(save)+'(0,*)=r')
 res=EXECUTE('!guide.cs'+SCROP(save)+'(1,*)=g')
 res=EXECUTE('!guide.cs'+SCROP(save)+'(2,*)=b')
 res=EXECUTE('!guide.cs'+SCROP(save)+'_ncols='+SCROP(ncols))
ENDIF


;Merge the saved colour tables.
IF KEYWORD_SET(merge) THEN BEGIN
 ncols1=!guide.cs1_ncols
 ncols2=!guide.cs2_ncols 
 ncols3=!guide.cs3_ncols 
 ncols4=!guide.cs4_ncols
 ncols5=!guide.cs5_ncols
 IF (ncols1+ncols2+ncols3+ncols4+ncols5 GT 254) THEN BEGIN
  PRINT, ''
  PRINT, 'CS ERROR - too many colours to combine'
  PRINT, ''
  PRINT, 'CS1_NCOLS=', ncols1
  PRINT, 'CS2_NCOLS=', ncols2
  PRINT, 'CS3_NCOLS=', ncols3
  PRINT, 'CS4_NCOLS=', ncols4
  PRINT, 'CS5_NCOLS=', ncols5
  PRINT, 'Total is ', ncols1+ncols2+ncols3+ncols4+ncols5
  PRINT, 'Number of colours to combine must be less than or equal to 254'
  PRINT, ''
  STOP
 ENDIF

 r=[255,0, INTARR(254)+255]
 g=r
 b=r
 count=2 ;Starting colour.
 rgb=['r', 'g', 'b']
 FOR isave=1,5 DO BEGIN ;Loop over saved colour scales.
  res=EXECUTE('savecols=ncols'+SCROP(isave))
  IF (savecols GT 0) THEN BEGIN ;Loop over rgb.
   FOR icol=0,2 DO BEGIN
    com=rgb(icol)+'(count:count+savecols-1)=!guide.cs'+SCROP(isave)+'(icol, 2:savecols+1)'
    res=EXECUTE(com)
   ENDFOR
   count=count+savecols
  ENDIF
  TVLCT, r, g, b
 ENDFOR
ENDIF


;Clear the saved colour tables.
IF KEYWORD_SET(clear) THEN BEGIN
 FOR isave=1,5 DO BEGIN
  res=EXECUTE('!guide.cs'+SCROP(isave)+'_ncols=0')
  res=EXECUTE('!guide.cs'+SCROP(isave)+'(*)=255')
 ENDFOR
ENDIF


;Drawing a colour scale.
IF KEYWORD_SET(draw) THEN BEGIN
 gstruct=!guide ;Make a copy of !guide.
 TVLCT, r, g, b, /GET ;Get correct colour scale.
 PSOPEN ;This overwrites the colour scale with scale=1.
 TVLCT, r, g, b ;Reload colour scale.
 size=1200
 offset=1000
 thresh=50  
 FOR ix=0, 15 DO BEGIN
  FOR iy=0, 15 DO BEGIN
   xpts=[ix, ix, ix+1, ix+1, ix]*size+offset
   ypts=[iy, iy+1, iy+1, iy, iy]*size+offset
   POLYFILL, xpts, ypts, COLOR=((15-iy)*16)+ix, /DEVICE
   textcol=0
   col=((15-iy)*16)+ix
   IF (LONG(r(col))+LONG(g(col))+LONG(b(col)) GT 350) THEN textcol=1
   XYOUTS, ix*size+size/2+offset, iy*size+size/2.6+offset, SCROP(col), $
          ALIGN=0.5, CHARSIZE=1.5, CHARTHICK=5, COLOR=textcol, /DEVICE
  ENDFOR
 ENDFOR

 PSCLOSE
 DEFSYSV, '!guide', gstruct ;Restore !guide.
ENDIF


END

