pro mintra,trpt,tmin,tmax,phin,phix,rdcp,cp

; The 'MINTRA line' is approximated by Tm=A0*(P**A1) +14 (kelvin)
A0=137.14816    ; This constant set for pressure in Pa 
A1=0.046822 
P_LIMIT=50    ; upper limit of calculation (mb)

label=0
npts=(1050-p_limit)/10 +1
tmintra=fltarr(npts)
smintra=fltarr(npts)

j=0
for p=1050,P_LIMIT,-10 do begin
  p_si=p*100.0
  MINTRA=A0*p_si^A1 +14.0
  tmintra[j]=mintra-trpt
  smintra[j]=cp*alog(mintra*(1000.0/p)^rdcp)
  if(smintra[j] gt phin and label eq 0) then begin
    textv='MINTRA'
    xp=tmintra[j]
    yp=smintra[j]
    gplot,x=xp,y=yp,text=textv,charsize=100,col=5, $
            orientation=100.0,align=0.0,valign=0.5
    label=1
  endif
  j=j+1
endfor

gplot,x=tmintra,y=smintra,col=5,style=4,thick=100,/clip

end
pro THICKNESS,tmax,trpt,tmin,phin,phix,RDCP,gacc,alv,cp
; determine thickness locations
; dz=-dp.rd.t/(p.g) so T = -dz.p.g/(dp.R)
; dp=100hPa

r=cp*rdcp

for p=25.0,275.0,50.0 do begin               ; pressure in hPa
  thplot=-1
  for thick=0.0,4000.0,10.0 do begin           ; thickness in metres
    thplot=thplot+1
    T=thick*p*gacc/(50.0*r)
    tc=t-trpt
    if(thplot eq 5) then thplot=0
    if(tc gt tmin and tc lt tmax) then begin
      th=t*(1000.0/p)^rdcp
      s=cp*alog(th)
      if(s gt phin and s lt phix) then begin
        gplot,x=tc,y=s,sym=3,size=25,col=5
        if(thplot eq 0) then begin
          textv=scrop(strmid(thick,0),ndecs=0)
          gplot,x=tc,y=s,text=textv,charsize=50,col=5, $
            orientation=45.0,align=0.5
        endif
      endif
    endif
  endfor
endfor

for p=350.0,950.0,100.0 do begin               ; pressure in hPa
  thplot=-1
  for thick=0.0,4000.0,10.0 do begin           ; thickness in metres
    thplot=thplot+1
    T=thick*p*gacc/(100.0*r)
    tc=t-trpt
    if(thplot eq 5) then thplot=0
    if(tc gt tmin and tc lt tmax) then begin
      th=t*(1000.0/p)^rdcp
      s=cp*alog(th)
      if(s gt phin and s lt phix) then begin
        gplot,x=tc,y=s,sym=3,size=25,col=5
        if(thplot eq 0) then begin
          textv=scrop(strmid(thick,0),ndecs=0)
          gplot,x=tc,y=s,text=textv,charsize=50,col=5, $
            orientation=45.0,align=0.5
        endif
      endif
    endif
  endfor
endfor

end
pro LETTER,tmax,trpt,rdcp,cp,phix,phin,tmin,TS,A0,A1,A2,A3,A4,A5,A6
; FUNCTION - TO PLOT LETTERING, ETC.
  
; Lettering is plotted in S-T coordinates.

; Isobar labels
; 31 isobars to be plotted
; 1050,1000,900,800,700,600,500,400,300,250,200,150,100,90,80,70
; 60,50,40,30,20,10,9,8,7,6,5,4,3,2,1

p=fltarr(31)
p=[1050,1000,900,800,700,600,500,400,300,250,200,150,100,90,80,70, $
 60,50,40,30,20,10,9,8,7,6,5,4,3,2,1]

for j=0,30 do begin
  i=j
  xpos=tmax
  ypos=cp*alog((tmax+trpt)*(1000.0/p[j])^RDCP)
  if(ypos gt phix) then break
  textv='  '+scrop(strmid(p[j],0)+'hPa')
  gplot,y=ypos,x=xpos,col=5,text=textv,charsize=70,align=0.0,orientation=45.0,valign=0.0
endfor
for j=i,30 do begin
  xpos=exp(phix/cp)
  xpos=xpos*((p[j]/1000.0)^RDCP)-trpt
  ypos=phix
  if(xpos lt tmin) then break
  textv=scrop(strmid(p[j],0)+'hPa')
  gplot,y=ypos,x=xpos,col=5,text=textv,charsize=70,align=0.0,orientation=45.0,valign=0.0
endfor

;isotherm labels
T1=tmin/10.0
t2=round(t1)
tp1=t2*10.0
if(tp1 lt tmin) then tp1=tp1+10.0
xpos=1.0
for i=round(tp1),round(tmax),10 do begin
  xpos=i
  ypos=phin
  ; check if at temperature i and phin the pressure is greater than 1050
  th=exp(phin/cp)
  pl=exp(alog(1000.0)+alog((i+trpt)/th)/rdcp)
  if(pl gt 1050.0) then begin
    th=(i+trpt)*(1000.0/1050.0)^rdcp
    ypos=cp*alog(th)
  endif
  textv=scrop(strmid(i,0)+'C')
  gplot,y=ypos,x=xpos,col=5,text=textv,charsize=70,align=0.0,orientation=0.0,valign=1.0
endfor

;dry adiabat labels
THmin=EXP(PHIN/CP)/10.0 -trpt/10.0                      ; min theta
th1=round(thmin)
if(thmin gt th1) then begin
  thmin=(th1+1.0)*10.0
endif else begin
  thmin=th1*10.0
endelse
THmax=EXP(PHIx/CP)-trpt/10.0

for i=round(thmin),round(thmax),10 do begin
  xpos=tmin
  ypos=cp*alog(i+trpt)
  if(ypos gt phix) then break
  textv=scrop(strmid(i,0)+'C')
  gplot,y=ypos,x=xpos,col=5,text=textv,charsize=70,align=1.0,orientation=0.0,valign=0.5
endfor

; moisture labels
p0=10
p1=1050
pd=2
npts=(p1-p0)/pd+1
qpoints=14
q=fltarr(14)

q=[56.0,40.0,32.0,20.0,10.0,5.0,2.0,1.0,0.5,0.2,0.1,0.05,0.01,0.001]
  
for j=0,qpoints-1 do begin
  ndecs=3
  if(q[j] ge 0.01 ) then ndecs=2
  if(q[j] ge 0.1 ) then ndecs=1
  if(q[j] ge 1.0 ) then ndecs=0

  for ipp=p0,p1,pd do begin
    ERATIO=29.0*Q(J)/18000.0
    PMBS=ipp
    EMBS=ERATIO*PMBS/(1.0+ERATIO) 
    TSOLVE,EMBS,tn,TS,A0,A1,A2,A3,A4,A5,A6
    splot=cp*alog((tn)*(1000.0/pmbs)^RDCP)
    tplot=tn-trpt
    if(splot lt phin ) then break
    if(tplot gt tmax ) then break
  endfor
  splot=splot-(phix-phin)/30.0
  if(tplot gt tmax) then begin
    splot=splot-(phix-phin)/30.0
    tplot=tplot+(tmax-tmin)/30.0
  endif
  if(tplot ge tmin) then begin 
    textv=scrop(strmid(q[j],0),ndecs=ndecs)+'g/kg'
    gplot,y=splot,x=tplot,col=5,text=textv,charsize=70,align=0.0, $
           orientation=-70.0,valign=0.5
  endif
endfor
end

pro TSOUND,TRPT,CP,RDCP,iflag2,iflag4
; FUNCTION - TO PLOT A SOUNDING COMPRISING TEMPERATURE
;            AND DEW POINT 
  
NLEVEL=0
NLEVED=0
readf,8,NLEVEL,NLEVED

temp=fltarr(nlevel)
psdg=fltarr(nlevel)
tabs=fltarr(nlevel)
dew=fltarr(nlevel)
dewabs=fltarr(nlevel)
splot=fltarr(nlevel)
press=!values.f_nan
dew[*]=!values.f_nan

for K=1,NLEVEL do begin
  IF(K LE NLEVED) THEN begin
    READf,8,press,TSDG,DEWSDG 
  endif else begin
    READf,8,press,TSDG
    DEWSDG=0.0 
  endelse
  PSDG[k-1]=press
  IF(IFLAG2 EQ 3 AND IFLAG4 EQ.1) THEN begin   ; temp, C
    TEMP[k-1]=TSDG 
    TABS[k-1]=TSDG+TRPT
    DEW[k-1]=DEWSDG
    DEWABS[k-1]=DEWSDG+TRPT
  ENDIF 
  IF(IFLAG2 EQ 4 AND IFLAG4 EQ 1) THEN begin   ; temp, K
    TEMP[k-1]=TSDG-TRPT
    TABS[k-1]=TSDG 
    DEW[k-1]=DEWSDG-TRPT 
    DEWABS[k-1]=DEWSDG 
  ENDIF 
  IF(IFLAG2 EQ 3 AND IFLAG4 EQ 2) THEN begin  ; theta, C
    DEW[k-1]=DEWSDG 
    DEWABS[k-1]=DEWSDG+TRPT 
    TABS[k-1]=(TRPT+TSDG)*(PSDG[k-1]/1000.0)^RDCP 
    TEMP[k-1]=TABS[k-1]-TRPT 
  ENDIF 
  IF(IFLAG2 EQ 4 AND IFLAG4 EQ 2) THEN begin  ; theta, K
    DEW[k-1]=DEWSDG-TRPT 
    DEWABS[k-1]=DEWSDG 
    TABS[k-1]=TSDG*(PSDG[k-1]/1000.0)^RDCP
    TEMP[k-1]=TABS[k-1]-TRPT 
  ENDIF 
endfor

; PLOT TEMPERATURE
; Convert reading to splot-tplot temp
for k=0,nlevel-1 do begin
   THETA=TABS[k]*(1000.0/PSDG[k])^RDCP
   splot[k]=cp*alog(theta)
endfor
gplot,x=temp,y=splot,col=3,thick=150,/clip

;plot dew point
; Convert reading to splot-tplot temp
for k=0,nleved-1 do begin
   THETA=dewABS[k]*(1000.0/PSDG[k])^RDCP
   splot[k]=cp*alog(theta)
endfor
gplot,x=dew,y=splot,col=4,thick=150,/clip
END 

pro MSOUND,TRPT,CP,RDCP,iflag2,iflag3,TS,A0,A1,A2,A3,A4,A5,A6
; FUNCTION - TO PLOT A SOUNDING COMPRISING TEMPERATURE OR 
;            POTENTIAL TEMPERATURE, AND MOISTURE 
  
nlevel=0
nleved=-0
readf,8,NLEVEL,NLEVED
qsdg=fltarr(nlevel)
psdg=fltarr(nlevel)
temp=fltarr(nlevel)
tabs=fltarr(nlevel)
splot=fltarr(nlevel)
press=!values.f_nan
moist=!values.f_nan

for K=1,NLEVEL do begin
  IF(K LE NLEVED) THEN begin
    READf,8,press,TSDG,moist
  endif else begin
    READf,8,press,TSDG
    moist=!values.f_nan
  endelse
  PSDG[k-1]=press
  QSDG[k-1]=moist
  IF(IFLAG2 EQ 4 AND IFLAG3 EQ 6) THEN begin    ; theta, K
    TABS[k-1]=TSDG*(PSDG[k-1]/1000.0)^RDCP
    TEMP[k-1]=TABS[k-1]-TRPT 
  ENDIF 
  IF(IFLAG2 EQ 3 AND IFLAG3 EQ 5) THEN begin    ; temp, C
    TEMP[k-1]=TSDG 
    TABS[k-1]=TSDG+TRPT
  ENDIF 
  IF(IFLAG2 EQ 4 AND IFLAG3 EQ 5) THEN begin    ; temp, K
    TEMP[k-1]=TSDG-TRPT
    TABS[k-1]=TSDG 
  ENDIF 
  IF(IFLAG2 EQ 3 AND IFLAG3 EQ 6) THEN begin    ; theta, C
    TABS[k-1]=(TSDG+TRPT)*(PSDG[k-1]/1000.0)^RDCP
    TEMP[k-1]=TABS[k-1]-TRPT
  ENDIF 
endfor

; PLOT TEMPERATURE
; Convert reading to splot-temp plot
splot[*]=!values.f_nan
for k=0,nlevel-1 do begin
   THETA=TABS[k]*(1000.0/PSDG[k])^RDCP
   splot[k]=cp*alog(theta)
endfor
gplot,x=temp,y=splot,col=3,thick=150,/clip

; PLOT MOISTURE 
temp[*]=!values.f_nan
splot[*]=!values.f_nan
for k=0,nleved-1 do begin
  ERATIO=29.0*qsdg[k]/18000.0
  PMBS=psdg[k]
  EMBS=ERATIO*PMBS/(1.0+ERATIO) 
  TSOLVE,EMBS,tn,TS,A0,A1,A2,A3,A4,A5,A6
  splot[k]=cp*alog((tn)*(1000.0/pmbs)^RDCP)
  temp[k]=tn-trpt
endfor
gplot,x=temp,y=splot,col=4,thick=150,/clip
END 
pro TLIMITS,TRPT,CP,RDCP,iflag2,iflag4,phix,phin,tmin,tmax
; FUNCTION - TO determine sounding plotting limits
  
NLEVEL=0
NLEVED=0
readf,8,NLEVEL,NLEVED

temp=fltarr(nlevel)
psdg=fltarr(nlevel)
tabs=fltarr(nlevel)
dew=fltarr(nlevel)
dewabs=fltarr(nlevel)
splot=fltarr(nlevel)
press=!values.f_nan
dew[*]=!values.f_nan

for K=1,NLEVEL do begin
  IF(K LE NLEVED) THEN begin
    READf,8,press,TSDG,DEWSDG 
  endif else begin
    READf,8,press,TSDG
    DEWSDG=0.0 
  endelse
  PSDG[k-1]=press
  IF(IFLAG2 EQ 3 AND IFLAG4 EQ.1) THEN begin   ; temp, C
    TEMP[k-1]=TSDG 
    TABS[k-1]=TSDG+TRPT
    DEW[k-1]=DEWSDG
    DEWABS[k-1]=DEWSDG+TRPT
  ENDIF 
  IF(IFLAG2 EQ 4 AND IFLAG4 EQ 1) THEN begin   ; temp, K
    TEMP[k-1]=TSDG-TRPT
    TABS[k-1]=TSDG 
    DEW[k-1]=DEWSDG-TRPT 
    DEWABS[k-1]=DEWSDG 
  ENDIF 
  IF(IFLAG2 EQ 3 AND IFLAG4 EQ 2) THEN begin  ; theta, C
    DEW[k-1]=DEWSDG 
    DEWABS[k-1]=DEWSDG+TRPT 
    TABS[k-1]=(TRPT+TSDG)*(PSDG[k-1]/1000.0)^RDCP 
    TEMP[k-1]=TABS[k-1]-TRPT 
  ENDIF 
  IF(IFLAG2 EQ 4 AND IFLAG4 EQ 2) THEN begin  ; theta, K
    DEW[k-1]=DEWSDG-TRPT 
    DEWABS[k-1]=DEWSDG 
    TABS[k-1]=TSDG*(PSDG[k-1]/1000.0)^RDCP
    TEMP[k-1]=TABS[k-1]-TRPT 
  ENDIF 
endfor
tmin=min(temp)
tmax=max(temp)
if(max(dew) gt tmax) then tmax=max(dew)
if(min(dew) lt tmin) then tmin=min(dew)

; Convert reading to splot-tplot temp
for k=0,nlevel-1 do begin
   THETA=TABS[k]*(1000.0/PSDG[k])^RDCP
   splot[k]=cp*alog(theta)
endfor
phin=min(splot)
phix=max(splot)

for k=0,nleved-1 do begin
   THETA=dewABS[k]*(1000.0/PSDG[k])^RDCP
   splot[k]=cp*alog(theta)
endfor
if(min(splot) lt phin) then phin=min(splot)
if(max(splot) gt phix) then phix=max(splot)

; Additionally, include the same lowest-level temperature and
; lowest-level theta as if at 1050hPa
T1=TABS[0]
THETA1=T1*(1000.0/1050.0)^RDCP
S1=cp*alog(Theta1)
t1=t1-trpt
theta1=theta1-trpt
if(s1 lt phin) then phin=s1
if(s1 gt phix) then phix=s1
if(t1 gt tmax) then tmax=t1
if(t1 lt tmin) then tmin=t1
if(theta1 gt tmax) then tmax=theta1
if(theta1 lt tmin) then tmin=theta1

; Additionally, include the same lowest-level dewpoint as if at 1050hPa
T1=dewABS[0]
THETA1=T1*(1000.0/1050.0)^RDCP
S1=cp*alog(Theta1)
t1=t1-trpt
theta1=theta1-trpt
if(s1 lt phin) then phin=s1
if(s1 gt phix) then phix=s1
if(t1 gt tmax) then tmax=t1
if(t1 lt tmin) then tmin=t1
if(theta1 gt tmax) then tmax=theta1
if(theta1 lt tmin) then tmin=theta1

END 
pro MLIMITS,TRPT,CP,RDCP,iflag2,iflag3,TS,A0,A1,A2,A3,A4,A5,A6,phix,phin,tmin,tmax
; FUNCTION - TO determine sounding plotting limits
  
nlevel=0
nleved=-0
readf,8,NLEVEL,NLEVED
qsdg=fltarr(nlevel)
psdg=fltarr(nlevel)
temp=fltarr(nlevel)
tabs=fltarr(nlevel)
splot=fltarr(nlevel)
press=!values.f_nan
moist=!values.f_nan

for K=1,NLEVEL do begin
  IF(K LE NLEVED) THEN begin
    READf,8,press,TSDG,moist
  endif else begin
    READf,8,press,TSDG
    moist=!values.f_nan
  endelse
  PSDG[k-1]=press
  QSDG[k-1]=moist
  IF(IFLAG2 EQ 4 AND IFLAG3 EQ 6) THEN begin    ; theta, K
    TABS[k-1]=TSDG*(PSDG[k-1]/1000.0)^RDCP
    TEMP[k-1]=TABS[k-1]-TRPT 
  ENDIF 
  IF(IFLAG2 EQ 3 AND IFLAG3 EQ 5) THEN begin    ; temp, C
    TEMP[k-1]=TSDG 
    TABS[k-1]=TSDG+TRPT
  ENDIF 
  IF(IFLAG2 EQ 4 AND IFLAG3 EQ 5) THEN begin    ; temp, K
    TEMP[k-1]=TSDG-TRPT
    TABS[k-1]=TSDG 
  ENDIF 
  IF(IFLAG2 EQ 3 AND IFLAG3 EQ 6) THEN begin    ; theta, C
    TABS[k-1]=(TSDG+TRPT)*(PSDG[k-1]/1000.0)^RDCP
    TEMP[k-1]=TABS[k-1]-TRPT
  ENDIF 
endfor
tmin=min(temp)
tmax=max(temp)

; PLOT TEMPERATURE
; Convert reading to splot-temp plot
splot[*]=!values.f_nan
for k=0,nlevel-1 do begin
   THETA=TABS[k]*(1000.0/PSDG[k])^RDCP
   splot[k]=cp*alog(theta)
endfor
phin=min(splot)
phix=max(splot)

; PLOT MOISTURE 
temp[*]=!values.f_nan
splot[*]=!values.f_nan
for k=0,nleved-1 do begin
  ERATIO=29.0*qsdg[k]/18000.0
  PMBS=psdg[k]
  EMBS=ERATIO*PMBS/(1.0+ERATIO) 
  TSOLVE,EMBS,tn,TS,A0,A1,A2,A3,A4,A5,A6
  splot[k]=cp*alog((tn)*(1000.0/pmbs)^RDCP)
  temp[k]=tn-trpt
endfor
if(max(temp) gt tmax) then tmax=max(temp)
if(min(temp) lt tmin) then tmin=min(temp)
if(min(splot) lt phin) then phin=min(splot)
if(max(splot) gt phix) then phix=max(splot)

; Additionally, include the same lowest-level temperature and
; lowest-level theta as if at 1050hPa
T1=TABS[0]
THETA1=T1*(1000.0/1050.0)^RDCP
S1=cp*alog(Theta1)
t1=t1-trpt
theta1=theta1-trpt
if(s1 lt phin) then phin=s1
if(s1 gt phix) then phix=s1
if(t1 gt tmax) then tmax=t1
if(t1 lt tmin) then tmin=t1
if(theta1 gt tmax) then tmax=theta1
if(theta1 lt tmin) then tmin=theta1

; Additionally, include the same lowest-level moisture as if at 1050hPa
ERATIO=29.0*qsdg[0]/18000.0
PMBS=1050.0
EMBS=ERATIO*PMBS/(1.0+ERATIO) 
TSOLVE,EMBS,tn,TS,A0,A1,A2,A3,A4,A5,A6
s1=cp*alog((tn)*(1000.0/pmbs)^RDCP)
t1=tn-trpt
if(s1 lt phin) then phin=s1
if(s1 gt phix) then phix=s1
if(t1 gt tmax) then tmax=t1
if(t1 lt tmin) then tmin=t1

END 
pro TSOLVE,ES,T,TS,A0,A1,A2,A3,A4,A5,A6
; FUNCTION - TO CALCULATE TEMPERATURE (DEG K) AS A FUNCTION OF
;            SATURATED VAPOUR PRESSURE 
; ARGS IN -ES(VAPOUR PRESSURE(MB))
; ARGS OUT - T(TEMPERATURE (DEG K) CORRESPONDING TO SVP OF ES)
  
T0=270.0
E=ES
for i=0,100 do begin
  G=A1*TS/T0+A2*ALOG(TS/T0)+A3*EXP(A4*T0/TS)+A5*EXP(A6*TS/T0) 
  F=E-A0*EXP(G) 
  DG=-A1*TS/(T0*T0)-A2/T0+A3*A4*(EXP(A4*T0/TS))/TS $
     -A5*A6*TS*(EXP(A6*TS/T0))/(T0*T0) 
  DF=-A0*EXP(G)*DG
  TN=T0-F/DF
  IF(ABS(TN-T0) LT 0.05) THEN break
  T0=TN
endfor
T=TN

END 

pro QSAT,TS,A0,A1,A2,A3,A4,A5,A6,cp,trpt,rdcp,phix,phin,tmax,tmin
; FUNCTION - TO CALCULATE MOISTURE ISOLINES 

detail=1
  
p0=10
p1=1050
pd=10
npts=(p1-p0)/pd+1
splot=fltarr(npts)
tplot=fltarr(npts)

if(detail eq 1) then begin
  ; plot every 0.001g/kg
  for j=0.001,0.009,0.001 do begin
    iplot=0
    for ipp=p0,p1,pd do begin
      ERATIO=29.0*J/18000.0
      PMBS=ipp
      EMBS=ERATIO*PMBS/(1.0+ERATIO) 
      TSOLVE,EMBS,tn,TS,A0,A1,A2,A3,A4,A5,A6
      splot[iplot]=cp*alog((tn)*(1000.0/pmbs)^RDCP)
      tplot[iplot]=tn-trpt
      iplot=iplot+1
    endfor
    gplot,x=tplot,y=splot,col=5,style=2,thick=10,/clip
  endfor

  ; plot every 0.01g/kg
  for j=0.01,0.09,0.01 do begin
    iplot=0
    for ipp=p0,p1,pd do begin
      ERATIO=29.0*J/18000.0
      PMBS=ipp
      EMBS=ERATIO*PMBS/(1.0+ERATIO) 
      TSOLVE,EMBS,tn,TS,A0,A1,A2,A3,A4,A5,A6
      splot[iplot]=cp*alog((tn)*(1000.0/pmbs)^RDCP)
      tplot[iplot]=tn-trpt
      iplot=iplot+1
    endfor
    gplot,x=tplot,y=splot,col=5,style=2,thick=10,/clip
  endfor
  ; plot every 0.1g/kg
  for j=0.1,0.9,0.1 do begin
    iplot=0
    for ipp=p0,p1,pd do begin
      ERATIO=29.0*J/18000.0
      PMBS=ipp
      EMBS=ERATIO*PMBS/(1.0+ERATIO) 
      TSOLVE,EMBS,tn,TS,A0,A1,A2,A3,A4,A5,A6
      splot[iplot]=cp*alog((tn)*(1000.0/pmbs)^RDCP)
      tplot[iplot]=tn-trpt
      iplot=iplot+1
    endfor
    gplot,x=tplot,y=splot,col=5,style=2,thick=10,/clip
  endfor

  ; plot every 1g/kg
  for j=1,9 do begin
    iplot=0
    for ipp=p0,p1,pd do begin
      ERATIO=29.0*J/18000.0
      PMBS=ipp
      EMBS=ERATIO*PMBS/(1.0+ERATIO) 
      TSOLVE,EMBS,tn,TS,A0,A1,A2,A3,A4,A5,A6
      splot[iplot]=cp*alog((tn)*(1000.0/pmbs)^RDCP)
      tplot[iplot]=tn-trpt
      iplot=iplot+1
    endfor
    gplot,x=tplot,y=splot,col=5,style=2,thick=10,/clip
  endfor

  ; plot every 2g/kg
  for j=10,18,2 do begin
    iplot=0
    for ipp=p0,p1,pd do begin
      ERATIO=29.0*J/18000.0
      PMBS=ipp
      EMBS=ERATIO*PMBS/(1.0+ERATIO) 
      TSOLVE,EMBS,tn,TS,A0,A1,A2,A3,A4,A5,A6
      splot[iplot]=cp*alog((tn)*(1000.0/pmbs)^RDCP)
      tplot[iplot]=tn-trpt
      iplot=iplot+1
    endfor
    gplot,x=tplot,y=splot,col=5,style=2,thick=10,/clip
  endfor

  ; plot every 4g/kg
  for j=20,36,4 do begin
    iplot=0
    for ipp=p0,p1,pd do begin
      ERATIO=29.0*J/18000.0
      PMBS=ipp
      EMBS=ERATIO*PMBS/(1.0+ERATIO) 
      TSOLVE,EMBS,tn,TS,A0,A1,A2,A3,A4,A5,A6
      splot[iplot]=cp*alog((tn)*(1000.0/pmbs)^RDCP)
      tplot[iplot]=tn-trpt
      iplot=iplot+1
    endfor
    gplot,x=tplot,y=splot,col=5,style=2,thick=10,/clip
  endfor

  ; plot every 8g/kg
  for j=40,80,8 do begin
    iplot=0
    for ipp=p0,p1,pd do begin
      ERATIO=29.0*J/18000.0
      PMBS=ipp
      EMBS=ERATIO*PMBS/(1.0+ERATIO) 
      TSOLVE,EMBS,tn,TS,A0,A1,A2,A3,A4,A5,A6
      splot[iplot]=cp*alog((tn)*(1000.0/pmbs)^RDCP)
      tplot[iplot]=tn-trpt
      iplot=iplot+1
    endfor
    gplot,x=tplot,y=splot,col=5,style=2,thick=10,/clip
  endfor

endif

qpoints=14
q=fltarr(14)
q=[56.0,40.0,32.0,20.0,10.0,5.0,2.0,1.0,0.5,0.2,0.1,0.05,0.01,0.001]
  
for j=0,qpoints-1 do begin
  iplot=0
  for ipp=p0,p1,pd do begin
    ERATIO=29.0*Q(J)/18000.0
    PMBS=ipp
    EMBS=ERATIO*PMBS/(1.0+ERATIO) 
    TSOLVE,EMBS,tn,TS,A0,A1,A2,A3,A4,A5,A6
    splot[iplot]=cp*alog((tn)*(1000.0/pmbs)^RDCP)
    tplot[iplot]=tn-trpt
    iplot=iplot+1
  endfor
  gplot,x=tplot,y=splot,col=5,style=2,/clip
endfor
end

pro DRYADBT,cp,phin,phix,tmin,tmax,rdcp,trpt
; FUNCTION - TO PLOT DRY ADIABATS 

detail=1
if(detail eq 1) then begin
  THmin=EXP(PHIN/CP)/10.0  -trpt/10.0                     ; min theta
  th1=round(thmin)
  if(thmin gt th1) then begin
    thmin=(th1+1.0)*10.0
  endif else begin
    thmin=th1*10.0
  endelse
  thmin=thmin+trpt-10.0

  THmax=EXP(PHIx/CP)/10.0   -trpt/10.0                    ; min theta
  th2=round(thmax)
  if(thmax lt th2) then begin
    thmax=(th2-1.0)*10.0
  endif else begin
    thmax=th2*10.0
  endelse
  thmax=thmax+trpt+10.0

  ; For each 10C increment in theta compute the (T,S) coordinate at 2hPa intervals
  thvals=(thmax-thmin) +1
  pvals=(1050-10)/2 + 1
  s1=fltarr(pvals)
  t1=fltarr(pvals)
  for theta=thmin,thmax do begin
    tk=theta
    t1[*]=!values.f_nan
    s1[*]=cp*alog(tk)
    i=0
    for p=10,1050,2 do begin
      t1[i]=tk*(p/1000.0)^rdcp - trpt
      i=i+1
    endfor
    gplot,x=t1,y=s1,col=5,thick=10,/clip
  endfor
endif
THmin=EXP(PHIN/CP)/10.0  -trpt/10.0                     ; min theta
th1=round(thmin)
if(thmin gt th1) then begin
  thmin=(th1+1.0)*10.0
endif else begin
  thmin=th1*10.0
endelse
thmin=thmin+trpt

THmax=EXP(PHIx/CP)/10.0   -trpt/10.0                    ; min theta
th2=round(thmax)
if(thmax lt th2) then begin
  thmax=(th2-1.0)*10.0
endif else begin
  thmax=th2*10.0
endelse
thmax=thmax+trpt
; For each 10C increment in theta compute the (T,S) coordinate at 2hPa intervals
thvals=(thmax-thmin)/10 +1
pvals=(1050-10)/2 + 1
s=fltarr(pvals)
t=fltarr(pvals)
for theta=thmin,thmax,10 do begin
  tk=theta
  t[*]=!values.f_nan
  s[*]=cp*alog(tk)
  i=0
  for p=10,1050,2 do begin
    t[i]=tk*(p/1000.0)^rdcp - trpt
    i=i+1
  endfor
  gplot,x=t,y=s,col=5,/clip
endfor

theta=EXP(PHIN/CP)
tk=theta
t[*]=!values.f_nan
s[*]=phin
i=0
for p=10,1050,2 do begin
  t[i]=tk*(p/1000.0)^rdcp - trpt
  i=i+1
endfor
gplot,x=t,y=s,col=5,/clip

theta=EXP(PHIX/CP)
tk=theta
t[*]=!values.f_nan
s[*]=phix
i=0
for p=10,1050,2 do begin
  t[i]=tk*(p/1000.0)^rdcp - trpt
  i=i+1
endfor
gplot,x=t,y=s,col=5,/clip

end
pro ISOTHM,TRPT,RDCP,tmin,tmax,phix,cp
; FUNCTION - TO PLOT ISOTHERMS

detail=1
if(detail eq 1) then begin
  ; First print every 1C
  T1=tmin/10.0
  t2=round(t1)
  tp1=t2*10.0
  if(tp1 lt tmin) then tp1=tp1+1.0

  T1=tmax/10.0
  t2=round(t1)
  tp2=t2*10.0
  if(tp2 gt tmax) then tp2=tp2-1.0

  s1=fltarr(2)
  t1=fltarr(2)
  for IT=tp1,tp2,1 do begin
    s1[0]=cp*alog((IT+TRPT)*(1000.0/1050.0)^RDCP)
    s1[1]=phix
    if(s1[0] gt phix) then s1[*]=!values.f_nan
    t1[*]=it
    lstyle=0
    lthick=10
    if(it eq 0) then lstyle=2
    if(it eq 0) then lthick=200
    gplot,x=t1,y=s1,col=5,thick=lthick,style=lstyle,/clip
  endfor
endif

T1=tmin/10.0
t2=round(t1)
tp1=t2*10.0
if(tp1 lt tmin) then tp1=tp1+10.0

T1=tmax/10.0
t2=round(t1)
tp2=t2*10.0
if(tp2 gt tmax) then tp2=tp2-10.0

s=fltarr(2)
t=fltarr(2)
for IT=tp1,tp2,10 do begin
  s[0]=cp*alog((IT+TRPT)*(1000.0/1050.0)^RDCP)
  s[1]=phix
  if(s[0] gt phix) then s[*]=!values.f_nan
  t[*]=it
  style=0
  if(it eq 0) then style=2
  gplot,x=t,y=s,col=5,style=style,/clip
endfor

IT=tmin
s[0]=cp*alog((IT+TRPT)*(1000.0/1050.0)^RDCP)
s[1]=phix
if(s[0] gt phix) then s[*]=!values.f_nan
t[*]=it
gplot,x=t,y=s,col=5,/clip

IT=tmax
s[0]=cp*alog((IT+TRPT)*(1000.0/1050.0)^RDCP)
s[1]=phix
if(s[0] gt phix) then s[*]=!values.f_nan
t[*]=it
gplot,x=t,y=s,col=5,/clip

END 
pro ISOBAR,tmin,tmax,rdcp,trpt,cp,phix
; FUNCTION - TO PLOT ISOBARS

detail=1
if(detail eq 1) then begin
  ; Firstly, output every 10hPa up to 10hPa
  tint=0.2
  ntemps10=(tmax-tmin)/tint+1
  splot10=fltarr(ntemps10)
  tplot10=fltarr(ntemps10)
  
  for p10=10,1050,10 do begin
    ; For each value of t in the range tmin,tmix determine the value of S
    it=0
    for t=tmin,tmax,tint do begin
      splot10[it]=cp*alog((T+TRPT)*(1000.0/p10)^RDCP)
      tplot10[it]=t
      it=it+1
    endfor
    gplot,x=tplot10,y=splot10,col=5,thick=10,/clip
  endfor
endif

; 31 isobars to be plotted (in bolder type)
; 1050,1000,900,800,700,600,500,400,300,250,200,150,100,90,80,70
; 60,50,40,30,20,10,9,8,7,6,5,4,3,2,1

npressure=31
p=fltarr(npressure)
ntemps=(tmax-tmin)/tint+1
splot=fltarr(ntemps)
tplot=fltarr(ntemps)

p=[1050,1000,900,800,700,600,500,400,300,250,200,150,100,90,80,70, $
     60,50,40,30,20,10,9,8,7,6,5,4,3,2,1]

for jp=0,npressure-1 do begin
  ; For each value of t in the range tmin,tmix determine the value of S
  it=0
  for t=tmin,tmax,tint do begin
    splot[it]=cp*alog((T+TRPT)*(1000.0/p[jp])^RDCP)
    tplot[it]=t
    it=it+1
  endfor
  gplot,x=tplot,y=splot,col=5,/clip
endfor
end
pro constants,ts,a0,a1,a2,a3,a4,a5,a6,cp,alv,rdcp
TS=373.16
A0=7.95357242E10
A1=-18.1972839
A2=5.02808
A3=-70242.1852
A4=-26.1205253
A5=58.0691913
A6=-8.03945282
CP=1005.46 
ALV=2500.0            ; THE UNITS OF ALV ARE J/G
RDCP=287.05/CP

; THE FOLLOWING ALLOWS THE USER TO DEFINE CP/ALV AND RDCP.
help,cp
help,alv
help,rdcp
print,'Do you wish to redefine any of CP, ALV or RDCP? Enter 1 FOR yes, or 0 for no.
indata=0
read, indata
print,indata
IF(INDATA NE 1 AND INDATA NE 0) then errorstop
IF(INDATA EQ 1)THEN begin
  print,'Enter 0.0 or your value for CP (J/KG/DEG K)'
  read, cp
  IF(cp gt 0.0) then CP=1004.9 
  print,'Enter 0.0 or your value for ALV in JOULES/G'
  read, ALV 
  IF(ALV gt 0.0) then ALV=2500.0 
  print,'Enter 0.0 or your value for RD/CP'
  read, RDCP
  IF(RDCP EQ 0.0) then RDCP=0.28564
ENDIF 

end
pro errorstop
;     FUNCTION - TO TERMINATE RUN AFTER INCORRECT INTERACTIVE RESPONSE
  
print, 'RUN STOPPED - INCORRECT ENTRY*********************'
exit
end      

pro sounding,iflag1,iflag2,iflag3,iflag4
; Specify type of sounding data available
iflag1=0
print,'Type 1 for dew point sounding, or'
print,'     2 FOR moisture sounding'
read,iflag1 
IF(IFLAG1 NE 1 AND IFLAG1 NE 2) then ERRORSTOP

if(iflag1 eq 1) then begin
  print,'Enter 1 if sounding data uses temperature, else'
  print,'      2 if data uses potential temperature'
  iflag4=0
  read,iflag4
  IF(IFLAG4 NE 1 AND IFLAG4 NE 2) then ERRORSTOP
  print,'Enter 3 if sounding data uses DEG C, else'
  print,'      4 FOR DEG K'
  iflag2=0
  read,iflag2
  IF(IFLAG2 NE 3 AND IFLAG2 NE 4) then ERRORSTOP
endif

if(iflag1 eq 2) then begin
  print,'Enter 3 if sounding data uses DEG C, else'
  print,'      4 FOR DEG K'
  iflag2=0
  read,iflag2
  IF(IFLAG2 NE 3 AND IFLAG2 NE 4) then ERRORSTOP
  print,'Enter 5 if sounding data uses temperature, else'
  print,'      6 if data uses potential temperature'
  iflag3=0
  read,iflag3
  IF(IFLAG3 NE 5 AND IFLAG3 NE 6) then ERRORSTOP
endif
end
pro sounding_wind,nwind,iw1,iw2,iwout1,iwout2
print,'Type 1 if wind data to be input, else 0'
nwind=0
read, nwind
IF(nwind NE 1 AND nwind NE 0) then ERRORSTOP

if(nwind eq 1) then begin
  print,'Enter 1 if windspeed units are knots, else'
  print,'      2 if windspeed units are m/s'
  iw1=0
  read, iw1
  if(iw1 ne 1 AND IW1 NE 2) then ERRORSTOP
  print,'Enter 3 if wind data is in degree/speed format, else'
  print,'      4 if in U-component/V-component format'
  iw2=0
  read, iw2
  if(IW2 NE 3 AND IW2 NE 4) then ERRORSTOP
  print,'Enter 5 for wind output in degree/speed format, else'
  print,'      6 for U-component/V-component format'
  iwout1=0
  read, IWOUT1 
  IF(IWOUT1 NE 5 AND IWOUT1 NE 6) then ERRORSTOP
  print,'Enter 7 if windspeed units are knots, else'
  print,'      8 if windspeed units are m/s'
  iwout2=0
  read, iwout2
  if(iwout2 ne 7 AND IWout2 NE 8) then ERRORSTOP
endif
end
pro tephi, FILE=file

;     FUNCTION - TO PLOT A TEPHIGRAM USING UNIRAS/METPLOT GRAPHICS 
;     AUTHOR - R BRUGGE, ATMOSPHERIC PHYSICS GROUP, IMPERIAL
;           COLLEGE,LONDON SW7 2BZ. 
;     AMENDED - R BRUGGE, UNIVERSITY OF READING, (MARCH 1991) TO WORK ON
;           METEOROLOGY DEPT. SUNS AT READING UNIVERSITY
;     AMENDED - R BRUGGE, UNIVERSITY OF READING, (DECEMBER 2008) TO WORK 
;           UNDER IDL AT READING UNIVERSITY

;     NOTE - THERE IS STILL SOME ARGUMENT OVER THE OPTIMUM VALUES 
;           THAT SHOULD BE USED FOR CP/ALV (THE RATIO OF THE
;           SPECIFIC HEAT OF DRY AIR TO THE LATENT HEAT OF
;           VAPORISATION OF WATER) AND RDCP (THE RATIO OF THE GAS 
;           CONSTANT TO CP) AND USERS ARE RECOMMENDED TO EDIT IN
;           THEIR PREFERRED VALUES. 

;     TO RUN THIS PROGRAM A DATA FILE (CALLED DATA.DAT) IS NEEDED. THIS 
;           CONTAINS THE FOLLOWING: 
;              M,N     - M LINES OF DATA FOLLOW, ONE PRESSURE LEVEL 
;              P,T,TD    PER LINE. (N LEVELS CONTAIN NON-ZERO MOISTURE) 
;              P,T,TD 
;              P,T,TD   ) 
;              P,T,TD   )DATA IN THE FORMAT SHOWN, WHERE P IS PRESSURE
;              ......   )IN MBS. DATA IS IN ORDER OF DECREASING PRESSURE. 
;              ......   ) 
;              ...... 
;              I       - NUMBER OF THETA-W CURVES TO BE PLOTTED 
;              THW     - REAL VALUE OF EACH THETA-W CURVE, ONE PER LINE 
;              THW
;              'DATE'  - EG. '21-11-84' 
;              'TIME'  - EG. '1200Z'
;              'PLACE' - EG. 'CAMBORNE' (PLACE HAS <= 15 CHARACTERS)
;              NW      - NW LINES OF WIND DATA FOLLOW, ONE PRESSURE 
;              P,W1,W2   LEVEL PER LINE.
;              P,W1,W2
;              P,W1,W2 )
;              P,W1,W2 )DATA IN THE FORMAT SHOWN, WHERE P IS PRESSURE 
;              P,W1,W2 )IN MBS. DATA IS IN ORDER OF DECREASING PRESSURE 
;              ....... )
;              .......
;              .......
;     T (A REAL NUMBER) MAY BE EITHER POTENTIAL OR DRY BULB TEMPERATURE 
;           IN UNITS OF DEG C OR DEG K. 
;     TD (A REAL NUMBER) MAY BE EITHER DEW POINT OR MOISTURE CONTENT
;           IN UNITS OF DEG C, DEG K OR G/KG. 
;     P IS A REAL NUMBER
;     M MUST NOT EXCEED 60, AND N MUST NOT EXCEED M.
;     IF DEW POINT IS USED, N IS THE NO. OF LEVELS WITH DEW POINT VALUES. 
;           OTHER LEVELS CONTAIN ONLY PRESSURE AND TEMPERATURE.  IF 
;           MOISTURE IS USED, N IS THE NO. OF LEVELS WITH NON-ZERO
;           MOISTURE.  OTHER LEVELS CONTAIN P,T,0.0 
;     IF NW=0, NO WIND DATA IS PROCESSED AND NONE NEED BE SUPPLIED. 
;     W1 MAY BE EITHER WIND DIRECTION (DEGREES) OR THE U-COMPONENT. 
;     W2 MAY BE EITHER THE TOTAL WIND SPEED (IF W1 IS THE WIND
;           DIRECTION) OR THE V-COMPONENT (IF W1 IS THE 
;           U-COMPONENT). 
;     WIND SPEEDS AND COMPONENTS MAY BE IN UNITS OF KNOTS OR M/S. 

; Start of code




; 1.0 Specify program/plotting constants
gacc=9.80665
TRPT=273.15           ; TEMPERATURE (DEG K) =TEMPERATURE (DEG C) +TRPT
PHIX=6150.0 
PHIN=5500.0 
                      ; PHIX AND PHIN ARE THE MAX AND MIN VALUES OF 
                      ; ENTROPY (PHI) USED IN CONSTRUCTING THE TEPHIGRAM, 
                      ; WHERE PHI=CP*ALOG(POTENTIAL TEMPERATURE)
Tmin=-80.0
Tmax=40.0
                      ; Tmin/Tmax defines the temperature range
charsize=70           ; charsize value for gplot routine


constants,ts,a0,a1,a2,a3,a4,a5,a6,cp,alv,rdcp

; 2.0 Open the data file
file_a=file
openr, 8, file_a

; 3.0 Specify type of sounding data available
sounding,iflag1,iflag2,iflag3,iflag4

; 3.0.1 Make a quick read of the data file to determine plotting area
IF(IFLAG1 EQ 1) THEN TLIMITS,TRPT,CP,RDCP,iflag2,iflag4,phix,phin,tmin,tmax
IF(IFLAG1 EQ 2) THEN MLIMITS,TRPT,CP,RDCP,iflag2,iflag3,TS,A0,A1,A2,A3,A4,A5,A6,phix,phin,tmin,tmax
phirange=phix-phin
trange=tmax-tmin
phix=phix+0.1*phirange
phin=phin-0.1*phirange
tmax=tmax+0.1*trange
tmin=tmin-0.1*trange

free_lun,8
openr, 8, file_a

; 3.1 Specify wind data type
sounding_wind,nwind,iw1,iw2,iwout1,iwout2

; 4.0 Plotting
psopen
; pen colours
; pen(2) - black, pen(3) - red, pen(4) - blue, pen(5) - green 
cs,cols=[549,2,90,199]
gset,xmin=tmin,xmax=tmax,ymin=phin,ymax=phix
;axes,xstep=10,col=5
  
;     PLOT DRY ADIABATS 
DRYADBT,cp,phin,phix,tmin,tmax,rdcp,trpt

;     PLOT ISOTHERMS
ISOTHM,TRPT,RDCP,tmin,tmax,phix,cp

;     PLOT ISOBARS
ISOBAR,tmin,tmax,rdcp,trpt,cp,phix

; PLOT MOISTURE ISOLINES
QSAT,TS,A0,A1,A2,A3,A4,A5,A6,cp,trpt,rdcp,phix,phin,tmax,tmin

WETADBT,tmin,tmax,trpt,TS,A0,A1,A2,A3,A4,A5,A6,alv,cp,rdcp,phin,phix

; READ AND PLOT SOUNDING
IF(IFLAG1 EQ 1) THEN TSOUND,TRPT,CP,RDCP,iflag2,iflag4
IF(IFLAG1 EQ 2) THEN MSOUND,TRPT,CP,RDCP,iflag2,iflag3,TS,A0,A1,A2,A3,A4,A5,A6
close, 8

; PLOT SYMBOLS
LETTER,tmax,trpt,rdcp,cp,phix,phin,tmin,TS,A0,A1,A2,A3,A4,A5,A6

; plot thickness values
THICKNESS,tmax,trpt,tmin,phin,phix,RDCP,gacc,alv,cp

; plot mintra line
mintra,trpt,tmin,tmax,phin,phix,rdcp,cp

;      CALL WIND 
psclose

end
 
pro WETADBT,tmin,tmax,trpt,TS,A0,A1,A2,A3,A4,A5,A6,alv,cp,rdcp,phin,phix
; FUNCTION - CALLING ROUTINE TO PLOT SATURATED ADIABATS 

detail=1

T1=tmin/10.0
t2=round(t1)
tp1=t2*10.0
if(tp1 lt tmin) then tp1=tp1+10.0
if(tp1 lt -50.0) then tp1=-50.0

T1=tmax/10.0
t2=round(t1)
tp2=t2*10.0
if(tp2 gt tmax) then tp2=tp2-10.0

for thew=tp2,tp1,-10 do begin
  thick=100
  theta_w=thew
  WET,theta_w,trpt,TS,A0,A1,A2,A3,A4,A5,A6,alv,cp,rdcp,phin, $
      tmin,phix,tmax,thick
  if(detail eq 1) then begin
    for thew1=thew-2,thew-8,-2 do begin
      theta_w=thew1
      thick=10
      WET,theta_w,trpt,TS,A0,A1,A2,A3,A4,A5,A6,alv,cp,rdcp,phin, $
          tmin,phix,tmax,thick
    endfor
  endif
endfor

END 

pro WET,THEW,trpt,TS,A0,A1,A2,A3,A4,A5,A6,alv,cp,rdcp,phin,tmin,phix,tmax,thick
; FUNCTION - TO CALCULATE AND PLOT SATURATED ADIABATS 
; ARGS IN - THEW(THETA-W, DEG C)
  
THEW=THEW+TRPT

IPTS=(1050-50)/10 +1
XARR=fltarr(ipts)
YARR=fltarr(ipts)

; Determine pressure level for theta-w annotation
th=exp(phin/cp)
thdt=th/(tmin+trpt)
lpodp=alog(thdt)/rdcp
ptheta=exp(alog(1000.0)-lpodp)
pround=round(ptheta/50.0)
pth2=0.0
pth2=pround*50.0
if(ptheta gt pth2) then ptheta=pth2+50.0
if(ptheta le pth2) then ptheta=pth2

; CALCULATE EQUIVALENT POTENTIAL TEMPERATURE
TDRY=THEW 
G=A1*TS/TDRY+A2*ALOG(TS/TDRY)+A3*EXP(A4*TDRY/TS)+A5*EXP(A6*TS/TDRY) 
QSAT=A0*EXP(G)
XHI=(18015.4)/(28.966*(1000.0-QSAT))
THEQ=TDRY*EXP(ALV*XHI*QSAT/(CP*TDRY)) 
I=0
for IP=1050,50,-10 do begin
  P=FLOAT(IP) 
  IF(P LE 0) then P=20.0

  ; PERFORM ITERATION TO FIND THETA AND TEMP AT P 
  TEMP0=THEW
  TEMP1=99999.9
  F=9999.9
  DF=1.0
  ratio=abs(f/df)
  WHILE(ratio GT 0.05) do begin
    THETA=TEMP0*(1000.0/P)^RDCP
    G=A1*TS/TEMP0+A2*ALOG(TS/TEMP0)+A3*EXP(A4*TEMP0/TS) $
        +A5*EXP(A6*TS/TEMP0)
    QSAT=A0*EXP(G)
    ; CONVERT MB TO G/KG
    XHI=(18015.4)/(28.966*(P-QSAT)) 
    F=THEQ-THETA*EXP(ALV*QSAT*XHI/(CP*TEMP0)) 
    DQSAT=QSAT*(-A1*TS/(TEMP0*TEMP0)-A2/TEMP0+(A3*A4/TS)* $
        EXP(A4*TEMP0/TS)-(A5*A6*TS/(TEMP0*TEMP0))*EXP(A6*TS/TEMP0)) 
    DF=-((1000.0/P)^RDCP)*EXP(XHI*ALV*QSAT/(CP*TEMP0))  $
        -THETA*EXP(XHI*ALV*QSAT/(CP*TEMP0))*(XHI*ALV*DQSAT/ $
       (CP*TEMP0)-XHI*ALV*QSAT/(CP*TEMP0*TEMP0)) 
    ratio=f/df
    TEMP1=TEMP0-ratio
    TEMP0=TEMP1
  endwhile
  T=TEMP1
  XARR[I]=T-TRPT
  ZARR=T*(1000.0/P)^RDCP 
  YARR[I]=CP*ALOG(ZARR) 

  if(round(ip) eq round(ptheta)) then begin
    textv=scrop(strmid(thew-trpt,0),ndecs=0)+'C'
    xp=t-trpt
    yp=yarr[i]
    if(yp lt phix and yp gt phin and xp lt tmax and xp gt tmin and thick eq 100) then $
       gplot,y=yp,x=xp,col=5,text=textv,charsize=70, $
       align=0.0,orientation=-20.0,valign=0.0
  endif

  I=I+1
endfor
gplot,x=xarr,y=yarr,col=5,thick=thick,/clip
END 
