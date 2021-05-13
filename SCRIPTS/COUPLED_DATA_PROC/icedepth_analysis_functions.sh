############################################################################################
#
#  FUNCTIONS
#
############################################################################################
extract_monthly_ice_data () {
  
  # DECLARE INPUTS
  IDDIR=$1
  UMNAME=$2
  ODDIR=$3
  VARNAME=$4
  EXPT=$5
  
  echo ==========================================
  echo  PARAMETERS
  echo  ----------
  echo 
  echo IDDIR ${IDDIR}
  echo UMNAME ${UMNAME}
  echo ODDIR ${ODDIR}
  echo VARNAME ${VARNAME}
  echo 
  echo ==========================================

  # SETUP 
  typeset -Z2 ENS
  # 
  MONDIR='MONTHLY/'
  OMDIR=${ODDIR}${MONDIR}
  OMEDIR=${OMDIR}ENSB/
  MONTHS="jan feb mar apr may jun jul aug sep oct nov dec"
  
  # make monthly output directory if it doesn't already exist
  mkdir -p ${OMEDIR}
   
  # extract monthly fractional sea ice cover from each ensemble member and
  # put it in the monthly folder
    
  for ENS in {1..30}; do
    echo ======================================
    echo
    echo ENSEMBLE MEMBER:  ${ENS}
    echo
    echo 
    #
    cd ${IDDIR}en${ENS}
     
    for MON in ${MONTHS}; do
      cdo selname,${UMNAME} *.pm*${MON}.nc ${OMEDIR}${EXPT}_${ENS}_${OVARNAME}_${MON}.nc
    done  
    echo MONTHLY DATA EXTRACTED
    echo
    echo ================================================
  done
  
  # change to output directory
  cd ${OMEDIR}
  
  for MON in ${MONTHS}; do
    cdo ensmean ${EXPT}_??_${OVARNAME}_${MON}.nc ${OMDIR}${EXPT}_${OVARNAME}_${MON}_ensmean.nc
    cdo ensstd ${EXPT}_??_${OVARNAME}_${MON}.nc ${OMDIR}${EXPT}_${OVARNAME}_${MON}_ensstd.nc
  done
  
  # Clean up MONTHLY
#  for ENS in {1..30}; do
#   cdo mergetime ${EXPT}_${ENS}_${OVARNAME}_*.nc ${EXPT}_${ENS}_${OVARNAME}.nc
#   mv ${EXPT}_${ENS}_${OVARNAME}.nc ENSB
#  done
  
#  for MON in ${MONTHS}; do; rm -f ${EXPT}_??_${OVARNAME}_${MON}.nc; done
  
}
################################################################################################


################################################################################################
make_bimonthly_aves () {
  # INPUTS
  MDDIR=$1        # directory of monthly ice concentrations 
  BMDDIR=$2       # directory for bimonthly data
  EXPT=$3         # experiment name
  VAR=$4          # variable name
  
  typeset -Z2 ENS
  BIMONTHS="AM JJ AS ON DJ FM"
  echo 
  echo   MAKING BIMONTHLY MEANS
  echo 
  
  # MAKE BIMONTHLY ENSEMBLE FOLDER
  BEDIR=${BMDDIR}ENSB/
  mkdir -p ${BEDIR}
  cd ${MDDIR}ENSB/

  # EXTRACT BIMONTHLY ENSEMBLE DATA
  for ENS in {1..30}; do
    cdo mergetime ${EXPT}_${ENS}_${VAR}_apr.nc ${EXPT}_${ENS}_${VAR}_may.nc ${BEDIR}${EXPT}_${ENS}_${VAR}_AM.nc
    cdo mergetime ${EXPT}_${ENS}_${VAR}_jun.nc ${EXPT}_${ENS}_${VAR}_jul.nc ${BEDIR}${EXPT}_${ENS}_${VAR}_JJ.nc
    cdo mergetime ${EXPT}_${ENS}_${VAR}_aug.nc ${EXPT}_${ENS}_${VAR}_sep.nc ${BEDIR}${EXPT}_${ENS}_${VAR}_AS.nc
    cdo mergetime ${EXPT}_${ENS}_${VAR}_oct.nc ${EXPT}_${ENS}_${VAR}_nov.nc ${BEDIR}${EXPT}_${ENS}_${VAR}_ON.nc
    cdo mergetime ${EXPT}_${ENS}_${VAR}_dec.nc ${EXPT}_${ENS}_${VAR}_jan.nc ${BEDIR}${EXPT}_${ENS}_${VAR}_DJ.nc
    cdo mergetime ${EXPT}_${ENS}_${VAR}_feb.nc ${EXPT}_${ENS}_${VAR}_mar.nc ${BEDIR}${EXPT}_${ENS}_${VAR}_FM.nc
   done
  
  cd ${BEDIR}
  # MAKE BIMONTHLY MEAN DATA
  for ENS in {1..30}; do
    cdo timmean ${EXPT}_${ENS}_${VAR}_AM.nc ${EXPT}_${ENS}_${VAR}_AM_mean.nc
    cdo timmean ${EXPT}_${ENS}_${VAR}_JJ.nc ${EXPT}_${ENS}_${VAR}_JJ_mean.nc
    cdo timmean ${EXPT}_${ENS}_${VAR}_AS.nc ${EXPT}_${ENS}_${VAR}_AS_mean.nc
    cdo timmean ${EXPT}_${ENS}_${VAR}_ON.nc ${EXPT}_${ENS}_${VAR}_ON_mean.nc
    cdo timmean ${EXPT}_${ENS}_${VAR}_DJ.nc ${EXPT}_${ENS}_${VAR}_DJ_mean.nc
    cdo timmean ${EXPT}_${ENS}_${VAR}_FM.nc ${EXPT}_${ENS}_${VAR}_FM_mean.nc
  done 
  
  # MAKE ENSEMBLE MEAN DATA
  
  cdo ensmean ${EXPT}_??_${VAR}_AM_mean.nc ${BMDDIR}${EXPT}_${VAR}_AM_ensmean.nc
  cdo ensmean ${EXPT}_??_${VAR}_JJ_mean.nc ${BMDDIR}${EXPT}_${VAR}_JJ_ensmean.nc
  cdo ensmean ${EXPT}_??_${VAR}_AS_mean.nc ${BMDDIR}${EXPT}_${VAR}_AS_ensmean.nc
  cdo ensmean ${EXPT}_??_${VAR}_ON_mean.nc ${BMDDIR}${EXPT}_${VAR}_ON_ensmean.nc
  cdo ensmean ${EXPT}_??_${VAR}_DJ_mean.nc ${BMDDIR}${EXPT}_${VAR}_DJ_ensmean.nc
  cdo ensmean ${EXPT}_??_${VAR}_FM_mean.nc ${BMDDIR}${EXPT}_${VAR}_FM_ensmean.nc

  # MAKE ENSEMBLE STANDARD DEVIATION DATA
  
  cdo ensstd ${EXPT}_??_${VAR}_AM_mean.nc ${BMDDIR}${EXPT}_${VAR}_AM_ensstd.nc
  cdo ensstd ${EXPT}_??_${VAR}_JJ_mean.nc ${BMDDIR}${EXPT}_${VAR}_JJ_ensstd.nc
  cdo ensstd ${EXPT}_??_${VAR}_AS_mean.nc ${BMDDIR}${EXPT}_${VAR}_AS_ensstd.nc
  cdo ensstd ${EXPT}_??_${VAR}_ON_mean.nc ${BMDDIR}${EXPT}_${VAR}_ON_ensstd.nc
  cdo ensstd ${EXPT}_??_${VAR}_DJ_mean.nc ${BMDDIR}${EXPT}_${VAR}_DJ_ensstd.nc
  cdo ensstd ${EXPT}_??_${VAR}_FM_mean.nc ${BMDDIR}${EXPT}_${VAR}_FM_ensstd.nc
   
}
################################################################################################

################################################################################################
make_nsseas_aves () {
  # INPUTS
  MDDIR=$1        # directory of monthly ice concentrations 
  NSDDIR=$2       # directory for bimonthly data
  EXPT=$3         # experiment name
  VAR=$4
  
  typeset -Z2 ENS

  echo 
  echo   MAKING NON-STANDARD SEASONAL MEANS
  echo 
  
  # MAKE NON-STANDARD ENSEMBLE FOLDER
  NSEDIR=${NSDDIR}ENSB/
  mkdir -p ${NSEDIR}
  cd ${MDDIR}ENSB/
  
  
  # MAKE BIMONTHLY ENSEMBLE DATA
  for ENS in {1..30}; do
    cdo mergetime ${EXPT}_${ENS}_${VAR}_apr.nc  ${EXPT}_${ENS}_${VAR}_may.nc ${EXPT}_${ENS}_${VAR}_jun.nc ${NSEDIR}${EXPT}_${ENS}_${VAR}_AMJ.nc
    cdo mergetime ${EXPT}_${ENS}_${VAR}_jul.nc ${EXPT}_${ENS}_${VAR}_aug.nc ${EXPT}_${ENS}_${VAR}_sep.nc ${NSEDIR}${EXPT}_${ENS}_${VAR}_JAS.nc
    cdo mergetime ${EXPT}_${ENS}_${VAR}_oct.nc ${EXPT}_${ENS}_${VAR}_nov.nc ${EXPT}_${ENS}_${VAR}_dec.nc ${NSEDIR}${EXPT}_${ENS}_${VAR}_OND.nc
    cdo mergetime ${EXPT}_${ENS}_${VAR}_jan.nc ${EXPT}_${ENS}_${VAR}_feb.nc ${EXPT}_${ENS}_${VAR}_mar.nc ${NSEDIR}${EXPT}_${ENS}_${VAR}_JFM.nc
  done
  
  cd ${NSEDIR}
  for ENS in {1..30}; do
    cdo timmean ${EXPT}_${ENS}_${VAR}_AMJ.nc ${EXPT}_${ENS}_${VAR}_AMJ_mean.nc
    cdo timmean ${EXPT}_${ENS}_${VAR}_JAS.nc ${EXPT}_${ENS}_${VAR}_JAS_mean.nc
    cdo timmean ${EXPT}_${ENS}_${VAR}_OND.nc ${EXPT}_${ENS}_${VAR}_OND_mean.nc
    cdo timmean ${EXPT}_${ENS}_${VAR}_JFM.nc ${EXPT}_${ENS}_${VAR}_JFM_mean.nc
  done 
  
  # MAKE ENSEMBLE MEAN DATA
  
  cdo ensmean ${EXPT}_??_${VAR}_AMJ_mean.nc ${NSDIR}${EXPT}_${VAR}_AMJ_ensmean.nc
  cdo ensmean ${EXPT}_??_${VAR}_JAS_mean.nc ${NSDIR}${EXPT}_${VAR}_JAS_ensmean.nc
  cdo ensmean ${EXPT}_??_${VAR}_OND_mean.nc ${NSDIR}${EXPT}_${VAR}_OND_ensmean.nc
  cdo ensmean ${EXPT}_??_${VAR}_JFM_mean.nc ${NSDIR}${EXPT}_${VAR}_JFM_ensmean.nc

  # MAKE ENSEMBLE MEAN DATA
  
  cdo ensstd ${EXPT}_??_${VAR}_AMJ_mean.nc ${NSDDIR}${EXPT}_${VAR}_AMJ_ensstd.nc
  cdo ensstd ${EXPT}_??_${VAR}_JAS_mean.nc ${NSDDIR}${EXPT}_${VAR}_JAS_ensstd.nc
  cdo ensstd ${EXPT}_??_${VAR}_OND_mean.nc ${NSDDIR}${EXPT}_${VAR}_OND_ensstd.nc
  cdo ensstd ${EXPT}_??_${VAR}_JFM_mean.nc ${NSDDIR}${EXPT}_${VAR}_JFM_ensstd.nc
  
  
}
################################################################################################

################################################################################################
make_seas_aves () {
  # INPUTS
  MDDIR=$1        # directory of monthly ice concentrations 
  SDDIR=$2       # directory for bimonthly data
  EXPT=$3         # experiment name
  VAR=$4
  
  typeset -Z2 ENS

  echo 
  echo   MAKING NON-STANDARD SEASONAL MEANS
  echo 
  
  # MAKE NON-STANDARD ENSEMBLE FOLDER
  SEDIR=${SDDIR}ENSB/
  mkdir -p ${SEDIR}
  cd ${MDDIR}ENSB/
  
  
  # MAKE BIMONTHLY ENSEMBLE DATA
  for ENS in {1..30}; do
    cdo mergetime ${EXPT}_${ENS}_${VAR}_jun.nc  ${EXPT}_${ENS}_${VAR}_jul.nc ${EXPT}_${ENS}_${VAR}_aug.nc ${SEDIR}${EXPT}_${ENS}_${VAR}_JJA.nc
    cdo mergetime ${EXPT}_${ENS}_${VAR}_sep.nc ${EXPT}_${ENS}_${VAR}_oct.nc ${EXPT}_${ENS}_${VAR}_nov.nc ${SEDIR}${EXPT}_${ENS}_${VAR}_SON.nc
    cdo mergetime ${EXPT}_${ENS}_${VAR}_dec.nc ${EXPT}_${ENS}_${VAR}_jan.nc ${EXPT}_${ENS}_${VAR}_feb.nc ${SEDIR}${EXPT}_${ENS}_${VAR}_DJF.nc
  done
  
  cd ${SEDIR}
  for ENS in {1..30}; do
    cdo timmean ${EXPT}_${ENS}_${VAR}_JJA.nc ${EXPT}_${ENS}_${VAR}_JJA_mean.nc
    cdo timmean ${EXPT}_${ENS}_${VAR}_SON.nc ${EXPT}_${ENS}_${VAR}_SON_mean.nc
    cdo timmean ${EXPT}_${ENS}_${VAR}_DJF.nc ${EXPT}_${ENS}_${VAR}_DJF_mean.nc
  done 
  
  # MAKE ENSEMBLE MEAN DATA
  
  cdo ensmean ${EXPT}_??_${VAR}_JJA_mean.nc ${SDDIR}${EXPT}_${VAR}_JJA_ensmean.nc
  cdo ensmean ${EXPT}_??_${VAR}_SON_mean.nc ${SDDIR}${EXPT}_${VAR}_SON_ensmean.nc
  cdo ensmean ${EXPT}_??_${VAR}_DJF_mean.nc ${SDDIR}${EXPT}_${VAR}_DJF_ensmean.nc

  # MAKE ENSEMBLE MEAN DATA
  
  cdo ensstd ${EXPT}_??_${VAR}_JJA_mean.nc ${SDDIR}${EXPT}_${VAR}_JJA_ensstd.nc
  cdo ensstd ${EXPT}_??_${VAR}_SON_mean.nc ${SDDIR}${EXPT}_${VAR}_SON_ensstd.nc
  cdo ensstd ${EXPT}_??_${VAR}_DJF_mean.nc ${SDDIR}${EXPT}_${VAR}_DJF_ensstd.nc
  
  
}
################################################################################################


