PRO loop2
; A more complicated example of filename construction

datastr='u850'
FOR year=1979,1980 DO BEGIN

yearstr=STRTRIM(STRING(year),2)

;Set months as text
mymon=STRARR(6)
mymon(0)='may'
mymon(1)='jun'
mymon(2)='jul'
mymon(3)='aug'
mymon(4)='sep'
mymon(5)='oct'

;Set months as numbers
mymonno=STRARR(6)
mymonno(0)='05'
mymonno(1)='06'
mymonno(2)='07'
mymonno(3)='08'
mymonno(4)='09'
mymonno(5)='10'


FOR mymonind=0,5 DO BEGIN

monstr=mymon(mymonind)

IF ( mymonind eq 0 ) THEN mondays=31
IF ( mymonind eq 1 ) THEN mondays=30
IF ( mymonind eq 2 ) THEN mondays=31
IF ( mymonind eq 3 ) THEN mondays=31
IF ( mymonind eq 4 ) THEN mondays=30
IF ( mymonind eq 5 ) THEN mondays=31

FOR days=1,mondays DO BEGIN

daystr=STRTRIM(STRING(days),2)
monpad=''
IF ( days LE 9 ) THEN monpad='0'

FOR hours=0,18,6 DO BEGIN

IF ( hours eq 0 )  THEN hourstr='00'
IF ( hours eq 6 )  THEN hourstr='06'
IF ( hours eq 12 ) THEN hourstr='12'
IF ( hours eq 18 ) THEN hourstr='18'


myfile='/export/charney/data-05/era-40/'+datastr+'/'+yearstr+'/'+monstr+yearstr+'/'$
        +datastr+yearstr+mymonno(mymonind)+monpad+daystr+hourstr+'.nc'
PRINT, myfile

ENDFOR
ENDFOR
ENDFOR
ENDFOR

END

