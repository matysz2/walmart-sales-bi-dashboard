USE TreningData;
GO

/*
DZIEN 02
SELECT, TOP, DISTINCT, aliasy i ORDER BY
Tabela: dbo.Walmart_Sales_Cleaned
*/

-- 1. Wybór konkretnych kolumn
SELECT
    Store,
    Date_Sales,
    Weekly_Sales
FROM dbo.Walmart_Sales_Cleaned;
GO

-- 2. Aliasy kolumn
SELECT
    Store AS Numer_Sklepu,
    Date_Sales AS Data_Sprzedazy,
    Weekly_Sales AS Sprzedaz_Tygodniowa
FROM dbo.Walmart_Sales_Cleaned;
GO

-- 3. Pierwsze 10 rekordów
SELECT TOP (10)
    Store,
    Date_Sales,
    Weekly_Sales
FROM dbo.Walmart_Sales_Cleaned;
GO

-- 4. Unikalne sklepy
SELECT DISTINCT
    Store
FROM dbo.Walmart_Sales_Cleaned
ORDER BY Store ASC;
GO

-- 5. Najwyższa sprzedaż tygodniowa
SELECT TOP (10)
    Store,
    Date_Sales,
    Weekly_Sales,
    Holiday_Flag
FROM dbo.Walmart_Sales_Cleaned
ORDER BY Weekly_Sales DESC;
GO

-- 6. Sortowanie wielopoziomowe
SELECT
    Store,
    Date_Sales,
    Weekly_Sales
FROM dbo.Walmart_Sales_Cleaned
ORDER BY
    Store ASC,
    Date_Sales DESC;
GO

/* =========================================================
CWICZENIA - wykonaj samodzielnie
========================================================= */

-- Cwiczenie 1
-- Wyswietl Store, Date_Sales, Weekly_Sales.

-- Cwiczenie 2
-- Wyswietl unikalne numery sklepow rosnaco.

-- Cwiczenie 3
-- Wyswietl 10 rekordow z najnizsza Weekly_Sales.

-- Cwiczenie 4
-- Wyswietl 15 rekordow z najwyzsza Weekly_Sales.
-- Zastosuj polskie aliasy kolumn.

-- Cwiczenie 5
-- Posortuj wszystkie rekordy wedlug Store rosnaco,
-- a wewnatrz sklepu wedlug Date_Sales malejaco.

-- Cwiczenie 6
-- Wyswietl unikalne kombinacje Store i Holiday_Flag.
-- Posortuj wynik wedlug Store, a nastepnie Holiday_Flag.

SELECT
    Store,
    Date_Sales,
    Weekly_Sales
FROM dbo.Walmart_Sales_Cleaned;

SELECT DISTINCT
    Store,
    Holiday_Flag
FROM dbo.Walmart_Sales_Cleaned
ORDER BY Store ASC, Holiday_Flag ASC;

SELECT TOP (10)
    Store AS Numer_Sklepu,
    Date_Sales AS Data_Sprzedazy,
    Weekly_Sales AS Sprzedaz_Tygodniowa
FROM dbo.Walmart_Sales_Cleaned
ORDER BY Weekly_Sales ASC;

SELECT TOP (15)
    Store AS Numer_Sklepu,
    Date_Sales AS Data_Sprzedazy,
    Weekly_Sales AS Sprzedaz_Tygodniowa
FROM dbo.Walmart_Sales_Cleaned
ORDER BY Weekly_Sales DESC;

SELECT
    Store,
    Date_Sales,
    Weekly_Sales
FROM dbo.Walmart_Sales_Cleaned
ORDER BY Store ASC, Date_Sales DESC;

SELECT DISTINCT
    Store,
    Holiday_Flag
FROM dbo.Walmart_Sales_Cleaned
ORDER BY Store ASC, Holiday_Flag ASC;

/* =========================================================
ZADANIE PRAKTYCZNE
========================================================= */
-- Przygotuj ranking 20 najwyzszych wynikow tygodniowej sprzedazy.
-- Kolumny:
-- Numer_Sklepu
-- Data_Sprzedazy
-- Sprzedaz_Tygodniowa
-- Czy_Swieto
-- Sortowanie: Sprzedaz_Tygodniowa malejaco.

SELECT TOP (20)
    Store AS Numer_Sklepu,
    Date_Sales AS Data_Sprzedazy,
    Weekly_Sales AS Sprzedaz_Tygodniowa,
    Holiday_Flag AS Czy_Swieto
FROM dbo.Walmart_Sales_Cleaned
ORDER BY Weekly_Sales DESC;