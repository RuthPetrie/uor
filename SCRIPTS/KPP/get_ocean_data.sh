#/bin/usr/sh    

# get ocean data T & S from Jon Robson

# Define directories
DDIR='/net/jasmin/old_servers/aspen/data-06/swr06jir/new_ocean_anal/xbt_biascor/monthly/51-06'
ODIR='/net/quince/export/quince/data-05/wx019276/OCEAN_ANALYSIS'

# cd to data loc
cd ${DDIR}

for YEAR in {1979..2011}; do

  cp pot_anal_${YEAR}*nc ${ODIR}
  cp sal_anal_${YEAR}*nc ${ODIR}
  
done
