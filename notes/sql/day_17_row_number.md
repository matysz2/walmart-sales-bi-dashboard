# Dzień 17 - ROW_NUMBER w SQL Server

## Parametry używane w lekcji

- tabela sprzedaży: `dbo.Walmart_Sales_Cleaned`
- kolumna daty: `Date_Sales`
- tabela opisowa sklepów: `dbo.Stores_Metadata`

## 1. Cel dnia

Po tej lekcji potrafisz:

- numerować rekordy za pomocą `ROW_NUMBER()`;
- tworzyć osobną numerację dla każdego sklepu;
- wskazywać najlepszy lub najnowszy rekord w grupie;
- wybierać TOP N rekordów dla każdej grupy;
- filtrować wynik funkcji okienkowej za pomocą CTE;
- rozumieć różnicę między `ORDER BY` wewnątrz `OVER` i końcowym `ORDER BY`.

## 2. Teoria

`ROW_NUMBER()` jest funkcją okienkową, która przypisuje każdemu rekordowi unikalny kolejny numer: 1, 2, 3, 4...

```sql
ROW_NUMBER() OVER (ORDER BY Weekly_Sales DESC)
```

- `ROW_NUMBER()` tworzy numerację;
- `OVER(...)` definiuje okno;
- `ORDER BY` wewnątrz `OVER` ustala kolejność nadawania numerów;
- `PARTITION BY` opcjonalnie rozpoczyna numerację od 1 osobno dla każdej grupy.

### Numeracja całego wyniku

```sql
ROW_NUMBER() OVER
(
    ORDER BY Weekly_Sales DESC,
             Store ASC,
             Date_Sales ASC
)
```

### Numeracja osobno dla każdego sklepu

```sql
ROW_NUMBER() OVER
(
    PARTITION BY Store
    ORDER BY Weekly_Sales DESC,
             Date_Sales ASC
)
```

`ROW_NUMBER()` zawsze nadaje różne numery, nawet gdy dwie wartości sortujące są takie same. Dlatego warto dodać dodatkową kolumnę rozstrzygającą kolejność, np. `Date_Sales`.

## 3. Przykłady

### Przykład 1 - numeracja tygodni od najwyższej sprzedaży w całej firmie

```sql
SELECT
    Store,
    Date_Sales,
    Weekly_Sales,
    ROW_NUMBER() OVER
    (
        ORDER BY Weekly_Sales DESC,
                 Store ASC,
                 Date_Sales ASC
    ) AS Company_Sales_Row
FROM dbo.Walmart_Sales_Cleaned
ORDER BY Company_Sales_Row;
```

Najwyższy wynik kontrolny: sklep 14, data 2010-12-24, sprzedaż 3 818 686,45.

### Przykład 2 - numeracja sprzedaży osobno dla każdego sklepu

```sql
SELECT
    Store,
    Date_Sales,
    Weekly_Sales,
    ROW_NUMBER() OVER
    (
        PARTITION BY Store
        ORDER BY Weekly_Sales DESC,
                 Date_Sales ASC
    ) AS Store_Sales_Row
FROM dbo.Walmart_Sales_Cleaned
ORDER BY Store, Store_Sales_Row;
```

Dla każdego sklepu numeracja rozpoczyna się ponownie od 1.

### Przykład 3 - trzy najlepsze tygodnie każdego sklepu

Nie można użyć aliasu funkcji okienkowej bezpośrednio w `WHERE` tego samego poziomu zapytania. Najpierw obliczamy numer w CTE, a następnie filtrujemy wynik.

```sql
;WITH Ranked_Sales AS
(
    SELECT
        Store,
        Date_Sales,
        Weekly_Sales,
        ROW_NUMBER() OVER
        (
            PARTITION BY Store
            ORDER BY Weekly_Sales DESC,
                     Date_Sales ASC
        ) AS Store_Sales_Row
    FROM dbo.Walmart_Sales_Cleaned
)
SELECT
    Store,
    Date_Sales,
    Weekly_Sales,
    Store_Sales_Row
FROM Ranked_Sales
WHERE Store_Sales_Row <= 3
ORDER BY Store, Store_Sales_Row;
```

Dla 45 sklepów wynik powinien zawierać 135 rekordów, jeżeli każdy sklep ma co najmniej trzy tygodnie danych.

### Przykład 4 - najnowszy rekord każdego sklepu

```sql
;WITH Latest_Sales AS
(
    SELECT
        Store,
        Date_Sales,
        Weekly_Sales,
        ROW_NUMBER() OVER
        (
            PARTITION BY Store
            ORDER BY Date_Sales DESC,
                     Weekly_Sales DESC
        ) AS Latest_Row
    FROM dbo.Walmart_Sales_Cleaned
)
SELECT
    Store,
    Date_Sales,
    Weekly_Sales
FROM Latest_Sales
WHERE Latest_Row = 1
ORDER BY Store;
```

W danych źródłowych najnowszą datą dla wszystkich 45 sklepów jest 2012-10-26.

### Przykład 5 - najlepszy tydzień każdego sklepu z typem i powierzchnią

```sql
;WITH Best_Week AS
(
    SELECT
        Store,
        Date_Sales,
        Weekly_Sales,
        ROW_NUMBER() OVER
        (
            PARTITION BY Store
            ORDER BY Weekly_Sales DESC,
                     Date_Sales ASC
        ) AS Sales_Row
    FROM dbo.Walmart_Sales_Cleaned
)
SELECT
    b.Store,
    s.Type,
    s.Size,
    b.Date_Sales,
    b.Weekly_Sales
FROM Best_Week AS b
INNER JOIN dbo.Stores_Metadata AS s
    ON b.Store = s.Store
WHERE b.Sales_Row = 1
ORDER BY b.Weekly_Sales DESC;
```

To raport biznesowy pokazujący rekordowy tydzień każdego sklepu wraz z jego charakterystyką.

### Przykład 6 - TOP a ROW_NUMBER

`TOP (3)` zwraca trzy rekordy dla całego wyniku:

```sql
SELECT TOP (3)
    Store,
    Date_Sales,
    Weekly_Sales
FROM dbo.Walmart_Sales_Cleaned
ORDER BY Weekly_Sales DESC;
```

`ROW_NUMBER()` z `PARTITION BY Store` pozwala zwrócić trzy rekordy dla każdego sklepu.

## 4. Ćwiczenia

1. Pokaż wszystkie rekordy i nadaj im numer od najstarszej daty do najnowszej.
2. Nadaj numer sprzedaży osobno dla każdego sklepu, od najniższej do najwyższej wartości `Weekly_Sales`.
3. Wybierz dwa najlepsze tygodnie każdego sklepu.
4. Wybierz najstarszy rekord każdego sklepu.
5. Wybierz najlepszy tydzień każdego sklepu tylko dla 2011 roku.
6. Połącz najlepszy tydzień każdego sklepu z `dbo.Stores_Metadata`.

## 5. Zadanie praktyczne

Przygotuj raport `Top_5_Weeks_Per_Store_2011`, który zawiera:

- `Store`;
- `Type`;
- `Size`;
- `Date_Sales`;
- `Weekly_Sales`;
- pozycję sprzedaży od 1 do 5.

Wymagania:

1. ogranicz dane do 2011 roku;
2. połącz sprzedaż z `dbo.Stores_Metadata`;
3. nadaj pozycję osobno dla każdego sklepu;
4. pozostaw pięć najlepszych tygodni każdego sklepu;
5. posortuj wynik według `Store` i pozycji.

Wzorzec rozwiązania znajduje się w pliku SQL, ale wykonaj zadanie najpierw samodzielnie.

## 6. Typowe błędy

### Błąd 1 - brak ORDER BY wewnątrz OVER

```sql
ROW_NUMBER() OVER ()
```

W SQL Server `ROW_NUMBER()` wymaga `ORDER BY` w klauzuli `OVER`.

### Błąd 2 - mylenie dwóch ORDER BY

```sql
ROW_NUMBER() OVER (ORDER BY Weekly_Sales DESC)
...
ORDER BY Date_Sales;
```

Pierwsze `ORDER BY` nadaje numery. Drugie tylko ustawia kolejność wyświetlania.

### Błąd 3 - brak PARTITION BY

Bez `PARTITION BY Store` powstanie jedna numeracja dla całej firmy, a nie osobna dla każdego sklepu.

### Błąd 4 - filtrowanie aliasu w tym samym SELECT

```sql
SELECT
    ROW_NUMBER() OVER (...) AS Sales_Row
FROM dbo.Walmart_Sales_Cleaned
WHERE Sales_Row <= 3;
```

Alias `Sales_Row` nie jest jeszcze dostępny w `WHERE`. Użyj CTE lub podzapytania.

### Błąd 5 - brak reguły rozstrzygającej remis

```sql
ORDER BY Weekly_Sales DESC
```

Przy takich samych wartościach kolejność może być niedeterministyczna. Dodaj np. `Date_Sales ASC`.

### Błąd 6 - użycie niewłaściwej tabeli lub kolumny

W tej ścieżce używamy dokładnie:

```sql
FROM dbo.Walmart_Sales_Cleaned
```

oraz:

```sql
Date_Sales
```

## 7. Co zapamiętać

- `ROW_NUMBER()` nadaje każdemu rekordowi unikalny numer.
- `ORDER BY` wewnątrz `OVER` jest obowiązkowe.
- `PARTITION BY` rozpoczyna numerację od 1 osobno dla każdej grupy.
- Funkcja okienkowa nie zmniejsza liczby rekordów.
- Aby filtrować po numerze, użyj CTE lub podzapytania.
- `ROW_NUMBER()` jest podstawowym narzędziem do wyboru TOP N rekordów w każdej grupie.
- Przy remisie `ROW_NUMBER()` nadal nadaje różne numery.

## 8. Test wiedzy

1. Do czego służy `ROW_NUMBER()`?
2. Czy `ROW_NUMBER()` zmniejsza liczbę rekordów?
3. Dlaczego `ORDER BY` wewnątrz `OVER` jest obowiązkowe?
4. Co daje `PARTITION BY Store`?
5. Co się stanie, gdy pominiemy `PARTITION BY Store`?
6. Jaka jest różnica między `TOP (3)` i `ROW_NUMBER()` z podziałem na sklep?
7. Dlaczego nie można użyć aliasu `Sales_Row` bezpośrednio w `WHERE` tego samego zapytania?
8. Jak wybrać najnowszy rekord każdego sklepu?
9. Dlaczego warto dodać drugą kolumnę do `ORDER BY` wewnątrz `OVER`?
10. Jakie zastosowanie biznesowe ma `ROW_NUMBER()` w projekcie Walmart?

## 9. Zadanie domowe

Przygotuj raport pięciu najlepszych tygodni sprzedaży dla każdego typu sklepu w 2011 roku.

Raport ma zawierać:

- `Type`;
- `Store`;
- `Date_Sales`;
- `Weekly_Sales`;
- numer pozycji w obrębie typu.

Wskazówka: najpierw połącz sprzedaż z tabelą `dbo.Stores_Metadata`, a następnie użyj:

```sql
ROW_NUMBER() OVER
(
    PARTITION BY Type
    ORDER BY Weekly_Sales DESC,
             Store ASC,
             Date_Sales ASC
)
```

## Następny dzień

Dzień 18: `RANK()` i `DENSE_RANK()` - zachowanie funkcji rankingowych przy remisach.
