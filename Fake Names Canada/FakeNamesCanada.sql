USE [DSTraining]
GO
/****** Object:  StoredProcedure [dbo].[BLD_WRK_FakeNamesCanada]    Script Date: 1/27/2019 1:10:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC[dbo].[BLD_WRK_FakeNamesCanada]
-- =============================================
-- Author:		Sanjog Handique
-- Create date: 2019-01-27
-- Description:	RAW -> WRK
-- Mod Date:
-- =============================================

AS


BEGIN

-- =============================================
-- DROP TABLE
-- =============================================

IF OBJECT_ID('WRK_FakeNamesCanada') IS NOT NULL
DROP TABLE [WRK_FakeNamesCanada]

-- =============================================
-- CREATE TABLE
-- =============================================
CREATE TABLE [WRK_FakeNamesCanada]
(
	[RowNumber]      INT IDENTITY(1,1)
	,[Number]		 VARCHAR(100)
	,[Gender]		 VARCHAR(10)
	,[GivenName]	 VARCHAR(1000)
	,[Surname]		 VARCHAR(1000)
	,[StreetAddress] VARCHAR(5000)
	,[City]			 VARCHAR(1000)
	,[ZipCode]		 VARCHAR(10)
	,[CountryFull]   VARCHAR(100)
	,[Birthday]		 DATE
	,[Balance]		 FLOAT
	,[InterestRate]  FLOAT

)


-- =============================================
-- TRUNCATE TABLE
-- =============================================
TRUNCATE TABLE [WRK_FakeNamesCanada]


-- =============================================
-- INSERT INTO
-- =============================================
INSERT INTO [WRK_FakeNamesCanada]
(
    [Number]
    ,[Gender]
    ,[GivenName]
    ,[Surname]
    ,[StreetAddress]
    ,[City]
    ,[ZipCode]
    ,[CountryFull]
    ,[Birthday]
    ,[Balance]
    ,[InterestRate]			 
)

SELECT
	 [Number]
    ,[Gender]
    ,[GivenName]
    ,[Surname]
    ,[StreetAddress]
    ,[City]
    ,[ZipCode]
    ,[CountryFull]
    ,[Birthday]
    ,[Balance]
    ,[InterestRate]
	 

FROM [RAW_FakeNamesCanada_20190125]
-- (x rows affected)


-- =============================================
-- ADDING FILTER
-- =============================================
WHERE ISNUMERIC([Balance]) = 1
-- (Exclude 10 ROWS that HAVE NON NUMERIC VALUES)
AND LEN([ZipCode]) <= 7
-- (Exclude 2 rows that had ZipCodes greater than 7)
AND ISDATE([Birthday]) = 1
-- (Excude 1 row that had Birthday in wrong format)

-- (199987 rows affected) 
-- TOTAL ROWS = 199987 + 10 +2 +1 = 200000 VERFIFIED



-- =============================================
-- ADDITIONAL EXCLUSIONS
-- =============================================

DELETE 
FROM [WRK_FakeNamesCanada]
WHERE [Balance] < 0
-- (1 row affected)


DELETE 
FROM [WRK_FakeNamesCanada]
WHERE [ZipCode] NOT LIKE '___ ___'
-- (4 rows affected)


DELETE 
FROM [WRK_FakeNamesCanada]
WHERE [Birthday] < '1915-08-03'
-- No rows were affected

 

END

-- SELECT COUNT(*) FROM [WRK_FakeNamesCanada]

-- SELECT * FROM [WRK_FakeNamesCanada]

-- SELECT COUNT(*) FROM [dbo].[RAW_FakeNamesCanada_20190125]

-- SELECT * FROM [dbo].[RAW_FakeNamesCanada_20190125]