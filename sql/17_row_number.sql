/*
Dzien 17 - ROW_NUMBER w SQL Server
Tabela: dbo.Walmart_Sales_Cleaned
Kolumna daty: Date_Sales
*/

-- 1. Numeracja tygodni od najwyzszej sprzedazy w calej firmie
SELECT
    Store,
    Date_Sales,
    Weekly_Sales,
    ROW_NUMBER() OVER
    (
        ORDER BY Weekly_Sales DESC,
                 Store ASC,
                 Date_Sales ASC
    ) AS Company_Sales_Row
FROM dbo.Walmart_Sales_Cleaned
ORDER BY Company_Sales_Row;


-- 2. Numeracja sprzedazy osobno dla kazdego sklepu
SELECT
    Store,
    Date_Sales,
    Weekly_Sales,
    ROW_NUMBER() OVER
    (
        PARTITION BY Store
        ORDER BY Weekly_Sales DESC,
                 Date_Sales ASC
    ) AS Store_Sales_Row
FROM dbo.Walmart_Sales_Cleaned
ORDER BY Store, Store_Sales_Row;


-- 3. Trzy najlepsze tygodnie kazdego sklepu
;WITH Ranked_Sales AS
(
    SELECT
        Store,
        Date_Sales,
        Weekly_Sales,
        ROW_NUMBER() OVER
        (
            PARTITION BY Store
            ORDER BY Weekly_Sales DESC,
                     Date_Sales ASC
        ) AS Store_Sales_Row
    FROM dbo.Walmart_Sales_Cleaned
)
SELECT
    Store,
    Date_Sales,
    Weekly_Sales,
    Store_Sales_Row
FROM Ranked_Sales
WHERE Store_Sales_Row <= 3
ORDER BY Store, Store_Sales_Row;


-- 4. Najnowszy rekord kazdego sklepu
;WITH Latest_Sales AS
(
    SELECT
        Store,
        Date_Sales,
        Weekly_Sales,
        ROW_NUMBER() OVER
        (
            PARTITION BY Store
            ORDER BY Date_Sales DESC,
                     Weekly_Sales DESC
        ) AS Latest_Row
    FROM dbo.Walmart_Sales_Cleaned
)
SELECT
    Store,
    Date_Sales,
    Weekly_Sales
FROM Latest_Sales
WHERE Latest_Row = 1
ORDER BY Store;


-- 5. Najlepszy tydzien kazdego sklepu z typem i powierzchnia
;WITH Best_Week AS
(
    SELECT
        Store,
        Date_Sales,
        Weekly_Sales,
        ROW_NUMBER() OVER
        (
            PARTITION BY Store
            ORDER BY Weekly_Sales DESC,
                     Date_Sales ASC
        ) AS Sales_Row
    FROM dbo.Walmart_Sales_Cleaned
)
SELECT
    b.Store,
    s.Type,
    s.Size,
    b.Date_Sales,
    b.Weekly_Sales
FROM Best_Week AS b
INNER JOIN dbo.Stores_Metadata AS s
    ON b.Store = s.Store
WHERE b.Sales_Row = 1
ORDER BY b.Weekly_Sales DESC;


-- 6. Cwiczenie 1: numeracja od najstarszej daty
SELECT
    Store,
    Date_Sales,
    Weekly_Sales,
    ROW_NUMBER() OVER
    (
        ORDER BY Date_Sales ASC,
                 Store ASC
    ) AS Chronological_Row
FROM dbo.Walmart_Sales_Cleaned
ORDER BY Chronological_Row;


-- 7. Cwiczenie 2: numeracja od najnizszej sprzedazy w sklepie
SELECT
    Store,
    Date_Sales,
    Weekly_Sales,
    ROW_NUMBER() OVER
    (
        PARTITION BY Store
        ORDER BY Weekly_Sales ASC,
                 Date_Sales ASC
    ) AS Lowest_Sales_Row
FROM dbo.Walmart_Sales_Cleaned
ORDER BY Store, Lowest_Sales_Row;


-- 8. Cwiczenie 3: dwa najlepsze tygodnie kazdego sklepu
;WITH Ranked_Sales AS
(
    SELECT
        Store,
        Date_Sales,
        Weekly_Sales,
        ROW_NUMBER() OVER
        (
            PARTITION BY Store
            ORDER BY Weekly_Sales DESC,
                     Date_Sales ASC
        ) AS Sales_Row
    FROM dbo.Walmart_Sales_Cleaned
)
SELECT
    Store,
    Date_Sales,
    Weekly_Sales,
    Sales_Row
FROM Ranked_Sales
WHERE Sales_Row <= 2
ORDER BY Store, Sales_Row;


-- 9. Zadanie praktyczne: Top 5 tygodni na sklep w 2011 roku
;WITH Sales_2011 AS
(
    SELECT
        w.Store,
        s.Type,
        s.Size,
        w.Date_Sales,
        w.Weekly_Sales
    FROM dbo.Walmart_Sales_Cleaned AS w
    INNER JOIN dbo.Stores_Metadata AS s
        ON w.Store = s.Store
    WHERE YEAR(w.Date_Sales) = 2011
),
Ranked_Sales AS
(
    SELECT
        Store,
        Type,
        Size,
        Date_Sales,
        Weekly_Sales,
        ROW_NUMBER() OVER
        (
            PARTITION BY Store
            ORDER BY Weekly_Sales DESC,
                     Date_Sales ASC
        ) AS Sales_Position
    FROM Sales_2011
)
SELECT
    Store,
    Type,
    Size,
    Date_Sales,
    Weekly_Sales,
    Sales_Position
FROM Ranked_Sales
WHERE Sales_Position <= 5
ORDER BY Store, Sales_Position;


-- 10. Zadanie domowe: piec najlepszych tygodni dla kazdego typu sklepu w 2011 roku
;WITH Sales_With_Type AS
(
    SELECT
        s.Type,
        w.Store,
        w.Date_Sales,
        w.Weekly_Sales
    FROM dbo.Walmart_Sales_Cleaned AS w
    INNER JOIN dbo.Stores_Metadata AS s
        ON w.Store = s.Store
    WHERE YEAR(w.Date_Sales) = 2011
),
Ranked_By_Type AS
(
    SELECT
        Type,
        Store,
        Date_Sales,
        Weekly_Sales,
        ROW_NUMBER() OVER
        (
            PARTITION BY Type
            ORDER BY Weekly_Sales DESC,
                     Store ASC,
                     Date_Sales ASC
        ) AS Type_Sales_Row
    FROM Sales_With_Type
)
SELECT
    Type,
    Store,
    Date_Sales,
    Weekly_Sales,
    Type_Sales_Row
FROM Ranked_By_Type
WHERE Type_Sales_Row <= 5
ORDER BY Type, Type_Sales_Row;
