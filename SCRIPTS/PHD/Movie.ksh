#!/bin/ksh

# Converts ps files to gif and produces animation

#export DIR=/home/wx019276/Modelling/Matlab/model

export COUNTER="0001 0002 0003 0004 0005 0006 0007 0008 0009 0010 0011 0012 0013 0014 0015 0016 0017 0018 0019 0020 0021 "
# 0022 0023 0024 0025 0026 0027 0028 0029 0030 0031 0032 0033 0034 0035 0036 0037 0038 0039 0040 0041 0042 0043 0044 0045 0046 0047 0048 0049 0050 0051 "
# 0052 0053 0054 0055 0056 0057 0058 0059 0060 0061 0062 0063 0064 0065 0066 0067 0068 0069 0070 0071 0072 0073 0074 0075 0076 0077 0078 0079 0080 0081 0082 0083 0084 0085 0086 0087 0088 0089 0090 0091 0092 0093 0094 0095 0096 0097 0098 0099 0100 0101 "

# Compile code

# start matlab
setup matlab

matlab -nodesktop -nosplash -nojvm -r advection_w 
cd MovieFigures/
# run program in matlab

#advection_w

#echo "\07"


cd /home/wx019276/Modelling/Matlab/model/MovieFigures
for i in ${COUNTER}; do
echo $i
#convert Model_Plot-$i.ps Model_Plot-$i.gif
convert W_advection-$i.png W_advection-0$i.gif
rm -f W_advection-$i.png
# convert WAdvection_0-$i.png W_advection_0$i.gif
#convert Advection_0$i.ps Advection_0$i.gif
# convert Frame_$i.ps Frame_0$i.gif
#rm -f Model_Plot-$i.png
done
echo "\07"
sleep 1
echo "\07"
sleep 1
echo "\07"


convert -loop 50 -delay 40 W_advection-*.gif /home/wx019276/public_html/images/PMT_RG_02.gif
for i in ${COUNTER}; do
rm -f W_advection$i.gif
done
# convert -delay 10 Frame_*.gif test.gif
# convert -loop 50 -delay 40 Advection_*.gif  /home/wx019276/public_html/images/v_horiz_advect.gif
#convert -loop 50 -delay 40 Advection_*.gif nonlinear_upstream_u.gif       
# convert -loop 50 -delay 40 Frame_*.gif /home/wx019276/public_html/images/ModelTest2.gif         
#cp ModelEvolution.gif /home/wx019276/public_html/ModelEvolution.gif
# rhop_horiz_advect.gif
# v_horiz_advect.gif
