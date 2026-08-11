# Power BI / DAX – Dzień 10 – ALLSELECTED i Visual Total

## Czego się nauczyłem
- `ALL` vs `ALLSELECTED`
- visual total
- udział w wybranej grupie
- ranking wybranej grupy
- dynamiczny mianownik
- wpływ segmentatorów na miary
- miary vs kolumny przy analizie interaktywnej

## Zastosowanie w projekcie
Wybrałem sklepy:
```text
4
14
20
```

```DAX
Selected Stores Sales =
CALCULATE(
    [Total Sales],
    ALLSELECTED(Stores_Metadata[Store])
)
```

Wynik:
```text
889 941 657,18
```

```DAX
Store Sales Share Selected % =
DIVIDE(
    [Total Sales],
    [Selected Stores Sales],
    0
)
```

```DAX
Store Rank Selected =
IF(
    ISINSCOPE(Stores_Metadata[Store]),
    RANKX(
        ALLSELECTED(Stores_Metadata[Store]),
        [Total Sales],
        ,
        DESC,
        DENSE
    )
)
```

Udziały:
```text
Store 20 → 33,87%
Store 4  → 33,66%
Store 14 → 32,47%
Suma     → 100,00%
```

## Problem
`ALL(Store)` liczy wynik względem szerszego zbioru sklepów, a nie tylko wyboru użytkownika.

## Rozwiązanie
Użyłem `ALLSELECTED(Store)`, aby zachować wybór z segmentatora.

## Wniosek
`ALLSELECTED` służy do udziałów, rankingów i visual totals względem aktualnie wybranego zestawu danych.
