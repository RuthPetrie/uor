#/usr/bin/ksh
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
source ./temp_functions.sh
# set up tools
setup cdo

# Set DATADIR
VARDIR='TEMP/'
VARNAME=temp
UMNAME1=theta
UMNAME2=p_1

CDDIR=/net/quince/export/quince/data-05/wx019276/COUPLED_EXPTS/CTRL/
PDDIR=/net/quince/export/quince/data-05/wx019276/COUPLED_EXPTS/PERT/


extract_data=false
calc_stats=true
plot_temps=false

##################################################################################
if [ "${extract_data}" = "true" ]; then; 

  echo EXTRACTING DATA

  # EXTRACT THE MONTHLY DATA AND MAKE MONTHLY STATISTICS
  #-------------------------------------------------------
  extract_monthly_data ${CDDIR} ${VARDIR} ${VARNAME} ${UMNAME1} ${UMNAME2} 
  extract_monthly_data ${PDDIR} ${VARDIR} ${VARNAME} ${UMNAME1} ${UMNAME2} 
fi
##################################################################################################
##################################################################################
if [ "${calc_stats}" = "true" ]; then; 

  echo CALCULATING MONTHLY STATS
#  calc_monthly_stats ${CDDIR} ${VARDIR} temp
#  calc_monthly_stats ${PDDIR} ${VARDIR} temp
#  calc_monthly_stats ${CDDIR} ${VARDIR} surf_temp
#  calc_monthly_stats ${PDDIR} ${VARDIR} surf_temp

  echo CALCULATE STATS OF BIMONTHLY DATA
  #-------------------------------------------------------
#  extract_bimonthly_data ${CDDIR} ${VARDIR} temp
#  extract_bimonthly_data ${PDDIR} ${VARDIR} temp
#  extract_bimonthly_data ${CDDIR} ${VARDIR} surf_temp
#  extract_bimonthly_data ${PDDIR} ${VARDIR} surf_temp

  echo CALCULATE STATS OF STANDARD SEASONAL DATA
  #-------------------------------------------------------
#  extract_seasonal_data ${CDDIR} ${VARDIR} temp
#  extract_seasonal_data ${PDDIR} ${VARDIR} temp
#  extract_seasonal_data ${CDDIR} ${VARDIR} surf_temp
 # extract_seasonal_data ${PDDIR} ${VARDIR} surf_temp

  echo CALCULATE STATS OF NON-STANDARD SEASONAL DATA
  #-------------------------------------------------------
  extract_nsseasonal_data ${CDDIR} ${VARDIR} temp
  extract_nsseasonal_data ${PDDIR} ${VARDIR} temp
  extract_nsseasonal_data ${CDDIR} ${VARDIR} surf_temp
  extract_nsseasonal_data ${PDDIR} ${VARDIR} surf_temp

fi
##################################################################################################


############################################
if [ "${plot_temps}" = "true" ]; then; 
# plot evolution and ensemble distribution.

  echo ========================================
  echo  PLOT SURFACE AIR TEMPERATURE RESPONSE
  echo ========================================


  IDLFILELOC='/home/wx019276/teacosi/idl_plotting/coupled_um_expts/coupled_analysis/'
  cd $IDLFILELOC
  
  FIGOUTDIR='/home/wx019276/figures/teacosi/coupled_expts/canalysis/'

  idl -e "plot_sat_resp_seasonally" -args ${CDDIR}${VARDIR} ${PDDIR}${VARDIR} ${FIGOUTDIR} sat  
  idl -e "plot_sat_resp_ns_seas" -args ${CDDIR}${VARDIR} ${PDDIR}${VARDIR} ${FIGOUTDIR} sat  
  idl -e "plot_sat_resp_bimonthly" -args ${CDDIR}${VARDIR} ${PDDIR}${VARDIR} ${FIGOUTDIR} sat
  
fi
############################################
















