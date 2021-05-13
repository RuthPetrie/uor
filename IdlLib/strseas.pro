FUNCTION strseas, index

; returns the month index as a year and month'

IF (index EQ	0	) THEN output = 'DJF'
IF (index EQ	1	) THEN output = 'MAM'
IF (index EQ	2	) THEN output = 'JJA'
IF (index EQ	3	) THEN output = 'SON'

RETURN, output

END
