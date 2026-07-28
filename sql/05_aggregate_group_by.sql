USE TreningData;
GO

/*
DZIEN 5 - FUNKCJE AGREGUJACE I GROUP BY
Tabela: dbo.Walmart_Sales_Cleaned
*/

-- 1. KPI dla calej tabeli
SELECT
    COUNT(*) AS Liczba_Rekordow,
    SUM(Weekly_Sales) AS Sprzedaz_Laczna,
    AVG(Weekly_Sales) AS Srednia_Sprzedaz,
    MIN(Weekly_Sales) AS Najnizsza_Sprzedaz,
    MAX(Weekly_Sales) AS Najwyzsza_Sprzedaz
FROM dbo.Walmart_Sales_Cleaned;
GO

-- 2. COUNT(*) a COUNT(kolumna)
SELECT
    COUNT(*) AS Wszystkie_Rekordy,
    COUNT(CPI) AS Rekordy_Z_CPI
FROM dbo.Walmart_Sales_Cleaned;
GO

-- 3. Podsumowanie wedlug sklepu
SELECT
    Store AS Numer_Sklepu,
    COUNT(*) AS Liczba_Tygodni,
    SUM(Weekly_Sales) AS Sprzedaz_Laczna,
    AVG(Weekly_Sales) AS Srednia_Sprzedaz,
    MIN(Weekly_Sales) AS Najnizsza_Sprzedaz,
    MAX(Weekly_Sales) AS Najwyzsza_Sprzedaz
FROM dbo.Walmart_Sales_Cleaned
GROUP BY Store
ORDER BY Sprzedaz_Laczna DESC;
GO

-- 4. Porownanie tygodni swiatecznych i zwyklych
SELECT
    Holiday_Flag AS Czy_Swieto,
    COUNT(*) AS Liczba_Tygodni,
    SUM(Weekly_Sales) AS Sprzedaz_Laczna,
    AVG(Weekly_Sales) AS Srednia_Sprzedaz
FROM dbo.Walmart_Sales_Cleaned
GROUP BY Holiday_Flag
ORDER BY Holiday_Flag ASC;
GO

-- 5. Podsumowanie wedlug roku
SELECT
    YEAR(Date_Sales) AS Rok,
    COUNT(*) AS Liczba_Rekordow,
    SUM(Weekly_Sales) AS Sprzedaz_Laczna,
    AVG(Weekly_Sales) AS Srednia_Sprzedaz
FROM dbo.Walmart_Sales_Cleaned
GROUP BY YEAR(Date_Sales)
ORDER BY Rok ASC;
GO

-- 6. WHERE przed GROUP BY - raport za rok 2012
SELECT
    Store AS Numer_Sklepu,
    COUNT(*) AS Liczba_Tygodni,
    SUM(Weekly_Sales) AS Sprzedaz_Laczna,
    AVG(Weekly_Sales) AS Srednia_Sprzedaz
FROM dbo.Walmart_Sales_Cleaned
WHERE Date_Sales >= '2012-01-01'
  AND Date_Sales <  '2013-01-01'
GROUP BY Store
ORDER BY Sprzedaz_Laczna DESC;
GO

-- 7. Grupowanie wedlug kilku kolumn
SELECT
    YEAR(Date_Sales) AS Rok,
    Holiday_Flag AS Czy_Swieto,
    COUNT(*) AS Liczba_Tygodni,
    SUM(Weekly_Sales) AS Sprzedaz_Laczna,
    AVG(Weekly_Sales) AS Srednia_Sprzedaz
FROM dbo.Walmart_Sales_Cleaned
GROUP BY
    YEAR(Date_Sales),
    Holiday_Flag
ORDER BY
    Rok ASC,
    Czy_Swieto ASC;
GO

/*
ZADANIE PRAKTYCZNE
Przygotuj ranking sprzedazy sklepow za caly rok 2012.

Wynik:
- Store AS Numer_Sklepu
- COUNT(*) AS Liczba_Tygodni
- SUM(Weekly_Sales) AS Sprzedaz_Laczna
- AVG(Weekly_Sales) AS Srednia_Sprzedaz
- MIN(Weekly_Sales) AS Najnizsza_Sprzedaz
- MAX(Weekly_Sales) AS Najwyzsza_Sprzedaz

Warunki:
- caly rok 2012
- grupowanie wedlug Store
- sortowanie Sprzedaz_Laczna malejaco
- bez TOP
*/

SELECT
    Store AS Numer_Sklepu,
    COUNT(*) AS Liczba_Tygodni,
    SUM(Weekly_Sales) AS Sprzedaz_Laczna,
    AVG(Weekly_Sales) AS Srednia_Sprzedaz,
    MIN(Weekly_Sales) AS Najnizsza_Sprzedaz,
    MAX(Weekly_Sales) AS Najwyzsza_Sprzedaz
FROM dbo.Walmart_Sales_Cleaned
WHERE Date_Sales >= '2012-01-01'
  AND Date_Sales <  '2013-01-01'
GROUP BY Store
ORDER BY Sprzedaz_Laczna DESC;


/*
ZADANIE DOMOWE
1. Podsumowanie sprzedazy wedlug sklepu.
2. Podsumowanie wedlug Holiday_Flag: liczba, minimum, maksimum, srednia.
3. Podsumowanie wedlug roku: liczba rekordow i suma sprzedazy.
4. Podsumowanie sklepow 4, 13 i 20 w roku 2012.
5. Podsumowanie wedlug roku i Holiday_Flag.
*/

SELECT
    Store AS Numer_Sklepu,
    COUNT(*) AS Liczba_Tygodni,
    SUM(Weekly_Sales) AS Sprzedaz_Laczna,
    AVG(Weekly_Sales) AS Srednia_Sprzedaz,
    MIN(Weekly_Sales) AS Najnizsza_Sprzedaz,
    MAX(Weekly_Sales) AS Najwyzsza_Sprzedaz
FROM dbo.Walmart_Sales_Cleaned
WHERE Date_Sales >= '2012-01-01'
  AND Date_Sales <  '2013-01-01'
GROUP BY Store
ORDER BY Sprzedaz_Laczna DESC;  

SELECT
    Holiday_Flag AS Czy_Swieto,
    COUNT(*) AS Liczba_Tygodni,
    SUM(Weekly_Sales) AS Sprzedaz_Laczna,
    AVG(Weekly_Sales) AS Srednia_Sprzedaz,
    MIN(Weekly_Sales) AS Najnizsza_Sprzedaz,
    MAX(Weekly_Sales) AS Najwyzsza_Sprzedaz
FROM dbo.Walmart_Sales_Cleaned
GROUP BY Holiday_Flag
ORDER BY Czy_Swieto ASC;   

SELECT
    YEAR(Date_Sales) AS Rok,
    COUNT(*) AS Liczba_Rekordow,
    SUM(Weekly_Sales) AS Sprzedaz_Laczna
FROM dbo.Walmart_Sales_Cleaned
GROUP BY YEAR(Date_Sales)
ORDER BY Rok ASC;