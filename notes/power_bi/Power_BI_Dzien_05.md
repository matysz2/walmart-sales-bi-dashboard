# Power BI – Dzień 5 – Tabela kalendarza Dim_Date

## Czego się nauczyłem
- osobna tabela dat
- `List.Min`, `List.Max`, `List.Dates`
- dynamiczny kalendarz
- Year, Quarter, Month
- sortowanie miesięcy
- `Year_Month_Sort`
- oznaczenie tabeli dat
- relacja dat z tabelą faktów

## Zastosowanie w projekcie
Utworzyłem `Dim_Date` na podstawie zakresu `Walmart_Sales_Cleaned[Date_Sales]`.

Relacja:
```text
Dim_Date[Date] 1 ───── * Walmart_Sales_Cleaned[Date_Sales]
```

Dodałem m.in.:
```text
Year
Quarter
Month_Number
Month_Name
Year_Month
Year_Month_Sort
Week_Number
```

## Problem
`Month_Name` może sortować się alfabetycznie.

## Rozwiązanie
```text
Month_Name → Sortuj według → Month_Number
Year_Month → Sortuj według → Year_Month_Sort
```

## Wniosek
Tabela dat jest podstawą Time Intelligence. Jeden wiersz `Dim_Date` reprezentuje jeden dzień.
