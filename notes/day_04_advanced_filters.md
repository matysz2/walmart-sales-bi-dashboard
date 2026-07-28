# Dzień 4 - Precyzyjne filtrowanie danych

## Cel dnia

Nauczyć się stosować `IN`, `NOT IN`, `BETWEEN`, `NOT BETWEEN`, `LIKE`, `IS NULL` i `IS NOT NULL` w praktycznych zapytaniach analitycznych.

## Teoria

### `IN`

`IN` sprawdza, czy wartość znajduje się na podanej liście.

```sql
WHERE Store IN (4, 13, 20)
```

Jest to czytelniejszy odpowiednik:

```sql
WHERE Store = 4 OR Store = 13 OR Store = 20
```

### `NOT IN`

```sql
WHERE Store NOT IN (4, 13, 20)
```

Wyklucza wymienione sklepy.

### `BETWEEN`

```sql
WHERE Weekly_Sales BETWEEN 1300000 AND 1600000
```

`BETWEEN` uwzględnia obie granice. Jest równoważny zapisowi:

```sql
WHERE Weekly_Sales >= 1300000
  AND Weekly_Sales <= 1600000
```

### Zakres dat

Dla pełnego roku bezpieczny jest zakres półotwarty:

```sql
WHERE Date_Sales >= '2012-01-01'
  AND Date_Sales <  '2013-01-01'
```

### `LIKE`

- `%` - dowolna liczba znaków,
- `_` - dokładnie jeden znak.

```sql
WHERE Type LIKE 'A%'
```

### `IS NULL` i `IS NOT NULL`

```sql
WHERE CPI IS NULL
```

```sql
WHERE CPI IS NOT NULL
```

Nie używamy `CPI = NULL`.

## Przykład biznesowy

```sql
SELECT
    Store AS Numer_Sklepu,
    Date_Sales AS Data_Sprzedazy,
    Weekly_Sales AS Sprzedaz_Tygodniowa,
    Holiday_Flag AS Czy_Swieto
FROM dbo.Walmart_Sales_Cleaned
WHERE Store IN (4, 13, 20)
  AND Date_Sales >= '2011-01-01'
  AND Date_Sales <  '2012-01-01'
  AND Weekly_Sales BETWEEN 1300000 AND 2000000
  AND Holiday_Flag = 0
ORDER BY Weekly_Sales DESC;
```

## Typowe błędy

- `IN` bez nawiasów,
- elementy listy połączone przez `AND` zamiast przecinków,
- odwrócone granice `BETWEEN`,
- data zapisana jako `01.01.2012` zamiast `2012-01-01`,
- porównanie `= NULL` zamiast `IS NULL`,
- brak apostrofów w `LIKE 'A%'`.

## Co zapamiętać

- `IN` służy do listy wartości.
- `BETWEEN` służy do przedziału i uwzględnia obie granice.
- `LIKE` działa na tekście.
- `NULL` sprawdzamy przez `IS NULL` lub `IS NOT NULL`.
- Dla pełnych okresów czasu stosuj `>= początek` i `< początek następnego okresu`.

## Test wiedzy

1. Do czego służy `IN`?
2. Jaka jest różnica między `IN` i `BETWEEN`?
3. Czy `BETWEEN` uwzględnia obie granice?
4. Jak wykluczyć sklepy 4, 13 i 20?
5. Jak zapisać cały rok 2012?
6. Co oznacza `%` w `LIKE`?
7. Co oznacza `_` w `LIKE`?
8. Dlaczego `CPI = NULL` jest błędne?
9. Czym różni się `NULL` od zera?
10. Jaka jest kolejność `SELECT`, `FROM`, `WHERE`, `ORDER BY`?

## Zadanie praktyczne

Przygotuj raport sklepów 4, 13 i 20 za cały 2012 rok. Sprzedaż ma wynosić od 1 500 000 do 2 300 000 włącznie. Wyklucz rekordy z brakującą temperaturą. Posortuj sprzedaż malejąco, a datę rosnąco.

## Zadanie domowe

1. Sprzedaż sklepów 2, 7, 12 i 17.
2. Sprzedaż od 1 000 000 do 1 250 000 włącznie.
3. Drugie półrocze 2011 roku z zakresem półotwartym.
4. Wszystkie sklepy poza 1, 2 i 3 ze sprzedażą powyżej 1 800 000.
5. Kontrola braków danych w `Temperature`, `CPI` i `Unemployment`.
6. Sklepy, których `Type NOT LIKE 'A%'`.

## Notatka do README

```markdown
## Day 4 - Advanced filtering
- Used IN and NOT IN to filter store groups.
- Used BETWEEN for numeric ranges.
- Applied safe date-range filtering.
- Checked missing values with IS NULL and IS NOT NULL.
- Practiced text pattern matching with LIKE.
```
