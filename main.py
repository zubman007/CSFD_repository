import sql_com
import time
import json
import parameters as par
import random
import classes
import numpy as np


pocet_clusteru = par.pocet_clusteru

#Načtení dat
f = open('data.json')
data = json.load(f)
all_users = sql_com.all_users()

used_users = []
stredy = []
users_rating = []
i = 1

#Uložení dat do třídy BOD
for x in data:
    users_rating.append(classes.bod(x[0],x[1],0))

#Vytvoření initial náhodných clusterů
for x in range(pocet_clusteru):
    random_choice = random.choice(users_rating)
    while used_users.count(random_choice.id) > 0 :
        random_choice = random.choice(users_rating)
    stredy.append(random_choice)
    used_users.append(stredy[-1].id)

for x in stredy:  
    x.id  = i
    x.typ = 1
    i    += 1


#Hlavní kód
for i in range(par.max_pocet_iteraci):
    start = time.time()
    #print("\n")
    #print(str(i)+"-tá ITERACE")
    #print("__________________")

    zmena = 0
    for x in users_rating:      #Hledání středu, od kterého má uživatel nejmenší vzdálenost
        nej = np.zeros(shape=(0,2))
        for y in stredy:
            nej = np.append(nej, [[y.id,classes.r_gibs(x.hodnoceni,y.hodnoceni)]], 0)
        novy_cluster = np.where(nej[:,1] == min(nej[:,1]))[0][0] + 1
        if novy_cluster != x.a : zmena = zmena + 1
        x.a = novy_cluster
    stredy = classes.prumer(users_rating)           #Průměrování nových středů

    end = time.time()
    print("Doba "+str(i)+"-té iterace: " + str(round(end - start,8)))

    if zmena == 0 : break       #Pokud žádný uživatel nezměnil cluster alg. musí končit. Dál se neposouvá



sql_com.save_cluster_distribuci(classes.clust_dist(users_rating))

start = time.time()
classes.export_reseni(users_rating,stredy)
end = time.time()
print("Doba exportu: " + str(round(end - start,8)))













