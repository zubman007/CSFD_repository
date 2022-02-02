import pyodbc

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

def avg_rat_of_user_un(user_ID): # zjišťuje průměrné hodnocení daného uživatele v normalizované tabulce
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


