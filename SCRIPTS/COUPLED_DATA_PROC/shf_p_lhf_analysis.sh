#/usr/bin/ksh

# CALCULATE THE TOTAL OF SURFACE SENSIBLE AND LATENT HEAT FLUXES.
# CALCULATE STATS
# PLOT THE DATA

# Version 1.0 Ruth Petrie 25-6-2014

# ADDITIONAL EXPORT PATH FOR REP ON QUINCE, WILL CONFLICT WITH IDL HIGHLIGHTING
#export LD_LIBRARY_PATH=$LIBRARY_PATH:/opt/graphics/64/lib


##################################################################################
# include functions
source ./shf_p_lhf_functions.sh
# set up tools
setup cdo

# Set DATADIR
SHFDIR='SHF/'
LHFDIR='LHF/'
SHF=shf
LHF=lhf
VARDIR='SH+LH/'
VARNAME='shf_p_lhf'

CDDIR=/net/quince/export/quince/data-05/wx019276/COUPLED_EXPTS/CTRL/
PDDIR=/net/quince/export/quince/data-05/wx019276/COUPLED_EXPTS/PERT/

data_analysis=true
plot_fluxes=true

##################################################################################
if [ "${data_analysis}" = "true" ]; then; 

  echo EXTRACTING DATA
 
  # EXTRACT THE MONTHLY DATA AND MAKE MONTHLY STATISTICS
  #-------------------------------------------------------
  
  # COMBINE THE MONTHLY SHF AND LHF DATA 
  add_monthly_data_calc_mthly_stats ${CDDIR} ${SHFDIR} ${LHFDIR} ${SHF} ${LHF} ${VARDIR} ${VARNAME}
  #add_monthly_data_calc_mthly_stats ${PDDIR} ${SHFDIR} ${LHFDIR} ${SHF} ${LHF} ${VARDIR} ${VARNAME}
      
  # EXTRACT AND CALCULATE STATS OF BIMONTHLY DATA
  #-------------------------------------------------------
  extract_bimonthly_data ${CDDIR} ${VARDIR} ${VARNAME}
 # extract_bimonthly_data ${PDDIR} ${VARDIR} ${VARNAME}

  # EXTRACT AND CALCULATE STATS OF STANDARD SEASONAL DATA
  #-------------------------------------------------------
  extract_seasonal_data ${CDDIR} ${VARDIR} ${VARNAME}
#  extract_seasonal_data ${PDDIR} ${VARDIR} ${VARNAME}

  # EXTRACT AND CALCULATE STATS OF NON-STANDARD SEASONAL DATA
  #-------------------------------------------------------
  extract_nsseasonal_data ${CDDIR} ${VARDIR} ${VARNAME}
#  extract_nsseasonal_data ${PDDIR} ${VARDIR} ${VARNAME}

fi
##################################################################################################


############################################
if [ "${plot_fluxes}" = "true" ]; then; 
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
  
 # idl -e "plot_shfplhf_resp_ns_seas" -args ${CFILELOC} ${PFILELOC} ${figoutdir} ${VARNAME} 
#================================================================================================
  TEMPORAL='BIMONTHLY/'
  CFILELOC=${CDDIR}${VARDIR}${TEMPORAL}
  PFILELOC=${PDDIR}${VARDIR}${TEMPORAL}
 
#  idl -e "plot_shfplhf_bimonthly" -args ${CFILELOC} ${PFILELOC} ${figoutdir} ${VARNAME} 
#================================================================================================
  TEMPORAL='SEASONALLY/'
  CFILELOC=${CDDIR}${VARDIR}${TEMPORAL}
  PFILELOC=${PDDIR}${VARDIR}${TEMPORAL}
 
  idl -e "plot_shfplhf_resp_seas" -args ${CFILELOC} ${PFILELOC} ${figoutdir} ${VARNAME} 
#================================================================================================
  
   
fi
############################################














