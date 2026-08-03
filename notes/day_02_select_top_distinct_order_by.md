# Dzień 02 - SELECT, TOP, DISTINCT, aliasy i ORDER BY

## Cel dnia

Po tej lekcji potrafię:

- wybierać konkretne kolumny za pomocą `SELECT`,
- ograniczać liczbę rekordów przez `TOP`,
- usuwać powtórzenia z wyniku za pomocą `DISTINCT`,
- nadawać czytelne aliasy kolumnom przez `AS`,
- sortować dane za pomocą `ORDER BY`,
- tworzyć prosty ranking sprzedaży.

## Tabele używane w lekcji

- `dbo.Walmart_Sales_Cleaned`
- kolumny: `Store`, `Date_Sales`, `Weekly_Sales`, `Holiday_Flag`, `Temperature`, `Fuel_Price`, `CPI`, `Unemployment`

## Teoria

### SELECT

`SELECT` wskazuje kolumny, które mają znaleźć się w wyniku zapytania.

```sql
SELECT Store, Date_Sales, Weekly_Sales
FROM dbo.Walmart_Sales_Cleaned;
```

W pracy analityka lepiej zwykle wybierać konkretne kolumny niż używać `SELECT *`.

### TOP

W Microsoft SQL Server do ograniczania liczby rekordów używamy `TOP`.

```sql
SELECT TOP (10) Store, Date_Sales, Weekly_Sales
FROM dbo.Walmart_Sales_Cleaned;
```

`TOP` bez `ORDER BY` nie oznacza najwyższych ani najnowszych rekordów.

### DISTINCT

`DISTINCT` usuwa powtarzające się wiersze z wyniku.

```sql
SELECT DISTINCT Store
FROM dbo.Walmart_Sales_Cleaned;
```

Przy wielu kolumnach `DISTINCT` dotyczy całej kombinacji wartości.

### Alias AS

Alias zmienia nazwę kolumny tylko w wyniku zapytania.

```sql
SELECT Weekly_Sales AS Sprzedaz_Tygodniowa
FROM dbo.Walmart_Sales_Cleaned;
```

### ORDER BY

`ORDER BY` sortuje wynik:

- `ASC` - rosnąco,
- `DESC` - malejąco.

```sql
SELECT Store, Date_Sales, Weekly_Sales
FROM dbo.Walmart_Sales_Cleaned
ORDER BY Weekly_Sales DESC;
```

Można sortować według kilku kolumn. Kolejność kolumn określa priorytet sortowania.

## Zastosowanie biznesowe

Kierownik sprzedaży chce szybko zobaczyć:

- najwyższe tygodniowe wyniki sprzedaży,
- sklepy występujące w danych,
- historię każdego sklepu od najnowszego tygodnia,
- raport z czytelnymi nazwami kolumn.

## Kontrola wyniku

- `SELECT DISTINCT Store` powinno zwrócić 45 sklepów.
- Najwyższa wartość `Weekly_Sales` powinna wynosić `3818686.45`.
- Rekord z najwyższą sprzedażą: sklep 14, data 2010-12-24.

## Typowe błędy

1. Używanie `LIMIT` zamiast `TOP` w SQL Server.
2. Używanie `TOP` bez `ORDER BY` przy budowaniu rankingu.
3. Pomijanie `DESC`, gdy potrzebne są najwyższe wartości.
4. Zakładanie, że baza zawsze zwraca rekordy w tej samej kolejności.
5. Myślenie, że `DISTINCT` dotyczy tylko pierwszej kolumny.
6. Używanie `SELECT *` w raportach produkcyjnych.

## Co zapamiętać

```sql
SELECT TOP (liczba)
    kolumna1 AS Alias_1,
    kolumna2 AS Alias_2
FROM tabela
ORDER BY kolumna2 DESC;
```

Bez `ORDER BY` kolejność rekordów nie jest gwarantowana.

## Ćwiczenia

1. Wyświetl `Store`, `Date_Sales`, `Weekly_Sales`.
2. Wyświetl unikalne numery sklepów rosnąco.
3. Wyświetl 10 rekordów z najniższą sprzedażą.
4. Wyświetl 15 rekordów z najwyższą sprzedażą i nadaj polskie aliasy.
5. Posortuj dane według sklepu rosnąco i daty malejąco.
6. Wyświetl unikalne kombinacje `Store` i `Holiday_Flag`.

## Zadanie praktyczne

Przygotuj ranking 20 najwyższych wyników tygodniowej sprzedaży. Wynik ma zawierać:

- `Numer_Sklepu`,
- `Data_Sprzedazy`,
- `Sprzedaz_Tygodniowa`,
- `Czy_Swieto`.

Sortowanie: od najwyższej sprzedaży.

## Test wiedzy

1. Do czego służy `SELECT`?
2. Jaka jest różnica między `TOP (10)` a `TOP (10) ... ORDER BY Weekly_Sales DESC`?
3. Czy `TOP` gwarantuje kolejność rekordów?
4. Jak działa `DISTINCT` przy dwóch kolumnach?
5. Jaka jest różnica między `ASC` i `DESC`?
6. Dlaczego w raporcie warto stosować aliasy?

## Zadanie domowe

Napisz cztery zapytania:

1. 5 najwyższych wartości `Weekly_Sales`.
2. 5 najniższych wartości `Weekly_Sales`.
3. Unikalne wartości `Holiday_Flag`.
4. Dane posortowane według `Store` malejąco i `Date_Sales` rosnąco.

Następnie zapisz trzy krótkie wnioski biznesowe wynikające z rankingu najwyższej sprzedaży.
