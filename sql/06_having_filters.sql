/*
DZIEN 06 - HAVING: FILTROWANIE WYNIKOW GRUPOWANIA
Microsoft SQL Server | Walmart Sales
*/

USE TreningData;
GO

-- 1. Sklepy z laczna sprzedaza powyzej 200 mln
SELECT
    Store AS Numer_Sklepu,
    SUM(Weekly_Sales) AS Sprzedaz_Laczna
FROM dbo.Walmart_Sales_Cleaned
GROUP BY Store
HAVING SUM(Weekly_Sales) > 200000000
ORDER BY Sprzedaz_Laczna DESC;

-- 2. Sklepy ze srednia tygodniowa powyzej 1,5 mln
SELECT
    Store AS Numer_Sklepu,
    COUNT(*) AS Liczba_Tygodni,
    AVG(Weekly_Sales) AS Srednia_Sprzedaz
FROM dbo.Walmart_Sales_Cleaned
GROUP BY Store
HAVING AVG(Weekly_Sales) > 1500000
ORDER BY Srednia_Sprzedaz DESC;

-- 3. WHERE filtruje rekordy, HAVING filtruje grupy
SELECT
    Store AS Numer_Sklepu,
    COUNT(*) AS Liczba_Tygodni,
    SUM(Weekly_Sales) AS Sprzedaz_Laczna
FROM dbo.Walmart_Sales_Cleaned
WHERE Date_Sales >= '2012-01-01'
  AND Date_Sales <  '2013-01-01'
GROUP BY Store
HAVING SUM(Weekly_Sales) >= 50000000
ORDER BY Sprzedaz_Laczna DESC;

-- 4. Kilka warunkow w HAVING
SELECT
    Store AS Numer_Sklepu,
    COUNT(*) AS Liczba_Tygodni,
    SUM(Weekly_Sales) AS Sprzedaz_Laczna,
    AVG(Weekly_Sales) AS Srednia_Sprzedaz
FROM dbo.Walmart_Sales_Cleaned
GROUP BY Store
HAVING SUM(Weekly_Sales) >= 200000000
   AND AVG(Weekly_Sales) >= 1500000
ORDER BY Sprzedaz_Laczna DESC;

-- 5. Grupowanie wedlug Store i Holiday_Flag
SELECT
    Store AS Numer_Sklepu,
    Holiday_Flag AS Czy_Swieto,
    COUNT(*) AS Liczba_Tygodni,
    AVG(Weekly_Sales) AS Srednia_Sprzedaz
FROM dbo.Walmart_Sales_Cleaned
GROUP BY Store, Holiday_Flag
HAVING COUNT(*) >= 10
ORDER BY Store ASC, Holiday_Flag ASC;

/*
ZADANIE PRAKTYCZNE
Raport sklepow o wysokiej sprzedazy w roku 2011.

Wynik:
- Store AS Numer_Sklepu
- COUNT(*) AS Liczba_Tygodni
- SUM(Weekly_Sales) AS Sprzedaz_Laczna
- AVG(Weekly_Sales) AS Srednia_Sprzedaz
- MAX(Weekly_Sales) AS Najwyzsza_Sprzedaz

Warunki:
- caly rok 2011
- GROUP BY Store
- SUM(Weekly_Sales) >= 80000000
- AVG(Weekly_Sales) >= 1500000
- sortowanie Sprzedaz_Laczna malejaco

Kontrola: 9 sklepow, pierwszy sklep 4.
*/

-- NAPISZ ROZWIAZANIE PONIZEJ:

SELECT
    Store AS Numer_Sklepu,
    COUNT(*) AS Liczba_Tygodni,
    SUM(Weekly_Sales) AS Sprzedaz_Laczna,
    AVG(Weekly_Sales) AS Srednia_Sprzedaz,
    MAX(Weekly_Sales) AS Najwyzsza_Sprzedaz
FROM dbo.Walmart_Sales_Cleaned
WHERE Date_Sales >= '2011-01-01'
  AND Date_Sales <  '2012-01-01'
GROUP BY Store
HAVING SUM(Weekly_Sales) >= 80000000
   AND AVG(Weekly_Sales) >= 1500000
ORDER BY Sprzedaz_Laczna DESC;


/*
ZADANIE DOMOWE
1. Sklepy z laczna sprzedaza co najmniej 250000000.
2. Rok 2012: srednia sprzedaz powyzej 1200000; pokaz COUNT, AVG i MAX.
3. GROUP BY Store, Holiday_Flag: minimum 10 tygodni i srednia powyzej 1000000.
4. Rok 2011: minimum 50 rekordow i MAX(Weekly_Sales) powyzej 2500000.
*/

SELECT
    Store AS Numer_Sklepu,
    SUM(Weekly_Sales) AS Sprzedaz_Laczna
FROM dbo.Walmart_Sales_Cleaned
GROUP BY Store
HAVING SUM(Weekly_Sales) >= 250000000
ORDER BY Sprzedaz_Laczna DESC;

SELECT
    COUNT(*) AS Liczba_Tygodni,
    AVG(Weekly_Sales) AS Srednia_Sprzedaz,
    MAX(Weekly_Sales) AS Najwyzsza_Sprzedaz
FROM dbo.Walmart_Sales_Cleaned
WHERE Date_Sales >= '2012-01-01'
  AND Date_Sales <  '2013-01-01'
HAVING AVG(Weekly_Sales) > 1200000;

SELECT
    Store AS Numer_Sklepu,
    Holiday_Flag AS Czy_Swieto,
    COUNT(*) AS Liczba_Tygodni,
    AVG(Weekly_Sales) AS Srednia_Sprzedaz
FROM dbo.Walmart_Sales_Cleaned
GROUP BY Store, Holiday_Flag
HAVING COUNT(*) >= 10
   AND AVG(Weekly_Sales) > 1000000
ORDER BY Store ASC, Holiday_Flag ASC;

SELECT
    YEAR(Date_Sales) AS Rok,
    COUNT(*) AS Liczba_Rekordow,
    MAX(Weekly_Sales) AS Najwyzsza_Sprzedaz
FROM dbo.Walmart_Sales_Cleaned
WHERE Date_Sales >= '2011-01-01'
  AND Date_Sales <  '2012-01-01'
GROUP BY YEAR(Date_Sales)
HAVING COUNT(*) >= 50
   AND MAX(Weekly_Sales) > 2500000;