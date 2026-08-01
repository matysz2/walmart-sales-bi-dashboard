/*
DZIEN 19 - LAG() I LEAD()
Microsoft SQL Server | Projekt Walmart

Tabela sprzedaży: dbo.Walmart_Sales_Cleaned
Kolumna daty: Date_Sales
Tabela sklepów: dbo.Stores_Metadata
*/

-- 1. LAG(): poprzednia sprzedaż dla każdego sklepu
SELECT
    Store,
    Date_Sales,
    Weekly_Sales,
    LAG(Weekly_Sales) OVER
    (
        PARTITION BY Store
        ORDER BY Date_Sales
    ) AS Previous_Weekly_Sales
FROM dbo.Walmart_Sales_Cleaned
ORDER BY Store, Date_Sales;


-- 2. Wynik kontrolny dla sklepu 1
SELECT
    Store,
    Date_Sales,
    Weekly_Sales,
    LAG(Weekly_Sales) OVER
    (
        PARTITION BY Store
        ORDER BY Date_Sales
    ) AS Previous_Weekly_Sales
FROM dbo.Walmart_Sales_Cleaned
WHERE Store = 1
ORDER BY Date_Sales;


-- 3. LAG() z przesunieciem o dwa rekordy
SELECT
    Store,
    Date_Sales,
    Weekly_Sales,
    LAG(Weekly_Sales, 2) OVER
    (
        PARTITION BY Store
        ORDER BY Date_Sales
    ) AS Sales_Two_Rows_Ago
FROM dbo.Walmart_Sales_Cleaned
WHERE Store = 1
ORDER BY Date_Sales;


-- 4. LEAD(): sprzedaż z następnego rekordu
SELECT
    Store,
    Date_Sales,
    Weekly_Sales,
    LEAD(Weekly_Sales) OVER
    (
        PARTITION BY Store
        ORDER BY Date_Sales
    ) AS Next_Weekly_Sales
FROM dbo.Walmart_Sales_Cleaned
WHERE Store = 1
ORDER BY Date_Sales;


-- 5. LAG() i LEAD() w jednym raporcie
SELECT
    Store,
    Date_Sales,
    Weekly_Sales,
    LAG(Weekly_Sales) OVER
    (
        PARTITION BY Store
        ORDER BY Date_Sales
    ) AS Previous_Weekly_Sales,
    LEAD(Weekly_Sales) OVER
    (
        PARTITION BY Store
        ORDER BY Date_Sales
    ) AS Next_Weekly_Sales
FROM dbo.Walmart_Sales_Cleaned
ORDER BY Store, Date_Sales;


-- 6. Różnica oraz zmiana procentowa względem poprzedniego rekordu
;WITH Sales_With_Previous AS
(
    SELECT
        Store,
        Date_Sales,
        Weekly_Sales,
        LAG(Weekly_Sales) OVER
        (
            PARTITION BY Store
            ORDER BY Date_Sales
        ) AS Previous_Weekly_Sales
    FROM dbo.Walmart_Sales_Cleaned
)
SELECT
    Store,
    Date_Sales,
    Weekly_Sales,
    Previous_Weekly_Sales,
    Weekly_Sales - Previous_Weekly_Sales AS Sales_Difference,
    CAST(
        (Weekly_Sales - Previous_Weekly_Sales) * 100.0
        / NULLIF(Previous_Weekly_Sales, 0)
        AS decimal(10,2)
    ) AS Sales_Change_Pct
FROM Sales_With_Previous
ORDER BY Store, Date_Sales;


-- 7. Klasyfikacja trendu sprzedaży
;WITH Sales_With_Previous AS
(
    SELECT
        Store,
        Date_Sales,
        Weekly_Sales,
        LAG(Weekly_Sales) OVER
        (
            PARTITION BY Store
            ORDER BY Date_Sales
        ) AS Previous_Weekly_Sales
    FROM dbo.Walmart_Sales_Cleaned
)
SELECT
    Store,
    Date_Sales,
    Weekly_Sales,
    Previous_Weekly_Sales,
    Weekly_Sales - Previous_Weekly_Sales AS Sales_Difference,
    CASE
        WHEN Previous_Weekly_Sales IS NULL THEN 'Brak porownania'
        WHEN Weekly_Sales > Previous_Weekly_Sales THEN 'Wzrost'
        WHEN Weekly_Sales < Previous_Weekly_Sales THEN 'Spadek'
        ELSE 'Bez zmian'
    END AS Sales_Trend
FROM Sales_With_Previous
ORDER BY Store, Date_Sales;


-- 8. Filtrowanie po obliczeniu LAG(): zachowuje poprzedni rekord z całej historii
;WITH Sales_With_Previous AS
(
    SELECT
        Store,
        Date_Sales,
        Weekly_Sales,
        LAG(Weekly_Sales) OVER
        (
            PARTITION BY Store
            ORDER BY Date_Sales
        ) AS Previous_Weekly_Sales
    FROM dbo.Walmart_Sales_Cleaned
)
SELECT
    Store,
    Date_Sales,
    Weekly_Sales,
    Previous_Weekly_Sales
FROM Sales_With_Previous
WHERE YEAR(Date_Sales) = 2011
ORDER BY Store, Date_Sales;


-- 9. Duże spadki sprzedaży: więcej niż 10 procent
;WITH Sales_With_Previous AS
(
    SELECT
        Store,
        Date_Sales,
        Weekly_Sales,
        LAG(Weekly_Sales) OVER
        (
            PARTITION BY Store
            ORDER BY Date_Sales
        ) AS Previous_Weekly_Sales
    FROM dbo.Walmart_Sales_Cleaned
),
Sales_Changes AS
(
    SELECT
        Store,
        Date_Sales,
        Weekly_Sales,
        Previous_Weekly_Sales,
        CAST(
            (Weekly_Sales - Previous_Weekly_Sales) * 100.0
            / NULLIF(Previous_Weekly_Sales, 0)
            AS decimal(10,2)
        ) AS Sales_Change_Pct
    FROM Sales_With_Previous
)
SELECT *
FROM Sales_Changes
WHERE Sales_Change_Pct < -10
ORDER BY Sales_Change_Pct ASC;


-- 10. Zadanie praktyczne: raport dynamiki z charakterystyką sklepu
;WITH Sales_With_Previous AS
(
    SELECT
        Store,
        Date_Sales,
        Weekly_Sales,
        LAG(Weekly_Sales) OVER
        (
            PARTITION BY Store
            ORDER BY Date_Sales
        ) AS Previous_Weekly_Sales
    FROM dbo.Walmart_Sales_Cleaned
),
Sales_Report AS
(
    SELECT
        Store,
        Date_Sales,
        Weekly_Sales,
        Previous_Weekly_Sales,
        Weekly_Sales - Previous_Weekly_Sales AS Sales_Difference,
        CAST(
            (Weekly_Sales - Previous_Weekly_Sales) * 100.0
            / NULLIF(Previous_Weekly_Sales, 0)
            AS decimal(10,2)
        ) AS Sales_Change_Pct,
        CASE
            WHEN Previous_Weekly_Sales IS NULL THEN 'Brak porownania'
            WHEN Weekly_Sales > Previous_Weekly_Sales THEN 'Wzrost'
            WHEN Weekly_Sales < Previous_Weekly_Sales THEN 'Spadek'
            ELSE 'Bez zmian'
        END AS Sales_Trend
    FROM Sales_With_Previous
)
SELECT
    sr.Store,
    sm.Type,
    sm.Size,
    sr.Date_Sales,
    sr.Weekly_Sales,
    sr.Previous_Weekly_Sales,
    sr.Sales_Difference,
    sr.Sales_Change_Pct,
    sr.Sales_Trend
FROM Sales_Report AS sr
INNER JOIN dbo.Stores_Metadata AS sm
    ON sr.Store = sm.Store
ORDER BY sr.Store, sr.Date_Sales;




--1. Pokaż poprzednią sprzedaż dla Store = 5.
SELECT 
Store,
Date_Sales,
Weekly_Sales,
LAG(Weekly_Sales) OVER
(
    PARTITION BY Store
    ORDER BY Date_Sales
) AS Previous_Weekly_Sales
FROM dbo.Walmart_Sales_Cleaned
WHERE Store = 5
ORDER BY Date_Sales;
--2. Pokaż sprzedaż sprzed dwóch rekordów dla Store = 10.
SELECT 
Store,
Date_Sales,
Weekly_Sales,
LAG(Weekly_Sales, 2) OVER
(
    PARTITION BY Store
    ORDER BY Date_Sales
) AS Sales_Two_Rows_Ago
FROM dbo.Walmart_Sales_Cleaned
WHERE Store = 10
ORDER BY Date_Sales;
--3. Pokaż następny rekord sprzedaży dla każdego sklepu.
SELECT 
    Store,
    Date_Sales,
    Weekly_Sales,
    LEAD(Weekly_Sales) OVER(PARTITION BY Store ORDER BY Date_Sales) AS Next_Weekly_Sales
FROM dbo.Walmart_Sales_Cleaned
ORDER BY Store, Date_Sales;

-- 4. Oblicz zmianę kwotową i procentową.
SELECT 
    Store,
    Date_Sales,
    Weekly_Sales,
    LAG(Weekly_Sales) OVER(PARTITION BY Store ORDER BY Date_Sales) AS Previous_Weekly_Sales,
    Weekly_Sales - LAG(Weekly_Sales) OVER(PARTITION BY Store ORDER BY Date_Sales) AS Sales_Difference,
    CAST(
        (Weekly_Sales - LAG(Weekly_Sales) OVER(PARTITION BY Store ORDER BY Date_Sales)) * 100.0 
        / NULLIF(LAG(Weekly_Sales) OVER(PARTITION BY Store ORDER BY Date_Sales), 0) 
        AS DECIMAL(10,2)
    ) AS Sales_Change_Pct
FROM dbo.Walmart_Sales_Cleaned
ORDER BY Store, Date_Sales;

--5. Wybierz rekordy ze spadkiem większym niż 15 procent.
SELECT 
Store,
Date_Sales,
Weekly_Sales,
LAG(Weekly_Sales) OVER
(
    PARTITION BY Store
    ORDER BY Date_Sales
) AS Previous_Weekly_Sales,
Weekly_Sales - LAG(Weekly_Sales) OVER
(
    PARTITION BY Store
    ORDER BY Date_Sales
) AS Sales_Difference,
CAST(
    (Weekly_Sales - LAG(Weekly_Sales) OVER
    (
        PARTITION BY Store
        ORDER BY Date_Sales
    )) * 100.0
    / NULLIF(LAG(Weekly_Sales) OVER
    (
        PARTITION BY Store
        ORDER BY Date_Sales
    ), 0)
    AS decimal(10,2)
) AS Sales_Change_Pct
FROM dbo.Walmart_Sales_Cleaned
WHERE CAST(
    (Weekly_Sales - LAG(Weekly_Sales) OVER
    (
        PARTITION BY Store
        ORDER BY Date_Sales
    )) * 100.0
    / NULLIF(LAG(Weekly_Sales) OVER
    (
        PARTITION BY Store  
        ORDER BY Date_Sales
    ), 0)
    AS decimal(10,2)
) < -15
ORDER BY Store, Date_Sales; 
--6. Zbuduj raport tylko dla 2012 roku, ale policz LAG() przed filtrem roku.
select
    Store,
    Date_Sales,
    Weekly_Sales,
    LAG(Weekly_Sales) OVER
    (
        PARTITION BY Store
        ORDER BY Date_Sales
    ) AS Previous_Weekly_Sales,
    Weekly_Sales - LAG(Weekly_Sales) OVER
    (
        PARTITION BY Store
        ORDER BY Date_Sales
    ) AS Sales_Difference,
    CAST(
        (Weekly_Sales - LAG(Weekly_Sales) OVER
        (
            PARTITION BY Store
            ORDER BY Date_Sales
        )) * 100.0
        / NULLIF(LAG(Weekly_Sales) OVER
        (
            PARTITION BY Store
            ORDER BY Date_Sales
        ), 0)
        AS decimal(10,2)
    ) AS Sales_Change_Pct
from dbo.Walmart_Sales_Cleaned
where YEAR(Date_Sales) = 2012
order by Store, Date_Sales; 
--7. Dołącz Type i Size z dbo.Stores_Metadata.
SELECT
    sr.Store,
    sm.Type,
    sm.Size,
    sr.Date_Sales,
    sr.Weekly_Sales,
    sr.Previous_Weekly_Sales,
    sr.Sales_Difference,
    sr.Sales_Change_Pct
FROM
(
    SELECT
        Store,
        Date_Sales,
        Weekly_Sales,
        LAG(Weekly_Sales) OVER
        (
            PARTITION BY Store
            ORDER BY Date_Sales
        ) AS Previous_Weekly_Sales,
        Weekly_Sales - LAG(Weekly_Sales) OVER
        (
            PARTITION BY Store
            ORDER BY Date_Sales
        ) AS Sales_Difference,
        CAST(
            (Weekly_Sales - LAG(Weekly_Sales) OVER
            (
                PARTITION BY Store
                ORDER BY Date_Sales
            )) * 100.0
            / NULLIF(LAG(Weekly_Sales) OVER
            (
                PARTITION BY Store
                ORDER BY Date_Sales
            ), 0)
            AS decimal(10,2)
        ) AS Sales_Change_Pct
    FROM dbo.Walmart_Sales_Cleaned
) AS sr
INNER JOIN dbo.Stores_Metadata AS sm
    ON sr.Store = sm.Store
ORDER BY sr.Store, sr.Date_Sales;   