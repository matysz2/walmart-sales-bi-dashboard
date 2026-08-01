/*
DZIEN 20 - VIEW W SQL SERVER
Projekt: Walmart Sales
Tabela faktow: dbo.Walmart_Sales_Cleaned
Kolumna daty: Date_Sales
Wymiar: dbo.Stores_Metadata
*/

USE TreningData;
GO

/* 1. Widok szczegolowy */
CREATE OR ALTER VIEW dbo.vw_Walmart_Sales_Details
AS
SELECT
    s.Store,
    s.Date_Sales,
    s.Weekly_Sales,
    s.Holiday_Flag,
    s.Temperature,
    s.Fuel_Price,
    s.CPI,
    s.Unemployment,
    m.Type,
    m.Size,
    YEAR(s.Date_Sales) AS Sales_Year,
    MONTH(s.Date_Sales) AS Sales_Month
FROM dbo.Walmart_Sales_Cleaned AS s
INNER JOIN dbo.Stores_Metadata AS m
    ON s.Store = m.Store;
GO

/* 2. Kontrola widoku szczegolowego */
SELECT COUNT(*) AS Records_Count
FROM dbo.vw_Walmart_Sales_Details;

SELECT TOP (20)
    Store,
    Date_Sales,
    Weekly_Sales,
    Type,
    Size,
    Sales_Year
FROM dbo.vw_Walmart_Sales_Details
ORDER BY Store, Date_Sales;
GO

/* 3. Widok agregujacy */
CREATE OR ALTER VIEW dbo.vw_Store_Sales_Summary
AS
SELECT
    s.Store,
    m.Type,
    m.Size,
    COUNT(*) AS Weeks_Count,
    SUM(s.Weekly_Sales) AS Total_Sales,
    CAST(AVG(s.Weekly_Sales) AS decimal(18,2)) AS Avg_Weekly_Sales,
    MIN(s.Weekly_Sales) AS Min_Weekly_Sales,
    MAX(s.Weekly_Sales) AS Max_Weekly_Sales,
    MIN(s.Date_Sales) AS First_Sales_Date,
    MAX(s.Date_Sales) AS Last_Sales_Date
FROM dbo.Walmart_Sales_Cleaned AS s
INNER JOIN dbo.Stores_Metadata AS m
    ON s.Store = m.Store
GROUP BY
    s.Store,
    m.Type,
    m.Size;
GO

/* 4. Kontrola widoku agregujacego */
SELECT
    Store,
    Type,
    Size,
    Weeks_Count,
    Total_Sales,
    Avg_Weekly_Sales
FROM dbo.vw_Store_Sales_Summary
ORDER BY Total_Sales DESC;
GO

/* 5. Ranking na podstawie widoku */
SELECT
    Store,
    Type,
    Total_Sales,
    DENSE_RANK() OVER
    (
        PARTITION BY Type
        ORDER BY Total_Sales DESC
    ) AS Rank_In_Type,
    DENSE_RANK() OVER
    (
        ORDER BY Total_Sales DESC
    ) AS Company_Rank
FROM dbo.vw_Store_Sales_Summary
ORDER BY Company_Rank;
GO

/* 6. Cwiczenie - widok swiateczny */
CREATE OR ALTER VIEW dbo.vw_Holiday_Sales_Details
AS
SELECT
    s.Store,
    s.Date_Sales,
    s.Weekly_Sales,
    s.Holiday_Flag,
    m.Type,
    m.Size
FROM dbo.Walmart_Sales_Cleaned AS s
INNER JOIN dbo.Stores_Metadata AS m
    ON s.Store = m.Store
WHERE s.Holiday_Flag = 1;
GO

SELECT TOP (20) *
FROM dbo.vw_Holiday_Sales_Details
ORDER BY Store, Date_Sales;
GO

*/ 7. Zadanie domowe - szablon */
 CREATE OR ALTER VIEW dbo.vw_Holiday_Sales_Analysis
 AS
 SELECT
    s.Store,
    m.Size,
    s.Holiday_Flag,
    COUNT(*) AS Records_Count,
    SUM(s.Weekly_Sales) AS Total_Sales,
     CAST(AVG(s.Weekly_Sales) AS decimal(18,2)) AS Avg_Weekly_Sales,
    MAX(s.Weekly_Sales) AS Max_Weekly_Sales
    FROM dbo.Walmart_Sales_Cleaned AS s
    INNER JOIN dbo.Stores_Metadata AS m
    ON s.Store = m.Store
    GROUP BY
    s.Store,
    m.Type,
    m.Size,
    s.Holiday_Flag;
    GO

/* 8. Usuwanie widoku - uruchom tylko swiadomie */
 DROP VIEW IF EXISTS dbo.vw_Holiday_Sales_Details;
 GO
