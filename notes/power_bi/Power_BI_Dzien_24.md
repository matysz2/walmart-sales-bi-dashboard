# Power BI - Dzien 24
## Finalizacja projektu Walmart, portfolio, README i GitHub

**Projekt:** Walmart Sales Performance Analysis  
**Etap:** finalizacja projektu Power BI  
**Cel:** przygotowanie projektu w formie gotowej do pokazania rekruterowi i publikacji na GitHub.

---

## Cel dnia

Po Dniu 24 potrafie:

- przeprowadzic finalny audyt raportu Power BI,
- ocenic czy model danych jest gotowy do portfolio,
- usunac elementy testowe i techniczne, ktore nie powinny zostac w wersji finalnej,
- przygotowac logiczna strukture repozytorium,
- wybrac screenshoty do dokumentacji,
- przygotowac README w jezyku angielskim i polskim,
- opisac architekture rozwiazania BI,
- opisac cel biznesowy i najwazniejsze wnioski,
- przygotowac finalny plik `.pbix` do repozytorium,
- wykonac finalny commit Git.

---

# 1. Co zostalo zbudowane

Projekt Walmart nie jest juz pojedynczym dashboardem. Jest to kompletne rozwiazanie BI obejmujace kilka warstw:

```text
Pliki CSV
    |
    v
Microsoft SQL Server
    |
    v
Audyt i czyszczenie danych
    |
    v
SQL - analiza, widoki, procedury, indeksy
    |
    v
Power Query
    |
    v
Model semantyczny Power BI
    |
    v
DAX
    |
    v
Raport Power BI
    |
    v
RLS / Dynamic RLS
    |
    v
Power BI Service
    |
    v
Gateway / Refresh / App / Dashboard
```

Projekt pokazuje wiec caly podstawowy workflow pracy BI Analysta.

---

# 2. Cel biznesowy projektu

Celem biznesowym jest analiza wynikow sprzedazy sieci Walmart oraz dostarczenie managementowi narzedzia pozwalajacego monitorowac kluczowe KPI i porownywac wyniki sklepow.

Raport odpowiada miedzy innymi na pytania:

1. Ktore sklepy generuja najwyzsza sprzedaz?
2. Jak sprzedaz zmienia sie w czasie?
3. Jak wyglada dynamika YoY?
4. Jak roznia sie wyniki sklepow typu A, B i C?
5. Czy tygodnie swiateczne roznia sie od pozostalych tygodni?
6. Jak wyglada ranking sklepow?
7. Jaki jest udzial sklepu w sprzedazy wybranej grupy?
8. Jak wyglada szczegolowa historia pojedynczego sklepu?
9. Jak ograniczyc dostep do danych dla roznych uzytkownikow?
10. Jak opublikowac i odswiezac raport w Power BI Service?

---

# 3. Finalny model Power BI

Finalna wersja modelu zawiera piec tabel:

```text
             Dim_Date
                1
                |
                *
      Walmart_Sales_Cleaned
                *
                |
                1
        Stores_Metadata


_Measures              RLS_UserAccess
```

Role tabel:

- `Walmart_Sales_Cleaned` - tabela faktow,
- `Stores_Metadata` - wymiar sklepu,
- `Dim_Date` - wymiar daty,
- `_Measures` - dedykowana tabela na miary DAX,
- `RLS_UserAccess` - tabela pomocnicza dla Dynamic RLS.

Finalny model nie zawiera tabeli `Walmart_Sales_IR_Test`. Byla ona wykorzystywana tylko do demonstracji Incremental Refresh i zostala usunieta z wersji portfolio.

---

# 4. Dlaczego usunieto tabele testowa Incremental Refresh

Tabela:

```text
Walmart_Sales_IR_Test
```

byla technicznym cwiczeniem z Dnia 22.

Pozostawienie jej w modelu portfolio powodowaloby:

- duplikacje danych sprzedazowych,
- mniej czytelny model,
- pytanie rekrutera, dlaczego istnieja dwie prawie identyczne tabele faktow,
- niepotrzebne zwiekszenie zlozonosci projektu.

Dlatego:

```text
wersja szkoleniowa
-> tabela IR zostaje w dokumentacji

wersja portfolio
-> tabela IR jest usunieta
```

Dokumentacja i screenshot `incremental-refresh-history.png` nadal pozostaja w repozytorium jako dowod wykonania cwiczenia.

---

# 5. Audyt stron raportu

Finalny raport zawiera siedem stron.

## 01 - Overview

Glowna strona managerska.

Najwazniejsze elementy:

- Total Sales,
- Average Weekly Sales,
- Maximum Weekly Sales,
- Records Count,
- Stores Count,
- Year,
- Type,
- Sales YoY,
- tabela podsumowujaca,
- bookmarki.

## 02 - Holiday Analysis

Analiza tygodni swiatecznych i nieswiatecznych:

- Holiday Sales,
- Holiday Sales Share %,
- Average Holiday Weekly Sales,
- Holiday Average Uplift %.

W ramach finalnego audytu poprawiono format roku z:

```text
2010,00
```

na:

```text
2010
```

## 03 - Time Analysis

Analiza Time Intelligence:

- Total Sales,
- Sales Previous Year,
- Sales YoY Change,
- Sales YoY %,
- Sales YTD,
- trend miesieczny.

## 04 - Store Ranking

Ranking sklepow wedlug wynikow sprzedazowych:

- Store Rank,
- Top Stores,
- Top Store Sales,
- Year,
- Type.

## 05 - Selected Analysis

Analiza kontekstu zaznaczenia:

- Selected Stores Sales,
- Store Sales Share %,
- Store Sales Share Selected %,
- Store Rank,
- Store Rank Selected.

Strona pokazuje praktyczne zastosowanie `ALL` i `ALLSELECTED`.

## 06 - Store Details

Strona Drill-through dla pojedynczego sklepu:

- Total Sales,
- Average Weekly Sales,
- Sales Previous Year,
- Sales YoY %,
- Holiday Sales,
- Non-Holiday Records Count,
- Type,
- Size,
- trend sprzedazy.

## 07 - Store Tooltip

Kompaktowa strona Tooltip pokazujaca kontekst wybranego sklepu.

---

# 6. Screenshoty portfolio

W repozytorium zostaly przygotowane zarowno screenshoty raportowe, jak i techniczne.

Najwazniejsze screenshoty raportu:

```text
overview.png
holiday-analysis.png
time-analysis.png
store-ranking.png
selected-analysis.png
store-details-drillthrough.png
store-tooltip.png
data-model.png
mobile-layout.png
```

Screenshoty techniczne:

```text
dynamic-rls-success.png
gateway-online.png
incremental-refresh-history.png
refresh-history-success.png
semantic-model-gateway-mapping.png
dax-query-view-filter-context-type-c.png
dax-query-view-sales-by-store-type.png
walmart-model-cardinality-audit.png
powerbi-app-view.png
total-sales-data-alert.png
```

Do glownego README nie trzeba dodawac wszystkich screenshotow. README powinien pokazac kilka najwazniejszych elementow, a pozostale moga zostac jako dokumentacja techniczna.

---

# 7. Struktura repozytorium

Finalna struktura projektu:

```text
walmart-sales-performance-analysis/
|
|-- README.md
|-- README_PL.md
|-- struktura.txt
|
|-- data/
|   |-- raw/
|   |   |-- stores.csv
|   |   `-- Walmart_Sales.csv
|   `-- processed/
|
|-- docs/
|   `-- screenshots/
|
|-- notes/
|   |-- power_bi/
|   `-- sql/
|
|-- powerbi/
|   `-- Walmart_Sales_SQL.pbix
|
`-- sql/
    |-- 01_data_audit.sql
    |-- ...
    `-- 25_test_project.sql
```

Pelna lista plikow moze pozostac w `struktura.txt`.

Dzieki temu README pozostaje czytelny, a szczegolowa struktura nadal jest dostepna w repozytorium.

---

# 8. README

W projekcie znajduja sie dwie wersje:

```text
README.md
README_PL.md
```

`README.md` jest glowna wersja angielska przeznaczona przede wszystkim do GitHub i rekrutacji.

`README_PL.md` zawiera pelny opis projektu po polsku.

README zawiera:

- Project Overview / Opis projektu,
- Business Goal / Cel biznesowy,
- zrodla danych,
- technologie,
- jakosc danych,
- model SQL,
- model Power BI,
- SQL Analysis,
- Power Query,
- DAX,
- opis stron raportu,
- RLS,
- Power BI Service,
- Gateway,
- Incremental Refresh,
- Performance Analyzer,
- Mobile Layout,
- najwazniejsze wnioski,
- screenshoty,
- strukture repo,
- instrukcje uruchomienia,
- status projektu,
- umiejetnosci,
- mozliwe dalsze rozwiniecia,
- podsumowanie na rozmowe rekrutacyjna.

---

# 9. Najwazniejsze technologie i funkcjonalnosci

## SQL

- SELECT / WHERE / GROUP BY / HAVING,
- JOIN,
- UNION,
- CTE,
- Window Functions,
- ROW_NUMBER,
- RANK,
- DENSE_RANK,
- LAG,
- LEAD,
- VIEW,
- INDEX,
- Stored Procedures,
- Query Optimization.

## Power BI

- Power Query,
- Star Schema,
- DAX,
- Time Intelligence,
- `ALL`,
- `ALLSELECTED`,
- rankingi,
- Drill-through,
- Tooltip,
- Bookmarks,
- synchronizacja slicerow,
- RLS,
- Dynamic RLS,
- `USERPRINCIPALNAME()`,
- Power BI Service,
- Workspace,
- App,
- Audiences,
- Dashboard,
- Alerts,
- Subscriptions,
- Gateway,
- Refresh,
- Incremental Refresh,
- Performance Analyzer,
- DAX Query View,
- Mobile Layout,
- Alt Text,
- Tab Order.

---

# 10. Najwazniejsze wnioski biznesowe

Na podstawie analizy projektu:

- Store 20 wygenerowal najwyzsza calkowita sprzedaz w pelnym zbiorze danych.
- Wielkosc sklepu wykazala silna dodatnia zaleznosc z tygodniowa sprzedaza; korelacja wyniosla okolo `0.81`.
- Tygodnie swiateczne mialy wyzsza srednia tygodniowa sprzedaz niz tygodnie nieswiateczne.
- Calkowita sprzedaz nieswiateczna byla wyzsza, poniewaz takich obserwacji jest znacznie wiecej.
- Typ i wielkosc sklepu powinny byc analizowane lacznie.
- Korelacja nie oznacza zwiazku przyczynowo-skutkowego.

---

# 11. Finalizacja pliku PBIX

Finalny raport powinien zostac zapisany w:

```text
powerbi/Walmart_Sales_SQL.pbix
```

Przed dodaniem do repo nalezy sprawdzic:

- czy tabela `Walmart_Sales_IR_Test` zostala usunieta,
- czy nie ma niepotrzebnych relacji,
- czy wszystkie wizualizacje dzialaja,
- czy tooltip dziala,
- czy Drill-through dziala,
- czy bookmarki dzialaja,
- czy slicery maja prawidlowe formatowanie,
- czy tytuly nie sa uciete,
- czy plik zostal zapisany.

---

# 12. Finalny workflow Git

Przed commitem:

```powershell
git status
```

Sprawdzamy zmiany.

Nastepnie:

```powershell
git add .
```

Dodajemy zmiany do staging area.

Commit:

```powershell
git commit -m "docs: finalize Power BI portfolio project"
```

Znaczenie:

- `docs:` - zmiany dotycza finalizacji dokumentacji projektu,
- `finalize Power BI portfolio project` - opisuje zakres commita.

Po commicie:

```powershell
git status
```

Repo powinno byc czyste.

Jesli branch ma ustawiony upstream:

```powershell
git push
```

Jesli nie:

```powershell
git branch --show-current
```

a nastepnie:

```powershell
git push -u origin NAZWA_BRANCHA
```

---

# 13. Typowe bledy przy finalizacji portfolio

## 1. Zostawienie testowych tabel

Np. `Walmart_Sales_IR_Test`.

Finalny model powinien byc czysty.

## 2. Pusty folder `powerbi`

Repo pokazuje dokumentacje, ale nie zawiera finalnego raportu.

## 3. README opisuje funkcje jako "planned"

Jesli funkcja jest juz wykonana, powinna znajdowac sie w sekcji Completed.

## 4. Za duzo screenshotow w README

README ma prezentowac projekt, a nie dokumentowac kazde klikniecie.

## 5. Uciete tytuly i KPI

Finalne screenshoty musza byc czytelne.

## 6. README nie zawiera wnioskow biznesowych

Portfolio analityka powinno pokazywac nie tylko technologie, ale tez interpretacje danych.

## 7. Brak instrukcji uruchomienia

Rekruter powinien rozumiec, jak projekt jest zbudowany.

---

# 14. Co zapamietac

Dobry projekt portfolio BI powinien pokazac:

```text
problem biznesowy
       +
dane
       +
SQL
       +
model danych
       +
DAX
       +
wizualizacja
       +
security
       +
deployment
       +
dokumentacja
       +
wnioski biznesowe
```

Nie chodzi o jak najwieksza liczbe funkcji.

Najwazniejsze jest pokazanie, ze potrafimy zbudowac logiczne rozwiazanie od danych zrodlowych do gotowego raportu.

---

# 15. Test wiedzy - Dzien 24

## 1. Jaki jest cel biznesowy projektu Walmart?

Celem jest analiza wynikow sprzedazy Walmart oraz przygotowanie raportu wspierajacego monitorowanie KPI, trendow, rankingow i wynikow sklepow.

## 2. Co jest tabela faktow?

`Walmart_Sales_Cleaned`.

## 3. Co jest tabela wymiaru?

`Stores_Metadata` oraz `Dim_Date`.

## 4. Dlaczego zastosowano Star Schema?

Aby uproscic model, relacje, filtrowanie i tworzenie miar oraz zachowac czytelna separacje faktow i wymiarow.

## 5. Jaka role pelni Dim_Date?

Zapewnia poprawna analize czasu i funkcje Time Intelligence, takie jak Previous Year, YoY i YTD.

## 6. Dlaczego miary sa przechowywane w _Measures?

Dla lepszej organizacji modelu i latwiejszego zarzadzania DAX.

## 7. Jaka role pelni Power Query?

Laczy dane ze zrodlem, wykonuje transformacje, walidacje i przygotowuje dane do modelu.

## 8. Jaka role pelni DAX?

Tworzy dynamiczne obliczenia biznesowe reagujace na kontekst filtrowania raportu.

## 9. Co pokazuje YoY?

Zmiane wyniku w stosunku do analogicznego okresu poprzedniego roku.

## 10. Do czego sluzy ranking sklepow?

Pozwala identyfikowac sklepy o najlepszych i najslabszych wynikach w aktualnym kontekście.

## 11. Do czego sluzy Drill-through?

Pozwala przejsc z analizy ogolnej do szczegolow wybranego obiektu, np. sklepu.

## 12. Czym Tooltip rozni sie od Drill-through?

Tooltip pokazuje dodatkowe informacje po najechaniu, a Drill-through przenosi uzytkownika na osobna strone szczegolowa.

## 13. Po co zastosowano RLS?

Aby ograniczyc uzytkownikom dostep tylko do danych, do ktorych sa uprawnieni.

## 14. Po co Dynamic RLS wykorzystuje USERPRINCIPALNAME()?

Aby rozpoznac aktualnie zalogowanego uzytkownika i na tej podstawie zastosowac odpowiednie ograniczenie danych.

## 15. Do czego sluzy Gateway?

Umozliwia Power BI Service dostep do lokalnego zrodla danych, np. SQL Servera.

## 16. Co sprawdzalismy Performance Analyzerem?

Czasy wykonywania wizualizacji i zapytan DAX oraz potencjalne bottlenecki raportu.

## 17. Dlaczego Incremental Refresh byl demonstracja?

Poniewaz finalna tabela faktow ma tylko 6 435 rekordow i nie wymaga przyrostowego odswiezania ze wzgledow wydajnosciowych.

## 18. Po co przygotowano Mobile Layout?

Aby raport byl wygodny i czytelny na telefonie.

## 19. Co powinno znalezc sie w README?

Cel biznesowy, dane, technologie, architektura, model, opis analiz, funkcjonalnosci raportu, wnioski, screenshoty, instrukcja uruchomienia i struktura projektu.

## 20. Jak opisac projekt rekruterowi?

> Zbudowalem kompleksowe rozwiazanie BI do analizy sprzedazy Walmart. Dane zostaly zaimportowane i oczyszczone w SQL Server, a nastepnie przygotowalem analizy SQL, widoki, procedury i indeksy. W Power BI zbudowalem model Star Schema, tabele dat i miary DAX dla sprzedazy, YoY, YTD, rankingow oraz analizy kontekstu. Raport zawiera Drill-through, Tooltip, Bookmarks i RLS. Projekt opublikowalem do Power BI Service, skonfigurowalem Gateway i odswiezanie, a takze przeprowadzilem analize wydajnosci i przygotowalem Mobile Layout.

---

# 16. Zadanie praktyczne

1. Umiesc finalny `.pbix` w `powerbi/`.
2. Zaktualizuj `struktura.txt`.
3. Dodaj `Power_BI_Dzien_24.md` do `notes/power_bi/`.
4. Sprawdz oba README.
5. Sprawdz sciezki screenshotow w README.
6. Uruchom `git status`.
7. Wykonaj finalny commit.
8. Wykonaj push do GitHub.
9. Otworz repo na GitHub i sprawdz, czy obrazy oraz linki wyswietlaja sie prawidlowo.

---

# 17. Zadanie domowe

Przygotuj 60-sekundowa wypowiedz o projekcie bez czytania z notatek.

Powinna zawierac:

1. problem biznesowy,
2. zrodla danych,
3. proces przygotowania danych,
4. SQL,
5. model Power BI,
6. DAX,
7. najwazniejsze funkcjonalnosci,
8. Power BI Service,
9. jeden wniosek biznesowy,
10. czego nauczyles sie podczas projektu.

---

# 18. Status Dnia 24

Wykonane:

- finalny audyt raportu - OK,
- poprawa formatowania - OK,
- finalny model 5 tabel - OK,
- usuniecie tabeli testowej IR - OK,
- screenshoty portfolio - OK,
- README angielskie - OK,
- README polskie - OK,
- struktura repo - OK,
- dokumentacja Dnia 24 - OK.

Do wykonania lokalnie:

- skopiowanie finalnego `.pbix` do `powerbi/`,
- aktualizacja `struktura.txt`,
- commit i push na GitHub.

**Dzien 24 - zakonczony.**
