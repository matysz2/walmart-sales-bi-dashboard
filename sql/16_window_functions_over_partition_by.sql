/*
DZIEN 16 - FUNKCJE OKIENKOWE: OVER I PARTITION BY
Projekt: Walmart Sales
Srodowisko: Microsoft SQL Server / SSMS

Cel:
- zachowac pojedyncze rekordy,
- dopisac do nich srednie, sumy i liczniki,
- porownac tydzien ze sklepem, typem sklepu i cala firma.
*/

USE TreningData;
GO

/* =========================================================
1. GROUP BY - wynik zagregowany do jednego wiersza na sklep
========================================================= */
SELECT
    Store,
    AVG(Weekly_Sales) AS Avg_Store_Sales
FROM dbo.Walmart_Sales
GROUP BY Store
ORDER BY Store;
GO

/* =========================================================
2. OVER() - srednia dla calego wyniku bez utraty rekordow
========================================================= */
SELECT TOP (20)
    Store,
    [Date],
    Weekly_Sales,
    AVG(Weekly_Sales) OVER () AS Company_Avg_Sales,
    Weekly_Sales - AVG(Weekly_Sales) OVER () AS Diff_From_Company_Avg
FROM dbo.Walmart_Sales
ORDER BY Store, [Date];
GO

/* =========================================================
3. PARTITION BY Store - srednia osobno dla kazdego sklepu
========================================================= */
SELECT TOP (20)
    Store,
    [Date],
    Weekly_Sales,
    AVG(Weekly_Sales) OVER (PARTITION BY Store) AS Avg_Store_Sales,
    Weekly_Sales
        - AVG(Weekly_Sales) OVER (PARTITION BY Store) AS Diff_From_Store_Avg
FROM dbo.Walmart_Sales
ORDER BY Store, [Date];
GO

/* =========================================================
4. SUM i COUNT jako funkcje okienkowe
========================================================= */
SELECT TOP (20)
    Store,
    [Date],
    Weekly_Sales,
    SUM(Weekly_Sales) OVER (PARTITION BY Store) AS Store_Total_Sales,
    COUNT(*) OVER (PARTITION BY Store) AS Weeks_Count
FROM dbo.Walmart_Sales
ORDER BY Store, [Date];
GO

/* =========================================================
5. Srednia wedlug typu sklepu po JOIN
========================================================= */
SELECT TOP (30)
    ws.Store,
    ws.[Date],
    sm.Type,
    sm.Size,
    ws.Weekly_Sales,
    AVG(ws.Weekly_Sales) OVER (PARTITION BY sm.Type) AS Avg_Type_Sales,
    ws.Weekly_Sales
        - AVG(ws.Weekly_Sales) OVER (PARTITION BY sm.Type) AS Diff_From_Type_Avg
FROM dbo.Walmart_Sales AS ws
INNER JOIN dbo.Stores_Metadata AS sm
    ON ws.Store = sm.Store
ORDER BY sm.Type, ws.Store, ws.[Date];
GO

/* =========================================================
6. Kilka roznych okien w jednym SELECT
========================================================= */
SELECT TOP (30)
    ws.Store,
    ws.[Date],
    sm.Type,
    ws.Weekly_Sales,
    AVG(ws.Weekly_Sales) OVER () AS Company_Avg,
    AVG(ws.Weekly_Sales) OVER (PARTITION BY ws.Store) AS Store_Avg,
    AVG(ws.Weekly_Sales) OVER (PARTITION BY sm.Type) AS Type_Avg
FROM dbo.Walmart_Sales AS ws
INNER JOIN dbo.Stores_Metadata AS sm
    ON ws.Store = sm.Store
ORDER BY ws.Store, ws.[Date];
GO

/* =========================================================
7. Suma narastajaca - ORDER BY wewnatrz OVER
========================================================= */
SELECT
    Store,
    [Date],
    Weekly_Sales,
    SUM(Weekly_Sales) OVER
    (
        PARTITION BY Store
        ORDER BY [Date]
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS Running_Total_Sales
FROM dbo.Walmart_Sales
WHERE Store = 1
ORDER BY [Date];
GO

/* =========================================================
8. Wplyw WHERE na funkcje okienkowa
Srednia jest liczona tylko z danych z 2011 roku.
========================================================= */
SELECT TOP (30)
    Store,
    [Date],
    Weekly_Sales,
    AVG(Weekly_Sales) OVER (PARTITION BY Store) AS Avg_Store_Sales_2011
FROM dbo.Walmart_Sales
WHERE YEAR([Date]) = 2011
ORDER BY Store, [Date];
GO

/* =========================================================
9. ZADANIE PRAKTYCZNE - WEEKLY STORE BENCHMARK
========================================================= */
SELECT TOP (100)
    ws.Store,
    ws.[Date],
    sm.Type,
    sm.Size,
    ws.Weekly_Sales,
    AVG(ws.Weekly_Sales) OVER () AS Company_Avg_Sales,
    AVG(ws.Weekly_Sales) OVER (PARTITION BY ws.Store) AS Store_Avg_Sales,
    AVG(ws.Weekly_Sales) OVER (PARTITION BY sm.Type) AS Type_Avg_Sales,
    ws.Weekly_Sales
        - AVG(ws.Weekly_Sales) OVER (PARTITION BY ws.Store) AS Diff_From_Store_Avg,
    CASE
        WHEN ws.Weekly_Sales >= AVG(ws.Weekly_Sales)
             OVER (PARTITION BY ws.Store)
            THEN 'Powyzej sredniej sklepu'
        ELSE 'Ponizej sredniej sklepu'
    END AS Status_Store_Avg
FROM dbo.Walmart_Sales AS ws
INNER JOIN dbo.Stores_Metadata AS sm
    ON ws.Store = sm.Store
ORDER BY ws.Store, ws.[Date];
GO

/* =========================================================
10. CWICZENIA - napisz samodzielnie
========================================================= */

-- Cwiczenie 1:
-- Pokaz Store, Date, Weekly_Sales i srednia calej firmy.

SELECT 
Store, 
Date_Sales,
Weekly_Sales,
    AVG(Weekly_Sales) OVER () AS Company_Avg
FROM dbo.Walmart_Sales_Cleaned
ORDER BY Store, Date_Sales;


-- Cwiczenie 2:
-- Dodaj srednia sklepu i roznice od tej sredniej.

SELECT 
Store, 
Date_Sales,
Weekly_Sales,
    AVG(Weekly_Sales) OVER () AS Company_Avg,
    AVG(Weekly_Sales) OVER (PARTITION BY Store) AS Store_Avg,
    Weekly_Sales - AVG(Weekly_Sales) OVER (PARTITION BY Store) AS Diff_From_Store_Avg
FROM dbo.Walmart_Sales_Cleaned
ORDER BY Store, Date_Sales;

-- Cwiczenie 3:
-- Dodaj sume sprzedazy sklepu oraz liczbe tygodni.

SELECT 
Store, 
Date_Sales,
Weekly_Sales,
    AVG(Weekly_Sales) OVER () AS Company_Avg,
    AVG(Weekly_Sales) OVER (PARTITION BY Store) AS Store_Avg,
    Weekly_Sales - AVG(Weekly_Sales) OVER (PARTITION BY Store) AS Diff_From_Store_Avg,
    SUM(Weekly_Sales) OVER (PARTITION BY Store) AS Store_Total_Sales,
    COUNT(*) OVER (PARTITION BY Store) AS Weeks_Count
FROM dbo.Walmart_Sales_Cleaned
ORDER BY Store, Date_Sales;

-- Cwiczenie 4:
-- Polacz dane ze Stores_Metadata i policz srednia wedlug Type.

select 
ws.Store,
ws.Date_Sales,
ws.Weekly_Sales,
sm.Type,
    AVG(ws.Weekly_Sales) OVER () AS Company_Avg,
    AVG(ws.Weekly_Sales) OVER (PARTITION BY ws.Store) AS Store_Avg,
    AVG(ws.Weekly_Sales) OVER (PARTITION BY sm.Type) AS Type_Avg
from dbo.Walmart_Sales_Cleaned as ws
inner join dbo.Stores_Metadata as sm
on ws.Store = sm.Store
order by ws.Store, ws.Date_Sales;

-- Cwiczenie 5:
-- W jednym SELECT pokaz Company_Avg, Store_Avg i Type_Avg
-- tylko dla sklepow 1, 3 i 4.

select 
ws.Store,
ws.Date_Sales,
ws.Weekly_Sales,
sm.Type,
    AVG(ws.Weekly_Sales) OVER () AS Company_Avg,
    AVG(ws.Weekly_Sales) OVER (PARTITION BY ws.Store) AS Store_Avg,
    AVG(ws.Weekly_Sales) OVER (PARTITION BY sm.Type) AS Type_Avg
from dbo.Walmart_Sales_Cleaned as ws
inner join dbo.Stores_Metadata as sm
on ws.Store = sm.Store
where ws.Store in (1, 3, 4)
order by ws.Store, ws.Date_Sales;
/* =========================================================
11. ZADANIE DOMOWE
========================================================= */
-- Przygotuj raport dla sklepow typu A i roku 2011.
-- Wymagane kolumny:
-- Store, Date, Type, Size, Weekly_Sales,
-- srednia typu A, srednia sklepu, suma sklepu, liczba tygodni,
-- roznica od sredniej sklepu i status powyzej/ponizej sredniej.
-- Nie stosuj GROUP BY w koncowym raporcie.
select 
ws.Store,
ws.Date_Sales,
sm.Type,
sm.Size,
ws.Weekly_Sales,
    AVG(ws.Weekly_Sales) OVER (PARTITION BY sm.Type) AS Type_Avg,
    AVG(ws.Weekly_Sales) OVER (PARTITION BY ws.Store) AS Store_Avg,
    SUM(ws.Weekly_Sales) OVER (PARTITION BY ws.Store) AS Store_Total_Sales,
    COUNT(*) OVER (PARTITION BY ws.Store) AS Weeks_Count,
    ws.Weekly_Sales - AVG(ws.Weekly_Sales) OVER (PARTITION BY ws.Store) AS Diff_From_Store_Avg,
    CASE
        WHEN ws.Weekly_Sales >= AVG(ws.Weekly_Sales)
             OVER (PARTITION BY ws.Store)
            THEN 'Powyzej sredniej sklepu'
        ELSE 'Ponizej sredniej sklepu'
    END AS Status_Store_Avg
from dbo.Walmart_Sales_Cleaned as ws
inner join dbo.Stores_Metadata as sm
on ws.Store = sm.Store
where sm.Type = 'A' and YEAR(ws.Date_Sales) = 2011
order by ws.Store, ws.Date_Sales;