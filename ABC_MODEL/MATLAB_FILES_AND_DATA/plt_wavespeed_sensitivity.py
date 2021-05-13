import matplotlib.pyplot as plt
from netCDF4 import Dataset
import numpy as np

# Read in data
c_gr_h_ref=np.genfromtxt('hoz_grav_speed_ref.dat')
c_gr_v_ref=np.genfromtxt('vert_grav_speed_ref.dat')
c_ac_h_ref=np.genfromtxt('hoz_ac_speed_ref.dat')
c_ac_v_ref=np.genfromtxt('vert_ac_speed_ref.dat')

# Define an x-axis for horizontal waves
hoz_dims=np.shape(c_gr_h_ref)
xax_hoz=np.arange(hoz_dims[1])

# Define an x-axis for vertical waves
vert_dims=np.shape(c_gr_v_ref)
xax_vert=np.arange(vert_dims[1])

# Select slice to plot
m=1
plot_m=c_gr_h_ref[1,:]


# Open a figure
plt.figure(1)
plt.plot(xax_hoz, c_gr_h_ref[4,:], 'k', label='C$_{gr}$')
plt.plot(xax_hoz, c_ac_h_ref[4,:], 'k--', label='C$_{ac}$')
plt.title('Wavespeeds as a function of horizontal wavenumber')
plt.legend(loc='best')
plt.axis('tight')
plt.ylabel('Wave speed ms$^{-1}$')
plt.xlabel('Wave number')
plt.show()
plt.close()

plt.figure(2)
plt.plot(xax_vert, c_gr_v_ref[101,:], 'k', label='C$_{gr}$')
plt.plot(xax_vert, c_ac_v_ref[101,:], 'k--', label='C$_{ac}$')
plt.title('Wavespeeds as a function of vertical wavenumber')
plt.legend(loc='best')
plt.axis('tight')
plt.ylabel('Wave speed ms$^{-1}$')
plt.xlabel('Wave number')
plt.show()
plt.close()

