/*
DZIEN 22 - PROCEDURY SKLADOWANE W SQL SERVER
Projekt: Walmart Sales
Tabela faktow: dbo.Walmart_Sales_Cleaned
Kolumna daty: Date_Sales
Wymiar: dbo.Stores_Metadata
*/

USE TreningData;
GO

/* =========================================================
1. PROCEDURA BEZ PARAMETROW
========================================================= */
CREATE OR ALTER PROCEDURE dbo.usp_Walmart_Company_Summary
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        COUNT(*) AS Records_Count,
        COUNT(DISTINCT Store) AS Stores_Count,
        SUM(Weekly_Sales) AS Total_Sales,
        AVG(Weekly_Sales) AS Avg_Weekly_Sales,
        MIN(Date_Sales) AS First_Date,
        MAX(Date_Sales) AS Last_Date
    FROM dbo.Walmart_Sales_Cleaned;
END;
GO

EXEC dbo.usp_Walmart_Company_Summary;
GO

/* =========================================================
2. PROCEDURA Z PARAMETRAMI I WALIDACJA
========================================================= */
CREATE OR ALTER PROCEDURE dbo.usp_Walmart_Sales_By_Store
    @Store int,
    @Date_From date,
    @Date_To date,
    @Holiday_Flag tinyint = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @Store IS NULL OR @Store <= 0
    BEGIN
        THROW 50001, N'Parametr @Store musi byc dodatnia liczba.', 1;
    END;

    IF @Date_From IS NULL OR @Date_To IS NULL
    BEGIN
        THROW 50002, N'Parametry dat nie moga byc NULL.', 1;
    END;

    IF @Date_From > @Date_To
    BEGIN
        THROW 50003, N'Data poczatkowa nie moze byc pozniejsza niz koncowa.', 1;
    END;

    IF @Holiday_Flag IS NOT NULL
       AND @Holiday_Flag NOT IN (0, 1)
    BEGIN
        THROW 50004, N'Holiday_Flag moze miec 0, 1 albo NULL.', 1;
    END;

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Stores_Metadata
        WHERE Store = @Store
    )
    BEGIN
        THROW 50005, N'Sklep o podanym numerze nie istnieje.', 1;
    END;

    SELECT
        s.Store,
        m.Type,
        m.Size,
        s.Date_Sales,
        s.Weekly_Sales,
        s.Holiday_Flag,
        s.Temperature,
        s.Fuel_Price,
        s.CPI,
        s.Unemployment
    FROM dbo.Walmart_Sales_Cleaned AS s
    INNER JOIN dbo.Stores_Metadata AS m
        ON s.Store = m.Store
    WHERE s.Store = @Store
      AND s.Date_Sales >= @Date_From
      AND s.Date_Sales <= @Date_To
      AND
      (
          @Holiday_Flag IS NULL
          OR s.Holiday_Flag = @Holiday_Flag
      )
    ORDER BY s.Date_Sales;
END;
GO

-- Wszystkie tygodnie sklepu 20 w 2011 roku.
EXEC dbo.usp_Walmart_Sales_By_Store
    @Store = 20,
    @Date_From = '20110101',
    @Date_To = '20111231';
GO

-- Tylko tygodnie swiateczne sklepu 20.
EXEC dbo.usp_Walmart_Sales_By_Store
    @Store = 20,
    @Date_From = '20100101',
    @Date_To = '20121231',
    @Holiday_Flag = 1;
GO

/* =========================================================
3. PARAMETR OUTPUT
========================================================= */
CREATE OR ALTER PROCEDURE dbo.usp_Walmart_Count_Store_Weeks
    @Store int,
    @Rows_Count int OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Stores_Metadata
        WHERE Store = @Store
    )
    BEGIN
        THROW 50006, N'Sklep o podanym numerze nie istnieje.', 1;
    END;

    SELECT
        @Rows_Count = COUNT(*)
    FROM dbo.Walmart_Sales_Cleaned
    WHERE Store = @Store;
END;
GO

DECLARE @Count_Result int;

EXEC dbo.usp_Walmart_Count_Store_Weeks
    @Store = 20,
    @Rows_Count = @Count_Result OUTPUT;

SELECT @Count_Result AS Rows_Count;
GO

/* =========================================================
4. ZADANIE PRAKTYCZNE - GOTOWA PROCEDURA RAPORTOWA
========================================================= */
CREATE OR ALTER PROCEDURE dbo.usp_Walmart_Store_Performance_Report
    @Date_From date,
    @Date_To date,
    @Store int = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @Date_From IS NULL OR @Date_To IS NULL
    BEGIN
        THROW 50010, N'Parametry dat nie moga byc NULL.', 1;
    END;

    IF @Date_From > @Date_To
    BEGIN
        THROW 50011, N'Data poczatkowa nie moze byc pozniejsza niz koncowa.', 1;
    END;

    IF @Store IS NOT NULL
       AND NOT EXISTS
       (
           SELECT 1
           FROM dbo.Stores_Metadata
           WHERE Store = @Store
       )
    BEGIN
        THROW 50012, N'Sklep o podanym numerze nie istnieje.', 1;
    END;

    SELECT
        s.Store,
        m.Type,
        m.Size,
        COUNT(*) AS Weeks_Count,
        SUM(CASE WHEN s.Holiday_Flag = 1 THEN 1 ELSE 0 END) AS Holiday_Weeks,
        SUM(s.Weekly_Sales) AS Total_Sales,
        AVG(s.Weekly_Sales) AS Avg_Weekly_Sales,
        MIN(s.Weekly_Sales) AS Min_Weekly_Sales,
        MAX(s.Weekly_Sales) AS Max_Weekly_Sales
    FROM dbo.Walmart_Sales_Cleaned AS s
    INNER JOIN dbo.Stores_Metadata AS m
        ON s.Store = m.Store
    WHERE s.Date_Sales >= @Date_From
      AND s.Date_Sales <= @Date_To
      AND
      (
          @Store IS NULL
          OR s.Store = @Store
      )
    GROUP BY
        s.Store,
        m.Type,
        m.Size
    ORDER BY Total_Sales DESC;
END;
GO

-- Raport calej firmy.
EXEC dbo.usp_Walmart_Store_Performance_Report
    @Date_From = '20110101',
    @Date_To = '20111231';
GO

-- Raport sklepu 20.
EXEC dbo.usp_Walmart_Store_Performance_Report
    @Date_From = '20110101',
    @Date_To = '20111231',
    @Store = 20;
GO

/* =========================================================
5. CWICZENIE 1
Utworz dbo.usp_Walmart_Holiday_Summary.
Ma zwracac Holiday_Flag, COUNT(*), SUM i AVG Weekly_Sales.
========================================================= */
CREATE OR ALTER PROCEDURE dbo.usp_Walmart_Holiday_Summary
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        Holiday_Flag,
        COUNT(*) AS Weeks_Count,
        SUM(Weekly_Sales) AS Total_Weekly_Sales,
        AVG(Weekly_Sales) AS Avg_Weekly_Sales
    FROM dbo.Walmart_Sales_Cleaned
    GROUP BY Holiday_Flag
    ORDER BY Holiday_Flag;
END;
GO

EXEC dbo.usp_Walmart_Holiday_Summary;
GO

/* =========================================================
6. CWICZENIE 2
Utworz dbo.usp_Walmart_Store_Summary z parametrem @Store.
Dodaj walidacje istnienia sklepu.
========================================================= */
CREATE OR ALTER PROCEDURE dbo.usp_Walmart_Store_Summary
    @Store int
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Stores_Metadata
        WHERE Store = @Store
    )
    BEGIN
        THROW 50007, N'Sklep o podanym numerze nie istnieje.', 1;
    END;

    SELECT
        s.Store,
        m.Type,
        m.Size,
        COUNT(*) AS Weeks_Count,
        SUM(s.Weekly_Sales) AS Total_Sales,
        AVG(s.Weekly_Sales) AS Avg_Weekly_Sales
    FROM dbo.Walmart_Sales_Cleaned AS s
    INNER JOIN dbo.Stores_Metadata AS m
        ON s.Store = m.Store
    WHERE s.Store = @Store
    GROUP BY
        s.Store,
        m.Type,
        m.Size;
END;
GO

EXEC dbo.usp_Walmart_Store_Summary @Store = 10;
GO

/* =========================================================
7. ZADANIE DOMOWE
Utworz dbo.usp_Walmart_Type_Performance z parametrami:
@Type varchar(5), @Date_From date, @Date_To date.
Waliduj Type: A, B albo C.
========================================================= */
CREATE OR ALTER PROCEDURE dbo.usp_Walmart_Type_Performance
    @Type varchar(5),
    @Date_From date,
    @Date_To date
AS
BEGIN
    SET NOCOUNT ON;

    IF @Type IS NULL
       OR @Type NOT IN ('A', 'B', 'C')
    BEGIN
        THROW 50008, N'Parametr @Type musi byc A, B albo C.', 1;
    END;

    IF @Date_From IS NULL OR @Date_To IS NULL
    BEGIN
        THROW 50009, N'Parametry dat nie moga byc NULL.', 1;
    END;

    IF @Date_From > @Date_To
    BEGIN
        THROW 50010, N'Data poczatkowa nie moze byc pozniejsza niz koncowa.', 1;
    END;

    SELECT
        m.Type,
        COUNT(*) AS Weeks_Count,
        SUM(s.Weekly_Sales) AS Total_Sales,
        AVG(s.Weekly_Sales) AS Avg_Weekly_Sales,
        MIN(s.Weekly_Sales) AS Min_Weekly_Sales,
        MAX(s.Weekly_Sales) AS Max_Weekly_Sales
    FROM dbo.Walmart_Sales_Cleaned AS s
    INNER JOIN dbo.Stores_Metadata AS m
        ON s.Store = m.Store
    WHERE m.Type = @Type
      AND s.Date_Sales >= @Date_From
      AND s.Date_Sales <= @Date_To
    GROUP BY
        m.Type
    ORDER BY
        m.Type;
END;
GO

EXEC dbo.usp_Walmart_Type_Performance
    @Type = 'A',
    @Date_From = '2010-01-01',
    @Date_To = '2012-12-31';
GO

 Opcjonalne sprzatanie:
DROP PROCEDURE IF EXISTS dbo.usp_Walmart_Count_Store_Weeks;
GO
