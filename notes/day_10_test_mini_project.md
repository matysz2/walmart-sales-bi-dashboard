# Dzień 10 - test i mini projekt SQL

## Cel dnia

Utrwalenie materiału z dni 1-9:

- SELECT, TOP, DISTINCT, aliasy, ORDER BY
- WHERE, AND, OR, IN, BETWEEN, NULL
- COUNT, SUM, AVG, MIN, MAX, GROUP BY, HAVING
- CASE
- INNER JOIN
- LEFT JOIN

## Mini projekt

Przygotuj ranking sklepów za 2012 rok zawierający:

- numer sklepu,
- typ sklepu,
- powierzchnię,
- liczbę tygodni,
- sprzedaż łączną,
- średnią sprzedaż,
- najwyższą sprzedaż,
- klasyfikację wyniku.

## Klasyfikacja

- `AVG >= 1800000` - Bardzo wysoka
- `AVG >= 1400000` - Wysoka
- `AVG >= 1000000` - Srednia
- pozostałe - Niska

## Kontrola

- 45 sklepów
- pierwszy sklep: 4

## Najważniejsze zasady

- `WHERE` filtruje rekordy.
- `HAVING` filtruje grupy.
- `COUNT(*)` liczy wiersze.
- `COUNT(kolumna)` pomija `NULL`.
- `INNER JOIN` zwraca dopasowania.
- `LEFT JOIN` zachowuje lewą tabelę.
- `CASE` sprawdza warunki od góry.
