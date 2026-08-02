/*
DZIEN 21 - INDEX W SQL SERVER
Projekt: Walmart Sales
Tabela: dbo.Walmart_Sales_Cleaned
Kolumna daty: Date_Sales

Cel:
- sprawdzenie istniejacych indeksow,
- porownanie planu i odczytow przed/po,
- utworzenie indeksu nonclustered z INCLUDE,
- swiadome usuniecie indeksu po cwiczeniu.
*/

USE TreningData;
GO

/* ============================================================
1. KONTROLA ISTNIEJACYCH INDEKSOW
============================================================ */
SELECT
    i.name AS Index_Name,
    i.type_desc AS Index_Type,
    i.is_unique,
    i.is_primary_key,
    c.name AS Column_Name,
    ic.key_ordinal,
    ic.is_included_column
FROM sys.indexes AS i
INNER JOIN sys.index_columns AS ic
    ON i.object_id = ic.object_id
   AND i.index_id = ic.index_id
INNER JOIN sys.columns AS c
    ON ic.object_id = c.object_id
   AND ic.column_id = c.column_id
WHERE i.object_id = OBJECT_ID('dbo.Walmart_Sales_Cleaned')
ORDER BY i.index_id, ic.key_ordinal, ic.index_column_id;
GO

/* ============================================================
2. ZAPYTANIE BAZOWE - PRZED NOWYM INDEKSEM
W SSMS wlacz Actual Execution Plan: Ctrl+M.
============================================================ */
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT
    Store,
    Date_Sales,
    Weekly_Sales,
    Holiday_Flag
FROM dbo.Walmart_Sales_Cleaned
WHERE Date_Sales >= '20110101'
  AND Date_Sales <  '20120101'
ORDER BY Date_Sales, Store;

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO

/* ============================================================
3. UTWORZENIE INDEKSU NONCLUSTERED
Date_Sales = klucz indeksu.
Store, Weekly_Sales, Holiday_Flag = kolumny INCLUDE.
============================================================ */
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

/* ============================================================
4. TO SAMO ZAPYTANIE - PO UTWORZENIU INDEKSU
Porownaj operator, Logical reads i czas.
============================================================ */
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT
    Store,
    Date_Sales,
    Weekly_Sales,
    Holiday_Flag
FROM dbo.Walmart_Sales_Cleaned
WHERE Date_Sales >= '20110101'
  AND Date_Sales <  '20120101'
ORDER BY Date_Sales, Store;

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO

/* ============================================================
5. FILTR PRZYJAZNY INDEKSOWI VS FUNKCJA NA KOLUMNIE
============================================================ */
-- Zwykle lepszy wzorzec dla indeksu zakresowego:
SELECT
    Store,
    Date_Sales,
    Weekly_Sales
FROM dbo.Walmart_Sales_Cleaned
WHERE Date_Sales >= '20120101'
  AND Date_Sales <  '20130101';
GO

-- Wersja do porownania w planie:
SELECT
    Store,
    Date_Sales,
    Weekly_Sales
FROM dbo.Walmart_Sales_Cleaned
WHERE YEAR(Date_Sales) = 2012;
GO

/* ============================================================
6. CWICZENIE - PROPOZYCJA INDEKSU DLA RAPORTU SWIATECZNEGO
Nie tworz bez uzasadnienia i sprawdzenia istniejacych indeksow.
============================================================ */


CREATE NONCLUSTERED INDEX IX_Walmart_Sales_Cleaned_Holiday_Date
ON dbo.Walmart_Sales_Cleaned (Holiday_Flag, Date_Sales)
INCLUDE (Store, Weekly_Sales);
GO 

/* ============================================================
7. USUNIECIE INDEKSU PO CWICZENIU - OPCJONALNIE
DROP INDEX nie usuwa tabeli ani danych.
============================================================ */
DROP INDEX IX_Walmart_Sales_Cleaned_Date_Sales
ON dbo.Walmart_Sales_Cleaned;
GO
