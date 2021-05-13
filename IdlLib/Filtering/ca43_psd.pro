
; ============================================
; ESSential Time Series Analysis, Fall 2010
; sample solution of computer assignment 4.3 :
; power spectral density of sunspot numbers
; ============================================

dt=1.
ff=1.
psd=csd(sunspots,sunspots,dt=dt,freq=ff,nsub=64)
plot, ff, psd
end
