############################################################################################
#
#  FUNCTIONS
#
############################################################################################

############################################################################################
get_sit_data () {

DDIR=$1
VARDIR=$2
VARNAME=$3
nv=$4
V1=$5
V2=$6

MDIR=${DDIR}${VARDIR}MONTHLY/
MENS=${DDIR}${VARDIR}MONTHLY/ENSB/

mkdir -p ${MENS}

typeset -Z2 ENS
#typeset -Z2 MON

MTHS[01]="jan"
MTHS[02]="feb"
MTHS[03]="mar"
MTHS[04]="apr"
MTHS[05]="may"
MTHS[06]="jun"
MTHS[07]="jul"
MTHS[08]="aug"
MTHS[09]="sep"
MTHS[10]="oct"
MTHS[11]="nov"
MTHS[12]="dec"



for ENS in {1..30}; do
  cd ${DDIR}/RAWENSEMBLE/en${ENS}
  for MON in {1..12}; do
    for FILE in  *i.1m.*${MON}.nc; do
     if [ "$nv" == "2" ]; then
        cdo selvar,$V1,$V2 ${FILE} ${MENS}${VARNAME}_${ENS}_${MTHS[${MON}]}.nc
     else
        cdo selvar,$V1 ${FILE} ${MENS}${VARNAME}_${ENS}_${MTHS[${MON}]}.nc
     fi
    done
  done
done


}
############################################################################################

############################################################################################
get_sst_or_sss_data () {

DDIR=$1
VARDIR=$2
VARNAME=$3


MDIR=${DDIR}${VARDIR}MONTHLY/
MENS=${DDIR}${VARDIR}MONTHLY/ENSB/

mkdir -p ${MENS}

typeset -Z2 ENS
MONTHS="jan feb mar apr may jun jul aug sep oct nov dec"


for ENS in {1..30}; do
  cd ${DDIR}/RAWENSEMBLE/en${ENS}
    
    cdo selvar,$VARNAME *.1m.2035-04.nc ${MENS}${VARNAME}_${ENS}_apr.nc
    cdo selvar,$VARNAME *.1m.2035-05.nc ${MENS}${VARNAME}_${ENS}_may.nc
    cdo selvar,$VARNAME *.1m.2035-06.nc ${MENS}${VARNAME}_${ENS}_jun.nc
    cdo selvar,$VARNAME *.1m.2035-07.nc ${MENS}${VARNAME}_${ENS}_jul.nc
    cdo selvar,$VARNAME *.1m.2035-08.nc ${MENS}${VARNAME}_${ENS}_aug.nc
    cdo selvar,$VARNAME *.1m.2035-09.nc ${MENS}${VARNAME}_${ENS}_sep.nc
    cdo selvar,$VARNAME *.1m.2035-10.nc ${MENS}${VARNAME}_${ENS}_oct.nc
    cdo selvar,$VARNAME *.1m.2035-11.nc ${MENS}${VARNAME}_${ENS}_nov.nc
    cdo selvar,$VARNAME *.1m.2035-12.nc ${MENS}${VARNAME}_${ENS}_dec.nc
    cdo selvar,$VARNAME *.1m.2036-01.nc ${MENS}${VARNAME}_${ENS}_jan.nc
    cdo selvar,$VARNAME *.1m.2036-02.nc ${MENS}${VARNAME}_${ENS}_feb.nc
 
done


}
############################################################################################



############################################################################################
calc_thickness () {

# inputs
DDIR=$1
VARDIR=$2
VARNAME=$3
HEIGHT=$4
ICEA=$5

cd ${DDIR}${VARDIR}MONTHLY/ENSB

for FILE in *nc; do
  cdo mul,$V1,$V2 $FILE $FILE 'tmp'$FILE
  cdo selvar,hi 'tmp'$FILE 'w'$FILE
done

rm -f tmp*

}
############################################################################################


############################################################################################
calc_volume () {

  DDIR=$1
  typeset -Z2 ENS
  months="jan feb apr may jun jul aug sep oct nov dec" 
  AREA=/net/quince/export/quince/data-05/wx019276/COUPLED_EXPTS/OCRA025_tarea_km2.nc 

  cd ${DDIR}MONTHLY/ENSB

  for ENS in {1..30}; do
    for M in ${months}; do
      cdo mul wsit_${ENS}_${M}.nc  ${AREA} siv_${ENS}_${M}.nc
      cdo sellonlatbox,0,360,0,90 siv_${ENS}_${M}.nc siv_nh_${ENS}_${M}.nc
      cdo fldsum siv_nh_${ENS}_${M}.nc siv_nhtot_${ENS}_${M}.nc
  done  
    cdo mergetime siv_nhtot_${ENS}_*.nc ../siv_nhtot_${ENS}.nc
 done
 
 
}
############################################################################################

############################################################################################
calc_monthly_stats () {

#  inputs
 
DDIR=$1
VARDIR=$2
VARNAME=$3

typeset -Z2 ENS

cd ${DDIR}${VARDIR}MONTHLY/ENSB/
pwd
months="jan feb apr may jun jul aug sep oct nov dec"
for MON in ${months}; do
  cdo ensmean ${VARNAME}_??_${MON}.nc ../${VARNAME}_${MON}_ensmean.nc
  cdo ensstd ${VARNAME}_??_${MON}.nc ../${VARNAME}_${MON}_ensstd.nc
done


}
############################################################################################

############################################################################################
calc_bimonthly_stats () {

DDIR=$1
VARDIR=$2
VARNAME=$3

typeset -Z2 ENS
bimths="AM JJ AS ON DJ"

# CALCULATE BIMONTHLY DATA AND MEANS
BDDIR=${DDIR}${VARDIR}BIMONTHLY/
BEDDIR=${DDIR}${VARDIR}BIMONTHLY/ENSB/
mkdir -p ${BEDDIR}

cd ${DDIR}${VARDIR}MONTHLY/ENSB/
for ENS in {1..30}; do
  cdo mergetime ${VARNAME}_${ENS}_apr.nc ${VARNAME}_${ENS}_may.nc ${BEDDIR}${VARNAME}_${ENS}_ens_AM.nc
  cdo mergetime ${VARNAME}_${ENS}_jun.nc ${VARNAME}_${ENS}_jul.nc ${BEDDIR}${VARNAME}_${ENS}_ens_JJ.nc
  cdo mergetime ${VARNAME}_${ENS}_aug.nc ${VARNAME}_${ENS}_sep.nc ${BEDDIR}${VARNAME}_${ENS}_ens_AS.nc
  cdo mergetime ${VARNAME}_${ENS}_oct.nc ${VARNAME}_${ENS}_nov.nc ${BEDDIR}${VARNAME}_${ENS}_ens_ON.nc
  cdo mergetime ${VARNAME}_${ENS}_dec.nc ${VARNAME}_${ENS}_jan.nc ${BEDDIR}${VARNAME}_${ENS}_ens_DJ.nc
done

cd ${BEDDIR}
for ENS in {1..30}; do
  for TIME in ${bimths}; do
    cdo timmean ${VARNAME}_${ENS}_ens_${TIME}.nc ${VARNAME}_${ENS}_${TIME}.nc
  done
done


for TIME in ${bimths}; do
  cdo ensmean ${VARNAME}_??_${TIME}.nc ../${VARNAME}_${TIME}_ensmean.nc
  cdo ensstd ${VARNAME}_??_${TIME}.nc ../${VARNAME}_${TIME}_ensstd.nc
done


}

############################################################################################


############################################################################################
calc_seasonal_stats () {

DDIR=$1
VARDIR=$2
VARNAME=$3

typeset -Z2 ENS
seas="JJA SON DJF"

# CALCULATE BIMONTHLY DATA AND MEANS
SDDIR=${DDIR}${VARDIR}SEASONALLY/
SEDDIR=${DDIR}${VARDIR}SEASONALLY/ENSB/
mkdir -p ${SEDDIR}

cd ${DDIR}${VARDIR}MONTHLY/ENSB/
for ENS in {1..30}; do
  cdo mergetime ${VARNAME}_${ENS}_jun.nc ${VARNAME}_${ENS}_jul.nc ${VARNAME}_${ENS}_aug.nc ${SEDDIR}${VARNAME}_${ENS}_ens_JJA.nc
  cdo mergetime ${VARNAME}_${ENS}_sep.nc ${VARNAME}_${ENS}_oct.nc ${VARNAME}_${ENS}_nov.nc ${SEDDIR}${VARNAME}_${ENS}_ens_SON.nc
  cdo mergetime ${VARNAME}_${ENS}_dec.nc ${VARNAME}_${ENS}_jan.nc ${VARNAME}_${ENS}_feb.nc ${SEDDIR}${VARNAME}_${ENS}_ens_DJF.nc
done

cd ${SEDDIR}
for ENS in {1..30}; do
  for TIME in ${seas}; do
    cdo timmean ${VARNAME}_${ENS}_ens_${TIME}.nc ${VARNAME}_${ENS}_${TIME}.nc
  done
done


for TIME in ${seas}; do
  cdo ensmean ${VARNAME}_??_${TIME}.nc ../${VARNAME}_${TIME}_ensmean.nc
  cdo ensstd ${VARNAME}_??_${TIME}.nc ../${VARNAME}_${TIME}_ensstd.nc
done


}

############################################################################################
############################################################################################
calc_ns_seasonal_stats () {

DDIR=$1
VARDIR=$2
VARNAME=$3

typeset -Z2 ENS
nsseas="AMJ JAS OND"

# CALCULATE BIMONTHLY DATA AND MEANS
NSDDIR=${DDIR}${VARDIR}NON_STD_SEASONS/
NSEDDIR=${DDIR}${VARDIR}NON_STD_SEASONS/ENSB/
mkdir -p ${NSEDDIR}

cd ${DDIR}${VARDIR}MONTHLY/ENSB/
for ENS in {1..30}; do
  cdo mergetime ${VARNAME}_${ENS}_apr.nc ${VARNAME}_${ENS}_may.nc ${VARNAME}_${ENS}_jun.nc ${NSEDDIR}${VARNAME}_${ENS}_ens_AMJ.nc
  cdo mergetime ${VARNAME}_${ENS}_jul.nc ${VARNAME}_${ENS}_aug.nc ${VARNAME}_${ENS}_sep.nc ${NSEDDIR}${VARNAME}_${ENS}_ens_JAS.nc
  cdo mergetime ${VARNAME}_${ENS}_oct.nc ${VARNAME}_${ENS}_nov.nc ${VARNAME}_${ENS}_dec.nc ${NSEDDIR}${VARNAME}_${ENS}_ens_OND.nc
done

cd ${NSEDDIR}
for ENS in {1..30}; do
  for TIME in ${nsseas}; do
    cdo timmean ${VARNAME}_${ENS}_ens_${TIME}.nc ${VARNAME}_${ENS}_${TIME}.nc
  done
done


for TIME in ${nsseas}; do
  cdo ensmean ${VARNAME}_??_${TIME}.nc ../${VARNAME}_${TIME}_ensmean.nc
  cdo ensstd ${VARNAME}_??_${TIME}.nc ../${VARNAME}_${TIME}_ensstd.nc
done


}

############################################################################################


################################################################################################




