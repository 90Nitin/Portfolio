__author__ = 'nsrivas3'

import time
from scipy import sparse
from scipy.sparse import csr_matrix
from scipy.sparse import linalg
from scipy.sparse import csgraph
from sklearn.cluster import KMeans
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

# 1. Importing the click dataset into the memory
click_data = shelve.open("click_asso.shelve")
print("check2")

# 2. Importing the product mapping dataset into the memory
product_idx = shelve.open("product_index.shelve")
print("check3")

# 3. Creating a symmetric graph adjacency matrix from the dataset
W = get_adj_mat(click_data, product_idx)
print("check4")

# 4. Creating the diagonal matrix of the adjacency matrix
n = W.shape[1]
D = csr_matrix((n, n))
print("check5")
temp = csr_matrix((n,1))
temp = W.sum(axis = 1)
for i in range(0,n):
    if (temp[i]!=0):
        D[i,i] = temp[i]
    else:
        D[i,i] = 10**-6
print("check6")
# 5. Defining and Declaring the un-normalized Laplacian
L = csgraph.laplacian(W,normed=False)
print("check7")
# 6. Choose number of clusters to create
K = input("Choose number of clusters to create")
eigvals,eigvecs = linalg.eigsh(L,k=K,M=D,which='SM')
print("check8")
# 7. Clustering the Dataset
kmeans_obj = KMeans(init="k-means++",n_clusters=K,n_init=10,precompute_distances=True,n_jobs=-1)
a = kmeans_obj.fit_predict(X=L)
print("check9")

