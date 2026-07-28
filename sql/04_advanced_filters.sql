USE TreningData;
GO

/*
DZIEN 4 - PRECYZYJNE FILTROWANIE DANYCH
Tematy: IN, NOT IN, BETWEEN, NOT BETWEEN, LIKE, IS NULL, IS NOT NULL
*/

/* ================================================================
1. IN - wybieranie wartosci z listy
================================================================ */
SELECT
    Store,
    Date_Sales,
    Weekly_Sales
FROM dbo.Walmart_Sales_Cleaned
WHERE Store IN (4, 13, 20)
ORDER BY Store ASC, Date_Sales ASC;
GO

/* To samo zapisane za pomoca OR */
SELECT
    Store,
    Date_Sales,
    Weekly_Sales
FROM dbo.Walmart_Sales_Cleaned
WHERE Store = 4
   OR Store = 13
   OR Store = 20
ORDER BY Store ASC, Date_Sales ASC;
GO

/* ================================================================
2. NOT IN - wykluczanie wartosci z listy
================================================================ */
SELECT
    Store,
    Date_Sales,
    Weekly_Sales
FROM dbo.Walmart_Sales_Cleaned
WHERE Store NOT IN (4, 13, 20)
ORDER BY Store ASC, Date_Sales ASC;
GO

/* ================================================================
3. BETWEEN - przedzial liczbowy z obiema granicami wlacznie
================================================================ */
SELECT
    Store,
    Date_Sales,
    Weekly_Sales
FROM dbo.Walmart_Sales_Cleaned
WHERE Weekly_Sales BETWEEN 1300000 AND 1600000
ORDER BY Weekly_Sales DESC;
GO

/* Zapis rownowazny */
SELECT
    Store,
    Date_Sales,
    Weekly_Sales
FROM dbo.Walmart_Sales_Cleaned
WHERE Weekly_Sales >= 1300000
  AND Weekly_Sales <= 1600000
ORDER BY Weekly_Sales DESC;
GO

/* ================================================================
4. NOT BETWEEN - wartosci poza przedzialem
================================================================ */
SELECT
    Store,
    Date_Sales,
    Weekly_Sales
FROM dbo.Walmart_Sales_Cleaned
WHERE Weekly_Sales NOT BETWEEN 1300000 AND 1600000
ORDER BY Weekly_Sales DESC;
GO

/* ================================================================
5. Zakres dat
================================================================ */

/* BETWEEN - poprawne dla kolumny typu date */
SELECT
    Store,
    Date_Sales,
    Weekly_Sales
FROM dbo.Walmart_Sales_Cleaned
WHERE Date_Sales BETWEEN '2011-01-01' AND '2011-12-31'
ORDER BY Date_Sales ASC;
GO

/* Preferowany wzorzec dla pelnego okresu */
SELECT
    Store,
    Date_Sales,
    Weekly_Sales
FROM dbo.Walmart_Sales_Cleaned
WHERE Date_Sales >= '2011-01-01'
  AND Date_Sales <  '2012-01-01'
ORDER BY Date_Sales ASC;
GO

/* ================================================================
6. LIKE - wzorce tekstowe
================================================================ */
SELECT
    Store,
    Type,
    Size
FROM dbo.Stores_Metadata
WHERE Type LIKE 'A%'
ORDER BY Store ASC;
GO

/* ================================================================
7. IS NULL i IS NOT NULL - kontrola brakow danych
================================================================ */
SELECT
    Store,
    Date_Sales,
    CPI
FROM dbo.Walmart_Sales_Cleaned
WHERE CPI IS NULL;
GO

SELECT
    Store,
    Date_Sales,
    CPI
FROM dbo.Walmart_Sales_Cleaned
WHERE CPI IS NOT NULL
ORDER BY Store ASC, Date_Sales ASC;
GO

/* ================================================================
8. Przyklad laczacy operatory
================================================================ */
SELECT
    Store AS Numer_Sklepu,
    Date_Sales AS Data_Sprzedazy,
    Weekly_Sales AS Sprzedaz_Tygodniowa,
    Holiday_Flag AS Czy_Swieto
FROM dbo.Walmart_Sales_Cleaned
WHERE Store IN (4, 13, 20)
  AND Date_Sales >= '2011-01-01'
  AND Date_Sales <  '2012-01-01'
  AND Weekly_Sales BETWEEN 1300000 AND 2000000
  AND Holiday_Flag = 0
ORDER BY Weekly_Sales DESC;
GO

/* ================================================================
9. CWICZENIA - napisz zapytania samodzielnie
================================================================ */

/*
1. Wyswietl Store, Date_Sales i Weekly_Sales dla sklepow 1, 5, 10 i 15.
2. Znajdz rekordy ze sprzedaza od 900000 do 1100000 wlacznie.
3. Wyswietl dane z pierwszego kwartalu 2012 roku.
4. Wyswietl wszystkie sklepy poza 4, 13 i 20.
5. Sprawdz braki danych w kolumnie Unemployment.
6. W Stores_Metadata wyswietl sklepy typu pasujacego do A%.
*/

SELECT
    Store,
    Date_Sales,
    Weekly_Sales
FROM dbo.Walmart_Sales_Cleaned
WHERE Store IN (1, 5, 10, 15)
ORDER BY Store ASC, Date_Sales ASC;

SELECT
    Store,
    Date_Sales,
    Weekly_Sales
FROM dbo.Walmart_Sales_Cleaned
WHERE Weekly_Sales BETWEEN 900000 AND 1100000
ORDER BY Weekly_Sales DESC;

SELECT
    Store,
    Date_Sales,
    Weekly_Sales
FROM dbo.Walmart_Sales_Cleaned
WHERE Date_Sales >= '2012-01-01'
  AND Date_Sales <  '2012-04-01'
ORDER BY Date_Sales ASC;

SELECT
    Store,
    Date_Sales,
    Weekly_Sales
FROM dbo.Walmart_Sales_Cleaned
WHERE Store NOT IN (4, 13, 20)
ORDER BY Store ASC, Date_Sales ASC;

SELECT
    Store,
    Date_Sales,
    Unemployment
FROM dbo.Walmart_Sales_Cleaned
WHERE Unemployment IS NULL
ORDER BY Store ASC, Date_Sales ASC;


/* ================================================================
10. ZADANIE PRAKTYCZNE
================================================================ */

/*
Przygotuj raport dla sklepow 4, 13 i 20 w 2012 roku.

Wynik:
- Store AS Numer_Sklepu
- Date_Sales AS Data_Sprzedazy
- Weekly_Sales AS Sprzedaz_Tygodniowa
- Temperature AS Temperatura
- Holiday_Flag AS Czy_Swieto

Warunki:
- Store IN (4, 13, 20)
- caly rok 2012
- Weekly_Sales od 1500000 do 2300000 wlacznie
- Temperature IS NOT NULL
- sortowanie Weekly_Sales malejaco, Date_Sales rosnaco
*/

SELECT
    Store AS Numer_Sklepu,
    Date_Sales AS Data_Sprzedazy,
    Weekly_Sales AS Sprzedaz_Tygodniowa,
    Temperature AS Temperatura,
    Holiday_Flag AS Czy_Swieto
FROM dbo.Walmart_Sales_Cleaned
WHERE Store IN (4, 13, 20)
  AND Date_Sales >= '2012-01-01'
  AND Date_Sales <  '2013-01-01'
  AND Weekly_Sales BETWEEN 1500000 AND 2300000
  AND Temperature IS NOT NULL
ORDER BY Weekly_Sales DESC, Date_Sales ASC;


/* ================================================================
11. ZADANIE DOMOWE
================================================================ */

/*
1. Sprzedaz sklepow 2, 7, 12 i 17.
2. Sprzedaz od 1000000 do 1250000 wlacznie.
3. Drugie polrocze 2011 roku - zakres polotwarty.
4. Wszystkie sklepy poza 1, 2 i 3 ze sprzedaza > 1800000.
5. Braki danych w Temperature, CPI i Unemployment.
6. W Stores_Metadata sklepy, ktorych Type NOT LIKE 'A%'.
*/

SELECT
    Store,
    Date_Sales,
    Weekly_Sales
FROM dbo.Walmart_Sales_Cleaned
WHERE Store IN (2, 7, 12, 17)
ORDER BY Store ASC, Date_Sales ASC; 

SELECT
    Store,
    Date_Sales,
    Weekly_Sales
FROM dbo.Walmart_Sales_Cleaned
WHERE Weekly_Sales BETWEEN 1000000 AND 1250000
ORDER BY Weekly_Sales DESC; 

SELECT
    Store,
    Date_Sales,
    Weekly_Sales
FROM dbo.Walmart_Sales_Cleaned
WHERE Date_Sales >= '2011-07-01'
  AND Date_Sales <  '2012-01-01'
ORDER BY Date_Sales ASC;

SELECT
    Store,
    Date_Sales,
    Weekly_Sales
FROM dbo.Walmart_Sales_Cleaned
WHERE Store NOT IN (1, 2, 3)
  AND Weekly_Sales > 1800000
ORDER BY Weekly_Sales DESC;

SELECT
    Store,
    Date_Sales,
    Temperature,
    CPI,
    Unemployment
FROM dbo.Walmart_Sales_Cleaned
WHERE Temperature IS NULL       
   OR CPI IS NULL
   OR Unemployment IS NULL
ORDER BY Store ASC, Date_Sales ASC; 

SELECT
    Store,
    Type,
    Size
FROM dbo.Stores_Metadata
WHERE Type NOT LIKE 'A%'
ORDER BY Store ASC;