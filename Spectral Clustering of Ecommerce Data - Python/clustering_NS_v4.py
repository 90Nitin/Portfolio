__author__ = 'nsrivas3'

import time
from scipy import sparse
from scipy.sparse import csr_matrix
from scipy.sparse import linalg
from scipy.sparse import csgraph
from sklearn.cluster import KMeans
import shelve

print("check1")

def new_adj_mat(weight_dict, product_map):
    start = time.time()
    n = len(product_map.keys())
    adj = sparse.dok_matrix((n, n))
    counter = 0
    for k1, v1 in product_map.iteritems():
        i = v1
        counter = counter + 1
        for k2, v2 in weight_dict[k1].iteritems():
            j = product_map[k2]
            # print("I: = "+str(i)+" J: = "+str(j))
            adj[i, j] = len(v2)
    print(time.time()-start)
    return(adj+adj.transpose())

# 1. Importing the click dataset into the memory
click_data = shelve.open("click_asso.shelve")
print("check2")

# 2. Importing the product mapping dataset into the memory
product_idx = shelve.open("product_final_idx.shelve")
print("check3")

# 3. Creating a symmetric graph adjacency matrix from the dataset
W = new_adj_mat(click_data, product_idx)
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

# 6. Choose number of clusters to create and producing a dictionary to store the clusters
clust_dict = {}
K_val = [5,10,15,25,50]
K_max = max(K_val)
eigvals,eigvecs = linalg.eigs(L,k=K_max,M=D,which='SM')
eigvecs = eigvecs[:,eigvals.argsort()]
print("check8")
for k in K_val:
    # 7. Clustering the Dataset

    kmeans_obj = KMeans(init='random',n_clusters=k,n_init=10,precompute_distances=True,n_jobs=-1)
    clust_dict[str(k)] = kmeans_obj.fit_predict(X=eigvecs[:,0:k])
print("check9")

# 8. Storing the results in a shelve file- DO NOT RUN THIS OVER AND OVER SINCE IT APPENDS DATA
myShelve = shelve.open('dict_clust.shelve')
myShelve.update(clust_dict)
myShelve.close()