#/usr/bin/ksh

# Extract ice concentration from control and perturbation runs

# include functions if needed
source ./icedepth_analysis_functions.sh
#######################################################################################



# set up tools
setup cdo

# Set up parameter names

# input
CDDIR='/net/quince/export/quince/data-05/wx019276/COUPLED_EXPTS/CTRL/RAWENSEMBLE/'
PDDIR='/net/quince/export/quince/data-05/wx019276/COUPLED_EXPTS/PERT/RAWENSEMBLE/'
UMID='icedepth'
CEXPT='ctrl'
PEXPT='pert'
#
VARDIR='SIT/'
OCDIR='/net/quince/export/quince/data-05/wx019276/COUPLED_EXPTS/CTRL/'${VARDIR}
OPDIR='/net/quince/export/quince/data-05/wx019276/COUPLED_EXPTS/PERT/'${VARDIR}
OVARNAME='sit'

IDLFILELOC='/home/wx019276/teacosi/idl_plotting/coupled_um_expts/coupled_analysis'


extract_data=false
make_means=false
plot_sit_evol=true


############################################
if [ "${extract_data}" = "true" ]; then; 
  
  echo ============
  echo EXTRACT DATA
  echo ============
  
  # extract ctrl ice data
  extract_monthly_ice_data ${CDDIR} ${UMID} ${OCDIR} ${OVARNAME} ${CEXPT} 

  # extract pert ice data
  extract_monthly_ice_data ${PDDIR} ${UMID} ${OPDIR} ${OVARNAME} ${PEXPT}

fi
############################################


############################################
if [ "${make_means}" = "true" ]; then; 
  
  echo =============================
  echo  MAKING MEANS
  echo ===========================
  
  # make foldersfor bimonthly and seasonal data

#  BMCDDIR=${OCDIR}BIMONTHLY/
 # mkdir -p ${BMCDDIR}
  SCDDIR=${OCDIR}SEASONALLY/
  mkdir -p ${SCDDIR}
#  NSCDDIR=${OCDIR}NON_STD_SEASONS/
#  mkdir -p ${NSCDDIR}
  
#  BMPDDIR=${OPDIR}BIMONTHLY/
#  mkdir -p ${BMPDDIR}
  SPDDIR=${OPDIR}SEASONALLY/
  mkdir -p ${SPDDIR}
#  NSSPDDIR=${OPDIR}NON_STD_SEASONS/
#  mkdir -p ${NSSPDDIR}
  

  # calculate the bimothly and seasonal means for CTRL and PERT 
   
  LEXPT=ctrl 
 # make_bimonthly_aves ${OCDIR}MONTHLY/ ${BMCDDIR} ${LEXPT} ${OVARNAME}
  make_seas_aves ${OCDIR}MONTHLY/ ${SPDDIR} ${LEXPT} ${OVARNAME}
  #make_nsseas_aves ${OCDIR}MONTHLY/ ${NSCDDIR} ${LEXPT} ${OVARNAME}
  
  
  LEXPT=pert
 # make_bimonthly_aves ${OPDIR}MONTHLY/ ${BMPDDIR} ${LEXPT} ${OVARNAME}
  make_seas_aves ${OPDIR}MONTHLY/ ${SPDDIR} ${LEXPT} ${OVARNAME}
 # make_nsseas_aves ${OPDIR}MONTHLY/ ${NSSPDDIR} ${LEXPT} ${OVARNAME}
  
fi
############################################




############################################
if [ "${plot_sit_evol}" = "true" ]; then; 
# plot evolution and ensemble distribution.

  cd $IDLFILELOC

  echo =====================================
  echo  PLOT SPATIAL EVOLUTION OF SIC
  echo 
  echo  MONTHLY
 
  
  FIGOUT='/home/wx019276/figures/teacosi/coupled_expts/canalysis/ens_monthly_sit_spatial_evol_apr_sep.eps'
  FIGOUT2='/home/wx019276/figures/teacosi/coupled_expts/canalysis/ens_monthly_sit_spatial_evol_oct_mar.eps'
  
  idl -e "plot_sit_mthly_spatial_evol" -args ${OCDIR}MONTHLY/  ${OPDIR}MONTHLY/ ${FIGOUT}  ${FIGOUT2}
  
  echo 
  echo  BIMONTHLY

 
  FIGOUT='/home/wx019276/figures/teacosi/coupled_expts/canalysis/ens_bimonthly_sit_spatial_evol.eps'
  idl -e "plot_sit_bimthly_spatial_evol" -args ${OCDIR}BIMONTHLY/  ${OPDIR}BIMONTHLY/ ${FIGOUT} 

  echo 
  echo  SEASONALLY

  FIGOUT='/home/wx019276/figures/teacosi/coupled_expts/canalysis/ens_seasonal_sit_spatial_evol.eps'
  idl -e "plot_sit_seasonal_spatial_evol" -args ${OCDIR}NON_STD_SEASONS/  ${OPDIR}NON_STD_SEASONS/ ${FIGOUT} 
  
  echo =====================================

fi
############################################



