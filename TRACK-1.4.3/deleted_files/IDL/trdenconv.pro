; Program to integrate a spehrical distribution function and re-normalize.

; Read input from file or from keyboard

filenam=' '
nd=0
nscl=0
trnum=1
scale=0.0
;read,io, prompt='Input from file, 0, or from keyboard, 1?  '
io=0
if io eq 0 then begin
;   read, infile, prompt='What is the input control filename? '
   infile='idl.out'
   openr,1,infile
   readf,1,filenam
   readf,1,lreg
   readf,1,nd
;   readf,1,trnum
   readf,1,nscl
   readf,1,scale
   readf,1,ifscl
   readf,1,fscal

   print,filenam
   print,trnum
   print,scale
   close,1
endif


if io eq 1 then read,filenam,prompt='What statistics file do you want to read?  '


proj=' '
point_num=' '
domain=' '
scrap=' '

openr,1,filenam

readf,1,proj
print,proj
readf,1,point_num
print,point_num
readf,1,domain
print,domain
readf,1,scrap
npts=round(float(strmid(point_num,9,6)))
print,npts

nparams=14
kertype=intarr(nparams)
arcbandw=dblarr(nparams)
ndata=dblarr(nparams)
readf,1,kertype
readf,1,arcbandw
readf,1,ndata
print,kertype
print,arcbandw
print,ndata

alon=dblarr(npts)
alat=dblarr(npts)
fieldin=dblarr(nparams+2)
mstr=dblarr(npts)
sstr=dblarr(npts)
mspd=dblarr(npts)
sspd=dblarr(npts)
fden=dblarr(npts)
gden=dblarr(npts)
lden=dblarr(npts)
tden=dblarr(npts)
mvl1=dblarr(npts)
mvl2=dblarr(npts)
mlif=dblarr(npts)
mgth=dblarr(npts)
miso=dblarr(npts)
mor1=dblarr(npts)
mor2=dblarr(npts)
mten=dblarr(npts)

for ipt=0, npts-1 do begin
   readf,1,a,b,fieldin
   alon(ipt)=a
   alat(ipt)=b
   mstr(ipt)=fieldin(0)
   sstr(ipt)=fieldin(1)
   mspd(ipt)=fieldin(2)
   sspd(ipt)=fieldin(3)
   fden(ipt)=fieldin(4)
   gden(ipt)=fieldin(5)
   lden(ipt)=fieldin(6)
   tden(ipt)=fieldin(7)
   mvl1(ipt)=fieldin(8)
   mvl2(ipt)=fieldin(9)
   mlif(ipt)=fieldin(10)
   mgth(ipt)=fieldin(11)
   miso(ipt)=fieldin(12)
   mor1(ipt)=fieldin(13)
   mor2(ipt)=fieldin(14)
   mten(ipt)=fieldin(15)
endfor

close,1

gs=[1.,0.5]
limits=[-180.,0.,180.,90.]
;limits=[-180.,-90.,180.,0.]
;limits=[0.0, 0.0, 183.75, 34.0]

if io eq 1 then read,lreg, prompt='Is the data irregular, 0,  or uniform, 1? '

; Feature density

intsolid,lreg,alon,alat,fden,gs,limits,intfield
print,'Integral of Feature density = ', intfield

if abs(intfield - 1.0) gt 0.01 then print,'****WARNING****, Feature density distribution does not integrate to unity.'

; Genesis density

intsolid,lreg,alon,alat,gden,gs,limits,intfield
print,'Integral of Genesis density = ', intfield

if abs(intfield - 1.0) gt 0.01 then print,'****WARNING****, Genesis density distribution does not integrate to unity.'

; Lysis density

intsolid,lreg,alon,alat,lden,gs,limits,intfield
print,'Integral of Lysis density = ', intfield

if abs(intfield - 1.0) gt 0.01 then print,'****WARNING****, Lysis density distribution does not integrate to unity.'

; Track density

intsolid,lreg,alon,alat,tden,gs,limits,intfield
print,'Integral of Track density = ', intfield

; Normalize track density.

if intfield gt 0.000001 then begin

   for ipt=0, npts-1 do begin

      tden(ipt)=tden(ipt)/intfield

   endfor

endif

intsolid,lreg,alon,alat,tden,gs,limits,intfield
print,'Integral of Track density = ', intfield
if abs(intfield - 1.0) gt 0.01 then print,'****WARNING****, Track density distribution does not integrate to unity.'

if io eq 1 then read,nd, prompt='Do you want pdf or number density output, 0 or 1.  '

if nd eq 1 then begin

   print, 'Producing number densities'

;   if io eq 1 then read,trnum, prompt='How many tracks are there? '

;   ndata(7) = trnum

   for ipt=0, npts-1 do begin

       fden(ipt) = fden(ipt) * ndata(4)
       gden(ipt) = gden(ipt) * ndata(5)
       lden(ipt) = lden(ipt) * ndata(6)
       tden(ipt) = tden(ipt) * ndata(7)
   endfor

endif

if io eq 1 then read,nscl, prompt='Do you want to further scale the densities, 0 for no, 1 for yes?'

if nscl eq 1 then begin


   if io eq 1 then read, scale, prompt='What is the scaling value.'

   print, 'Scaling densities by ', scale

   for ipt=0, npts-1 do begin

       fden(ipt) = fden(ipt) * scale
       gden(ipt) = gden(ipt) * scale
       lden(ipt) = lden(ipt) * scale
       tden(ipt) = tden(ipt) * scale

   endfor

endif


if io eq 1 then read,ifscl, prompt='Do you want field scaling, 0 for no, 1 for yes?'

if ifscl eq 1 then begin

    if io eq 1 then read, fscal, prompt='What field scaling do you want?'

    print, 'Scaling field values by', fscal

    for ipt=0, npts-1 do begin

        mstr(ipt) = mstr(ipt) * fscal
        sstr(ipt) = sstr(ipt) * fscal
        mten(ipt) = mten(ipt) * fscal

    endfor

endif

if nd eq 1 then begin
   openw,1,filenam+'.num'
endif else begin
   openw,1,filenam+'.new'
endelse

printf,1,proj
printf,1,point_num
printf,1,domain
printf,1,scrap
printf,1,kertype,format='(14(I2,1X))'
printf,1,arcbandw,format='(14(F10.5,1X))'
printf,1,ndata,format='(14(F10.2,1X))'

for ipt=0, npts-1 do begin

   fieldin(0)=mstr(ipt)
   fieldin(1)=sstr(ipt)
   fieldin(2)=mspd(ipt)
   fieldin(3)=sspd(ipt)
   fieldin(4)=fden(ipt)
   fieldin(5)=gden(ipt)
   fieldin(6)=lden(ipt)
   fieldin(7)=tden(ipt)
   fieldin(8)=mvl1(ipt)
   fieldin(9)=mvl2(ipt)
   fieldin(10)=mlif(ipt)
   fieldin(11)=mgth(ipt)
   fieldin(12)=miso(ipt)
   fieldin(13)=mor1(ipt)
   fieldin(14)=mor2(ipt)
   fieldin(15)=mten(ipt)
   printf,1,alon(ipt),alat(ipt),fieldin

endfor

close,1

end
