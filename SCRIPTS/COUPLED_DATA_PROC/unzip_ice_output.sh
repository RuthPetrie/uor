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

# Unzip all the files
#cd ${CRDDIR}

for ENS in {1..30}; do
  cd ${CRDDIR}en${ENS}
  tar -zxvf *.tgz 
  echo ensemble ${ENS} ice files unzipped
done

#cd ${PRDDIR}

for ENS in {1..30}; do
  cd ${PRDDIR}en${ENS}
  tar -zxvf *.tgz 
  echo ensemble ${ENS} ice files unzipped
done



