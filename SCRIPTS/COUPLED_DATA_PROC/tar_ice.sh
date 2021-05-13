#/usr/bin/ksh

 

ddir='/export/quince/data-05/wx019276/COUPLED_EXPTS/PERT/RAWENSEMBLE/'
# typeset -Z2 ENS
for ENS in {01 02 03 04 05 06 07 08 09}; do
  echo $ENS
  echo ${ddir}en${ENS}
  cd ${ddir}en${ENS}
  tar -zcf ice_${ENS}.tgz *i.1m.* 

  if [ $? -eq 0 ]; then
   rm -f *i.1m.* 
  fi
done

ENS=01
  echo $ENS
  echo ${ddir}en${ENS}
  cd ${ddir}en${ENS}
  tar -zcf ice_${ENS}.tgz *i.1m.* 

  if [ $? -eq 0 ]; then
   rm -f *i.1m.* 
  fi

ENS=09
  echo $ENS
  echo ${ddir}en${ENS}
  cd ${ddir}en${ENS}
  tar -zcf ice_${ENS}.tgz *i.1m.* 

  if [ $? -eq 0 ]; then
   rm -f *i.1m.* 
  fi


for ENS in {10..30}; do
  echo $ENS
  echo ${ddir}en${ENS}
  cd ${ddir}en${ENS}
  tar -zcf ice_${ENS}.tgz *i.1m.* 

  if [ $? -eq 0 ]; then
   rm -f *i.1m.* 
  fi
done

