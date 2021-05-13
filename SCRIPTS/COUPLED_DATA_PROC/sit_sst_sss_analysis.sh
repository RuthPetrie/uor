#/usr/bin/ksh

# Extract ice concentration from control and perturbation runs

# include functions if needed
source ./sit_sst_sss_analysis_functions.sh
#######################################################################################

# set up tools
setup cdo

# Set up parameter names

# input
CDDIR='/net/quince/export/quince/data-05/wx019276/COUPLED_EXPTS/CTRL/RAWENSEMBLE/'
PDDIR='/net/quince/export/quince/data-05/wx019276/COUPLED_EXPTS/PERT/RAWENSEMBLE/'
SITID='sit'
SSTID='sst'
SSSID='sss'

SITDIR='SIT/'
SSTDIR='SST/'
SSSDIR='SSS/'

CEXPT='ctrl'
PEXPT='pert'
#
CDIR='/net/quince/export/quince/data-05/wx019276/COUPLED_EXPTS/CTRL/'
PDIR='/net/quince/export/quince/data-05/wx019276/COUPLED_EXPTS/PERT/'

OVARNAME=sic
AVARNAME=sia  # area var name

get_sit_data=false
get_sst_data=false
get_sss_data=false

calc_sit_means=false
calc_sst_means=true
calc_sss_means=false
calc_siv=false
plt_sst=false

############################################
if [ "${get_sit_data}" = "true" ]; then; 
 
 echo === RETRIEVING DATA ===
 get_sit_data ${CDIR} ${SITDIR} ${SITID} 2 hi aice
 get_sit_data ${PDIR} ${SITDIR} ${SITID} 2 hi aice

fi
############################################
############################################
if [ "${get_sst_data}" = "true" ]; then; 
 
 echo === RETRIEVING DATA ===
 get_sst_or_sss_data ${CDIR} ${SSTDIR} ${SSTID}  
 get_sst_or_sss_data ${PDIR} ${SSTDIR} ${SSTID}  

fi
############################################
############################################
if [ "${get_sss_data}" = "true" ]; then; 
 
 echo === RETRIEVING DATA ===

 get_sst_or_sss_data ${CDIR} ${SSSDIR} ${SSSID} 
 get_sst_or_sss_data ${PDIR} ${SSSDIR} ${SSSID}

fi
############################################


############################################
if [ "${calc_sit_means}" = "true" ]; then; 
 
 echo === CALCULATING MONTHLY STATS ===
 calc_monthly_stats ${CDIR} ${SITDIR} ${SITID}
 calc_monthly_stats ${PDIR} ${SITDIR} ${SITID}
 
 echo === CALCULATING BIMONTHLY STATS ===
 calc_bimonthly_stats ${CDIR} ${SITDIR} 'w'${SITID}
 calc_bimonthly_stats ${PDIR} ${SITDIR} 'w'${SITID}
 
 echo === CALCULATING SEASONAL STATS ===
 calc_seasonal_stats ${CDIR} ${SITDIR} 'w'${SITID}
 calc_seasonal_stats ${PDIR} ${SITDIR} 'w'${SITID}

 echo === CALCULATING NON_STANDARD_SEASONAL STATS ===
 calc_ns_seasonal_stats ${CDIR} ${SITDIR} 'w'${SITID}
 calc_ns_seasonal_stats ${PDIR} ${SITDIR} 'w'${SITID}

fi
############################################

############################################
if [ "${calc_sst_means}" = "true" ]; then; 
 
# echo === CALCULATING MONTHLY STATS ===
# calc_monthly_stats ${CDIR} ${SSTDIR} ${SSTID}
# calc_monthly_stats ${PDIR} ${SSTDIR} ${SSTID}

 echo === CALCULATING BIMONTHLY STATS ===
 calc_bimonthly_stats ${CDIR} ${SSTDIR} ${SSTID}
 calc_bimonthly_stats ${PDIR} ${SSTDIR} ${SSTID}

 echo === CALCULATING SEASONAL STATS ===
 calc_seasonal_stats ${CDIR} ${SSTDIR} ${SSTID}
 calc_seasonal_stats ${PDIR} ${SSTDIR} ${SSTID}

 echo === CALCULATING NON_STANDARD_SEASONAL STATS ===
 calc_ns_seasonal_stats ${CDIR} ${SSTDIR} ${SSTID}
 calc_ns_seasonal_stats ${PDIR} ${SSTDIR} ${SSTID}

fi
############################################


############################################
if [ "${calc_sss_means}" = "true" ]; then; 
 
# echo === CALCULATING MONTHLY STATS ===
 calc_monthly_stats ${CDIR} ${SSSDIR} ${SSSID}
 calc_monthly_stats ${PDIR} ${SSSDIR} ${SSSID}
 
 echo === CALCULATING BIMONTHLY STATS ===
 calc_bimonthly_stats ${CDIR} ${SSSDIR} ${SSSID}
 calc_bimonthly_stats ${PDIR} ${SSSDIR} ${SSSID}

 echo === CALCULATING SEASONAL STATS ===
 calc_seasonal_stats ${CDIR} ${SSSDIR} ${SSSID}
 calc_seasonal_stats ${PDIR} ${SSSDIR} ${SSSID}

 echo === CALCULATING NON_STANDARD_SEASONAL STATS ===
 calc_ns_seasonal_stats ${CDIR} ${SSSDIR} ${SSSID}
 calc_ns_seasonal_stats ${PDIR} ${SSSDIR} ${SSSID}

fi
############################################



############################################
if [ "${calc_siv}" = "true" ]; then; 
  
  echo =============================
  echo CALCULATING SEA ICE VOLUME
  echo =============================
 
  echo calculating a weighted sea ice thickness
  calc_thickness ${CDIR} ${SITDIR} ${SITID} hi aice
  calc_thickness ${PDIR} ${SITDIR} ${SITID} hi aice

  echo calculating a volume
  calc_volume ${CDIR}SIT/
  calc_volume ${PDIR}SIT/


fi
############################################



############################################
if [ "${plt_sst}" = "true" ]; then; 
# Plot september ice distributions for ctrl, pert and diff

  echo ============================
  echo  PLOTTING SSTS
  echo =============================


  IDLFILELOC='/home/wx019276/teacosi/idl_plotting/coupled_um_expts/coupled_analysis'
  cd $IDLFILELOC
  
  FIGOUT='/home/wx019276/figures/teacosi/coupled_expts/canalysis/sst_bimonthly.eps'


  idl -e "plot_sst_bimonthly" -args ${CDIR}SST/BIMONTHLY/ ${PDIR}SST/BIMONTHLY/ $FIGOUT 'sst'
  
fi
############################################




############################################
if [ "${plt_ice_evol}" = "true" ]; then; 
# plot evolution and ensemble distribution.

  echo =====================================
  echo  PLOT ENSEMBLE MONTHLY ICE EVOLUTION
  echo =====================================


  IDLFILELOC='/home/wx019276/teacosi/idl_plotting/coupled_um_expts/coupled_analysis/'
  cd $IDLFILELOC
  
  ICFILES=${OCDIR}MONTHLY/ENSB/ctrl_*_tot_nh_sia.nc
  IPFILES=${OPDIR}MONTHLY/ENSB/pert_*_tot_nh_sia.nc
  FIGOUT='/home/wx019276/figures/teacosi/coupled_expts/canalysis/'
  FIGTITLE='SEA_ICE_EVOLUTION'
   
  idl -e "plot_ice_area_evolution" -args ${ICFILES} ${IPFILES} ${FIGOUTDIR} ${FIGTITLE}
  
  
fi
############################################



############################################
if [ "${plt_mthly_sia_evol}" = "true" ]; then; 
# plot evolution and ensemble distribution.

  echo =====================================
  echo  PLOT SPATIAL EVOLUTION OF SIC
  echo =====================================


  IDLFILELOC='/home/wx019276/teacosi/idl_plotting/coupled_um_expts/coupled_analysis/'
  cd $IDLFILELOC
  
  FIGOUT='/home/wx019276/figures/teacosi/coupled_expts/canalysis/ens_monthly_sia_spatial_evol_apr_sep.eps'
  FIGOUT2='/home/wx019276/figures/teacosi/coupled_expts/canalysis/ens_monthly_sia_spatial_evol_oct_mar.eps'
 
   
  idl -e "plot_sia_mthly_spatial_evol" -args ${OCDIR}MONTHLY/  ${OPDIR}MONTHLY/ ${FIGOUT}  ${FIGOUT2}
  
fi
############################################



############################################
if [ "${plt_bimth_evol}" = "true" ]; then; 
# plot evolution and ensemble distribution.

  echo =============================================
  echo  PLOT SPATIAL EVOLUTION OF BIMONTHLY SIC
  echo =============================================


  IDLFILELOC='/home/wx019276/teacosi/idl_plotting/coupled_um_expts/coupled_analysis/'
  cd $IDLFILELOC
  
  FIGOUT='/home/wx019276/figures/teacosi/coupled_expts/canalysis/ens_bimonthly_sia_spatial_evol.eps'
 
   
  idl -e "plot_sia_bimthly_spatial_evol" -args ${OCDIR}BIMONTHLY/  ${OPDIR}BIMONTHLY/ ${FIGOUT} 
  
fi
############################################


############################################
if [ "${plt_seas_evol}" = "true" ]; then; 
# plot evolution and ensemble distribution.

  echo =====================================
  echo  PLOT SPATIAL EVOLUTION OF SIC
  echo =====================================


  IDLFILELOC='/home/wx019276/teacosi/idl_plotting/coupled_um_expts/coupled_analysis/'
  cd $IDLFILELOC
  
  FIGOUT='/home/wx019276/figures/teacosi/coupled_expts/canalysis/ens_seasonal_sia_spatial_evol.eps'
   
  idl -e "plot_sia_seasonal_spatial_evol" -args ${OCDIR}NON_STD_SEASONS/  ${OPDIR}NON_STD_SEASONS/ ${FIGOUT} 
  
fi
############################################


