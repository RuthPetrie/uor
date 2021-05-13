###########################################################################
# Set up functions
###########################################################################

###########################################################################
extract_monthly_data () {
  
  DDIR=$1
  VARDIR=$2
  VARNAME=$3
  UMNAME=$4
  HEIGHT=$5
  RAWDATA='RAWENSEMBLE/'
  RAWDIR=${DDIR}${RAWDATA}
 
  MONDIR='MONTHLY/'
  MEDIR=${DDIR}${VARDIR}${MONDIR}'ENSB/'
  
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
      cdo selname,${UMNAME} *.pm*${MON}.nc ${MEDIR}${VARNAME}_${ENS}_${MON}.nc
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
  MEDDIR=${DDIR}${VARDIR}${MONDIR}'ENSB/'
  cd ${MEDDIR}
  MONTHS="jan feb mar apr may jun jul aug sep oct nov dec"
 
  echo
  echo === ${MEDDIR} === 
  echo 
  echo Calculating monthly ensemble mean statistics
  echo 
  echo ================================================
   
  # Calculate ensemble mean
  
  for MON in ${MONTHS}; do
    cdo ensmean ${VARNAME}*${MON}.nc ${MDIR}${VARNAME}_${MON}_ensmean.nc    
    cdo ensstd  ${VARNAME}*${MON}.nc ${MDIR}${VARNAME}_${MON}_ensstd.nc    
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
  
  MON_ENS_DDIR='MONTHLY/ENSB/'
  BIMON_ENS_DDIR='BIMONTHLY/ENSB/'
  MEDIR=${DDIR}${VARDIR}${MON_ENS_DDIR}
  BDIR=${DDIR}${VARDIR}'BIMONTHLY/'
  BEDIR=${DDIR}${VARDIR}${BIMON_ENS_DDIR}

  mkdir -p ${BEDIR}
  
  echo
  echo ================================================
  echo 
  echo Extracting ${VARNAME} bimonthly data
  echo 
  echo ================================================

  cd ${MEDIR}
  for ENS in {1..30}; do 
     cdo mergetime ${VARNAME}_${ENS}_apr.nc ${VARNAME}_${ENS}_may.nc ${VARNAME}_${ENS}_ens_AM.nc 
     cdo mergetime ${VARNAME}_${ENS}_jun.nc ${VARNAME}_${ENS}_jul.nc ${VARNAME}_${ENS}_ens_JJ.nc 
     cdo mergetime ${VARNAME}_${ENS}_aug.nc ${VARNAME}_${ENS}_sep.nc ${VARNAME}_${ENS}_ens_AS.nc 
     cdo mergetime ${VARNAME}_${ENS}_oct.nc ${VARNAME}_${ENS}_nov.nc ${VARNAME}_${ENS}_ens_ON.nc 
     cdo mergetime ${VARNAME}_${ENS}_dec.nc ${VARNAME}_${ENS}_jan.nc ${VARNAME}_${ENS}_ens_DJ.nc 
     cdo mergetime ${VARNAME}_${ENS}_feb.nc ${VARNAME}_${ENS}_mar.nc ${VARNAME}_${ENS}_ens_FM.nc 
   done
 
   echo timemerge completed
   
   for ENS in {1..30}; do 
    for MONS in ${BIMONTHS}; do
       mv ${VARNAME}_${ENS}_ens_${MONS}.nc ${BEDIR}
    done
   done
    
   cd ${BEDIR}
   pwd
   echo 
   echo 
   for ENS in {1..30}; do 
     for MONS in ${BIMONTHS}; do
       cdo timmean ${VARNAME}_${ENS}_ens_${MONS}.nc ${VARNAME}_${ENS}_${MONS}.nc     
     done
   done

   for MONS in ${BIMONTHS}; do
     cdo ensmean ${BEDIR}${VARNAME}_??_${MONS}.nc ${BDIR}${VARNAME}_${MONS}_ensmean.nc    
     cdo ensstd  ${BEDIR}${VARNAME}_??_${MONS}.nc ${BDIR}${VARNAME}_${MONS}_ensstd.nc    
   done  
   
}
####################################################################################################

###########################################################################
calc_atl_zm_monthly_stats () {

  # ARG #1 is main data Directory
  # ARG #2 is variable directory name
  # ARG #3 is variable name
  typeset -Z2 ENS

  DDIR=$1
  VARDIR=$2
  VARNAME=$3  
  OVARNAME=$4  

  MONDIR='MONTHLY/'
  MDIR=${DDIR}${VARDIR}${MONDIR}
  MEDDIR=${DDIR}${VARDIR}${MONDIR}'ENSB/'
  cd ${MEDDIR}
  MONTHS="jan feb mar apr may jun jul aug sep oct nov dec"
 
  echo
  echo === ${MEDDIR} === 
  echo 
  echo Calculating monthly ensemble mean statistics
  echo 
  echo ================================================
   
  # Calculate ensemble mean
  
  for MON in ${MONTHS}; do
    for ENS in {1..30}; do
      cdo sellonlatbox,-75,0,0,90 ${VARNAME}_${ENS}_${MON}.nc ${VARNAME}_${ENS}_${MON}_tmp.nc 
      cdo zonmean ${VARNAME}_${ENS}_${MON}_tmp.nc ${OVARNAME}_${ENS}_${MON}.nc
    done
    rm -f *_tmp.nc
    cdo ensmean ${OVARNAME}_??_${MON}.nc ${MDIR}${OVARNAME}_${MON}_ensmean.nc     
    cdo ensstd  ${OVARNAME}_??_${MON}.nc ${MDIR}${OVARNAME}_${MON}_ensstd.nc    
  done  
}
###########################################################################


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
  echo Extracting ${VARNAME} non-standard seasonal data
  echo 
  echo ================================================

  cd ${MEDIR}
  
  for ENS in {1..30}; do 
     cdo mergetime ${VARNAME}_${ENS}_apr.nc ${VARNAME}_${ENS}_may.nc ${VARNAME}_${ENS}_jun.nc  ${VARNAME}_${ENS}_ens_AMJ.nc 
     cdo mergetime ${VARNAME}_${ENS}_jul.nc  ${VARNAME}_${ENS}_aug.nc ${VARNAME}_${ENS}_sep.nc ${VARNAME}_${ENS}_ens_JAS.nc 
     cdo mergetime ${VARNAME}_${ENS}_oct.nc ${VARNAME}_${ENS}_nov.nc ${VARNAME}_${ENS}_dec.nc  ${VARNAME}_${ENS}_ens_OND.nc 
     cdo mergetime ${VARNAME}_${ENS}_jan.nc ${VARNAME}_${ENS}_feb.nc ${VARNAME}_${ENS}_mar.nc ${VARNAME}_${ENS}_ens_JFM.nc 
     cdo mergetime ${VARNAME}_${ENS}_nov.nc ${VARNAME}_${ENS}_dec.nc ${VARNAME}_${ENS}_jan.nc ${VARNAME}_${ENS}_feb.nc ${VARNAME}_${ENS}_mar.nc ${VARNAME}_${ENS}_ens_NDJFM.nc 
   done
 
   echo non-standard timemerge completed   
   
  
   # MOVE DATA TO CORRECT DIRECTORY
   for ENS in {1..30}; do 
    for SEAS in ${NSSEAS}; do
       mv ${VARNAME}_${ENS}_ens_${SEAS}.nc ${NSEDIR}
    done
   done

   cd ${NSEDIR}
   pwd
   echo
   echo
   echo CALCULATING TIME MEANS OVER NON-STANDARD SEASON
   echo 
   for ENS in {1..30}; do 
     for SEAS in ${NSSEAS}; do
       cdo timmean ${VARNAME}_${ENS}_ens_${SEAS}.nc ${VARNAME}_${ENS}_${SEAS}.nc
     done
   done  
   
   
   echo
   echo CALCULATING NON-STANDARD SEASONAL ENSEMBLE MEAN AND STANDARD DEVIATIONS
   echo 
   
   for SEAS in ${NSSEAS}; do
     cdo ensmean ${VARNAME}_??_${SEAS}.nc ${NSDIR}${VARNAME}_${SEAS}_ensmean.nc    
     cdo ensstd  ${VARNAME}_??_${SEAS}.nc ${NSDIR}${VARNAME}_${SEAS}_ensstd.nc    
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
  mkdir -p ${SDIR}
  mkdir -p ${SEDIR}

  echo
  echo ================================================
  echo 
  echo Extracting ${VARNAME} seasonal data
  echo 
  echo ================================================
 
  cd ${MEDIR}

  for ENS in {1..30}; do 
     cdo mergetime ${VARNAME}_${ENS}_jun.nc ${VARNAME}_${ENS}_jul.nc ${VARNAME}_${ENS}_aug.nc  ${VARNAME}_${ENS}_ens_JJA.nc 
     cdo mergetime ${VARNAME}_${ENS}_sep.nc ${VARNAME}_${ENS}_oct.nc ${VARNAME}_${ENS}_nov.nc ${VARNAME}_${ENS}_ens_SON.nc 
     cdo mergetime ${VARNAME}_${ENS}_dec.nc ${VARNAME}_${ENS}_jan.nc ${VARNAME}_${ENS}_feb.nc ${VARNAME}_${ENS}_ens_DJF.nc 
   done
 
   echo timemerge completed
   
   # MOVE MEAN FILES TO CORRECT DIRECTORY
   for ENS in {1..30}; do 
     for SEAS in ${SSEASONS}; do
       mv ${VARNAME}_${ENS}_ens_${SEAS}.nc ${SEDIR}
     done
   done

  
   cd ${SEDIR}
   pwd
   echo
   echo
   echo CALCULATING TIME MEANS OVER STANDARD SEASON
   echo 

   for ENS in {1..30}; do 
     for SEAS in ${SSEASONS}; do
       cdo timmean ${VARNAME}_${ENS}_ens_${SEAS}.nc ${VARNAME}_${ENS}_${SEAS}.nc
     done  
   done
   
   echo
   echo CALCULATING STANDARD SEASONAL ENSEMBLE MEAN AND STANDARD DEVIATIONS
   echo 
   

   for SEAS in ${SSEASONS}; do
     cdo ensmean ${VARNAME}_??_${SEAS}.nc ${SDIR}${VARNAME}_${SEAS}_ensmean.nc    
     cdo ensstd  ${VARNAME}_??_${SEAS}.nc ${SDIR}${VARNAME}_${SEAS}_ensstd.nc    
   done  

}
####################################################################################################





