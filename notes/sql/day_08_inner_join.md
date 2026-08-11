# Dzień 8 - INNER JOIN w SQL Server

## Cel dnia

Nauczyć się łączyć tabelę sprzedaży z tabelą opisującą sklepy.

## Model danych

- `dbo.Stores_Metadata` - strona `1`
- `dbo.Walmart_Sales_Cleaned` - strona `*`
- klucz łączenia: `Store`

## Podstawowa składnia

```sql
SELECT
    kolumny
FROM tabela_1 AS t1
INNER JOIN tabela_2 AS t2
    ON t1.klucz = t2.klucz;
```

## Przykład

```sql
SELECT
    ws.Store,
    sm.Type,
    sm.Size,
    ws.Date_Sales,
    ws.Weekly_Sales
FROM dbo.Walmart_Sales_Cleaned AS ws
INNER JOIN dbo.Stores_Metadata AS sm
    ON ws.Store = sm.Store;
```

## Najważniejsze pojęcia

- `INNER JOIN` - zwraca tylko dopasowane rekordy.
- `ON` - określa warunek dopasowania.
- `ws`, `sm` - aliasy tabel.
- `COUNT(*)` - liczba rekordów.
- `COUNT(DISTINCT sm.Store)` - liczba unikalnych sklepów.

## Kolejność zapisu

```text
SELECT
FROM
INNER JOIN
ON
WHERE
GROUP BY
HAVING
ORDER BY
```

## Zadanie praktyczne

Przygotuj podsumowanie sprzedaży według typu sklepu za rok 2012:

- `Typ_Sklepu`
- `Liczba_Sklepow`
- `Liczba_Tygodni`
- `Sprzedaz_Laczna`
- `Srednia_Sprzedaz`
- `Najwyzsza_Sprzedaz`

Kontrola:

- 3 wiersze: A, B, C
- typ A pierwszy
- typ A: 22 sklepy i 946 rekordów

## Co zapamiętać

- `INNER JOIN` łączy tylko rekordy mające dopasowanie.
- Alias wskazuje źródło kolumny.
- `ON ws.Store = sm.Store` łączy obie tabele po numerze sklepu.
- Po JOIN można stosować `WHERE`, `GROUP BY`, `HAVING` i `ORDER BY`.

