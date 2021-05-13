#!/bin/ksh

#cd /home/wx019276/Modelling/Fortran/Model/Prognostic

#Compile Program
f90 -C -I/opt/graphics/include Forw_Mod_Driver.f90 -o  Forw_Mod_Driver.out  Constants3d.f90  Allocations.f90  Read_Field.f90 Interpolation2d.f90 Model3.f90 Write_Field3d.f90 Boundaries3d.f90 -M/opt/graphics/include -L/opt/graphics/lib -lnetcdf -lhdf5_hl -lhdf5
f90 -C -I/opt/graphics/include Forw_Mod_Driver.f90 -o  Forw_Mod_Driver.out  Constants3d.f90  Allocations.f90  Read_Field.f90 Interpolation2d.f90 Model3.f90 Write_Field3d.f90 Boundaries3d.f90 -M/opt/graphics/include -L/opt/graphics/lib -lnetcdf -lhdf5_hl -lhdf5


#Run Program
Forw_Mod_Driver.out
echo "\07"
echo "\07"
echo "\07"


# change directory to run matlab
cd /home/wx019276/Modelling/Matlab/model

# run advection routine
setup matlab
# matlab -nodesktop -nosplash -nojvm -r advection_w2 
matlab -nodesktop -nosplash -nojvm -r ModelPlot

# setup counter
export COUNTER="0001 0002 0003 0004 0005 0006 0007 0008 0009 0010 0011 "
#0012 0013 0014 0015 0016 0017 0018 0019 0020 0021" 
#0022 0023 0024 0025 0026 0027 0028 0029"
#0021 0022 0023 0024 0025 0026 0027 0028 0029 0030 0031 0032 0033 0034 0035 0036 0037 0038 0039 0040 0041 0042 0043 0044 0045 0046 0047 0048 0049 0050 0051"
#0052 0053 0054 0055 0056 0057 0058 0059 0060 0061 0062 0063 0064 0065 0066 0067 0068 0069 0070 0071 0072 0073 0074 0075 0076 0077 0078 0079 0080 0081 0082 0083 0084 0085 0086 0087 0088 0089 0090 0091 0092 0093 0094 0095 0096 0097 0098 0099 0100 0101 "

# change to figures directory
cd /home/wx019276/Modelling/Matlab/model/MovieFigures

# convert png's to gif
for i in ${COUNTER}; do
echo $i
convert Model_Plot-$i.png Model_Plot-$i.gif
rm -f Model_Plot-$i.png
done
echo "\07"

convert -loop 50 -delay 40 Model_Plot*.gif /home/wx019276/public_html/images/PMT_C26_33.gif

rm -f Model_Plot*gif

# change directory to run matlab
#cd /home/wx019276/Modelling/Matlab/model

# run advection routine
#setup matlab
# matlab -nodesktop -nosplash -nojvm -r advection_w2 
#matlab -nodesktop -nosplash -nojvm -r Tracer 

# change to figures directory
#cd /home/wx019276/Modelling/Matlab/model/MovieFigures

# convert png's to gif
#for i in ${COUNTER}; do
#echo $i
#convert Tracer-$i.png Tracer-$i.gif
#rm -f Tracer-$i.png
#done
#echo "\07"
#convert -loop 50 -delay 40 Tracer*.gif /home/wx019276/public_html/images/ATracer_18.gif
#rm -f Tracer*gif



echo "\07"
sleep 1
echo "\07"
sleep 1
echo "\07"
