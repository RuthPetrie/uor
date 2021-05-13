#!/bin/ksh

# Loop for um pp fields and create netcdf files
# of u and v at 850 
# with correct naming convention 
# to be compatible with the tracking setup 
file='/export/quince/data-06/wx019276/um_expts/fullpert/output/xhuida.pc'
outfile='/export/quince/data-06/wx019276/um_expts/pert/trackdata/pert_winds_850_'

for decade in 198 199 200 201
do
  if [[ $decade = '198' ]];then
    dec=i
  elif [[ $decade = '199' ]];then
    dec=j
  elif [[ $decade = '200' ]];then
    dec=k
  elif [[ $decade = '201' ]];then
    dec=l
  fi

  if [[ $decade = '201' ]];then
    for year in 0 1 2
    do
      for seas in c 3 6 9
      do
        if [[ $seas = 'c' ]];then
          season=son
        elif [[ $seas = '3' ]];then
          season=djf
        elif [[ $seas = '6' ]];then
          season=mam
        elif [[ $seas = '9' ]];then
          season=jja
        fi
        print $file$dec$year$seas'10.pp'
        print $outfile$decade$year'_'$season'.nc'
        ~/TRACK-1.4.3/converters/cat_conv.tcl -i $file$dec$year$seas'10.pp' -o $outfile$decade$year'_'$season'.nc'
       done
     done
  else
    for year in 0 1 2 3 4 5 6 7 8 9
    do
      for seas in c 3 6 9
      do
         if [[ $seas = 'c' ]];then
          season=son
        elif [[ $seas = '3' ]];then
          season=djf
        elif [[ $seas = '6' ]];then
          season=mam
        elif [[ $seas = '9' ]];then
          season=jja
        fi
        print $file$dec$year$seas'10.pp'
        print $outfile$decade$year'_'$season'.nc'
        ~/TRACK-1.4.3/converters/cat_conv.tcl -i $file$dec$year$seas'10.pp' -o $outfile$decade$year'_'$season'.nc'
    done
   done

  fi

done
