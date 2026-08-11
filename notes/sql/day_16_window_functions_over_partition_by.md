# Dzień 16 - funkcje okienkowe: `OVER` i `PARTITION BY`

## Cel dnia

Nauczyć się obliczać średnie, sumy i liczniki dla całego zbioru lub wybranych grup bez utraty pojedynczych rekordów sprzedaży.

## Najważniejsza różnica

`GROUP BY` redukuje liczbę wierszy. Funkcja okienkowa zachowuje wiersze źródłowe i dopisuje do nich wynik obliczenia.

```sql
SELECT
    Store,
    [Date],
    Weekly_Sales,
    AVG(Weekly_Sales) OVER (PARTITION BY Store) AS Avg_Store_Sales
FROM dbo.Walmart_Sales;
```

## Składnia

```sql
funkcja(kolumna) OVER
(
    PARTITION BY kolumna_grupująca
    ORDER BY kolumna_sortująca
)
```

- `OVER()` - obejmuje cały wynik zapytania.
- `PARTITION BY` - dzieli wynik na niezależne grupy, ale nie redukuje liczby rekordów.
- `ORDER BY` wewnątrz `OVER` - ustala kolejność obliczeń w oknie.
- `ORDER BY` na końcu zapytania - ustala kolejność wyświetlania wyniku.

## Przykłady

### Średnia całej firmy

```sql
AVG(Weekly_Sales) OVER ()
```

W danych Walmart średnia wynosi około **1 046 964,88**.

### Średnia sklepu

```sql
AVG(Weekly_Sales) OVER (PARTITION BY Store)
```

Dla sklepu 1 średnia wynosi około **1 555 264,40**.

### Suma i liczba tygodni sklepu

```sql
SUM(Weekly_Sales) OVER (PARTITION BY Store)
COUNT(*) OVER (PARTITION BY Store)
```

Każdy sklep w pełnym zbiorze ma 143 tygodnie.

### Średnia według typu sklepu

```sql
AVG(ws.Weekly_Sales) OVER (PARTITION BY sm.Type)
```

Wartości kontrolne:

| Type | Liczba rekordów | Średnia Weekly_Sales |
|---|---:|---:|
| A | 3 146 | 1 376 673,47 |
| B | 2 431 | 822 994,96 |
| C | 858 | 472 614,83 |

### Suma narastająca

```sql
SUM(Weekly_Sales) OVER
(
    PARTITION BY Store
    ORDER BY [Date]
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
)
```

## Typowe błędy

1. Pominięcie `OVER` i przypadkowe użycie zwykłej agregacji.
2. Mylenie `PARTITION BY` z `GROUP BY`.
3. Mylenie `ORDER BY` w oknie z końcowym `ORDER BY`.
4. Brak aliasów przy połączeniu tabel.
5. Nieuwzględnienie tego, że `WHERE` ogranicza rekordy przed wykonaniem funkcji okienkowej.

## Co zapamiętać

- `OVER()` - cały wynik.
- `OVER(PARTITION BY Store)` - osobne okno dla każdego sklepu.
- Funkcja okienkowa zachowuje każdy rekord.
- Jedno zapytanie może zawierać kilka funkcji okienkowych z różnymi partycjami.

## Test wiedzy

1. Czym jest funkcja okienkowa?
2. Jaka jest różnica między `GROUP BY` a funkcją okienkową?
3. Do czego służy `OVER`?
4. Co oznacza puste `OVER()`?
5. Do czego służy `PARTITION BY`?
6. Czy `PARTITION BY` zmniejsza liczbę wierszy?
7. Jaka jest różnica między dwoma rodzajami `ORDER BY`?
8. Jak policzyć średnią osobno dla każdego sklepu?
9. Dlaczego `WHERE` może zmienić wynik funkcji okienkowej?
10. Jakie zastosowanie biznesowe mają funkcje okienkowe w Walmart?

## Zadanie domowe

Przygotuj raport dla sklepów typu A i roku 2011. Zachowaj pojedyncze tygodnie i dodaj:

- średnią całej wybranej grupy,
- średnią sklepu,
- sumę sklepu,
- liczbę tygodni,
- różnicę od średniej sklepu,
- status powyżej/poniżej średniej sklepu.

Nie używaj `GROUP BY` w końcowym raporcie.

## Następny dzień

Dzień 17: `ROW_NUMBER` - numerowanie rekordów w grupach oraz wybór najlepszego lub najnowszego rekordu.
