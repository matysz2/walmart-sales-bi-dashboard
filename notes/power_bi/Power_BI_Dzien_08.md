# Power BI / DAX – Dzień 8 – Time Intelligence, YoY i YTD

## Czego się nauczyłem
- Time Intelligence
- `SAMEPERIODLASTYEAR`
- Sales Previous Year
- YoY Change
- YoY %
- `TOTALYTD`
- analiza YTD
- porównywanie analogicznych okresów
- interpretacja niepełnego roku

## Zastosowanie w projekcie
```DAX
Sales Previous Year =
CALCULATE(
    [Total Sales],
    SAMEPERIODLASTYEAR(Dim_Date[Date])
)
```

```DAX
Sales YoY Change =
[Total Sales] - [Sales Previous Year]
```

```DAX
Sales YoY % =
DIVIDE(
    [Sales YoY Change],
    [Sales Previous Year],
    0
)
```

```DAX
Sales YTD =
TOTALYTD(
    [Total Sales],
    Dim_Date[Date]
)
```

Wyniki kontrolne:
```text
2011 YoY = +6,96%
2012 YoY = +2,57% w moim modelu
```

## Problem
Pełny 2011 i niepełny 2012 mają różną długość, więc proste porównanie sum może sugerować fałszywy spadek.

## Rozwiązanie
Porównuję analogiczne zakresy czasu za pomocą tabeli `Dim_Date` i funkcji Time Intelligence.

## Wniosek
W analizie biznesowej trzeba porównywać porównywalne okresy.
