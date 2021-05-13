#!/bin/sh

setup cdo
CONVDIR=/home/wx019276/TRACK\-1.4.3/converters

####################################
# CTRL
####################################
#DIR=/export/quince/data-06/wx019276/um_expts/ctrl
#cd $DIR/tclout
#rm -f *

#cd $DIR/output
#for file in xhuica.pm* ;do
# filein=$file
# fileout=${filein%.pp}
# $CONVDIR/cat_conv_psag.tcl -i $filein -o $DIR/tclout/$fileout'_psag.nc' 
# $CONVDIR/cat_conv_temp.tcl -i $filein -o $DIR/tclout/$fileout'_temp.nc' 
#done

#cd $DIR/tclout

#cdo mergetime *psag.nc psags.nc
#cdo mergetime *temp.nc temps.nc
#cdo div temps.nc psags.nc adj_temps.nc
#cdo seasmean adj_temps.nc adj_temps_seasmeans.nc
#cdo selyear,1983/2012 adj_temps_seasmeans.nc adj_temps_seasmean_selected_years.nc
##remove final December in 2012
#cdo seltimestep,0/11235 adj_temps_seasmean_selected.nc $DIR/ncfiles/adj_temps.nc
#cdo splitseas $DIR/ncfiles/adj_temps.nc $DIR/ncfiles/ctrl_adj_T_

#cd $DIR/tclout
#rm -f *
####################################
####################################


####################################
# FULLPERT
####################################
DIR=/export/quince/data-06/wx019276/um_expts/fullpert
cd $DIR/tclout
rm -f *


cd $DIR/output
for file in xhuida.pm* ;do
  filein=$file
  fileout=${filein%.pp}
  $CONVDIR/cat_conv_psag.tcl -i $filein -o $DIR/tclout/$fileout'_psag.nc' 
  $CONVDIR/cat_conv_temp.tcl -i $filein -o $DIR/tclout/$fileout'_temp.nc' 
done

cd $DIR/tclout


cdo mergetime *psag.nc psags.nc
cdo mergetime *temp.nc temps.nc
cdo div temps.nc psags.nc adj_temps.nc
cdo seasmean adj_temps.nc adj_temps_seasmeans.nc
cdo selyear,1983/2012 adj_temps_seasmeans.nc adj_temps_seasmean_selected_years.nc
#remove final December in 2012
cdo seltimestep,0/11235 adj_temps_seasmean_selected.nc $DIR/ncfiles/adj_temps.nc
cdo splitseas $DIR/ncfiles/adj_temps.nc $DIR/ncfiles/pert_adj_T_

#cd $DIR/tclout
#rm -f *
####################################
####################################

####################################
# ICE
####################################
DIR=/export/quince/data-05/wx019276/um_expts/iceonly

cd $DIR/tclout
rm -f *


cd $DIR/output
for file in xhuiea.pm* ;do
 filein=$file
 fileout=${filein%.pp}
 $CONVDIR/cat_conv_psag.tcl -i $filein -o $DIR/tclout/$fileout'_psag.nc' 
 $CONVDIR/cat_conv_temp.tcl -i $filein -o $DIR/tclout/$fileout'_temp.nc' 
done

cd $DIR/tclout

cdo mergetime *psag.nc psags.nc
cdo mergetime *temp.nc temps.nc
cdo div temps.nc psags.nc adj_temps.nc
cdo seasmean adj_temps.nc adj_temps_seasmeans.nc
cdo selyear,1983/2012 adj_temps_seasmeans.nc adj_temps_seasmean_selected_years.nc
#remove final December in 2012
###cdo seltimestep,0/11235 adj_temps_seasmean_selected.nc $DIR/ncfiles/adj_temps.nc
cdo selmon,2,5,8,11 adj_temps_seasmean_selected.nc $DIR/ncfiles/adj_temps.nc
cdo splitseas $DIR/ncfiles/adj_temps.nc $DIR/ncfiles/ice_adj_T_


#cd $DIR/tclout
#rm -f
####################################
####################################

