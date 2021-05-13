FUNCTION strmth, index

; returns the month index as a year and month'

IF (index EQ	0	) THEN output = 'JAN'
IF (index EQ	1	) THEN output = 'FEB'
IF (index EQ	2	) THEN output = 'MAR'
IF (index EQ	3	) THEN output = 'APR'
IF (index EQ	4	) THEN output = 'MAY'
IF (index EQ	5	) THEN output = 'JUN
IF (index EQ	6	) THEN output = 'JUL'
IF (index EQ	7	) THEN output = 'AUG'
IF (index EQ	8	) THEN output = 'SEP'
IF (index EQ	9	) THEN output = 'OCT'
IF (index EQ	10	) THEN output = 'NOV'
IF (index EQ	11	) THEN output = 'DEC'

RETURN, output

END
