PRO convert_lats_longs_to_erai_indices

; convert lats and longs into array indices
nxs =0  
i = 0
WHILE (nxs EQ 0) DO BEGIN 
  IF (d.longitude(i) GT long_min) THEN nxs = i
  i = i+1
ENDWHILE
PRINT, 'Starting longitude index ', nxs

nxe = 0  
i = 0
WHILE (nxe EQ 0) DO BEGIN 
  IF (d.longitude(i) GT long_max) THEN nxe = i
  i = i+1
ENDWHILE
PRINT, 'Ending longitude index ', nxe


nys = 0  
i = 0
WHILE (nys EQ 0) DO BEGIN 
  IF (d.latitude(i) LT lat_min) THEN nys = i-1
  i = i+1
ENDWHILE
PRINT, 'Starting latitude index ', nys

nye = 0  
i = 0
WHILE (nye EQ 0) DO BEGIN 
  IF (d.latitude(i) LT lat_max) THEN nye = i-1
  i = i+1
ENDWHILE
PRINT, 'Ending latitude index ', nye
PRINT, ''

END
