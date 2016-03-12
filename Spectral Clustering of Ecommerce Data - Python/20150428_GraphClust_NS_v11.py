__author__ = 'Nitin'

import numpy
import shelve
import time
import h5py

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
    for k1, v1 in d.iteritems():
        i = map_file[k1] - 1
        for k2, v2 in v1.iteritems():
            j = map_file[k2] - 1
            adj[i,j] = sum(v2)
    print(time.time()-start)
    return(adj)

W = dict_iter(click_data, map_file)
print("check1")
# h5f = h5py.File('W_matrix.h5','w')
# print("check2")
# h5f.create_dataset('dataset_1', data=W)
# print("check3")

# start = time.time()
# for i in range(0,n):
#     temp = numpy.sum(W[:,i] + W[i,:])
#     W[i,:] = temp/2
#     W[:,i] = temp/2
# print(time.time()-start)


