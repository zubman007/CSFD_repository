import numpy as np
import parameters as par
import functools
import numpy_indexed as npi
import json
from datetime import date



class bod:  
    def __init__(self, id, hodnoceni, typ):
        self.id = id
        self.hodnoceni =  np.array(hodnoceni) 
        self.typ = typ  #typ 0 jsou uživatele, typ 1 jsou středy clusterů
        self.a = 0
        self.b = 0



def clust_dist(uzi):   # zjišťuje rozdělení počtu uživatelů v jednotlivých clusterech
    stat_clusteru = []
    for i in range(1,par.pocet_clusteru+1):
        uzi = np.array(uzi)
        stat_clusteru.append([i,0])
        for x in uzi:
            if x.a == i : stat_clusteru[i-1][1] = stat_clusteru[i-1][1] + 1
    return stat_clusteru



def r_gibs(A,B):   # zjišťuje vzdalenost dvou bodů v prostoru
    I = functools.reduce(
        lambda l,r: np.intersect1d(l,r,True),
        (i[:,0] for i in (A,B)))
    A_in = A[np.searchsorted(A[:,0], I)]
    B_in = B[np.searchsorted(B[:,0], I)]
    S_N = len(B_in[:,0])
    if S_N != 0:
        G = (sum(abs(A_in[:,1] - B_in[:,1])))/S_N
        H = par.Marsellus_Wallace_Parametr*(((len(B)-S_N)/len(B))+((len(A)-S_N)/len(A)))
    else:
        G = 0
        H = par.Marsellus_Wallace_Parametr*2
    D = G + H
    return D



def prumer(uzi):   # počítá nový prumer všech středů, klasický průměr
    stredy= []
    cc = np.zeros(shape=(0,2))
    for i in range(1,par.pocet_clusteru + 1): # projíždí se clustery 
        cc = np.array([[0,0]])
        for x in uzi:   
            if x.a == i: #tady se to bude dělat pouze pro daný cluster
                cc = np.append(cc,x.hodnoceni, axis = 0)
        stredy.append(bod(i,np.transpose(npi.group_by(cc[:,0]).mean(cc[:,1])),1))
    return stredy



def export_reseni(uzi,stredy):
    stredy_export = []
    uzivatele_export = []
    nazev_2 = 'stredy_'+ str(date.today())
    nazev_1 = 'uzivatele_reseni_'+ str(date.today())
    for i in stredy:   
        stredy_export.append([ i.id, i.hodnoceni.tolist()])
    for i in uzi:   
        uzivatele_export.append([ i.id, i.a , i.hodnoceni.tolist()])
    with open(nazev_1, 'w') as json_file:
        json.dump(uzivatele_export, json_file)
    with open(nazev_2, 'w') as json_file:
        json.dump(stredy_export, json_file)



