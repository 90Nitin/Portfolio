__author__ = 'nsrivas3'


import time
import numpy
from scipy import sparse
from scipy.sparse import csr_matrix
from scipy.sparse import linalg
import shelve

print("check1")

def get_adj_mat(weight_dict, product_idx):
    start = time.time()
    n = len(product_idx.keys())
    adj = sparse.dok_matrix((n, n))
    for k1, v1 in weight_dict.iteritems():
        i = product_idx[k1]
        for k2, v2 in v1.iteritems():
            j = product_idx[k2]
            adj[i, j] = len(v2)
    print(time.time()-start)
    return(adj+adj.transpose())


# Importing the dataset into the memory
click_data = shelve.open("click_asso.shelve")
print("check2")
product_idx = shelve.open("product_index.shelve")
print("check3")
# Creating a symmetric graph adjacency matrix from the dataset
W = get_adj_mat(click_data, product_idx)
print("check4")
# Creating the diagonal matrix of the adjacency matrix
n = W.shape[1]
D = csr_matrix((n, n))
print("check5")
temp = csr_matrix((n,1))
temp = W.sum(axis = 1)
for i in range(0,n):
    # Calculating the degree of the matrix for the graph
    if (temp[i]!=0):
        D[i,i] = temp[i]
    else:
        D[i,i] = 10**-6
print("check6")
L = sparse.dok_matrix((n, n))
L = D - W
# Choose number of clusters to create
K = input("Choose number of clusters to create")
eigvals,eigvecs = linalg.eigs(L,k=K,M=D,sigma=None,which='SM')
# Clustering the Dataset