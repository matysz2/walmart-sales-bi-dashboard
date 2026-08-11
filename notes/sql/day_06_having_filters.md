# Dzien 6 - HAVING: filtrowanie wynikow grupowania

## Cel dnia

Po tej lekcji potrafisz filtrowac wyniki funkcji agregujacych i odrozniac `WHERE` od `HAVING`.

## Najwazniejsza zasada

```text
WHERE  -> filtruje rekordy przed GROUP BY
HAVING -> filtruje grupy po GROUP BY
```

## Schemat

```sql
SELECT
    kolumna_grupujaca,
    funkcja_agregujaca(kolumna) AS Alias
FROM tabela
WHERE warunek_dla_rekordow
GROUP BY kolumna_grupujaca
HAVING warunek_dla_grup
ORDER BY Alias DESC;
```

## Przyklad

```sql
SELECT
    Store AS Numer_Sklepu,
    SUM(Weekly_Sales) AS Sprzedaz_Laczna
FROM dbo.Walmart_Sales_Cleaned
GROUP BY Store
HAVING SUM(Weekly_Sales) > 200000000
ORDER BY Sprzedaz_Laczna DESC;
```

## WHERE i HAVING razem

```sql
SELECT
    Store AS Numer_Sklepu,
    COUNT(*) AS Liczba_Tygodni,
    SUM(Weekly_Sales) AS Sprzedaz_Laczna
FROM dbo.Walmart_Sales_Cleaned
WHERE Date_Sales >= '2012-01-01'
  AND Date_Sales <  '2013-01-01'
GROUP BY Store
HAVING SUM(Weekly_Sales) >= 50000000
ORDER BY Sprzedaz_Laczna DESC;
```

## Kolejnosc zapisu

```text
SELECT -> FROM -> WHERE -> GROUP BY -> HAVING -> ORDER BY
```

## Co zapamietac

- `WHERE` filtruje pojedyncze rekordy.
- `HAVING` filtruje gotowe grupy.
- Funkcje `SUM`, `AVG`, `COUNT`, `MIN` i `MAX` w warunku umieszczamy w `HAVING`.
- W `HAVING` najbezpieczniej powtorzyc cala funkcje agregujaca.
- Alias wyniku agregacji moze zostac uzyty w `ORDER BY`.

## Zadanie praktyczne

Przygotuj raport sklepow o wysokiej sprzedazy w 2011 roku. Pokaz:

- `Store AS Numer_Sklepu`,
- `COUNT(*) AS Liczba_Tygodni`,
- `SUM(Weekly_Sales) AS Sprzedaz_Laczna`,
- `AVG(Weekly_Sales) AS Srednia_Sprzedaz`,
- `MAX(Weekly_Sales) AS Najwyzsza_Sprzedaz`.

Warunki:

- caly rok 2011,
- `SUM(Weekly_Sales) >= 80000000`,
- `AVG(Weekly_Sales) >= 1500000`,
- sortowanie lacznej sprzedazy malejaco.

Kontrola: wynik powinien zawierac 9 sklepow, a pierwszy powinien byc sklep 4.

## Test wiedzy

1. Do czego sluzy `HAVING`?
2. Jaka jest roznica miedzy `WHERE` i `HAVING`?
3. Czy mozna uzyc `SUM()` w `WHERE`?
4. Gdzie zapisujemy `HAVING`?
5. Co filtruje `HAVING COUNT(*) >= 40`?
6. Czy `WHERE` i `HAVING` moga wystapic razem?
7. Dlaczego w `HAVING` powtarzamy funkcje agregujaca?
8. Jak wybrac sklepy ze srednia sprzedaza powyzej 1500000?
9. Jaka jest kolejnosc `WHERE`, `GROUP BY`, `HAVING`?
10. Co oznaczaja dwa warunki polaczone `AND` w `HAVING`?
