import matplotlib.pyplot as plt
import numpy as np
import scipy.stats as sp

x=np.arange(13)
heights=[185, 173, 180,178,170,182,178,175,181,175,197,168,172]
hgts=np.array(heights)

plt.hist(heights,bins=[165, 169, 173, 177, 181, 185, 189,194,197])
plt.title("Box Plot")
yint = range(min(y), math.ceil(max(y))+1)
plt.yticks(yint)
plt.xlabel("Heights (cm)")
plt.ylabel("Frequency")
 yticks( arange(4), ('0', '1', '2', '3', '4') )  
#plt.show()
