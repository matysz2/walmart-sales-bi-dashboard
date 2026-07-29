USE TreningData;
GO

/*
DZIEN 10 - TEST I MINI PROJEKT
Powtorka dni 1-9
*/

-- TEST PRAKTYCZNY 1
-- Wyswietl 10 najwyzszych wynikow sprzedazy.

SELECT TOP 10 *
FROM dbo.Walmart_Sales_Cleaned
ORDER BY Weekly_Sales DESC;


-- TEST PRAKTYCZNY 2
-- Sklepy 4, 13 i 20 w 2012 roku, Weekly_Sales od 1500000 do 2300000.

SELECT 
sm.Store,
sm.Type,
sm.Size,
ws.Date_Sales,
ws.Weekly_Sales
FROM dbo.Walmart_Sales_Cleaned ws
INNER JOIN dbo.Stores_Metadata sm ON ws.Store = sm.Store
WHERE ws.Date_Sales BETWEEN '2012-01-01' AND '2012-12-31'
AND ws.Store IN (4, 13, 20)
AND ws.Weekly_Sales BETWEEN 1500000 AND 2300000
ORDER BY ws.Weekly_Sales DESC;

-- TEST PRAKTYCZNY 3
-- Laczna i srednia sprzedaz dla kazdego sklepu.
-- Zostaw tylko sklepy ze srednia co najmniej 1500000.

SELECT 
sm.Store,
sm.Type,
sm.Size,
COUNT(ws.Date_Sales) AS Liczba_Tygodni,
SUM(ws.Weekly_Sales) AS Sprzedaz_Laczna,
AVG(ws.Weekly_Sales) AS Srednia_Sprzedaz
FROM dbo.Walmart_Sales_Cleaned ws
INNER JOIN dbo.Stores_Metadata sm ON ws.Store = sm.Store
WHERE ws.Date_Sales BETWEEN '2012-01-01' AND '2012-12-31'
GROUP BY sm.Store, sm.Type, sm.Size
HAVING AVG(ws.Weekly_Sales) >= 1500000
ORDER BY Sprzedaz_Laczna DESC;

-- TEST PRAKTYCZNY 4
-- Polacz sprzedaz z Stores_Metadata i pokaz Type oraz Size.

SELECT 
sm.Store,
sm.Type,
sm.Size,
COUNT(ws.Date_Sales) AS Liczba_Tygodni,
SUM(ws.Weekly_Sales) AS Sprzedaz_Laczna,
AVG(ws.Weekly_Sales) AS Srednia_Sprzedaz,
MAX(ws.Weekly_Sales) AS Najwyzsza_Sprzedaz,
CASE 
    WHEN AVG(ws.Weekly_Sales) >= 1800000 THEN 'Bardzo wysoka'
    WHEN AVG(ws.Weekly_Sales) >= 1400000 THEN 'Wysoka'
    WHEN AVG(ws.Weekly_Sales) >= 1000000 THEN 'Srednia'
    ELSE 'Niska'
END AS Poziom_Sklepu
FROM dbo.Walmart_Sales_Cleaned ws
INNER JOIN dbo.Stores_Metadata sm ON ws.Store = sm.Store
WHERE ws.Date_Sales BETWEEN '2012-01-01' AND '2012-12-31'
GROUP BY sm.Store, sm.Type, sm.Size
ORDER BY Sprzedaz_Laczna DESC;

-- TEST PRAKTYCZNY 5
-- Pokaz wszystkie sklepy i liczbe dopasowanych rekordow z 2012 roku.
-- Zachowaj sklepy bez dopasowania.

SELECT
    sm.Store AS Numer_Sklepu,
    sm.Type AS Typ_Sklepu,
    sm.Size AS Powierzchnia,
    COUNT(ws.Date_Sales) AS Liczba_Rekordow_2012
FROM dbo.Stores_Metadata AS sm
LEFT JOIN dbo.Walmart_Sales_Cleaned AS ws
    ON sm.Store = ws.Store
   AND ws.Date_Sales >= '2012-01-01'
   AND ws.Date_Sales <  '2013-01-01'
GROUP BY
    sm.Store,
    sm.Type,
    sm.Size
ORDER BY
    sm.Store ASC;

/*
MINI PROJEKT

Raport wynikow sklepow za 2012 rok.

Wynik:
- sm.Store AS Numer_Sklepu
- sm.Type AS Typ_Sklepu
- sm.Size AS Powierzchnia
- COUNT(ws.Date_Sales) AS Liczba_Tygodni
- SUM(ws.Weekly_Sales) AS Sprzedaz_Laczna
- AVG(ws.Weekly_Sales) AS Srednia_Sprzedaz
- MAX(ws.Weekly_Sales) AS Najwyzsza_Sprzedaz
- CASE ... END AS Poziom_Sklepu

Klasyfikacja:
- AVG >= 1800000 -> Bardzo wysoka
- AVG >= 1400000 -> Wysoka
- AVG >= 1000000 -> Srednia
- pozostale -> Niska

Warunki:
- INNER JOIN po Store
- caly rok 2012
- GROUP BY Store, Type, Size
- ORDER BY Sprzedaz_Laczna DESC
- bez TOP

Kontrola:
- 45 sklepow
- pierwszy sklep: 4
*/

-- Napisz rozwiazanie ponizej:

SELECT 
    sm.Store AS Numer_Sklepu,
    sm.Type AS Typ_Sklepu,
    sm.Size AS Powierzchnia,
    COUNT(ws.Date_Sales) AS Liczba_Tygodni,
    SUM(ws.Weekly_Sales) AS Sprzedaz_Laczna,
    AVG(ws.Weekly_Sales) AS Srednia_Sprzedaz,
    MAX(ws.Weekly_Sales) AS Najwyzsza_Sprzedaz,
    CASE 
        WHEN AVG(ws.Weekly_Sales) >= 1800000 THEN 'Bardzo wysoka'
        WHEN AVG(ws.Weekly_Sales) >= 1400000 THEN 'Wysoka'
        WHEN AVG(ws.Weekly_Sales) >= 1000000 THEN 'Srednia'
        ELSE 'Niska'
    END AS Poziom_Sklepu
FROM dbo.Walmart_Sales_Cleaned ws
INNER JOIN dbo.Stores_Metadata sm ON ws.Store = sm.Store
WHERE ws.Date_Sales BETWEEN '2012-01-01' AND '2012-12-31'
GROUP BY sm.Store, sm.Type, sm.Size
ORDER BY Sprzedaz_Laczna DESC;      