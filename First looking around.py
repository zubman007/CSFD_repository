import sql_com
#movies_of_user(user_ID)
#users_of_movie
#rating_user_movie
#ratings_of_user



rating = sql_com.ratings_of_user(1)
print(len(rating))
print(rating[100])