# Power BI / DAX – Dzień 9 – RANKX i ranking sklepów

## Czego się nauczyłem
- `RANKX`
- `ALL`
- `DESC`
- `DENSE`
- dynamiczny ranking
- Top 5
- `MAXX`
- `ISINSCOPE`
- udział sklepu w sprzedaży
- `Store Label`

## Zastosowanie w projekcie
```DAX
Store Rank =
IF(
    ISINSCOPE(Stores_Metadata[Store]),
    RANKX(
        ALL(Stores_Metadata[Store]),
        [Total Sales],
        ,
        DESC,
        DENSE
    )
)
```

Bez filtrów:
```text
lider = Store 20
```

Dla:
```text
Year = 2011
lider = Store 4
```

## Problem
`Store` jest liczbą, więc Power BI traktował numery sklepów jak oś ciągłą. Ranking w wierszu `Suma` pokazywał niepotrzebne `1`.

## Rozwiązanie
Do prezentacji utworzyłem:
```DAX
Store Label =
FORMAT(
    Stores_Metadata[Store],
    "0"
)
```

Do sumy zastosowałem `ISINSCOPE`.

Top 5:
```text
Store Rank <= 5
```

## Wniosek
Ranking DAX jest dynamiczny i zależy od aktualnego kontekstu filtrowania.
