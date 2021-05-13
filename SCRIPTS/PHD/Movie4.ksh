#!/bin/ksh

# Converts ps files to gif and produces animation

export COUNTER="0001 0002 0003 0004 0005 0006 0007 0008 0009 0010 0011 0012 0013 0014 0015 0016 0017 0018 0019 0020 0021"
# 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 #65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 "

cd /home/wx019276/ASSIMILATION

# COMPILE AND RUN
#------------------

f90 -dalign -I/opt/graphics/include Main.f90 ConsType_Module.f90 Allocations.f90 Boundaries.f90 Cvt.f90 EnsembleGenerator.f90 EigsParamTrans.f90 GenerateObs.f90 InitDataProc.f90 InitCalculations.f90 Functions.f90 Balance.f90 Read.f90 ModelDriver.f90 Var.f90 ProgModel.f90 Linear_Analysis2.f90 Write.f90 -o Main.out -M/opt/graphics/include -L/opt/graphics/lib -lnetcdf -lhdf5_hl -lhdf5 -M/opt/local/lib/nag_mod_dir -L/opt/tools/lib -lnagfl90 
f90 -dalign -I/opt/graphics/include Main.f90 ConsType_Module.f90 Allocations.f90 Boundaries.f90 Cvt.f90 EnsembleGenerator.f90 EigsParamTrans.f90 GenerateObs.f90 InitDataProc.f90 InitCalculations.f90 Functions.f90 Balance.f90 Read.f90 ModelDriver.f90 Var.f90 ProgModel.f90 Linear_Analysis2.f90 Write.f90 -o Main.out -M/opt/graphics/include -L/opt/graphics/lib -lnetcdf -lhdf5_hl -lhdf5 -M/opt/local/lib/nag_mod_dir -L/opt/tools/lib -lnagfl90 

Main.out

cd /home/wx019276/ANALYSIS/MATLAB/model

# START MATLAB 
#---------------

 setup matlab

 matlab -softwareopengl -nojvm -r anim_b_w

# startup
# cd  /home/wx019276/ANALYSIS/MATLAB/model
# anim_b_w
# cd MovieFigures/
# run program in matlab

#advection_w
#quit
# exit

cd /home/wx019276/IMAGES/model/ANIMFIGS/

for i in ${COUNTER}; do
echo $i 
convert anim-$i.png anim-0$i.gif
# convert WAdvection_0-$i.png W_advection_0$i.gif
#convert Advection_0$i.ps Advection_0$i.gif
# convert Frame_$i.ps Frame_0$i.gif
# rm Frame_$i.ps
done

convert -loop 50 -delay 40 anim-0*.gif /home/wx019276/public_html/images/REGIME_TEST/RegTest27.gif

rm -f a*

echo "xanim /home/wx019276/public_html/images/REGIME_TEST/RegTest27.gif &"

echo "\07"
sleep 1
echo "\07"
sleep 1
echo "\07"
sleep 1


# convert -delay 10 Frame_*.gif test.gif
# convert -loop 50 -delay 40 Advection_*.gif  /home/wx019276/public_html/images/v_horiz_advect.gif
#convert -loop 50 -delay 40 Advection_*.gif nonlinear_upstream_u.gif       
# convert -loop 50 -delay 40 Frame_*.gif /home/wx019276/public_html/images/ModelTest2.gif         
#cp ModelEvolution.gif /home/wx019276/public_html/ModelEvolution.gif
# rhop_horiz_advect.gif
# v_horiz_advect.gif
