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
# python -i ./plot_dispersion_relations.py 'DATA/grav_frequency_REF.dat' 'DATA/acou_frequency_REF.dat' 'Horizontal'

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
fname_fgr=str(sys.argv[1])
fname_fac=str(sys.argv[2])
functionof=str(sys.argv[3])


# READ IN DATA
#=========================
fgr=np.genfromtxt(fname_fgr)
fac=np.genfromtxt(fname_fac) 

# DEFINE AN AXIS
#=========================
dims=np.shape(fgr)
xax=np.arange(dims[0])

# MAKE PLOT  (**** MAKE THIS A SUBROUTINE *******)
#=========================
plt.clf()
plt.figure()
plt.subplots_adjust(left=None, bottom=None, right=None, top=None, wspace=None, hspace=0.4)

plt.subplot(2, 1, 1)
plt.plot(xax, fac[:,1], 'k', label='wn=1')
plt.plot(xax, fac[:,2], 'k--', label='wn=2')
plt.plot(xax, fac[:,3], 'k:', label='wn=3')
plt.legend(loc='lower right', prop={'size':8})
plt.title('Acoustic waves')
plt.axis('tight')
plt.ylabel('Wave frequency s$^{-1}$')


plt.subplot(2, 1, 2)
plt.plot(xax, fgr[:,1], 'k', label='wn=1')
plt.plot(xax, fgr[:,2], 'k--', label='wn=2')
plt.plot(xax, fgr[:,3], 'k:', label='wn=3')
plt.legend(loc='lower right', prop={'size':8})
plt.title('Gravity waves')
plt.axis('tight')
plt.ylabel('Wave frequency s$^{-1}$')
plt.xlabel(functionof+' wave number')

# DEFINE OUTPUT FILE NAME
#=========================
ofile='Frequencies_fn_'+functionof+'_wn.eps'

# WRITE FIGURE TO FILE
#=========================
plt.savefig(ofile, format='eps', dpi=1000)

# DISPLAY FIGURE
#=========================
call("display "+ofile+"&", shell=True)  









