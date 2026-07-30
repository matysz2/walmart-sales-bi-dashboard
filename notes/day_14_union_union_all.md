# Dzień 14 - UNION i UNION ALL

## Cel dnia

Nauczyć się łączyć wyniki kilku zapytań `SELECT` jeden pod drugim oraz świadomie wybierać między `UNION` i `UNION ALL`.

## Najważniejsza definicja

- `JOIN` najczęściej dodaje kolumny poziomo.
- `UNION` i `UNION ALL` dodają wiersze pionowo.

## Składnia

```sql
SELECT kolumna_1, kolumna_2
FROM tabela_1
UNION ALL
SELECT kolumna_1, kolumna_2
FROM tabela_2
ORDER BY kolumna_1;
```

## UNION a UNION ALL

| Operator | Działanie |
|---|---|
| `UNION` | Łączy wyniki i usuwa identyczne wiersze. |
| `UNION ALL` | Łączy wyniki i zachowuje wszystkie wiersze. |

`UNION ALL` jest zazwyczaj szybszy, ponieważ SQL Server nie musi wyszukiwać i usuwać duplikatów.

## Warunki poprawnego użycia

1. Każdy `SELECT` musi zwracać tę samą liczbę kolumn.
2. Kolumny na tych samych pozycjach muszą mieć zgodne typy danych.
3. Kolejność kolumn musi mieć ten sam sens biznesowy.
4. Nazwy kolumn wyniku pochodzą z pierwszego `SELECT`.
5. `ORDER BY` zapisujemy tylko po ostatnim `SELECT`.

## Przykład Walmart

```sql
SELECT Store, Type, Size
FROM dbo.Stores_Metadata
WHERE Type = 'A'
UNION ALL
SELECT Store, Type, Size
FROM dbo.Stores_Metadata
WHERE Type = 'B'
ORDER BY Type, Store;
```

Kontrola: typ A ma 22 sklepy, typ B ma 17 sklepów, więc wynik powinien mieć 39 wierszy.

## Co zapamiętać

- `UNION` może zmniejszyć liczbę rekordów, ponieważ usuwa identyczne wiersze.
- `UNION ALL` zachowuje pełny zestaw danych.
- SQL łączy kolumny według ich pozycji, a nie nazwy.
- W analizie danych warto dodać kolumnę `Zrodlo`, aby zachować informację o pochodzeniu rekordu.
- W raportach okresowych i segmentowych najczęściej stosuje się `UNION ALL`.

## Test wiedzy

1. Do czego służy `UNION`?
2. Jaka jest różnica między `UNION` i `UNION ALL`?
3. Dlaczego `UNION` może zwrócić mniej wierszy?
4. Jakie warunki muszą spełniać łączone zapytania?
5. Z którego `SELECT` pochodzą nazwy kolumn?
6. Gdzie zapisujemy `ORDER BY`?
7. Co się stanie przy różnej liczbie kolumn?
8. Dlaczego `UNION ALL` jest zwykle szybszy?
9. Jaka jest różnica między `JOIN` a `UNION`?
10. Jak wykorzystać `UNION` w projekcie Walmart?

1.UNION łączy wyniki zapytań pionowo i usuwa identyczne wiersze.
2.UNION usuwa duplikaty, a UNION ALL zachowuje wszystkie rekordy.
3.UNION może zwrócić mniej wierszy, ponieważ wykonuje deduplikację.
4.Zapytania muszą mieć tę samą liczbę kolumn, zgodne typy danych i tę 5.samą logiczną kolejność kolumn.
5.Nazwy końcowych kolumn pochodzą z pierwszego SELECT.
6.ORDER BY zapisujemy jeden raz, po ostatnim SELECT.
7.Różna liczba kolumn spowoduje błąd SQL Server.
8.UNION ALL jest szybszy, ponieważ nie wyszukuje i nie usuwa duplikatów.
9.JOIN zwykle dodaje kolumny poziomo, a UNION dodaje wiersze pionowo.
10.W Walmart UNION ALL służy do łączenia okresów, segmentów sklepów i raportów o