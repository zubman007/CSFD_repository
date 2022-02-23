CREATE PROCEDURE [dbo].[Normalization_phase_2]
AS

DECLARE @cnt INT = 1;
DECLARE @cnt_total INT = 0;
DECLARE @user_id INT = 0;
DECLARE @updatetime datetime2 = getutcdate();

SELECT @cnt_total = count(1)
FROM [CSFD_ML].[dbo].[users_worksheet]
where ([update_time_norm_rat]<[update_time] or [update_time_norm_rat] is null)

WHILE @cnt < @cnt_total+1
BEGIN
	SELECT @user_id = foo.[user_id] 
	FROM (
	  SELECT
		ROW_NUMBER() OVER (ORDER BY [user_id] ASC) AS rownumber,
		[user_id]
	  FROM [CSFD_ML].[dbo].[users_worksheet]
	  where ([update_time_norm_rat]<[update_time] or [update_time_norm_rat] is null)
	) AS foo
	WHERE rownumber <= @cnt;

   exec [dbo].[Normalization_phase_2_a] @userid=@user_id, @update_time=@updatetime
   SET @cnt = @cnt + 1;
END;
GO