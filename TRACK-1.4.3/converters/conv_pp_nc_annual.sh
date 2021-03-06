#!/bin/ksh


infileloc='/export/quince/data-05/wx019276/um_expts/iceonly/output/'
outfileloc='/export/quince/data-05/wx019276/um_expts/iceonly/trackdata/'

cd /export/quince/data-05/wx019276/um_expts/iceonly/output/

#infile=$infileloc'xhuiea.pck[0-1]*.pp '$infileloc'xhuiea.pck[2-3]*.pp '$infileloc'xhuiea.pck[4-5]*.pp '$infileloc'xhuiea.pck[6-7]*.pp '$infileloc'xhuiea.pck[8-9]*.pp '
#infile='xhuiea.pck[0-5]*.pp '
#infile=$infileloc'xhuiea.pck[8-9]*.pp '$infileloc'xhuiea.pcj[6-9]*.pp '
#outfile=$outfileloc'winds_1996_2012.nc'

for file in xhuiea.pci[1-8]*.pp
do
  infile=$file
  outfile=${file%pp}nc 
  print $infile
  print $outfile
  
~/TRACK-1.4.3/converters/cat_conv.tcl -i $infile -o $outfileloc$outfile

done

for file in xhuiea.pcj*.pp
do
  infile=$file
  outfile=${file%pp}nc 
  print $infile
  print $outfile
  
~/TRACK-1.4.3/converters/cat_conv.tcl -i $infile -o $outfileloc$outfile

done

for file in xhuiea.pck*.pp
do
  infile=$file
  outfile=${file%pp}nc 
  print $infile
  print $outfile
  
~/TRACK-1.4.3/converters/cat_conv.tcl -i $infile -o $outfileloc$outfile

done

for file in xhuiea.pcl*.pp
do
  infile=$file
  outfile=${file%pp}nc 
  print $infile
  print $outfile
  
~/TRACK-1.4.3/converters/cat_conv.tcl -i $infile -o $outfileloc$outfile

done

