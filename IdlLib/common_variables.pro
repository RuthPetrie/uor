nx_hgem=192
ny_hgem=145
nyu_hgem=144
nx_erai=512
ny_erai=256

; MSLP MEAN VALUES
mslp_cscale=26
mslp_minval=980
mslp_maxval=1040
mslp_stepsize=4
mslp_units='(hPa)'

; MSLP MEAN NH VALUES
mslp_nh_cscale=26
mslp_nh_minval=996
mslp_nh_maxval=1028
mslp_nh_stepsize=2


; MSLP DIFF VALUES
mslp_diff_cscale=6
mslp_diff_levs = [-5, -3, -2, -1, -0.5, 0.5, 1, 2,3, 5]
mslp_diff_ndecs = 1
mslp_diff_cols_req = N_ELEMENTS(mslp_diff_levs) +1

; SST MEAN VALUES
sst_cscale=26
sst_minval=-2
sst_maxval=36
sst_stepsize=2
sst_units='(K)'
sst_ndecs=0

; SST MEAN NH VALUES
sst_nh_cscale=26
sst_nh_minval=-2
sst_nh_maxval=26
sst_nh_stepsize=2
sst_nh_ndecs=0

; SST DIFF VALUES
sst_diff_cscale=6
sst_diff_levs = [-3, -2, -1.5,-1, -0.5, -0.25, 0.25, 0.5, 1,1.5, 2,3]
sst_diff_ndecs = 2
sst_diff_cols_req = N_ELEMENTS(sst_diff_levs) +1

; SIT DIST MEAN VALUES
sitd_cscale=26
sitd_minval=0
sitd_maxval=3
sitd_stepsize=0.25
sitd_ndecs=2
sitd_units='(m)'

; SIT DIST MEAN NH VALUES
sitd_nh_cscale=26
sitd_nh_minval=0
sitd_nh_maxval=3
sitd_nh_stepsize=0.25
sitd_nh_ndecs=2

; SIT DIST DIFF VALUES
sitd_diff_cscale=6
sitd_diff_levs = [-2, -1.5, -1.0,-0.5, -0.2, -0.1, 0.1,0.2, 0.5, 1,1.5, 2]
sitd_diff_ndecs = 2
sitd_diff_cols_req = N_ELEMENTS(sst_diff_levs) +1


; SIT MEAN VALUES
sit_cscale=26
sit_minval=0
sit_maxval=3
sit_stepsize=0.25
sit_ndecs=2
sit_units='(m)'

; SIT MEAN NH VALUES
sit_nh_cscale=26
sit_nh_minval=0
sit_nh_maxval=3
sit_nh_stepsize=0.25
sit_nh_ndecs=2

; SIT DIFF VALUES
sit_diff_cscale=6
sit_diff_levs = [-2.0, -1.5, -1.0,-0.5, -0.2, -0.1, 0.1,0.2, 0.5, 1.0,1.5, 2.0]
sit_diff_ndecs = 1
sit_diff_cols_req = N_ELEMENTS(sst_diff_levs) +1

;*****************************************************
;*****************************************************
;*****************************************************
; SNOW MEAN VALUES
snow_cscale=26
snow_minval=0
snow_maxval=150
snow_stepsize=10
snow_units='(m)'
snow_ndecs=0

; SNOW MEAN NH VALUES
snow_nh_cscale=26
snow_nh_minval=0
snow_nh_maxval=150
snow_nh_stepsize=10
snow_nh_ndecs=0

; SNOW DIFF VALUES
snow_diff_cscale=6
snow_diff_levs=[-50, -25, -10, -5, -2, -1, 1, 2, 5, 10, 25,50]
snow_diff_ndecs=1
snow_diff_cols_req = N_ELEMENTS(snow_diff_levs) +1
;*****************************************************
;*****************************************************
;*****************************************************

; Z50 MEAN VALUES
z50_cscale=26
z50_minval=20000
z50_maxval=22000
z50_stepsize=100
z50_units='(m)'

; Z500 MEAN NH VALUES
z50_nh_cscale=26
z50_nh_minval=19400
z50_nh_maxval=21000
z50_nh_stepsize=50


; Z500 DIFF VALUES
z50_diff_cscale=6
z50_diff_levs=[-40, -30, -20, -10, -5, -2, 2, 5, 10, 20, 30, 40]
z50_diff_ndecs=1
z50_diff_cols_req = N_ELEMENTS(z50_diff_levs) +1
;*****************************************************
;*****************************************************
;*****************************************************

; Z500 MEAN VALUES
z500_cscale=26
z500_minval=5000
z500_maxval=6000
z500_stepsize=50
z500_units='(m)'

; Z500 MEAN NH VALUES
z500_nh_cscale=26
z500_nh_minval=5000
z500_nh_maxval=6000
z500_nh_stepsize=50


; Z500 DIFF VALUES
z500_diff_cscale=6
z500_diff_levs=[-30, -25, -20, -15, -10, -5, 5, 10, 15, 20, 25, 30]
z500_diff_ndecs=1
z500_diff_cols_req = N_ELEMENTS(z500_diff_levs) +1

;*****************************************************
;*****************************************************
;*****************************************************
; Z250 MEAN VALUES
z250_cscale=26
z250_minval=9500
z250_maxval=11000
z250_stepsize=100
z250_units='(m)'
z250_ndecs=0

; Z250 MEAN NH VALUES
z250_nh_cscale=26
z250_nh_minval=9600
z250_nh_maxval=10600
z250_nh_stepsize=50
z250_nh_ndecs=0

; Z250 DIFF VALUES
z250_diff_cscale=6
z250_diff_levs=[-30, -25, -20, -15, -10, -5, 5, 10, 15, 20, 25, 30]
z250_diff_ndecs=1
z250_diff_cols_req = N_ELEMENTS(z250_diff_levs) +1
;*****************************************************
;*****************************************************
;*****************************************************

; PRECIP MEAN VALUES
precip_cscale=26
precip_minval=0.0
precip_maxval=8.0
precip_stepsize=0.4
precip_units='(x10!E5 kg m!E-2!N)'
precip_ndecs=1

; PRECIP MEAN NH VALUES
precip_nh_cscale=26
precip_nh_minval=0.0
precip_nh_maxval=10.0
precip_nh_stepsize=0.5
precip_nh_ndecs=1

; PRECIP DIFF VALUES
precip_diff_cscale=6
precip_diff_levs=[-2.0, -1.5, -1.0, -0.5, -0.2, -0.1, 0.1, 0.2, 0.5, 1.0, 1.5, 2.0]
precip_diff_ndecs=1
precip_diff_cols_req = N_ELEMENTS(precip_diff_levs)+1
;*****************************************************
;*****************************************************
;*****************************************************


; SNOW MEAN VALUES
snowdepth_cscale=26
snowdepth_minval=0
snowdepth_maxval=60000
snowdepth_stepsize=2000
snowdepth_units='(kg m!E-2!N)'
snowdepth_ndecs=1

; SNOW MEAN NH VALUES
snowdepth_nh_cscale=26
snowdepth_nh_minval=0
snowdepth_nh_maxval=60000
snowdepth_nh_stepsize=2000
snowdepth_nh_ndecs=1

; SNOW DIFF VALUES
snowdepth_diff_cscale=6
snowdepth_diff_levs=[-10000, -5000, -2000, -1000, -500, -100, 10, 50, 100, 200, 500, 1000]
snowdepth_diff_ndecs=1
snowdepth_diff_cols_req = N_ELEMENTS(precip_diff_levs)+1

;*****************************************************
;*****************************************************
;*****************************************************

; SHF MEAN VALUES
shf_cscale=26
shf_minval=-40
shf_maxval=80
shf_stepsize=10
shf_units='(W m!E2!N)'

; SHF MEAN NH VALUES
shf_nh_cscale=26
shf_nh_minval=-20
shf_nh_maxval=80
shf_nh_stepsize=10


; SHF DIFF VALUES
shf_diff_cscale=6
shf_diff_levs=[-30, -20, -10, -5, -2, 2, 5, 10, 20, 30]
shf_diff_ndecs=1
shf_diff_cols_req = N_ELEMENTS(shf_diff_levs) +1
;*****************************************************
;*****************************************************
;*****************************************************

; LHF MEAN VALUES
lhf_cscale=26
lhf_minval=-20
lhf_maxval=180
lhf_stepsize=10
lhf_units='(W m!E2!N)'

; LHF MEAN NH VALUES
lhf_nh_cscale=26
lhf_nh_minval=-20
lhf_nh_maxval=180
lhf_nh_stepsize=10


; LHF DIFF VALUES
lhf_diff_cscale=6
lhf_diff_levs=[-30, -20, -10, -5, -2, 2, 5, 10, 20, 30]
lhf_diff_ndecs=1
lhf_diff_cols_req = N_ELEMENTS(lhf_diff_levs) +1

;*****************************************************
;*****************************************************
;*****************************************************

; Zonal wind
; u850
u850_cscale=26
u850_minval=-10
u850_maxval=16
u850_stepsize=2
u850_units='(K)'

u850_nh_cscale=26
u850_nh_minval=-4
u850_nh_maxval=14
u850_nh_stepsize=2

u850_diff_cscale=6
u850_diff_levs = [-5, -3, -2, -1, -0.5, 0.5, 1, 2,3, 5]
u850_diff_ndecs = 1
u850_diff_cols_req = N_ELEMENTS(u850_diff_levs) +1
;*****************************************************
;*****************************************************
;*****************************************************

; SAT MEAN VALUES NH
; u500
u500_cscale=26
u500_minval=-10
u500_maxval=20
u500_stepsize=2
u500_units='(ms!E-1!N)'

u500_nh_cscale=26
u500_nh_minval=-4
u500_nh_maxval=20
u500_nh_stepsize=2


u500_diff_cscale=6
u500_diff_levs = [-5, -3, -2, -1, -0.5, 0.5, 1, 2,3, 5]
u500_diff_ndecs = 1
u500_diff_cols_req = N_ELEMENTS(u500_diff_levs) +1
;*****************************************************
;*****************************************************
;*****************************************************

; u50
u50_cscale=26
u50_minval=-10
u50_maxval=30
u50_stepsize=5
u50_units='(ms!E-1!N)'

u50_nh_cscale=26
u50_nh_minval=-10
u50_nh_maxval=50
u50_nh_stepsize=5


u50_diff_cscale=6
u50_diff_levs = [-5, -3, -2, -1, -0.5, 0.5, 1, 2,3, 5]
u50_diff_ndecs = 1
u50_diff_cols_req = N_ELEMENTS(u50_diff_levs) +1
;*****************************************************
;*****************************************************
;*****************************************************

; TEMPERATURE VERTICAL AVERAGES
tempva_cscale=26
tempva_minval=-40
tempva_maxval=20
tempva_stepsize=5
tempva_ndecs=0
tempva_units='(ms!E-1!N)'

tempva_nh_cscale=26
tempva_nh_minval=-30
tempva_nh_maxval=10
tempva_nh_stepsize=5
tempva_ndecs=0

tempva_diff_cscale=6
tempva_diff_levs = [-3, -2, -1, -0.6, -0.4, -0.2, 0.2, 0.4, 0.6, 1, 2,3]
tempva_diff_ndecs = 1
tempva_diff_cols_req = N_ELEMENTS(tempva_diff_levs) +1
;*****************************************************
;*****************************************************
;*****************************************************





; SAT DIFF VALUES
; u250

u250_cscale=26
u250_minval=-10
u250_maxval=30
u250_stepsize=2
u250_units='(K)'

u250_nh_cscale=26
u250_nh_minval=-4
u250_nh_maxval=30
u250_nh_stepsize=2

u250_diff_cscale=6
u250_diff_levs = [-5, -3, -2, -1, -0.5, 0.5, 1, 2,3, 5]
u250_diff_ndecs = 1
u250_diff_cols_req = N_ELEMENTS(u250_diff_levs) +1
;*****************************************************
;*****************************************************
;*****************************************************


;TAU MEAN VALUES
tau_cscale=9
tau_minval=0.0
tau_maxval=0.4
tau_stepsize=0.05
tau_units='(Nm!E2!N)'
tau_ncols=((tau_maxval - tau_minval)/tau_stepsize)+2
tau_ndecs=2

; TAU MEAN VALUES NH
tau_nh_cscale=9
tau_nh_minval=0.0
tau_nh_maxval=0.4
tau_nh_stepsize=0.05
tau_nh_units='(Nm!E2!N)'
tau_nh_ncols=((tau_maxval - tau_minval)/tau_stepsize)+2
tau_nh_ndecs=2

; TAU DIFF VALUES
tau_diff_cscale=6
tau_diff_levs = [-0.2, -0.1, -0.05, -0.02, -0.01, -0.005, 0.005, 0.01, 0.02, 0.05, 0.1, 0.2]
tau_diff_ndecs = 3
tau_diff_cols_req = N_ELEMENTS(tau_diff_levs) +1
;*****************************************************
;*****************************************************
;*****************************************************

nensbs_cexpt=30


; SAT MEAN VALUES
sat_cscale=26
sat_minval=-40
sat_maxval=40
sat_stepsize=4
sat_units='(K)'

; SAT MEAN VALUES NH
sat_nh_cscale=26
sat_nh_minval=-16
sat_nh_maxval=26
sat_nh_stepsize=2

; SAT DIFF VALUES
sat_diff_cscale=6
sat_diff_levs = [-5, -3, -2, -1, -0.5, 0.5, 1, 2,3, 5]
sat_diff_ndecs = 1
sat_diff_cols_req = N_ELEMENTS(sat_diff_levs) +1

;*****************************************************
;*****************************************************
;*****************************************************

; SEA ICE CONCENTRATION
latmin30=30
latmin45=45
latmin60=60

ice_cscale=25
ice_levs=[0, 0.1, 0.2, 0.3, 0.5, 0.8, 0.9, 0.95]
ice_cb_title='Fractional ice cover'
ice_ndecs=2

ice_diff_cscale=6
ice_diff_levs=[-0.5,-0.3,-0.2,-0.1,0.1,0.2,0.3,0.5]
ice_diff_cb_title='Difference in fractional ice cover'
ice_diff_ndecs=1


; SEA ICE THICKNESS
;latmin30=30
;latmin45=45
;latmin60=60

;sit_cscale=23
;sit_minval=0.0
;sit_maxval=4.0
;sit_stepsize=0.25
;sit_units='(m)'
;sit_ndecs=2
;sit_cb_title='Ice thickness'
;sit_ncols=18; FIX((sit_maxval - sit_maxval)/sit_stepsize)+2

;sit_diff_cscale=6
;sit_diff_levs=[-2.0,-1.0,-0.5,-0.2,0.2,0.5,1.0,2.0]
;sit_diff_cb_title='Difference in ice thickness'
;sit_diff_ndecs=1
;sit_diff_ncols=N_ELEMENTS(sit_diff_levs)+1



labels=['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z']
str_bimths=['AM','JJ','AS','ON','DJ','FM']
strmonths = ['jan','feb','mar','apr','may','jun','jul','aug','sep','oct','nov','dec']
str_mth_apr_start = ['apr','may','jun','jul','aug','sep','oct','nov','dec','jan','feb','mar']


STR_NS_SEASONS=['AMJ','JAS','OND','JFM']
STR_ST_SEASONS=['DJF','MAM','JJA','SON']
strseason=['djf','mam','jja','son']

; CONSTANTS
kelvin=273.15

; Pan Arctic
arctic_sea = 'Pan-Arctic'
arctic_long_min = 0
arctic_long_max = 359
arctic_lat_min  = 65
arctic_lat_max  = 89

; Laptev and East Siberian
sib_sea = 'Laptev-East-Siberian'
sib_long_min = 100
sib_long_max = 180
sib_lat_min  = 70
sib_lat_max  = 80

; Laptev and East Siberian and Chukchi
sibc_sea = 'Laptev-East-Siberian-Chukchi'
sibc_long_min = 100
sibc_long_max = 200
sibc_lat_min  = 65
sibc_lat_max  = 80


; Beaufort
bf_sea = 'Beaufort'
bf_long_min = 200
bf_long_max = 260
bf_lat_min  = 70
bf_lat_max  = 85

;barents-kara-sea
bk_sea = 'Barents-Kara'
bk_long_min = 20
bk_long_max = 100
bk_lat_min  = 65
bk_lat_max  = 82

;barents sea
b_sea = 'Barents'
b_long_min = 20
b_long_max = 60
b_lat_min  = 65
b_lat_max  = 82

;kara sea
k_sea = 'Kara'
k_long_min = 60
k_long_max = 100
k_lat_min  = 70
k_lat_max  = 82
