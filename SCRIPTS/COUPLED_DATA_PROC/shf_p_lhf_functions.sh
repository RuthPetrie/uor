############################################################################################
#
#  FUNCTIONS FOR SHF PLUS LHF ANALYSIS
#
############################################################################################

add_monthly_data_calc_mthly_stats () {

  # DECLARE INPUTS
  DDIR=$1
  SHFDDIR=$2
  LHFDDIR=$3
  SHF=$4
  LHF=$5
  ODDIR=$6
  OVARNAME=$7 
  
  typeset -Z2 ENS
  
  
#  echo ==========================================
#  echo  PARAMETERS
#  echo  ----------
#  echo 
  echo   DDIR=$1
  echo   SHFDDIR=$2
  echo   LHFDDIR=$3
  echo   SHF=$4
  echo   LHF=$5
  echo   ODDIR=$6 
# ODDIR is SHpLH = SH+LH/
  echo   OVARNAME=$7
#  echo
#  echo ==========================================


  # MAKE OUTPUT DIRECTORY IF IT DOESN'T ALREADY EXIST
  SHpLH_DDIR=${DDIR}${ODDIR}
  SHpLH_E_DDIR=${SHpLH_DDIR}MONTHLY/ENSB/
  mkdir -p ${SHpLH_E_DDIR}

  SHF_E_DDIR=${DDIR}${SHFDDIR}'MONTHLY/ENSB/'
  LHF_E_DDIR=${DDIR}${LHFDDIR}'MONTHLY/ENSB/'
   
  MONTHS="jan feb mar apr may jun jul aug sep oct nov dec"
  
  # FOR EACH ENSEMBLE MEMBER AND MONTH ADD THE SHF AND LHF
      
  for ENS in {1..30}; do
    echo ======================================
    echo
    echo ENSEMBLE MEMBER:  ${ENS}
    echo
    echo 
     
    for MON in ${MONTHS}; do
      cdo add ${SHF_E_DDIR}${SHF}_${ENS}_${MON}.nc ${LHF_E_DDIR}${LHF}_${ENS}_${MON}.nc ${SHpLH_E_DDIR}${OVARNAME}_${ENS}_${MON}.nc
    done  
    echo MONTHLY DATA ADDED
    echo
    echo ================================================
  done
  
  # CALCULATE MONTHLY STATISTICS
  echo 
  echo CALCULATING MONTHLY STATS
  echo 
  echo ==============================================
  # change to output directory
  cd ${SHpLH_E_DDIR}
  
  for MON in ${MONTHS}; do
    cdo ensmean ${OVARNAME}_??_${MON}.nc ${SHpLH_DDIR}MONTHLY/${OVARNAME}_${MON}_ensmean.nc
    cdo ensstd ${OVARNAME}_??_${MON}.nc ${SHpLH_DDIR}MONTHLY/${OVARNAME}_${MON}_ensstd.nc
  done
  
}


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


