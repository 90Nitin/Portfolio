__author__ = 'Nitin'

import numpy
import shelve
from scipy import linalg
from sklearn import cluster
import time

# Importing the dataset into the
click_data = shelve.open("click_asso.shelve")
# Creating a dictionary of the indexes of the products
n = click_data.keys().__len__()
map_file = dict(zip(click_data.keys(),numpy.linspace(1,n,n)))
print(click_data.keys().__len__())

def dict_iter(d, map_file):
    start = time.time()
    # Pass the dictionary and a file that gives the exact sequence of all the keys wrt each other
    # key_list = d.keys()
    # print(key_list)
    adj = numpy.zeros((n,n))
    count_non_zero = 1
    for k1, v1 in d.iteritems():
        # print(k1)
        # print(d.get(k1))
        i = map_file[k1] - 1
        # print(i)
        for k2, v2 in v1.iteritems():
            # print(d.get(k1).get(k2))
            j = map_file[k2] - 1
            # print("i = "+str(i)+"j = "+str(j))
            adj[i,j] = sum(v2)
            if adj[i,j]!=0:
                count_non_zero += 1
        # if count > 10000:
        #     break
    print(time.time()-start)
    print(count_non_zero)
    return(adj)

adj = dict_iter(click_data, map_file)
# adj is a very sparse matrix, this means that adj-1 is going to be a very dense matrix less than 0.5% entries are full
# I dont need that in my life right now

# Calculating the #rows = #cols in the ad. matrix
nrow = adj.shape[1]

# Computing the Diagonal of the Ad. Matrix
D = numpy.zeros((nrow,nrow))
for i in range(0,nrow):
   D[i][i] = sum(adj[i])

# Define the LapLacian of the graph Adj matrix
L = numpy.linalg.solve(D,(D - adj))

# Use the scipy eigen value solver since it loads the eigenvalues in ascending order
eigval,eigvec = scipy.linalg.eigh(L)

# Storing the number of clusters to be created in the graph
K = input("Number of clusters to be created: ")
K = int(K)
eigvec = eigvec[:,0:K]
k_means = cluster.KMeans(init = 'k-means++', n_clusters = K, n_init = 10, max_iter = 300,tol = 1e-4)
k_means.fit(eigvec)
clust_predict = k_means.fit_predict(eigvec)