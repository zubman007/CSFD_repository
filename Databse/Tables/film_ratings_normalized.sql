USE [CSFD_ML]
GO

CREATE TABLE [dbo].[film_ratings_normalized](
	[movie] [int] NOT NULL,
	[user_id] [int] NOT NULL,
	[rating] [tinyint] NOT NULL
) ON [PRIMARY]
GO

CREATE CLUSTERED INDEX [IX_TableRating_norm] ON [dbo].[film_ratings_normalized]
(
	[user_id] ASC,
	[movie] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
