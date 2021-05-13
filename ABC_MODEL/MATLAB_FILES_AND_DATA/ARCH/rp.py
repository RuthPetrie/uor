import matplotlib.pyplot as plt
import matplotlib.colors as mcolors
import numpy as np
import netCDF4 as nc
from pylab import *
import subprocess
from subprocess import call


d=nc.Dataset('/home/wx019276/MODELLING/MATLAB_FILES_AND_DATA/Geostropic_Adjustment.nc')
lons=d.variables['longs_v'][:] # only need this as rho is defined at v points
levs=d.variables['half_level'][:]
times=d.variables['time'][:]
u=d.variables['u'][:,:,:]
v=d.variables['v'][:,:,:]
p=d.variables['rho_prime'][:,:,:]
p=p*100
#levels=np.arange(11, dtype=float)
#levels=np.arange(-10,12,2, dtype=float)
levels=[-1.0,-0.75,-0.5,-0.25,-0.2,-0.15,-0.1,-0.05,-0.01,0.01,0.05,0.1,0.15,0.2,0.25,0.5,0.75,1.0]
#cmap=cm.Greys
cmap=cm.bwr

init=np.where(times==0.0)[0][0]
half=np.where(times==1800.0)[0][0]
one=np.where(times==3600.0)[0][0]
two=np.where(times==7200.0)[0][0]
three=np.where(times==10800.0)[0][0]

levs=levs*0.001
lons=lons*0.001

X,Y = meshgrid(lons,levs)

# ARRAY SHAPES ARE 0=time, 1=levels, 2=longitudes; e.g. (31, 60, 360)
# make subroutine for plotting subplots (initial time is done explicitly)
def pltsubplot(X,Y,p,u,v,levels,lons,levs, time, title):
  plt.contourf(X,Y,p[time,:,:], levels, cmap=cm.get_cmap(cmap, len(levels)-1) )
#  plt.contour(X,Y,p[time,:,:])#, colors='k' )
  plt.axis([min(lons), max(lons), min(levs), max(levs)])
  
  Q=quiver(X[::3,::30],Y[::3,::30], u[time,::3,::30], v[time,::3,::30], color='k', scale=40, pivot='mid')
  if time == half:
    quiverkey(Q, 0.9, 1.1, 4, '10 ms$^{-1}$', labelpos='E',)
  
  plt.title(title)
  

# set up plot
plt.clf
plt.figure()

# make intitial plot with additional info
fg1 = plt.subplot2grid((6,4), (0, 1), colspan=2, rowspan=2)
geo=plt.contourf(X,Y,p[init,:,:], levels, cmap=cm.get_cmap(cmap, len(levels)-1) )

#plt.contour(X,Y,p[init,:,:])#, colors='k' )
plt.axis([min(lons), max(lons), min(levs), max(levs)])
plt.title("Initial perturbation")
plt.xlabel('Longitudinal distance (km)')
plt.ylabel('Height (km)')

colorbar_labels=[-1.0,-0.25,-0.05, 0.05,0.25,1.0]
cb=plt.colorbar(geo,orientation='vertical', shrink=1.0,  pad=0.1, ticks=colorbar_labels,)
#cb=plt.colorbar(geo,orientation='vertical', shrink=0.9,anchor=(2.25, 0.50), pad=-0.25)

#cb.ax.set_yticklabels(['-1.0', '0', '1.0'])

# timeslices using subrouting pltsubplot 
fg2 = plt.subplot2grid((6,4), (2, 0), colspan=2, rowspan=2)
pltsubplot(X,Y,p,u,v,levels,lons,levs,half,"Time = Half hour")

fg3 = plt.subplot2grid((6,4), (2, 2), colspan=2, rowspan=2)
pltsubplot(X,Y,p,u,v,levels,lons,levs,one,"Time = One hour")

fg4 = plt.subplot2grid((6,4), (4, 0), colspan=2, rowspan=2)
pltsubplot(X,Y,p,u,v,levels,lons,levs,two,"Time = Two hours")

fg5 = plt.subplot2grid((6,4), (4,2), colspan=2, rowspan=2)
pltsubplot(X,Y,p,u,v,levels,lons,levs,three,"Time = Three hours")

plt.tight_layout()

ofile="geostrophic_adj.eps"

# WRITE FIGURE TO FILE
#=========================
plt.savefig(ofile, format='eps', dpi=1000)

# DISPLAY FIGURE
#=========================
call("display "+ofile+"&", shell=True)  



#plt.plot(xax_hoz, c_gr_h_ref[4,:], 'k', label='C$_{gr}$')
#plt.plot(xax_hoz, c_ac_h_ref[4,:], 'k--', label='C$_{ac}$')
#plt.title('Wavespeeds as a function of horizontal wavenumber')
#plt.legend(loc='best')
#plt.axis('tight')
#plt.ylabel('Wave speed ms$^{-1}$')
#plt.xlabel('Wave number')
#plt.show()
#plt.close()
