import matplotlib.pyplot as plt
from mpl_toolkits.basemap import Basemap
import netCDF4 as nc

dataset=nc.Dataset('air.mon.mean.nc')
airtemp=dataset.variables['air']
lon=dataset.variables['lon']
lat=dataset.variables['lat']

plt.figure(1)
map = Basemap(min(lon),min(lat),max(lon),max(lat), resolution='i', projection='merc')
map.drawcoastlines()
image = map.transform_scalar(airtemp[:,:,:].mean(0), lon[:], lat[:], 500, 500)
map.imshow(image)
cb = plt.colorbar(orientation='horizontal')
cb.set_label('Air Temp')
plt.title('Air Temp')

