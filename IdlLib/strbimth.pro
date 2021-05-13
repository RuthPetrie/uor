FUNCTION STRBIMTH, index

; returns the month index as a year and month'

IF (index EQ	0	) THEN output = 'JF'
IF (index EQ	1	) THEN output = 'MA'
IF (index EQ	2	) THEN output = 'MJ'
IF (index EQ	3	) THEN output = 'JA'
IF (index EQ	4	) THEN output = 'SO'
IF (index EQ	5	) THEN output = 'ND'

RETURN, output

END
