import pylab as pl

# plot the magnitude of the amplification factor for FTBS for c =0.2, 
# and range over k Dx = 0:pi

# a range of values of c
#c = pl.linspace(-1.5,1.5,31)

# set c
c = 0.2

#set kdx
kdx = pl.linspace(0.0,pl.pi,30)
# cosine kdx
coskdx = pl.cos(kdx)

#print coskdx

A = pl.zeros_like(coskdx)

# Calculate A^2 called magA
magA = 1.0 - 2.0*c*(1-c)*(1-coskdx) # pl.sqrt(complex(1,0) -c**2)

# plot the squared magnitudes
pl.clf()
font = {'size'   : 24}
pl.rc('font', **font)
pl.grid(True, which='both')
pl.plot(kdx, magA, 'k')#, label='positive root')
pl.legend(loc='best')
pl.title(c)
pl.xlabel('$k \Delta x$')
pl.ylabel('$||A||^2$')
pl.show()
pl.savefig('FTBS_stability_analsysis.pdf')

