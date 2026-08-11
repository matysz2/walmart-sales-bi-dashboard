# Power Query – Dzień 1 – Import i profilowanie danych

## Czego się nauczyłem
- czym jest zapytanie w Power Query
- różnica między krokami `Źródło` i `Nawigacja`
- profilowanie kolumn
- wartości odrębne i unikatowe
- profilowanie pierwszych 1000 wierszy vs całego zbioru
- poprawne typy danych
- różnica `Duplikuj` vs `Odwołanie`

## Zastosowanie w projekcie
Zaimportowałem:
- `Walmart_Sales_Cleaned`
- `Stores_Metadata`

Sprawdziłem typy danych, jakość kolumn i usunąłem pomocniczą kolumnę nawigacyjną `Stores_Metadata`.

## Problem
Profilowanie tylko pierwszych 1000 wierszy może przeoczyć błędy, `NULL` lub nietypowe wartości.

## Rozwiązanie
Włączyłem profilowanie całego zestawu danych.

## Wniosek
Przed analizą sprawdzam typy, braki, błędy, wartości odrębne i unikatowe. Power Query transformuje dane bez bezpośredniej zmiany źródła.
