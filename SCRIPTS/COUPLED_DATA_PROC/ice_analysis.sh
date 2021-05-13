#/usr/bin/ksh

# Extract ice concentration from control and perturbation runs

# include functions if needed
source ./ice_analysis_functions.sh
#######################################################################################



# set up tools
setup cdo

# Set up parameter names

# input
n96areafile='/home/wx019276/teacosi/constants/n96_grid_area_km2.nc'
CDDIR='/net/quince/export/quince/data-05/wx019276/COUPLED_EXPTS/CTRL/'
PDDIR='/net/quince/export/quince/data-05/wx019276/COUPLED_EXPTS/PERT/'
UMNAME='iceconc'
CEXPT='ctrl'
PEXPT='pert'
#
VARDIR='SIC/'
VARNAME=sic
#AVARNAME=sia  # area var name

extract_data=false
convert_to_area=false
plt_sept_ice=false
plt_ice_evol=false
plt_mthly_sia_evol=false
plt_bimth_evol=true
plt_nsseas_evol=false
plt_seas_evol=false
############################################
if [ "${extract_data}" = "true" ]; then; 
  
  echo ============
  echo EXTRACT DATA
  echo ============
  # EXTRACT THE MONTHLY DATA AND MAKE MONTHLY STATISTICS
  #-------------------------------------------------------
  extract_monthly_data ${CDDIR} ${VARDIR} ${VARNAME} ${UMNAME} 
  extract_monthly_data ${PDDIR} ${VARDIR} ${VARNAME} ${UMNAME} 
  calc_monthly_stats ${CDDIR} ${VARDIR} ${VARNAME}
  calc_monthly_stats ${PDDIR} ${VARDIR} ${VARNAME}

  # EXTRACT AND CALCULATE STATS OF BIMONTHLY DATA
  #-------------------------------------------------------
  extract_bimonthly_data ${CDDIR} ${VARDIR} ${VARNAME}
  extract_bimonthly_data ${PDDIR} ${VARDIR} ${VARNAME}

  # EXTRACT AND CALCULATE STATS OF STANDARD SEASONAL DATA
  #-------------------------------------------------------
  extract_seasonal_data ${CDDIR} ${VARDIR} ${VARNAME}
  extract_seasonal_data ${PDDIR} ${VARDIR} ${VARNAME}

  # EXTRACT AND CALCULATE STATS OF NON-STANDARD SEASONAL DATA
  #-------------------------------------------------------
  extract_nsseasonal_data ${CDDIR} ${VARDIR} ${VARNAME}
  extract_nsseasonal_data ${PDDIR} ${VARDIR} ${VARNAME}


fi
############################################


############################################
if [ "${convert_to_area}" = "true" ]; then; 

  echo ===============
  echo CONVERT TO SIA
  echo ===============

  # extract ctrl ice data
  convert_sic_to_sia ${OCDIR}/MONTHLY/ ${CEXPT} ${n96areafile} ${UMID} ${AVARNAME}
  convert_sic_to_sia ${OPDIR}/MONTHLY/ ${PEXPT} ${n96areafile} ${UMID} ${AVARNAME}

fi
############################################




############################################
if [ "${plt_sept_ice}" = "true" ]; then; 
# Plot september ice distributions for ctrl, pert and diff

  echo ============================
  echo  PLOT SEPT ICE DISTRIBUTION
  echo =============================


  IDLFILELOC='/home/wx019276/teacosi/idl_plotting/coupled_um_expts/coupled_analysis'
  cd $IDLFILELOC
  
  CFILE='ctrl_sic_sep_em.nc'
  PFILE='pert_sic_sep_em.nc'
  FIGOUT='/home/wx019276/figures/teacosi/coupled_expts/canalysis/sept_sics.eps'
  SP1TITLE='SEPT_CONTROL_MEAN'
  SP2TITLE='SEPT_PERT_MEAN'
  SP3TITLE='SEPT_MEAN_DIFF'

#  idl -e "plot_sept_ice" -args ${OCDIR}MONTHLY/ ${CFILE} ${OPDIR}MONTHLY/ ${PFILE} ${FIGOUT} ${SP1TITLE} ${SP2TITLE} ${SP3TITLE}

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
  FIGOUT='/home/wx019276/figures/teacosi/coupled_expts/canalysis/ens_monthly_sia_evol.eps'
  FIGTITLE='SEA_ICE_EVOLUTION'
   
# idl -e "plot_ice_area_evolution" -args ${ICFILES} ${IPFILES} ${FIGOUT} ${FIGTITLE}
  
  
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
 
   
#  idl -e "plot_sia_mthly_spatial_evol" -args ${CDDIR}MONTHLY/  ${PDDIR}MONTHLY/ ${FIGOUT}  ${FIGOUT2}
  
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
  
  FIGOUT='/home/wx019276/figures/teacosi/coupled_expts/canalysis/ens_bimonthly_sic_spatial_evol.eps'
 
   
  idl -e "plot_sic_bimthly_spatial_evol" -args ${CDDIR}${VARDIR}BIMONTHLY/  ${PDDIR}${VARDIR}BIMONTHLY/ ${FIGOUT} 
 # idl -e "plot_sia_bimthly_spatial_evol" -args ${OCDIR}BIMONTHLY/  ${OPDIR}BIMONTHLY/ ${FIGOUT} 
  
fi
############################################


############################################
if [ "${plt_nsseas_evol}" = "true" ]; then; 
# plot evolution and ensemble distribution.

  echo =====================================
  echo  PLOT SPATIAL EVOLUTION OF SIC
  echo =====================================


  IDLFILELOC='/home/wx019276/teacosi/idl_plotting/coupled_um_expts/coupled_analysis/'
  cd $IDLFILELOC
  
  FIGOUT='/home/wx019276/figures/teacosi/coupled_expts/canalysis/ens_nsseasonal_sia_spatial_evol.eps'
   
#  idl -e "plot_sia_seasonal_spatial_evol" -args ${OCDIR}NON_STD_SEASONS/  ${OPDIR}NON_STD_SEASONS/ ${FIGOUT} 
  
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
   
#  idl -e "plot_sic_seasonal_spatial_evol" -args ${CDDIR}${VARDIR}SEASONALLY/  ${PDDIR}${VARDIR}SEASONALLY/ ${FIGOUT} sic
  
fi
############################################

