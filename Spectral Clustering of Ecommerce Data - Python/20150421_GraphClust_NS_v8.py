__author__ = 'Nitin'

import numpy
import shelve


click_data = shelve.open("click_asso.shelve")

def dict_iter(d):
    key_list = d.keys()
    print(key_list)
    n = key_list.__len__()
    adj = numpy.zeros((n,n))
    for k1 in d.__iter__():
        # print(k1)
        # print(d.get(k1))
        i = key_list.index(k1)
        # print(i)
        for k2 in d.get(k1).__iter__():
            # print(d.get(k1).get(k2))
            j = key_list.index(k2)
            print("i = "+str(i)+"j = "+str(j))
            adj[i,j] = sum(d.get(k1).get(k2))
    return(adj)

adj = dict_iter(click_data)


