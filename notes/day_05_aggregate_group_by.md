# Dzień 5 - funkcje agregujące i `GROUP BY`

## Cel dnia

- używać `COUNT()`, `SUM()`, `AVG()`, `MIN()` i `MAX()`,
- rozumieć różnicę między agregacją całej tabeli a agregacją grup,
- tworzyć podsumowania za pomocą `GROUP BY`,
- łączyć `WHERE` z `GROUP BY`,
- przygotowywać biznesowe KPI sprzedażowe.

## Teoria

Agregacja zamienia wiele rekordów w jedną lub kilka wartości podsumowujących.

```sql
SELECT
    COUNT(*) AS Liczba_Rekordow,
    SUM(Weekly_Sales) AS Sprzedaz_Laczna,
    AVG(Weekly_Sales) AS Srednia_Sprzedaz,
    MIN(Weekly_Sales) AS Najnizsza_Sprzedaz,
    MAX(Weekly_Sales) AS Najwyzsza_Sprzedaz
FROM dbo.Walmart_Sales_Cleaned;
```

`COUNT(*)` liczy wszystkie wiersze. `COUNT(kolumna)` liczy tylko wartości różne od `NULL`.

## `GROUP BY`

```sql
SELECT
    Store AS Numer_Sklepu,
    COUNT(*) AS Liczba_Tygodni,
    SUM(Weekly_Sales) AS Sprzedaz_Laczna,
    AVG(Weekly_Sales) AS Srednia_Sprzedaz
FROM dbo.Walmart_Sales_Cleaned
GROUP BY Store
ORDER BY Sprzedaz_Laczna DESC;
```

Każda kolumna z `SELECT`, która nie jest objęta funkcją agregującą, musi występować w `GROUP BY`.

## `WHERE` i `GROUP BY`

```sql
SELECT
    Store AS Numer_Sklepu,
    COUNT(*) AS Liczba_Tygodni,
    SUM(Weekly_Sales) AS Sprzedaz_Laczna
FROM dbo.Walmart_Sales_Cleaned
WHERE Date_Sales >= '2012-01-01'
  AND Date_Sales <  '2013-01-01'
GROUP BY Store
ORDER BY Sprzedaz_Laczna DESC;
```

Kolejność zapisu:

```text
SELECT -> FROM -> WHERE -> GROUP BY -> ORDER BY
```

Logiczna kolejność przetwarzania:

```text
FROM -> WHERE -> GROUP BY -> SELECT -> ORDER BY
```

## Grupowanie według kilku kolumn

```sql
SELECT
    YEAR(Date_Sales) AS Rok,
    Holiday_Flag AS Czy_Swieto,
    COUNT(*) AS Liczba_Tygodni,
    SUM(Weekly_Sales) AS Sprzedaz_Laczna,
    AVG(Weekly_Sales) AS Srednia_Sprzedaz
FROM dbo.Walmart_Sales_Cleaned
GROUP BY
    YEAR(Date_Sales),
    Holiday_Flag
ORDER BY
    Rok ASC,
    Czy_Swieto ASC;
```

## Zadanie praktyczne

Przygotuj ranking sprzedaży sklepów za cały rok 2012. Pokaż:

- `Store AS Numer_Sklepu`,
- `COUNT(*) AS Liczba_Tygodni`,
- `SUM(Weekly_Sales) AS Sprzedaz_Laczna`,
- `AVG(Weekly_Sales) AS Srednia_Sprzedaz`,
- `MIN(Weekly_Sales) AS Najnizsza_Sprzedaz`,
- `MAX(Weekly_Sales) AS Najwyzsza_Sprzedaz`.

Grupuj według `Store` i sortuj `Sprzedaz_Laczna` malejąco.

## Typowe błędy

- brak `GROUP BY`,
- kolumna w `SELECT`, której nie ma w `GROUP BY`,
- zbyt szczegółowe grupowanie,
- mylenie `COUNT(*)` z `COUNT(kolumna)`,
- wpisanie `WHERE` po `GROUP BY`.

## Co zapamiętać

- bez `GROUP BY` funkcje agregujące podsumowują cały filtrowany zbiór,
- `GROUP BY` tworzy osobne podsumowanie dla każdej grupy,
- `WHERE` filtruje rekordy przed agregacją,
- alias agregacji można stosować w `ORDER BY`.

## Test wiedzy

1. Do czego służy `COUNT(*)`?
2. Czym różni się `COUNT(*)` od `COUNT(CPI)`?
3. Co oblicza `SUM(Weekly_Sales)`?
4. Czy `AVG()` uwzględnia `NULL`?
5. Do czego służy `GROUP BY`?
6. Dlaczego `Store` musi znaleźć się w `GROUP BY`?
7. Czy `WHERE` może wystąpić przed `GROUP BY`?
8. Co zwróci grupowanie według `Store` i `Holiday_Flag`?
9. Jaka jest kolejność zapisu zapytania agregującego?
10. Jak posortować sklepy według łącznej sprzedaży malejąco?

## Zadanie domowe

1. Podsumuj sprzedaż według sklepu.
2. Podsumuj sprzedaż według `Holiday_Flag`.
3. Podsumuj sprzedaż według roku.
4. Podsumuj sklepy 4, 13 i 20 w roku 2012.
5. Podsumuj sprzedaż według roku i `Holiday_Flag`.
