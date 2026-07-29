USE TreningData;
GO

/*
DZIEN 7 - CASE
Projekt: Walmart Sales
Temat: klasyfikacja danych i agregacja warunkowa
*/

-- 1. CASE prosty - zamiana flagi 0/1 na opis
SELECT TOP (20)
    Store AS Numer_Sklepu,
    Date_Sales AS Data_Sprzedazy,
    Weekly_Sales AS Sprzedaz_Tygodniowa,
    CASE Holiday_Flag
        WHEN 1 THEN 'Tak'
        WHEN 0 THEN 'Nie'
        ELSE 'Brak danych'
    END AS Czy_Swieto
FROM dbo.Walmart_Sales_Cleaned
ORDER BY Weekly_Sales DESC;
GO

-- 2. CASE WHEN - klasyfikacja sprzedazy
SELECT
    Store AS Numer_Sklepu,
    Date_Sales AS Data_Sprzedazy,
    Weekly_Sales AS Sprzedaz_Tygodniowa,
    CASE
        WHEN Weekly_Sales >= 2000000 THEN 'Bardzo wysoka'
        WHEN Weekly_Sales >= 1500000 THEN 'Wysoka'
        WHEN Weekly_Sales >= 1000000 THEN 'Srednia'
        ELSE 'Niska'
    END AS Kategoria_Sprzedazy
FROM dbo.Walmart_Sales_Cleaned
ORDER BY Weekly_Sales DESC;
GO

-- 3. Klasyfikacja temperatury
SELECT
    Store,
    Date_Sales,
    Temperature,
    CASE
        WHEN Temperature < 32 THEN 'Mroz'
        WHEN Temperature < 60 THEN 'Chlodno'
        ELSE 'Cieplo'
    END AS Poziom_Temperatury
FROM dbo.Walmart_Sales_Cleaned
ORDER BY Temperature ASC;
GO

-- 4. Agregacja warunkowa - sprzedaz swiateczna i nieswiateczna
SELECT
    Store AS Numer_Sklepu,
    SUM(
        CASE
            WHEN Holiday_Flag = 1 THEN Weekly_Sales
            ELSE 0
        END
    ) AS Sprzedaz_Swiateczna,
    SUM(
        CASE
            WHEN Holiday_Flag = 0 THEN Weekly_Sales
            ELSE 0
        END
    ) AS Sprzedaz_Nieswiateczna
FROM dbo.Walmart_Sales_Cleaned
GROUP BY Store
ORDER BY Sprzedaz_Swiateczna DESC;
GO

-- 5. Liczba tygodni swiatecznych
SELECT
    Store AS Numer_Sklepu,
    SUM(
        CASE
            WHEN Holiday_Flag = 1 THEN 1
            ELSE 0
        END
    ) AS Liczba_Tygodni_Swiatecznych
FROM dbo.Walmart_Sales_Cleaned
GROUP BY Store
ORDER BY Store ASC;
GO

/*
ZADANIE PRAKTYCZNE

Przygotuj raport klasyfikacji sklepow za caly rok 2012.

Wynik:
- Store AS Numer_Sklepu
- COUNT(*) AS Liczba_Tygodni
- SUM(Weekly_Sales) AS Sprzedaz_Laczna
- AVG(Weekly_Sales) AS Srednia_Sprzedaz
- CASE ... END AS Poziom_Sklepu

Klasyfikacja:
- AVG(Weekly_Sales) >= 1800000 -> Bardzo wysoka
- AVG(Weekly_Sales) >= 1400000 -> Wysoka
- AVG(Weekly_Sales) >= 1000000 -> Srednia
- pozostale -> Niska

Warunki:
- caly rok 2012
- GROUP BY Store
- ORDER BY Sprzedaz_Laczna DESC
- bez TOP

Kontrola:
- 45 sklepow
- pierwszy sklep: 4
- poziom sklepu 4: Bardzo wysoka
*/

-- Napisz rozwiazanie ponizej:

SELECT
    Store AS Numer_Sklepu,
    COUNT(*) AS Liczba_Tygodni,
    SUM(Weekly_Sales) AS Sprzedaz_Laczna,
    AVG(Weekly_Sales) AS Srednia_Sprzedaz,
    CASE
        WHEN AVG(Weekly_Sales) >= 1800000 THEN 'Bardzo wysoka'
        WHEN AVG(Weekly_Sales) >= 1400000 THEN 'Wysoka'
        WHEN AVG(Weekly_Sales) >= 1000000 THEN 'Srednia'
        ELSE 'Niska'
    END AS Poziom_Sklepu
FROM dbo.Walmart_Sales_Cleaned
WHERE Date_Sales >= '2012-01-01'
  AND Date_Sales <  '2013-01-01'
GROUP BY Store
ORDER BY Sprzedaz_Laczna DESC;

/*
ZADANIE DOMOWE

1. Klasyfikacja tygodniowej sprzedazy:
   >= 2000000 Premium
   >= 1500000 Wysoka
   >= 1000000 Standard
   pozostale Niska

2. Dla kazdego sklepu w 2011 roku:
   Sprzedaz_Laczna >= 80000000 -> Cel osiagniety
   pozostale -> Ponizej celu

3. Policz liczbe tygodni swiatecznych i nieswiatecznych przez SUM(CASE...).

4. Policz sprzedaz swiateczna i nieswiateczna dla kazdego sklepu.
*/

SELECT
    Store AS Numer_Sklepu,
    Date_Sales AS Data_Sprzedazy,
    Weekly_Sales AS Sprzedaz_Tygodniowa,
    CASE
        WHEN Weekly_Sales >= 2000000 THEN 'Premium'
        WHEN Weekly_Sales >= 1500000 THEN 'Wysoka'
        WHEN Weekly_Sales >= 1000000 THEN 'Standard'
        ELSE 'Niska'
    END AS Kategoria_Sprzedazy
FROM dbo.Walmart_Sales_Cleaned
ORDER BY Weekly_Sales DESC;

SELECT
    Store AS Numer_Sklepu,
    Date_Sales AS Data_Sprzedazy,
    Weekly_Sales AS Sprzedaz_Tygodniowa,
    CASE
        WHEN Date_Sales >= '2011-01-01' AND Date_Sales < '2012-01-01' THEN
            CASE
                WHEN SUM(Weekly_Sales) OVER (PARTITION BY Store) >= 80000000 THEN 'Cel osiagniety'
                ELSE 'Ponizej celu'
            END
        ELSE 'Brak danych'
    END AS Status_Celu
FROM dbo.Walmart_Sales_Cleaned
ORDER BY Store ASC, Date_Sales ASC; 

SELECT
    Store AS Numer_Sklepu,
    SUM(
        CASE
            WHEN Holiday_Flag = 1 THEN 1
            ELSE 0
        END
    ) AS Liczba_Tygodni_Swiatecznych,
    SUM(
        CASE
            WHEN Holiday_Flag = 0 THEN 1
            ELSE 0
        END
    ) AS Liczba_Tygodni_Nieswiatecznych
FROM dbo.Walmart_Sales_Cleaned
GROUP BY Store
ORDER BY Store ASC;

SELECT
    Store AS Numer_Sklepu,
    SUM(
        CASE
            WHEN Holiday_Flag = 1 THEN Weekly_Sales
            ELSE 0
        END
    ) AS Sprzedaz_Swiateczna,
    SUM(
        CASE
            WHEN Holiday_Flag = 0 THEN Weekly_Sales
            ELSE 0
        END
    ) AS Sprzedaz_Nieswiateczna
FROM dbo.Walmart_Sales_Cleaned
GROUP BY Store
ORDER BY Store ASC;