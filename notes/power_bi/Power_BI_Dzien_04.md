# Power BI – Dzień 4 – Model danych i relacja 1:*

## Czego się nauczyłem
- tabela faktów vs tabela wymiaru
- kardynalność
- relacja `1:*`
- pojedynczy kierunek filtrowania
- relacja aktywna
- podstawy schematu gwiazdy
- testowanie relacji

## Zastosowanie w projekcie
Tabela wymiaru:
```text
Stores_Metadata
```

Tabela faktów:
```text
Walmart_Sales_Cleaned
```

Relacja:
```text
Stores_Metadata[Store] 1 ───── * Walmart_Sales_Cleaned[Store]
```

## Problem
Relacja `*:*` albo niepotrzebne filtrowanie dwukierunkowe zwiększa złożoność modelu.

## Rozwiązanie
Ustawiłem `1:*`, kierunek pojedynczy i aktywną relację. Działanie sprawdziłem segmentatorem `Type`.

## Wniosek
W modelu gwiazdy wymiar opisuje obiekt biznesowy i filtruje fakty.
