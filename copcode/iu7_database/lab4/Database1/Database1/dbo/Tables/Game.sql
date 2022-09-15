CREATE TABLE [dbo].[Game] (
    [GId]    INT           NOT NULL,
    [GTitle] NVARCHAR (40) NOT NULL,
    [GGenre] NVARCHAR (20) NOT NULL,
    [DevId]  INT           NOT NULL,
    [PlId]   INT           NOT NULL,
    [GYear]  INT           NOT NULL,
    [GPrice] INT           NOT NULL,
    [ClId]   INT           NOT NULL,
    PRIMARY KEY CLUSTERED ([GId] ASC),
    CONSTRAINT [FK_ClId] FOREIGN KEY ([ClId]) REFERENCES [dbo].[Client] ([ClId]),
    CONSTRAINT [FK_DevId] FOREIGN KEY ([DevId]) REFERENCES [dbo].[Developer] ([DevId]),
    CONSTRAINT [FK_PlId] FOREIGN KEY ([PlId]) REFERENCES [dbo].[Platform] ([PlId])
);

