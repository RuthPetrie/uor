# -*- coding: utf-8 -*-
"""
Spyder Editor

This temporary script file is located here:
C:\Users\qv903917\.spyder2\.temp.py
"""

# Some code to get you started : 


# Reading in a csv file
#--------------------------
import matplotlib as plt
import scipy.stats as sps
import numpy as np

temps = np.genfromtxt("temps_0910.csv", delimiter=",",skip_header=1)
