#!/bin/ksh

echo 'performing data extraction'

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


   echo $mon
   echo $monnum

 done

