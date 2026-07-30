/*
DZIEN 15 - CTE (COMMON TABLE EXPRESSION)
Projekt Walmart Sales | Microsoft SQL Server | T-SQL

Tabele:
- dbo.Walmart_Sales
- dbo.Stores_Metadata
*/

/* =========================================================
1. PODSTAWOWA SKLADNIA
========================================================= */

;WITH Nazwa_CTE AS
(
    SELECT
        Store,
        [Date],
        Weekly_Sales
    FROM dbo.Walmart_Sales_Cleaned
    WHERE Weekly_Sales >= 2000000
)
SELECT
    Store,
    [Date],
    Weekly_Sales
FROM Nazwa_CTE
ORDER BY Weekly_Sales DESC;


/* =========================================================
2. CTE - TYGODNIE Z WYSOKA SPRZEDAZA
Kontrola: 410 rekordow przy Weekly_Sales >= 2 000 000
========================================================= */

;WITH High_Sales_Weeks AS
(
    SELECT
        Store,
        [Date],
        Weekly_Sales,
        Holiday_Flag
    FROM dbo.Walmart_Sales_Cleaned
    WHERE Weekly_Sales >= 2000000
)
SELECT
    Store,
    [Date],
    Weekly_Sales,
    Holiday_Flag
FROM High_Sales_Weeks
ORDER BY Weekly_Sales DESC;


/* =========================================================
3. CTE - SPRZEDAZ WEDLUG SKLEPU
Kontrola: 7 sklepow z Total_Sales >= 250 000 000
========================================================= */

;WITH Sales_By_Store AS
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
    Avg_Weekly_Sales
FROM Sales_By_Store
WHERE Total_Sales >= 250000000
ORDER BY Total_Sales DESC;


/* =========================================================
4. CTE + JOIN DO METADANYCH SKLEPOW
========================================================= */

;WITH Sales_By_Store AS
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
    s.Store,
    sm.Type,
    sm.Size,
    s.Weeks_Count,
    s.Total_Sales,
    s.Avg_Weekly_Sales
FROM Sales_By_Store AS s
INNER JOIN dbo.Stores_Metadata AS sm
    ON s.Store = sm.Store
ORDER BY s.Total_Sales DESC;


/* =========================================================
5. KILKA CTE W JEDNYM ZAPYTANIU
Kontrola:
- Avg_Store_Sales ok. 149 715 977,49
- 19 sklepow powyzej lub rownych sredniej
- 26 sklepow ponizej sredniej
========================================================= */

;WITH Sales_By_Store AS
(
    SELECT
        Store,
        SUM(Weekly_Sales) AS Total_Sales
    FROM dbo.Walmart_Sales_Cleaned
    GROUP BY Store
),
Company_Average AS
(
    SELECT AVG(Total_Sales) AS Avg_Store_Sales
    FROM Sales_By_Store
)
SELECT
    s.Store,
    s.Total_Sales,
    a.Avg_Store_Sales,
    CASE
        WHEN s.Total_Sales >= a.Avg_Store_Sales
            THEN 'Powyzej lub rowna sredniej'
        ELSE 'Ponizej sredniej'
    END AS Sales_Status
FROM Sales_By_Store AS s
CROSS JOIN Company_Average AS a
ORDER BY s.Total_Sales DESC;


/* =========================================================
6. ZADANIE PRAKTYCZNE - RAPORT SKLEPOW POWYZEJ SREDNIEJ
========================================================= */

;WITH Sales_By_Store AS
(
    SELECT
        Store,
        COUNT(*) AS Weeks_Count,
        SUM(Weekly_Sales) AS Total_Sales,
        AVG(Weekly_Sales) AS Avg_Weekly_Sales
    FROM dbo.Walmart_Sales_Cleaned
    GROUP BY Store
),
Company_Average AS
(
    SELECT AVG(Total_Sales) AS Avg_Store_Sales
    FROM Sales_By_Store
)
SELECT
    s.Store,
    sm.Type,
    sm.Size,
    s.Weeks_Count,
    s.Total_Sales,
    s.Avg_Weekly_Sales,
    a.Avg_Store_Sales,
    s.Total_Sales / NULLIF(sm.Size, 0) AS Sales_Per_Size,
    'Powyzej_lub_rowna_sredniej' AS Sales_Status
FROM Sales_By_Store AS s
INNER JOIN dbo.Stores_Metadata AS sm
    ON s.Store = sm.Store
CROSS JOIN Company_Average AS a
WHERE s.Total_Sales >= a.Avg_Store_Sales
ORDER BY s.Total_Sales DESC;


/* =========================================================
7. KONTROLA LICZBY SKLEPOW POWYZEJ LUB ROWNYCH SREDNIEJ
Oczekiwany wynik: 19
========================================================= */

;WITH Sales_By_Store AS
(
    SELECT
        Store,
        SUM(Weekly_Sales) AS Total_Sales
    FROM dbo.Walmart_Sales_Cleaned
    GROUP BY Store
),
Company_Average AS
(
    SELECT AVG(Total_Sales) AS Avg_Store_Sales
    FROM Sales_By_Store
)
SELECT
    COUNT(*) AS Stores_Above_Or_Equal_Average
FROM Sales_By_Store AS s
CROSS JOIN Company_Average AS a
WHERE s.Total_Sales >= a.Avg_Store_Sales;


/* =========================================================
8. ZADANIA DOMOWE - SZABLONY
========================================================= */

-- Zadanie 1:
-- CTE Sales_2012, a nastepnie COUNT, SUM i AVG wedlug Store.

;WITH Sales_2012 AS
(
    SELECT
        Store,
        Weekly_Sales
    FROM dbo.Walmart_Sales_Cleaned
    WHERE Date_Sales >= '2012-01-01'
      AND Date_Sales <  '2013-01-01'
)
SELECT
    Store,
    COUNT(*) AS Liczba_Tygodni,
    SUM(Weekly_Sales) AS Sprzedaz_Laczna,
    AVG(Weekly_Sales) AS Srednia_Sprzedaz
FROM Sales_2012
GROUP BY Store
ORDER BY Sprzedaz_Laczna DESC;

-- Zadanie 2:
-- CTE Sales_By_Store i filtr Avg_Weekly_Sales > 1 500 000.

;With Sales_By_Store AS
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
    s.Store,
    s.Weeks_Count,
    s.Total_Sales,
    s.Avg_Weekly_Sales,
    sm.Type,
    sm.Size
FROM Sales_By_Store AS s
INNER JOIN dbo.Stores_Metadata AS sm
    ON s.Store = sm.Store
WHERE s.Avg_Weekly_Sales > 1500000
ORDER BY s.Avg_Weekly_Sales DESC;

-- Zadanie 3:
-- CTE Sales_By_Store + JOIN do Stores_Metadata + filtr Type = 'A'.

;WITH Sales_By_Store AS
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
    s.Store,
    s.Weeks_Count,
    s.Total_Sales,
    s.Avg_Weekly_Sales,
    sm.Type,
    sm.Size
FROM Sales_By_Store AS s
INNER JOIN dbo.Stores_Metadata AS sm
    ON s.Store = sm.Store
WHERE sm.Type = 'A'
ORDER BY s.Total_Sales DESC;

-- Zadanie 4:
-- Dwa CTE: Sales_By_Store i Company_Average.
-- Pokaz sklepy ponizej sredniej i oblicz Sales_Gap.

;WITH Sales_By_Store AS
(
    SELECT
        Store,
        SUM(Weekly_Sales) AS Total_Sales
    FROM dbo.Walmart_Sales_Cleaned
    GROUP BY Store
),
Company_Average AS
(
    SELECT AVG(Total_Sales) AS Avg_Store_Sales
    FROM Sales_By_Store
)
SELECT
    s.Store,
    s.Total_Sales,
    a.Avg_Store_Sales,
    a.Avg_Store_Sales - s.Total_Sales AS Sales_Gap
FROM Sales_By_Store AS s
CROSS JOIN Company_Average AS a
WHERE s.Total_Sales < a.Avg_Store_Sales
ORDER BY Sales_Gap DESC;

-- Zadanie 5:
-- Policz sklepy powyzej/rowne sredniej oraz ponizej sredniej.
-- Wyniki kontrolne: 19 i 26.

;WITH Sales_By_Store AS
(
    SELECT
        Store,
        SUM(Weekly_Sales) AS Total_Sales
    FROM dbo.Walmart_Sales_Cleaned
    GROUP BY Store
),
Company_Average AS
(
    SELECT AVG(Total_Sales) AS Avg_Store_Sales
    FROM Sales_By_Store
)
SELECT
    CASE
        WHEN s.Total_Sales >= a.Avg_Store_Sales THEN 'Powyzej lub rowna sredniej'
        ELSE 'Ponizej sredniej'
    END AS Sales_Status,
    COUNT(*) AS Stores_Count
FROM Sales_By_Store AS s
CROSS JOIN Company_Average AS a
GROUP BY
    CASE
        WHEN s.Total_Sales >= a.Avg_Store_Sales THEN 'Powyzej lub rowna sredniej'
        ELSE 'Ponizej sredniej'
    END
ORDER BY Sales_Status; 







