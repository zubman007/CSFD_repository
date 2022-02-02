USE [CSFD_ML]
GO

CREATE TABLE [dbo].[film_ratings_normalized](
	[movie] [int] NOT NULL,
	[user_id] [int] NOT NULL,
	[rating] [tinyint] NOT NULL
) ON [PRIMARY]
GO