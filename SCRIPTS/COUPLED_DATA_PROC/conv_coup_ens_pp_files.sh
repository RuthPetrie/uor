#!/bin/ksh

echo '====================================================='
echo
echo 'Converting coupled climate model pp output to netcdf'
echo
echo '====================================================='

DIR='/export/quince/data-05/wx019276/COUPLED_EXPTS/PERT/RAWENSEMBLE/'
typeset -Z2 ENS

mbrs="10 25 29"

for ENS in ${mbrs}; do
  
  # Change to ensmble member directory 
  cd ${DIR}'en'${ENS}

  echo ====================================================  
  echo    ENSEMBLE MEMBER: ${ENS}
  
  # if a tar file exits
#  if [ -f *.tgz ]; then
#    echo
#    echo untar and unzipping
#    echo
    # then unzip the file 
 #   tar -zxf *.tgz
 # fi
  
  # for each pp file in the directory
  for FILE in *.pp; do
    echo $FILE
    FILEOUT=${FILE%pp}nc
    
    # convert to netcdf
    ~/SCRIPTS/converters/convpp2nc.tcl -i $FILE -o ${FILEOUT}
    if [ $? -eq 0 ]; then
      rm -f $FILE
    fi
  done
  
  echo
  echo    ${JOBID} COMPLETED
  echo
  echo ====================================================

  # increment ensemble member
#  ((ENS=ENS+1))

done

