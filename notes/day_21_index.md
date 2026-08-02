# Dzień 21 - INDEX w SQL Server

## Cel dnia

Po lekcji potrafisz sprawdzić istniejące indeksy, odróżnić indeks clustered od nonclustered, utworzyć indeks pod filtr po `Date_Sales`, użyć `INCLUDE` oraz porównać plan wykonania i `Logical reads`.

## Używane obiekty

- tabela faktów: `dbo.Walmart_Sales_Cleaned`
- kolumna daty: `Date_Sales`
- wymiar: `dbo.Stores_Metadata`

## Czym jest indeks?

Indeks jest dodatkową strukturą powiązaną z tabelą. Zawiera uporządkowane klucze i informacje pozwalające szybciej dotrzeć do właściwych rekordów. Nie zmienia wyniku zapytania - zmienia możliwą drogę dostępu do danych.

> Indeks działa podobnie jak indeks pojęć w książce: nie czytasz wszystkiego od początku, tylko przechodzisz do właściwego miejsca.

## Clustered a nonclustered

| Clustered | Nonclustered |
|---|---|
| maksymalnie jeden na tabelę | może być wiele |
| poziom liści zawiera wiersze danych | osobna struktura z kluczem i lokalizatorem wiersza |
| często powiązany z kluczem głównym | projektowany pod konkretne filtry, JOIN i sortowania |

## Sprawdzenie istniejących indeksów

```sql
SELECT
    i.name AS Index_Name,
    i.type_desc AS Index_Type,
    i.is_unique,
    i.is_primary_key,
    c.name AS Column_Name,
    ic.key_ordinal,
    ic.is_included_column
FROM sys.indexes AS i
INNER JOIN sys.index_columns AS ic
    ON i.object_id = ic.object_id
   AND i.index_id = ic.index_id
INNER JOIN sys.columns AS c
    ON ic.object_id = c.object_id
   AND ic.column_id = c.column_id
WHERE i.object_id = OBJECT_ID('dbo.Walmart_Sales_Cleaned')
ORDER BY i.index_id, ic.key_ordinal, ic.index_column_id;
```

## Zapytanie bazowe

```sql
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT
    Store,
    Date_Sales,
    Weekly_Sales,
    Holiday_Flag
FROM dbo.Walmart_Sales_Cleaned
WHERE Date_Sales >= '20110101'
  AND Date_Sales <  '20120101'
ORDER BY Date_Sales, Store;
```

W SSMS włącz rzeczywisty plan wykonania skrótem `Ctrl+M`.

## Utworzenie indeksu

```sql
CREATE NONCLUSTERED INDEX IX_Walmart_Sales_Cleaned_Date_Sales
ON dbo.Walmart_Sales_Cleaned (Date_Sales)
INCLUDE (Store, Weekly_Sales, Holiday_Flag);
```

- `Date_Sales` - kolumna kluczowa, używana do filtrowania zakresu.
- `Store`, `Weekly_Sales`, `Holiday_Flag` - kolumny `INCLUDE`, potrzebne w wyniku.

## Dlaczego zakres dat zamiast YEAR()?

Lepszy wzorzec:

```sql
WHERE Date_Sales >= '20110101'
  AND Date_Sales <  '20120101'
```

Wzorzec do porównania:

```sql
WHERE YEAR(Date_Sales) = 2011
```

Funkcja na kolumnie może utrudniać wykorzystanie wyszukiwania zakresowego.

## Kiedy indeks może nie zostać użyty?

- tabela jest mała;
- zapytanie zwraca dużą część rekordów;
- indeks nie pasuje do filtra;
- pierwsza kolumna indeksu złożonego nie odpowiada warunkowi zapytania;
- zapytanie pobiera wiele kolumn spoza indeksu;
- optymalizator oceni skan jako tańszy.

## Koszt indeksów

Indeksy zajmują miejsce i zwiększają koszt `INSERT`, `UPDATE` i `DELETE`. Nie tworzymy osobnego indeksu na każdą kolumnę.

## Ćwiczenie praktyczne

1. Sprawdź istniejące indeksy.
2. Uruchom raport za 2011 rok przed nowym indeksem.
3. Zapisz operator oraz `Logical reads`.
4. Utwórz indeks po `Date_Sales` z `INCLUDE`.
5. Uruchom to samo zapytanie ponownie.
6. Porównaj wyniki i napisz trzy wnioski.

## Typowe błędy

- tworzenie indeksu bez sprawdzenia `sys.indexes`;
- dublowanie indeksów;
- zła kolejność kolumn w indeksie złożonym;
- używanie `SELECT *`;
- ocenianie tylko czasu zamiast planu i odczytów logicznych;
- przekonanie, że każdy `Scan` jest błędem.

## Co zapamiętać

- indeks projektujemy pod konkretne zapytanie;
- tabela może mieć jeden indeks clustered i wiele nonclustered;
- `INCLUDE` pomaga pokryć zapytanie bez rozbudowy klucza;
- kolejność kolumn kluczowych ma znaczenie;
- mała tabela Walmart może nadal być skanowana mimo utworzenia indeksu;
- zawsze porównuj plan i `Logical reads` przed i po.

## Test wiedzy

1. Czym jest indeks w SQL Server?
2. Jaka jest różnica między indeksami clustered i nonclustered?
3. Dlaczego tabela może mieć tylko jeden indeks clustered?
4. Po co przed `CREATE INDEX` sprawdzamy `sys.indexes`?
5. Jaką rolę pełni pierwsza kolumna indeksu złożonego?
6. Do czego służy `INCLUDE`?
7. Dlaczego `YEAR(Date_Sales) = 2011` może być mniej korzystne niż zakres dat?
8. Dlaczego SQL Server może wybrać `Scan` mimo istnienia indeksu?
9. Jak porównać zapytanie przed i po utworzeniu indeksu?
10. Jakie zastosowanie biznesowe ma indeks w projekcie Walmart?

## Zadanie domowe

Zaproponuj indeksy dla trzech raportów:

1. jeden sklep i zakres dat;
2. wszystkie sklepy i zakres dat;
3. tygodnie świąteczne w zakresie dat.

Dla każdego zapisz zapytanie, klucz indeksu, kolumny `INCLUDE` i uzasadnienie.
