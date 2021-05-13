PRO PSCLOSE, NOVIEW=noview, GV=gv, BACKGROUND=bkgd

; Very simple modification of Andy Heap's original code (as of
; Dec 2011). The optional keyword /BACKGROUND runs the 
;
;           SPAWN, 'display ...' 
; command with the addition of an '&' at the end so that images do not
; have to be shut in order to continue using the IDL command
; line. (BJH 12/12/2011)

;Procedure to close and view a postscipt file.
;(C) NCAS 2010

;Check !guide structure exists.
DEFSYSV, '!guide', exists=exists
IF (exists EQ 0) THEN BEGIN
 PRINT, ''
 PRINT, 'ERROR - PSOPEN must first be called to initiate a postscript file.'
 PRINT, ''
 STOP
ENDIF

; BJH: set the string amps
IF N_ELEMENTS(bkgd) THEN amps = '&' ELSE amps = ''

DEVICE, /CLOSE

os=STRLOWCASE(!version.os_family)
IF ((os EQ 'unix') OR (os EQ 'macos'))THEN BEGIN
 IF (NOT KEYWORD_SET(noview)) THEN BEGIN
  IF NOT KEYWORD_SET(GV) THEN BEGIN
   com='display +antialias -density 150 -resize 60% '
   IF NOT KEYWORD_SET(!guide.portrait) THEN com=com+'-rotate -90 '
   com=com+!guide.psfile
   SPAWN, com+amps
  ENDIF
 
  IF KEYWORD_SET(GV) THEN BEGIN
   IF (!guide.portrait NE 1) THEN com='gsview -seascape '+!guide.psfile
   IF (!guide.portrait EQ 1) THEN com='gsview '+!guide.psfile  
   SPAWN, com+amps
  ENDIF
 ENDIF
ENDIF

IF (os EQ 'windows') THEN BEGIN
 IF (NOT KEYWORD_SET(noview)) THEN BEGIN
  com=!guide.windows_viewer+' ' +!guide.psfile
  SPAWN, com, /NOSHELL
 ENDIF
ENDIF


END

