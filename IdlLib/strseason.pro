FUNCTION strseason, index

; returns the month index as a year and month'

IF (index EQ	0	) THEN output = 'djf'
IF (index EQ	1	) THEN output = 'mam'
IF (index EQ	2	) THEN output = 'jja'
IF (index EQ	3	) THEN output = 'son'

RETURN, output

END
