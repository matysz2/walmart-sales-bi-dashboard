# Dzień 9 - LEFT JOIN w SQL Server

## Cel dnia

Nauczyć się zachowywać wszystkie rekordy z tabeli lewej, nawet gdy nie istnieje dopasowanie w tabeli prawej.

## Podstawowa składnia

```sql
SELECT
    kolumny
FROM tabela_lewa AS l
LEFT JOIN tabela_prawa AS p
    ON l.klucz = p.klucz;
```

## Najważniejsza zasada

`LEFT JOIN` zachowuje wszystkie rekordy z tabeli zapisanej po lewej stronie.

Gdy nie ma dopasowania, kolumny prawej tabeli mają wartość `NULL`.

## INNER JOIN a LEFT JOIN

- `INNER JOIN` - tylko rekordy dopasowane.
- `LEFT JOIN` - wszystkie rekordy lewej tabeli oraz dopasowane rekordy prawej tabeli.

## Szukanie braku dopasowania

```sql
SELECT
    sm.Store,
    sm.Type,
    sm.Size
FROM dbo.Stores_Metadata AS sm
LEFT JOIN dbo.Walmart_Sales_Cleaned AS ws
    ON sm.Store = ws.Store
WHERE ws.Store IS NULL;
```

## Warunek w ON a warunek w WHERE

Warunek w `ON` ogranicza dopasowania, ale zachowuje wszystkie rekordy lewej tabeli:

```sql
LEFT JOIN dbo.Walmart_Sales_Cleaned AS ws
    ON sm.Store = ws.Store
   AND ws.Weekly_Sales >= 2000000
```

Warunek prawej tabeli w `WHERE` usuwa wiersze z `NULL` i może zmienić efekt zapytania na podobny do `INNER JOIN`.

## COUNT po LEFT JOIN

```sql
COUNT(ws.Weekly_Sales)
```

zwraca `0`, gdy nie istnieje dopasowanie, ponieważ `COUNT(kolumna)` nie liczy `NULL`.

`COUNT(*)` może być mylący, ponieważ policzy również wiersz zachowany przez lewą tabelę.

## Zadanie praktyczne

Przygotuj raport wszystkich 45 sklepów dla tygodni z 2012 roku, w których `Weekly_Sales >= 2000000`.

Kontrola:

- 45 sklepów,
- 7 sklepów z dopasowaniem,
- 38 sklepów z `Liczba_Tygodni = 0`,
- pierwszy sklep: 4 z 41 tygodniami.

## Supabase

Składnia `LEFT JOIN` jest taka sama. Użyj:

```sql
FROM public.stores AS sm
LEFT JOIN public.walmart_sales AS ws
    ON sm.store = ws.store
```
