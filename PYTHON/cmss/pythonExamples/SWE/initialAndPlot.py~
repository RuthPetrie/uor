import pylab as py
import numpy as np

def initialJet(nx, y, beta, g):
    "Calculate the initial conditions for the geostrophically balanced jet"
    "for h, u and v at nx x-locations and at locations y"
    
    # Initial jet parameters
    yc = 6e6          # Centre of jet
    jetw = 3e6        # Jet half width
    yS = yc - jetw    # Southern extent of the jet
    yN = yc - jetw    # Northern extent of the jet
    umax = 20.        # Maximum jet velocity

    # derived jet parameters
    yhat = (y - yc)/jetw
    hS = 16./35*jetw*beta*umax*yc/g  # southern h
    hN = -hS                     # northern h
    
    ny = len(y)
    
    # initialise u, v and h
    u = py.zeros([nx, ny])
    v = py.zeros([nx, ny])
    h = py.zeros([nx, ny])

    # jet velocity
    u[:,:] = py.where((abs(yhat) > 1), 0., \
             umax*(1 - 3*yhat**2 + 3*yhat**4 - yhat**6))

    # jet height
    h[:,:] = py.where((yhat < -1), hS, py.where((yhat > 1), hN, \
                hS - jetw*beta*umax/g*(\
             yc*(16./35+yhat-yhat**3+3./5*yhat**5-1./7*yhat**7)\
           + jetw*(-1./8+0.5*yhat**2-0.75*yhat**4+0.5*yhat**6-1./8*yhat**8))))

    return [h,u,v]


def createMountain(x, y):
    "create the mountain at locations x and y"
    nx = len(x)
    ny = len(y)
    h0 = py.zeros([nx,ny])
    
    return h0


def plothuv(xh, yh, xu, yu, xv, yv, h, h0, u, v):
    "plot the height and velocity for A- or C-grid variables"
    dx = xh[-1]-xh[-2]
    dy = yh[-1]-yh[-2]
    py.clf()
    py.ion()
    x = py.append(xh-0.5*dx, xh[-1]+0.5*dx)
    y = py.append(yh-0.5*dy, yh[-1]+0.5*dy)
    py.colorbar(py.pcolormesh(x, y, py.transpose(h+h0)))
    if (np.max(h0) > np.min(h0)):
        py.contour(xh, yh, py.transpose(h0))
    if (xh == xu).all():
        py.quiver(xu, yu, py.transpose(u), py.transpose(v), scale=1e3)
    else:
        py.quiver(xu, yu, py.transpose(u), py.transpose(vatu(v)), scale=1e3)
        py.quiver(xv, yv, py.transpose(uatv(u)), py.transpose(v), scale=1e3)
    py.axis([np.min(x), np.max(x), np.min(y), np.max(y)])
