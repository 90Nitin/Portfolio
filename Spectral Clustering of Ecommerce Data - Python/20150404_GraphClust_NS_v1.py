__author__ = 'nsrivas3'
#importing numpy and pandas to access the data structures
import numpy

click_data = numpy.genfromtxt('samplegraph.csv',delimiter = ',')
print(click_data)
# Calculating the #rows = #cols in the ad. matrix
nrow = click_data.shape[1]

# Computing the Diagonal of the Ad. Matrix
D = numpy.zeros((nrow,nrow))
for i in range(0,nrow):
   D[i][i] = sum(click_data[i])

# Define the LapLacian of the graph Ad matrix
L = (numpy.linalg.inv(D))*(D - click_data)
# Use the scipy eigen value solver since it loads the eigenvalues in ascending order
eigval,eigv = numpy.linalg.eigh(L)
# Storing the number of clusters to be created in the graph
K = 3;

print(eigval)
print(eigv)
