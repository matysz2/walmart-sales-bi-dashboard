/*
DZIEN 23 - OPTYMALIZACJA ZAPYTAN W SQL SERVER
Projekt: Walmart Sales
Tabela: dbo.Walmart_Sales_Cleaned
Kolumna daty: Date_Sales
*/

USE TreningData;
GO

/* 1. Wersja mniej korzystna */
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT *
FROM dbo.Walmart_Sales_Cleaned
WHERE YEAR(Date_Sales) = 2011
  AND CAST(Store AS varchar(10)) = '20'
ORDER BY Weekly_Sales DESC;

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO

/* 2. Wersja poprawiona */
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT
    Store,
    Date_Sales,
    Weekly_Sales,
    Holiday_Flag
FROM dbo.Walmart_Sales_Cleaned
WHERE Store = 20
  AND Date_Sales >= '20110101'
  AND Date_Sales <  '20120101'
ORDER BY Weekly_Sales DESC;

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO

/* 3. Sprawdzenie indeksow */
SELECT
    i.name AS Index_Name,
    i.type_desc AS Index_Type,
    i.is_unique,
    i.is_primary_key
FROM sys.indexes AS i
WHERE i.object_id = OBJECT_ID('dbo.Walmart_Sales_Cleaned')
ORDER BY i.index_id;
GO

/* 4. Indeks dopasowany do raportu sklepu i zakresu dat */
IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_Walmart_Store_Date'
      AND object_id = OBJECT_ID('dbo.Walmart_Sales_Cleaned')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_Walmart_Store_Date
    ON dbo.Walmart_Sales_Cleaned
    (
        Store,
        Date_Sales
    )
    INCLUDE
    (
        Weekly_Sales,
        Holiday_Flag
    );
END;
GO

/* 5. Raport z JOIN */
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
WHERE s.Store = 20
  AND s.Date_Sales >= '20110101'
  AND s.Date_Sales <  '20120101'
ORDER BY s.Date_Sales;
GO

/* 6. Cwiczenie: przepisz YEAR na zakres dat */
SELECT
    Store,
    Date_Sales,
    Weekly_Sales
FROM dbo.Walmart_Sales_Cleaned
WHERE YEAR(Date_Sales) = 2012;
GO

/* 7. Cwiczenie: Store 14, pierwsze polrocze 2011 */
-- Napisz zapytanie samodzielnie.
SELECT
    Store,
    Date_Sales,
    Weekly_Sales
FROM dbo.Walmart_Sales_Cleaned
WHERE Store = 14
  AND Date_Sales >= '20110101'
  AND Date_Sales <  '20110701'
ORDER BY Date_Sales;
/* 8. Cwiczenie: sklepy typu A w 2012 z Type i Size */
-- Napisz zapytanie samodzielnie.
SELECT
    s.Store,
    s.Date_Sales,
    s.Weekly_Sales,
    m.Type,
    m.Size
FROM dbo.Walmart_Sales_Cleaned AS s
INNER JOIN dbo.Stores_Metadata AS m
    ON s.Store = m.Store
WHERE m.Type = 'A'
  AND s.Date_Sales >= '20120101'
  AND s.Date_Sales <  '20130101'
ORDER BY s.Store, s.Date_Sales;