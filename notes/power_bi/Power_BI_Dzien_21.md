# Power BI - Dzień 21
## Performance Analyzer, DAX Query View i optymalizacja modelu

## Cel dnia

Po tej lekcji potrafię:

- uruchomić i interpretować **Performance Analyzer**,
- rozróżnić `Duration`, `DAX query`, `Visual display`, `Other` i `Direct query`,
- wykonać pomiar **BEFORE -> zmiana -> AFTER**,
- uruchomić zapytanie wizualizacji w **DAX Query View**,
- odróżnić miarę DAX od pełnego zapytania DAX wizualizacji,
- używać `EVALUATE`, `SUMMARIZECOLUMNS`, `TREATAS`, `ROW` i `ORDER BY`,
- wyjaśnić kardynalność kolumny,
- wykonać audyt modelu Walmart pod kątem kardynalności,
- ocenić, czy raport rzeczywiście wymaga optymalizacji.

---

## 1. Performance Analyzer

Performance Analyzer służy do pomiaru wydajności wizualizacji w Power BI Desktop.

Proces pracy:

```text
Start recording
    ↓
Refresh visuals / zmiana slicera
    ↓
znalezienie najwolniejszej wizualizacji
    ↓
analiza DAX query / Visual display / Other
    ↓
jedna zmiana
    ↓
ponowny pomiar
```

### Wynik audytu projektu Walmart

Eksport `PowerBIPerformanceData.json` zawiera rejestr wizualizacji, zapytań i interakcji. W zarejestrowanych próbach nie widać trwałego wąskiego gardła po stronie DAX. Wiele zapytań DAX wykonuje się w pojedynczych lub kilkudziesięciu milisekundach, a całkowite czasy wizualizacji pozostają zwykle poniżej około 1 sekundy.

**Wniosek:** na obecnym rozmiarze modelu nie ma uzasadnienia dla agresywnego przepisywania miar DAX tylko po to, aby "coś zoptymalizować".

---

## 2. Miara DAX a zapytanie DAX wizualizacji

Przykładowa miara:

```DAX
Total Sales =
SUM(Walmart_Sales_Cleaned[Weekly_Sales])
```

Wizualizacja nie wysyła jednak tylko tej miary. Power BI generuje pełne zapytanie uwzględniające m.in. filtry, osie, slicery i sortowanie.

W zarejestrowanym zapytaniu `Sales YoY %` wystąpiły m.in. filtry:

```DAX
TREATAS({2012}, 'Dim_Date'[Year])
TREATAS({"C"}, 'Stores_Metadata'[Type])
```

Czyli wizualizacja obliczała wynik w kontekście:

```text
Year = 2012
Type = C
```

---

## 3. DAX Query View

### Własne zapytanie - sprzedaż według typu sklepu

```DAX
EVALUATE
SUMMARIZECOLUMNS(
    'Stores_Metadata'[Type],
    "Total Sales", '_Measures'[Total Sales]
)
```

### Własne zapytanie - sprzedaż według Type dla 2012

```DAX
EVALUATE
SUMMARIZECOLUMNS(
    'Stores_Metadata'[Type],
    TREATAS(
        {2012},
        'Dim_Date'[Year]
    ),
    "Total Sales", '_Measures'[Total Sales]
)
ORDER BY
    [Total Sales] DESC
```

Wynik biznesowy dla 2012:

| Type | Total Sales |
|---|---:|
| A | 1 287 376 394,08 |
| B | 586 603 999,51 |
| C | 126 152 465,76 |

**Wniosek:** w 2012 najwyższą sprzedaż wygenerowały sklepy typu A, następnie B, a najmniejszą typu C.

---

## 4. Kardynalność

Kardynalność kolumny oznacza liczbę różnych wartości w tej kolumnie.

| Kolumna / wskaźnik | Wynik | Interpretacja |
|---|---:|---|
| Records | 6435 | Liczba rekordów tabeli faktów |
| Store | 45 | Niska kardynalność |
| Date_Sales | 143 | Niska kardynalność |
| Weekly_Sales | 6435 | Bardzo wysoka, ale kolumna niezbędna biznesowo |
| Holiday_Flag | 2 | Bardzo niska kardynalność |
| Temperature | 3528 | Wysoka - do oceny biznesowej w dużym modelu |
| Fuel_Price | 892 | Średnia/wysoka |
| CPI | 2145 | Wysoka - do oceny biznesowej w dużym modelu |
| Unemployment | 349 | Średnia |

Najważniejsza zasada:

> Wysoka kardynalność nie oznacza automatycznie, że kolumnę należy usunąć. Najpierw trzeba sprawdzić, czy jest potrzebna biznesowo lub technicznie.

Przykład: `Weekly_Sales` ma 6435 różnych wartości na 6435 rekordów, ale jest podstawową wartością faktu i musi pozostać w modelu.

---

## 5. Audyt modelu Walmart

```text
        Stores_Metadata
               1
               │
               *
Walmart_Sales_Cleaned
               *
               │
               1
            Dim_Date
```

Ocena:

| Obszar | Ocena |
|---|---|
| Star Schema | OK |
| Relacje 1:* | OK |
| Osobna Dim_Date | OK |
| Osobna tabela _Measures | OK |
| DAX Performance | dobra |
| Kardynalność przy obecnym rozmiarze | bez problemu |
| Znaczący bottleneck | nie wykryto |

Kolumny `Temperature`, `Fuel_Price`, `CPI` i `Unemployment` warto zostawić, jeśli będą używane do analiz biznesowych. Przy bardzo dużym modelu i braku ich wykorzystania byłyby kandydatami do ponownej oceny.

---

## 6. Odpowiedzi na pytania - Dzień 21

### 1. Co to jest Performance Analyzer?
Performance Analyzer to narzędzie w Power BI Desktop służące do pomiaru czasu wykonywania i wyświetlania poszczególnych wizualizacji. Pomaga ustalić, czy opóźnienie wynika z zapytania DAX, renderowania wizualizacji, DirectQuery czy innych operacji.

### 2. Do czego służy Start recording?
Start recording rozpoczyna rejestrowanie działań raportu. Od tego momentu Performance Analyzer zapisuje czasy operacji wykonywanych przez wizualizacje, np. po odświeżeniu strony lub zmianie slicera.

### 3. Co robi Refresh visuals?
Refresh visuals wymusza ponowne wykonanie wizualizacji na bieżącej stronie i zapisuje ich czasy w Performance Analyzer. Dzięki temu można wykonać porównywalny pomiar całej strony.

### 4. Co oznacza Duration?
Duration to całkowity czas obsługi danej wizualizacji w zarejestrowanej operacji. Nie należy go utożsamiać wyłącznie z DAX, bo może obejmować zapytanie, renderowanie i oczekiwanie na inne operacje.

### 5. Co oznacza DAX query?
DAX query to czas potrzebny modelowi semantycznemu na wykonanie zapytania DAX wygenerowanego dla wizualizacji. W projekcie Walmart zapytania DAX były krótkie i nie wykazały trwałego wąskiego gardła.

### 6. Co oznacza Visual display?
Visual display to czas potrzebny Power BI na narysowanie i aktualizację wizualizacji po otrzymaniu danych. Jeżeli ta część dominuje, problem może leżeć w samym typie lub złożoności wizualizacji, a nie w miarze DAX.

### 7. Co oznacza Other?
Other obejmuje pozostałe czynności i oczekiwanie związane z wykonaniem wizualizacji, m.in. przygotowanie operacji oraz kolejkę pracy względem innych elementów strony. Wysokiego Other nie należy automatycznie interpretować jako zły DAX.

### 8. Czym jest Direct query w Performance Analyzer?
Direct query pojawia się przy modelach korzystających z DirectQuery i oznacza czas oczekiwania na zewnętrzne źródło danych. W modelu Import nie jest głównym elementem pomiaru wizualizacji.

### 9. Co oznacza wysoki czas DAX query?
Wysoki DAX query sugeruje, że trzeba przeanalizować miary, kontekst filtrowania, liczbę relacji, iteratory, FILTER, RANKX, ALLSELECTED lub inne kosztowne obliczenia. Najpierw jednak trzeba potwierdzić problem pomiarem.

### 10. Co może oznaczać wysoki Visual display?
Może oznaczać, że dane są policzone szybko, lecz dużo czasu zajmuje ich narysowanie. Wtedy sprawdza się m.in. liczbę punktów, liczbę kolumn/wierszy tabeli, formatowanie warunkowe i ogólną złożoność visuala.

### 11. Dlaczego nie optymalizujemy raportu na oko?
Bo odczucie, że raport jest wolny, nie mówi, gdzie leży przyczyna. Poprawny proces to pomiar BEFORE, diagnoza konkretnego bottlenecku, jedna zmiana, pomiar AFTER i porównanie.

### 12. Co daje Copy query?
Copy query kopiuje pełne zapytanie DAX wygenerowane przez daną wizualizację. Dzięki temu można zobaczyć, jakie filtry, grupowania i miary Power BI rzeczywiście wysyła do modelu.

### 13. Jaka jest różnica między miarą DAX a zapytaniem DAX wizualizacji?
Miara to pojedyncza definicja obliczenia, np. Total Sales = SUM(...). Zapytanie wizualizacji jest szersze: korzysta z miary, ale dodaje osie, filtry, slicery, sortowanie i kontekst danego visuala.

### 14. Co to jest DAX Query View?
DAX Query View to widok w Power BI Desktop do uruchamiania zapytań DAX zwracających tabele. W Dniu 21 użyliśmy EVALUATE, SUMMARIZECOLUMNS, TREATAS i ORDER BY oraz uruchomiliśmy zapytanie pochodzące z Performance Analyzer.

### 15. Co to jest kardynalność?
W kontekście kolumn kardynalność oznacza liczbę różnych wartości w kolumnie. Nie należy mylić jej z kardynalnością relacji 1:*.

### 16. Dlaczego wysoka kardynalność może mieć znaczenie dla modelu?
Kolumny z bardzo dużą liczbą różnych wartości zwykle kompresują się gorzej w modelu kolumnowym i mogą zwiększać jego rozmiar. Nie oznacza to jednak, że każdą taką kolumnę należy usunąć - najpierw ocenia się jej znaczenie biznesowe.

### 17. Dlaczego Star Schema pomaga w budowie dobrego modelu Power BI?
Star Schema rozdziela tabelę faktów od tabel wymiarów, upraszcza relacje i przepływ filtrów oraz ułatwia tworzenie przewidywalnych miar. W projekcie Walmart fakt Walmart_Sales_Cleaned jest filtrowany przez Stores_Metadata i Dim_Date.

### 18. Dlaczego nie wykonujemy wielu zmian optymalizacyjnych jednocześnie?
Bo po wielu zmianach naraz nie wiadomo, która z nich rzeczywiście poprawiła lub pogorszyła wydajność. Lepszy proces to jedna zmiana i ponowny pomiar w tych samych warunkach.

### 19. Jak prawidłowo porównujesz raport przed i po optymalizacji?
Używam tego samego widoku, tych samych filtrów i podobnych warunków testu. Zapisuję wynik BEFORE, wprowadzam jedną zmianę, ponownie uruchamiam Performance Analyzer i porównuję wynik AFTER, zwracając uwagę na DAX query, Visual display i całkowity Duration.

### 20. Jak opowiedziałbyś rekruterowi, jak diagnozujesz wolny raport?
Najpierw mierzę raport w Performance Analyzer. Ustalam, które wizualizacje są najwolniejsze i czy czas pochodzi głównie z DAX czy renderowania. Potem sprawdzam model: Star Schema, relacje, liczbę kolumn, typy danych i kardynalność. Optymalizuję konkretny element i wykonuję ponowny pomiar, aby potwierdzić efekt.

---

## 7. Typowe błędy

- Optymalizacja raportu bez wcześniejszego pomiaru.
- Założenie, że wysoki `Duration` automatycznie oznacza wolny DAX.
- Usuwanie każdej kolumny o wysokiej kardynalności.
- Wprowadzanie wielu zmian naraz i brak możliwości wskazania, co pomogło.
- Mylenie miary DAX z pełnym zapytaniem wizualizacji.
- Zbyt duża liczba niepotrzebnych wizualizacji na jednej stronie.
- Traktowanie `Other` jako jednoznacznego błędu DAX.

---

## 8. Co zapamiętać

```text
Pomiar -> diagnoza -> jedna zmiana -> ponowny pomiar
```

- Performance Analyzer wskazuje, **gdzie** szukać problemu.
- DAX Query View pokazuje, **jakie zapytanie** rzeczywiście wykonuje model.
- Star Schema i rozsądna liczba kolumn upraszczają model.
- Kardynalność jest ważna głównie przy większej skali danych.
- Nie optymalizujemy rozwiązania, które nie ma mierzalnego problemu.

---

## 9. Odpowiedź rekrutacyjna

> Najpierw mierzę raport w Performance Analyzer. Ustalam, które wizualizacje są najwolniejsze i czy czas pochodzi z zapytania DAX, renderowania czy innych operacji. Następnie analizuję model danych: Star Schema, relacje, liczbę kolumn, typy danych i kardynalność. Wprowadzam jedną zmianę, wykonuję ponowny pomiar i porównuję wynik przed i po optymalizacji.

---

## 10. Screeny do dokumentacji projektu

Zalecane nazwy:

- `dax-query-view-generated-yoy-query.png`
- `dax-query-view-filter-context-type-c.png`
- `dax-query-view-sales-by-store-type.png`
- `dax-query-view-sales-by-store-type-2012.png`
- `walmart-model-cardinality-audit.png`

Proponowany katalog:

```text
docs/
└── screenshots/
    ├── dax-query-view-generated-yoy-query.png
    ├── dax-query-view-filter-context-type-c.png
    ├── dax-query-view-sales-by-store-type.png
    ├── dax-query-view-sales-by-store-type-2012.png
    └── walmart-model-cardinality-audit.png
```

## Zadanie domowe

1. Wyjaśnij własnymi słowami różnicę między `DAX query` i `Visual display`.
2. Podaj dwie sytuacje, w których wysoka kardynalność jest problemem.
3. Wyjaśnij, dlaczego nie usuwamy `Weekly_Sales` mimo kardynalności 6435/6435.
4. Opisz proces optymalizacji raportu w pięciu krokach.
5. Przygotuj 60-sekundową odpowiedź rekrutacyjną o Performance Analyzer.
