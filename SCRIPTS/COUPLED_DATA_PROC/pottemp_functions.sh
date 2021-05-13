###########################################################################
# Set up functions
###########################################################################

###########################################################################
extract_monthly_data () {
  
  DDIR=$1
  VARDIR=$2
  VARNAME=$3
  THETA=$4
  PRESSURE=$5
  
  RAWDATA='RAWENSEMBLE/'
  RAWDIR=${DDIR}${RAWDATA}
 
  MONDIR='MONTHLY/'
  MDIR=${DDIR}${VARDIR}${MONDIR}
  MEDIR=${DDIR}${VARDIR}${MONDIR}ENSB/
  
  MONTHS="jan feb mar apr may jun jul aug sep oct nov dec"

  # MAKE FOLDER TO HOLD ENSEMBLE DATA
  
  mkdir -p ${MEDIR}

 
  typeset -Z2 ENS
  for ENS in {1..30}; do
    echo ======================================
    echo
    echo ENSEMBLE MEMBER:  $ENS
    echo
    echo ======================================
  
    cd ${RAWDIR}en${ENS}
    echo ${RAWDIR}en${ENS}
  
    echo ================================================
    echo 
    echo    extracting data
    
    for MON in ${MONTHS}; do
      cdo selname,${THETA} *.pm*${MON}.nc ${MEDIR}theta_${ENS}_${MON}.nc
      cdo selname,${PRESSURE} *.pm*${MON}.nc ${MEDIR}pressure_${ENS}_${MON}.nc
      # temperature at the surface
      cdo selname,temp *.pm*${MON}.nc ${MEDIR}surf_temp_${ENS}_${MON}.nc
    done   
  done

  # convert theta to temperature
  cd ${MEDIR}
  for ENS in {1..30}; do
    for MON in ${MONTHS}; do
      cdo divc,101300 pressure_${ENS}_${MON}.nc scaled_p_${ENS}_${MON}_tmp.nc
      cdo pow,0.286 scaled_p_${ENS}_${MON}_tmp.nc theta_fact_${ENS}_${MON}_tmp.nc
      cdo mul theta_${ENS}_${MON}.nc theta_fact_${ENS}_${MON}_tmp.nc temperature_${ENS}_${MON}_tmp.nc
      cdo chname,theta,tempC temperature_${ENS}_${MON}_tmp.nc temp_${ENS}_${MON}_tmp.nc
      cdo subc,273.15 temp_${ENS}_${MON}_tmp.nc temp_${ENS}_${MON}.nc
      rm -f *tmp.nc 
    done
  done 
  

}
###########################################################################

###########################################################################
calc_monthly_stats () {

  # ARG #1 is main data Directory
  # ARG #2 is variable directory name
  # ARG #3 is variable name

  typeset -Z2 ENS
  DDIR=$1
  VARDIR=$2
  VARNAME=$3  
  MONDIR='MONTHLY/'
  MDIR=${DDIR}${VARDIR}${MONDIR}
  MEDIR=${DDIR}${VARDIR}${MONDIR}'ENSB/'
  cd ${MEDIR}
  MONTHS="jan feb mar apr may jun jul aug sep oct nov dec"
 
  echo
  echo === ${MEDIR} === 
  echo 
  echo Calculating monthly ensemble mean statistics
  echo 
  echo ================================================
 
  cd ${MEDIR}
  
  # Calculate ensemble mean
  
  for MON in ${MONTHS}; do
    cdo ensmean ${VARNAME}_??_${MON}.nc ${MDIR}${VARNAME}_${MON}_ensmean.nc    
    cdo ensstd  ${VARNAME}_??_${MON}.nc ${MDIR}${VARNAME}_${MON}_ensstd.nc    
  done  
}
###########################################################################

####################################################################################################
extract_bimonthly_data (){
 
  # ARG #1 is main data Directory
  # ARG #2 is variable directory name
  # ARG #3 is variable name

  DDIR=$1
  VARDIR=$2
  VARNAME=$3  
  typeset -Z2 ENS

  BIMONTHS="AM JJ AS ON DJ FM"
  
  MON_ENS_DIR='MONTHLY/ENSB/'
  BIMONDIR='BIMONTHLY/'
  MEDIR=${DDIR}${VARDIR}${MON_ENS_DIR}
  BDIR=${DDIR}${VARDIR}${BIMONDIR}
  BEDIR=${DDIR}${VARDIR}${BIMONDIR}'ENSB/'

  mkdir -p ${BEDIR}
  
  
  echo
  echo ================================================
  echo 
  echo Extracting ${VARNAME} bimonthly data
  echo 
  echo ================================================

  cd ${MEDIR}
  for ENS in {1..30}; do 
     cdo mergetime ${VARNAME}_${ENS}_apr.nc ${VARNAME}_${ENS}_may.nc ${BEDIR}${VARNAME}_${ENS}_ens_AM.nc 
     cdo mergetime ${VARNAME}_${ENS}_jun.nc ${VARNAME}_${ENS}_jul.nc ${BEDIR}${VARNAME}_${ENS}_ens_JJ.nc 
     cdo mergetime ${VARNAME}_${ENS}_aug.nc ${VARNAME}_${ENS}_sep.nc ${BEDIR}${VARNAME}_${ENS}_ens_AS.nc 
     cdo mergetime ${VARNAME}_${ENS}_oct.nc ${VARNAME}_${ENS}_nov.nc ${BEDIR}${VARNAME}_${ENS}_ens_ON.nc 
     cdo mergetime ${VARNAME}_${ENS}_dec.nc ${VARNAME}_${ENS}_jan.nc ${BEDIR}${VARNAME}_${ENS}_ens_DJ.nc 
     cdo mergetime ${VARNAME}_${ENS}_feb.nc ${VARNAME}_${ENS}_mar.nc ${BEDIR}${VARNAME}_${ENS}_ens_FM.nc 
   done
 
     
   cd ${BEDIR}
   pwd
   echo 
   echo 
   for ENS in {1..30}; do 
     for MONS in ${BIMONTHS}; do
       cdo timmean ${VARNAME}_${ENS}_ens_${MONS}.nc ${VARNAME}_${ENS}_${MONS}_mean.nc     
     done
   done

   for MONS in ${BIMONTHS}; do
     cdo ensmean ${VARNAME}_??_${MONS}_mean.nc ${BDIR}${VARNAME}_${MONS}_ensmean.nc    
     cdo ensstd  ${VARNAME}_??_${MONS}_mean.nc ${BDIR}${VARNAME}_${MONS}_ensstd.nc    
   done  
}
####################################################################################################

####################################################################################################
extract_nsseasonal_data (){
 
  # ARG #1 is main data Directory
  # ARG #2 is variable directory name
  # ARG #3 is variable name

  DDIR=$1
  VARDIR=$2
  VARNAME=$3  
  typeset -Z2 ENS

  NSSEAS="AMJ JAS OND JFM NDJFM"
  
  MON_ENS_DIR='MONTHLY/ENSB/'
  NSSEASDIR='NON_STD_SEASONS/'
  MEDIR=${DDIR}${VARDIR}${MON_ENS_DIR}
  NSDIR=${DDIR}${VARDIR}${NSSEASDIR}
  NSEDIR=${DDIR}${VARDIR}${NSSEASDIR}'ENSB/'
  
  mkdir -p ${NSEDIR}

  echo
  echo ================================================
  echo 
  echo Extracting ${VARNAME} bimonthly data
  echo 
  echo ================================================

  cd ${MEDIR}
  
  for ENS in {1..30}; do 
     cdo mergetime ${VARNAME}_${ENS}_apr.nc ${VARNAME}_${ENS}_may.nc ${VARNAME}_${ENS}_jun.nc  ${NSEDIR}${VARNAME}_${ENS}_ens_AMJ.nc 
     cdo mergetime ${VARNAME}_${ENS}_jul.nc  ${VARNAME}_${ENS}_aug.nc ${VARNAME}_${ENS}_sep.nc ${NSEDIR}${VARNAME}_${ENS}_ens_JAS.nc 
     cdo mergetime ${VARNAME}_${ENS}_oct.nc ${VARNAME}_${ENS}_nov.nc ${VARNAME}_${ENS}_dec.nc  ${NSEDIR}${VARNAME}_${ENS}_ens_OND.nc 
     cdo mergetime ${VARNAME}_${ENS}_jan.nc ${VARNAME}_${ENS}_feb.nc ${VARNAME}_${ENS}_mar.nc ${NSEDIR}${VARNAME}_${ENS}_ens_JFM.nc 
     cdo mergetime ${VARNAME}_${ENS}_nov.nc ${VARNAME}_${ENS}_dec.nc ${VARNAME}_${ENS}_jan.nc ${VARNAME}_${ENS}_feb.nc ${VARNAME}_${ENS}_mar.nc ${NSEDIR}${VARNAME}_${ENS}_ens_NDJFM.nc 
   done
 
   echo non-standard timemerge completed   
 

   cd ${NSEDIR}
   pwd
   echo
   echo
   echo CALCULATING TIME MEANS OVER NON-STANDARD SEASON
   echo 
   for ENS in {1..30}; do 
     for SEAS in ${NSSEAS}; do
       cdo timmean ${VARNAME}_${ENS}_ens_${SEAS}.nc ${VARNAME}_${ENS}_${SEAS}_mean.nc
     done
   done  
   
   
   echo
   echo CALCULATING NON-STANDARD SEASONAL ENSEMBLE MEAN AND STANDARD DEVIATIONS
   echo 
   
   for SEAS in ${NSSEAS}; do
     cdo ensmean ${VARNAME}_??_${SEAS}_mean.nc ../${VARNAME}_${SEAS}_ensmean.nc    
     cdo ensstd  ${VARNAME}_??_${SEAS}_mean.nc ../${VARNAME}_${SEAS}_ensstd.nc    
   done  
}
####################################################################################################



####################################################################################################
extract_seasonal_data (){
 
  # ARG #1 is main data Directory
  # ARG #2 is variable directory name
  # ARG #3 is variable name

  DDIR=$1
  VARDIR=$2
  VARNAME=$3  
  typeset -Z2 ENS

  SSEASONS="JJA SON DJF "
  
  MON_ENS_DIR='MONTHLY/ENSB/'
  SSEASDIR='SEASONALLY/'
  MEDIR=${DDIR}${VARDIR}${MON_ENS_DIR}
  SDIR=${DDIR}${VARDIR}${SSEASDIR}
  SEDIR=${DDIR}${VARDIR}${SSEASDIR}'ENSB/'
  
  mkdir -p ${SEDIR}

  echo
  echo ================================================
  echo 
  echo Extracting ${VARNAME} seasonal data
  echo 
  echo ================================================
 
  cd ${MEDIR}

  for ENS in {1..30}; do 
     cdo mergetime ${VARNAME}_${ENS}_jun.nc ${VARNAME}_${ENS}_jul.nc ${VARNAME}_${ENS}_aug.nc  ${SEDIR}${VARNAME}_${ENS}_ens_JJA.nc 
     cdo mergetime ${VARNAME}_${ENS}_sep.nc ${VARNAME}_${ENS}_oct.nc ${VARNAME}_${ENS}_nov.nc ${SEDIR}${VARNAME}_${ENS}_ens_SON.nc 
     cdo mergetime ${VARNAME}_${ENS}_dec.nc ${VARNAME}_${ENS}_jan.nc ${VARNAME}_${ENS}_feb.nc ${SEDIR}${VARNAME}_${ENS}_ens_DJF.nc 
   done
 
   echo timemerge completed
   
 
   cd ${SEDIR}
   pwd
   echo
   echo
   echo CALCULATING TIME MEANS OVER STANDARD SEASON
   echo 

   for ENS in {1..30}; do 
     for SEAS in ${SSEASONS}; do
       cdo timmean ${VARNAME}_${ENS}_ens_${SEAS}.nc ${VARNAME}_${ENS}_${SEAS}_mean.nc
     done  
   done
   
   echo
   echo CALCULATING STANDARD SEASONAL ENSEMBLE MEAN AND STANDARD DEVIATIONS
   echo 
   

   for SEAS in ${SSEASONS}; do
     cdo ensmean ${VARNAME}_??_${SEAS}_mean.nc ../${VARNAME}_${SEAS}_ensmean.nc    
     cdo ensstd  ${VARNAME}_??_${SEAS}_mean.nc ../${VARNAME}_${SEAS}_ensstd.nc    
   done  

}
####################################################################################################



