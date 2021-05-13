###################################
#
#  PROGRAM TO PLOT DISPERSION CURVES
#  
#  Version
#  0.1   R. Petrie 27-5-2014
#
##################################


# SUPPLY 3 ARGS
#
# 1: GRAVITY WAVE SPEEDS FILE NAME
# 2: ACOUSTIC WAVE SPEEDS FILE NAME
# 3: HORIZONTAL OR VERTICAL (WAVE SPEEDS AS A FUNCTION OF)
#
# E.G
#
# python ./plot_disp_curves.py 'DATA/hori_grav_speed_REF.dat' 'DATA/hori_acou_speed_REF.dat' 'Horizontal'
# python ./plot_disp_curves.py 'DATA/vert_grav_speed_REF.dat' 'DATA/vert_acou_speed_REF.dat' 'Vertical'

# import all libraries
import matplotlib.pyplot as plt
from netCDF4 import Dataset
import numpy as np
import sys
import subprocess
from subprocess import call

#######################################################################################
#### INTERACTIVE MODE ONLY ############
# define system arguments when running in interactive mode define args, 
# dummy arg[0] required in interactive mode
#
# sys.argv = ['', 'hori_grav_speed_TestExp.dat', 'hori_acou_speed_TestExp.dat', 'Horizontal']
#
# then use execfile("?????.py")
#######################################################################################

# REPORT BACK ON ARGS
#=========================
total = len(sys.argv)
cmdargs = str(sys.argv)
print ("The total numbers of args passed to the script: %d " % total)
print ("Args list: %s " % cmdargs)
print ("Script name: %s" % str(sys.argv[0]))
for i in xrange(total):
    print ("Argument # %d : %s" % (i, str(sys.argv[i])))

# USE SUPPLIED ARGS TO DEFINE FILENAMES AND FUNCTIONOF
#=========================
fname_fac=str(sys.argv[1])
fname_fgr=str(sys.argv[2])
fname_cac_h=str(sys.argv[3])
fname_cgr_h=str(sys.argv[4])
fname_cac_v=str(sys.argv[5])
fname_cgr_v=str(sys.argv[6])

# READ IN DATA
#=========================
fac=np.genfromtxt(fname_fac)
fgr=np.genfromtxt(fname_fgr) 

cac_h=np.genfromtxt(fname_cac_h)
cgr_h=np.genfromtxt(fname_cgr_h)

cac_v=np.genfromtxt(fname_cac_v)
cgr_v=np.genfromtxt(fname_cgr_v)









