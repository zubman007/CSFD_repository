CREATE PROCEDURE [dbo].[Normalization_phase_1_a]
	@userid int,
	@update_time datetime2
AS
DECLARE @blbe bit = 0,
		@a float,
		@b float,
		@c float,
		@d float,
		@e float,
		@f float,
		@bp float,
		@cp float,
		@dp float,
		@ep float,
		@parabola_param float,
		@exist bit = 0,
		@exist_in_sheet bit = 0,
		@avg float = 0

SELECT @avg = avg(cast([rating] as float))
FROM [CSFD_ML].[dbo].[film_ratings]
where [user_id]=@userid

SELECT @exist =1
FROM [CSFD_ML].[dbo].[users]
WHERE [user_id] = @userid

SELECT @exist_in_sheet =1
FROM [CSFD_ML].[dbo].[users_worksheet]
WHERE [user_id] = @userid

IF @exist = 1
begin
	begin try
		select @a = sum(case fr.[rating] when 100 then 1 else 0 end),
			   @b = sum(case fr.[rating] when 80 then 1 else 0 end),
			   @c = sum(case fr.[rating] when 60 then 1 else 0 end),
			   @d = sum(case fr.[rating] when 40 then 1 else 0 end),
			   @e = sum(case fr.[rating] when 20 then 1 else 0 end),
			   @f = sum(case fr.[rating] when 0 then 1 else 0 end)
		from [CSFD_ML].[dbo].[film_ratings] as fr
		where [user_id]=@userid
		SET @parabola_param =(5*(-@a+@b+@c+@d+@e+@f)-(8*@b+6*@c+4*@d+2*@e))/(-12800*@b-14400*@c-9600*@d-3200*@e);
		SET @bp = -1600*@parabola_param+1;
		SET @cp = -2400*@parabola_param+1;
		SET @dp = -2400*@parabola_param+1;
		SET @ep = -1600*@parabola_param+1;
		SET @blbe = case 
						 when 4*@bp>5 then 1
						 when 3*@cp>4*@bp then 1
						 when 2*@dp>3*@cp then 1
						 when @ep>2*@dp then 1
						 when @ep<0 then 1
					end;

		IF @blbe = 1
				if @exist_in_sheet=0
					begin
						INSERT INTO [dbo].[users_worksheet]
								   ([user_id]
								   ,[number_of_ratings]
								   ,[average_rating]
								   ,[parabol_param]
								   ,[unnormalizable]
								   ,[update_time])
							 VALUES
								   (@userid
								   ,@a+@b+@c+@d+@e+@f
								   ,@avg
								   ,case when @avg < 50 then -1 else 1 end
								   ,1
								   ,@update_time)
					end;
				else
					begin
						update [dbo].[users_worksheet]
						set [number_of_ratings]=@a+@b+@c+@d+@e+@f,
							[average_rating]=@avg,
							[parabol_param]=case when @avg < 50 then -1 else 1 end,
							[unnormalizable]=1,
							[update_time]=@update_time
						 where [user_id]=@userid
					end
		ELSE
			begin
				if @exist_in_sheet=0
					begin
						INSERT INTO [dbo].[users_worksheet]
								   ([user_id]
								   ,[number_of_ratings]
								   ,[average_rating]
								   ,[parabol_param]
								   ,[unnormalizable]
								   ,[update_time])
							 VALUES(@userid
								   ,@a+@b+@c+@d+@e+@f
								   ,@avg
								   ,@parabola_param
								   ,0
								   ,@update_time)
					end
				else
					begin
						update [dbo].[users_worksheet]
						set [number_of_ratings]=@a+@b+@c+@d+@e+@f,
							[average_rating]=@avg,
							[parabol_param]=@parabola_param,
							[unnormalizable]=0,
							[update_time]=@update_time
						 where [user_id]=@userid
					end
			end

	END TRY
	BEGIN CATCH 
				if @exist_in_sheet=0
					begin
						INSERT INTO [dbo].[users_worksheet]
								   ([user_id]
								   ,[number_of_ratings]
								   ,[average_rating]
								   ,[parabol_param]
								   ,[unnormalizable]
								   ,[update_time])
							 VALUES
								   (@userid
								   ,@a+@b+@c+@d+@e+@f
								   ,@avg
								   ,case when @avg < 50 then -1 else 1 end
								   ,1
								   ,@update_time)
					end;
				else
					begin
						update [dbo].[users_worksheet]
						set [number_of_ratings]=@a+@b+@c+@d+@e+@f,
							[average_rating]=@avg,
							[parabol_param]=case when @avg < 50 then -1 else 1 end,
							[unnormalizable]=1,
							[update_time]=@update_time
						 where [user_id]=@userid
					end
	END CATCH
end

GO