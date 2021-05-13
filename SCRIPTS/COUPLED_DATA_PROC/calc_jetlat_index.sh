#/usr/bin/ksh
# 
# CALCULATE INDEX OF ZONAL MEAN WINDS
# TO INDICATE THE DISTRIBUTION OF ENSEMBLE

# DEFINE AREA AVERAGE FUNCTION
###########################################################################
calc_jet_postion () {

typeset -Z2 ENS

DIR=$1
SEAS=$2

cd ${DIR}

for ENS in {1..30}; do
  for FILE in u_${ENS}_${SEAS}_mean.nc; do
    cdo -zonmean, -sellonlatbox,300,0,15,75, -vertmean, -sellevel,925,700 ${FILE} ${FILE%.nc}_jet.nc
  done
done
}
###########################################################################


# SETUP CDO
setup cdo

# DEFINE DIRECTORIES
DDIR='/net/quince/export/quince/data-05/wx019276/COUPLED_EXPTS/'
U_BM_CTRL=${DDIR}'CTRL/U/BIMONTHLY/ENSB/'
U_BM_PERT=${DDIR}'PERT/U/BIMONTHLY/ENSB/'


calc_jet_postion ${U_BM_CTRL} 'JJ' 
calc_jet_postion ${U_BM_PERT} 'JJ' 
calc_jet_postion ${U_BM_CTRL} 'ON' 
calc_jet_postion ${U_BM_PERT} 'ON' 



