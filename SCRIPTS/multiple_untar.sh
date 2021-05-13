#!/bin/ksh

DIR='/export/quince/data-07/wx019276/coupled_expts/CTRL/'
cd ${DIR}

# set ensemble number to have two digits
typeset -Z2 counter
counter=20

for job in {1..4}; do
  echo en${counter}
  
  # change directory to next ensemble member
  cd ${DIR}'en'${counter}
  
  tar -zxvf *.tgz
  
  # increase counter #
  ((counter=counter+1))
done

counter=26
for job in {1..5}; do
  echo en${counter}
  
  # change directory to next ensemble member
  cd ${DIR}'en'${counter}
  
  tar -zxvf *.tgz
  
  # increase counter #
  ((counter=counter+1))
done

echo "   _____ ____  __  __ _____  _      ______ _______ ______ ";
echo "  / ____/ __ \|  \/  |  __ \| |    |  ____|__   __|  ____|";
echo " | |   | |  | | \  / | |__) | |    | |__     | |  | |__   ";
echo " | |   | |  | | |\/| |  ___/| |    |  __|    | |  |  __|  ";
echo " | |___| |__| | |  | | |    | |____| |____   | |  | |____ ";
echo "  \_____\____/|_|  |_|_|    |______|______|  |_|  |______|";
echo "                                                          ";
echo "                                                          ";

