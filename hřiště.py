import numpy as np
import parameters as par
import time
import numpy_indexed as npi
import json
import classes
from datetime import date
from operator import itemgetter

users_rating = []
hodnoceni_x = []
hodnoceni_x.append(np.array([[14,44],[66,100],[68,44],[1897966,66],[1952122,44],[1997154,4]]))
hodnoceni_x.append(np.array([[10,40],[66,50],[68,60],[1876,20],[1922,44],[1997155,4]]))
aa = np.array([[10,40],[66,50],[68,60],[1876,20],[1922,44],[1997155,4]])
bb = np.array([[14,44],[66,100],[68,44],[1897966,66],[1952122,44/3],[1997154,4]])
PC = par.pocet_clusteru

json_export = []
ooo = [[14,44],[66,100],[68,44],[1897966,66],[1952122,44],[1997154,4]]

users_rating.append(classes.bod(1,aa,0))
users_rating.append(classes.bod(1,bb,0))
users_rating[0].a = 5
users_rating[1].a = 4




