__author__ = 'Nitin'

# Trying to recode reading and feeding the data to the list in this code
# This code is different from the v4 in the sense that dictionary
# Learning how to iterate through a dictionary

# Creating a dictionary
a1 = [2,3,4,5,5]
a2 = [3,34,6,656]
# c = [1,2] - d is now a dictionary of dictionaries
b = dict()
c = dict()
d = dict()

b[5] = a2
b[8] = a1
c[6] = a1
c[2] = a2
d[10] = b
d[20] = c

for k in d.__iter__():
    print(k)
    print(d.get(k))
    print(d.get(k).keys())
    for l in d.get(k).__iter__():
        print(l)
        print(d.get(k).get(l))
        print(sum(d.get(k).get(l)))

