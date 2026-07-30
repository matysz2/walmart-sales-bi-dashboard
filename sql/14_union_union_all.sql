/*
DZIEN 14 - UNION I UNION ALL
Projekt Walmart Sales | Microsoft SQL Server | T-SQL

Cel:
- laczenie wynikow kilku zapytan SELECT jeden pod drugim,
- rozrodnienie UNION i UNION ALL,
- kontrola zgodnosci kolumn,
- budowa raportow z kilku okresow lub segmentow.
*/

USE TreningData;
GO

/* =========================================================
   1. Sklepy typu A i B - UNION ALL
   Kontrola: 22 + 17 = 39 wierszy
   ========================================================= */
SELECT
    Store,
    Type,
    Size
FROM dbo.Stores_Metadata
WHERE Type = 'A'

UNION ALL

SELECT
    Store,
    Type,
    Size
FROM dbo.Stores_Metadata
WHERE Type = 'B'
ORDER BY Type, Store;
GO

/* =========================================================
   2. UNION usuwa identyczne wiersze
   Kontrola: 22 wiersze
   ========================================================= */
SELECT Store, Type
FROM dbo.Stores_Metadata
WHERE Type = 'A'

UNION

SELECT Store, Type
FROM dbo.Stores_Metadata
WHERE Type = 'A';
GO

/* =========================================================
   3. UNION ALL zachowuje oba zestawy
   Kontrola: 44 wiersze
   ========================================================= */
SELECT Store, Type
FROM dbo.Stores_Metadata
WHERE Type = 'A'

UNION ALL

SELECT Store, Type
FROM dbo.Stores_Metadata
WHERE Type = 'A';
GO

/* =========================================================
   4. Dodanie kolumny identyfikujacej zrodlo
   Kontrola: typ A 22 + typ C 6 = 28 wierszy
   ========================================================= */
SELECT
    Store,
    Type,
    Size,
    'Segment A' AS Zrodlo
FROM dbo.Stores_Metadata
WHERE Type = 'A'

UNION ALL

SELECT
    Store,
    Type,
    Size,
    'Segment C' AS Zrodlo
FROM dbo.Stores_Metadata
WHERE Type = 'C'
ORDER BY Type, Store;
GO

/* =========================================================
   5. Raport: tygodnie swiateczne i zwykle
   ========================================================= */
SELECT
    'Tygodnie swiateczne' AS Rodzaj_Okresu,
    COUNT(*) AS Records_Count,
    CAST(SUM(Weekly_Sales) AS DECIMAL(18,2)) AS Total_Sales,
    CAST(AVG(Weekly_Sales) AS DECIMAL(18,2)) AS Avg_Weekly_Sales
FROM dbo.Walmart_Sales
WHERE Holiday_Flag = 1

UNION ALL

SELECT
    'Tygodnie zwykle' AS Rodzaj_Okresu,
    COUNT(*) AS Records_Count,
    CAST(SUM(Weekly_Sales) AS DECIMAL(18,2)) AS Total_Sales,
    CAST(AVG(Weekly_Sales) AS DECIMAL(18,2)) AS Avg_Weekly_Sales
FROM dbo.Walmart_Sales
WHERE Holiday_Flag = 0
ORDER BY Rodzaj_Okresu;
GO

/* =========================================================
   6. Zadanie praktyczne - raport roczny
   Jezeli Date jest tekstem, zamien YEAR([Date]) na:
   YEAR(TRY_CONVERT(date, [Date], 105))
   ========================================================= */
SELECT
    2010 AS Rok,
    COUNT(*) AS Records_Count,
    CAST(SUM(Weekly_Sales) AS DECIMAL(18,2)) AS Total_Sales,
    CAST(AVG(Weekly_Sales) AS DECIMAL(18,2)) AS Avg_Weekly_Sales
FROM dbo.Walmart_Sales
WHERE YEAR([Date]) = 2010

UNION ALL

SELECT
    2011,
    COUNT(*),
    CAST(SUM(Weekly_Sales) AS DECIMAL(18,2)),
    CAST(AVG(Weekly_Sales) AS DECIMAL(18,2))
FROM dbo.Walmart_Sales
WHERE YEAR([Date]) = 2011

UNION ALL

SELECT
    2012,
    COUNT(*),
    CAST(SUM(Weekly_Sales) AS DECIMAL(18,2)),
    CAST(AVG(Weekly_Sales) AS DECIMAL(18,2))
FROM dbo.Walmart_Sales
WHERE YEAR([Date]) = 2012
ORDER BY Rok;
GO

/* =========================================================
   CWICZENIA
   ========================================================= */

-- Cwiczenie 1:
-- Polacz sklepy typu A i C za pomoca UNION ALL.
-- Pokaz Store, Type, Size i kolumne Zrodlo.

SeLECT
    Store,
    Type,
    Size,
    'Segment A' AS Zrodlo
FROM dbo.Stores_Metadata
WHERE Type = 'A'    

UNION ALL

SELECT
    Store,
    Type,
    Size,
    'Segment C' AS Zrodlo
FROM dbo.Stores_Metadata
WHERE Type = 'C'
ORDER BY Type, Store;
GO

/* =========================================================
   CWICZENIE 2:
   Uruchom dwa identyczne SELECT dla typu B:
   raz z UNION, raz z UNION ALL.
   Kontrola: 17 oraz 34 wiersze.
   ========================================================= */
-- Uzycie UNION: Usuwa duplikaty. Powinno zwrocic 17 wierszy dla Type 'B'.
SELECT
    Store,
    Type,
    Size
FROM dbo.Stores_Metadata
WHERE Type = 'B'

UNION

SELECT
    Store,
    Type,
    Size
FROM dbo.Stores_Metadata
WHERE Type = 'B'
ORDER BY Type, Store;
GO

-- Uzycie UNION ALL: Zachowuje wszystkie wiersze, wlacznie z duplikatami. Powinno zwrocic 34 wiersze dla Type 'B'.
SELECT
    Store,
    Type,
    Size
FROM dbo.Stores_Metadata
WHERE Type = 'B'

UNION ALL

SELECT
    Store,
    Type,
    Size
FROM dbo.Stores_Metadata
WHERE Type = 'B'
ORDER BY Type, Store;
GO

/* =========================================================
   CWICZENIE 3:
   Polacz szczegolowe rekordy sprzedazy z lat 2010 i 2012.
   Pokaz Store, Date, Weekly_Sales i Okres_Zrodlowy.
   ========================================================= */
SELECT
    Store,
    Date,
    Weekly_Sales,
    '2010' AS Okres_Zrodlowy
FROM dbo.Walmart_Sales
WHERE YEAR(Date) = 2010

UNION ALL

SELECT
    Store,
    Date,
    Weekly_Sales,
    '2012' AS Okres_Zrodlowy
FROM dbo.Walmart_Sales
WHERE YEAR(Date) = 2012
ORDER BY Date, Store;
GO


/* =========================================================
   CWICZENIE 4:
   Zbuduj roczny raport dla 2010, 2011 i 2012.
   Kolumny: Rok, Records_Count, Total_Sales, Avg_Weekly_Sales.
   ========================================================= */
SELECT
    YEAR(Date) AS Rok,
    COUNT(*) AS Records_Count,
    CAST(SUM(Weekly_Sales) AS DECIMAL(18,2)) AS Total_Sales,
    CAST(AVG(Weekly_Sales) AS DECIMAL(18,2)) AS Avg_Weekly_Sales
FROM dbo.Walmart_Sales
WHERE YEAR(Date) = 2010
GROUP BY YEAR(Date)

UNION ALL

SELECT
    YEAR(Date) AS Rok,
    COUNT(*) AS Records_Count,
    CAST(SUM(Weekly_Sales) AS DECIMAL(18,2)) AS Total_Sales,
    CAST(AVG(Weekly_Sales) AS DECIMAL(18,2)) AS Avg_Weekly_Sales
FROM dbo.Walmart_Sales
WHERE YEAR(Date) = 2011
GROUP BY YEAR(Date)

UNION ALL

SELECT
    YEAR(Date) AS Rok,
    COUNT(*) AS Records_Count,
    CAST(SUM(Weekly_Sales) AS DECIMAL(18,2)) AS Total_Sales,
    CAST(AVG(Weekly_Sales) AS DECIMAL(18,2)) AS Avg_Weekly_Sales
FROM dbo.Walmart_Sales
WHERE YEAR(Date) = 2012
GROUP BY YEAR(Date)
ORDER BY Rok;
GO
