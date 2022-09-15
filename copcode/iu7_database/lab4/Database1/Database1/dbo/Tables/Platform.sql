CREATE TABLE [dbo].[Platform] (
    [PlId]        INT           NOT NULL,
    [PlTitle]     NVARCHAR (30) NOT NULL,
    [PlDeveloper] NVARCHAR (40) NOT NULL,
    [PlYear]      INT           NOT NULL,
    PRIMARY KEY CLUSTERED ([PlId] ASC)
);

