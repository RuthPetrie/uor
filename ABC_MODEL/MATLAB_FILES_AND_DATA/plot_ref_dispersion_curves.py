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
# sys.argv = ['', 'DATA/hori_grav_speed_TestExp.dat', 'DATA/hori_acou_speed_TestExp.dat', 'DATA/Horizontal']
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
fac=np.genfromtxt(fname_fac) # (360,60)
fgr=np.genfromtxt(fname_fgr) # (360,60)

cac_h=np.genfromtxt(fname_cac_h) # (60,360)
cgr_h=np.genfromtxt(fname_cgr_h) # (60,360)

cac_v=np.genfromtxt(fname_cac_v) # (360,60)
cgr_v=np.genfromtxt(fname_cgr_v) # (360,60)

# DEFINE A AXES
#=========================
xax_h=np.arange(359)+1
xax_v=np.arange(59)+1

ylabelfrequency='Frequency s$^{-1}$'
ylabelspeed='Wave speed ms$^{-1}$'
ac_title='Acoustic waves'
gr_title='Gravity waves'
xlabelhoz='Horizontal wavenumber'
xlabelvert='Vertical wavenumber'

def makesubplot(axis,var,title,xlabel,ylabel,nt):
  plt.plot(axis, var[1,1:nt], 'k', label='wn=1')
  plt.plot(axis, var[2,1:nt], 'k--', label='wn=2')
  plt.plot(axis, var[3,1:nt], 'k:', label='wn=3')
  plt.legend(loc='lower right', prop={'size':8}, frameon=False )
  plt.title(title)
  plt.axis('tight')
  plt.ylabel(ylabel)
  plt.xlabel(xlabel)


# SET UP PLOT
#=========================
plt.clf
plt.figure(figsize=(11, 8))

fg1 = plt.subplot2grid((3,2), (0, 0))
makesubplot(xax_h,np.transpose(fac),ac_title,xlabelhoz,ylabelfrequency,360)

fg2 = plt.subplot2grid((3,2), (0, 1))
makesubplot(xax_h,np.transpose(fgr),gr_title,xlabelhoz,ylabelfrequency,360)

fg3 = plt.subplot2grid((3,2), (1, 0))
makesubplot(xax_h,cac_h,' ',xlabelhoz,ylabelspeed,360)

fg4 = plt.subplot2grid((3,2), (1, 1))
makesubplot(xax_h,cgr_h,' ',xlabelhoz,ylabelspeed,360)

fg5 = plt.subplot2grid((3,2), (2, 0))
makesubplot(xax_v,cac_v,' ',xlabelvert,ylabelspeed,60)

fg6 = plt.subplot2grid((3,2), (2, 1))
makesubplot(xax_v,cgr_v,' ',xlabelvert,ylabelspeed,60)





plt.tight_layout()

ofile="FIGS/dispersion_relations.eps"

# WRITE FIGURE TO FILE
#=========================
plt.savefig(ofile, format='eps', dpi=1000)

# DISPLAY FIGURE
#=========================
call("display "+ofile+"&", shell=True)  




