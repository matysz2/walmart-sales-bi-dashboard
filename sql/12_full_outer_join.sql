USE TreningData;
GO

/*
DZIEN 12 - FULL OUTER JOIN
Projekt: Walmart Sales
Temat: zachowanie wszystkich rekordow z obu tabel
*/

-- 1. Podstawowy FULL OUTER JOIN
SELECT
    COALESCE(sm.Store, ws.Store) AS Numer_Sklepu,
    sm.Type AS Typ_Sklepu,
    sm.Size AS Powierzchnia,
    ws.Date_Sales AS Data_Sprzedazy,
    ws.Weekly_Sales AS Sprzedaz_Tygodniowa
FROM dbo.Walmart_Sales_Cleaned AS ws
FULL OUTER JOIN dbo.Stores_Metadata AS sm
    ON ws.Store = sm.Store
ORDER BY
    COALESCE(sm.Store, ws.Store),
    ws.Date_Sales;
GO

-- 2. Rekordy bez dopasowania po dowolnej stronie
SELECT
    ws.Store AS Store_Ze_Sprzedazy,
    sm.Store AS Store_Z_Metadanych,
    sm.Type,
    sm.Size
FROM dbo.Walmart_Sales_Cleaned AS ws
FULL OUTER JOIN dbo.Stores_Metadata AS sm
    ON ws.Store = sm.Store
WHERE ws.Store IS NULL
   OR sm.Store IS NULL;
GO

-- Na obecnych danych wynik powinien miec 0 wierszy.

-- 3. Raport statusu dopasowania
SELECT
    COALESCE(sm.Store, ws.Store) AS Numer_Sklepu,
    sm.Type AS Typ_Sklepu,
    sm.Size AS Powierzchnia,
    COUNT(ws.Date_Sales) AS Liczba_Tygodni,
    COALESCE(SUM(ws.Weekly_Sales), 0) AS Sprzedaz_Laczna,
    CASE
        WHEN ws.Store IS NULL THEN 'Brak sprzedazy'
        WHEN sm.Store IS NULL THEN 'Brak metadanych'
        ELSE 'Dopasowany'
    END AS Status_Dopasowania
FROM dbo.Walmart_Sales_Cleaned AS ws
FULL OUTER JOIN dbo.Stores_Metadata AS sm
    ON ws.Store = sm.Store
GROUP BY
    COALESCE(sm.Store, ws.Store),
    sm.Store,
    ws.Store,
    sm.Type,
    sm.Size
ORDER BY Numer_Sklepu;
GO

/*
ZADANIE PRAKTYCZNE

Przygotuj raport kontroli spojnosci tabel.

Wynik:
- COALESCE(sm.Store, ws.Store) AS Numer_Sklepu
- sm.Type AS Typ_Sklepu
- sm.Size AS Powierzchnia
- COUNT(ws.Date_Sales) AS Liczba_Tygodni
- COALESCE(SUM(ws.Weekly_Sales), 0) AS Sprzedaz_Laczna
- CASE ... END AS Status_Dopasowania

Klasyfikacja:
- ws.Store IS NULL -> Brak sprzedazy
- sm.Store IS NULL -> Brak metadanych
- pozostale -> Dopasowany

Warunki:
- FULL OUTER JOIN po Store
- GROUP BY COALESCE(sm.Store, ws.Store), sm.Store, ws.Store, sm.Type, sm.Size
- ORDER BY Numer_Sklepu
- bez filtra roku

Kontrola:
- 45 wierszy
- wszystkie statusy: Dopasowany
- kazdy sklep: 143 tygodnie
*/

-- Napisz rozwiazanie ponizej:



SELECT
    COALESCE(sm.Store, ws.Store) AS Numer_Sklepu,
    sm.Type AS Typ_Sklepu,
    sm.Size AS Powierzchnia,
    COUNT(ws.Date_Sales) AS Liczba_Tygodni,
    COALESCE(SUM(ws.Weekly_Sales), 0) AS Sprzedaz_Laczna,
    CASE
        WHEN ws.Store IS NULL THEN 'Brak sprzedazy'
        WHEN sm.Store IS NULL THEN 'Brak metadanych'
        ELSE 'Dopasowany'
    END AS Status_Dopasowania
FROM dbo.Walmart_Sales_Cleaned AS ws
FULL OUTER JOIN dbo.Stores_Metadata AS sm
    ON ws.Store = sm.Store
GROUP BY
    COALESCE(sm.Store, ws.Store),
    sm.Store,
    ws.Store,
    sm.Type,
    sm.Size
ORDER BY Numer_Sklepu;
GO


/*
ZADANIE DOMOWE

1. Pokaz ws.Store i sm.Store oddzielnie po FULL OUTER JOIN.
2. Dodaj Numer_Sklepu przez COALESCE.
3. Pokaz tylko rekordy bez dopasowania po dowolnej stronie.
4. Przygotuj podsumowanie liczby sklepow wedlug Status_Dopasowania.
*/

SELECT DISTINCT
    ws.Store AS Store_Ze_Sprzedazy,
    sm.Store AS Store_Z_Metadanych,
    COALESCE(sm.Store, ws.Store) AS Numer_Sklepu
FROM dbo.Walmart_Sales_Cleaned AS ws
FULL OUTER JOIN dbo.Stores_Metadata AS sm
    ON ws.Store = sm.Store
WHERE ws.Store IS NULL
   OR sm.Store IS NULL
ORDER BY Numer_Sklepu;

SELECT DISTINCT
    ws.Store AS Store_Ze_Sprzedazy,
    sm.Store AS Store_Z_Metadanych,
    COALESCE(ws.Store, sm.Store) AS Numer_Sklepu
FROM dbo.Walmart_Sales_Cleaned AS ws
FULL OUTER JOIN dbo.Stores_Metadata AS sm
    ON ws.Store = sm.Store
ORDER BY Numer_Sklepu;

SELECT DISTINCT
    ws.Store AS Store_Ze_Sprzedazy,
    sm.Store AS Store_Z_Metadanych,
    COALESCE(ws.Store, sm.Store) AS Numer_Sklepu,
    CASE
        WHEN ws.Store IS NOT NULL
         AND sm.Store IS NULL
            THEN 'Tylko w sprzedaży'

        WHEN ws.Store IS NULL
         AND sm.Store IS NOT NULL
            THEN 'Tylko w metadanych'
    END AS Status_Dopasowania
FROM dbo.Walmart_Sales_Cleaned AS ws
FULL OUTER JOIN dbo.Stores_Metadata AS sm
    ON ws.Store = sm.Store
WHERE ws.Store IS NULL
   OR sm.Store IS NULL
ORDER BY Numer_Sklepu;

SELECT
    CASE
        WHEN ws.Store IS NOT NULL
         AND sm.Store IS NOT NULL
            THEN 'Dopasowany'

        WHEN ws.Store IS NOT NULL
         AND sm.Store IS NULL
            THEN 'Tylko w sprzedaży'

        WHEN ws.Store IS NULL
         AND sm.Store IS NOT NULL
            THEN 'Tylko w metadanych'
    END AS Status_Dopasowania,

    COUNT(
        DISTINCT COALESCE(ws.Store, sm.Store)
    ) AS Liczba_Sklepow

FROM dbo.Walmart_Sales_Cleaned AS ws
FULL OUTER JOIN dbo.Stores_Metadata AS sm
    ON ws.Store = sm.Store

GROUP BY
    CASE
        WHEN ws.Store IS NOT NULL
         AND sm.Store IS NOT NULL
            THEN 'Dopasowany'

        WHEN ws.Store IS NOT NULL
         AND sm.Store IS NULL
            THEN 'Tylko w sprzedaży'

        WHEN ws.Store IS NULL
         AND sm.Store IS NOT NULL
            THEN 'Tylko w metadanych'
    END

ORDER BY Status_Dopasowania;