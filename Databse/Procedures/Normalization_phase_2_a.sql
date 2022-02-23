CREATE PROCEDURE [dbo].[Normalization_phase_2_a]
	@userid int,
	@update_time datetime2
as
DECLARE @user_unnormalizable as int = 0,
		@parabola_param float,
		@exist bit = 0,
		@avg_rat int

SELECT	@exist =1,
		@parabola_param = [parabol_param],
		@user_unnormalizable = [unnormalizable],
		@avg_rat = [average_rating]
FROM [CSFD_ML].[dbo].[users_worksheet]
WHERE [user_id] = @userid

IF @exist = 1
begin
	begin try
		BEGIN TRANSACTION

		DELETE [film_ratings_normalized]
		WHERE [user_id] = @userid;
		IF @user_unnormalizable=1
			RAISERROR (15600,-1,-1, 'ERROR');
			
		INSERT INTO [film_ratings_normalized]
		SELECT rat.[movie] as [movie]
			  ,rat.[user_id] as [user_id]
			  ,case when rat.[rating]=100 then 100
					when rat.[rating]=0 then   0
					when rat.[rating]=80 then (80-128000*@parabola_param)
					when rat.[rating]=60 then (60-144000*@parabola_param)
					when rat.[rating]=40 then (40-96000*@parabola_param)
					when rat.[rating]=20 then (20-32000*@parabola_param)
				end as [rating]
		  FROM [CSFD_ML].[dbo].[film_ratings] as rat
		  WHERE [user_id] = @userid;

		update [CSFD_ML].[dbo].[users_worksheet]
		set [update_time_norm_rat]=@update_time,
			[average_normilized_rating]=(SELECT avg(cast([rating] as float))
										FROM [CSFD_ML].[dbo].[film_ratings_normalized]
										where [user_id]=@userid),
			[unnormalizable]=0
			WHERE [user_id] = @userid
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH  
		ROLLBACK TRANSACTION
			BEGIN TRY
				BEGIN TRANSACTION
				if @avg_rat>50
					begin
						INSERT INTO [film_ratings_normalized]
						SELECT rat.[movie] as [movie]
							  ,rat.[user_id] as [user_id]
							  ,case when rat.[rating]=100 then 100
									when rat.[rating]=0   then 0
									when rat.[rating]=80  then 50
									when rat.[rating]=60  then 30
									when rat.[rating]=40  then 15
									when rat.[rating]=20  then 5
								end as [rating]
						  FROM [CSFD_ML].[dbo].[film_ratings] as rat
						  WHERE [user_id] = @userid;
					end
					else
					begin
						INSERT INTO [film_ratings_normalized]
						SELECT rat.[movie] as [movie]
							  ,rat.[user_id] as [user_id]
							  ,case when rat.[rating]=100 then 100
									when rat.[rating]=0   then 0
									when rat.[rating]=80  then 95
									when rat.[rating]=60  then 85
									when rat.[rating]=40  then 70
									when rat.[rating]=20  then 50
								end as [rating]
						  FROM [CSFD_ML].[dbo].[film_ratings] as rat
						  WHERE [user_id] = @userid;
					end
					update [CSFD_ML].[dbo].[users_worksheet]
					set [update_time_norm_rat]=@update_time,
						[average_normilized_rating]=(SELECT avg(cast([rating] as float))
														FROM [CSFD_ML].[dbo].[film_ratings_normalized]
														where [user_id]=@userid),
						[unnormalizable]=1
					WHERE [user_id] = @userid
				COMMIT TRANSACTION
			END TRY
			BEGIN CATCH
				ROLLBACK TRANSACTION
			END CATCH
	END CATCH
end

GO