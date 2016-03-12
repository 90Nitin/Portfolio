__author__ = 'Nitin'

import numpy
import shelve
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
    count = 1
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
        count += 1
        if count > 10000:
            break
    print(time.time()-start)

    return(adj)

adj = dict_iter(click_data, map_file)
