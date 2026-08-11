# Dzień 20 - VIEW w SQL Server

## Cel dnia

Po tej lekcji potrafisz tworzyć, odczytywać, modyfikować i usuwać widoki oraz wykorzystywać je jako warstwę raportową dla SQL i Power BI.

## Używane obiekty

- tabela faktów: `dbo.Walmart_Sales_Cleaned`
- kolumna daty: `Date_Sales`
- wymiar sklepów: `dbo.Stores_Metadata`

## Czym jest VIEW?

VIEW to zapisane w bazie zapytanie `SELECT`, które można odpytywać podobnie jak tabelę. Zwykły widok przechowuje definicję zapytania, a nie osobną kopię rekordów.

## Widok szczegółowy

```sql
USE TreningData;
GO

CREATE VIEW dbo.vw_Walmart_Sales_Details
AS
SELECT
    s.Store,
    s.Date_Sales,
    s.Weekly_Sales,
    s.Holiday_Flag,
    s.Temperature,
    s.Fuel_Price,
    s.CPI,
    s.Unemployment,
    m.Type,
    m.Size,
    YEAR(s.Date_Sales) AS Sales_Year,
    MONTH(s.Date_Sales) AS Sales_Month
FROM dbo.Walmart_Sales_Cleaned AS s
INNER JOIN dbo.Stores_Metadata AS m
    ON s.Store = m.Store;
GO
```

## Odczyt widoku

```sql
SELECT TOP (20)
    Store,
    Date_Sales,
    Weekly_Sales,
    Type,
    Size
FROM dbo.vw_Walmart_Sales_Details
ORDER BY Store, Date_Sales;
```

## Widok agregujący

```sql
CREATE VIEW dbo.vw_Store_Sales_Summary
AS
SELECT
    s.Store,
    m.Type,
    m.Size,
    COUNT(*) AS Weeks_Count,
    SUM(s.Weekly_Sales) AS Total_Sales,
    CAST(AVG(s.Weekly_Sales) AS decimal(18,2)) AS Avg_Weekly_Sales,
    MIN(s.Weekly_Sales) AS Min_Weekly_Sales,
    MAX(s.Weekly_Sales) AS Max_Weekly_Sales,
    MIN(s.Date_Sales) AS First_Sales_Date,
    MAX(s.Date_Sales) AS Last_Sales_Date
FROM dbo.Walmart_Sales_Cleaned AS s
INNER JOIN dbo.Stores_Metadata AS m
    ON s.Store = m.Store
GROUP BY
    s.Store,
    m.Type,
    m.Size;
GO
```

## Modyfikowanie i usuwanie

```sql
ALTER VIEW dbo.vw_Walmart_Sales_Details
AS
SELECT ...;
GO

DROP VIEW IF EXISTS dbo.vw_Walmart_Sales_Details;
GO
```

## VIEW vs CTE vs #tabela

- VIEW: stały obiekt bazy, używany przez wiele zapytań i raportów.
- CTE: działa tylko dla jednego polecenia bezpośrednio po `WITH`.
- `#tabela`: tymczasowo przechowuje dane w bieżącej sesji.

## Najważniejsze zasady

1. `CREATE VIEW` powinno rozpoczynać nową partię poleceń.
2. Sortowanie wykonuj w zapytaniu korzystającym z widoku.
3. W definicji widoku wymieniaj kolumny jawnie zamiast `SELECT *`.
4. Zwykły widok pokazuje aktualny wynik danych źródłowych.
5. Widok jest dobrym źródłem dla Power BI, gdy standaryzuje logikę raportową.

## Test wiedzy

1. Czym jest widok w SQL Server?
2. Czy zwykły widok przechowuje własną kopię rekordów?
3. Do czego służy `CREATE VIEW`?
4. Dlaczego przed `CREATE VIEW` często stosujemy `GO`?
5. Jak odczytać dane z widoku?
6. Jaka jest różnica między VIEW a CTE?
7. Co stanie się z wynikiem widoku po zmianie danych źródłowych?
8. Gdzie należy stosować `ORDER BY`?
9. Dlaczego należy unikać `SELECT *` w widoku?
10. Jakie zastosowanie biznesowe ma VIEW w projekcie Walmart?

## Zadanie domowe

Utwórz `dbo.vw_Holiday_Sales_Analysis` z jednym rekordem dla kombinacji `Store` i `Holiday_Flag`, zawierający `Type`, `Size`, `Records_Count`, `Total_Sales`, `Avg_Weekly_Sales`, `Min_Weekly_Sales` i `Max_Weekly_Sales`.
