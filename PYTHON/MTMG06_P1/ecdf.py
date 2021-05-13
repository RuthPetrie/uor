import matplotlib.pyplot as plt
import numpy as np
import scipy.stats as sp

# data
heights=[185, 173, 180,178,170,182,178,175,181,175,197,168,172]
hgts=np.array(heights)
nbins=len(heights)
#ecdf=sp.cumfreq(hgts, nbins)

hts_sorted=np.sort(hgts)
yvals=np.arange(len(hts_sorted))/float(len(hts_sorted))
plt.xlabel("Height (m)")
plt.ylabel("Cummulative probability")
plt.plot(hts_sorted, yvals)
plt.show()
