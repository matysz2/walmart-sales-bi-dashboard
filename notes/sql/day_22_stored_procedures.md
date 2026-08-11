# Dzień 22 - procedury składowane w SQL Server

## Cel dnia

Po lekcji potrafisz tworzyć i uruchamiać procedury składowane, przekazywać parametry, stosować wartości domyślne, walidować dane wejściowe i przygotować procedurę raportową dla projektu Walmart.

## Używane obiekty

- tabela faktów: `dbo.Walmart_Sales_Cleaned`
- kolumna daty: `Date_Sales`
- wymiar sklepów: `dbo.Stores_Metadata`

## Czym jest procedura?

Procedura składowana to nazwany program T-SQL zapisany w bazie. Może zawierać kilka instrukcji i być uruchamiany wielokrotnie poleceniem `EXEC`.

```sql
CREATE OR ALTER PROCEDURE dbo.Nazwa_Procedury
    @Parametr int
AS
BEGIN
    SET NOCOUNT ON;

    SELECT ...;
END;
GO
```

## Pierwsza procedura

```sql
CREATE OR ALTER PROCEDURE dbo.usp_Walmart_Company_Summary
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        COUNT(*) AS Records_Count,
        COUNT(DISTINCT Store) AS Stores_Count,
        SUM(Weekly_Sales) AS Total_Sales,
        AVG(Weekly_Sales) AS Avg_Weekly_Sales
    FROM dbo.Walmart_Sales_Cleaned;
END;
GO

EXEC dbo.usp_Walmart_Company_Summary;
```

## Procedura z parametrami

```sql
CREATE OR ALTER PROCEDURE dbo.usp_Walmart_Sales_By_Store
    @Store int,
    @Date_From date,
    @Date_To date,
    @Holiday_Flag tinyint = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @Date_From > @Date_To
    BEGIN
        THROW 50003, N'Data początkowa nie może być późniejsza niż końcowa.', 1;
    END;

    SELECT
        s.Store,
        m.Type,
        m.Size,
        s.Date_Sales,
        s.Weekly_Sales,
        s.Holiday_Flag
    FROM dbo.Walmart_Sales_Cleaned AS s
    INNER JOIN dbo.Stores_Metadata AS m
        ON s.Store = m.Store
    WHERE s.Store = @Store
      AND s.Date_Sales >= @Date_From
      AND s.Date_Sales <= @Date_To
      AND (@Holiday_Flag IS NULL OR s.Holiday_Flag = @Holiday_Flag)
    ORDER BY s.Date_Sales;
END;
GO
```

## Uruchomienie

```sql
EXEC dbo.usp_Walmart_Sales_By_Store
    @Store = 20,
    @Date_From = '20110101',
    @Date_To = '20111231',
    @Holiday_Flag = 1;
```

## Najważniejsze zasady

- `CREATE` zapisuje definicję, a `EXEC` uruchamia procedurę.
- Parametry umożliwiają wielokrotne użycie jednego raportu.
- Wartości domyślne tworzą parametry opcjonalne.
- Walidacja chroni przed błędnym sklepem i zakresem dat.
- `SET NOCOUNT ON` ogranicza komunikaty o liczbie wierszy.
- Procedura jest stałym obiektem bazy, ale nie jest tabelą ani widokiem.

## Typowe błędy

- brak `GO` przed definicją procedury,
- brak typu danych parametru,
- pominięcie wymaganego parametru,
- brak walidacji zakresu dat,
- próba użycia `SELECT * FROM procedura`,
- brak `OUTPUT` podczas odbierania parametru wyjściowego.

## Test wiedzy

1. Czym jest procedura składowana?
2. Jaka jest różnica między `VIEW` a procedurą?
3. Do czego służy `CREATE OR ALTER PROCEDURE`?
4. Dlaczego przed definicją procedury często stosujemy `GO`?
5. Do czego służy `SET NOCOUNT ON`?
6. Jak przekazać parametry podczas `EXEC`?
7. Po co stosujemy wartości domyślne parametrów?
8. Dlaczego należy walidować zakres dat?
9. Czym różni się parametr wejściowy od `OUTPUT`?
10. Jakie zastosowanie biznesowe ma procedura w projekcie Walmart?

## Zadanie domowe

Utwórz `dbo.usp_Walmart_Type_Performance` z parametrami `@Type`, `@Date_From` i `@Date_To`. Waliduj typ sklepu, zwróć podsumowanie sprzedaży według sklepów i posortuj wynik malejąco według `Total_Sales`.
