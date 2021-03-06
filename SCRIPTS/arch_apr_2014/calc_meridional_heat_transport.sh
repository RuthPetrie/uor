#!/bin/ksh

setup cdo
CONVDIR=/home/wx019276/TRACK\-1.4.3/converters

EXPT=ctrl
EXPTID=xhuica
TRANSDIR=/export/quince/data-06/wx019276/um_expts/${EXPT}/trans_tmp
UMOUTDIR=/export/quince/data-06/wx019276/um_expts/${EXPT}/output
VAR=T

cd ${UMOUTDIR}
for file in ${EXPTID}.pc* ;do
  filein=${file}
  fileout=${filein%.pp}
  ${CONVDIR}/cat_conv_${VAR}.tcl -i ${filein} -o ${TRANSDIR}/${fileout}'_'${VAR}'.nc' 
done

cd ${TRANSDIR}
cdo mergetime *_${VAR}.nc ctrl_6hrly_${VAR}.nc


