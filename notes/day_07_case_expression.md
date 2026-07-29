# Dzień 7 - CASE w SQL Server

## Cel dnia

Nauczyć się tworzyć kategorie biznesowe na podstawie warunków oraz stosować `CASE` w raportach i agregacjach.

## Najważniejsza składnia

```sql
CASE
    WHEN warunek_1 THEN wynik_1
    WHEN warunek_2 THEN wynik_2
    ELSE wynik_pozostaly
END AS Nazwa_Kolumny
```

SQL Server sprawdza warunki od góry i zwraca wynik pierwszego spełnionego warunku.

## CASE prosty

```sql
CASE Holiday_Flag
    WHEN 1 THEN 'Tak'
    WHEN 0 THEN 'Nie'
    ELSE 'Brak danych'
END AS Czy_Swieto
```

## CASE WHEN

```sql
CASE
    WHEN Weekly_Sales >= 2000000 THEN 'Bardzo wysoka'
    WHEN Weekly_Sales >= 1500000 THEN 'Wysoka'
    WHEN Weekly_Sales >= 1000000 THEN 'Srednia'
    ELSE 'Niska'
END AS Kategoria_Sprzedazy
```

## Agregacja warunkowa

```sql
SUM(
    CASE
        WHEN Holiday_Flag = 1 THEN Weekly_Sales
        ELSE 0
    END
) AS Sprzedaz_Swiateczna
```

```sql
SUM(
    CASE
        WHEN Holiday_Flag = 1 THEN 1
        ELSE 0
    END
) AS Liczba_Tygodni_Swiatecznych
```

## Typowe błędy

- brak `END`,
- zła kolejność warunków progowych,
- brak `ELSE`,
- mieszanie wyników tekstowych i liczbowych,
- użycie aliasu z `SELECT` w `WHERE`,
- literówki w nazwach kolumn.

## Co zapamiętać

- `CASE` zwraca jedną wartość.
- Pierwszy prawdziwy warunek kończy sprawdzanie.
- Progi `>=` zapisuj od najwyższego do najniższego.
- `CASE` nie zmienia danych w tabeli.
- `SUM(CASE WHEN ... THEN 1 ELSE 0 END)` liczy rekordy spełniające warunek.

## Zadanie praktyczne

Przygotuj raport klasyfikacji sklepów za rok 2012:

- `Store AS Numer_Sklepu`,
- `COUNT(*) AS Liczba_Tygodni`,
- `SUM(Weekly_Sales) AS Sprzedaz_Laczna`,
- `AVG(Weekly_Sales) AS Srednia_Sprzedaz`,
- kategoria przez `CASE`.

Progi średniej:

- `>= 1800000` - Bardzo wysoka,
- `>= 1400000` - Wysoka,
- `>= 1000000` - Srednia,
- pozostałe - Niska.

Kontrola: 45 sklepów, pierwszy sklep 4, poziom sklepu 4 - Bardzo wysoka.
