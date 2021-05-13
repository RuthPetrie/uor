





nx_erai  = 512
ny_erai  = 256
nz_erai  = 37
nx_hgem  = 192
ny_hgem  = 145
nyu_hgem = 144
nz_hgem  = 17
nensmbrs = 30
nx_hadisst = 360
ny_hadisst = 180
nmths    = 12
nseas    = 4
kelvin = 273.15
pi = 3.1415926
rad_conv_fact = pi/180.0
deg_conv_fact = 180.0/pi


analysisloc = '/export/quince/data-06/wx019276/um_expts/analysis/'
publicfigout = '/home/wx019276/public_html/teacosi/'
hadisstloc = '/export/quince/data-06/wx019276/hadisst/'
erafigoutloc = '/home/wx019276/teacosi/figures/era/'
era_loc = '/net/jasmin/era/era-in/netc/monthly_means/'
local_era_loc = '/net/quince/export/quince/data-06/wx019276/era/'
era_srt_yr = 1979

nsidc_loc = '/export/quince/data-06/wx019276/nsidc/'
rsl_loc = '/export/quince/data-06/wx019276/rsl/'
quikscat_loc= '/export/quince/data-06/wx019276/QuikSCAT_v4/'

months = INTARR(12)
months = [1,2,3,4,5,6,7,8,9,10,11,12]
bimonths = INTARR(6)
bimonths = [1,2,3,4,5,6]
seasons = INTARR(4)
seasons = [1,2,3,4]

diff_cs = 6
hot_cs  = 9 

snr_levs      = [1.0, 1.5, 2.0, 3.0]
snr_decs      = 1
signif_levs   = [0.80,0.90, 0.95, 0.99]
signif_decs   = 2
n_cols_signif = N_ELEMENTS(signif_levs)+1

ice_diff_levs = [-0.5, -0.4, -0.3, -0.15, -0.1, -0.05, 0.05, 0.1, 0.15, 0.3, 0.4, 0.5]
ice_diff_decs = 2
n_cols_ice_diff = N_ELEMENTS(ice_diff_levs) +1

sst_diff_levs = [-3, -2, -1, -0.75, -0.5, -0.25, 0.25, 0.5, 0.75, 1, 2,3]
sst_diff_decs = 2
n_sst_diff_cols_req = N_ELEMENTS(sst_diff_levs) +1


srcs = 1
srncols = 22
srmintemp = 0
srmaxtemp = 10
srstep = 0.5
srdecs = 1

poltempcs = 1
poltempncols = 22
polmintemp = -40
polmaxtemp = 40
poltempstep = 4
polntempdecs = 0

globtempcs = 1
globtempncols = 22
globmintemp = -40
globmaxtemp = 40
globtempstep = 4
globntempdecs = 0


polmslpcs = 1
polmslpncols = 22
polminmslp = 990
polmaxmslp = 1030
polmslpstep = 3
polnmslpdecs = 0

globmslpcs = 1
globmslpncols = 24
globminmslp = 980
globmaxmslp = 1035
globmslpstep = 2.5
globnmslpdecs = 1

mslp_diff_levs = [-10, -5, -3, -2, -1, -0.5, 0.5, 1, 2,3, 5, 10]
mslp_diff_decs = 1
n_mslp_diff_cols_req = N_ELEMENTS(mslp_diff_levs) +1

mslp_diff_fine_levs = [-5, -4, -3, -2,-1.5, -1,-0.5, 0.5, 1,1.5, 2, 3, 4,5]
mslp_diff_fine_decs = 2
n_mslp_diff_fine_cols_req = N_ELEMENTS(mslp_diff_fine_levs) +1


temp_diff_levs = [-10,-5,-3,-2,-1,-0.5,0.5,1,2,3,5,10]
temp_diff_decs = 1
n_temp_diff_cols_req = N_ELEMENTS(temp_diff_levs) +1

temp_diff_fine_levs = [-5,-3,-2.5,-2,-1.5,-1,-0.75,-0.5,-0.25,0.25,0.5,0.75,1,1.5,2,2.5,3,5]
temp_diff_fine_decs = 2
n_temp_diff_fine_cols_req = N_ELEMENTS(temp_diff_fine_levs) +1

z_diff_fine_levs = [-1000, -900, -850, -800, -600, -100, -50, -40, -30, -20,-15, -10,-5, 5, 10,15, 20, 30, 40,50, 100, 600, 800, 850, 900, 1000]
z_diff_fine_decs = 2
n_z_diff_fine_cols_req = N_ELEMENTS(z_diff_fine_levs) +1


strmonths = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec']

