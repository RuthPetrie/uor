#/usr/bin/sh
#include<data_processing_functions.sh>


# Program to calculate monthly surface pressure statistics
# RUN ON JASMIN

#  SEASON FOLDERS
#  
#  MONTHLY
#  BIMONTHLY
#  SEASONALY
#  NON_STD_SEASONS



# Version 1.0 Ruth Petrie 28-5-2014

# ADDITIONAL EXPORT PATH FOR REP ONLY
#export LD_LIBRARY_PATH=$LIBRARY_PATH:/opt/graphics/64/lib


##################################################################################
# include functions
source ./precip_functions.sh
# set up tools
setup cdo

# Set DATADIR
VARDIR='PRECIP/'
VARNAME=precip
UMNAME=precip

CDDIR=/net/quince/export/quince/data-05/wx019276/COUPLED_EXPTS/CTRL/
PDDIR=/net/quince/export/quince/data-05/wx019276/COUPLED_EXPTS/PERT/

extract_data=true
calculate_zonal_means=false
plot_precip=false
plot_precip_zonm_gbl=false
calculate_area_averages=false
##################################################################################
if [ "${extract_data}" = "true" ]; then; 

  echo EXTRACTING DATA

  # EXTRACT THE MONTHLY DATA AND MAKE MONTHLY STATISTICS
  #-------------------------------------------------------
#  extract_monthly_data ${CDDIR} ${VARDIR} ${VARNAME} ${UMNAME} 
#  extract_monthly_data ${PDDIR} ${VARDIR} ${VARNAME} ${UMNAME}
#  calc_monthly_stats ${CDDIR} ${VARDIR} ${VARNAME}
#  calc_monthly_stats ${PDDIR} ${VARDIR} ${VARNAME}

  # EXTRACT AND CALCULATE STATS OF BIMONTHLY DATA
  #-------------------------------------------------------
#  extract_bimonthly_data ${CDDIR} ${VARDIR} ${VARNAME}
#  extract_bimonthly_data ${PDDIR} ${VARDIR} ${VARNAME}

  # EXTRACT AND CALCULATE STATS OF STANDARD SEASONAL DATA
  #-------------------------------------------------------
  extract_seasonal_data ${CDDIR} ${VARDIR} ${VARNAME}
  extract_seasonal_data ${PDDIR} ${VARDIR} ${VARNAME}

  # EXTRACT AND CALCULATE STATS OF NON-STANDARD SEASONAL DATA
  #-------------------------------------------------------
#  extract_nsseasonal_data ${CDDIR} ${VARDIR} ${VARNAME}
#  extract_nsseasonal_data ${PDDIR} ${VARDIR} ${VARNAME}

fi
##################################################################################################

##################################################################################
if [ "${calculate_area_averages}" = "true" ]; then; 

  echo Calculating area averages

  # EXTRACT THE MONTHLY DATA AND MAKE MONTHLY STATISTICS
  #-------------------------------------------------------
#  calculate_monthly_area_aves ${CDDIR} ${VARDIR} ${VARNAME}  
#  calculate_monthly_area_aves ${PDDIR} ${VARDIR} ${VARNAME} 
#  calc_monthly_stats ${CDDIR} ${VARDIR} ${VARNAME}_eawm
#  calc_monthly_stats ${CDDIR} ${VARDIR} ${VARNAME}_eawmw
#  calc_monthly_stats ${CDDIR} ${VARDIR} ${VARNAME}_eawme
#  calc_monthly_stats ${PDDIR} ${VARDIR} ${VARNAME}_eawm
#  calc_monthly_stats ${PDDIR} ${VARDIR} ${VARNAME}_eawmw
#  calc_monthly_stats ${PDDIR} ${VARDIR} ${VARNAME}_eawme


  # EXTRACT AND CALCULATE STATS OF BIMONTHLY DATA
  #-------------------------------------------------------
#  extract_bimonthly_data ${CDDIR} ${VARDIR} precip_eawm_areaave
#  extract_bimonthly_data ${CDDIR} ${VARDIR} precip_eawmw_areaave
#  extract_bimonthly_data ${CDDIR} ${VARDIR} precip_eawme_areaave
#  extract_bimonthly_data ${PDDIR} ${VARDIR} precip_eawm_areaave
#  extract_bimonthly_data ${PDDIR} ${VARDIR} precip_eawmw_areaave
#  extract_bimonthly_data ${PDDIR} ${VARDIR} precip_eawme_areaave
  extract_bimonthly_data ${CDDIR} ${VARDIR} precip_eawmne_areaave
#  extract_bimonthly_data ${PDDIR} ${VARDIR} precip_eawmne_areaave

  # EXTRACT AND CALCULATE STATS OF STANDARD SEASONAL DATA
  #-------------------------------------------------------
#  extract_seasonal_data ${CDDIR} ${VARDIR} precip_eawm_areaave
#  extract_seasonal_data ${CDDIR} ${VARDIR} precip_eawmw_areaave
#  extract_seasonal_data ${CDDIR} ${VARDIR} precip_eawme_areaave
#  extract_seasonal_data ${PDDIR} ${VARDIR} precip_eawm_areaave
#  extract_seasonal_data ${PDDIR} ${VARDIR} precip_eawmw_areaave
#  extract_seasonal_data ${PDDIR} ${VARDIR} precip_eawme_areaave
  extract_seasonal_data ${CDDIR} ${VARDIR} precip_eawmne_areaave
#  extract_seasonal_data ${PDDIR} ${VARDIR} precip_eawmne_areaave

  # EXTRACT AND CALCULATE STATS OF NON-STANDARD SEASONAL DATA
  #-------------------------------------------------------
#  extract_nsseasonal_data ${CDDIR} ${VARDIR} precip_eawm
#  extract_nsseasonal_data ${CDDIR} ${VARDIR} precip_eawmw
#  extract_nsseasonal_data ${CDDIR} ${VARDIR} precip_eawme
#  extract_nsseasonal_data ${PDDIR} ${VARDIR} precip_eawm
#  extract_nsseasonal_data ${PDDIR} ${VARDIR} precip_eawmw
#  extract_nsseasonal_data ${PDDIR} ${VARDIR} precip_eawme

fi
##################################################################################################





##################################################################################
if [ "${calculate_zonal_means}" = "true" ]; then; 

  echo Calculating zonal means

  # EXTRACT THE MONTHLY DATA AND MAKE MONTHLY STATISTICS
  #-------------------------------------------------------
#  calculate_raw_monthly_zonal_means ${CDDIR} ${VARDIR} ${VARNAME} ${UMNAME} 
#  calculate_raw_monthly_zonal_means ${PDDIR} ${VARDIR} ${VARNAME} ${UMNAME}
#  calc_monthly_stats ${CDDIR} ${VARDIR} ${VARNAME}_zonm
#  calc_monthly_stats ${PDDIR} ${VARDIR} ${VARNAME}_zonm

  # EXTRACT AND CALCULATE STATS OF BIMONTHLY DATA
  #-------------------------------------------------------
#  extract_bimonthly_data ${CDDIR} ${VARDIR} precip_zonm
  extract_bimonthly_data ${PDDIR} ${VARDIR} precip_zonm

  # EXTRACT AND CALCULATE STATS OF STANDARD SEASONAL DATA
  #-------------------------------------------------------
  extract_seasonal_data ${CDDIR} ${VARDIR} precip_zonm
  extract_seasonal_data ${PDDIR} ${VARDIR} precip_zonm

  # EXTRACT AND CALCULATE STATS OF NON-STANDARD SEASONAL DATA
  #-------------------------------------------------------
  extract_nsseasonal_data ${CDDIR} ${VARDIR} precip_zonm
  extract_nsseasonal_data ${PDDIR} ${VARDIR} precip_zonm

fi
##################################################################################################


############################################
if [ "${plot_precip}" = "true" ]; then; 
# plot evolution and ensemble distribution.

  echo ==============================================
  echo  PLOT SENSIBLE HEAT FLUX RESPONSE
  echo ==============================================
 
  CDDIR=/net/quince/export/quince/data-05/wx019276/COUPLED_EXPTS/CTRL/
  PDDIR=/net/quince/export/quince/data-05/wx019276/COUPLED_EXPTS/PERT/
  IDLFILELOC='/home/wx019276/teacosi/idl_plotting/coupled_um_expts/coupled_analysis'
  cd $IDLFILELOC
  ODIR='/home/wx019276/figures/teacosi/coupled_expts/canalysis/'
  figoutdir=${ODIR}
  
#================================================================================================
  TEMPORAL='NON_STD_SEASONS/'
  CFILELOC=${CDDIR}${VARDIR}${TEMPORAL}
  PFILELOC=${PDDIR}${VARDIR}${TEMPORAL}
  
#  idl -e "plot_precip_resp_ns_seas" -args ${CFILELOC} ${PFILELOC} ${figoutdir} ${VARNAME} 
#================================================================================================
  TEMPORAL='SEASONALLY/'
  CFILELOC=${CDDIR}${VARDIR}${TEMPORAL}
  PFILELOC=${PDDIR}${VARDIR}${TEMPORAL}
  
  idl -e "plot_precip_resp_seas" -args ${CFILELOC} ${PFILELOC} ${figoutdir} ${VARNAME} 
#================================================================================================
  TEMPORAL='BIMONTHLY/'
  CFILELOC=${CDDIR}${VARDIR}${TEMPORAL}
  PFILELOC=${PDDIR}${VARDIR}${TEMPORAL}
 
# idl -e "plot_precip_resp_bimonthly" -args ${CFILELOC} ${PFILELOC} ${figoutdir} ${VARNAME} 
#================================================================================================
  
   
fi
############################################


############################################
if [ "${plot_precip_zonm_gbl}" = "true" ]; then; 
# plot evolution and ensemble distribution.

  echo ==============================================
  echo  PLOT PRECIP GLOBABL MEAN
  echo ==============================================
 
  CDDIR=/net/quince/export/quince/data-05/wx019276/COUPLED_EXPTS/CTRL/
  PDDIR=/net/quince/export/quince/data-05/wx019276/COUPLED_EXPTS/PERT/
  IDLFILELOC='/home/wx019276/teacosi/idl_plotting/coupled_um_expts/coupled_analysis'
  cd $IDLFILELOC
  ODIR='/home/wx019276/figures/teacosi/coupled_expts/canalysis/'
  figoutdir=${ODIR}

#================================================================================================
  TEMPORAL='SEASONALLY/'
  CFILELOC=${CDDIR}${VARDIR}${TEMPORAL}
  PFILELOC=${PDDIR}${VARDIR}${TEMPORAL}

  idl -e "plot_precip_zonm_seas" -args ${CFILELOC} ${PFILELOC} ${figoutdir} precip_zonm
#================================================================================================
  
#================================================================================================
  TEMPORAL='NON_STD_SEASONS/'
  CFILELOC=${CDDIR}${VARDIR}${TEMPORAL}
  PFILELOC=${PDDIR}${VARDIR}${TEMPORAL}

 # idl -e "plot_precip_zonm_ns_seas" -args ${CFILELOC} ${PFILELOC} ${figoutdir} precip_zonm
#================================================================================================
#  BIMONTHLY
  TEMPORAL='BIMONTHLY/'
  CFILELOC=${CDDIR}${VARDIR}${TEMPORAL}
  PFILELOC=${PDDIR}${VARDIR}${TEMPORAL}
 
# idl -e "plot_precip_zonm_bimonthly" -args ${CFILELOC} ${PFILELOC} ${figoutdir} precip_zonm
#================================================================================================
  
   
fi
############################################
















