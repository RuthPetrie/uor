import pylab as py
import numpy as np

# Code for initialising, solving and plotting the SWE on a beta-plane using
#  forward-backward time-stepping on the A- and C-grid domain periodic in x,
# slip at y boundaries

execfile("ACgrids.py")
execfile("initialAndPlot.py")

# time-stepping parameters
nt = 144         # total number of time-steps
ntPlot = 144     # plot every ntPlot time-steps
dt = 600         # time-step (seconds)
# The domain
xmin = 0.
xmax = 1.2e7
ymin = 0.
ymax = 1.2e7
# number of points in the x and y directions
nx = 39
ny = 39
# model parameters
beta = 2e-11
g = 10.
H = 3000.

# grid-spacing
dx = (xmax - xmin)/nx
dy = (ymax - ymin)/ny
# x and y locations for the h positions
x = py.linspace(xmin + dx/2., xmax - dx/2., nx)
y = py.linspace(ymin + dy/2., ymax - dy/2., ny)
# x and y locations for the u positions (for the C-grid)
xu = py.linspace(xmin, xmax - dx, nx)
yu = py.linspace(ymin + dy/2., ymax - dy/2., ny)
# x and y locations for the v positions (for the C-grid)
xv = py.linspace(xmin + dx/2., xmax - dx/2., nx)
yv = py.linspace(ymin, ymax - dy, ny)

# Calculate the mountain height
h0 = createMountain(x, y)

# Initialise u, v and h (for the C-grid)
[hC, uC, vC] = initialJet(nx, y, beta, g)
# Initialise u, v and h (for the A-grid)
[hA, uA, vA] = initialJet(nx, y, beta, g)

# Subtract the mountain height
hC = hC - h0
hA = hA - h0

# Gravity wave and advective Courant number
Cu = dt*max(np.max(uC), np.max(vC))/min(dx,dy)
Cg = dt*py.sqrt(g*H)/min(dx,dy)
print 'Maximum advective Courant number ', Cu, \
      '\nmaximum gravity wave Courant number ', Cg

# plot the initial conditions
py.figure(1)
raw_input('C-grid initial conditions, press return to continue then close the plot window to continue')
plothuv(x, y, xu, yu, xv, yv, hC, h0, uC, vC)
py.figure(2)
raw_input('A-grid initial conditions, press return to continue then close the plot window to continue')
plothuv(x, y, x, y, x, y, hA, h0, uA, vA)

# solve the SWE using the A- and C-grids plotting every ntPlot
for it in range(0,nt,ntPlot):
    [uC,vC,hC] = SWE_Cgrid(beta, g, H, dx, yu, yv, dt, ntPlot, uC, vC, hC,h0)
    py.figure(1)
    raw_input("C-grid time step %d, press return to continue then close the plot window to continue" % (it+ntPlot))
    plothuv(x, y, xu,yu, xv, yv, hC, h0, uC, vC)
    
    [uA,vA,hA] = SWE_Agrid(beta, g, H, dx, y, dt, ntPlot, uA, vA, hA, h0)
    py.figure(2)
    raw_input("A-grid time step %d, press return to continue then close the plot window to continue" % (it+ntPlot))
    plothuv(x, y, x,y, x, y, hA, h0, uA, vA)

