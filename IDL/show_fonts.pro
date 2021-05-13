PRO show_fonts

PSOPEN
GSET, XMIN=0, XMAX=10, YMIN=0, YMAX=10
fonts=['HELVETICA', 'TIMES', 'PALATINO', 'COURIER', 'AVANTGARDE, /BOOK', $
       'SCHOOLBOOK', 'BKMAN, /LIGHT']
fonts2=['HELVETICA', 'TIMES', 'PALATINO', 'COURIER', 'AVANTGARDE', $
       'SCHOOLBOOK', 'BKMAN']
showstring='abcdef123'

DEVICE, /HELVETICA
FOR ifont=1,7 DO BEGIN
 myfont=ifont
 XYOUTS, font=0, 0, 7-ifont/2.0, 'FONT='+SCROP(myfont)+'      ('+fonts2(ifont-1)+')'
ENDFOR
 

FOR ifont=1,7 DO BEGIN
 com='DEVICE, /ISOLATIN1, /'+fonts(ifont-1)
 res=EXECUTE(com)
 XYOUTS, font=0, 2.8, 7-ifont/2.0, showstring
ENDFOR

FOR ifont=1,7 DO BEGIN
 com='DEVICE,/'+fonts(ifont-1)
 IF ((ifont LE 4) OR (ifont EQ 6)) THEN com=com+', /BOLD'
 res=EXECUTE(com)
 XYOUTS, font=0, 4.5, 7-ifont/2.0, showstring
ENDFOR

FOR ifont=1,7 DO BEGIN
 com='DEVICE,/'+fonts(ifont-1)
 IF ((ifont EQ 2) OR (ifont EQ 3) OR (ifont EQ 6) OR (ifont EQ 7)) THEN com=com+', /ITALIC'
 IF ((ifont EQ 1) OR (ifont EQ 4) OR (ifont EQ 5)) THEN com=com+ ', /OBLIQUE'
 res=EXECUTE(com)
 XYOUTS, font=0, 6.0, 7-ifont/2.0, showstring
ENDFOR
 
FOR ifont=1,7 DO BEGIN
 com='DEVICE,/'+fonts(ifont-1)
 IF ((ifont LE 4) OR (ifont EQ 6)) THEN com=com+', /BOLD'
 IF ((ifont EQ 2) OR (ifont EQ 3) OR (ifont EQ 6) OR (ifont EQ 7)) THEN com=com+', /ITALIC'
 IF ((ifont EQ 1) OR (ifont EQ 4) OR (ifont EQ 5)) THEN com=com+ ', /OBLIQUE'
 res=EXECUTE(com)
 XYOUTS, font=0, 8, 7-ifont/2.0, showstring
ENDFOR 
 

PSCLOSE
END
