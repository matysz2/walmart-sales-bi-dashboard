USE TreningData;
GO

/*
DZIEN 11 - RIGHT JOIN
Projekt: Walmart Sales
Temat: zachowanie wszystkich rekordow z prawej tabeli
*/

-- 1. Podstawowy RIGHT JOIN
SELECT
    sm.Store AS Numer_Sklepu,
    sm.Type AS Typ_Sklepu,
    sm.Size AS Powierzchnia,
    ws.Date_Sales AS Data_Sprzedazy,
    ws.Weekly_Sales AS Sprzedaz_Tygodniowa
FROM dbo.Walmart_Sales_Cleaned AS ws
RIGHT JOIN dbo.Stores_Metadata AS sm
    ON ws.Store = sm.Store
ORDER BY
    sm.Store,
    ws.Date_Sales;
GO

-- 2. Wszystkie sklepy i sprzedaz z 2012 roku
SELECT
    sm.Store AS Numer_Sklepu,
    sm.Type AS Typ_Sklepu,
    sm.Size AS Powierzchnia,
    ws.Date_Sales AS Data_Sprzedazy,
    ws.Weekly_Sales AS Sprzedaz_Tygodniowa
FROM dbo.Walmart_Sales_Cleaned AS ws
RIGHT JOIN dbo.Stores_Metadata AS sm
    ON ws.Store = sm.Store
   AND ws.Date_Sales >= '2012-01-01'
   AND ws.Date_Sales <  '2013-01-01'
ORDER BY
    sm.Store,
    ws.Date_Sales;
GO

-- 3. Liczba dopasowanych rekordow z 2012 roku
SELECT
    sm.Store AS Numer_Sklepu,
    COUNT(ws.Date_Sales) AS Liczba_Tygodni_2012
FROM dbo.Walmart_Sales_Cleaned AS ws
RIGHT JOIN dbo.Stores_Metadata AS sm
    ON ws.Store = sm.Store
   AND ws.Date_Sales >= '2012-01-01'
   AND ws.Date_Sales <  '2013-01-01'
GROUP BY sm.Store
ORDER BY sm.Store;
GO

-- 4. Wyszukiwanie sklepow bez dopasowania
SELECT
    sm.Store,
    sm.Type,
    sm.Size
FROM dbo.Walmart_Sales_Cleaned AS ws
RIGHT JOIN dbo.Stores_Metadata AS sm
    ON ws.Store = sm.Store
WHERE ws.Store IS NULL;
GO

-- 5. RIGHT JOIN i rownowazny LEFT JOIN

-- RIGHT JOIN:
SELECT
    sm.Store,
    ws.Date_Sales,
    ws.Weekly_Sales
FROM dbo.Walmart_Sales_Cleaned AS ws
RIGHT JOIN dbo.Stores_Metadata AS sm
    ON ws.Store = sm.Store;
GO

-- LEFT JOIN:
SELECT
    sm.Store,
    ws.Date_Sales,
    ws.Weekly_Sales
FROM dbo.Stores_Metadata AS sm
LEFT JOIN dbo.Walmart_Sales_Cleaned AS ws
    ON sm.Store = ws.Store;
GO

/*
ZADANIE PRAKTYCZNE

Przygotuj raport wszystkich sklepow dla tygodni z roku 2012,
w ktorych sprzedaz wyniosla co najmniej 2000000.

Wynik:
- sm.Store AS Numer_Sklepu
- sm.Type AS Typ_Sklepu
- sm.Size AS Powierzchnia
- COUNT(ws.Date_Sales) AS Liczba_Tygodni
- COALESCE(SUM(ws.Weekly_Sales), 0) AS Sprzedaz_Laczna
- COALESCE(MAX(ws.Weekly_Sales), 0) AS Najwyzsza_Sprzedaz

Warunki:
- Walmart_Sales_Cleaned po lewej
- Stores_Metadata po prawej
- RIGHT JOIN po Store
- rok 2012 i Weekly_Sales >= 2000000 w ON
- GROUP BY Store, Type, Size
- ORDER BY Liczba_Tygodni DESC, Sprzedaz_Laczna DESC

Kontrola:
- 45 sklepow
- 7 sklepow z dopasowaniem
- 38 sklepow z Liczba_Tygodni = 0
- pierwszy sklep: 4
- sklep 4: Liczba_Tygodni = 41
*/

-- Napisz rozwiazanie ponizej:

SELECT
    sm.Store AS Numer_Sklepu,
    sm.Type AS Typ_Sklepu,
    sm.Size AS Powierzchnia,
    COUNT(ws.Date_Sales) AS Liczba_Tygodni,
    COALESCE(SUM(ws.Weekly_Sales), 0) AS Sprzedaz_Laczna,
    COALESCE(MAX(ws.Weekly_Sales), 0) AS Najwyzsza_Sprzedaz
FROM dbo.Walmart_Sales_Cleaned AS ws
RIGHT JOIN dbo.Stores_Metadata AS sm    
    ON ws.Store = sm.Store
   AND YEAR(ws.Date_Sales) = 2012
   AND ws.Weekly_Sales >= 2000000
GROUP BY
    sm.Store,
    sm.Type,
    sm.Size
ORDER BY
    Liczba_Tygodni DESC,
    Sprzedaz_Laczna DESC;
GO



/*
ZADANIE DOMOWE

1. Wszystkie sklepy i sprzedaz z 2011 roku przez RIGHT JOIN.
2. Liczba tygodni swiatecznych w 2012 roku dla kazdego sklepu.
3. Sklepy bez sprzedazy Weekly_Sales >= 2500000.
4. To samo zapytanie przez RIGHT JOIN i rownowazny LEFT JOIN.
*/

SELECT
    sm.Store AS Numer_Sklepu,
    sm.Type AS Typ_Sklepu,
    sm.Size AS Powierzchnia,
    ws.Date_Sales AS Data_Sprzedazy,
    ws.Weekly_Sales AS Sprzedaz_Tygodniowa
FROM dbo.Walmart_Sales_Cleaned AS ws
RIGHT JOIN dbo.Stores_Metadata AS sm
    ON ws.Store = sm.Store
   AND YEAR(ws.Date_Sales) = 2011
ORDER BY
    sm.Store,
    ws.Date_Sales;  

SELECT
    sm.Store AS Numer_Sklepu,
    sm.Type AS Typ_Sklepu,
    sm.Size AS Powierzchnia,
    COUNT(ws.Date_Sales) AS Liczba_Tygodni_2012
FROM dbo.Walmart_Sales_Cleaned AS ws
RIGHT JOIN dbo.Stores_Metadata AS sm
    ON ws.Store = sm.Store
   AND YEAR(ws.Date_Sales) = 2012
   AND ws.Weekly_Sales >= 2500000
GROUP BY
    sm.Store,
    sm.Type,
    sm.Size
ORDER BY
    Liczba_Tygodni_2012 DESC;

SELECT
    sm.Store AS Numer_Sklepu,
    sm.Type AS Typ_Sklepu,
    sm.Size AS Powierzchnia,
    COUNT(ws.Date_Sales) AS Liczba_Tygodni_2012
FROM dbo.Walmart_Sales_Cleaned AS ws
RIGHT JOIN dbo.Stores_Metadata AS sm
    ON ws.Store = sm.Store
   AND YEAR(ws.Date_Sales) = 2012
   AND ws.Weekly_Sales >= 2500000
GROUP BY
    sm.Store,
    sm.Type,
    sm.Size
ORDER BY
    Liczba_Tygodni_2012 DESC;   

SELECT
    sm.Store AS Numer_Sklepu,
    sm.Type AS Typ_Sklepu,
    sm.Size AS Powierzchnia,
    COUNT(ws.Date_Sales) AS Liczba_Tygodni_2012
FROM dbo.Stores_Metadata AS sm
LEFT JOIN dbo.Walmart_Sales_Cleaned AS ws
    ON sm.Store = ws.Store
   AND YEAR(ws.Date_Sales) = 2012
   AND ws.Weekly_Sales >= 2500000
GROUP BY
    sm.Store,
    sm.Type,
    sm.Size
ORDER BY
    Liczba_Tygodni_2012 DESC;