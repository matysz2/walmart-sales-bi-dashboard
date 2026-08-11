# Dzień 23 - Optymalizacja zapytań w SQL Server

## Cel dnia

Nauczyć się optymalizować zapytania na podstawie pomiarów: rzeczywistego planu wykonania, `STATISTICS IO`, `STATISTICS TIME` i poprawnego zapisu filtrów.

## Używane obiekty

- `dbo.Walmart_Sales_Cleaned`
- `Date_Sales`
- `dbo.Stores_Metadata`

## Najważniejsza zasada

> Poprawność -> pomiar -> jedna zmiana -> ponowny pomiar.

## Plan wykonania

- Estimated Execution Plan: `Ctrl + L`
- Actual Execution Plan: `Ctrl + M`, a następnie wykonanie zapytania

Najczęstsze operatory: `Index Seek`, `Index Scan`, `Table Scan`, `Key Lookup`, `Sort`, `Nested Loops`, `Hash Match`.

## Pomiar

```sql
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT
    Store,
    Date_Sales,
    Weekly_Sales
FROM dbo.Walmart_Sales_Cleaned
WHERE Store = 20
  AND Date_Sales >= '20110101'
  AND Date_Sales <  '20120101';

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
```

## SARGability

Mniej korzystnie:

```sql
WHERE YEAR(Date_Sales) = 2011
```

Lepiej:

```sql
WHERE Date_Sales >= '20110101'
  AND Date_Sales <  '20120101'
```

## Jawne kolumny

W raportach preferuj:

```sql
SELECT Store, Date_Sales, Weekly_Sales
```

zamiast:

```sql
SELECT *
```

## Indeks dla raportu sklepu i zakresu dat

```sql
CREATE NONCLUSTERED INDEX IX_Walmart_Store_Date
ON dbo.Walmart_Sales_Cleaned (Store, Date_Sales)
INCLUDE (Weekly_Sales, Holiday_Flag);
```

## Co zapamiętać

- `Scan` nie zawsze jest błędem.
- `Seek` nie gwarantuje automatycznie najlepszego planu.
- Funkcje na filtrowanej kolumnie mogą ograniczać użycie indeksu.
- Zwracaj tylko potrzebne kolumny.
- Nie maskuj błędnego `JOIN` przez `DISTINCT`.
- CTE, VIEW i PROCEDURE nie przyspieszają automatycznie.
- Na małej tabeli różnica czasu może być niewielka, dlatego analizuj również `Logical reads` i plan.

## Test wiedzy

1. Czym jest optymalizacja zapytania?
2. Czym różni się plan szacowany od rzeczywistego?
3. Co mierzy `STATISTICS IO`?
4. Dlaczego `YEAR(Date_Sales)` może utrudnić użycie indeksu?
5. Jak zapisać zakres dat dla 2011 roku?
6. Dlaczego `SELECT *` może być niekorzystne?
7. Dlaczego konwersja `Store` w `WHERE` może pogorszyć plan?
8. Czy `Index Scan` zawsze oznacza problem?
9. Dlaczego porównujemy identyczne zapytanie przed i po zmianie?
10. Jak optymalizacja wspiera raporty Walmart i Power BI?
