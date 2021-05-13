import matplotlib.pyplot as plt
from netCDF4 import Dataset
import numpy as np
from subprocess import call

fname_cgr='vert_grav_speed_TestExp.dat'
fname_cac='vert_acou_speed_TestExp.dat'
functionof='Vertical'

finfo_cgr=fname_cgr.strip('.dat')
finfo_cac=fname_cac.strip('.dat')


# Read in wave speeds as a function of horizontal wavenumber
cgr=np.genfromtxt(fname_cgr)
ccac=np.genfromtxt(fname_cac) 

hoz_dims=np.shape(cgr)
xax_hoz=np.arange(hoz_dims[1])

plt.clf()
plt.figure()
plt.subplot(2, 1, 1)
plt.plot(xax_hoz, ccac[1,:], 'k', label='C$_{ac}$; m=1')
plt.plot(xax_hoz, ccac[2,:], 'k--', label='C$_{ac}$; m=2')
plt.plot(xax_hoz, ccac[3,:], 'k:', label='C$_{ac}$; m=3')
plt.legend(loc='lower right', prop={'size':8})
plt.title('Acoustic wavespeeds')
plt.axis('tight')
plt.ylabel('Wave speed ms$^{-1}$')


plt.subplot(2, 1, 2)
plt.plot(xax_hoz, cgr[1,:], 'k', label='C$_{gr}$; m=1')
plt.plot(xax_hoz, cgr[2,:], 'k--', label='C$_{gr}$; m=2')
plt.plot(xax_hoz, cgr[3,:], 'k:', label='C$_{gr}$; m=3')
plt.legend(loc='lower right', prop={'size':8})
plt.title('Gravity wavespeeds')
plt.axis('tight')
plt.ylabel('Wave speed ms$^{-1}$')
plt.xlabel(functionof+' wave number')

plt.savefig(fileinfo+'.eps', format='eps', dpi=1000)

call("display "+fileinfo+'.eps'+"&", shell=True)  
