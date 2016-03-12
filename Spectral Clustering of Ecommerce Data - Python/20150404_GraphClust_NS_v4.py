__author__ = 'nsrivas3'

import numpy
import scipy
from scipy import linalg
from sklearn import cluster
import shelve

# Loading the stored click data
click_data = shelve.open("click_asso.shelve")

def dict_iter(diction):
    # Dict_iter creates a adjacency matrix out of the click_data dict
    # Let diction be a input dictionary of dictionaries
    # The number of elements to the dictionary shall be the number of keys in the dict
    n = diction.keys().__len__()
    adj = numpy.zeros((n,n))
    for i in range(0,n):
        for j in range(0,diction[i+1].__len__()):
            adj[i,j] = sum(diction[i+1][j+1])
            print("primary key val = "+str(diction[i+1])+"secondary key val = "+str(diction[i+1][j+1]))
            print(diction[i+1][j+1])
            print(sum(diction[i+1][j+1]))

    return(adj)

adj = dict_iter(click_data)

# Calculating the #rows = #cols in the ad. matrix
nrow = adj.shape[1]

# Computing the Diagonal of the Ad. Matrix
D = numpy.zeros((nrow,nrow))
for i in range(0,nrow):
   D[i][i] = sum(adj[i])

# Define the LapLacian of the graph Ad matrix
L = (numpy.linalg.inv(D))*(D - adj)

# Use the scipy eigen value solver since it loads the eigenvalues in ascending order
eigval,eigvec = scipy.linalg.eigh(L)

# Storing the number of clusters to be created in the graph
K = input("Number of clusters to be created: ")
K = int(K)
eigvec = eigvec[:,0:K]
k_means = cluster.KMeans(init = 'k-means++', n_clusters = K, n_init = 10, max_iter = 300,tol = 1e-4)
k_means.fit(eigvec)
clust_predict = k_means.fit_predict(eigvec)


