# Power BI / DAX – Dzień 6 – Pierwsze miary i KPI

## Czego się nauczyłem
- czym jest DAX
- miara vs kolumna obliczeniowa
- kontekst filtrowania
- `SUM`, `AVERAGE`, `COUNTROWS`, `DISTINCTCOUNT`, `MAX`
- miary jawne i niejawne
- tabela `_Measures`
- karty KPI

## Zastosowanie w projekcie
Utworzyłem tabelę `_Measures` i miary:

```DAX
Total Sales =
SUM(Walmart_Sales_Cleaned[Weekly_Sales])
```

```DAX
Average Weekly Sales =
AVERAGE(Walmart_Sales_Cleaned[Weekly_Sales])
```

```DAX
Records Count =
COUNTROWS(Walmart_Sales_Cleaned)
```

```DAX
Stores Count =
DISTINCTCOUNT(Walmart_Sales_Cleaned[Store])
```

```DAX
Maximum Weekly Sales =
MAX(Walmart_Sales_Cleaned[Weekly_Sales])
```

## Problem
Automatyczna `Suma elementów Weekly_Sales` jest mniej czytelna i trudniejsza do ponownego wykorzystania.

## Rozwiązanie
Używam jawnych miar z tabeli `_Measures`.

## Wniosek
Miara jest przeliczana dynamicznie w aktualnym kontekście filtrów. Jawne miary są lepsze do profesjonalnego modelu.
