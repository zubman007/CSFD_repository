alter PROCEDURE [dbo].[Normalization_of_users_ratings]
	@userid int
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
		@user_unnormalizable as int = 0,
		@ratings_average float,
		@parabola_param float,
		@exist bit = 0

SELECT @exist =1
FROM [CSFD_ML].[dbo].[users]
WHERE [user_id] = @userid

IF @exist = 1
begin
	begin try
		BEGIN TRANSACTION
		SELECT	@f = cast(sum(rat.rat_0) as float),
				@e = cast(sum(rat.rat_20) as float),
				@d = cast(sum(rat.rat_40) as float),
				@c = cast(sum(rat.rat_60) as float),
				@b = cast(sum(rat.rat_80) as float),
				@a = cast(sum(rat.rat_100) as float)
		FROM
		(select case when fr.[rating]=0 then 1 else 0 end as rat_0,
			   case when fr.[rating]=20 then 1 else 0 end as rat_20,
			   case when fr.[rating]=40 then 1 else 0 end as rat_40,
			   case when fr.[rating]=60 then 1 else 0 end as rat_60,
			   case when fr.[rating]=80 then 1 else 0 end as rat_80,
			   case when fr.[rating]=100 then 1 else 0 end as rat_100
		  from [CSFD_ML].[dbo].[film_ratings] as fr
		  where [user_id]=@userid ) as rat;

		SET @parabola_param =(5*(-@a+@b+@c+@d+@e+@f)-(8*@b+6*@c+4*@d+2*@e))/(-12800*@b-14400*@c-9600*@d-3200*@e);
		SET @bp = @parabola_param*80*80-100*80*@parabola_param+1;
		SET @cp = @parabola_param*60*60-100*60*@parabola_param+1;
		SET @dp = @parabola_param*40*40-100*40*@parabola_param+1;
		SET @ep = @parabola_param*20*20-100*20*@parabola_param+1;

		DELETE [film_ratings_normalized]
		WHERE [user_id] = @userid;

		INSERT INTO [film_ratings_normalized]
		SELECT rat.[movie] as [movie]
			  ,rat.[user_id] as [user_id]
			  ,case when rat.[rating]=100 then 100
					when rat.[rating]=0 then 0
					when rat.[rating]=80 then cast(rat.[rating] as float)*@bp
					when rat.[rating]=60 then cast(rat.[rating] as float)*@cp
					when rat.[rating]=40 then cast(rat.[rating] as float)*@dp
					when rat.[rating]=20 then cast(rat.[rating] as float)*@ep
				end as [rating]
		  FROM [CSFD_ML].[dbo].[film_ratings] as rat
		  WHERE [user_id] = @userid;
   
		SELECT @ratings_average = avg(cast([rating] as float))
		  FROM [CSFD_ML].[dbo].[film_ratings_normalized]
		  where [user_id]=@userid;

		SET @blbe = case 
						 when 80*@bp>100 then 1
						 when 60*@cp>80*@bp then 1
						 when 40*@dp>60*@cp then 1
						 when 20*@ep>40*@dp then 1
						 when 20*@ep<0 then 1
					end;

		IF @blbe = 1
			begin
			   ROLLBACK TRANSACTION;
			   SELECT TOP (1) @user_unnormalizable = 1
			   FROM [CSFD_ML].[dbo].[film_ratings]
			   where [user_id]=@userid

		   		IF @user_unnormalizable = 0
						INSERT INTO [dbo].[unnormalizable_users] ([user_id])	VALUES (@userid);	
				print('Došlo k chybě');
			end		   
		ELSE 
			begin
			   COMMIT TRANSACTION;
			   delete [dbo].[unnormalizable_users]
			   where  [user_id]=@userid;

			   select (SELECT avg(cast([rating] as float))
						  FROM [CSFD_ML].[dbo].[film_ratings]
						  where [user_id]=@userid) as unnormalized,
					   (SELECT avg(cast([rating] as float))
						  FROM [CSFD_ML].[dbo].[film_ratings_normalized]
						  where [user_id]=@userid) as normalized,
					   80*@bp as rat_80,
					   60*@cp as rat_80,
					   40*@dp as rat_80,
					   20*@ep as rat_80;
			end;
	END TRY
	BEGIN CATCH  
		print('Došlo k chybě')
		ROLLBACK TRANSACTION
		SELECT TOP (1) @user_unnormalizable = 1
		FROM [CSFD_ML].[dbo].[film_ratings]
		where [user_id]=@userid
		IF @user_unnormalizable = 0
			begin
				INSERT INTO [dbo].[unnormalizable_users] ([user_id]) VALUES (@userid);
			end
	END CATCH;
end

