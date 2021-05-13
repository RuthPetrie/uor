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
READVAR=$1
VARNAME=$2
DATOUTDIRNAME=$3
startyear=$4
endyear=$5
ERAFILENAME=$6

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
ERA_DIR='/net/jasmin/era/era-in/netc/monthly_means/'
OUT_DIR='/net/quince/export/quince/data-06/wx019276/era/NEWDATA/'${DATOUTDIRNAME}'/'

# make directory if it doesn't already exit
mkdir -p $OUT_DIR

# setup cdo tools
setup cdo

echo 'performing data extraction'
for year in {$startyear..$endyear}; do
 cd $ERA_DIR$year
 for mon in {01,02,03,04,05,06,07,08,09,10,11,12}; do
    echo $year$mon
   cdo selvar,$READVAR $ERAFILENAME$year$mon'.nc' $OUT_DIR'erairaw_'$VARNAME'_'$year$mon'.nc'
 done
done

# change to output directory
cd $OUT_DIR

# combine all era data into one file
cdo mergetime 'erairaw'*'.nc' 'erai_'$VARNAME'_'$startyear'_'$endyear'.nc'
rm -f erairaw*


