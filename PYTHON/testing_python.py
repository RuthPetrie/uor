import numpy as np
import matplotlib.pyplot as plt
import datetime
from mpl_toolkits.basemap import Basemap, shiftgrid
from netCDF4 import Dataset

file = '/export/quince/data-06/wx019276/um_expts/ctrl/ncfiles/ctrl_mslp_djf.nc'
mslp_djf = Dataset(file)


# read lats,lons
# reverse latitudes if required with [::-1]

latitudes = mslp_djf.variables['latitude'][:] 
longitudes = mslp_djf.variables['longitude'][:].tolist()
times = mslp_djf.variables['t'][:].tolist()

# mult slp by 0.01 to put in units of hPa.
slpinall = 0.01*mslp_djf.variables['p'][:].squeeze()
slpin = slpinall[0,:,:].squeeze()
# add cyclic points manually (could use addcyclic function)
slp = np.zeros((slpin.shape[0],slpin.shape[1]+1),np.float)
slp[:,0:-1] = slpin[::-1]; slp[:,-1] = slpin[::-1,0]
longitudes.append(360.); longitudes = np.array(longitudes)

lons, lats = np.meshgrid(longitudes,latitudes)

# make orthographic basemap.
#m = Basemap(resolution='c',projection='npstere',lat_0=30.,lon_0=60.0)
m = Basemap(projection='npstere',boundinglat=10,lon_0=270,resolution='l')

# create figure, add axes
fig1 = plt.figure(figsize=(8,10))
ax = fig1.add_axes([0.1,0.1,0.8,0.8])
clevs = np.arange(960,1061,5)

# compute native x,y coordinates of grid.
x, y = m(lons, lats)

# define parallels and meridians to draw.
parallels = np.arange(-80.,90,20.)
meridians = np.arange(0.,360.,20.)

# plot SLP contours.
CS1 = m.contour(x,y,slp,clevs,linewidths=0.5,colors='k',animated=True)

# draw coastlines, parallels, meridians.
m.drawcoastlines(linewidth=1.5)
m.drawparallels(parallels)
m.drawmeridians(meridians)

# add colorbar
cb = m.colorbar(CS1,"bottom", size="5%", pad="2%")
cb.set_label('hPa')

# set plot title
ax.set_title('SLP and Wind Vectors '+str(date))
plt.show()
