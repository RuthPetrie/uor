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
UMNAME=u

CDDIR=/net/quince/export/quince/data-05/wx019276/COUPLED_EXPTS/CTRL/
PDDIR=/net/quince/export/quince/data-05/wx019276/COUPLED_EXPTS/PERT/

extract_data=true
plot_data=false



##################################################################################
if [ "${extract_data}" = "true" ]; then; 

  echo EXTRACTING DATA

  # EXTRACT THE MONTHLY DATA AND MAKE MONTHLY STATISTICS
  #-------------------------------------------------------
  heights="850 500 250 50"
#  HEIGHT=50
  for HEIGHT in ${heights}; do
  
    echo ${HEIGHT}
  
 #   extract_monthly_data ${CDDIR} ${VARDIR} ${VARNAME} ${UMNAME} ${HEIGHT}
    extract_monthly_data ${PDDIR} ${VARDIR} ${VARNAME} ${UMNAME} ${HEIGHT}
 #   calc_monthly_stats ${CDDIR} ${VARDIR} ${VARNAME} ${HEIGHT}
    calc_monthly_stats ${PDDIR} ${VARDIR} ${VARNAME} ${HEIGHT}

    # EXTRACT AND CALCULATE STATS OF BIMONTHLY DATA
    #-------------------------------------------------------
  #  extract_bimonthly_data ${CDDIR} ${VARDIR} ${VARNAME} ${HEIGHT}
    extract_bimonthly_data ${PDDIR} ${VARDIR} ${VARNAME} ${HEIGHT}

    # EXTRACT AND CALCULATE STATS OF STANDARD SEASONAL DATA
    #-------------------------------------------------------
  #  extract_seasonal_data ${CDDIR} ${VARDIR} ${VARNAME} ${HEIGHT}
    extract_seasonal_data ${PDDIR} ${VARDIR} ${VARNAME} ${HEIGHT}

    # EXTRACT AND CALCULATE STATS OF NON-STANDARD SEASONAL DATA
    #-------------------------------------------------------
   # extract_nsseasonal_data ${CDDIR} ${VARDIR} ${VARNAME} ${HEIGHT}
    extract_nsseasonal_data ${PDDIR} ${VARDIR} ${VARNAME} ${HEIGHT}

  done

fi
##################################################################################################





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








