#!/usr/bin/env python
import matplotlib.pyplot as plt
from mpl_toolkits.basemap import Basemap, shiftgrid, addcyclic
import numpy as np
from netCDF4 import Dataset as nc

#read in data
data = nc('air_mon_mean.nc')
#data = nc('gdata.nc')
temp = data.variables['air'][0,:,:]
lons = data.variables['lon'][:]
lats = data.variables['lat'][:]

plt.figure(figsize=(11, 8))
plt.tick_params(direction='out', which='both')

#set up map
mymap = Basemap(projection='cyl',llcrnrlon=0, urcrnrlon=360, \
                llcrnrlat=-90, urcrnrlat=90)#, \
               # lon_0=180, lat_0=0, resolution='c')  

[x,y]=np.meshgrid(lons, lats)

#contour data
clevs=np.arange(-32,36,4) #levels
cs = mymap.contourf(x,y,temp,clevs,extend='both')
plt.colorbar(orientation='horizontal', aspect=75, pad=0.08, ticks=clevs)
cs = mymap.contour(x,y,temp,clevs,colors='k')
plt.clabel(cs, fmt = '%d', colors = 'k', fontsize=11) 

#axes
#plt.xticks(np.arange(-180, 210, 60), ['180', '120W', '60W', '0', '60W', '120W', '180'])
#plt.yticks(np.arange(-90, 120, 30), ['90S', '60S', '30S', '0', '30N', '60N', '90N'])


#coastlines and title
mymap.drawcoastlines()
plt.title('Temperature in degrees Celsius', y=1.03)
plt.savefig('ex1.png')
plt.show()


