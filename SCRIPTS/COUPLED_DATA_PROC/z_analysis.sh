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
source ./z_functions.sh
# set up tools
setup cdo

# Set DATADIR
VARDIR='GPH/ALL/'
VARNAME=GPH
UMNAME=ht_1
ATL_ZMVARNAME=GPH_ATL_ZM

CDDIR=/net/quince/export/quince/data-05/wx019276/COUPLED_EXPTS/CTRL/
PDDIR=/net/quince/export/quince/data-05/wx019276/COUPLED_EXPTS/PERT/

extract_data=false
calc_atlantic_zm=true
plot_data=false

#height=250

##################################################################################
if [ "${extract_data}" = "true" ]; then

  echo EXTRACTING DATA

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
##################################################################################################
##################################################################################
if [ "${calc_atlantic_zm}" = "true" ]; then; 

  echo CALCULATING ATLANTIC ZONAL MEAN DATA

  # EXTRACT THE MONTHLY DATA AND MAKE MONTHLY STATISTICS
  #-------------------------------------------------------
#  calc_atl_zm_monthly_stats ${CDDIR} ${VARDIR} ${VARNAME} ${ATL_ZMVARNAME} 
#  calc_atl_zm_monthly_stats ${PDDIR} ${VARDIR} ${VARNAME} ${ATL_ZMVARNAME}

  # EXTRACT AND CALCULATE STATS OF BIMONTHLY DATA
  #-------------------------------------------------------
  extract_bimonthly_data ${CDDIR} ${VARDIR} ${ATL_ZMVARNAME}
  extract_bimonthly_data ${PDDIR} ${VARDIR} ${ATL_ZMVARNAME}

  # EXTRACT AND CALCULATE STATS OF STANDARD SEASONAL DATA
  #-------------------------------------------------------
  extract_seasonal_data ${CDDIR} ${VARDIR} ${ATL_ZMVARNAME}
  extract_seasonal_data ${PDDIR} ${VARDIR} ${ATL_ZMVARNAME}

  # EXTRACT AND CALCULATE STATS OF NON-STANDARD SEASONAL DATA
  #-------------------------------------------------------
  extract_nsseasonal_data ${CDDIR} ${VARDIR} ${ATL_ZMVARNAME}
  extract_nsseasonal_data ${PDDIR} ${VARDIR} ${ATL_ZMVARNAME}

#  done

fi
##########################################################################################



##################################################################################################
if [ "${plot_data}" = "true" ]; then; 

  echo PLOT DATA
  
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
  
  idl -e "plot_z250_nsseas" -args ${CFILELOC} ${PFILELOC} ${figoutdir} ${VARNAME} 

#================================================================================================
  TEMPORAL='BIMONTHLY/'
  CFILELOC=${CDDIR}${VARDIR}${TEMPORAL}
  PFILELOC=${PDDIR}${VARDIR}${TEMPORAL}
 
 # idl -e "plot_z250_bimonthly" -args ${CFILELOC} ${PFILELOC} ${figoutdir} ${VARNAME} 
#================================================================================================
  TEMPORAL='SEASONALLY/'

  CFILELOC=${CDDIR}${VARDIR}${TEMPORAL}
  PFILELOC=${PDDIR}${VARDIR}${TEMPORAL}
 # idl -e "plot_z250_seas" -args ${CFILELOC} ${PFILELOC} ${figoutdir} ${VARNAME} 
#================================================================================================

fi
#######################################################################

















