CREATE PROCEDURE [dbo].[Normalization_phase_1]
AS

DECLARE @cnt INT = 1;
DECLARE @cnt_total INT = 0;
DECLARE @user_id INT = 0;
DECLARE @updatetime datetime2 = getutcdate();

IF OBJECT_ID(N'tempdb..#temp', N'U') IS NOT NULL   
DROP TABLE #temp;  
CREATE TABLE #temp ([user_id] int);

insert into #temp
SELECT us.[user_id]
FROM [CSFD_ML].[dbo].[users] as us
left join [CSFD_ML].[dbo].[users_worksheet] as us_sheet
on us_sheet.[user_id]=us.[user_id]
where	((((us_sheet.[average_normilized_rating]<47 or 
		us_sheet.[average_normilized_rating]>52 or 
		us_sheet.[average_normilized_rating] is null)
		and [unnormalizable]<>1) or DATEDIFF(day,us_sheet.[update_time],getutcdate())>150) 
		or us_sheet.[user_id] is null)


select @cnt_total = count([user_id]) from #temp

WHILE @cnt < @cnt_total+1
BEGIN
	SELECT @user_id = foo.[user_id]
	from
	(
		SELECT 	ROW_NUMBER() OVER (ORDER BY [user_id] ASC) AS rownumber,
				t.[user_id]
		FROM #temp as t
	) AS foo
	WHERE rownumber <= @cnt;

   exec [dbo].[Normalization_phase_1_a] @userid=@user_id, @update_time=@updatetime
   SET @cnt = @cnt + 1;
END;
GO