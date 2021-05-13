import numpy as np
import pylab as pl


def errorNorms(phi, phiExact):
    "Calculates the l1, l2 and linfinity error norms of phi in comparison to"
    "phiExact"
    
    #remove the wrap-around points
    phi = phi[0:-2]
    phiExact = phiExact[0:-2]
    
    # calculate the error and the error norms
    phiError = phi - phiExact
    l1 = sum(np.abs(phiError))/sum(np.abs(phiExact))
    l2 = sum(phiError**2)/sum(phiExact**2)
    linf = np.max(np.abs(phiError))

    return [l1,l2,linf]


def fourierPower(signal):
    "Calculates the Fourier power spectrum of the signal"
    
    A = pl.fft(signal)
    n = (len(signal)+1)/2
    power = pl.zeros(n)  #+1)
    #power[0] = A[0].real**2
    #for i in range(1,n+1):
    for i in range(n):
        power[i] = 4*(A[i+1].real**2 + A[i+1].imag**2)
    return power

