import pyodbc
from operator import itemgetter
import parameters as par

server = 'ZUBOVO\SQLEXPRESS'        #název serveru SQL
database = 'CSFD_ML'                # název databáze

#připojení na můj sql server
conn = pyodbc.connect(
        'DRIVER={ODBC Driver 17 for SQL Server};'
        'SERVER='+server+';'
        'DATABASE='+database+';'
        'Trusted_Connection=yes;')

def movs_of_user(user_ID):   # zjišťuje filmy daného uživatele 
    exec_str='SELECT [movie]'+'\n'+' FROM [CSFD_ML].[dbo].[film_ratings]'+'\n'+'where [user_id]='+str(user_ID)
    cursor = conn.cursor()
    cursor.execute(exec_str)   
    output_sql = cursor.fetchall()
    return output_sql

def users_of_mov(movie_ID): # zjišťuje uživatele daného filmu
    exec_str='SELECT [user_id]'+'\n'+' FROM [CSFD_ML].[dbo].[film_ratings]'+'\n'+'where [movie]='+str(movie_ID)
    cursor = conn.cursor()
    cursor.execute(exec_str)   
    output_sql = cursor.fetchall()
    return output_sql

def rat_user_mov_un(movie_ID,user_ID): # zjišťuje hodnocení daného uživatele a filmu v nenormalizované tabulce
    exec_str='SELECT top 1 [rating]'+'\n'+' FROM [CSFD_ML].[dbo].[film_ratings]'+'\n'+'where [movie]='+str(movie_ID)+' and [user_id]='+str(user_ID)
    cursor = conn.cursor()
    cursor.execute(exec_str)   
    output_sql = cursor.fetchall()
    return output_sql

def rats_of_user_un(user_ID): # zjišťuje všechna hodnocení daného uživatele v nenormalizované tabulce
    exec_str='SELECT [movie],'+'\n'+'   [rating]'+'\n'+' FROM [CSFD_ML].[dbo].[film_ratings]'+'\n'+'where [user_id]='+str(user_ID)
    cursor = conn.cursor()
    cursor.execute(exec_str)   
    output_sql = cursor.fetchall()
    return output_sql

def dist_of_rats_of_user_un(user_ID): #zjišťuje distribuci hodnocení daného uživatele v nenormalizované tabulce
    exec_str='select sum(rat.rat_0) as rat_0,'+'\n'+'		sum(rat.rat_20) as rat_20,'+'\n'+'		sum(rat.rat_40) as rat_40,'+'\n'+'		sum(rat.rat_60) as rat_60,'+'\n'+'		sum(rat.rat_80) as rat_80,'+'\n'+'		sum(rat.rat_100) as rat_100'+'\n'+'from'+'\n'+'(SELECT case when fr.[rating]=0 then 1 else 0 end as rat_0,'+'\n'+'	   case when fr.[rating]=20 then 1 else 0 end as rat_20,'+'\n'+'	   case when fr.[rating]=40 then 1 else 0 end as rat_40,'+'\n'+'	   case when fr.[rating]=60 then 1 else 0 end as rat_60,'+'\n'+'	   case when fr.[rating]=80 then 1 else 0 end as rat_80,'+'\n'+'	   case when fr.[rating]=100 then 1 else 0 end as rat_100'+'\n'+'  FROM [CSFD_ML].[dbo].[film_ratings] as fr'+'\n'+'  where [user_id]= '+str(user_ID)+' ) as rat'
    cursor = conn.cursor()
    cursor.execute(exec_str)   
    output_sql = cursor.fetchall()
    return output_sql

def avg_rat_of_user_un(user_ID): # zjišťuje průměrné hodnocení daného uživatele v nenormalizované tabulce
    exec_str='SELECT avg([rating])'+'\n'+'  FROM [CSFD_ML].[dbo].[film_ratings]'+'\n'+'  where [user_id]='+str(user_ID)
    cursor = conn.cursor()
    cursor.execute(exec_str)   
    output_sql = cursor.fetchall()
    return output_sql

def rat_user_mov_n(movie_ID,user_ID): # zjišťuje hodnocení daného uživatele a filmu v normalizované tabulce  
    exec_str='SELECT top 1 [rating]'+'\n'+' FROM [CSFD_ML].[dbo].[film_ratings_normalized]'+'\n'+'where [movie]='+str(movie_ID)+' and [user_id]='+str(user_ID)
    cursor = conn.cursor()
    cursor.execute(exec_str)   
    output_sql = cursor.fetchall()
    return output_sql

def rats_of_user_n(user_ID):  # zjišťuje všechna hodnocení daného uživatele v normalizované tabulce
    exec_str='SELECT [movie],'+'\n'+'   [rating]'+'\n'+' FROM [CSFD_ML].[dbo].[film_ratings_normalized]'+'\n'+'where [user_id]='+str(user_ID)
    cursor = conn.cursor()
    cursor.execute(exec_str)   
    output_sql = cursor.fetchall()
    return output_sql

def avg_rat_of_user_n(user_ID): # zjišťuje průměrné hodnocení daného uživatele v normalizované tabulce
    exec_str='SELECT avg([rating])'+'\n'+'  FROM [CSFD_ML].[dbo].[film_ratings_normalized]'+'\n'+'  where [user_id]='+str(user_ID)
    cursor = conn.cursor()
    cursor.execute(exec_str)   
    output_sql = cursor.fetchall()
    return output_sql

def vraceni_filmu_jakzto_n_prostoru(omezeni): # vrací všechny filmy, které mají více ne omezeni-krat hodnocení 
    exec_str='select [movie]'+'\n'+'from ('+'\n'+'SELECT  [movie],'+'\n'+'		count([movie]) as countmovie'+'\n'+'FROM [CSFD_ML].[dbo].[film_ratings_normalized]'+'\n'+'group by [movie] ) as aa'+'\n'+'where aa.countmovie > '+str(omezeni)+'\n'+'order by [movie]'
    cursor = conn.cursor()
    cursor.execute(exec_str)   
    output_sql = cursor.fetchall()
    return output_sql

def all_users(): # vrací všechny uživatele
    exec_str='SELECT [user_id]'+'\n'+'FROM [CSFD_ML].[dbo].[users]'
    cursor = conn.cursor()
    cursor.execute(exec_str)   
    output_sql = cursor.fetchall()
    au = []
    for x in output_sql:
        au.append(x[0])
    return au


def rating_of_user_v_prostoru_filmu(rozsah,user): # zjišťuje průměrné hodnocení daného uživatele v normalizované tabulce
    exec_str='select [movie],[rating]'+'\n'+'from [CSFD_ML].[dbo].[film_ratings_normalized]'+'\n'+'where [movie] in'+ rozsah+' and [user_id] = ' + str(user)
    cursor = conn.cursor()
    cursor.execute(exec_str)   
    output_sql = cursor.fetchall()
    return output_sql

def get_all_ratings_in_span(rozsah):
    exec_str = 'select [user_id],[movie],[rating]'+'\n'+'from [CSFD_ML].[dbo].[film_ratings_normalized]'+'\n'+'where [movie] in'+ rozsah
    cursor = conn.cursor()
    cursor.execute(exec_str)   
    output_sql = cursor.fetchall()
    return output_sql


def get_all_ratings_in_span(rozsah):
    exec_str = 'select [user_id],[movie],[rating]'+'\n'+'from [CSFD_ML].[dbo].[film_ratings_normalized]'+'\n'+'where [movie] in'+ rozsah
    cursor = conn.cursor()
    cursor.execute(exec_str)   
    output_sql = cursor.fetchall()
    return output_sql

def save_cluster_distribuci(distr):
    distr = sorted(distr, key=itemgetter(1))
    exec_str = 'INSERT INTO [CSFD_ML].[dbo].[clusters_30]'+'\n'+'([MWp],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],[29],[30],[InsertDateTime])'+'\n'+'VALUES'+'('+'\n'+str(par.Marsellus_Wallace_Parametr)+','+'\n'
    for i in distr:
        exec_str = exec_str + str(i[1]) +',' + '\n'
    exec_str = exec_str + 'getUTCDate()'+'\n'+')'#+'\n'+'GO'
    cursor = conn.cursor()
    cursor.execute(exec_str)   
    cursor.commit()









