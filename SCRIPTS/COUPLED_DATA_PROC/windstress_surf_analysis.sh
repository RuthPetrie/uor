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
source ./windstress_functions.sh
# set up tools
setup cdo

# Set DATADIR
VARDIR='TAU/'
VARNAME=tau
UMNAMEX=taux_1
UMNAMEY=tauy_1

CDDIR=/net/quince/export/quince/data-05/wx019276/COUPLED_EXPTS/CTRL/
PDDIR=/net/quince/export/quince/data-05/wx019276/COUPLED_EXPTS/PERT/

extract_data=false
plot=true

##################################################################################
if [ "${extract_data}" = "true" ]; then; 

  echo EXTRACTING DATA

  # EXTRACT THE MONTHLY DATA AND MAKE MONTHLY STATISTICS
  #-------------------------------------------------------

  extract_monthly_data ${CDDIR} ${VARDIR} ${VARNAME} ${UMNAMEX} ${UMNAMEY}
 # extract_monthly_data ${PDDIR} ${VARDIR} ${VARNAME} ${UMNAMEX} ${UMNAMEY}
  calc_monthly_stats ${CDDIR} ${VARDIR} ${VARNAME} ${UMNAMEX} ${UMNAMEY}
#  calc_monthly_stats ${PDDIR} ${VARDIR} ${VARNAME} ${UMNAMEX} ${UMNAMEY}

  # EXTRACT AND CALCULATE STATS OF BIMONTHLY DATA
  #-------------------------------------------------------
#  extract_bimonthly_data ${CDDIR} ${VARDIR} ${VARNAME}
#  extract_bimonthly_data ${PDDIR} ${VARDIR} ${VARNAME} 

  # EXTRACT AND CALCULATE STATS OF STANDARD SEASONAL DATA
  #-------------------------------------------------------
  extract_seasonal_data ${CDDIR} ${VARDIR} ${VARNAME}
 # extract_seasonal_data ${PDDIR} ${VARDIR} ${VARNAME}

  # EXTRACT AND CALCULATE STATS OF NON-STANDARD SEASONAL DATA
  #-------------------------------------------------------
#  extract_nsseasonal_data ${CDDIR} ${VARDIR} ${VARNAME}
 # extract_nsseasonal_data ${PDDIR} ${VARDIR} ${VARNAME} 


fi
##################################################################################################


############################################
if [ "${plot}" = "true" ]; then; 
# plot evolution and ensemble distribution.

  echo ==============================================
  echo  PLOT SURFACE WIND STRESS
  echo ==============================================


  IDLFILELOC='/home/wx019276/teacosi/idl_plotting/coupled_um_expts/coupled_analysis/'
  cd $IDLFILELOC
  FIGOUTDIR='/home/wx019276/figures/teacosi/coupled_expts/canalysis/'
  
 # TIMEDIR='BIMONTHLY/'
 #  idl -e "plot_tau_bimonthly" -args ${CDDIR}${VARDIR}${TIMEDIR} ${PDDIR}${VARDIR}${TIMEDIR} ${FIGOUTDIR} ${VARNAME}
  
  
  TIMEDIR='SEASONALLY/'
  idl -e "plot_tau_seasonally" -args ${CDDIR}${VARDIR}${TIMEDIR} ${PDDIR}${VARDIR}${TIMEDIR} ${FIGOUTDIR} ${VARNAME} 

 #  TIMEDIR='NON_STD_SEASONS/'
 # idl -e "plot_tau_nsseas" -args ${CDDIR}${VARDIR}${TIMEDIR} ${PDDIR}${VARDIR}${TIMEDIR} ${FIGOUTDIR} ${VARNAME}
  
fi
############################################
