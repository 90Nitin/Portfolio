__author__ = 'nsrivas3'
# importing numpy and pandas to access the data structures
import numpy
import scipy
from sklearn import cluster
from scipy import linalg

# Importing the dataset
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
eigval,eigvec = scipy.linalg.eigh(L)

# Storing the number of clusters to be created in the graph
K = input("Number of clusters to be created: ")
K = int(K)
eigvec = eigvec[:,0:K]
print(eigval)
print(eigvec)
k_means = cluster.KMeans(init = 'k-means++', n_clusters = K, n_init = 10, max_iter = 300,tol = 1e-4)
k_means.fit(eigvec)
predict = k_means.fit_predict(eigvec)

