###########################################################################
# Set up functions
###########################################################################

###########################################################################
extract_monthly_data () {
  
  DDIR=$1
  VARDIR=$2
  VARNAME=$3
  UMNAME_X=$4
  UMNAME_Y=$5
  
#  echo DDIR $DDIR
#  echo VARDIR $VARDIR
#  echo VARNAME $VARNAME
#  echo UMNAME $UMNAME
#  echo HEIGHT $HEIGHT
  
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
      cdo selvar,${UMNAME_X},${UMNAME_Y} *.pm*${MON}.nc ${MEDIR}${VARNAME}_${ENS}_${MON}.nc
    done   
  done

}
###########################################################################

###########################################################################
calc_monthly_stats () {

  # ARG #1 is main data Directory
  # ARG #2 is variable directory name
  # ARG #3 is variable name

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
    cdo ensmean ${VARNAME}_??_${MON}.nc ${MDIR}${VARNAME}_${MON}_ensmean.nc    
    cdo ensstd  ${VARNAME}_??_${MON}.nc ${MDIR}${VARNAME}_${MON}_ensstd.nc    
    cdo ensvar  ${VARNAME}_??_${MON}.nc ${MDIR}${VARNAME}_${MON}_ensvar.nc    
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
     cdo mergetime ${VARNAME}_${ENS}_apr.nc ${VARNAME}_${ENS}_may.nc ${BEDIR}${VARNAME}_${ENS}_ens_AM.nc 
     cdo mergetime ${VARNAME}_${ENS}_jun.nc ${VARNAME}_${ENS}_jul.nc ${BEDIR}${VARNAME}_${ENS}_ens_JJ.nc 
     cdo mergetime ${VARNAME}_${ENS}_aug.nc ${VARNAME}_${ENS}_sep.nc ${BEDIR}${VARNAME}_${ENS}_ens_AS.nc 
     cdo mergetime ${VARNAME}_${ENS}_oct.nc ${VARNAME}_${ENS}_nov.nc ${BEDIR}${VARNAME}_${ENS}_ens_ON.nc 
     cdo mergetime ${VARNAME}_${ENS}_dec.nc ${VARNAME}_${ENS}_jan.nc ${BEDIR}${VARNAME}_${ENS}_ens_DJ.nc 
     cdo mergetime ${VARNAME}_${ENS}_feb.nc ${VARNAME}_${ENS}_mar.nc ${BEDIR}${VARNAME}_${ENS}_ens_FM.nc 
   done
 
   echo timemerge completed
   
#   for ENS in {1..30}; do 
#    for MONS in ${BIMONTHS}; do
#       mv ${VARNAME}_${ENS}_ens_${MONS}.nc ${BEDIR}
#    done
#   done
    
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
     cdo ensvar  ${BEDIR}${VARNAME}_??_${MONS}.nc ${BDIR}${VARNAME}_${MONS}_ensvar.nc    
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

  non_stand_seas="AMJ JAS OND JFM NDJFM"
  
  MON_ENS_DIR='MONTHLY/ENSB/'
  NSSEASDIR='NON_STD_SEASONS/'
  MEDIR=${DDIR}${VARDIR}${MON_ENS_DIR}
  NSSDIR=${DDIR}${VARDIR}${NSSEASDIR}
  NSSEDIR=${DDIR}${VARDIR}${NSSEASDIR}'ENSB/'
  
  mkdir -p ${NSSEDIR}

  echo
  echo ================================================
  echo 
  echo Extracting ${VARNAME} non-standard seasonal data
  echo 
  echo ================================================

  cd ${MEDIR}
  
  for ENS in {1..30}; do 
     cdo mergetime ${VARNAME}_${ENS}_apr.nc ${VARNAME}_${ENS}_may.nc ${VARNAME}_${ENS}_jun.nc  ${NSSEDIR}${VARNAME}_${ENS}_ens_AMJ.nc 
     cdo mergetime ${VARNAME}_${ENS}_jul.nc  ${VARNAME}_${ENS}_aug.nc ${VARNAME}_${ENS}_sep.nc ${NSSEDIR}${VARNAME}_${ENS}_ens_JAS.nc 
     cdo mergetime ${VARNAME}_${ENS}_oct.nc ${VARNAME}_${ENS}_nov.nc ${VARNAME}_${ENS}_dec.nc  ${NSSEDIR}${VARNAME}_${ENS}_ens_OND.nc 
     cdo mergetime ${VARNAME}_${ENS}_jan.nc ${VARNAME}_${ENS}_feb.nc ${VARNAME}_${ENS}_mar.nc ${NSSEDIR}${VARNAME}_${ENS}_ens_JFM.nc 
     cdo mergetime ${VARNAME}_${ENS}_nov.nc ${VARNAME}_${ENS}_dec.nc ${VARNAME}_${ENS}_jan.nc ${VARNAME}_${ENS}_feb.nc ${VARNAME}_${ENS}_mar.nc ${NSSEDIR}${VARNAME}_${ENS}_ens_NDJFM.nc 
   done
 
   echo non-standard timemerge completed   
   
   cd ${NSSEDIR}
   pwd
   echo
   echo
   echo CALCULATING TIME MEANS FOR NON-STANDARD SEASON
   echo 
   for ENS in {1..30}; do 
     for SEAS in ${non_stand_seas}; do
       cdo timmean ${VARNAME}_${ENS}_ens_${SEAS}.nc ${VARNAME}_${ENS}_${SEAS}_mean.nc
     done
   done  
   
   
   echo
   echo CALCULATING NON-STANDARD SEASONAL ENSEMBLE MEAN AND STANDARD DEVIATIONS
   echo 
   
   for SEAS in ${non_stand_seas}; do
     cdo ensmean ${VARNAME}_??_${SEAS}_mean.nc ${NSSDIR}${VARNAME}_${SEAS}_ensmean.nc    
     cdo ensstd  ${VARNAME}_??_${SEAS}_mean.nc ${NSSDIR}${VARNAME}_${SEAS}_ensstd.nc    
     cdo ensvar  ${VARNAME}_??_${SEAS}_mean.nc ${NSSDIR}${VARNAME}_${SEAS}_ensvar.nc    
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
     cdo mergetime ${VARNAME}_${ENS}_jun.nc ${VARNAME}_${ENS}_jul.nc ${VARNAME}_${ENS}_aug.nc  ${SEDIR}${VARNAME}_${ENS}_ens_JJA.nc 
     cdo mergetime ${VARNAME}_${ENS}_sep.nc ${VARNAME}_${ENS}_oct.nc ${VARNAME}_${ENS}_nov.nc ${SEDIR}${VARNAME}_${ENS}_ens_SON.nc 
     cdo mergetime ${VARNAME}_${ENS}_dec.nc ${VARNAME}_${ENS}_jan.nc ${VARNAME}_${ENS}_feb.nc ${SEDIR}${VARNAME}_${ENS}_ens_DJF.nc 
   done
 
   echo timemerge completed
   
   # MOVE MEAN FILES TO CORRECT DIRECTORY
#   for ENS in {1..30}; do 
#     for SEAS in ${SSEASONS}; do
#       mv ${VARNAME}_${ENS}_ens_${SEAS}.nc ${SEDIR}
#     done
#   done

  
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
     cdo ensmean ${VARNAME}_??_${SEAS}_mean.nc ${SDIR}${VARNAME}_${SEAS}_ensmean.nc    
     cdo ensstd  ${VARNAME}_??_${SEAS}_mean.nc ${SDIR}${VARNAME}_${SEAS}_ensstd.nc    
     cdo ensvar  ${VARNAME}_??_${SEAS}_mean.nc ${SDIR}${VARNAME}_${SEAS}_ensvar.nc    
   done  

}
####################################################################################################





