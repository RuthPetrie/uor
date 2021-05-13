; Print contents of current directory using unix command ls.
; Flags can be applied using the syntax e.g.
;
;     ls, '-l'
;

PRO LS, flags

IF NOT N_ELEMENTS(flags) THEN flags = ''
com = "SPAWN, 'ls "+flags+"'"
IF NOT EXECUTE(com) THEN PRINT, 'ls failed'

END
