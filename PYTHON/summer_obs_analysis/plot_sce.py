#!/usr/bin/env python
import matplotlib.pyplot as plt
import numpy as np
from netCDF4 import Dataset as nc

sce = nc('/net/quince/export/quince/data-07/wx019276/SNOW/rsl_sce_1979_2013_sa.nc')
time=sce.variables['time'][:]
snowcover=sce.variables['snowcover'][:]

fig = plt.figure(figsize=(22, 16))
ax1 = fig.add_subplot(111)

ax1.axis([1979, 2013, 310, 390])
ax1.tick_params(direction='out', which='both')
ax1.set_xlabel('Year')
ax1.set_ylabel('SCE (10^6 km2)')
ax1.set_xticks(np.arange(1979, 2014, 2))
ax1.set_yticks(np.arange(-30, 30, 5))

ax1.plot(time[:], snowcover[:], label='Snow Cover Extent', color="blue")

ax1.legend(loc='upper left')
fig.savefig('sce_anom_timeseries.png')


#ax1.show()


#plt.clf()
#plt.plot(time,snowcover,'b', label='Snow Cover Extent')
#plt.legend(loc='best')

#plt.xlabel('year')
#plt.ylabel('SCE $10^6$km$^2$')
#plt.set_xticks(np.arange(1979, 2014, 2))
#plt.show()
#plt.savefig('sce_anom_timeseries.png')


