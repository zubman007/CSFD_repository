import sql_com
import time
import json
import parameters as par

omezeni = par.omezeni
start = time.time()
prostor_filmu = sql_com.vraceni_filmu_jakzto_n_prostoru(omezeni)
all_users = sql_com.all_users()
pocet_useru = len(all_users)
a = 0
string_filmu_v_prostoru = "("
for x in prostor_filmu:
    string_filmu_v_prostoru = string_filmu_v_prostoru + str(x[0]) +","
    a = a + 1
string_filmu_v_prostoru = string_filmu_v_prostoru + "0)"
data = []
data_1 = sql_com.get_all_ratings_in_span(string_filmu_v_prostoru)
p = 0
for x in all_users:
    hodnoceni = []
    rat = list(filter(lambda c: c[0] == x[0], data_1))
    for y in rat:
        hodnoceni.append([y[1],y[2]])
    data.append([x[0],hodnoceni])
    p = p + 1
    print(p)

with open('personal.json', 'w') as json_file:
    json.dump(data, json_file)

end = time.time()
print(round(end - start,2))