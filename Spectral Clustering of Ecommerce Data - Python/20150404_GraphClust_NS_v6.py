__author__ = 'Nitin'

import numpy
# import scipy
import shelve
# Trying to recode reading and feeding the data to the list in this code
# This code is different from the v4 in the sense that dictionary
# Learning how to iterate through a dictionary

click_data = shelve.open("click_asso.shelve")

def dict_iter(d):
    n = d.keys().__len__()
    adj = numpy.zeros((n,n))
    i = 0
    for k in d.__iter__():
        print(k)
        print(d.get(k))
        print(d.get(k).keys())
        j = 0
        for l in d.get(k).__iter__():
            adj[i,j] = sum(d.get(k).get(l))
            print(l)
            print(d.get(k).get(l))
            j = j + 1
        i = i + 1
    return(adj)

adj = dict_iter(click_data)

# Saving the obtained dataset using pytables
