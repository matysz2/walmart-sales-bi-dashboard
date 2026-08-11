# Dzień 15 - CTE w SQL Server

## Cel dnia

CTE pozwala nazwać wynik zapytania i wykorzystać go w następnym poleceniu. Dzięki temu dłuższe zapytanie można podzielić na czytelne etapy.

## Podstawowa składnia

```sql
;WITH Nazwa_CTE AS
(
    SELECT kolumna_1, kolumna_2
    FROM dbo.Tabela
    WHERE warunek
)
SELECT kolumna_1, kolumna_2
FROM Nazwa_CTE;
```

## Najważniejsze zasady

- CTE oznacza **Common Table Expression**.
- W SQL Server najbezpieczniej rozpoczynać definicję od `;WITH`.
- CTE działa tylko dla jednego polecenia bezpośrednio po definicji.
- CTE nie tworzy fizycznej tabeli w bazie.
- Kilka CTE zapisujemy po jednym `WITH` i rozdzielamy przecinkami.
- Kolejne CTE może korzystać z wcześniej zdefiniowanego CTE.
- `ORDER BY` stosujemy w końcowym `SELECT`.

## Przykład - sprzedaż według sklepu

```sql
;WITH Sales_By_Store AS
(
    SELECT
        Store,
        COUNT(*) AS Weeks_Count,
        SUM(Weekly_Sales) AS Total_Sales,
        AVG(Weekly_Sales) AS Avg_Weekly_Sales
    FROM dbo.Walmart_Sales_Cleaned
    GROUP BY Store
)
SELECT
    Store,
    Weeks_Count,
    Total_Sales,
    Avg_Weekly_Sales
FROM Sales_By_Store
WHERE Total_Sales >= 250000000
ORDER BY Total_Sales DESC;
```

Kontrola wyniku: warunek spełnia 7 sklepów.

## Kilka CTE

```sql
;WITH Sales_By_Store AS
(
    SELECT
        Store,
        SUM(Weekly_Sales) AS Total_Sales
    FROM dbo.Walmart_Sales
    GROUP BY Store
),
Company_Average AS
(
    SELECT AVG(Total_Sales) AS Avg_Store_Sales
    FROM Sales_By_Store
)
SELECT
    s.Store,
    s.Total_Sales,
    a.Avg_Store_Sales
FROM Sales_By_Store AS s
CROSS JOIN Company_Average AS a
WHERE s.Total_Sales >= a.Avg_Store_Sales
ORDER BY s.Total_Sales DESC;
```

Kontrola wyniku:

- średnia łączna sprzedaż sklepu: około `149 715 977,49`;
- sklepy powyżej lub równe średniej: `19`;
- sklepy poniżej średniej: `26`.

## CTE a inne rozwiązania

| Rozwiązanie | Zakres | Zastosowanie |
|---|---|---|
| CTE | jedno kolejne polecenie | czytelne etapy jednego zapytania |
| Podzapytanie | wewnątrz zapytania | krótka logika używana jeden raz |
| `#Tabela` tymczasowa | wiele poleceń w sesji | ponowne użycie wyniku i możliwość indeksowania |
| Widok | stały obiekt w bazie | logika wykorzystywana wielokrotnie |

## Typowe błędy

- brak średnika przed `WITH`;
- próba uruchomienia samej definicji CTE bez końcowego polecenia;
- próba użycia tego samego CTE w drugim niezależnym `SELECT`;
- `ORDER BY` wewnątrz prostego CTE;
- przecinek po ostatniej definicji CTE;
- brak aliasów przy kolumnach po `JOIN`.

## Test wiedzy

1. Co oznacza skrót CTE?
2. Do czego służy CTE?
3. Dlaczego stosujemy `;WITH`?
4. Jak długo dostępny jest wynik CTE?
5. Czy CTE tworzy fizyczną tabelę?
6. Gdzie zapisujemy polecenie korzystające z CTE?
7. Jak definiujemy kilka CTE?
8. Czy drugie CTE może korzystać z pierwszego?
9. Jaka jest różnica między CTE a `#tabelą` tymczasową?
10. Jak CTE można wykorzystać w projekcie Walmart?

## Zadanie domowe

1. Utwórz CTE z danymi z 2012 roku i policz sprzedaż według sklepu.
2. Pokaż sklepy ze średnią tygodniową powyżej 1 500 000.
3. Połącz wynik CTE z `Stores_Metadata` i pozostaw sklepy typu A.
4. Pokaż sklepy poniżej średniej i oblicz brak do średniej.
5. Policz sklepy powyżej/równe średniej oraz poniżej średniej. Wyniki kontrolne: 19 i 26.

## Co zapamiętać

CTE to nazwany, tymczasowy zestaw wynikowy, który ułatwia budowanie raportu etapami. Nie pozostaje w bazie i działa tylko dla jednego polecenia bezpośrednio po definicji.
