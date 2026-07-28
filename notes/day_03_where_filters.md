# Dzień 3 - Filtrowanie danych w SQL Server

## Cel dnia

- filtrowanie rekordów za pomocą `WHERE`,
- używanie operatorów `=`, `<>`, `>`, `>=`, `<`, `<=`,
- łączenie warunków przez `AND`, `OR` i `NOT`,
- stosowanie nawiasów przy bardziej złożonych filtrach,
- filtrowanie dat w bezpiecznym formacie `YYYY-MM-DD`.

## Teoria

`SELECT` wybiera kolumny, natomiast `WHERE` wybiera rekordy.

```sql
SELECT kolumny
FROM tabela
WHERE warunek
ORDER BY kolumna;
```

Logiczna kolejność pracy zapytania:

1. `FROM`
2. `WHERE`
3. `SELECT`
4. `ORDER BY`

## Operatory

| Operator | Znaczenie |
|---|---|
| `=` | równe |
| `<>` | różne |
| `>` | większe niż |
| `>=` | większe lub równe |
| `<` | mniejsze niż |
| `<=` | mniejsze lub równe |

## Warunki logiczne

- `AND` - wszystkie warunki muszą być prawdziwe,
- `OR` - wystarczy co najmniej jeden prawdziwy warunek,
- `NOT` - odwraca warunek,
- nawiasy `( )` - określają kolejność sprawdzania warunków.

## Przykład

```sql
SELECT
    Store,
    Date_Sales,
    Weekly_Sales
FROM dbo.Walmart_Sales_Cleaned
WHERE (Store = 4 OR Store = 20)
  AND Weekly_Sales >= 1500000
ORDER BY Weekly_Sales DESC;
```

## Typowe błędy

- `WHERE` zapisane po `ORDER BY`,
- użycie `==` zamiast `=`,
- użycie `AND` do rozdzielania kolumn w `ORDER BY`,
- brak apostrofów przy dacie,
- brak nawiasów przy połączeniu `AND` i `OR`,
- użycie aliasu z `SELECT` w klauzuli `WHERE`.

## Co zapamiętać

- `SELECT` wybiera kolumny, `WHERE` wybiera rekordy.
- `ORDER BY` zapisujemy po `WHERE`.
- Daty zapisujemy jako `'YYYY-MM-DD'`.
- Przy połączeniu `AND` i `OR` stosujemy nawiasy.

## Test wiedzy

1. Jaka jest różnica między `SELECT` i `WHERE`?
2. Co oznacza operator `<>`?
3. Kiedy warunek połączony przez `AND` jest prawdziwy?
4. Kiedy warunek połączony przez `OR` jest prawdziwy?
5. Dlaczego przy połączeniu `AND` i `OR` warto używać nawiasów?
6. Czy zapis `Weekly_Sales == 1000000` jest poprawny?
7. Gdzie znajduje się `WHERE` względem `FROM` i `ORDER BY`?
8. Dlaczego datę zapisujemy jako `'2011-01-01'`?

## Zadanie praktyczne

Przygotuj raport wysokiej sprzedaży w chłodne, nieświąteczne tygodnie.

Warunki:

- `Weekly_Sales >= 1500000`,
- `Temperature < 50`,
- `Holiday_Flag = 0`,
- sortowanie od najwyższej sprzedaży.

## Zadanie domowe

1. Sprzedaż powyżej 1 750 000.
2. Sklep 13 albo 20 w roku 2012.
3. Tygodnie nieświąteczne z temperaturą poniżej 32.
4. Sklepy 4 lub 14 ze sprzedażą minimum 1 300 000 - zastosuj nawiasy.
