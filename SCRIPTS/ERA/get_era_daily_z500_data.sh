#!/bin/ksh

########################################################
#
# Retrieve era data
# 
# Log onto jasmin before running this script
#
# Supply two arguments,  
# 
# $1 : the era code name of the variable
# $2 : the output filename of the variable
# $3 : output file directory
# $5 : start year
# $4 : end year
# $5 : era data string, e.g. ggas, ggap...
#
# R. Petrie,
# 18-11-2013
#
########################################################
READVAR='Z'
VARNAME='Z'
DATOUTDIRNAME='GPH'
startyear='2001'
endyear='2012'
ERAFILENAME='ggap'

echo 'era variable name'
echo $READVAR
echo 'my write variable name'
echo $VARNAME
echo 'output directory name'
echo $DATOUTDIRNAME
echo 'final year of extraction'
echo $endyear
echo 'era file type'
echo $ERAFILENAME

# declare directories
ERA_DIR='/net/jasmin/era/era-in/netc/'${ERAFILENAME}'/' 
OUT_DIR='/net/quince/export/quince/data-06/wx019276/era/NEWDATA/'${DATOUTDIRNAME}'/DAILY/'

# make directory if it doesn't already exit
#mkdir -p $OUT_DIR

# setup cdo tools
setup cdo

echo 'performing data extraction'
for year in {$startyear..$endyear}; do
  for mon in {'jan','feb','mar','apr','may','jun','jul','aug','sep','oct','nov','dec'}; do
   

   if [ "${mon}" = "jan" ]; then ; monnum='01'; fi 
   if [ "${mon}" = "feb" ]; then ; monnum='02'; fi
   if [ "${mon}" = "mar" ]; then ; monnum='03'; fi
   if [ "${mon}" = "apr" ]; then ; monnum='04'; fi
   if [ "${mon}" = "may" ]; then ; monnum='05'; fi
   if [ "${mon}" = "jun" ]; then ; monnum='06'; fi
   if [ "${mon}" = "jul" ]; then ; monnum='07'; fi
   if [ "${mon}" = "aug" ]; then ; monnum='08'; fi
   if [ "${mon}" = "sep" ]; then ; monnum='09'; fi
   if [ "${mon}" = "oct" ]; then ; monnum='10'; fi
   if [ "${mon}" = "nov" ]; then ; monnum='11'; fi
   if [ "${mon}" = "dec" ]; then ; monnum='12'; fi


   cd $ERA_DIR$year'/'${mon}${year}
   echo ${year}$mon
    for day in {'01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30','31'}; do
      echo $ERAFILENAME${year}${monnum}${day}'0000.nc'
      cdo selvar,$READVAR -sellevel,500 $ERAFILENAME${year}${monnum}${day}'0000.nc' $OUT_DIR'erairaw_'$VARNAME'_'$year$mon${day}'.nc'
    done  
 done
done

# change to output directory
cd $OUT_DIR

# combine all era data into one file
cdo mergetime 'erairaw'*'.nc' 'erai_'$VARNAME'_'$startyear'_'$endyear'_daily.nc'
rm -f erairaw*


