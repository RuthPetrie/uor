#/usr/bin/ksh
# 
# CALCULATE INDEX OF ZONAL MEAN WINDS
# TO INDICATE THE DISTRIBUTION OF ENSEMBLE

# DEFINE AREA AVERAGE FUNCTION
###########################################################################
calc_area_average () {

typeset -Z2 ENS

DIR=$1
SEAS=$2
LONMIN=$3
LONMAX=$4
LATMIN=$5
LATMAX=$6
VAR=$7

cd ${DIR}

for ENS in {1..30}; do
  for FILE in u850_${ENS}_${SEAS}.nc; do
    cdo -fldmean, -sellonlatbox,${LONMIN},${LONMAX},${LATMIN},${LATMAX} ${FILE} ${FILE%.nc}_${VAR}.nc
  done
done
cdo mergetime u850_??_${SEAS}_${VAR}.nc ../u850_${SEAS}_${VAR}_ens.nc
}
###########################################################################


# SETUP CDO
setup cdo

# DEFINE DIRECTORIES
DDIR='/net/quince/export/quince/data-05/wx019276/COUPLED_EXPTS/'
U_BM_CTRL=${DDIR}'CTRL/U/BIMONTHLY/ENSB/'
U_BM_PERT=${DDIR}'PERT/U/BIMONTHLY/ENSB/'




calc_area_average ${U_BM_CTRL} 'JJ' 60 0 50 60 'na_jet_pole'
calc_area_average ${U_BM_CTRL} 'JJ' 55 5 35 49 'na_jet_equat'
calc_area_average ${U_BM_PERT} 'JJ' 60 0 50 60 'na_jet_pole'
calc_area_average ${U_BM_PERT} 'JJ' 55 5 35 49 'na_jet_equat'
calc_area_average ${U_BM_CTRL} 'ON' 60 0 52 60 'na_jet_pole'
calc_area_average ${U_BM_CTRL} 'ON' 75 5 35 50 'na_jet_equat'
calc_area_average ${U_BM_PERT} 'ON' 60 0 52 60 'na_jet_pole'
calc_area_average ${U_BM_PERT} 'ON' 75 5 35 50 'na_jet_equat'



