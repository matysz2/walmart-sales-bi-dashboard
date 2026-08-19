# Power BI — Dzień 22  
## Incremental Refresh, RangeStart / RangeEnd, Query Folding i partycje

> Projekt: **Walmart Sales Analytics**  
> Źródło danych: **Microsoft SQL Server**  
> Główna tabela faktów: `Walmart_Sales_Cleaned`  
> Tabela testowa do ćwiczenia: `Walmart_Sales_IR_Test`

---

## Cel dnia

Po tej lekcji powinienem umieć:

- wyjaśnić, czym jest **Incremental Refresh**,
- odróżnić **Full Refresh**, **Scheduled Refresh** i **Incremental Refresh**,
- utworzyć parametry `RangeStart` i `RangeEnd`,
- poprawnie zastosować filtr:
  - `Date_Sales_IR >= RangeStart`
  - `Date_Sales_IR < RangeEnd`,
- wyjaśnić, dlaczego Query Folding jest ważny,
- wyjaśnić, czym są partycje,
- skonfigurować politykę Incremental Refresh,
- opublikować model do Power BI Service,
- zweryfikować pierwsze i kolejne odświeżenie,
- wyjaśnić rolę Gateway przy Incremental Refresh.

---

# 1. Co to jest Incremental Refresh?

**Incremental Refresh** to odświeżanie przyrostowe.

Zamiast za każdym razem ponownie pobierać i przetwarzać całą historię danych, Power BI może odświeżać tylko wybrany, najnowszy zakres.

Przykład biznesowy:

```text
Pełna historia sprzedaży: 5 lat
Codziennie dopisywane są nowe rekordy

Full Refresh:
→ za każdym razem odśwież całą historię

Incremental Refresh:
→ przechowuj historię
→ odświeżaj tylko najnowszy zakres
```

---

# 2. Full Refresh vs Scheduled Refresh vs Incremental Refresh

## Full Refresh

Odpowiada za ponowne przetworzenie całego zbioru danych.

```text
Cała tabela
↓
pełne pobranie
↓
pełne przetworzenie
```

## Scheduled Refresh

Odpowiada na pytanie:

> **Kiedy uruchomić odświeżenie?**

Przykład:

```text
Codziennie o 21:00
```

## Incremental Refresh

Odpowiada na pytanie:

> **Jaki zakres danych odświeżyć?**

Przykład:

```text
Przechowuj 5 lat historii
Odświeżaj ostatnie 30 dni
```

Można więc mieć jednocześnie:

```text
Scheduled Refresh
codziennie o 21:00
        ↓
Incremental Refresh
odświeża tylko wybrany zakres
```

---

# 3. Co to jest partycja?

**Partycja** to logiczny fragment tabeli, który może być przetwarzany niezależnie od innych fragmentów.

Przykład:

```text
Walmart_Sales
│
├── 2022
├── 2023
├── 2024
├── 2025
└── 2026
```

W standardowym Incremental Refresh partycje są tworzone i zarządzane automatycznie przez Power BI Service na podstawie ustawionej polityki.

Na poziomie Junior BI Analyst wystarczy rozumieć:

> Power BI dzieli dużą tabelę faktów na zakresy czasu i dzięki temu nie musi za każdym razem odświeżać całej historii.

---

# 4. Parametry RangeStart i RangeEnd

Do Incremental Refresh potrzebujemy dwóch parametrów Power Query:

```text
RangeStart
RangeEnd
```

Ich nazwy muszą być zapisane dokładnie w tej formie.

Typ:

```text
Date/Time
```

czyli w polskiej wersji:

```text
Data/godzina
```

W ćwiczeniu użyto:

```text
RangeStart = 01.01.2012 00:00:00
RangeEnd   = 01.02.2012 00:00:00
```

W Power BI Desktop wartości te służą do filtrowania próbki danych podczas pracy.

---

# 5. Tabela testowa

Żeby nie modyfikować głównej tabeli faktów, utworzono odwołanie:

```text
Walmart_Sales_IR_Test
```

na podstawie:

```text
Walmart_Sales_Cleaned
```

Dzięki temu można było ćwiczyć Incremental Refresh bez ingerowania w główny model raportowy.

---

# 6. Kolumna Date_Sales_IR

Oryginalna kolumna:

```text
Date_Sales
```

pozostała bez zmian.

Do Incremental Refresh dodano pomocniczą kolumnę:

```text
Date_Sales_IR
```

typu:

```text
Date/Time
```

Przykładowa formuła Power Query:

```powerquery
DateTime.From([Date_Sales])
```

Przykład wartości:

```text
06.01.2012 00:00:00
13.01.2012 00:00:00
20.01.2012 00:00:00
```

---

# 7. Filtr Incremental Refresh

Na kolumnie `Date_Sales_IR` zastosowano dwa warunki:

```text
Date_Sales_IR >= RangeStart
AND
Date_Sales_IR < RangeEnd
```

Czyli dla:

```text
RangeStart = 01.01.2012 00:00:00
RangeEnd   = 01.02.2012 00:00:00
```

Power Query lokalnie pokazuje styczeń 2012.

---

# 8. Dlaczego >= RangeStart i < RangeEnd?

Najważniejszy wzorzec:

```text
>= RangeStart
<  RangeEnd
```

Przykład dwóch sąsiednich zakresów:

```text
Partycja 1:
01.01 <= data < 01.02

Partycja 2:
01.02 <= data < 01.03
```

Data:

```text
01.02 00:00:00
```

trafi wyłącznie do drugiego zakresu.

Nie stosujemy:

```text
>= RangeStart
<= RangeEnd
```

ponieważ wartość graniczna mogłaby znaleźć się w dwóch sąsiednich zakresach.

---

# 9. Query Folding

**Query Folding** oznacza, że transformacje Power Query mogą zostać przetłumaczone na zapytanie wykonywane po stronie źródła, np. SQL Servera.

Chcemy uzyskać zachowanie podobne do:

```sql
WHERE Date_Sales >= @RangeStart
  AND Date_Sales <  @RangeEnd
```

Dzięki temu SQL Server zwraca tylko potrzebny zakres danych.

Bez Query Folding mogłoby wyglądać to tak:

```text
SQL Server
↓
pobierz bardzo dużo rekordów
↓
Power BI
↓
dopiero wtedy filtruj
```

W dużych modelach byłoby to nieefektywne.

---

# 10. Jak sprawdzić Query Folding?

W Power Query:

1. wybieramy `Walmart_Sales_IR_Test`,
2. przechodzimy do ostatniego kroku filtra,
3. klikamy prawym przyciskiem myszy,
4. sprawdzamy opcję:

```text
Wyświetl zapytanie natywne
```

Jeśli opcja jest dostępna, Query Folding dla tego kroku jest zachowany.

---

# 11. Polityka Incremental Refresh

Dla ćwiczenia ustawiono:

```text
Odśwież przyrostowo tę tabelę: ON

Archiwizowanie danych:
20 lat

Odświeżanie przyrostowe:
15 lat
```

Dlaczego takie wartości?

Dane treningowe Walmart pochodzą z lat 2010–2012, a bieżący rok jest znacznie późniejszy. Standardowe ustawienie typu:

```text
3 lata historii
30 dni odświeżania
```

nie obejmowałoby danych treningowych.

Dlatego ustawiono szeroki zakres tylko na potrzeby demonstracji mechanizmu.

---

# 12. Ustawienia opcjonalne

W ćwiczeniu pozostawiono wyłączone:

```text
Pobieraj najnowsze dane w czasie rzeczywistym
Odświeżaj tylko pełne okresy
Wykryj zmiany danych
```

Na poziomie tego ćwiczenia nie były potrzebne.

---

# 13. Publish do Power BI Service

Po ustawieniu polityki model został opublikowany do Power BI Service.

Schemat:

```text
Power BI Desktop
        ↓
RangeStart / RangeEnd
        ↓
filtr zakresu
        ↓
Incremental Refresh Policy
        ↓
Publish
        ↓
Power BI Service
```

---

# 14. Gateway

Incremental Refresh nie zastępuje Gateway.

Architektura projektu:

```text
SQL Server lokalny
        ↓
On-premises Data Gateway
        ↓
Power BI Service
        ↓
Incremental Refresh
        ↓
Semantic Model
        ↓
Report
```

Gateway nadal zapewnia Power BI Service dostęp do lokalnego SQL Servera.

---

# 15. Pierwszy refresh

Pierwsze odświeżenie po publikacji trwało około:

```text
17:47:02 → 17:50:42
```

czyli około:

```text
3 minuty 40 sekund
```

Przy pierwszym odświeżeniu Power BI musi zastosować politykę i przygotować strukturę wymaganych partycji.

---

# 16. Drugie odświeżenie

Drugie odświeżenie trwało około:

```text
17:51:00 → 17:51:16
```

czyli około:

```text
16 sekund
```

To zachowanie jest zgodne z ideą Incremental Refresh: kolejne odświeżenia mogą być znacznie szybsze, ponieważ Power BI nie musi za każdym razem przetwarzać całej historii.

> Uwaga: sama różnica czasu nie jest technicznym dowodem zawartości poszczególnych partycji, ale jest prawidłowym wynikiem praktycznego testu.

---

# 17. Wynik praktyczny

```text
Pierwszy refresh
≈ 3 min 40 s
        ↓
zastosowanie polityki
+
utworzenie / przygotowanie partycji

Drugi refresh
≈ 16 s
        ↓
kolejne odświeżenie według polityki
```

---

# 18. Typowe błędy

## Błąd 1 — niepoprawna nazwa parametrów

Źle:

```text
rangestart
rangeend
```

Dobrze:

```text
RangeStart
RangeEnd
```

## Błąd 2 — zły typ parametrów

Źle:

```text
Date
```

Dobrze:

```text
Date/Time
```

## Błąd 3 — błędny górny warunek

Źle:

```text
Date >= RangeStart
Date <= RangeEnd
```

Dobrze:

```text
Date >= RangeStart
Date < RangeEnd
```

## Błąd 4 — brak Query Folding

Może spowodować, że Power BI pobierze zbyt dużo danych przed filtrowaniem.

## Błąd 5 — Incremental Refresh dla bardzo małej tabeli

Przykład:

```text
Stores_Metadata
45 rekordów
```

Nie ma praktycznej potrzeby stosowania Incremental Refresh dla tak małej tabeli wymiarowej.

## Błąd 6 — mylenie Scheduled Refresh z Incremental Refresh

```text
Scheduled Refresh
→ KIEDY?

Incremental Refresh
→ JAKI ZAKRES?
```

---

# 19. Co zapamiętać

Najważniejszy schemat:

```text
RangeStart + RangeEnd
        ↓
filtr daty
        ↓
Query Folding
        ↓
Incremental Refresh Policy
        ↓
Publish
        ↓
Power BI Service
        ↓
partycje
        ↓
odświeżanie nowszego zakresu
```

---

# 20. Test wiedzy — pytania i odpowiedzi

## 1. Co to jest Incremental Refresh?

Incremental Refresh to odświeżanie przyrostowe. Zamiast za każdym razem przetwarzać całą historię danych, Power BI przetwarza głównie zakres objęty polityką odświeżania.

## 2. Jaka jest różnica między Full Refresh i Incremental Refresh?

Full Refresh ponownie przetwarza cały zbiór danych. Incremental Refresh wykorzystuje zakresy i partycje, dzięki czemu nie musi za każdym razem przetwarzać całej historii.

## 3. Jaka jest różnica między Scheduled Refresh i Incremental Refresh?

Scheduled Refresh odpowiada na pytanie **kiedy** uruchomić odświeżenie, np. codziennie o 21:00. Incremental Refresh odpowiada na pytanie **jaki zakres danych** ma zostać przetworzony.

## 4. Co to jest RangeStart?

`RangeStart` to parametr Power Query typu Date/Time określający dolną granicę zakresu danych.

## 5. Co to jest RangeEnd?

`RangeEnd` to parametr Power Query typu Date/Time określający górną granicę zakresu danych.

## 6. Jakiego typu muszą być RangeStart i RangeEnd?

Muszą mieć typ:

```text
Date/Time
```

czyli Data/godzina.

## 7. Dlaczego nazwy parametrów muszą być zapisane dokładnie?

Power BI rozpoznaje specjalne parametry `RangeStart` i `RangeEnd` po ich nazwach. Wielkość liter ma znaczenie.

## 8. Dlaczego stosujemy >= RangeStart?

Ponieważ rekord równy dolnej granicy ma należeć do danego zakresu.

## 9. Dlaczego stosujemy < RangeEnd?

Ponieważ górna granica powinna być wyłączna, aby sąsiednie zakresy nie nakładały się na siebie.

## 10. Co mogłoby się stać przy <= RangeEnd?

Rekord znajdujący się dokładnie na granicy mógłby spełniać warunki dwóch sąsiednich zakresów.

## 11. Co to jest partycja?

Partycja to logiczny fragment tabeli, który może być przetwarzany niezależnie od innych fragmentów.

## 12. Kto tworzy partycje?

W standardowym Incremental Refresh tworzy je i zarządza nimi Power BI Service na podstawie skonfigurowanej polityki.

## 13. Co dzieje się podczas pierwszego refreshu?

Power BI Service stosuje politykę Incremental Refresh, przygotowuje strukturę partycji i ładuje wymagane dane historyczne oraz bieżące.

## 14. Co dzieje się podczas kolejnych refreshów?

Power BI przetwarza partycje należące do zakresu odświeżania, zamiast ponownie przetwarzać całą historię.

## 15. Dlaczego Query Folding jest ważny?

Pozwala przesunąć filtrowanie do źródła danych, np. SQL Servera, dzięki czemu Power BI pobiera tylko potrzebny zakres rekordów.

## 16. Jak sprawdzić Query Folding?

W Power Query można kliknąć prawym przyciskiem odpowiedni krok i sprawdzić:

```text
Wyświetl zapytanie natywne
```

## 17. Dlaczego Walmart_Sales_Cleaned jest dobrym kandydatem do Incremental Refresh?

Jest tabelą faktów, posiada kolumnę daty i w realnym systemie stale przybywałyby do niej nowe rekordy sprzedaży.

## 18. Dlaczego Stores_Metadata nie jest dobrym kandydatem?

Ponieważ ma około 45 rekordów. Pełne odświeżenie tak małej tabeli jest bardzo tanie.

## 19. Czy Incremental Refresh zastępuje Gateway?

Nie. Gateway nadal zapewnia Power BI Service dostęp do lokalnego SQL Servera.

## 20. Jak opisać Incremental Refresh rekruterowi?

> Skonfigurowałem Incremental Refresh dla tabeli faktów z SQL Servera. Utworzyłem parametry RangeStart i RangeEnd, zastosowałem filtr daty, skonfigurowałem politykę przechowywania i odświeżania, opublikowałem model do Power BI Service i zweryfikowałem historię odświeżeń. Rozumiem również znaczenie Query Folding, partycji i rolę Gateway.

---

# 21. Odpowiedź rekrutacyjna — wersja krótka

> Incremental Refresh pozwala ograniczyć zakres danych przetwarzanych podczas kolejnych odświeżeń. Zamiast każdorazowo odświeżać całą historię, Power BI wykorzystuje parametry RangeStart i RangeEnd oraz partycje. Ważne jest również zachowanie Query Folding, aby filtr zakresu dat był wykonywany możliwie po stronie źródła danych.

---

# 22. Odpowiedź rekrutacyjna — wersja projektowa

> W projekcie Walmart skonfigurowałem Incremental Refresh dla tabeli sprzedażowej pochodzącej z Microsoft SQL Server. Utworzyłem parametry RangeStart i RangeEnd, przygotowałem kolumnę Date/Time, zastosowałem filtr `>= RangeStart` i `< RangeEnd`, skonfigurowałem politykę przechowywania oraz zakres odświeżania i opublikowałem model do Power BI Service. Model korzysta z On-premises Data Gateway. Po publikacji zweryfikowałem historię odświeżeń — pierwsze odświeżenie trwało około 3 minut 40 sekund, a kolejne około 16 sekund.

---

# 23. Checklista Dnia 22

- [x] Utworzenie tabeli testowej `Walmart_Sales_IR_Test`
- [x] Utworzenie `RangeStart`
- [x] Utworzenie `RangeEnd`
- [x] Typ parametrów Date/Time
- [x] Przygotowanie kolumny `Date_Sales_IR`
- [x] Filtr `>= RangeStart`
- [x] Filtr `< RangeEnd`
- [x] Omówienie Query Folding
- [x] Konfiguracja polityki Incremental Refresh
- [x] Publikacja do Power BI Service
- [x] Gateway
- [x] Pierwszy refresh
- [x] Drugi refresh
- [x] Historia odświeżania
- [x] Porównanie czasu
- [x] Omówienie partycji
- [x] Odpowiedź rekrutacyjna

---

# 24. Screenshoty do dokumentacji

Sugerowane nazwy:

```text
docs/screenshots/day22-range-parameters.png
docs/screenshots/day22-incremental-refresh-policy.png
docs/screenshots/day22-refresh-history.png
```

Przykład użycia w README:

```markdown
![Incremental Refresh Policy](docs/screenshots/day22-incremental-refresh-policy.png)

![Refresh History](docs/screenshots/day22-refresh-history.png)
```

---

# 25. Co umiem po Dniu 22?

Po tej lekcji potrafię:

- wyjaśnić Incremental Refresh,
- skonfigurować `RangeStart` i `RangeEnd`,
- zastosować prawidłowy filtr dat,
- rozumieć znaczenie Query Folding,
- wyjaśnić podstawy partycjonowania,
- skonfigurować politykę odświeżania przyrostowego,
- opublikować model do Power BI Service,
- korzystać z Gateway przy lokalnym SQL Serverze,
- sprawdzić historię odświeżania,
- opisać cały mechanizm na rozmowie rekrutacyjnej.

---

## Najważniejszy wniosek

Incremental Refresh nie służy do przyspieszania każdej tabeli. Największą wartość daje przy dużych tabelach faktów, w których stale pojawiają się nowe rekordy, a ponowne przetwarzanie całej historii byłoby kosztowne.

W projekcie Walmart mechanizm został przećwiczony praktycznie na tabeli testowej, mimo że sam zbiór danych jest mały i nie wymagałby Incremental Refresh w realnym zastosowaniu.
