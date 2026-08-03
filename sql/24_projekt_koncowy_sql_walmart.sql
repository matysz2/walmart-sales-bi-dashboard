/*
Dzień 24 - Projekt końcowy etapu SQL
Walmart Sales Performance - warstwa danych pod Power BI
Baza: TreningData
Tabele: dbo.Walmart_Sales_Cleaned, dbo.Stores_Metadata
Kolumna daty: Date_Sales
*/

USE TreningData;
GO

/* 1. AUDYT */
SELECT
    COUNT(*) AS Records_Count,
    COUNT(DISTINCT Store) AS Stores_Count,
    MIN(Date_Sales) AS Date_From,
    MAX(Date_Sales) AS Date_To,
    SUM(Weekly_Sales) AS Total_Sales,
    AVG(Weekly_Sales) AS Avg_Weekly_Sales
FROM dbo.Walmart_Sales_Cleaned;

SELECT
    Store,
    Date_Sales,
    COUNT(*) AS Duplicate_Count
FROM dbo.Walmart_Sales_Cleaned
GROUP BY Store, Date_Sales
HAVING COUNT(*) > 1;

SELECT DISTINCT
    s.Store
FROM dbo.Walmart_Sales_Cleaned AS s
LEFT JOIN dbo.Stores_Metadata AS m
    ON s.Store = m.Store
WHERE m.Store IS NULL;
GO

/* 2. WIDOK RAPORTOWY */
CREATE OR ALTER VIEW dbo.vw_Walmart_Sales_Analysis
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
    m.Size
FROM dbo.Walmart_Sales_Cleaned AS s
INNER JOIN dbo.Stores_Metadata AS m
    ON s.Store = m.Store;
GO

/* 3. PODSUMOWANIE I RANKING SKLEPÓW */
;WITH Store_Summary AS
(
    SELECT
        Store,
        Type,
        Size,
        COUNT(*) AS Weeks_Count,
        SUM(Weekly_Sales) AS Total_Sales,
        AVG(Weekly_Sales) AS Avg_Weekly_Sales,
        MAX(Weekly_Sales) AS Max_Weekly_Sales
    FROM dbo.vw_Walmart_Sales_Analysis
    GROUP BY Store, Type, Size
)
SELECT
    Store,
    Type,
    Size,
    Weeks_Count,
    Total_Sales,
    Avg_Weekly_Sales,
    Max_Weekly_Sales,
    RANK() OVER (ORDER BY Total_Sales DESC) AS Company_Rank,
    RANK() OVER (PARTITION BY Type ORDER BY Total_Sales DESC) AS Type_Rank
FROM Store_Summary
ORDER BY Company_Rank, Store;

/* 4. NAJLEPSZY TYDZIEŃ KAŻDEGO SKLEPU */
;WITH Ranked_Weeks AS
(
    SELECT
        Store,
        Type,
        Size,
        Date_Sales,
        Weekly_Sales,
        Holiday_Flag,
        ROW_NUMBER() OVER
        (
            PARTITION BY Store
            ORDER BY Weekly_Sales DESC, Date_Sales ASC
        ) AS Sales_Row
    FROM dbo.vw_Walmart_Sales_Analysis
)
SELECT
    Store,
    Type,
    Size,
    Date_Sales,
    Weekly_Sales,
    Holiday_Flag
FROM Ranked_Weeks
WHERE Sales_Row = 1
ORDER BY Store;

/* 5. ZMIANA TYDZIEŃ DO TYGODNIA */
;WITH Sales_With_Previous AS
(
    SELECT
        Store,
        Date_Sales,
        Weekly_Sales,
        Holiday_Flag,
        LAG(Weekly_Sales) OVER
        (
            PARTITION BY Store
            ORDER BY Date_Sales
        ) AS Previous_Weekly_Sales
    FROM dbo.vw_Walmart_Sales_Analysis
)
SELECT
    Store,
    Date_Sales,
    Weekly_Sales,
    Previous_Weekly_Sales,
    Weekly_Sales - Previous_Weekly_Sales AS Sales_Change,
    CAST
    (
        (Weekly_Sales - Previous_Weekly_Sales) * 100.0
        / NULLIF(Previous_Weekly_Sales, 0)
        AS decimal(10,2)
    ) AS Sales_Change_Pct,
    CASE
        WHEN Previous_Weekly_Sales IS NULL THEN 'Brak porównania'
        WHEN Weekly_Sales > Previous_Weekly_Sales THEN 'Wzrost'
        WHEN Weekly_Sales < Previous_Weekly_Sales THEN 'Spadek'
        ELSE 'Bez zmiany'
    END AS Trend_Status
FROM Sales_With_Previous
ORDER BY Store, Date_Sales;
GO

/* 6. PROCEDURA RAPORTOWA */
CREATE OR ALTER PROCEDURE dbo.usp_Walmart_Store_Performance
    @Date_From date,
    @Date_To date,
    @Type varchar(5) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @Date_From IS NULL OR @Date_To IS NULL
        THROW 50001, N'Daty nie mogą być NULL.', 1;

    IF @Date_From > @Date_To
        THROW 50002, N'Data początkowa nie może być późniejsza niż końcowa.', 1;

    IF @Type IS NOT NULL
       AND NOT EXISTS
       (
           SELECT 1
           FROM dbo.Stores_Metadata
           WHERE Type = @Type
       )
        THROW 50003, N'Nieprawidłowy typ sklepu.', 1;

    ;WITH Store_Summary AS
    (
        SELECT
            Store,
            Type,
            Size,
            COUNT(*) AS Weeks_Count,
            SUM(Weekly_Sales) AS Total_Sales,
            AVG(Weekly_Sales) AS Avg_Weekly_Sales
        FROM dbo.vw_Walmart_Sales_Analysis
        WHERE Date_Sales >= @Date_From
          AND Date_Sales < DATEADD(day, 1, @Date_To)
          AND (@Type IS NULL OR Type = @Type)
        GROUP BY Store, Type, Size
    )
    SELECT
        Store,
        Type,
        Size,
        Weeks_Count,
        Total_Sales,
        Avg_Weekly_Sales,
        RANK() OVER (ORDER BY Total_Sales DESC) AS Sales_Rank
    FROM Store_Summary
    ORDER BY Sales_Rank, Store;
END;
GO

EXEC dbo.usp_Walmart_Store_Performance
    @Date_From = '20110101',
    @Date_To = '20111231';

EXEC dbo.usp_Walmart_Store_Performance
    @Date_From = '20110101',
    @Date_To = '20111231',
    @Type = 'A';
GO

/* 7. INDEKS - UTWÓRZ TYLKO JEŻELI NIE ISTNIEJE */
IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_Walmart_Sales_Cleaned_Date_Sales'
      AND object_id = OBJECT_ID('dbo.Walmart_Sales_Cleaned')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_Walmart_Sales_Cleaned_Date_Sales
    ON dbo.Walmart_Sales_Cleaned (Date_Sales)
    INCLUDE (Store, Weekly_Sales, Holiday_Flag);
END;
GO

/* 8. POMIAR */
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

EXEC dbo.usp_Walmart_Store_Performance
    @Date_From = '20110101',
    @Date_To = '20111231';

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO
