#!/bin/ksh

# Converts ps files to gif and produces animation

export DIR=/home/wx019276/Modelling/Matlab/model

export COUNTER="2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 "
# 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 "

# Compile code

# start matlab
#setup matlab
#matlab -nojvm

# run program in matlab

#advection_w


exit

for i in ${COUNTER}; do
echo $i


 #convert WAdvection_0$i.png W_advection-0$i.gif
#convert Advection_0$i.ps Advection_0$i.gif
# convert Frame_$i.ps Frame_0$i.gif
# rm Frame_$i.ps
done

cp Advection_02.gif Advection_002.gif
rm  Advection_02.gif
cp Advection_03.gif Advection_003.gif
rm  Advection_03.gif
cp Advection_04.gif Advection_004.gif
rm Advection_04.gif
cp Advection_05.gif Advection_005.gif
rm  Advection_05.gif
cp Advection_06.gif Advection_006.gif
rm  Advection_06.gif
cp Advection_07.gif Advection_007.gif
rm  Advection_07.gif
cp Advection_08.gif Advection_008.gif
rm  Advection_08.gif
cp Advection_09.gif Advection_009.gif
rm  Advection_09.gif
cp Advection_0100.gif Advection_100.gif
rm Advection_0100.gif
cp Advection_0101.gif Advection_101.gif
rm  Advection_0101.gif

# convert -delay 10 Frame_*.gif test.gif
# convert -loop 50 -delay 40 Advection_*.gif  /home/wx019276/public_html/images/v_horiz_advect.gif
#convert -loop 50 -delay 40 Advection_*.gif nonlinear_upstream_u.gif       
# convert -loop 50 -delay 40 Frame_*.gif /home/wx019276/public_html/images/ModelTest2.gif         
#cp ModelEvolution.gif /home/wx019276/public_html/ModelEvolution.gif
# rhop_horiz_advect.gif
# v_horiz_advect.gif
