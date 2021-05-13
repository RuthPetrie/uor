PRO LOCATE, filen,OPEN=open

; Simple routine which prints the locations of all filen.pro files
; within the !PATH directories. If the keyword /OPEN is selected then
; the file is opened with emacs. If multiple files are found then the
; user is prompted to select which file to open. 

; Put !PATH directories in an array
locs = FILE_SEARCH(STRSPLIT(!PATH,':',/EXTRACT)+'/'+filen+'.pro')

; Check at least one file was found
IF locs[0] EQ '' THEN PRINT, 'Cannot find '+filen+'.pro' ELSE BEGIN

    ; Print the file names to screen and open if /OPEN is set
    ;   -- prompt user for choice if there's head than one file

    IF N_ELEMENTS(locs) GT 1 THEN BEGIN
        nfs = N_ELEMENTS(locs)
        PRINT, TRANSPOSE(STRTRIM(INDGEN(nfs),2)+': '+locs)
        IF N_ELEMENTS(open) THEN BEGIN
             READ, PROMPT='Enter file to open (0-'+STRTRIM(nfs-1,2)+'): ',n
             SPAWN, 'emacs '+locs[n]+'&'
        ENDIF
     ENDIF ELSE BEGIN
        PRINT, locs
        IF N_ELEMENTS(open) THEN $
             SPAWN, 'emacs '+locs+'&'
     ENDELSE

ENDELSE

END
