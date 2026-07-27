# Dzień 1 - Audyt danych w Microsoft SQL Server

## Cel dnia

Sprawdzić, czy tabele `dbo.Walmart_Sales` i `dbo.Stores_Metadata` są poprawnym źródłem do analizy oraz przyszłego raportu Power BI.

## Najważniejsze pojęcia

- **Ziarnistość (grain)** - co reprezentuje jeden wiersz tabeli.
- **Tabela faktów** - zawiera zdarzenia i miary, tutaj tygodniową sprzedaż.
- **Tabela wymiaru** - opisuje obiekty biznesowe, tutaj sklepy.
- **Klucz** - kolumna identyfikująca rekord.
- **NULL** - brak wartości, a nie zero.
- **Duplikat** - niepożądane powtórzenie rekordu.
- **Relacja 1:\*** - jeden sklep w `Stores_Metadata` może występować wiele razy w `Walmart_Sales`.

## Model

```text
Stores_Metadata[Store]  1 -------- *  Walmart_Sales[Store]
```

## Plik SQL

Uruchom: `sql/01_data_audit.sql`.

Skrypt kontroluje:

1. istnienie tabel,
2. typy danych,
3. liczbę rekordów,
4. wartości NULL,
5. unikalność `Store`,
6. unikalność pary `Store + Date`,
7. pełne duplikaty,
8. zakres dat,
9. zgodność kluczy między tabelami,
10. liczbę rekordów przed i po JOIN.

## Wartości referencyjne z oryginalnych plików CSV

| Kontrola | Wartość referencyjna |
|---|---:|
| `Walmart_Sales.csv` | 6435 rekordów |
| `stores.csv` | 45 rekordów |
| Unikalne sklepy | 45 |
| Rekordy na sklep | 143 |
| Zakres dat | 2010-02-05 - 2012-10-26 |
| Pełne duplikaty w CSV | 0 |
| Duplikaty `Store + Date` | 0 |
| Braki danych | 0 |

Jeżeli tabela SQL ma 12870 rekordów i 6435 nadmiarowych duplikatów, oznacza to najprawdopodobniej podwójny import danych. W dniu 1 niczego nie usuwamy - najpierw dokumentujemy problem.

## Zadanie praktyczne

Uruchom cały skrypt i zapisz wyniki kontroli:

- liczba rekordów obu tabel,
- liczba unikalnych sklepów,
- liczba pełnych duplikatów,
- liczba nadmiarowych rekordów,
- zakres dat,
- wynik kontroli relacji,
- liczba wierszy przed i po JOIN.



## Co zapamiętać

- Analizy nie zaczynamy od wykresu, lecz od kontroli danych.
- `COUNT(*)` liczy wiersze, a `COUNT(DISTINCT Store)` liczy sklepy.
- Strona `1` relacji musi mieć unikalny klucz.
- JOIN może zwielokrotnić rekordy, gdy klucz wymiaru nie jest unikalny.
- Duplikatów nie usuwamy automatycznie bez ustalenia przyczyny.


## Utworzenie tabeli oczyszczonej

Na podstawie tabeli surowej `dbo.Walmart_Sales` utworzono tabelę
`dbo.Walmart_Sales_Cleaned`.

Wyniki:

- liczba rekordów surowych: 12 870,
- liczba rekordów unikalnych: 6 435,
- liczba usuniętych nadmiarowych rekordów: 6 435,
- przyczyna: podwójny import danych,
- daty przekonwertowano z formatu `dd-MM-yyyy` do typu `date`,
- kolumny liczbowe przekonwertowano z `varchar` na właściwe typy numeryczne.