import pylab as pl

# plot the magnitude of the amplification factor for CTCS for k Dx = pi/2

# a range of values of c
c = pl.linspace(-1.5,1.5,31)

# two roots of the amplification factor (1j = sqrt(-1) = complex(0,1))
A1 = -1j*c + pl.sqrt(complex(1,0)-c**2)
A2 = -1j*c - pl.sqrt(complex(1,0)-c**2)

# the magnitude squared of each of the amplification factors
mag2A1 = A1*pl.conj(A1)
mag2A2 = A2*pl.conj(A2)

# plot the squared magnitudes
pl.clf()
font = {'size'   : 24}
pl.rc('font', **font)
pl.grid(True, which='both')
pl.plot(c, mag2A1, 'b', label='positive root')
pl.plot(c, mag2A2, 'r', label='negative root')
pl.legend(loc='best')
pl.xlabel('Courant number, $c$')
pl.ylabel('$||A||^2$')
pl.show()
pl.savefig('CTCSA.pdf')

