USE TreningData;
GO

/*
DZIEN 9 - LEFT JOIN
Projekt: Walmart Sales
Temat: zachowanie wszystkich rekordow z lewej tabeli
*/

-- 1. Podstawowy LEFT JOIN
SELECT
    sm.Store AS Numer_Sklepu,
    sm.Type AS Typ_Sklepu,
    sm.Size AS Powierzchnia,
    ws.Date_Sales AS Data_Sprzedazy,
    ws.Weekly_Sales AS Sprzedaz_Tygodniowa
FROM dbo.Stores_Metadata AS sm
LEFT JOIN dbo.Walmart_Sales_Cleaned AS ws
    ON sm.Store = ws.Store
ORDER BY sm.Store, ws.Date_Sales;
GO

-- 2. Sklepy bez jakiegokolwiek rekordu sprzedazy
SELECT
    sm.Store,
    sm.Type,
    sm.Size
FROM dbo.Stores_Metadata AS sm
LEFT JOIN dbo.Walmart_Sales_Cleaned AS ws
    ON sm.Store = ws.Store
WHERE ws.Store IS NULL;
GO

-- 3. Wszystkie sklepy i liczba tygodni ze sprzedaza minimum 2 000 000
SELECT
    sm.Store AS Numer_Sklepu,
    sm.Type AS Typ_Sklepu,
    COUNT(ws.Weekly_Sales) AS Liczba_Tygodni_Wysokiej_Sprzedazy
FROM dbo.Stores_Metadata AS sm
LEFT JOIN dbo.Walmart_Sales_Cleaned AS ws
    ON sm.Store = ws.Store
   AND ws.Weekly_Sales >= 2000000
GROUP BY
    sm.Store,
    sm.Type
ORDER BY Liczba_Tygodni_Wysokiej_Sprzedazy DESC;
GO

-- 4. Kontrola liczby sklepow w raporcie
SELECT COUNT(*) AS Liczba_Sklepow
FROM (
    SELECT sm.Store
    FROM dbo.Stores_Metadata AS sm
    LEFT JOIN dbo.Walmart_Sales_Cleaned AS ws
        ON sm.Store = ws.Store
       AND ws.Weekly_Sales >= 2000000
    GROUP BY sm.Store
) AS raport;
GO

/*
ZADANIE PRAKTYCZNE

Przygotuj raport wszystkich sklepow i tygodni z bardzo wysoka sprzedaza w 2012 roku.

Wynik:
- sm.Store AS Numer_Sklepu
- sm.Type AS Typ_Sklepu
- sm.Size AS Powierzchnia
- COUNT(ws.Weekly_Sales) AS Liczba_Tygodni
- SUM(ws.Weekly_Sales) AS Sprzedaz_Laczna
- MAX(ws.Weekly_Sales) AS Najwyzsza_Sprzedaz

Warunki:
- tabela lewa: dbo.Stores_Metadata
- LEFT JOIN po Store
- rok 2012 w warunku ON
- Weekly_Sales >= 2000000 w warunku ON
- GROUP BY Store, Type, Size
- ORDER BY Liczba_Tygodni DESC, Sprzedaz_Laczna DESC

Kontrola:
- 45 sklepow
- 7 sklepow z co najmniej jednym dopasowaniem
- 38 sklepow z Liczba_Tygodni = 0
- pierwszy sklep: 4, Liczba_Tygodni = 41
*/

-- Napisz rozwiazanie ponizej:

SELECT
    sm.Store AS Numer_Sklepu,
    sm.Type AS Typ_Sklepu,
    sm.Size AS Powierzchnia,
    COUNT(ws.Weekly_Sales) AS Liczba_Tygodni,
    SUM(ws.Weekly_Sales) AS Sprzedaz_Laczna,
    MAX(ws.Weekly_Sales) AS Najwyzsza_Sprzedaz
FROM dbo.Stores_Metadata AS sm
LEFT JOIN dbo.Walmart_Sales_Cleaned AS ws
    ON sm.Store = ws.Store
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

1. Pokaz wszystkie sklepy i rekordy sprzedazy z 2012 roku.
2. Dla kazdego sklepu policz liczbe tygodni swiatecznych.
3. Znajdz sklepy bez tygodnia z Weekly_Sales >= 2000000.
4. Policz tygodnie i sprzedaz przy Temperature < 32, umieszczajac warunek w ON.
*/

SELECT
    sm.Store AS Numer_Sklepu,
    sm.Type AS Typ_Sklepu,
    sm.Size AS Powierzchnia,
    ws.Date_Sales AS Data_Sprzedazy,
    ws.Weekly_Sales AS Sprzedaz_Tygodniowa
FROM dbo.Stores_Metadata AS sm
LEFT JOIN dbo.Walmart_Sales_Cleaned AS ws
    ON sm.Store = ws.Store
   AND ws.Date_Sales >= '2012-01-01'
   AND ws.Date_Sales <  '2013-01-01'
ORDER BY
    sm.Store ASC,
    ws.Date_Sales ASC;

    select
    sm.Store AS Numer_Sklepu,
    sm.Type AS Typ_Sklepu,
    sm.Size AS Powierzchnia,
    COUNT(ws.Weekly_Sales) AS Liczba_Tygodni_Swiatecznych
from dbo.Stores_Metadata AS sm
left join dbo.Walmart_Sales_Cleaned AS ws
    on sm.Store = ws.Store
   and ws.Date_Sales >= '2012-11-01'
   and ws.Date_Sales <  '2013-01-01'
group by
    sm.Store,
    sm.Type,
    sm.Size
order by
    Liczba_Tygodni_Swiatecznych DESC;

    SELECT
    sm.Store AS Numer_Sklepu,
    sm.Type AS Typ_Sklepu,
    sm.Size AS Powierzchnia
FROM dbo.Stores_Metadata AS sm
LEFT JOIN dbo.Walmart_Sales_Cleaned AS ws
    ON sm.Store = ws.Store
   AND ws.Weekly_Sales >= 2000000
WHERE ws.Store IS NULL
ORDER BY
    sm.Store ASC;   

    SELECT
    sm.Store AS Numer_Sklepu,
    sm.Type AS Typ_Sklepu,
    sm.Size AS Powierzchnia,
    COUNT(ws.Weekly_Sales) AS Liczba_Tygodni,
    SUM(ws.Weekly_Sales) AS Sprzedaz_Laczna
FROM dbo.Stores_Metadata AS sm
LEFT JOIN dbo.Walmart_Sales_Cleaned AS ws
    ON sm.Store = ws.Store
   AND ws.Temperature < 32
GROUP BY
    sm.Store,
    sm.Type,
    sm.Size
ORDER BY
    Liczba_Tygodni DESC,
    Sprzedaz_Laczna DESC;