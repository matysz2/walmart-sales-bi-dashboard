# Power Query – Dzień 3 – Audyt jakości danych

## Czego się nauczyłem
- ziarnistość tabeli
- kontrola duplikatów
- `Grupuj według`
- `Records_Count`
- kontrola braków
- kontrola `Holiday_Flag`
- `Lewe anty`
- integralność między tabelami
- kontrola jakości vs czyszczenie

## Zastosowanie w projekcie
Ziarnistość:
```text
jeden sklep + jeden tydzień
```

Klucz biznesowy:
```text
Store + Date_Sales
```

Utworzyłem:
- `Audit_Duplicates_Store_Date`
- `Audit_Missing_Values`
- `Audit_Invalid_Holiday_Flag`
- `Audit_Stores_Not_Matched`

## Problem
Duplikaty mogą zawyżać sprzedaż, średnie, rankingi i KPI.

## Rozwiązanie
Grupuję po `Store + Date_Sales` i sprawdzam:
```text
Records_Count > 1
```

Do kontroli sklepów używam `LEFT ANTI`.

## Wniosek
Najpierw wykrywam i rozumiem problem, potem decyduję o czyszczeniu. Nie każdy duplikat należy automatycznie usuwać.
