#-------------#
#import the necessary libraries#
#-------------#
import matplotlib.mlab as mlab
import matplotlib.pyplot as plt
import netCDF4
import numpy as np
from mpl_toolkits.basemap import Basemap, cm

#---------------------------------LIBRARIES------------------------------------#
import netCDF4 
from numpy import *
from pylab import *
from netCDF4 import Dataset
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
import scipy
from scipy import signal
import scipy.stats
import copy

#-------------------------ANOMALY DATA-----------------------------------------#
sia_SON = np.array([7644032.11577513,8099561.06148518,7625208.85766086,8153872.99474727,8049584.18452198,7376773.9147595,7549680.52764765,8146694.58773359,8079525.23346202,8112007.74706668,7649142.467251,7399612.03934649,7473210.16398489,8161333.33425849,7573608.6759379,   7860249.94346027,  6886421.41364489,  7790746.4058756,   7455822.67301782,7488209.42341681,  7503371.45589186,  7360382.99423041,  7563148.31651132,  7140041.24003371,  6999969.77563445,7166206.70816489,  6711348.24284829,  6743338.94321398,  5679007.7889199,   6475228.21928624,  6470773.30685772,6376908.19868507])
mean_sia_SON_1979_2000 = 7701775.101 #1979-2000 mean

anomaly=np.zeros(len(sia_SON)) #empty array to store data
anomaly[:] = [(x - mean_sia_SON_1979_2000) for x in sia_SON]
    
sia_detrended = scipy.signal.detrend(sia_SON)
mean_sia_detrended = np.mean(sia_detrended[0:22])  #1979-2000 mean

anomaly_detrended=np.zeros(len(sia_detrended))#empty array to store data
anomaly_detrended[:] = [(x - mean_sia_detrended) for x in sia_detrended]
    
sign_reversed_anomaly_detrended = anomaly_detrended*(-1)/1e6
#------------------------------------------------------------------------------#
#print sia_detrended

nc = netCDF4.Dataset('mslp_DJF.nc')     #mean value for each season. please notice winter of a year is stored on the february of next year
vars = nc.variables.keys(); 
lon = nc.variables['longitude'][:]    
lat = nc.variables['latitude']
time = nc.variables['time'] 
mslp = nc.variables['mslp']     
mslpVal = mslp[:]/100   # it is Pascals so /100 to make it hPa
timeVal = time[:]

grad = np.zeros((128,512))

for i in xrange(128):
    for j in xrange(512):
        gradient, intercept, r_value, p_value, std_err = scipy.stats.linregress(sign_reversed_anomaly_detrended,mslpVal[1:32+1,i,j])   #put the indeces for the years i want
        grad[i,j]=gradient
#print grad
print 'r_value=',r_value

m = Basemap(projection = 'npstere', boundinglat=20,lon_0=90, resolution='c',round=True)
m.drawcoastlines()
m.drawlsmask(land_color='orange')
# draw parallels and meridians.        
parallels = np.arange(-60.,91.,10.)
m.drawparallels(parallels)# label parallels on right and top
meridians = np.arange(0.,359.,30.)
m.drawmeridians(meridians,labels='auto')
# convert to map projection coords.
X,Y = np.meshgrid(lon,lat)
xpt,ypt = m(X,Y)
cm = plt.cm.get_cmap('seismic',10)
m.scatter(xpt, ypt, c = grad, cmap=cm, s=40, edgecolors='none',marker='s',vmin=-5,vmax=5)

cb = plt.colorbar(orientation='horizontal',drawedges=True)
cb.set_label('Plotted as regression coefficients with units of hPa')

cb.outline.set_color('black')
cb.outline.set_linewidth(2)

cb.dividers.set_color('black')
cb.dividers.set_linewidth(1.5)

plt.suptitle('Linear regression of winter MSLP (hPa) onto the sign-reversed \n detrended autumn Arctic SIA anomaly (1979-2010)',fontsize=14)  #. title
plt.show()
