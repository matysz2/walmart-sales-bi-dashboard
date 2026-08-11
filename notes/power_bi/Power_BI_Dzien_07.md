# Power BI / DAX – Dzień 7 – CALCULATE i analiza świąt

## Czego się nauczyłem
- `CALCULATE`
- zmiana kontekstu filtrowania
- filtrowanie przez `Holiday_Flag`
- `DIVIDE`
- udział procentowy
- uplift %
- porównywanie grup o różnej liczbie rekordów
- formatowanie procentów
- `FORMAT` do kart

## Zastosowanie w projekcie
```DAX
Holiday Sales =
CALCULATE(
    [Total Sales],
    Walmart_Sales_Cleaned[Holiday_Flag] = 1
)
```

```DAX
Non-Holiday Sales =
CALCULATE(
    [Total Sales],
    Walmart_Sales_Cleaned[Holiday_Flag] = 0
)
```

```DAX
Holiday Sales Share % =
DIVIDE(
    [Holiday Sales],
    [Total Sales],
    0
)
```

```DAX
Holiday Average Uplift % =
DIVIDE(
    [Average Holiday Weekly Sales] - [Average Non-Holiday Weekly Sales],
    [Average Non-Holiday Weekly Sales],
    0
)
```

## Problem
W moim Power BI średniki powodowały błąd DAX, a nowe karty skracały duże liczby do `mln`.

## Rozwiązanie
Używam przecinków jako separatorów DAX. Do pełnych liczb na kartach utworzyłem pomocnicze miary z `FORMAT`.

```DAX
Holiday Sales Card =
FORMAT(
    [Holiday Sales],
    "#,##0.00",
    "pl-PL"
)
```

## Wniosek
`CALCULATE` zmienia kontekst filtrowania. Przy porównaniu grup o różnej liczbie obserwacji nie wystarczy patrzeć tylko na sumę.
