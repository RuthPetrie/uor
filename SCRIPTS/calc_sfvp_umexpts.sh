#!/bin/ksh

#
#    CALCULATE ROSSBY WAVE SOURCE FOR EXPT DATA
#    NEEDS DAILY DATA OF U AND V
#
#    NEEDS CDO, and UMTOOLS 
#    
#    CALCULATES DIAGNOSTICS USING sfvp
#
#
#   R PETRIE, 23-APR-2014

# Setup commands
setup cdo
setup umtools

# CONTROL: ctrl; xhuic
# PERTURBATION: fullpert; xhuid
# ICE ONLY: iceonly; xhuie
# Declare variables 

EXPT='ctrl'
JOBID='xhuic'
if [ ${exp} -eq 'iceonly' ]; then DISK='5'; else DISK='6'; fi       
DDIR='/export/quince/data-0'${DISK}'/wx019276/um_expts/'${EXPT}

# MAKE OUTPUT FOLDER
cd ${DDIR}'/ncfiles'

# CHECK IF OUTPUT FOLDER EXISTS
if [ -d ${DDIR}'/ncfiles/winds' ]; then
   echo
   echo "======================="
   echo "Directory winds exists"
   echo "======================="
   echo
else
   echo "======================="
   echo "Directory winds does not exist"
   echo "Making directory winds"
   echo "======================="
   mkdir winds
fi

# DECLARE OUTPUT DIRECTORY
ODIR=${DDIR}'/ncfiles/winds/'

# CHANGE DIRECTORY TO UM OUTPUT

# *.pe* output files - DAILY RESOLUTION WIND FIELDS
# var 1 is u
# var 2 is v
# lev 2 is 850
# lev 5 is 500
# lev 8 is 250
# lev 9 is 200


for LEV in {2,5,8,9}; do

  if [ ${LEV} == 2 ]; then LEVNAME='850'; fi       
  if [ ${LEV} == 5 ]; then LEVNAME='500'; fi       
  if [ ${LEV} == 8 ]; then LEVNAME='250'; fi       
  if [ ${LEV} == 9 ]; then LEVNAME='200'; fi       

 # for VAR in {1,2}; do

#    cd ${DDIR}/output/

#    if [ ${VAR} == 1 ]; then VARNAME='u'; fi       
#    if [ ${VAR} == 2 ]; then VARNAME='v'; fi       

#    echo "======================="
#    echo "working directory"
#    echo ${DDIR}/output/
#    echo 
#    echo "converting"

#    ~/SCRIPTS/converters/convpp2nc.tcl -i ${JOBID}'a.pe'* -o $ODIR${EXPT}'_'$VARNAME$LEVNAME'_daily.nc' -p $VAR -levs $LEV
    
#  done

# Monthly resolution data
#~/SCRIPTS/converters/convpp2nc.tcl -i ${JOBID}'m'* -o ${OFILE} -p 208,209 -levs 2,5,8,9

  # Change working directory to output location
  echo "CHANGE WORKING DIRECTORY" 
  cd ${ODIR}

  # Reverse latitude coordinate; needed for sfvp to work
  UFILE=$ODIR${EXPT}'_u'$LEVNAME'_daily'
  VFILE=$ODIR${EXPT}'_v'$LEVNAME'_daily'
  echo 
  echo "FILENAMES"
  echo $UFILE
  echo $VFILE
#  USWAPFILE=${UFILE%.nc}
#  VSWAPFILE=${VFILE%.nc}

  ncpdq -a -latitude ${UFILE}'.nc' ${UFILE}'_latswap.nc'
  ncpdq -a -latitude ${VFILE}'.nc' ${VFILE}'_latswap.nc'

 # Run sfvp
 echo ${UFILE}'_latswap.nc'
 echo ${UFILE}'_latswap.nc'
 echo
 sfvp ${UFILE}'_latswap.nc' u ${VFILE}'_latswap.nc' v ${EXPT}'_sfvp'${LEV}'_daily.nc'


 
done




