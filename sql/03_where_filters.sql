USE TreningData;
GO

/*
DZIEN 3 - FILTROWANIE DANYCH
Temat: WHERE, operatory porownania, AND, OR, NOT i nawiasy
Tabela: dbo.Walmart_Sales_Cleaned
*/

-- 1. Sprzedaz powyzej 1,5 mln
SELECT
    Store,
    Date_Sales,
    Weekly_Sales
FROM dbo.Walmart_Sales_Cleaned
WHERE Weekly_Sales > 1500000
ORDER BY Weekly_Sales DESC;

-- 2. Tygodnie swiateczne
SELECT
    Store,
    Date_Sales,
    Weekly_Sales,
    Holiday_Flag
FROM dbo.Walmart_Sales_Cleaned
WHERE Holiday_Flag = 1
ORDER BY Date_Sales ASC;

-- 3. Sklep 20 ze sprzedaza co najmniej 1,5 mln
SELECT
    Store,
    Date_Sales,
    Weekly_Sales
FROM dbo.Walmart_Sales_Cleaned
WHERE Store = 20
  AND Weekly_Sales >= 1500000
ORDER BY Weekly_Sales DESC;

-- 4. Sklep 4 albo sklep 20
SELECT
    Store,
    Date_Sales,
    Weekly_Sales
FROM dbo.Walmart_Sales_Cleaned
WHERE Store = 4
   OR Store = 20
ORDER BY Store ASC, Date_Sales ASC;

-- 5. Sprzedaz w roku 2011
SELECT
    Store,
    Date_Sales,
    Weekly_Sales
FROM dbo.Walmart_Sales_Cleaned
WHERE Date_Sales >= '2011-01-01'
  AND Date_Sales <  '2012-01-01'
ORDER BY Date_Sales ASC;

-- 6. Sklep 4 lub 20 oraz sprzedaz minimum 1,5 mln
SELECT
    Store,
    Date_Sales,
    Weekly_Sales
FROM dbo.Walmart_Sales_Cleaned
WHERE (Store = 4 OR Store = 20)
  AND Weekly_Sales >= 1500000
ORDER BY Weekly_Sales DESC;


/*
ZADANIE PRAKTYCZNE
Przygotuj raport wysokiej sprzedazy w chlodne, nieswiateczne tygodnie.
Wynik:
- Store AS Numer_Sklepu
- Date_Sales AS Data_Sprzedazy
- Weekly_Sales AS Sprzedaz_Tygodniowa
- Temperature AS Temperatura
- Holiday_Flag AS Czy_Swieto
Warunki:
- Weekly_Sales >= 1500000
- Temperature < 50
- Holiday_Flag = 0
- sortowanie od najwyzszej sprzedazy
*/
SELECT
    Store AS Numer_Sklepu,
    Date_Sales AS Data_Sprzedazy,
    Weekly_Sales AS Sprzedaz_Tygodniowa,
    Temperature AS Temperatura,
    Holiday_Flag AS Czy_Swieto
FROM dbo.Walmart_Sales_Cleaned
WHERE Weekly_Sales >= 1500000
  AND Temperature < 50
  AND Holiday_Flag = 0
ORDER BY Weekly_Sales DESC;



/*
ZADANIE DOMOWE
1. Sprzedaz powyzej 1 750 000.
2. Sklep 13 albo 20 w roku 2012.
3. Tygodnie nieswiateczne z temperatura ponizej 32.
4. Sklepy 4 lub 14 ze sprzedaza minimum 1 300 000.
*/

-- 1. Sprzedaz powyzej 1 750 000

SELECT
    Store,
    Date_Sales,
    Weekly_Sales
FROM dbo.Walmart_Sales_Cleaned
WHERE Weekly_Sales > 1750000
ORDER BY Weekly_Sales DESC;


-- 2. Sklep 13 albo 20 w roku 2012

SELECT
    Store,
    Date_Sales,
    Weekly_Sales
FROM dbo.Walmart_Sales_Cleaned
WHERE
    (Store = 13 OR Store = 20)
    AND Date_Sales >= '2012-01-01'
    AND Date_Sales < '2013-01-01'
ORDER BY
    Store ASC,
    Date_Sales ASC;


-- 3. Tygodnie nieswiateczne z temperatura ponizej 32

SELECT
    Store,
    Date_Sales,
    Weekly_Sales,
    Holiday_Flag,
    Temperature
FROM dbo.Walmart_Sales_Cleaned
WHERE
    Holiday_Flag = 0
    AND Temperature < 32
ORDER BY Temperature ASC;


-- 4. Sklepy 4 lub 14 ze sprzedaza minimum 1 300 000

SELECT
    Store,
    Date_Sales,
    Weekly_Sales
FROM dbo.Walmart_Sales_Cleaned
WHERE
    (Store = 4 OR Store = 14)
    AND Weekly_Sales >= 1300000
ORDER BY Weekly_Sales DESC;