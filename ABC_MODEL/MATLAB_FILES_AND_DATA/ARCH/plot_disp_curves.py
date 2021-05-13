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
fname_cgr=str(sys.argv[1])
fname_cac=str(sys.argv[2])
functionof=str(sys.argv[3])


# READ IN DATA
#=========================
cgr=np.genfromtxt(fname_cgr)
cac=np.genfromtxt(fname_cac) 

# DEFINE AN AXIS
#=========================
dims=np.shape(cgr)
xax=np.arange(dims[1])

# MAKE PLOT  (**** MAKE THIS A SUBROUTINE *******)
#=========================
plt.clf()
plt.figure()
plt.subplots_adjust(left=None, bottom=None, right=None, top=None, wspace=None, hspace=0.4)

plt.subplot(2, 1, 1)
plt.plot(xax, cac[1,:], 'k', label='wn=1')
plt.plot(xax, cac[2,:], 'k--', label='wn=2')
plt.plot(xax, cac[3,:], 'k:', label='wn=3')
plt.legend(loc='lower right', prop={'size':8})
plt.title('Acoustic wavespeeds')
plt.axis('tight')
plt.ylabel('Wave speed ms$^{-1}$')


plt.subplot(2, 1, 2)

plt.plot(xax, cgr[1,:], 'k', label='wn=1')
plt.plot(xax, cgr[2,:], 'k--', label='wn=2')
plt.plot(xax, cgr[3,:], 'k:', label='wn=3')
plt.legend(loc='lower right', prop={'size':8})
plt.title('Gravity wavespeeds')
plt.axis('tight')
plt.ylabel('Wave speed ms$^{-1}$')
plt.xlabel(functionof+' wave number')

# DEFINE OUTPUT FILE NAME
#=========================
ofile='Wavespeeds_fn_'+functionof+'_wn.eps'

# WRITE FIGURE TO FILE
#=========================
plt.savefig(ofile, format='eps', dpi=1000)

# DISPLAY FIGURE
#=========================
call("display "+ofile+"&", shell=True)  









