#!/bin/ksh

########################################################
#
# CONVERT COUPLED CLIMATE EXPERIMENT ATMOSPHERIC DATA
# FROM GC2 RUNS FROM PP TO NETCDF FORMAT
#
#
# R. Petrie,
# 10-04-2014
#
########################################################

# EXPERIMENT
EXPT='CTRL'  

# ENSEMBLE MEMBER NUMBER   
ENNO='01'

# DIRECTORY
DIR='/export/quince/data-07/wx019276/coupled_expts/'
EXPTDIR=${DIR}${EXPT}'/en'${ENNO}

# CHANGE DIRECTORY
cd ${EXPTDIR}

echo =================================
echo ENSEMBLE MEMBER ${ENNO}
echo =================================

for FILE in *.pp; do

  echo CONVERTING:  ${FILE}
  
  # MAKE OUTPUT FILENAME
  FILEOUT=${FILE%pp}'nc'

  # CONVERT FILE USING TCL CODE
  ~/SHELL_SCRIPTS/converters/convpp2nc.tcl -i ${FILE} -o ${FILEOUT} 
done

# REMOVE ALL PP FILES
rm -f *.pp

# Merge into annual files
#~/SHELL_SCRIPTS/converters/convpp2nc.tcl -i *.pc* -o xjhbia.c.m.nc

