; Performs the unix command ncdump with option of including flags

PRO NCDUMP, filename,FLAGS=flags

IF N_ELEMENTS(flags) THEN com = 'ncdump '+'-'+flags+' '+filename $
                     ELSE com = 'ncdump '+filename
SPAWN, com

END
