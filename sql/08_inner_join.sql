USE TreningData;
GO

/*
DZIEN 8 - INNER JOIN
Projekt: Walmart Sales
Temat: laczenie tabel w relacji jeden-do-wielu
*/

-- 1. Podstawowe laczenie tabel
SELECT TOP (20)
    ws.Store AS Numer_Sklepu,
    sm.Type AS Typ_Sklepu,
    sm.Size AS Powierzchnia,
    ws.Date_Sales AS Data_Sprzedazy,
    ws.Weekly_Sales AS Sprzedaz_Tygodniowa
FROM dbo.Walmart_Sales_Cleaned AS ws
INNER JOIN dbo.Stores_Metadata AS sm
    ON ws.Store = sm.Store
ORDER BY ws.Weekly_Sales DESC;
GO

-- 2. Filtrowanie po kolumnie z tabeli Stores_Metadata
SELECT
    ws.Store AS Numer_Sklepu,
    sm.Type AS Typ_Sklepu,
    sm.Size AS Powierzchnia,
    ws.Date_Sales AS Data_Sprzedazy,
    ws.Weekly_Sales AS Sprzedaz_Tygodniowa
FROM dbo.Walmart_Sales_Cleaned AS ws
INNER JOIN dbo.Stores_Metadata AS sm
    ON ws.Store = sm.Store
WHERE sm.Type = 'A'
ORDER BY ws.Weekly_Sales DESC;
GO

-- 3. Podsumowanie sprzedazy wedlug typu sklepu
SELECT
    sm.Type AS Typ_Sklepu,
    COUNT(DISTINCT sm.Store) AS Liczba_Sklepow,
    COUNT(*) AS Liczba_Rekordow,
    SUM(ws.Weekly_Sales) AS Sprzedaz_Laczna,
    AVG(ws.Weekly_Sales) AS Srednia_Sprzedaz
FROM dbo.Walmart_Sales_Cleaned AS ws
INNER JOIN dbo.Stores_Metadata AS sm
    ON ws.Store = sm.Store
GROUP BY sm.Type
ORDER BY Sprzedaz_Laczna DESC;
GO

-- 4. Kontrola liczby rekordow po polaczeniu
SELECT COUNT(*) AS Liczba_Rekordow_Po_Join
FROM dbo.Walmart_Sales_Cleaned AS ws
INNER JOIN dbo.Stores_Metadata AS sm
    ON ws.Store = sm.Store;
GO

/*
ZADANIE PRAKTYCZNE

Przygotuj podsumowanie sprzedazy wedlug typu sklepu za caly rok 2012.

Wynik:
- sm.Type AS Typ_Sklepu
- COUNT(DISTINCT sm.Store) AS Liczba_Sklepow
- COUNT(*) AS Liczba_Tygodni
- SUM(ws.Weekly_Sales) AS Sprzedaz_Laczna
- AVG(ws.Weekly_Sales) AS Srednia_Sprzedaz
- MAX(ws.Weekly_Sales) AS Najwyzsza_Sprzedaz

Warunki:
- INNER JOIN po Store
- caly rok 2012
- GROUP BY sm.Type
- ORDER BY Sprzedaz_Laczna DESC
- bez TOP

Kontrola:
- 3 wiersze: A, B, C
- typ A pierwszy
- typ A: 22 sklepy i 946 rekordow
*/

-- Napisz rozwiazanie ponizej:

SELECT
    sm.Type AS Typ_Sklepu,
    COUNT(DISTINCT sm.Store) AS Liczba_Sklepow,
    COUNT(*) AS Liczba_Tygodni,
    SUM(ws.Weekly_Sales) AS Sprzedaz_Laczna,
    AVG(ws.Weekly_Sales) AS Srednia_Sprzedaz,
    MAX(ws.Weekly_Sales) AS Najwyzsza_Sprzedaz
FROM dbo.Walmart_Sales_Cleaned AS ws
INNER JOIN dbo.Stores_Metadata AS sm
    ON ws.Store = sm.Store
WHERE ws.Date_Sales >= '2012-01-01'
  AND ws.Date_Sales <  '2013-01-01'
GROUP BY sm.Type
ORDER BY Sprzedaz_Laczna DESC;

/*
ZADANIE DOMOWE

1. Wyswietl 20 najwyzszych wynikow sprzedazy wraz z Type i Size.
2. Pokaz sklepy typu A z 2011 roku i Weekly_Sales >= 1500000.
3. Dla kazdego sklepu policz SUM(Weekly_Sales), dodaj Type i Size.
4. Policz liczbe sklepow, rekordow, laczna i srednia sprzedaz wedlug Type.
*/
SELECT TOP (20)
    ws.Store AS Numer_Sklepu,
    sm.Type AS Typ_Sklepu,
    sm.Size AS Powierzchnia,
    ws.Date_Sales AS Data_Sprzedazy,
    ws.Weekly_Sales AS Sprzedaz_Tygodniowa
FROM dbo.Walmart_Sales_Cleaned AS ws
INNER JOIN dbo.Stores_Metadata AS sm
    ON ws.Store = sm.Store
ORDER BY ws.Weekly_Sales DESC;

select
    ws.Store AS Numer_Sklepu,
    sm.Type AS Typ_Sklepu,
    sm.Size AS Powierzchnia,
    ws.Date_Sales AS Data_Sprzedazy,
    ws.Weekly_Sales AS Sprzedaz_Tygodniowa
from dbo.Walmart_Sales_Cleaned AS ws
inner join dbo.Stores_Metadata AS sm
    on ws.Store = sm.Store
where sm.Type = 'A'
  and ws.Date_Sales >= '2011-01-01'
  and ws.Date_Sales <  '2012-01-01'
  and ws.Weekly_Sales >= 1500000
order by ws.Weekly_Sales desc;

select
    ws.Store AS Numer_Sklepu,
    sm.Type AS Typ_Sklepu,
    sm.Size AS Powierzchnia,
    SUM(ws.Weekly_Sales) AS Sprzedaz_Laczna
from dbo.Walmart_Sales_Cleaned AS ws
inner join dbo.Stores_Metadata AS sm
    on ws.Store = sm.Store
group by ws.Store, sm.Type, sm.Size
order by Sprzedaz_Laczna desc;

select
    sm.Type AS Typ_Sklepu,
    COUNT(DISTINCT sm.Store) AS Liczba_Sklepow,
    COUNT(*) AS Liczba_Rekordow,
    SUM(ws.Weekly_Sales) AS Sprzedaz_Laczna,
    AVG(ws.Weekly_Sales) AS Srednia_Sprzedaz
from dbo.Walmart_Sales_Cleaned AS ws
inner join dbo.Stores_Metadata AS sm
    on ws.Store = sm.Store
group by sm.Type
order by Sprzedaz_Laczna desc;