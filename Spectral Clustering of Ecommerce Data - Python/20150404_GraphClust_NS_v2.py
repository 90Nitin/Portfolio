__author__ = 'nsrivas3'

import shelve
import numpy
import scipy

# Loading the stored click data
# click_data = shelve.open("click_asso.shelve")

# C:\Users\nsrivas3\Dropbox\UIUC - Industrial Engineering\Thesis Research\RecSys\RecSys Data\Formatted data
# print(click_data.keys().__len__())

# Build 2 functions here 1. to create the adjacency matrix
# 2. To take the adjacency matrix and then create the clusters like we want

def dict_iter(diction):
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

# Learning how to iterate through a dictionary
a1 = [2,3,4,5,5]
a2 = [3,34,6,656]
# c = [1,2] - d is now a dictionary of dictionaries
b = dict()
c = dict()
d = dict()

b[1] = a2
b[2] = a1
c[1] = a1
c[2] = a2
d[1] = b
d[2] = c

adj = dict_iter(d)













