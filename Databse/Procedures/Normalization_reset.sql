USE [CSFD_ML]
GO

CREATE PROCEDURE [dbo].[Normalization_reset]
AS
truncate table [CSFD_ML].[dbo].[film_ratings_normalized]
truncate table [CSFD_ML].[dbo].[users_worksheet]
exec Normalization_phase_1
exec Normalization_phase_2
GO