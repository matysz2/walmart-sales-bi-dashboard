# Dzień 18 - `RANK()` i `DENSE_RANK()`

## Środowisko

- tabela sprzedaży: `dbo.Walmart_Sales_Cleaned`
- kolumna daty: `Date_Sales`
- tabela sklepów: `dbo.Stores_Metadata`

## Cel dnia

Po lekcji potrafisz:

- tworzyć rankingi z remisami;
- odróżniać `ROW_NUMBER()`, `RANK()` i `DENSE_RANK()`;
- tworzyć osobny ranking dla każdego sklepu lub typu sklepu;
- wybierać TOP N pozycji w grupie;
- rankingować sklepy po wcześniejszej agregacji sprzedaży.

## Najważniejsza różnica

Dla wartości `500, 400, 400, 300`:

| Wartość | ROW_NUMBER | RANK | DENSE_RANK |
|---:|---:|---:|---:|
| 500 | 1 | 1 | 1 |
| 400 | 2 | 2 | 2 |
| 400 | 3 | 2 | 2 |
| 300 | 4 | 4 | 3 |

- `ROW_NUMBER()` - zawsze unikalne numery;
- `RANK()` - remisy mają ten sam numer, po remisie występuje luka;
- `DENSE_RANK()` - remisy mają ten sam numer, bez luk.

## Podstawowa składnia

```sql
RANK() OVER
(
    PARTITION BY Store
    ORDER BY Weekly_Sales DESC
)
```

## Ranking tygodni osobno dla każdego sklepu

```sql
SELECT
    Store,
    Date_Sales,
    Weekly_Sales,
    RANK() OVER
    (
        PARTITION BY Store
        ORDER BY Weekly_Sales DESC
    ) AS Store_Sales_Rank,
    DENSE_RANK() OVER
    (
        PARTITION BY Store
        ORDER BY Weekly_Sales DESC
    ) AS Store_Sales_Dense_Rank
FROM dbo.Walmart_Sales_Cleaned
ORDER BY Store, Store_Sales_Rank, Date_Sales;
```

## Ranking sklepów według całkowitej sprzedaży

```sql
;WITH Store_Summary AS
(
    SELECT
        Store,
        SUM(Weekly_Sales) AS Total_Sales
    FROM dbo.Walmart_Sales_Cleaned
    GROUP BY Store
)
SELECT
    Store,
    Total_Sales,
    RANK() OVER (ORDER BY Total_Sales DESC) AS Company_Rank
FROM Store_Summary
ORDER BY Company_Rank;
```

## TOP 3 pozycji każdego sklepu

```sql
;WITH Ranked_Sales AS
(
    SELECT
        Store,
        Date_Sales,
        Weekly_Sales,
        DENSE_RANK() OVER
        (
            PARTITION BY Store
            ORDER BY Weekly_Sales DESC
        ) AS Sales_Position
    FROM dbo.Walmart_Sales_Cleaned
)
SELECT *
FROM Ranked_Sales
WHERE Sales_Position <= 3
ORDER BY Store, Sales_Position, Date_Sales;
```

> `DENSE_RANK() <= 3` może zwrócić więcej niż trzy rekordy dla sklepu, jeżeli występują remisy. Gdy potrzebujesz dokładnie trzech rekordów, użyj `ROW_NUMBER()`.

## Typowe błędy

1. Mylenie `RANK()` z `ROW_NUMBER()`.
2. Oczekiwanie dokładnie N rekordów po filtrze `RANK() <= N`.
3. Brak `PARTITION BY`, gdy ranking ma być osobny dla każdej grupy.
4. Próba filtrowania aliasu rankingu w `WHERE` tego samego zapytania.
5. Rankingowanie rekordów szczegółowych zamiast najpierw zagregować dane.
6. Dodanie kolumny rozstrzygającej do `ORDER BY`, gdy chcemy zachować remis.

## Co zapamiętać

- `ROW_NUMBER()` - dokładne TOP N rekordów;
- `RANK()` - ranking z remisami i lukami;
- `DENSE_RANK()` - ranking z remisami bez luk;
- `PARTITION BY` - osobny ranking dla każdej grupy;
- `ORDER BY` wewnątrz `OVER` - kryterium rankingu;
- CTE - filtrowanie wyniku funkcji okienkowej.

## Test wiedzy

1. Do czego służy `RANK()`?
2. Jak `RANK()` obsługuje remisy?
3. Jaka jest różnica między `RANK()` i `DENSE_RANK()`?
4. Jaka jest różnica między `ROW_NUMBER()` i `RANK()`?
5. Co daje `PARTITION BY Store`?
6. Dlaczego `ORDER BY` w `OVER` jest obowiązkowe?
7. Dlaczego `RANK() <= 3` może zwrócić więcej niż trzy rekordy?
8. Dlaczego dodatkowa kolumna w `ORDER BY` może usunąć remis?
9. Jak utworzyć ranking sklepów według `Total_Sales`?
10. Jakie zastosowanie biznesowe ma ranking w projekcie Walmart?

## Zadanie domowe

1. Porównaj trzy funkcje rankingowe dla `Store = 20`.
2. Wybierz pięć najwyższych pozycji sprzedażowych każdego sklepu.
3. Zbuduj ranking sklepów w całej firmie i osobno według `Type`.
4. Napisz trzy wnioski biznesowe.

## Następny temat

Dzień 19: `LAG()` - porównywanie bieżącego rekordu z poprzednim tygodniem.
