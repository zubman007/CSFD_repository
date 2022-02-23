USE [CSFD_ML]
GO

CREATE TABLE [dbo].[users_worksheet](
	[user_id] [int] NULL,
	[number_of_ratings] [int] NULL,
	[average_rating] [float] NULL,
	[parabol_param] [float] NULL,
	[average_normilized_rating] [float] NULL,
	[unnormalizable] [tinyint] NULL,
	[update_time_norm_rat] [datetime2](7) NULL,
	[update_time] [datetime2](7) NULL
) ON [PRIMARY]
GO

CREATE CLUSTERED INDEX [IX_TableWorksheet] ON [dbo].[users_worksheet]
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO


