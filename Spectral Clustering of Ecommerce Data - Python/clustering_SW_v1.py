__author__ = 'swang157'
import time
from scipy import sparse
import shelve


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
    return adj+adj.transpose()

# Importing the dataset into the
click_data = shelve.open("click_asso.shelve")
product_idx = shelve.open("product_index.shelve")
W = get_adj_mat(click_data, product_idx)