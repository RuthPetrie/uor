#!/bin/csh

set SEAS=$1
set EXPT=$2
@ START = $3
@ END = $4

@ YEAR = $START

setenv LD_LIBRARY_PATH /opt/graphics/64/lib

set DIR=/export/quince/data-05/wx019276
set DATA=${DIR}/um_expts/${EXPT}/trackdata

mkdir ${DIR}/TRACK/${EXPT}_$SEAS

while($YEAR <= $END)

     set INFILE=${EXPT}_winds_850_${YEAR}_${SEAS}.nc
     set VORFL=${EXPT}_vor850_${YEAR}_${SEAS}.dat
     set FILTF=${EXPT}_vor850_${YEAR}_${SEAS}_filt.dat
     set OUTDIR=${EXPT}_VOR850_${SEAS}${YEAR}

     set EXT=${EXPT}_${SEAS}$YEAR

   if(! -d ${DIR}/TRACK/${EXPT}_${SEAS}/$OUTDIR ) then

         \rm indat/$INFILE indat/$VORFL indat/$FILTF

         ln -s ${DATA}/$INFILE indat/$INFILE

         \rm vorcalc_$EXT

         sed -e "s@vor@indat/${VORFL}@" vorcalc.in > vorcalc_$EXT

         bin/track.linux -i $INFILE -f $EXT < vorcalc_$EXT  #>>/dev/null
         bin/track.linux -i $VORFL -f $EXT < filter.in
         mv outdat/specfil.${EXT}_band000 indat/$FILTF

         \rm vorcalc_$EXT

         master -c=$OUTDIR -d=now -e=track.linux -i=$FILTF -f=$EXT  -j=RUN_AT.in -n=1,32,12 -o=${DIR}/TRACK/${EXPT}_$SEAS -r=RUN_AT_ -s=RUNDATIN.VOR

         \rm outdat/*${EXT}*

   endif

     \rm indat/$INFILE indat/$VORFL indat/$FILTF

     @ YEAR ++

end
