#/usr/bin/ksh

# program to extract the ice areas from the ice output files

# Define Directories etc
CRDDIR='/net/quince/export/quince/data-05/wx019276/COUPLED_EXPTS/CTRL/RAWENSEMBLE/'
PRDDIR='/net/quince/export/quince/data-05/wx019276/COUPLED_EXPTS/PERT/RAWENSEMBLE/'
CDDIR='/net/quince/export/quince/data-05/wx019276/COUPLED_EXPTS/CTRL/'
PDDIR='/net/quince/export/quince/data-05/wx019276/COUPLED_EXPTS/PERT/'
typeset -Z2 ENS
typeset -Z2 MONTH

setup cdo

# Extract grid box ice thickness area field and write to directory
#VARIABLES="hi sst sss"

cd ${CDDIR}

SIT_CDDIR=${CDDIR}SIT/ 
SST_CDDIR=${CDDIR}SST/
SSS_CDDIR=${CDDIR}SSS/

mkdir -p ${SIT_CDDIR}
mkdir -p ${SST_CDDIR}
mkdir -p ${SSS_CDDIR}


for ENS in {1..30}; do
  cd ${CRDDIR}en${ENS}
  for MONTH in {1..12}; do
    cdo selvar,hi *i.1m*${MONTH}* ${SIT_CDDIR}sit_${ENS}_${MONTH}.nc
    cdo selvar,sst *i.1m*${MONTH}* ${SST_CDDIR}sst_${ENS}_${MONTH}.nc
    cdo selvar,sss *i.1m*${MONTH}* ${SSS_CDDIR}sss_${ENS}_${MONTH}.nc
  done
  echo ctrl $ENS finished
done


cd ${PRDDIR}

SIT_PDDIR=${PDDIR}'SIT/' 
SST_PDDIR=${PDDIR}'SST/'
SSS_PDDIR=${PDDIR}'SSS/'

mkdir -p ${SIT_PDDIR}
mkdir -p ${SST_PDDIR}
mkdir -p ${SSS_PDDIR}
 
for ENS in {1..30}; do
  cd ${PRDDIR}en${ENS}
  for MONTH in {1..12}; do
    cdo selvar,hi *i.1m*${MONTH}* ${SIT_PDDIR}sit_${ENS}_${MONTH}.nc
    cdo selvar,sst *i.1m*${MONTH}* ${SST_PDDIR}sst_${ENS}_${MONTH}.nc
    cdo selvar,sss *i.1m*${MONTH}* ${SSS_PDDIR}sss_${ENS}_${MONTH}.nc
  done
  echo pert $ENS finished
done





