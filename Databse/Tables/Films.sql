USE [CSFD_ML]
GO

CREATE TABLE [dbo].[Films](
	[film_id] [int] NULL
) ON [PRIMARY]
GO

CREATE CLUSTERED INDEX [IX_TableFilms_Film_ID] ON [dbo].[Films]
(
	[film_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
