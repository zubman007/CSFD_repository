CREATE PROCEDURE Normalization_of_all_users_ratings
AS

DECLARE @cnt INT = 1;
DECLARE @cnt_total INT = 0;
DECLARE @user_id INT = 0;

SELECT @cnt_total = count(1)
FROM [CSFD_ML].[dbo].[users]

WHILE @cnt < @cnt_total+1
BEGIN
	SELECT @user_id = foo.[user_id] 
	FROM (
	  SELECT
		ROW_NUMBER() OVER (ORDER BY [user_id] ASC) AS rownumber,
		[user_id]
	  FROM [CSFD_ML].[dbo].[users]
	) AS foo
	WHERE rownumber <= @cnt;

   exec Normalization_of_users_ratings @userid=@user_id
   print(@user_id);
   SET @cnt = @cnt + 1;
END;