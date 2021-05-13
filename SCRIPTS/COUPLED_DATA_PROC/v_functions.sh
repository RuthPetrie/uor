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
      cdo -timmean -sellevel,${HEIGHT} -selvar,${UMNAME} *.pe*${MON}.nc ${MEDIR}${VARNAME}${HEIGHT}_${ENS}_${MON}.nc
    done   
  done

}
###########################################################################

###########################################################################
extract_zm_monthly_data () {
  
  DDIR=$1
  VARDIR=$2
  VARNAME=$3
  UMNAME=$4

  
#  echo DDIR $DDIR
#  echo VARDIR $VARDIR
#  echo VARNAME $VARNAME
#  echo UMNAME $UMNAME
  
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
      cdo selvar,${UMNAME} *.pm*${MON}.nc ${MEDIR}${VARNAME}_${ENS}_${MON}.nc
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
  HEIGHT=$4
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
    cdo ensmean ${VARNAME}${HEIGHT}_??_${MON}.nc ${MDIR}${VARNAME}${HEIGHT}_${MON}_ensmean.nc    
    cdo ensstd  ${VARNAME}${HEIGHT}_??_${MON}.nc ${MDIR}${VARNAME}${HEIGHT}_${MON}_ensstd.nc    
  done  
}
###########################################################################

###########################################################################
calc_zm_monthly_stats () {

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
      cdo zonmean ${VARNAME}_${ENS}_${MON}.nc ${OVARNAME}_${ENS}_${MON}.nc
    done
    cdo ensmean ${OVARNAME}_??_${MON}.nc ${MDIR}${OVARNAME}_${MON}_ensmean.nc     
    cdo ensstd  ${OVARNAME}_??_${MON}.nc ${MDIR}${OVARNAME}_${MON}_ensstd.nc    
  done  
}
###########################################################################

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
      cdo sellonlatbox,-60,0,0,90 ${VARNAME}_${ENS}_${MON}.nc ${VARNAME}_${ENS}_${MON}_tmp.nc 
      cdo zonmean ${VARNAME}_${ENS}_${MON}_tmp.nc ${OVARNAME}_${ENS}_${MON}.nc
    done
    rm -f *_tmp.nc
    cdo ensmean ${OVARNAME}_??_${MON}.nc ${MDIR}${OVARNAME}_${MON}_ensmean.nc     
    cdo ensstd  ${OVARNAME}_??_${MON}.nc ${MDIR}${OVARNAME}_${MON}_ensstd.nc    
  done  
}
###########################################################################

####################################################################################################
extract_zm_bimonthly_data (){
 
  # ARG #1 is main data Directory
  # ARG #2 is variable directory name
  # ARG #3 is variable name

  DDIR=$1
  VARDIR=$2
  VARNAME=$3  
 # HEIGHT=$4
  
  
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
  echo Extracting ${VARNAME}${HEIGHT} bimonthly data
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
#       mv ${VARNAME}${HEIGHT}_${ENS}_ens_${MONS}.nc ${BEDIR}
#    done
#   done
    
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
     cdo ensmean ${BEDIR}${VARNAME}_??_${MONS}_mean.nc ${BDIR}${VARNAME}_${MONS}_ensmean.nc    
     cdo ensstd  ${BEDIR}${VARNAME}_??_${MONS}_mean.nc ${BDIR}${VARNAME}_${MONS}_ensstd.nc    
   done  
   
}
################################################################################################





####################################################################################################
extract_bimonthly_data (){
 
  # ARG #1 is main data Directory
  # ARG #2 is variable directory name
  # ARG #3 is variable name

  DDIR=$1
  VARDIR=$2
  VARNAME=$3  
  HEIGHT=$4
  
   
  
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
  echo Extracting ${VARNAME}${HEIGHT} bimonthly data
  echo 
  echo ================================================

  cd ${MEDIR}
  for ENS in {1..30}; do 
     cdo mergetime ${VARNAME}${HEIGHT}_${ENS}_apr.nc ${VARNAME}${HEIGHT}_${ENS}_may.nc ${BEDIR}${VARNAME}${HEIGHT}_${ENS}_ens_AM.nc 
     cdo mergetime ${VARNAME}${HEIGHT}_${ENS}_jun.nc ${VARNAME}${HEIGHT}_${ENS}_jul.nc ${BEDIR}${VARNAME}${HEIGHT}_${ENS}_ens_JJ.nc 
     cdo mergetime ${VARNAME}${HEIGHT}_${ENS}_aug.nc ${VARNAME}${HEIGHT}_${ENS}_sep.nc ${BEDIR}${VARNAME}${HEIGHT}_${ENS}_ens_AS.nc 
     cdo mergetime ${VARNAME}${HEIGHT}_${ENS}_oct.nc ${VARNAME}${HEIGHT}_${ENS}_nov.nc ${BEDIR}${VARNAME}${HEIGHT}_${ENS}_ens_ON.nc 
     cdo mergetime ${VARNAME}${HEIGHT}_${ENS}_dec.nc ${VARNAME}${HEIGHT}_${ENS}_jan.nc ${BEDIR}${VARNAME}${HEIGHT}_${ENS}_ens_DJ.nc 
     cdo mergetime ${VARNAME}${HEIGHT}_${ENS}_feb.nc ${VARNAME}${HEIGHT}_${ENS}_mar.nc ${BEDIR}${VARNAME}${HEIGHT}_${ENS}_ens_FM.nc 
   done
 
   echo timemerge completed
   
#   for ENS in {1..30}; do 
#    for MONS in ${BIMONTHS}; do
#       mv ${VARNAME}${HEIGHT}_${ENS}_ens_${MONS}.nc ${BEDIR}
#    done
#   done
    
   cd ${BEDIR}
   pwd
   echo 
   echo 
   for ENS in {1..30}; do 
     for MONS in ${BIMONTHS}; do
       cdo timmean ${VARNAME}${HEIGHT}_${ENS}_ens_${MONS}.nc ${VARNAME}${HEIGHT}_${ENS}_${MONS}.nc     
     done
   done

   for MONS in ${BIMONTHS}; do
     cdo ensmean ${BEDIR}${VARNAME}${HEIGHT}_??_${MONS}.nc ${BDIR}${VARNAME}${HEIGHT}_${MONS}_ensmean.nc    
     cdo ensstd  ${BEDIR}${VARNAME}${HEIGHT}_??_${MONS}.nc ${BDIR}${VARNAME}${HEIGHT}_${MONS}_ensstd.nc    
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
   HEIGHT=$4
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
  echo Extracting ${VARNAME}${HEIGHT} non-standard seasonal data
  echo 
  echo ================================================

  cd ${MEDIR}
  
  for ENS in {1..30}; do 
     cdo mergetime ${VARNAME}${HEIGHT}_${ENS}_apr.nc ${VARNAME}${HEIGHT}_${ENS}_may.nc ${VARNAME}${HEIGHT}_${ENS}_jun.nc  ${NSEDIR}${VARNAME}${HEIGHT}_${ENS}_ens_AMJ.nc 
     cdo mergetime ${VARNAME}${HEIGHT}_${ENS}_jul.nc  ${VARNAME}${HEIGHT}_${ENS}_aug.nc ${VARNAME}${HEIGHT}_${ENS}_sep.nc ${NSEDIR}${VARNAME}${HEIGHT}_${ENS}_ens_JAS.nc 
     cdo mergetime ${VARNAME}${HEIGHT}_${ENS}_oct.nc ${VARNAME}${HEIGHT}_${ENS}_nov.nc ${VARNAME}${HEIGHT}_${ENS}_dec.nc  ${NSEDIR}${VARNAME}${HEIGHT}_${ENS}_ens_OND.nc 
     cdo mergetime ${VARNAME}${HEIGHT}_${ENS}_jan.nc ${VARNAME}${HEIGHT}_${ENS}_feb.nc ${VARNAME}${HEIGHT}_${ENS}_mar.nc ${NSEDIR}${VARNAME}${HEIGHT}_${ENS}_ens_JFM.nc 
     cdo mergetime ${VARNAME}${HEIGHT}_${ENS}_nov.nc ${VARNAME}${HEIGHT}_${ENS}_dec.nc ${VARNAME}${HEIGHT}_${ENS}_jan.nc ${VARNAME}${HEIGHT}_${ENS}_feb.nc ${VARNAME}${HEIGHT}_${ENS}_mar.nc ${NSEDIR}${VARNAME}${HEIGHT}_${ENS}_ens_NDJFM.nc 
   done
 
   echo non-standard timemerge completed   
   
  
   # MOVE DATA TO CORRECT DIRECTORY
#   for ENS in {1..30}; do 
#    for SEAS in ${NSSEAS}; do
#       mv ${VARNAME}${HEIGHT}_${ENS}_ens_${SEAS}.nc ${NSEDIR}
#    done
#   done

   cd ${NSEDIR}
   pwd
   echo
   echo
   echo CALCULATING TIME MEANS OVER NON-STANDARD SEASON
   echo 
   for ENS in {1..30}; do 
     for SEAS in ${NSSEAS}; do
       cdo timmean ${VARNAME}${HEIGHT}_${ENS}_ens_${SEAS}.nc ${VARNAME}${HEIGHT}_${ENS}_${SEAS}_mean.nc
     done
   done  
   
   
   echo
   echo CALCULATING NON-STANDARD SEASONAL ENSEMBLE MEAN AND STANDARD DEVIATIONS
   echo 
   
   for SEAS in ${NSSEAS}; do
     cdo ensmean ${VARNAME}${HEIGHT}_??_${SEAS}_mean.nc ${NSDIR}${VARNAME}${HEIGHT}_${SEAS}_ensmean.nc    
     cdo ensstd  ${VARNAME}${HEIGHT}_??_${SEAS}_mean.nc ${NSDIR}${VARNAME}${HEIGHT}_${SEAS}_ensstd.nc    
   done  

}
####################################################################################################


####################################################################################################
extract_zm_nsseasonal_data (){
 
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
  echo Extracting ${VARNAME}${HEIGHT} non-standard seasonal data
  echo 
  echo ================================================

  cd ${MEDIR}
  
  for ENS in {1..30}; do 
     cdo mergetime ${VARNAME}_${ENS}_apr.nc ${VARNAME}_${ENS}_may.nc ${VARNAME}_${ENS}_jun.nc  ${NSEDIR}${VARNAME}_${ENS}_ens_AMJ.nc
     cdo mergetime ${VARNAME}_${ENS}_jul.nc ${VARNAME}_${ENS}_aug.nc ${VARNAME}_${ENS}_sep.nc ${NSEDIR}${VARNAME}_${ENS}_ens_JAS.nc 
     cdo mergetime ${VARNAME}_${ENS}_oct.nc ${VARNAME}_${ENS}_nov.nc ${VARNAME}_${ENS}_dec.nc  ${NSEDIR}${VARNAME}_${ENS}_ens_OND.nc
     cdo mergetime ${VARNAME}_${ENS}_jan.nc ${VARNAME}_${ENS}_feb.nc ${VARNAME}_${ENS}_mar.nc ${NSEDIR}${VARNAME}_${ENS}_ens_JFM.nc 
     cdo mergetime ${VARNAME}_${ENS}_nov.nc ${VARNAME}_${ENS}_dec.nc ${VARNAME}_${ENS}_jan.nc ${VARNAME}_${ENS}_feb.nc ${VARNAME}_${ENS}_mar.nc ${NSEDIR}${VARNAME}_${ENS}_ens_NDJFM.nc 
   done
 
   echo non-standard timemerge completed   
   
  
   # MOVE DATA TO CORRECT DIRECTORY
#   for ENS in {1..30}; do 
#    for SEAS in ${NSSEAS}; do
#       mv ${VARNAME}_${ENS}_ens_${SEAS}.nc ${NSEDIR}
#    done
#   done

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
     cdo ensmean ${VARNAME}_??_${SEAS}_mean.nc ${NSDIR}${VARNAME}_${SEAS}_ensmean.nc    
     cdo ensstd  ${VARNAME}_??_${SEAS}_mean.nc ${NSDIR}${VARNAME}_${SEAS}_ensstd.nc    
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
  HEIGHT=$4
  typeset -Z2 ENS

  SSEASONS="JJA SON DJF"
  
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
  echo Extracting ${VARNAME}${HEIGHT} seasonal data
  echo 
  echo ================================================
 
  cd ${MEDIR}

  for ENS in {1..30}; do 
     cdo mergetime ${VARNAME}${HEIGHT}_${ENS}_jun.nc ${VARNAME}${HEIGHT}_${ENS}_jul.nc ${VARNAME}${HEIGHT}_${ENS}_aug.nc  ${SEDIR}${VARNAME}${HEIGHT}_${ENS}_ens_JJA.nc 
     cdo mergetime ${VARNAME}${HEIGHT}_${ENS}_sep.nc ${VARNAME}${HEIGHT}_${ENS}_oct.nc ${VARNAME}${HEIGHT}_${ENS}_nov.nc ${SEDIR}${VARNAME}${HEIGHT}_${ENS}_ens_SON.nc 
     cdo mergetime ${VARNAME}${HEIGHT}_${ENS}_dec.nc ${VARNAME}${HEIGHT}_${ENS}_jan.nc ${VARNAME}${HEIGHT}_${ENS}_feb.nc ${SEDIR}${VARNAME}${HEIGHT}_${ENS}_ens_DJF.nc 
   done
 
   echo timemerge completed
   
   # MOVE MEAN FILES TO CORRECT DIRECTORY
#   for ENS in {1..30}; do 
#     for SEAS in ${SSEASONS}; do
#       mv ${VARNAME}${HEIGHT}_${ENS}_ens_${SEAS}.nc ${SEDIR}
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
       cdo timmean ${VARNAME}${HEIGHT}_${ENS}_ens_${SEAS}.nc ${VARNAME}${HEIGHT}_${ENS}_${SEAS}_mean.nc
     done  
   done
   
   echo
   echo CALCULATING STANDARD SEASONAL ENSEMBLE MEAN AND STANDARD DEVIATIONS
   echo 
   

   for SEAS in ${SSEASONS}; do
     cdo ensmean ${VARNAME}${HEIGHT}_??_${SEAS}_mean.nc ${SDIR}${VARNAME}${HEIGHT}_${SEAS}_ensmean.nc    
     cdo ensstd  ${VARNAME}${HEIGHT}_??_${SEAS}_mean.nc ${SDIR}${VARNAME}${HEIGHT}_${SEAS}_ensstd.nc    
   done  

}
####################################################################################################



####################################################################################################
extract_zm_seasonal_data (){
 
  # ARG #1 is main data Directory
  # ARG #2 is variable directory name
  # ARG #3 is variable name

  DDIR=$1
  VARDIR=$2
  VARNAME=$3  

  typeset -Z2 ENS

  SSEASONS="JJA SON DJF"
  
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
  echo Extracting ${VARNAME}${HEIGHT} seasonal data
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
   done  

}
####################################################################################################




