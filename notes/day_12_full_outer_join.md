# Dzień 12 - FULL OUTER JOIN w SQL Server

## Cel dnia

Nauczyć się zachowywać wszystkie rekordy z obu łączonych tabel oraz wykrywać braki dopasowania po obu stronach.

## Składnia

```sql
SELECT
    kolumny
FROM tabela_lewa AS l
FULL OUTER JOIN tabela_prawa AS p
    ON l.klucz = p.klucz;
```

## Najważniejsza zasada

`FULL OUTER JOIN` zachowuje:

- rekordy dopasowane,
- rekordy występujące tylko w tabeli lewej,
- rekordy występujące tylko w tabeli prawej.

## Jeden klucz przez COALESCE

```sql
COALESCE(sm.Store, ws.Store) AS Numer_Sklepu
```

`COALESCE` zwraca pierwszą wartość różną od `NULL`.

## Wykrywanie braków

```sql
WHERE ws.Store IS NULL
   OR sm.Store IS NULL
```

Na aktualnych danych Walmart wynik powinien mieć 0 wierszy.

## Status dopasowania

```sql
CASE
    WHEN ws.Store IS NULL THEN 'Brak sprzedazy'
    WHEN sm.Store IS NULL THEN 'Brak metadanych'
    ELSE 'Dopasowany'
END AS Status_Dopasowania
```

## Ważna uwaga o ON

Przy `FULL OUTER JOIN` warunek w `ON` ogranicza dopasowanie, ale nie usuwa rekordów z żadnej strony. Niedopasowane rekordy nadal pozostają w wyniku.

## Kontrola zadania praktycznego

- 45 sklepów,
- wszystkie statusy `Dopasowany`,
- każdy sklep ma 143 tygodnie.

## Co zapamiętać

- `FULL OUTER JOIN` zachowuje obie tabele.
- Brak dopasowania daje `NULL` po przeciwnej stronie.
- `COALESCE` pozwala uzyskać jeden wspólny klucz.
- Braki po obu stronach wyszukujemy przez `OR`.
- `COUNT(ws.Date_Sales)` liczy dopasowane rekordy sprzedaży.
