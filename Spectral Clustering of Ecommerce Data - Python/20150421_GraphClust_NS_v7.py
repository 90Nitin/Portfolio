__author__ = 'Nitin'

import numpy
# import scipy
import shelve

# Creating a dictionary
a1 = [2,3,4,5,5]
a2 = [3,34,6,656]
# c = [1,2] - d is now a dictionary of dictionaries
b = dict()
c = dict()
d = dict()
a = dict()

a[20] = a1
a[10] = a2
c[10] = a1
# c[2] = a2
d[20] = c
d[10] = b
d[30] = a
b[20] = a2
# b[8] = a1

key_list = d.keys()
n = key_list.__len__()
adj = numpy.zeros((n,n))
for k1 in d.__iter__():
    print(k1)
    print(d.get(k1))
    for k2 in d.get(k1).__iter__():
        print(d.get(k1).get(k2))
        i = key_list.index(k1)
        j = key_list.index(k2)
        print(i)
        print(j)
        adj[i,j] = sum(d.get(k1).get(k2))