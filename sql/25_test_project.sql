/* 
Zadanie 1. Audyt danych - 5 pkt
Napisz trzy zapytania kontrolne:
podsumowanie: Records_Count, Stores_Count, Date_From, Date_To, Total_Sales, Avg_Weekly_Sales;
wyszukanie duplikatów Store + Date_Sales;
wyszukanie sklepów sprzedażowych bez odpowiednika w dbo.Stores_Metadata.
Wyniki kontrolne: 6435 rekordów, 45 sklepów, zakres 2010-02-05 - 2012-10-26, 0 duplikatów i 0 brakujących sklepów w
metadanych.
*/

/*
Jedno zapytanie kontrolne, które łączy:
- podsumowanie sprzedaży (liczba rekordów, liczba sklepów, zakres dat, suma i średnia sprzedaży),
- wykrywanie duplikatów pary Store + Date,
- sprawdzenie sklepów w sprzedaży bez odpowiednika w dbo.Stores_Metadata.
*/
WITH Sales_Base AS (
    SELECT
        Date_Sales AS Sale_Date,
        Store,
        CAST(Weekly_Sales AS decimal(12, 2)) AS Weekly_Sales
    FROM dbo.Walmart_Sales_Cleaned
),
Summary AS (
    SELECT
        COUNT(*) AS Records_Count,
        COUNT(DISTINCT Store) AS Stores_Count,
        MIN(Sale_Date) AS Date_From,
        MAX(Sale_Date) AS Date_To,
        SUM(Weekly_Sales) AS Total_Sales,
        AVG(Weekly_Sales) AS Avg_Weekly_Sales
    FROM Sales_Base
),
Duplicate_Check AS (
    SELECT
        COUNT(*) AS Duplicate_Count
    FROM (
        SELECT
            Store,
            Sale_Date
        FROM Sales_Base
        GROUP BY Store, Sale_Date
        HAVING COUNT(*) > 1
    ) AS d
),
Missing_Stores AS (
    SELECT
        COUNT(*) AS Missing_Stores_Count
    FROM (
        SELECT DISTINCT
            s.Store
        FROM Sales_Base AS sb
        LEFT JOIN dbo.Stores_Metadata AS s
            ON sb.Store = s.Store
        WHERE s.Store IS NULL
    ) AS m
)
SELECT
    s.Records_Count,
    s.Stores_Count,
    s.Date_From,
    s.Date_To,
    s.Total_Sales,
    s.Avg_Weekly_Sales,
    d.Duplicate_Count AS Duplicate_Store_Date_Count,
    m.Missing_Stores_Count AS Missing_Stores_In_Metadata
FROM Summary AS s
CROSS JOIN Duplicate_Check AS d
CROSS JOIN Missing_Stores AS m;

/*
 Zadanie 2. KPI według typu sklepu - 6 pkt
Przygotuj raport na poziomie Type. Wynik ma zawierać:
 Type, Stores_Count, Weeks_Count, Total_Sales i Avg_Weekly_Sales;
 Avg_Holiday_Sales i Avg_NonHoliday_Sales przy użyciu agregacji warunkowej;
 sortowanie od najwyższej Total_Sales 
 */
SELECT
    m.Type,
    COUNT(DISTINCT s.Store) AS Stores_Count,
    COUNT(*) AS Weeks_Count,
    SUM(s.Weekly_Sales) AS Total_Sales,
    AVG(s.Weekly_Sales) AS Avg_Weekly_Sales,
    AVG(CASE WHEN s.Holiday_Flag = 1 THEN s.Weekly_Sales END) AS Avg_Holiday_Sales,
    AVG(CASE WHEN s.Holiday_Flag = 0 THEN s.Weekly_Sales END) AS Avg_NonHoliday_Sales
FROM dbo.Walmart_Sales_Cleaned AS s
JOIN dbo.Stores_Metadata AS m
    ON s.Store = m.Store
GROUP BY m.Type
ORDER BY Total_Sales DESC;

 /* Zadanie 3. Ranking sklepów - 7 pkt
Utwórz CTE Store_Summary. Najpierw zagreguj sprzedaż do jednego rekordu na sklep, a następnie pokaż:
Store, Type, Size, Weeks_Count, Total_Sales i Avg_Weekly_Sales;
Company_Rank - ranking wszystkich sklepów według Total_Sales;
Type_Rank - ranking sklepu wewnątrz jego typu;
tylko pięć najlepszych sklepów całej firmy.
Nie rankinguj pojedynczych tygodni. Ranking ma dotyczyć zagregowanych wyników sklepów.
*/
WITH Store_Summary AS (
    SELECT
        s.Store,
        m.Type,
        m.Size,
        COUNT(*) AS Weeks_Count,
        SUM(s.Weekly_Sales) AS Total_Sales,
        AVG(s.Weekly_Sales) AS Avg_Weekly_Sales
    FROM dbo.Walmart_Sales_Cleaned AS s
    JOIN dbo.Stores_Metadata AS m
        ON s.Store = m.Store
    GROUP BY s.Store, m.Type, m.Size
)
SELECT TOP (5)
    Store,
    Type,
    Size,
    Weeks_Count,
    Total_Sales,
    Avg_Weekly_Sales,
    RANK() OVER (ORDER BY Total_Sales DESC) AS Company_Rank,
    RANK() OVER (PARTITION BY Type ORDER BY Total_Sales DESC) AS Type_Rank
FROM Store_Summary
ORDER BY Total_Sales DESC;

/*
Zadanie 4. Trzy najlepsze tygodnie każdego sklepu - 6 pkt
Zwróć dokładnie trzy rekordy na każdy sklep. Wynik:
Store, Type, Date_Sales, Weekly_Sales, Holiday_Flag i Sales_Row;
numeracja osobno dla każdego Store;
sprzedaż malejąco, a przy remisie wcześniejsza data jako pierwsza;
sortowanie końcowe według Store i Sales_Row. 
*/
WITH Ranked_Weeks AS (
    SELECT
        s.Store,
        m.Type,
        s.Date_Sales,
        s.Weekly_Sales,
        s.Holiday_Flag,
        ROW_NUMBER() OVER (
            PARTITION BY s.Store
            ORDER BY s.Weekly_Sales DESC, s.Date_Sales ASC
        ) AS Sales_Row
    FROM dbo.Walmart_Sales_Cleaned AS s
    JOIN dbo.Stores_Metadata AS m
        ON s.Store = m.Store
)
SELECT
    Store,
    Type,
    Date_Sales,
    Weekly_Sales,
    Holiday_Flag,
    Sales_Row
FROM Ranked_Weeks
WHERE Sales_Row <= 3
ORDER BY Store, Sales_Row;

/*
Zadanie 5. Zmiana tydzień do tygodnia - 8 pkt
Dla sklepu 20 pokaż wyniki z 2011 roku:
Date_Sales, Weekly_Sales i Previous_Weekly_Sales;
Sales_Change oraz Sales_Change_Pct;
Trend_Status: Wzrost, Spadek, Bez zmiany lub Brak porównania;
ochronę przed dzieleniem przez zero przez NULLIF().
Warunek: Najpierw oblicz LAG() na pełnej historii sklepu, a dopiero w zapytaniu zewnętrznym ogranicz wynik do
2011 roku. Dzięki temu pierwszy rekord 2011 może zobaczyć ostatni rekord 2010.

*/
WITH Sales_With_Previous AS (
    SELECT
        Store,
        Date_Sales,
        Weekly_Sales,
        LAG(Weekly_Sales) OVER (
            PARTITION BY Store
            ORDER BY Date_Sales
        ) AS Previous_Weekly_Sales
    FROM dbo.Walmart_Sales_Cleaned
    WHERE Store = 20
)
SELECT
    Store,
    Date_Sales,
    Weekly_Sales,
    Previous_Weekly_Sales,
    Weekly_Sales - Previous_Weekly_Sales AS Sales_Change,
    CAST(
        (Weekly_Sales - Previous_Weekly_Sales) * 100.0
        / NULLIF(Previous_Weekly_Sales, 0)
        AS decimal(10, 2)
    ) AS Sales_Change_Pct,
    CASE
        WHEN Previous_Weekly_Sales IS NULL THEN 'Brak porównania'
        WHEN Weekly_Sales > Previous_Weekly_Sales THEN 'Wzrost'
        WHEN Weekly_Sales < Previous_Weekly_Sales THEN 'Spadek'
        ELSE 'Bez zmiany'
    END AS Trend_Status
FROM Sales_With_Previous
WHERE YEAR(Date_Sales) = 2011
ORDER BY Date_Sales;

/*
Zadanie 6. Procedura raportowa - 8 pkt
Utwórz procedurę dbo.usp_Walmart_Final_Report z parametrami:
@Date_From date,
@Date_To date,
@Type varchar(5) = NULL
sprawdź NULL dla obu dat;
odrzuć zakres, w którym @Date_From > @Date_To;
sprawdź poprawność @Type, jeżeli został podany;
zwróć podsumowanie sklepów i ranking według Total_Sales;
użyj filtra zakresowego uwzględniającego cały dzień @Date_To;
pokaż dwa przykładowe wywołania: bez typu oraz dla Type = A.
*/
CREATE OR ALTER PROCEDURE dbo.usp_Walmart_Final_Report
    @Date_From date,
    @Date_To date,
    @Type varchar(5) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @Date_From IS NULL OR @Date_To IS NULL
        THROW 50001, N'Daty nie mogą być NULL.', 1;

    IF @Date_From > @Date_To
        THROW 50002, N'Data początkowa nie może być późniejsza niż końcowa.', 1;

    IF @Type IS NOT NULL
       AND NOT EXISTS (
           SELECT 1
           FROM dbo.Stores_Metadata
           WHERE Type = @Type
       )
        THROW 50003, N'Nieprawidłowy typ sklepu.', 1;

    ;WITH Store_Summary AS (
        SELECT
            s.Store,
            m.Type,
            m.Size,
            COUNT(*) AS Weeks_Count,
            SUM(s.Weekly_Sales) AS Total_Sales,
            AVG(s.Weekly_Sales) AS Avg_Weekly_Sales
        FROM dbo.Walmart_Sales_Cleaned AS s
        JOIN dbo.Stores_Metadata AS m
            ON s.Store = m.Store
        WHERE s.Date_Sales >= @Date_From
          AND s.Date_Sales < DATEADD(day, 1, @Date_To)
          AND (@Type IS NULL OR m.Type = @Type)
        GROUP BY s.Store, m.Type, m.Size
    )
    SELECT
        Store,
        Type,
        Size,
        Weeks_Count,
        Total_Sales,
        Avg_Weekly_Sales,
        RANK() OVER (ORDER BY Total_Sales DESC) AS Sales_Rank
    FROM Store_Summary
    ORDER BY Sales_Rank, Store;
END;
GO

EXEC dbo.usp_Walmart_Final_Report
    @Date_From = '20110101',
    @Date_To = '20111231';

EXEC dbo.usp_Walmart_Final_Report
    @Date_From = '20110101',
    @Date_To = '20111231',
    @Type = 'A';