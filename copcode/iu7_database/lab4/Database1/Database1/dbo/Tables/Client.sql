CREATE TABLE [dbo].[Client] (
    [ClId]      INT           NOT NULL,
    [ClName]    NVARCHAR (20) NOT NULL,
    [ClSurname] NVARCHAR (20) NOT NULL,
    [ClPhone]   NVARCHAR (11) NOT NULL,
    [ClAge]     INT           NOT NULL,
    PRIMARY KEY CLUSTERED ([ClId] ASC)
);

