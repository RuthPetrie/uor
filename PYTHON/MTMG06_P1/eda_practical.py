# It is good coding practice to write a short description 
# at the top of your code that describes what the code does
# 
# Example
#
# Practical one sample code
# by Ruth Petrie Jan 2015
###############################################################

# import statements
import matplotlib.pylab as plt
import numpy as np
import scipy.stats as sps

# Read data
temps = np.genfromtxt("temps_0910.csv", delimiter=",",skip_header=1)

# Assign separate array for Tdry
tdryo = temps[:,1] # tdryo is the original tdry data array

# Use describe from scipy stats
print sps.describe(tdryo)

# Returns NaNs as one element is a NaN - Not a Number

# Reassign array to tdryn without NaNs for simplicity for this excercise
tdryn = tdryo[np.isfinite(tdryo)]

# Use describe again
print sps.describe(tdryn)

# Returns
# array size = 729
# (min, max) = -6.099, 25.0)
# mean = 10.24
# variance = 42.78
# skewness = -0.29
# kurtosis = -0.78

# Calculate the standard deviation
print np.std(tdryn)

###########################
# Plotting the data
###########################

# Make a boxplot of Tdry
#--------------------------
print 'plotting boxplot'
plt.boxplot(tdryn)
plt.ylim([-10,30])
plt.ylabel('Heights(cm)')
plt.xticks([1], ['Tdry'])
plt.title('Boxplot of Tdry')
plt.savefig("boxplot.png")

# You can also use
# plt.show()


# Make a histogram of Tdry
#--------------------------

# 1 degree temperature bin size
bins1=np.linspace(-10,30,41)

# Make the plot
print 'plotting histogram'
plt.hist(tdryn,bins=bins1)
plt.ylabel=('Frequency')
plt.xlabel=('Temperature (Deg C)')
plt.title('Histogram of Tdry with 1 Deg bins')
plt.savefig("hist_1.png")

# Plot Cumulative distribution functions with 50 bins
# Note here 50 is the number of bins not the bin size as in the previous plot
#------------------------------------------------------------------------------

# define number of bins
nbins=50

plt.hist(tdryn, nbins, normed=1,histtype='step', cumulative=True)
plt.ylabel('Cumulative probability')
plt.ylim([0.0,1.0])
plt.xlabel('Temperature (Deg C)')
plt.title('Cummulative distribution function of Tdry')
plt.savefig("ecdf_50.png")


# Calculate the empirical probability that Tdry is greater than 5 degrees
#------------------------------------------------------------------------

# Sort the data into order
tdry_sorted=np.sort(tdryn)

# Find the rank of 5 in the sorted data, this is just one example of how you can do this

# find where the elements of the sorted data are equal to 5
tdry_x=np.where(tdry_sorted==5)

# make an array of ranked data
tdry_sort_rank=sps.rankdata(tdry_sorted)

# find the rank of 5 deg
rank_tdry=tdry_sort_rank[tdry_x]
print rank_tdry

# the rank of 5 will always be the same, regardless of how many elements are 5!

# what is the empirical probability that the temperature is greater than 5?
e_p=(1-(rank_tdry[0]/(np.size(tdryn)+1)))*100
print e_p

# ADDITIONAL EXERCISE
# Note this calculation is more complicated so this could be made into a function so you 
# can calculate the empirical probability for any value 
# functions must be declared at the top of your program 

# this is the function to be placed at the top of your code
# uncomment every line, some lines have two comments, leave the second comments in


#def ep(data,val):
#  data_sorted=np.sort(data)
#  data_x=np.where(tdry_sorted==val)
#  data_ranked=sps.rankdata(data_sorted)
#  rank_val=data_ranked[data_x]
#  ep=(1-(rank_val[0]/(np.size(data)+1)))*100
#  print 'empirical probability is: ',ep
#  # if you want to pass the empirical probability back to the main program use the following line
#  return(ep)
#  # else python will just return none
#  # in this case we have just printed the value in the function


# now call the function with the following line (uncomment it first!)
#ep(tdryn,5)

# try different values by changing 5 to a different temperature
# using functions means that you can make your code much simpler
# it would be even better if you define a variable rather than "hard coding" the number
# using variable names makes it easier to read the code!
#
#
# for example:
# 
# value_to_find_ep_of=5    - perhaps you can think of a better name!!
# ep(tdryn,value_to_find_ep_of) 




 


