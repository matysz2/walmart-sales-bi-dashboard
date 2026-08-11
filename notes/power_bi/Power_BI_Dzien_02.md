# Power Query – Dzień 2 – Odwołania, Query Folding i audyt

## Czego się nauczyłem
- `Odwołanie` vs `Duplikuj`
- tworzenie zapytań pomocniczych
- filtrowanie zakresu dat
- Query Folding
- `Wyświetl zapytanie natywne`
- wyłączanie ładowania
- zależności zapytań
- grupowanie zapytań

## Zastosowanie w projekcie
Utworzyłem `Audit_Sales_2012` jako odwołanie do `Walmart_Sales_Cleaned`.

Filtr:
```text
Date_Sales >= 01.01.2012
Date_Sales <  01.01.2013
```

Zapytanie trafiło do grupy `99_Audit` i ma wyłączone ładowanie.

## Problem
Zapytanie kontrolne jest potrzebne w Power Query, ale nie powinno tworzyć tabeli w modelu.

## Rozwiązanie
Wyłączyłem `Włącz ładowanie`.

## Wniosek
Query Folding może przenieść filtrowanie do SQL Servera, dzięki czemu mniej danych trafia do Power BI i odświeżanie może być szybsze.
