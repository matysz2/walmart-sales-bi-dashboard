/*
Projekt: Walmart Sales Performance Analysis
Dzień 01: Audyt danych w Microsoft SQL Server
Baza: TreningData
Tabele: dbo.Walmart_Sales, dbo.Stores_Metadata

Cel skryptu:
- sprawdzić strukturę tabel,
- policzyć rekordy,
- znaleźć NULL-e i duplikaty,
- sprawdzić unikalność klucza Store,
- potwierdzić relację 1:* między sklepami i sprzedażą,
- nie modyfikować danych.

WAŻNE: Skrypt zawiera wyłącznie SELECT-y. Niczego nie usuwa.
*/

USE TreningData;
GO

/* ============================================================
   1. Czy wymagane tabele istnieją?
   ============================================================ */
SELECT
    TABLE_SCHEMA,
    TABLE_NAME,
    TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'dbo'
  AND TABLE_NAME IN ('Walmart_Sales', 'Stores_Metadata')
ORDER BY TABLE_NAME;
GO

/* ============================================================
   2. Struktura i typy danych
   ============================================================ */
SELECT
    TABLE_SCHEMA,
    TABLE_NAME,
    ORDINAL_POSITION,
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    NUMERIC_PRECISION,
    NUMERIC_SCALE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo'
  AND TABLE_NAME IN ('Walmart_Sales', 'Stores_Metadata')
ORDER BY TABLE_NAME, ORDINAL_POSITION;
GO

/* ============================================================
   3. Podgląd pierwszych rekordów
   ============================================================ */
SELECT TOP (10) *
FROM dbo.Walmart_Sales
ORDER BY Store, TRY_CONVERT(date, [Date], 105);

SELECT TOP (10) *
FROM dbo.Stores_Metadata
ORDER BY Store;
GO

/* ============================================================
   4. Liczba rekordów
   ============================================================ */
SELECT
    'dbo.Walmart_Sales' AS Table_Name,
    COUNT_BIG(*) AS Rows_Count
FROM dbo.Walmart_Sales
UNION ALL
SELECT
    'dbo.Stores_Metadata' AS Table_Name,
    COUNT_BIG(*) AS Rows_Count
FROM dbo.Stores_Metadata;
GO

/* ============================================================
   5. Liczba unikalnych sklepów
   ============================================================ */
SELECT
    COUNT_BIG(*) AS Sales_Rows,
    COUNT(DISTINCT Store) AS Unique_Stores_In_Sales
FROM dbo.Walmart_Sales;

SELECT
    COUNT_BIG(*) AS Store_Rows,
    COUNT(DISTINCT Store) AS Unique_Stores_In_Metadata
FROM dbo.Stores_Metadata;
GO

/* ============================================================
   6. Profil braków danych - Walmart_Sales
   ============================================================ */
SELECT
    SUM(CASE WHEN Store IS NULL THEN 1 ELSE 0 END) AS Null_Store,
    SUM(CASE WHEN [Date] IS NULL THEN 1 ELSE 0 END) AS Null_Date,
    SUM(CASE WHEN Weekly_Sales IS NULL THEN 1 ELSE 0 END) AS Null_Weekly_Sales,
    SUM(CASE WHEN Holiday_Flag IS NULL THEN 1 ELSE 0 END) AS Null_Holiday_Flag,
    SUM(CASE WHEN Temperature IS NULL THEN 1 ELSE 0 END) AS Null_Temperature,
    SUM(CASE WHEN Fuel_Price IS NULL THEN 1 ELSE 0 END) AS Null_Fuel_Price,
    SUM(CASE WHEN CPI IS NULL THEN 1 ELSE 0 END) AS Null_CPI,
    SUM(CASE WHEN Unemployment IS NULL THEN 1 ELSE 0 END) AS Null_Unemployment
FROM dbo.Walmart_Sales;
GO

/* ============================================================
   7. Profil braków danych - Stores_Metadata
   ============================================================ */
SELECT
    SUM(CASE WHEN Store IS NULL THEN 1 ELSE 0 END) AS Null_Store,
    SUM(CASE WHEN Type IS NULL THEN 1 ELSE 0 END) AS Null_Type,
    SUM(CASE WHEN Size IS NULL THEN 1 ELSE 0 END) AS Null_Size
FROM dbo.Stores_Metadata;
GO

/* ============================================================
   8. Czy Store jest unikalne w tabeli wymiaru?
   Oczekiwany wynik: 0 wierszy.
   ============================================================ */
SELECT
    Store,
    COUNT_BIG(*) AS Records_Count
FROM dbo.Stores_Metadata
GROUP BY Store
HAVING COUNT_BIG(*) > 1
ORDER BY Records_Count DESC, Store;
GO

/* ============================================================
   9. Czy Store + Date jest unikalne w sprzedaży?
   Oczekiwany wynik w czystym źródle: 0 wierszy.
   ============================================================ */
SELECT
    Store,
    [Date],
    COUNT_BIG(*) AS Records_Count
FROM dbo.Walmart_Sales
GROUP BY Store, [Date]
HAVING COUNT_BIG(*) > 1
ORDER BY Records_Count DESC, Store, [Date];
GO

/* ============================================================
   10. Pełne duplikaty w Walmart_Sales
   Jeśli tabela została zaimportowana dwa razy, zapytanie pokaże
   po 2 rekordy dla każdego powtórzonego wiersza.
   ============================================================ */
SELECT
    Store,
    [Date],
    Weekly_Sales,
    Holiday_Flag,
    Temperature,
    Fuel_Price,
    CPI,
    Unemployment,
    COUNT_BIG(*) AS Duplicate_Count
FROM dbo.Walmart_Sales
GROUP BY
    Store,
    [Date],
    Weekly_Sales,
    Holiday_Flag,
    Temperature,
    Fuel_Price,
    CPI,
    Unemployment
HAVING COUNT_BIG(*) > 1
ORDER BY Duplicate_Count DESC, Store, [Date];
GO

/* ============================================================
   11. Ile nadmiarowych rekordów tworzą pełne duplikaty?
   ============================================================ */
WITH DuplicateGroups AS (
    SELECT
        Store,
        [Date],
        Weekly_Sales,
        Holiday_Flag,
        Temperature,
        Fuel_Price,
        CPI,
        Unemployment,
        COUNT_BIG(*) AS Group_Count
    FROM dbo.Walmart_Sales
    GROUP BY
        Store,
        [Date],
        Weekly_Sales,
        Holiday_Flag,
        Temperature,
        Fuel_Price,
        CPI,
        Unemployment
)
SELECT
    SUM(CASE WHEN Group_Count > 1 THEN Group_Count - 1 ELSE 0 END)
        AS Extra_Duplicate_Rows
FROM DuplicateGroups;
GO

/* ============================================================
   12. Zakres dat i liczba tygodni
   TRY_CONVERT obsługuje zarówno kolumnę date, jak i tekst dd-mm-yyyy.
   ============================================================ */
SELECT
    MIN(TRY_CONVERT(date, [Date], 105)) AS Min_Date,
    MAX(TRY_CONVERT(date, [Date], 105)) AS Max_Date,
    COUNT(DISTINCT TRY_CONVERT(date, [Date], 105)) AS Distinct_Dates
FROM dbo.Walmart_Sales;
GO

/* ============================================================
   13. Liczba rekordów dla każdego sklepu
   W czystym źródle każdy sklep ma 143 tygodnie.
   Jeśli import wykonano podwójnie, może być 286.
   ============================================================ */
SELECT
    Store,
    COUNT_BIG(*) AS Records_Count,
    COUNT(DISTINCT TRY_CONVERT(date, [Date], 105)) AS Distinct_Dates
FROM dbo.Walmart_Sales
GROUP BY Store
ORDER BY Store;
GO

/* ============================================================
   14. Kontrola relacji - sprzedaż bez odpowiadającego sklepu
   Oczekiwany wynik: 0 wierszy.
   ============================================================ */
SELECT DISTINCT
    w.Store AS Missing_Store
FROM dbo.Walmart_Sales AS w
LEFT JOIN dbo.Stores_Metadata AS s
    ON w.Store = s.Store
WHERE s.Store IS NULL
ORDER BY w.Store;
GO

/* ============================================================
   15. Kontrola odwrotna - sklep bez sprzedaży
   Oczekiwany wynik dla plików Walmart: 0 wierszy.
   ============================================================ */
SELECT
    s.Store,
    s.Type,
    s.Size
FROM dbo.Stores_Metadata AS s
LEFT JOIN dbo.Walmart_Sales AS w
    ON s.Store = w.Store
WHERE w.Store IS NULL
ORDER BY s.Store;
GO

/* ============================================================
   16. Czy JOIN nie zwiększa liczby rekordów?
   Przy prawidłowej relacji 1:* liczba wierszy po INNER JOIN
   powinna być równa liczbie wierszy tabeli sprzedaży.
   ============================================================ */
SELECT COUNT_BIG(*) AS Sales_Rows_Before_Join
FROM dbo.Walmart_Sales;

SELECT COUNT_BIG(*) AS Rows_After_Inner_Join
FROM dbo.Walmart_Sales AS w
INNER JOIN dbo.Stores_Metadata AS s
    ON w.Store = s.Store;
GO

/* ============================================================
   17. Kontrole zakresów biznesowych
   ============================================================ */
SELECT *
FROM dbo.Walmart_Sales
WHERE Weekly_Sales < 0
   OR Holiday_Flag NOT IN (0, 1)
   OR Fuel_Price <= 0
   OR CPI <= 0
   OR Unemployment < 0;

SELECT *
FROM dbo.Stores_Metadata
WHERE Size <= 0
   OR Type NOT IN ('A', 'B', 'C');
GO

/* ============================================================
   18. Podstawowe statystyki kontrolne
   ============================================================ */
SELECT
    COUNT_BIG(*) AS Records_Count,
    SUM(Weekly_Sales) AS Total_Sales,
    AVG(Weekly_Sales) AS Avg_Weekly_Sales,
    MIN(Weekly_Sales) AS Min_Weekly_Sales,
    MAX(Weekly_Sales) AS Max_Weekly_Sales
FROM dbo.Walmart_Sales;
GO

/* ============================================================
   19. Raport audytu według sklepu
   ============================================================ */
SELECT
    w.Store,
    s.Type,
    s.Size,
    COUNT_BIG(*) AS Records_Count,
    COUNT(DISTINCT TRY_CONVERT(date, w.[Date], 105)) AS Distinct_Dates,
    MIN(TRY_CONVERT(date, w.[Date], 105)) AS Min_Date,
    MAX(TRY_CONVERT(date, w.[Date], 105)) AS Max_Date,
    SUM(w.Weekly_Sales) AS Total_Sales,
    AVG(w.Weekly_Sales) AS Avg_Weekly_Sales
FROM dbo.Walmart_Sales AS w
INNER JOIN dbo.Stores_Metadata AS s
    ON w.Store = s.Store
GROUP BY w.Store, s.Type, s.Size
ORDER BY w.Store;
GO
