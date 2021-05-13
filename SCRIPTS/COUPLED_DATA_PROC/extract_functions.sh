###########################################################################
# Set up functions
###########################################################################

###########################################################################
extract_monthly_data () {
  
  DDIR=$1
  VARDIR=$2
  VARNAME=$3
  UMNAME=$4
  AVE=$5
  RAWDATA='RAWENSEMBLE/'
  RAWDIR=${DDIR}${RAWDATA}
 
  typeset -Z2 ENS
  for ENS in {1..30}; do
    echo ======================================
    echo
    echo ENSEMBLE MEMBER:  $ENS
    echo
    echo ======================================
  
    cd ${RAWDIR}en${ENS}
    echo ${RAWDIR}en${ENS}
  

   if [ "${AVE}" = "average" ]; then;    # EXTRACT DATA
    extract_and_average_data ${DDIR} ${VARDIR} ${VARNAME} ${UMNAME} ${ENS}
   else
    extract_data ${DDIR} ${VARDIR} ${VARNAME} ${UMNAME} ${ENS}
   fi 
   
  done

}
###########################################################################

###########################################################################
extract_data () {

  typeset -Z2 ENS
  DDIR=$1
  VARDIR=$2
  VARNAME=$3
  UMNAME=$4
  ENS=$5

  MONDIR='MONTHLY/'
  MDIR=${DDIR}${VARDIR}${MONDIR}

  MONTHS="jan feb mar apr may jun jul aug sep oct nov dec"

  mkdir -p ${MDIR}

  # MAKE FOLDER TO HOLD ENSEMBLE DATA
  mkdir -p ${MDIR}ENSB
  
  
  echo ================================================
  echo 
  echo    extracting data
  
  for MON in ${MONTHS}; do
    cdo selname,${UMNAME} *.pm*${MON}.nc ${MDIR}${VARNAME}_${ENS}_${MON}.nc
  done  
}
###########################################################################


###########################################################################
extract_and_average_data () {

  typeset -Z2 ENS
  DDIR=$1
  VARDIR=$2
  VARNAME=$3
  UMNAME=$4
  ENS=$5

  MONDIR='MONTHLY/'
  MDIR=${DDIR}${VARDIR}${MONDIR}

  MONTHS="jan feb mar apr may jun jul aug sep oct nov dec"

  mkdir -p ${MDIR}
  
  
  echo ================================================
  echo 
  echo    extracting daily data
  echo    averging to monthly
  
  for MON in ${MONTHS}; do
    cdo selname,${UMNAME} *.pd*${MON}.nc ${VARNAME}_${ENS}_daily.nc
    cdo timmean ${VARNAME}_${ENS}_daily.nc ${VARNAME}_${ENS}_${MON}.nc
    # remove temporary files
    rm -f *${ENS}_daily.nc
  done
  
  echo    making ensemble
 
  cdo mergetime ${VARNAME}_*.nc ${MDIR}${VARNAME}_${ENS}_tmp.nc
  cdo chname,${UMNAME},${VARNAME} ${MDIR}${VARNAME}_${ENS}_tmp.nc ${MDIR}${VARNAME}_${ENS}_mon.nc
  
  # remove temporary files
  rm -f ${MDIR}${VARNAME}_${ENS}_tmp.nc
  rm -f ${VARNAME}*

  # Clean up MONTHLY
   # MAKE FOLDER TO HOLD ENSEMBLE DATA
  mkdir -p ${MDIR}ENSB
  mv ${MDIR}${VARNAME}_${ENS}_mon.nc ${MDIR}ENSB
}
###########################################################################


###########################################################################
calc_mon_stats () {

  # ARG #1 is main data Directory
  # ARG #2 is variable directory name
  # ARG #3 is variable name

  typeset -Z2 EN
  DDIR=$1
  VARDIR=$2
  VARNAME=$3  
  MONDIR='MONTHLY/'
  WDIR=${DDIR}${VARDIR}${MONDIR}
  MDDIR=${DDIR}${VARDIR}${MONDIR}'ENSB/'
  cd ${WDIR}
  
  echo
  echo === ${WDIR} === 
  echo 
  echo Calculating monthly ensemble mean statistics
  echo 
  echo ================================================
 
  cd ${WDIR}
  
  # Calculate ensemble mean
  cdo ensmean ${MDDIR}${VARNAME}*mon.nc ${VARNAME}_ens_mon_mean.nc    
  
  # Calculate ensemble standard deviation
  cdo ensstd  ${MDDIR}${VARNAME}*mon.nc ${VARNAME}_ens_mon_std.nc    

  # Split into monthly files
  cdo splitmon ${VARNAME}_ens_mon_mean.nc ${VARNAME}_mm_
  cdo splitmon ${VARNAME}_ens_mon_std.nc  ${VARNAME}_mstd_

}
###########################################################################

####################################################################################################
extract_bimonthly_data (){
 
  # ARG #1 is main data Directory
  # ARG #2 is variable directory name
  # ARG #3 is variable name

  typeset -Z2 EN
  DDIR=$1
  VARDIR=$2
  VARNAME=$3  
  
  MONDIR='MONTHLY/ENSB/'
  BIMONDIR='BIMONTHLY/'
  MDIR=${DDIR}${VARDIR}${MONDIR}
  BDIR=${DDIR}${VARDIR}${BIMONDIR}

  mkdir -p ${BDIR}

  echo
  echo ================================================
  echo 
  echo Extracting ${VARNAME} bimonthly data
  echo 
  echo ================================================

  for EN in {1..30}; do 
     cdo selmon,04,05 ${MDIR}${VARNAME}_${EN}_mon.nc ${BDIR}${VARNAME}_${EN}_AM.nc 
     cdo selmon,06,07 ${MDIR}${VARNAME}_${EN}_mon.nc ${BDIR}${VARNAME}_${EN}_JJ.nc   
     cdo selmon,08,09 ${MDIR}${VARNAME}_${EN}_mon.nc ${BDIR}${VARNAME}_${EN}_AS.nc    
     cdo selmon,10,11 ${MDIR}${VARNAME}_${EN}_mon.nc ${BDIR}${VARNAME}_${EN}_ON.nc    
     cdo selmon,12,01 ${MDIR}${VARNAME}_${EN}_mon.nc ${BDIR}${VARNAME}_${EN}_DJ.nc  
     cdo selmon,02,03 ${MDIR}${VARNAME}_${EN}_mon.nc ${BDIR}${VARNAME}_${EN}_FM.nc  
     cdo timmean ${BDIR}${VARNAME}_${EN}_AM.nc ${BDIR}${VARNAME}_${EN}_AM_mean.nc 
     cdo timmean ${BDIR}${VARNAME}_${EN}_JJ.nc ${BDIR}${VARNAME}_${EN}_JJ_mean.nc 
     cdo timmean ${BDIR}${VARNAME}_${EN}_AS.nc ${BDIR}${VARNAME}_${EN}_AS_mean.nc 
     cdo timmean ${BDIR}${VARNAME}_${EN}_ON.nc ${BDIR}${VARNAME}_${EN}_ON_mean.nc 
     cdo timmean ${BDIR}${VARNAME}_${EN}_DJ.nc ${BDIR}${VARNAME}_${EN}_DJ_mean.nc 
     cdo timmean ${BDIR}${VARNAME}_${EN}_FM.nc ${BDIR}${VARNAME}_${EN}_FM_mean.nc 
      
  done
  
}
####################################################################################################

####################################################################################################
calc_bimonthly_stats (){
  
  # ARG #1 is main data Directory
  # ARG #2 is variable directory name
  # ARG #3 is variable name

  typeset -Z2 EN
  DDIR=$1
  VARDIR=$2
  VARNAME=$3  
  BIMONTHLY='BIMONTHLY/'
  WDIR=${DDIR}${VARDIR}${BIMONTHLY}
  
  cd ${WDIR}
  
  echo ================================================
  echo
  echo ${WDIR} 
  echo 
  echo Calculating seasonal ensemble mean statistics
  echo 
  echo ================================================
 
  for MONS in {'AM','JJ','AS','ON','DJ','FM'}; do
    cdo ensmean ${VARNAME}*${MONS}*mean* mslp_${MONS}_ensmean.nc    
    cdo ensstd ${VARNAME}*${MONS}*mean* mslp_${MONS}_ensstd.nc        
  done

  # MAKE FOLDER TO HOLD ENSEMBLE DATA
  mkdir -p ENSB
 
  # CLEAN UP
  for EN in {1..30}; do 
    mv ${VARNAME}*${EN}* ENSB
  done

}


####################################################################################################


####################################################################################################
extract_seas_data (){
 
  # ARG #1 is main data Directory
  # ARG #2 is variable directory name
  # ARG #3 is variable name

  typeset -Z2 EN
  DDIR=$1
  VARDIR=$2
  VARNAME=$3  
  
  MONDIR='MONTHLY/ENSB/'
  SEASDIR='SEASONALY/'
  MDIR=${DDIR}${VARDIR}${MONDIR}
  SDIR=${DDIR}${VARDIR}${SEASDIR}

  mkdir -p ${SDIR}   
  
  echo
  echo ================================================
  echo 
  echo Extracting ${VARNAME} seasonal data
  echo 
  echo ================================================

  for EN in {1..30}; do 
    # CALCULATE SEASONAL AVERAGES       
    cdo selmon,06,07,08 ${MDIR}${VARNAME}_${EN}_mon.nc ${SDIR}${VARNAME}_${EN}_JJA.nc
    cdo selmon,09,10,11 ${MDIR}${VARNAME}_${EN}_mon.nc ${SDIR}${VARNAME}_${EN}_SON.nc
    cdo selmon,12,01,02 ${MDIR}${VARNAME}_${EN}_mon.nc ${SDIR}${VARNAME}_${EN}_DJF.nc
    cdo timmean ${SDIR}mslp_${EN}_JJA.nc ${SDIR}mslp_${EN}_JJA_mean.nc
    cdo timmean ${SDIR}mslp_${EN}_SON.nc ${SDIR}mslp_${EN}_SON_mean.nc
    cdo timmean ${SDIR}mslp_${EN}_DJF.nc ${SDIR}mslp_${EN}_DJF_mean.nc
    
    
    # LONG WINTER       
    cdo selmon,11,12,01,02,03 ${MDIR}${VARNAME}_${EN}_mon.nc ${SDIR}${VARNAME}_${EN}_NDJFM.nc
    cdo timmean ${SDIR}${VARNAME}_${EN}_NDJFM.nc ${SDIR}${VARNAME}_${EN}_NDJFM_mean.nc
  done
  
}
####################################################################################################



####################################################################################################
calc_seas_stats (){
  
  # ARG #1 is main data Directory
  # ARG #2 is variable directory name
  # ARG #3 is variable name

  typeset -Z2 EN
  DDIR=$1
  VARDIR=$2
  VARNAME=$3  
  SEASDIR='SEASONALY/'
  WDIR=${DDIR}${VARDIR}${SEASDIR}
  
  cd ${WDIR}
  
  echo
  echo === ${WDIR} === 
  echo 
  echo Calculating seasonal ensemble mean statistics
  echo 
  echo ================================================
 
  for SEAS in {'JJA','SON','DJF','NDJFM'}; do
    cdo ensmean ${VARNAME}*${SEAS}*mean* ${VARNAME}_${SEAS}_ensmean.nc    
    cdo ensstd ${VARNAME}*${SEAS}*mean* ${VARNAME}_${SEAS}_ensstd.nc    
  done

  # MAKE FOLDER TO HOLD ENSEMBLE DATA
  mkdir -p ENSB
 
  # CLEAN UP
  for EN in {1..30}; do 
    mv ${VARNAME}*${EN}* ENSB
  done

}


####################################################################################################


####################################################################################################
extract_ns_seas_data (){
 
  # ARG #1 is main data Directory
  # ARG #2 is variable directory name
  # ARG #3 is variable name

  typeset -Z2 EN
  DDIR=$1
  VARDIR=$2
  VARNAME=$3  
  
  MONDIR='MONTHLY/ENSB/'
  SEASDIR='NON_STD_SEASONS/'
  MDIR=${DDIR}${VARDIR}${MONDIR}
  SDIR=${DDIR}${VARDIR}${SEASDIR}

  mkdir -p ${SDIR}   
  
  echo
  echo ================================================
  echo 
  echo Extracting ${VARNAME} seasonal data
  echo 
  echo ================================================

  for EN in {1..30}; do 
    # CALCULATE SEASONAL AVERAGES       
    cdo selmon,04,05,06 ${MDIR}${VARNAME}_${EN}_mon.nc ${SDIR}${VARNAME}_${EN}_AMJ.nc
    cdo selmon,07,08,09 ${MDIR}${VARNAME}_${EN}_mon.nc ${SDIR}${VARNAME}_${EN}_JAS.nc
    cdo selmon,10,11,12 ${MDIR}${VARNAME}_${EN}_mon.nc ${SDIR}${VARNAME}_${EN}_OND.nc
    cdo selmon,01,02,03 ${MDIR}${VARNAME}_${EN}_mon.nc ${SDIR}${VARNAME}_${EN}_JFM.nc
    cdo timmean ${SDIR}mslp_${EN}_AMJ.nc ${SDIR}mslp_${EN}_AMJ_mean.nc
    cdo timmean ${SDIR}mslp_${EN}_JAS.nc ${SDIR}mslp_${EN}_JAS_mean.nc
    cdo timmean ${SDIR}mslp_${EN}_OND.nc ${SDIR}mslp_${EN}_OND_mean.nc
    cdo timmean ${SDIR}mslp_${EN}_JFM.nc ${SDIR}mslp_${EN}_JFM_mean.nc
  done
  
}
####################################################################################################



####################################################################################################
calc_ns_seas_stats (){
  
  # ARG #1 is main data Directory
  # ARG #2 is variable directory name
  # ARG #3 is variable name

  typeset -Z2 EN
  DDIR=$1
  VARDIR=$2
  VARNAME=$3  
  SEASDIR='NON_STD_SEASONS/'
  WDIR=${DDIR}${VARDIR}${SEASDIR}
  
  cd ${WDIR}
  
  echo
  echo === ${WDIR} === 
  echo 
  echo Calculating seasonal ensemble mean statistics
  echo 
  echo ================================================
 
  for SEAS in {'AMJ','JAS','OND','JFM'}; do
    cdo ensmean ${VARNAME}*${SEAS}*mean* ${VARNAME}_${SEAS}_ensmean.nc    
    cdo ensstd ${VARNAME}*${SEAS}*mean* ${VARNAME}_${SEAS}_ensstd.nc    
  done

  # MAKE FOLDER TO HOLD ENSEMBLE DATA
  mkdir -p ENSB
 
  # CLEAN UP
  for EN in {1..30}; do 
    mv ${VARNAME}*${EN}* ENSB
  done

}


####################################################################################################



