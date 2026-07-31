/*
DZIEN 18 - RANK() I DENSE_RANK()
Microsoft SQL Server | Projekt Walmart

Tabela sprzedazy: dbo.Walmart_Sales_Cleaned
Kolumna daty: Date_Sales
Tabela sklepow: dbo.Stores_Metadata
*/

USE TreningData;
GO

/* 1. Ranking wszystkich tygodni w calej firmie */
SELECT
    Store,
    Date_Sales,
    Weekly_Sales,
    RANK() OVER
    (
        ORDER BY Weekly_Sales DESC
    ) AS Company_Sales_Rank,
    DENSE_RANK() OVER
    (
        ORDER BY Weekly_Sales DESC
    ) AS Company_Sales_Dense_Rank
FROM dbo.Walmart_Sales_Cleaned
ORDER BY Company_Sales_Rank, Store, Date_Sales;
GO

/* 2. Osobny ranking dla kazdego sklepu */
SELECT
    Store,
    Date_Sales,
    Weekly_Sales,
    RANK() OVER
    (
        PARTITION BY Store
        ORDER BY Weekly_Sales DESC
    ) AS Store_Sales_Rank,
    DENSE_RANK() OVER
    (
        PARTITION BY Store
        ORDER BY Weekly_Sales DESC
    ) AS Store_Sales_Dense_Rank
FROM dbo.Walmart_Sales_Cleaned
ORDER BY Store, Store_Sales_Rank, Date_Sales;
GO

/* 3. Porownanie ROW_NUMBER, RANK i DENSE_RANK dla sklepu 1 */
SELECT
    Store,
    Date_Sales,
    Weekly_Sales,
    ROW_NUMBER() OVER
    (
        ORDER BY Weekly_Sales DESC, Date_Sales ASC
    ) AS Row_Num,
    RANK() OVER
    (
        ORDER BY Weekly_Sales DESC
    ) AS Sales_Rank,
    DENSE_RANK() OVER
    (
        ORDER BY Weekly_Sales DESC
    ) AS Sales_Dense_Rank
FROM dbo.Walmart_Sales_Cleaned
WHERE Store = 1
ORDER BY Weekly_Sales DESC, Date_Sales;
GO

/* 4. Ranking sklepow wedlug lacznej sprzedazy */
;WITH Store_Summary AS
(
    SELECT
        Store,
        COUNT(*) AS Weeks_Count,
        SUM(Weekly_Sales) AS Total_Sales,
        AVG(Weekly_Sales) AS Avg_Weekly_Sales
    FROM dbo.Walmart_Sales_Cleaned
    GROUP BY Store
)
SELECT
    Store,
    Weeks_Count,
    Total_Sales,
    Avg_Weekly_Sales,
    RANK() OVER
    (
        ORDER BY Total_Sales DESC
    ) AS Company_Rank,
    DENSE_RANK() OVER
    (
        ORDER BY Total_Sales DESC
    ) AS Company_Dense_Rank
FROM Store_Summary
ORDER BY Company_Rank, Store;
GO

/* 5. Ranking sklepow osobno wedlug Type */
;WITH Store_Summary AS
(
    SELECT
        s.Store,
        m.Type,
        m.Size,
        SUM(s.Weekly_Sales) AS Total_Sales
    FROM dbo.Walmart_Sales_Cleaned AS s
    INNER JOIN dbo.Stores_Metadata AS m
        ON s.Store = m.Store
    GROUP BY
        s.Store,
        m.Type,
        m.Size
)
SELECT
    Store,
    Type,
    Size,
    Total_Sales,
    DENSE_RANK() OVER
    (
        PARTITION BY Type
        ORDER BY Total_Sales DESC
    ) AS Rank_Within_Type
FROM Store_Summary
ORDER BY Type, Rank_Within_Type, Store;
GO

/* 6. TOP 3 pozycje sprzedazowe kazdego sklepu - z remisami */
;WITH Ranked_Sales AS
(
    SELECT
        Store,
        Date_Sales,
        Weekly_Sales,
        DENSE_RANK() OVER
        (
            PARTITION BY Store
            ORDER BY Weekly_Sales DESC
        ) AS Sales_Position
    FROM dbo.Walmart_Sales_Cleaned
)
SELECT
    Store,
    Date_Sales,
    Weekly_Sales,
    Sales_Position
FROM Ranked_Sales
WHERE Sales_Position <= 3
ORDER BY Store, Sales_Position, Date_Sales;
GO

/* 7. Zadanie praktyczne - pelny raport rankingowy */
;WITH Store_Summary AS
(
    SELECT
        s.Store,
        m.Type,
        m.Size,
        COUNT(*) AS Weeks_Count,
        SUM(s.Weekly_Sales) AS Total_Sales,
        AVG(s.Weekly_Sales) AS Avg_Weekly_Sales
    FROM dbo.Walmart_Sales_Cleaned AS s
    INNER JOIN dbo.Stores_Metadata AS m
        ON s.Store = m.Store
    GROUP BY
        s.Store,
        m.Type,
        m.Size
),
Ranked_Stores AS
(
    SELECT
        *,
        RANK() OVER (ORDER BY Total_Sales DESC) AS Company_Rank,
        RANK() OVER
        (
            PARTITION BY Type
            ORDER BY Total_Sales DESC
        ) AS Type_Rank,
        DENSE_RANK() OVER
        (
            PARTITION BY Type
            ORDER BY Total_Sales DESC
        ) AS Type_Dense_Rank
    FROM Store_Summary
)
SELECT *
FROM Ranked_Stores
ORDER BY Company_Rank, Store;
GO

-- CWICZENIA
--1. Ranking calej firmy za pomoca RANK().

SELECT
    Store,
    Date_Sales,
    Weekly_Sales,
    RANK() OVER
    (
        ORDER BY Weekly_Sales DESC
    ) AS Company_Sales_Rank
FROM dbo.Walmart_Sales_Cleaned
ORDER BY Company_Sales_Rank, Store, Date_Sales;
--2. Dodaj DENSE_RANK() i porownaj wynik.
SELECT
    Store,
    Date_Sales,
    Weekly_Sales,
    RANK() OVER
    (
        ORDER BY Weekly_Sales DESC
    ) AS Company_Sales_Rank,
    DENSE_RANK() OVER
    (
        ORDER BY Weekly_Sales DESC
    ) AS Company_Sales_Dense_Rank
FROM dbo.Walmart_Sales_Cleaned
ORDER BY Company_Sales_Rank, Store, Date_Sales;
--3. Porownaj trzy funkcje dla Store = 1.
SELECT
    Store,
    Date_Sales,
    Weekly_Sales,
    ROW_NUMBER() OVER
    (
        ORDER BY Weekly_Sales DESC, Date_Sales ASC
    ) AS Row_Num,
    RANK() OVER
    (
        ORDER BY Weekly_Sales DESC
    ) AS Sales_Rank,
    DENSE_RANK() OVER
    (
        ORDER BY Weekly_Sales DESC
    ) AS Sales_Dense_Rank
FROM dbo.Walmart_Sales_Cleaned
WHERE Store = 1
ORDER BY Weekly_Sales DESC, Date_Sales;
--4. Nadaj ranking osobno dla kazdego sklepu.
SELECT
    Store,
    Date_Sales,
    Weekly_Sales,
    RANK() OVER
    (
        PARTITION BY Store
        ORDER BY Weekly_Sales DESC
    ) AS Store_Sales_Rank
FROM dbo.Walmart_Sales_Cleaned
ORDER BY Store, Store_Sales_Rank, Date_Sales;
--5. Wybierz TOP 5 pozycji kazdego sklepu.
WITH Ranked_Sales AS (
    SELECT 
        Store,
        Date_Sales,
        Weekly_Sales,
        RANK() OVER (PARTITION BY Store ORDER BY Weekly_Sales DESC) AS Store_Sales_Rank
    FROM dbo.Walmart_Sales_Cleaned
)
SELECT Store, Date_Sales, Weekly_Sales, Store_Sales_Rank
FROM Ranked_Sales
WHERE Store_Sales_Rank <= 5
ORDER BY Store, Store_Sales_Rank, Date_Sales;
--6. Policz Total_Sales i utworz ranking sklepow.
WITH Store_Summary AS (
    SELECT 
        s.Store,
        m.Type,
        m.Size,
        SUM(s.Weekly_Sales) AS Total_Sales
    FROM dbo.Walmart_Sales_Cleaned AS s
    INNER JOIN dbo.Stores_Metadata AS m ON s.Store = m.Store
    GROUP BY s.Store, m.Type, m.Size
)
SELECT 
    Store,
    Type,
    Size,
    Total_Sales,
    RANK() OVER (ORDER BY Total_Sales DESC) AS Company_Rank,
    DENSE_RANK() OVER (ORDER BY Total_Sales DESC) AS Company_Dense_Rank
FROM Store_Summary
ORDER BY Company_Rank, Store;
--7. Utworz ranking sklepow osobno wedlug Type.
WITH Store_Summary AS (
    SELECT 
        s.Store,
        m.Type,
        m.Size,
        SUM(s.Weekly_Sales) AS Total_Sales
    FROM dbo.Walmart_Sales_Cleaned AS s
    INNER JOIN dbo.Stores_Metadata AS m ON s.Store = m.Store
    GROUP BY s.Store, m.Type, m.Size
)
SELECT 
    Store,
    Type,
    Size,
    Total_Sales,   
    RANK() OVER (PARTITION BY Type ORDER BY Total_Sales DESC) AS Type_Rank
FROM Store_Summary
ORDER BY Type, Type_Rank, Store;
