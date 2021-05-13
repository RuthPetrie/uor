; GENERAL USE 
;-------------------
labels=['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z']
diff_cs = 6
kelvin=273.15

; SIC
;-------------------
sic_diff_levs= [ -0.8,-0.5,-0.2,-0.1,0.1, 0.3,0.5]

sic_mean_cscale=24
sic_mean_levs=[0, 0.1, 0.2, 0.3, 0.5, 0.8, 0.9]
sic_mean_cb_title='Fractional ice cover'
sic_mean_ndecs=1
sic_mean_white=2


; SIT
;-------------------
sit_diff_cscale=6
sit_cscale=45
sit_mean_cs=9
sit_levs=[0.0, 0.1, 0.5, 1.0, 1.5, 2.0, 3.0, 4.0 ]
sit_ncols=N_ELEMENTS(sit_levs)
sit_white=2
sit_ndecs=2

;sit_mean_levs=[0.0, 0.1, 0.5, 0.7, 1.0, 1.5, 2.0, 2.5, 3.0, 4.0 ]



;sit_cols=[444,274,292,358,419,417,418]
sit_cols=[444,270,274,292,330,358,419,418]

sit_diff_cs=24
sit_diff_levs= [-2.0,-1.5,-1.0,-0.7,-0.5,-0.2,0]





; SNOW
;--------------------
;snow_diff_levs = [-50., -25.,-15., -10., -5., -2., 2., 5., 10., 15., 25., 50.]
snow_diff_levs=[-50,-20,-10,-5,-2,-1,1,2,5,10,20, 50]
snow_ncols=N_ELEMENTS(snow_diff_levs)+1
snow_ndecs=1

 
; PRECIP
;--------- 
precip_diff_levs=[-10,-7,-5.0,-2.0, -1.0, 1.0, 2.0,5.0,7,10]
precip_ncols=N_ELEMENTS(precip_diff_levs)+1
precip_ndecs=1

; SST
;-------------------
;sst_diff_levs= [ -2, -1, -0.5, -0.2, -0.1, 0.1, 0.2, 0.5, 1, 2]
sst_diff_levs= [-4, -3, -1,-0.5,-0.2,0.2, 0.5, 1, 3, 4]


;sst_diff_levs_trop = [-1.5, -1, -0.5, -0.2,-0.15,-0.1,-0.05,0.05,0.1,0.15, 0.2, 0.5, 1,1.5]
sst_diff_levs_trop = [-1.5, -1, -0.5, -0.2,-0.1,0.1, 0.2, 0.5, 1,1.5]


sst_mean_cscale=44
sst_minval=-2
sst_maxval=26
sst_stepsize=4
sst_mean_ndecs=0
sst_ncols=(FIX((sst_maxval-sst_minval)/sst_stepsize)+2)


; Temperature
;-------------------
temp_vert_diff_levs= [-5, -3, -1, -0.5, -0.2, -0.1, 0.1, 0.2, 0.5, 1, 3, 5]


; ZOnal wind, vertical profiles
;-------------------
u_vert_diff_levs=[-3, -2, -1, -0.2, 0.2, 1, 2, 3]
u_vert_mean_levs=[2,5,10,15,20,25,30]
u850_diff_levs = [-3, -2, -1, -0.5, -0.2,0.2, 0.5, 1, 2,3]


; MSLP
;-------------------
mslp_diff_levs = [ -3, -2, -1, -0.5, -0.2, 0.2, 0.5, 1, 2,3]



; Z500
;-------------------
z500_diff_levs=[-30, -20,  -10, -5, 5, 10,  20, 30]
z_vert_diff_levs=[-50, -30, -20,  -10, -5, 5, 10,  20, 30, 50]
z_vert_mean_levs=[4000,8000,12000,16000,20000,24000,28000]


; SAT
;-------------------
sat_diff_levs= [-8,-5, -3, -1, -0.5, 0.5, 1, 3, 5,8]


; Surface heat fluxes
;----------------------
shf_diff_levs = [-80, -60, -30, -10,-5,-2,2,5, 10, 30, 60, 80]

; Shortwave fluxes
;----------------------
swf_diff_levs= [-60, -40, -20,-10,-5, -1, 1, 5,10,20,40,60]


