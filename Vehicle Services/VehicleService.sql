USE [DSTraining]
GO
/****** Object:  StoredProcedure [dbo].[__TMPL__BLD_WRK_VehicleService]    Script Date: 1/27/2019 10:24:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[BLD_WRK_VehicleService]
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

IF OBJECT_ID('WRK_VehicleService') IS NOT NULL
DROP TABLE [WRK_VehicleService]

-- =============================================
-- CREATE TABLE
-- =============================================
CREATE TABLE [WRK_VehicleService]
(
	[RowNumber]       INT IDENTITY(1,1)
	,[CustomerID]     VARCHAR(100)
    ,[CustomerSince]  DATE
    ,[Vehicle]		  VARCHAR(1000)
    ,[2014]			  FLOAT
    ,[2015]           FLOAT
    ,[2016E]		  FLOAT
   
)


-- =============================================
-- TRUNCATE TABLE
-- =============================================
TRUNCATE TABLE [WRK_VehicleService]


-- =============================================
-- INSERT INTO
-- =============================================
INSERT INTO [WRK_VehicleService]
(
    [CustomerID]
	,[CustomerSince]
	,[Vehicle]
	,[2014]
	,[2015]
	,[2016E]			 
)

SELECT
	[CustomerID]
    ,[CustomerSince]
    ,[Vehicle]
    ,[2014]
    ,[2015]
    ,[2016E]		 
	

FROM [RAW_VehicleService_20190127]


-- =============================================
-- ADDING FILTER
-- =============================================
WHERE ISNUMERIC([2015]) = 1
OR [2015] = ''
-- (1049998 rows affected)

/*
[2014] only had null values, [2016E] didn't have any problems
EXCLUDED ROW:
SELECT *
  FROM [dbo].[RAW_VehicleService_20190127]
  WHERE ISNUMERIC([2015]) = 0
  AND [2015] <> ''
*/


-- =============================================
-- FINDING ADDITIONAL ANOMALIES
-- =============================================
-- 1. Duplicates in [CustomerID]

SELECT [CustomerID], COUNT(*)
FROM [dbo].[WRK_VehicleService]
GROUP BY [CustomerID]
HAVING COUNT(*) > 1
--(2 rows with same Customer ID - 3490750)


SELECT *
FROM [WRK_VehicleService]
WHERE [CustomerID] LIKE '3490750'

-- 2. Finding Errors in [CustomerSince] (customer can't be older than 100 years) 
SELECT *
FROM [WRK_VehicleService]
WHERE [CustomerSince] < '1919-01-27'
-- 1 row found.


END
-- SELECT * FROM [RAW_VehicleService_20190127]
-- SELECT * FROM [WRK_VehicleService]