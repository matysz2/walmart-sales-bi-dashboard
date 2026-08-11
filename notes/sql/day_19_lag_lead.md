# Dzień 19 - LAG() i LEAD() w SQL Server

## Cel dnia

Po tej lekcji potrafisz:

- pobierać wartość z poprzedniego rekordu za pomocą `LAG()`;
- pobierać wartość z następnego rekordu za pomocą `LEAD()`;
- porównywać sprzedaż tydzień do tygodnia;
- obliczać różnicę kwotową i procentową;
- rozumieć rolę `PARTITION BY Store` i `ORDER BY Date_Sales`;
- unikać błędów związanych z filtrowaniem danych przed funkcją okienkową.

## Używane obiekty

- tabela sprzedaży: `dbo.Walmart_Sales_Cleaned`
- kolumna daty: `Date_Sales`
- tabela sklepów: `dbo.Stores_Metadata`

## Teoria

`LAG()` zwraca wartość z wcześniejszego rekordu w tym samym oknie. `LEAD()` zwraca wartość z kolejnego rekordu. Rekord wcześniejszy lub kolejny jest ustalany przez `ORDER BY` wewnątrz `OVER`, a nie przez fizyczną kolejność w tabeli.

```sql
LAG(wyrazenie, przesuniecie, wartosc_domyslna) OVER
(
    PARTITION BY kolumna_grupujaca
    ORDER BY kolumna_kolejnosci
)
```

```sql
LEAD(wyrazenie, przesuniecie, wartosc_domyslna) OVER
(
    PARTITION BY kolumna_grupujaca
    ORDER BY kolumna_kolejnosci
)
```

- `wyrazenie` - wartość, którą pobieramy, np. `Weekly_Sales`;
- `przesuniecie` - ile rekordów wstecz lub do przodu, domyślnie `1`;
- `wartosc_domyslna` - wartość zamiast `NULL`, gdy rekord nie istnieje;
- `PARTITION BY Store` - osobne porównania dla każdego sklepu;
- `ORDER BY Date_Sales` - chronologiczna kolejność porównań.

## Przykład 1 - poprzedni tydzień

```sql
SELECT
    Store,
    Date_Sales,
    Weekly_Sales,
    LAG(Weekly_Sales) OVER
    (
        PARTITION BY Store
        ORDER BY Date_Sales
    ) AS Previous_Weekly_Sales
FROM dbo.Walmart_Sales_Cleaned
WHERE Store = 1
ORDER BY Date_Sales;
```

Pierwszy rekord każdego sklepu otrzyma `NULL`, ponieważ nie ma wcześniejszego rekordu w swoim oknie.

## Przykład 2 - różnica i zmiana procentowa

```sql
;WITH Sales_With_Previous AS
(
    SELECT
        Store,
        Date_Sales,
        Weekly_Sales,
        LAG(Weekly_Sales) OVER
        (
            PARTITION BY Store
            ORDER BY Date_Sales
        ) AS Previous_Weekly_Sales
    FROM dbo.Walmart_Sales_Cleaned
)
SELECT
    Store,
    Date_Sales,
    Weekly_Sales,
    Previous_Weekly_Sales,
    Weekly_Sales - Previous_Weekly_Sales AS Sales_Difference,
    CAST(
        (Weekly_Sales - Previous_Weekly_Sales) * 100.0
        / NULLIF(Previous_Weekly_Sales, 0)
        AS decimal(10,2)
    ) AS Sales_Change_Pct
FROM Sales_With_Previous
ORDER BY Store, Date_Sales;
```

`NULLIF(Previous_Weekly_Sales, 0)` chroni przed dzieleniem przez zero.

## Przykład 3 - następny tydzień

```sql
SELECT
    Store,
    Date_Sales,
    Weekly_Sales,
    LEAD(Weekly_Sales) OVER
    (
        PARTITION BY Store
        ORDER BY Date_Sales
    ) AS Next_Weekly_Sales
FROM dbo.Walmart_Sales_Cleaned
WHERE Store = 1
ORDER BY Date_Sales;
```

Ostatni rekord każdego sklepu otrzyma `NULL`, ponieważ nie ma kolejnego rekordu.

## Przykład 4 - raport dynamiki sprzedaży

```sql
;WITH Sales_Comparison AS
(
    SELECT
        Store,
        Date_Sales,
        Weekly_Sales,
        LAG(Weekly_Sales) OVER
        (
            PARTITION BY Store
            ORDER BY Date_Sales
        ) AS Previous_Weekly_Sales
    FROM dbo.Walmart_Sales_Cleaned
)
SELECT
    Store,
    Date_Sales,
    Weekly_Sales,
    Previous_Weekly_Sales,
    Weekly_Sales - Previous_Weekly_Sales AS Sales_Difference,
    CASE
        WHEN Previous_Weekly_Sales IS NULL THEN 'Brak poprzedniego tygodnia'
        WHEN Weekly_Sales > Previous_Weekly_Sales THEN 'Wzrost'
        WHEN Weekly_Sales < Previous_Weekly_Sales THEN 'Spadek'
        ELSE 'Bez zmian'
    END AS Sales_Trend
FROM Sales_Comparison
ORDER BY Store, Date_Sales;
```

## Ważne: filtr przed i po LAG()

Jeżeli odfiltrujesz dane przed obliczeniem `LAG()`, funkcja widzi tylko rekordy po filtrze. Aby zachować prawdziwy poprzedni rekord z całej historii, najpierw policz `LAG()` w CTE, a dopiero potem filtruj wynik.

```sql
;WITH Sales_With_Previous AS
(
    SELECT
        Store,
        Date_Sales,
        Weekly_Sales,
        LAG(Weekly_Sales) OVER
        (
            PARTITION BY Store
            ORDER BY Date_Sales
        ) AS Previous_Weekly_Sales
    FROM dbo.Walmart_Sales_Cleaned
)
SELECT *
FROM Sales_With_Previous
WHERE YEAR(Date_Sales) = 2011;
```

## Typowe błędy

1. Brak `PARTITION BY Store` - pierwszy rekord kolejnego sklepu może porównać się z ostatnim rekordem poprzedniego sklepu.
2. `ORDER BY Date_Sales DESC` - kierunek czasu zostaje odwrócony.
3. Użycie tylko końcowego `ORDER BY` - nie steruje ono funkcją `LAG()` ani `LEAD()`.
4. Założenie, że poprzedni rekord zawsze oznacza dokładnie poprzedni tydzień - funkcja pobiera poprzedni dostępny rekord.
5. Filtrowanie danych zbyt wcześnie.
6. Dzielenie przez zero przy zmianie procentowej.
7. Zastępowanie pierwszego `NULL` zerem bez uzasadnienia biznesowego.

## Co zapamiętać

- `LAG()` patrzy wstecz, `LEAD()` patrzy do przodu.
- `PARTITION BY Store` oddziela sklepy.
- `ORDER BY Date_Sales` wyznacza chronologię.
- Pierwszy rekord dla `LAG()` i ostatni dla `LEAD()` zwykle zwracają `NULL`.
- `LAG()` pobiera poprzedni dostępny rekord, nie gwarantuje odstępu siedmiu dni.
- Do filtrowania wyniku funkcji okienkowej użyj CTE lub podzapytania.

## Test wiedzy

1. Do czego służy `LAG()`?
2. Do czego służy `LEAD()`?
3. Co ustala `ORDER BY Date_Sales` wewnątrz `OVER`?
4. Co daje `PARTITION BY Store`?
5. Dlaczego pierwszy rekord sklepu zwraca `NULL` dla `LAG()`?
6. Dlaczego ostatni rekord sklepu zwraca `NULL` dla `LEAD()`?
7. Jak obliczyć różnicę między bieżącą i poprzednią sprzedażą?
8. Po co używamy `NULLIF()` przy zmianie procentowej?
9. Dlaczego filtr `WHERE` może zmienić wynik `LAG()`?
10. Jakie zastosowanie biznesowe mają `LAG()` i `LEAD()` w projekcie Walmart?

## Zadanie domowe

Zbuduj raport tygodniowej dynamiki sprzedaży dla każdego sklepu. Raport ma zawierać:

- `Store`, `Date_Sales`, `Weekly_Sales`;
- sprzedaż poprzedniego tygodnia;
- różnicę kwotową;
- zmianę procentową;
- status: `Wzrost`, `Spadek`, `Bez zmian`, `Brak porównania`;
- `Type` i `Size` z tabeli `dbo.Stores_Metadata`.

Posortuj wynik według `Store` i `Date_Sales`.
