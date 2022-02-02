import pyodbc

server = 'ZUBOVO\SQLEXPRESS'        #název serveru SQL
database = 'CSFD_ML'                # název databáze

#připojení na můj sql server
conn = pyodbc.connect(
        'DRIVER={ODBC Driver 17 for SQL Server};'
        'SERVER='+server+';'
        'DATABASE='+database+';'
        'Trusted_Connection=yes;')


def movies_of_user(user_ID):   # zjišťuje filmy daného uživatele
    exec_str='SELECT [movie]'+'\n'+' FROM [CSFD_ML].[dbo].[film_ratings]'+'\n'+'where [user_id]='+str(user_ID)
    cursor = conn.cursor()
    cursor.execute(exec_str)   
    output_sql = cursor.fetchall()
    return output_sql

def users_of_movie(movie_ID):   # zjišťuje filmy daného uživatele
    exec_str='SELECT [user_id]'+'\n'+' FROM [CSFD_ML].[dbo].[film_ratings]'+'\n'+'where [movie]='+str(movie_ID)
    cursor = conn.cursor()
    cursor.execute(exec_str)   
    output_sql = cursor.fetchall()
    return output_sql

def rating_user_movie(movie_ID,user_ID):   # zjišťuje filmy daného uživatele
    exec_str='SELECT top 1 [rating]'+'\n'+' FROM [CSFD_ML].[dbo].[film_ratings]'+'\n'+'where [movie]='+str(movie_ID)+' and [user_id]='+str(user_ID)
    cursor = conn.cursor()
    cursor.execute(exec_str)   
    output_sql = cursor.fetchall()
    return output_sql

def ratings_of_user(user_ID):   # zjišťuje filmy daného uživatele
    exec_str='SELECT [movie],'+'\n'+'   [rating]'+'\n'+' FROM [CSFD_ML].[dbo].[film_ratings]'+'\n'+'where [user_id]='+str(user_ID)
    cursor = conn.cursor()
    cursor.execute(exec_str)   
    output_sql = cursor.fetchall()
    return output_sql


