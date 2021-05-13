#!/bin/ksh

########################################################
#
# Retrieve era data
# 
# Log onto jasmin before running this script
#
# R. Petrie,
# 18-11-2013
#
########################################################

STARTYEAR=2007
ENDYEAR=2011
VAR=MSLP

echo $STARTYEAR
echo $ENDYEAR
echo $VAR
# declare directories
DIR='/net/quince/export/quince/data-06/wx019276/era/NEWDATA/'${VAR}'/'

# setup cdo tools
setup cdo

cd $DIR

FILENAME='erai_mslp_'

#cdo seasmean ${FILENAME}'1979_2013.nc' ${FILENAME}'1979_2013_sm.nc'
#cdo splitseas ${FILENAME}'1979_2013_sm.nc' ${FILENAME}'1979_2013_'

for SEASON in {'DJF','MAM','JJA','SON'}; do

  cdo selyear,${STARTYEAR}/${ENDYEAR} ${FILENAME}'1979_2013_'${SEASON}'.nc' ${FILENAME}${STARTYEAR}'_'${ENDYEAR}'_'${SEASON}'.nc'
 
  cdo seasstd ${FILENAME}${STARTYEAR}'_'${ENDYEAR}'_'${SEASON}'.nc' ${FILENAME}${STARTYEAR}'_'${ENDYEAR}'_'${SEASON}'_sstd.nc'
   
  cdo yseasmean ${FILENAME}${STARTYEAR}'_'${ENDYEAR}'_'${SEASON}'.nc' ${FILENAME}${STARTYEAR}_${ENDYEAR}_${SEASON}'_msm.nc'

done

