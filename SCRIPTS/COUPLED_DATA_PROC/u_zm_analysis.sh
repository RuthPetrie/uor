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
source ./u_functions.sh
# set up tools
setup cdo

# Set DATADIR
VARDIR='U/'
VARNAME=u
ZMVARNAME=u_zm
UMNAME=u_1
ATL_ZMVARNAME=u_atl2_zm
CDDIR=/net/quince/export/quince/data-05/wx019276/COUPLED_EXPTS/CTRL/
PDDIR=/net/quince/export/quince/data-05/wx019276/COUPLED_EXPTS/PERT/


extract_zm_data=false
calc_atlantic_zm=true
plot_data=false




##################################################################################
if [ "${extract_zm_data}" = "true" ]; then; 

  echo EXTRACTING DATA

  # EXTRACT THE MONTHLY DATA AND MAKE MONTHLY STATISTICS
  #-------------------------------------------------------
#  extract_zm_monthly_data ${CDDIR} ${VARDIR} ${VARNAME} ${UMNAME}
 # extract_zm_monthly_data ${PDDIR} ${VARDIR} ${VARNAME} ${UMNAME} 
 # calc_zm_monthly_stats ${CDDIR} ${VARDIR} ${VARNAME} ${ZMVARNAME} 
#  calc_zm_monthly_stats ${PDDIR} ${VARDIR} ${VARNAME} ${ZMVARNAME}

  # EXTRACT AND CALCULATE STATS OF BIMONTHLY DATA
  #-------------------------------------------------------
#  extract_zm_bimonthly_data ${CDDIR} ${VARDIR} ${ZMVARNAME}
#  extract_zm_bimonthly_data ${PDDIR} ${VARDIR} ${ZMVARNAME}

  # EXTRACT AND CALCULATE STATS OF STANDARD SEASONAL DATA
  #-------------------------------------------------------
  extract_zm_seasonal_data ${CDDIR} ${VARDIR} ${ZMVARNAME}
  extract_zm_seasonal_data ${PDDIR} ${VARDIR} ${ZMVARNAME}

  # EXTRACT AND CALCULATE STATS OF NON-STANDARD SEASONAL DATA
  #-------------------------------------------------------
  extract_zm_nsseasonal_data ${CDDIR} ${VARDIR} ${ZMVARNAME}
  extract_zm_nsseasonal_data ${PDDIR} ${VARDIR} ${ZMVARNAME}

#  done

fi
##########################################################################################


##################################################################################
if [ "${calc_atlantic_zm}" = "true" ]; then; 

  echo EXTRACTING DATA

  # EXTRACT THE MONTHLY DATA AND MAKE MONTHLY STATISTICS
  #-------------------------------------------------------
#  calc_atl_zm_monthly_stats ${CDDIR} ${VARDIR} ${VARNAME} ${ATL_ZMVARNAME} 
#  calc_atl_zm_monthly_stats ${PDDIR} ${VARDIR} ${VARNAME} ${ATL_ZMVARNAME}

  # EXTRACT AND CALCULATE STATS OF BIMONTHLY DATA
  #-------------------------------------------------------
  extract_zm_bimonthly_data ${CDDIR} ${VARDIR} ${ATL_ZMVARNAME}
  extract_zm_bimonthly_data ${PDDIR} ${VARDIR} ${ATL_ZMVARNAME}

  # EXTRACT AND CALCULATE STATS OF STANDARD SEASONAL DATA
  #-------------------------------------------------------
  extract_zm_seasonal_data ${CDDIR} ${VARDIR} ${ATL_ZMVARNAME}
  extract_zm_seasonal_data ${PDDIR} ${VARDIR} ${ATL_ZMVARNAME}

  # EXTRACT AND CALCULATE STATS OF NON-STANDARD SEASONAL DATA
  #-------------------------------------------------------
  extract_zm_nsseasonal_data ${CDDIR} ${VARDIR} ${ATL_ZMVARNAME}
  extract_zm_nsseasonal_data ${PDDIR} ${VARDIR} ${ATL_ZMVARNAME}

#  done

fi
##########################################################################################


##################################################################################################
if [ "${plot_data}" = "true" ]; then; 
  
  
  
#  for HEIGHT in ${heights}; do
    HEIGHT=850
   echo PLOT DATA ${HEIGHT}
    
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
    
#    idl -e "plot_u50_nsseas" -args ${CFILELOC} ${PFILELOC} ${figoutdir} ${VARNAME}${HEIGHT}
  #================================================================================================
    TEMPORAL='BIMONTHLY/'
    CFILELOC=${CDDIR}${VARDIR}${TEMPORAL}
    PFILELOC=${PDDIR}${VARDIR}${TEMPORAL}
   
#    idl -e "plot_u50_bimonthly" -args ${CFILELOC} ${PFILELOC} ${figoutdir} ${VARNAME}${HEIGHT}
  #================================================================================================
    TEMPORAL='SEASONALLY/'
    echo $TEMPORAL
    CFILELOC=${CDDIR}${VARDIR}${TEMPORAL}
    PFILELOC=${PDDIR}${VARDIR}${TEMPORAL}
    
    echo $CFILELOC
    echo $PFILELOC

    idl -e "plot_u850_seas" -args ${CFILELOC} ${PFILELOC} ${figoutdir} ${VARNAME}${HEIGHT}
  #================================================================================================
# done
  
fi
#######################################################################








