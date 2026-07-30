# Dzień 11 - RIGHT JOIN w SQL Server

## Cel dnia

Nauczyć się zachowywać wszystkie rekordy z tabeli zapisanej po prawej stronie złączenia.

## Podstawowa składnia

```sql
SELECT
    kolumny
FROM tabela_lewa AS l
RIGHT JOIN tabela_prawa AS p
    ON l.klucz = p.klucz;
```

## Najważniejsza zasada

`RIGHT JOIN` zachowuje wszystkie rekordy z tabeli prawej.

W projekcie Walmart:

```sql
FROM dbo.Walmart_Sales_Cleaned AS ws
RIGHT JOIN dbo.Stores_Metadata AS sm
    ON ws.Store = sm.Store
```

Tabela `Stores_Metadata` jest po prawej stronie, więc wszystkie sklepy zostają zachowane.

## RIGHT JOIN a LEFT JOIN

Te dwa zapisy są równoważne:

```sql
FROM dbo.Walmart_Sales_Cleaned AS ws
RIGHT JOIN dbo.Stores_Metadata AS sm
    ON ws.Store = sm.Store
```

```sql
FROM dbo.Stores_Metadata AS sm
LEFT JOIN dbo.Walmart_Sales_Cleaned AS ws
    ON sm.Store = ws.Store
```

## Filtrowanie

Aby zachować wszystkie sklepy, warunek dotyczący tabeli sprzedaży zapisuj w `ON`:

```sql
RIGHT JOIN dbo.Stores_Metadata AS sm
    ON ws.Store = sm.Store
   AND ws.Date_Sales >= '2012-01-01'
   AND ws.Date_Sales < '2013-01-01'
```

## Liczenie dopasowanych rekordów

```sql
COUNT(ws.Date_Sales)
```

pomija `NULL`, dlatego sklep bez dopasowania otrzyma wynik `0`.

## Zadanie praktyczne

Przygotuj raport wszystkich sklepów dla tygodni z 2012 roku ze sprzedażą co najmniej `2000000`.

Kontrola:

- 45 sklepów,
- 7 sklepów z dopasowaniem,
- 38 sklepów z wynikiem 0,
- pierwszy sklep 4,
- sklep 4 ma 41 tygodni spełniających warunek.

## Co zapamiętać

- `RIGHT JOIN` zachowuje prawą tabelę.
- Brak dopasowania daje `NULL` w kolumnach lewej tabeli.
- Warunki lewej tabeli umieszczaj w `ON`, gdy nie chcesz usuwać rekordów prawej tabeli.
- `COUNT(kolumna_lewej)` liczy dopasowania.
- `RIGHT JOIN` można przepisać jako `LEFT JOIN`.
