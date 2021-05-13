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
# ERA


# Declare variables 

DDIR='/net/quince/export/quince/data-06/wx019276/era/NEWDATA'
UFILE='/U/erai_u_1979_2013_monthly.nc'
VFILE='/V/erai_v_1979_2013_monthly.nc'


#----------------------------------------------------
# Convert all pp files to u and v netcdf files using 
# ~/SHELL_SCRIPTS/converters/convpp2nc.tcl

cd ${DDIR}

#~/SHELL_SCRIPTS/converters/convpp2nc.tcl -i ${JOBID}'e'* -o ctrl_u850_daily.nc -p 1 -levs 2

# Monthly resolution data
#~/SHELL_SCRIPTS/converters/convpp2nc.tcl -i ${JOBID}'m'* -o ${OFILE} -p 208,209 -levs 2,5,8,9

#mv ${OFILE} ${ODIR}'/winds'

# Change working directory to output location
#cd ${ODIR}'/winds'

# Reverse latitude coordinate; needed for sfvp to work

USWAPFILE=${UFILE%.nc}
VSWAPFILE=${VFILE%.nc}

ncpdq -a -latitude ${DDIR}${UFILE}'.nc' ${DDIR}${USWAPFILE}'_latswap.nc'
ncpdq -a -latitude ${DDIR}${VFILE}'.nc' ${DDIR}${VSWAPFILE}'_latswap.nc'

# Run sfvp
echo ${DDIR}${USWAPFILE}'_latswap.nc'
echo ${DDIR}${VSWAPFILE}'_latswap.nc'
echo
sfvp ${DDIR}${USWAPFILE}'_latswap.nc' U ${DDIR}${VSWAPFILE}'_latswap.nc' V ${DDIR}'/erai_sfvp.nc'






