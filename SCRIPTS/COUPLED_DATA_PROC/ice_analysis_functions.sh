############################################################################################
#
#  FUNCTIONS
#
############################################################################################
extract_monthly_data () {
  
  DDIR=$1
  VARDIR=$2
  VARNAME=$3
  UMNAME=$4
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
      cdo selname,${UMNAME} *.pm*${MON}.nc ${MEDIR}${VARNAME}_${ENS}_${MON}.nc
    done  
    echo MONTHLY DATA EXTRACTED

  done
}
###########################################################################



################################################################################################
#
#   RE WRITE BEFORE USING
#
#


convert_sic_to_sia () {
  # INPUTS
  DDIR=$1        # directory of ice concentrations 
  EXPT=$2        # control expt name 
  n96areafile=$3 # area file
  UMID=$4    # concentration variable name
  AVARNAME=$5    # area variable name
  
  MONTHS="jan feb mar apr may jun jul aug sep oct nov dec"
  typeset -Z2 ENS


  # convert ctrl sics to sias
  cd ${DDIR}
  echo $1
  
  
  for MON in ${MONTHS}; do 
    
    # convert sic to sia
    cdo mul ${n96areafile} ${EXPT}_sic_${MON}_em.nc ${EXPT}_sia_${MON}_em.nc
    
    # change name in file
    cdo chname,${UMID},${AVARNAME} ${EXPT}_sia_${MON}_em.nc ${EXPT}_sia_${MON}_em_tmp.nc
    mv ${EXPT}_sia_${MON}_em_tmp.nc ${EXPT}_sia_${MON}_em.nc

    # calculate Arctic (NH) sia
    cdo sellonlatbox,0,360,0,90 ${EXPT}_sia_${MON}_em.nc ${EXPT}_nh_sia_${MON}_em.nc
    
    # calculate total sia
    cdo fldsum ${EXPT}_nh_sia_${MON}_em.nc ${EXPT}_tot_nh_sia_${MON}_em.nc 
    
  done  
  
  
  # REPEAT FOR ALL ENSMBLE MEMBERS
  cd ENSB
  
  for ENS in {1..30}; do 
    cdo mul ${n96areafile} ${EXPT}_${ENS}_sic.nc ${EXPT}_${ENS}_sia.nc
    cdo chname,${UMID},${AVARNAME} ${EXPT}_${ENS}_sia.nc ${EXPT}_${ENS}_sia_tmp.nc
    mv ${EXPT}_${ENS}_sia_tmp.nc ${EXPT}_${ENS}_sia.nc 
    cdo sellonlatbox,0,360,0,90 ${EXPT}_${ENS}_sia.nc ${EXPT}_${ENS}_nh_sia.nc  
    cdo fldsum ${EXPT}_${ENS}_nh_sia.nc  ${EXPT}_${ENS}_tot_nh_sia.nc
  done 
}
################################################################################################

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
     cdo ensmean ${VARNAME}_??_${SEAS}_mean.nc ${SDIR}${VARNAME}_${SEAS}_ensmean.nc    
     cdo ensstd  ${VARNAME}_??_${SEAS}_mean.nc ${SDIR}${VARNAME}_${SEAS}_ensstd.nc    
   done  

}
####################################################################################################


