# Outer code for setting up the linear advection problem and calling the
# function to perform the linear advection
import pylab as pl

# all the linear advection schemes, diagnostics and initial conditions
execfile("advectionSchemes.py")
execfile("initialConditions.py")
execfile("moreAdvectionSchemes.py")
execfile("diagnostics.py")

# input variables
xmax = 1.0              # limits of the geometry
xmin = 0.0              # (must be real numbers, not integers)
nx = 100                # number of intervals to divide the geometry
nt = 100                # number of time steps
c = 2.1                 # Courant number for the advection
dx = (xmax - xmin)/nx   # spatial resolution
u = 1.0                 # wind speed
dt = c*dx/u             # time step
figurename = 'SemiLagrange1.pdf'
print 'time step: ',dt

# spatial points for plotting and for defining initial conditions
x = pl.linspace(xmin, xmax, nx+1)

# initial conditions
phiOld = mixed(x) #cosBell(x)#mixed(x)

# Exact solution is the same as the initial conditions but moved around
# the cyclic domain
phiExact = mixed((x - u*nt*dt)%(xmax - xmin)) 
#cosBell((x - u*nt*dt)%(xmax - xmin))#mixed((x - u*nt*dt)%(xmax - xmin))

# Call function for advecting the profile using FTBS and CTCS for nt time steps
phiFTBS = FTBS(phiOld.copy(), c, nt)
phiCTCS = CTCS(phiOld.copy(), c, nt)
#phiFTCS = FTCS(phiOld.copy(), c, nt)
phiLinearSL = linearSL(phiOld.copy(), c, nt)
phiCubicSL = cubicSL(phiOld.copy(), c, nt)

print phiCubicSL - phiLinearSL

#phiQuick = quick(phiOld.copy(), c, nt)
#phiVanLeer = TVD(phiOld.copy(), c, nt, vanLeer)

# plot options
font = {'size'   : 14}
pl.rc('font', **font)

# plot the results versus the analytic solution
pl.clf()
#pl.ylim(-0.1, 1.1)
#pl.plot(x, phiOld,      'k--', label='Initial')
pl.plot(x, phiExact,    'k', label='Exact')
#pl.plot(x, phiFTBS,     'r', label='FTBS')
#pl.plot(x, phiCTCS,     'b', label='CTCS')
#pl.plot(x, phiCTCS,     'g', label='FTCS')
pl.plot(x, phiCubicSL, 'b', label='Cubic SL')
pl.plot(x, phiLinearSL, 'r--', label='Linear SL')
#pl.plot(x, phiQuick,    'grey', label='QUICK')
#pl.plot(x, phiVanLeer,  'cyan', label='van Leer')
pl.legend(loc='best')
pl.xlabel('x')
pl.ylabel('$\phi$')
pl.savefig(figurename)
pl.show()

# calculate the error norms, mean and standard deviation of the fields
#FTBSerrors = errorNorms(phiFTBS, phiExact)
#CTCSerrors = errorNorms(phiCTCS, phiExact)
#FTCSerrors = errorNorms(phiCTCS, phiExact)
#print "FTBS l1, l2 and linf errors", FTBSerrors
#print "CTCS l1, l2 and linf errors", CTCSerrors
#print "FTCS l1, l2 and linf errors", CTCSerrors
#print "Initial mean and standard deviation", np.mean(phiOld[0:-2]), np.std(phiOld[0:-2])
#print "FTBS mean and standard deviation", np.mean(phiFTBS[0:-2]), np.std(phiFTBS[0:-2])
#print "CTCS mean and standard deviation", np.mean(phiCTCS[0:-2]), np.std(phiCTCS[0:-2])
#print "FTCS mean and standard deviation", np.mean(phiCTCS[0:-2]), np.std(phiCTCS[0:-2])


