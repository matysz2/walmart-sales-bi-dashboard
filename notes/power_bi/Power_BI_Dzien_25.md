# Power BI - Dzień 25
## Test końcowy: wszystkie pytania i odpowiedzi

**Cel:** końcowe sprawdzenie wiedzy z Power Query, modelowania danych, DAX, UX, Power BI Service, RLS, wydajności i odświeżania.

**Wynik końcowy:** **58,5 / 65 pkt = 90%**

**Ocena:** bardzo dobry poziom Junior / gotowość do rozmów rekrutacyjnych, z kilkoma tematami do dalszego utrwalenia.

> Dokument zawiera wszystkie 55 pytań z Dnia 25, poprawione odpowiedzi wzorcowe oraz punktację uzyskaną podczas sprawdzania.


# CZĘŚĆ A - Model danych i Power Query
## 1. Co to jest tabela faktów i która tabela pełni tę rolę w projekcie Walmart?

**Odpowiedź wzorcowa:**  
Tabela faktów przechowuje zdarzenia biznesowe i wartości liczbowe, które analizujemy. W projekcie Walmart tabelą faktów jest `Walmart_Sales_Cleaned`. Jeden rekord reprezentuje sprzedaż danego sklepu dla konkretnej daty/tygodnia, a kolumna `Weekly_Sales` jest podstawową wartością liczbową do agregacji.

**Punktacja:** 1/1

---
## 2. Co to jest tabela wymiaru? Podaj dwa przykłady z naszego modelu.

**Odpowiedź wzorcowa:**  
Tabela wymiaru przechowuje dane opisowe, które służą do filtrowania, grupowania i opisywania danych z tabeli faktów. W projekcie przykładami są `Stores_Metadata` i `Dim_Date`. `Stores_Metadata` opisuje sklep przez m.in. typ i rozmiar, a `Dim_Date` opisuje datę przez rok, miesiąc i inne atrybuty czasu.

**Punktacja:** 0,75/1

---
## 3. Co oznacza relacja 1:* na przykładzie Stores_Metadata -> Walmart_Sales_Cleaned?

**Odpowiedź wzorcowa:**  
Relacja 1:* oznacza relację jeden-do-wielu. Jeden sklep występuje jeden raz po stronie `Stores_Metadata`, ale może mieć wiele rekordów sprzedaży po stronie `Walmart_Sales_Cleaned`, np. po jednym rekordzie dla każdego tygodnia.

**Punktacja:** 1/1

---
## 4. Dlaczego Store musi być unikalny po stronie Stores_Metadata?

**Odpowiedź wzorcowa:**  
Kolumna po stronie `1` relacji musi jednoznacznie identyfikować rekord. Jeden sklep powinien mieć jeden zestaw atrybutów, np. jeden typ i jeden rozmiar. Duplikaty po stronie wymiaru mogłyby uniemożliwić poprawną relację jeden-do-wielu lub powodować niejednoznaczne filtrowanie.

**Punktacja:** 1/1

---
## 5. Po co utworzyliśmy osobną tabelę Dim_Date zamiast korzystać tylko z Date_Sales w tabeli faktów?

**Odpowiedź wzorcowa:**  
Osobna tabela dat zapewnia ciągły kalendarz i poprawną obsługę Time Intelligence. Dzięki niej łatwiej budować miary takie jak Previous Year, YoY i YTD oraz filtrować dane po roku, miesiącu czy kwartale. `Dim_Date` jest też czytelnym, centralnym wymiarem czasu w modelu.

**Punktacja:** 0,75/1

---
## 6. Co to jest Star Schema i dlaczego jest korzystne w Power BI?

**Odpowiedź wzorcowa:**  
Star Schema to model, w którym centralna tabela faktów jest połączona bezpośrednio z tabelami wymiarów. W projekcie centralną tabelą jest `Walmart_Sales_Cleaned`, a wymiarami są m.in. `Stores_Metadata` i `Dim_Date`. Taki układ upraszcza relacje i DAX, poprawia czytelność modelu i zwykle sprzyja dobrej wydajności.

**Punktacja:** 0,75/1

---
## 7. Co to jest Query Folding?

**Odpowiedź wzorcowa:**  
Query Folding oznacza, że Power Query deleguje możliwe transformacje do źródła danych, np. do SQL Servera. Zamiast pobierać wszystkie dane i przetwarzać je lokalnie, Power Query może wygenerować odpowiednie zapytanie SQL, np. z `WHERE`, i wykonać pracę po stronie serwera.

**Punktacja:** 1/1

---
## 8. Dlaczego filtrowanie po stronie SQL Servera jest zwykle lepsze niż pobranie całej tabeli i filtrowanie jej lokalnie?

**Odpowiedź wzorcowa:**  
Do Power BI trafia mniej danych, więc zmniejsza się transfer sieciowy i zużycie pamięci. SQL Server jest zoptymalizowany do filtrowania dużych zbiorów i może korzystać z indeksów. W efekcie odświeżanie i transformacje są zwykle szybsze.

**Punktacja:** 1/1

---
## 9. Jaka jest różnica między Duplicate i Reference w Power Query?

**Odpowiedź wzorcowa:**  
`Duplicate` kopiuje aktualne kroki zapytania i tworzy zapytanie, które dalej może być rozwijane niezależnie. `Reference` tworzy nowe zapytanie, którego źródłem jest wynik pierwszego zapytania. Zmiany w zapytaniu bazowym mogą więc wpływać na zapytanie referencyjne.

**Punktacja:** 1/1

---
## 10. Dlaczego przed załadowaniem danych sprawdzaliśmy NULL, duplikaty, typy danych i zgodność Store między tabelami?

**Odpowiedź wzorcowa:**  
`NULL` może powodować brakujące wyniki lub problemy z kluczami, duplikaty mogą zawyżać agregacje, błędne typy danych utrudniają obliczenia i Time Intelligence, a niezgodność `Store` może powodować brak dopasowania do tabeli wymiaru. Audyt danych chroni raport przed błędnymi wynikami biznesowymi.

**Punktacja:** 0,75/1

---

# CZĘŚĆ B - DAX
## 11. Jaka jest różnica między miarą a kolumną obliczeniową?

**Odpowiedź wzorcowa:**  
Kolumna obliczeniowa jest liczona wiersz po wierszu podczas odświeżania modelu, a jej wyniki są przechowywane w modelu i zajmują pamięć. Miara jest obliczana dynamicznie podczas zapytania i reaguje na bieżący filter context. Miary są preferowane do agregacji takich jak suma, średnia, YoY czy udział procentowy.

**Punktacja:** 1/1

---
## 12. Co oznacza filter context? Podaj przykład z filtrami Year = 2012 i Type = A.

**Odpowiedź wzorcowa:**  
Filter context to zestaw filtrów aktywnych w momencie obliczania miary. Może pochodzić ze slicerów, filtrów strony, osi wykresu lub funkcji DAX. Jeśli użytkownik wybierze `Year = 2012` i `Type = A`, miara `Total Sales` policzy sprzedaż tylko dla rekordów spełniających oba warunki.

**Punktacja:** 1/1

---
## 13. Co robi CALCULATE()?

**Odpowiedź wzorcowa:**  
`CALCULATE()` oblicza wyrażenie w zmodyfikowanym kontekście filtra. Pozwala dodawać, zmieniać lub usuwać filtry. To jedna z najważniejszych funkcji DAX, ponieważ umożliwia budowanie miar takich jak sprzedaż świąteczna, sprzedaż poprzedniego roku czy udział procentowy.

**Punktacja:** 1/1

---
## 14. Wyjaśnij działanie: Total Sales = SUM(Walmart_Sales_Cleaned[Weekly_Sales]).

**Odpowiedź wzorcowa:**  
Miara sumuje wartości `Weekly_Sales` dla wierszy widocznych w aktualnym filter context. Bez filtrów zwróci sumę całej dostępnej sprzedaży, a po wybraniu np. roku 2012 i typu A zwróci sprzedaż tylko dla tego zakresu.

**Punktacja:** 1/1

---
## 15. Do czego wykorzystujemy SAMEPERIODLASTYEAR()?

**Odpowiedź wzorcowa:**  
`SAMEPERIODLASTYEAR()` przesuwa bieżący kontekst dat o rok wstecz. Używamy jej do porównywania tego samego okresu z poprzednim rokiem, np. maja 2012 do maja 2011. Wymaga poprawnej tabeli dat.

**Punktacja:** 1/1

---
## 16. Co oznacza YoY?

**Odpowiedź wzorcowa:**  
YoY oznacza Year-over-Year, czyli porównanie wyniku z tym samym okresem poprzedniego roku. Pomaga mierzyć wzrost lub spadek i ogranicza wpływ sezonowości, ponieważ porównujemy np. grudzień do grudnia, a nie grudzień do listopada.

**Punktacja:** 1/1

---
## 17. Jaka jest różnica między ALL() a ALLSELECTED()?

**Odpowiedź wzorcowa:**  
`ALL()` usuwa filtr z podanej tabeli lub kolumny. `ALLSELECTED()` zachowuje wybory użytkownika dokonane np. slicerami, ale może usunąć bardziej lokalny kontekst konkretnego wiersza lub punktu wizualizacji. Dzięki temu można np. policzyć udział jednego sklepu w sprzedaży wszystkich sklepów aktualnie zaznaczonych przez użytkownika.

**Punktacja:** 0,75/1

---
## 18. Do czego służy RANKX()?

**Odpowiedź wzorcowa:**  
`RANKX()` tworzy ranking elementów na podstawie wskazanego wyrażenia, np. rankingu sklepów według `Total Sales`. Możemy określić kolejność `ASC`/`DESC` oraz sposób obsługi remisów `Skip` lub `Dense`. W projekcie używaliśmy jej do rankingu sklepów.

**Punktacja:** 0,75/1

---
## 19. Dlaczego DIVIDE(A, B) jest zwykle bezpieczniejsze niż A / B?

**Odpowiedź wzorcowa:**  
`DIVIDE()` bezpiecznie obsługuje przypadek dzielenia przez zero. Domyślnie zwraca `BLANK()`, a opcjonalnie można podać wartość alternatywną, np. 0. Dzięki temu miara nie generuje problematycznych wyników.

**Punktacja:** 1/1

---
## 20. Co zwraca EVALUATE SUMMARIZECOLUMNS('Stores_Metadata'[Type], "Total Sales", '_Measures'[Total Sales])?

**Odpowiedź wzorcowa:**  
`SUMMARIZECOLUMNS()` grupuje dane według `Stores_Metadata[Type]` i oblicza miarę `Total Sales` dla każdego typu sklepu. `EVALUATE` powoduje zwrócenie tej tabeli wynikowej w DAX Query View. Wynik ma np. wiersze A, B i C oraz odpowiadającą im łączną sprzedaż.

**Punktacja:** 1/1

---

# CZĘŚĆ C - Raport i UX
## 21. Jaka jest różnica między Drill-through i Tooltip?

**Odpowiedź wzorcowa:**  
Drill-through przenosi użytkownika na osobną stronę szczegółową i przekazuje kontekst wybranego elementu, np. konkretnego sklepu. Tooltip pokazuje dodatkowe informacje po najechaniu kursorem bez opuszczania bieżącej strony.

**Punktacja:** 1/1

---
## 22. Do czego służą Bookmarks?

**Odpowiedź wzorcowa:**  
Bookmarks zapisują stan strony raportu, np. widoczność wizualizacji, wybrane filtry i inne ustawienia. Umożliwiają tworzenie przełączanych widoków, nawigacji i interaktywnych prezentacji. W zależności od potrzeb można kontrolować, czy zakładka zapisuje także stan danych.

**Punktacja:** 1/1

---
## 23. Po co synchronizujemy slicery między stronami raportu?

**Odpowiedź wzorcowa:**  
Synchronizacja slicerów pozwala zachować ten sam wybór użytkownika na wielu stronach. Dzięki temu po wybraniu np. roku 2012 użytkownik może przejść do rankingu lub analizy czasu bez ponownego ustawiania filtra.

**Punktacja:** 1/1

---
## 24. Co to jest Mobile Layout?

**Odpowiedź wzorcowa:**  
Mobile Layout to osobny układ strony raportu przygotowany pod urządzenia mobilne. Umożliwia ustawienie kolejności, rozmiaru i rozmieszczenia wizualizacji tak, aby raport był czytelny i wygodny na małym ekranie. Pionowe przewijanie jest dopuszczalne.

**Punktacja:** 0,75/1

---
## 25. Po co stosujemy Alt Text, Tab Order, czytelne tytuły i informację inną niż sam kolor?

**Odpowiedź wzorcowa:**  
Są to elementy dostępności i dobrego UX. `Alt Text` pomaga użytkownikom korzystającym z czytników ekranu, `Tab Order` ustala logiczną kolejność nawigacji klawiaturą, czytelne tytuły wyjaśniają znaczenie wizualizacji, a symbole i wartości oprócz koloru pomagają m.in. osobom z zaburzeniami rozpoznawania barw.

**Punktacja:** 1/1

---

# CZĘŚĆ D - Power BI Service
## 26. Jaka jest różnica między Report a Semantic Model w Power BI Service?

**Odpowiedź wzorcowa:**  
Semantic Model jest warstwą danych i logiki analitycznej: zawiera dane, relacje i miary DAX. Report jest warstwą prezentacyjną: zawiera strony, wykresy, karty, slicery i inne wizualizacje korzystające z modelu semantycznego.

**Punktacja:** 1/1

---
## 27. Jaka jest różnica między Workspace a Power BI App?

**Odpowiedź wzorcowa:**  
Workspace to przestrzeń robocza zespołu BI, w której tworzymy, publikujemy i zarządzamy raportami oraz modelami. Power BI App to gotowy pakiet treści udostępniany użytkownikom końcowym. App może zawierać wiele raportów i może mieć różne `Audiences`.

**Punktacja:** 0,75/1

---
## 28. Wymień cztery role Workspace.

**Odpowiedź wzorcowa:**  
Cztery role Workspace to: `Admin`, `Member`, `Contributor` i `Viewer`. Viewer jest typowym odbiorcą treści, a pozostałe role mają coraz większe uprawnienia do tworzenia i zarządzania zawartością.

**Punktacja:** 1/1

---
## 29. Dlaczego zwykły odbiorca raportu powinien zazwyczaj mieć rolę Viewer, a nie Admin?

**Odpowiedź wzorcowa:**  
Zasada najmniejszych uprawnień mówi, że użytkownik powinien otrzymać tylko te uprawnienia, których potrzebuje. Viewer może konsumować raport bez możliwości przypadkowego modyfikowania lub usuwania zawartości Workspace. Jest to również właściwa rola dla odbiorców, których dane mają być ograniczane przez RLS.

**Punktacja:** 1/1

---
## 30. Jaka jest różnica między Publish a Share?

**Odpowiedź wzorcowa:**  
`Publish` przesyła projekt z Power BI Desktop do Power BI Service. `Share` udostępnia już opublikowany raport lub inną zawartość konkretnym użytkownikom. Publish dotyczy wdrożenia treści, Share - nadania dostępu.

**Punktacja:** 1/1

---
## 31. Do czego służy On-premises Data Gateway?

**Odpowiedź wzorcowa:**  
On-premises Data Gateway jest bezpiecznym mostem między Power BI Service w chmurze a lokalnym źródłem danych, np. SQL Serverem. Dzięki niemu Service może odświeżać model bez bezpośredniego wystawiania lokalnej bazy do Internetu.

**Punktacja:** 1/1

---
## 32. Dlaczego komputer z Gateway musi mieć dostęp do lokalnego SQL Servera?

**Odpowiedź wzorcowa:**  
To Gateway wykonuje połączenie ze źródłem danych w imieniu Power BI Service. Jeśli maszyna z Gateway nie może połączyć się z SQL Serverem, Service również nie będzie w stanie pobrać danych podczas odświeżania.

**Punktacja:** 1/1

---
## 33. Jaka jest różnica między Refresh now a Scheduled refresh?

**Odpowiedź wzorcowa:**  
`Refresh now` uruchamia odświeżenie danych ręcznie w bieżącym momencie. `Scheduled refresh` uruchamia je automatycznie według harmonogramu, np. codziennie o 19:00. W przypadku lokalnego SQL Servera Service korzysta wtedy z Gateway do odświeżenia Semantic Model.

**Punktacja:** 0,75/1

---
## 34. Co to jest dashboard w Power BI Service i czym różni się od raportu?

**Odpowiedź wzorcowa:**  
Dashboard to jednostronicowy pulpit z kafelkami służący do szybkiego monitorowania KPI. Kafelki mogą pochodzić z różnych raportów i modeli semantycznych. Raport może mieć wiele stron i oferuje znacznie większą interaktywność analityczną.

**Punktacja:** 1/1

---
## 35. Do czego służą Alert i Subscription?

**Odpowiedź wzorcowa:**  
Alert powiadamia użytkownika po spełnieniu warunku wartości, np. gdy KPI spadnie poniżej progu. Subscription wysyła cyklicznie wiadomość e-mail z raportem lub dashboardem według harmonogramu. Najprościej: Alert reaguje na wartość, Subscription na czas/harmonogram.

**Punktacja:** 1/1

---

# CZĘŚĆ E - RLS i bezpieczeństwo
## 36. Co to jest Row-Level Security?

**Odpowiedź wzorcowa:**  
Row-Level Security ogranicza użytkownikowi dostęp do określonych wierszy danych w modelu semantycznym na podstawie zdefiniowanych reguł bezpieczeństwa. Dzięki temu jeden raport i jeden model mogą obsługiwać wielu użytkowników, z których każdy widzi tylko dozwolony zakres danych.

**Punktacja:** 0,75/1

---
## 37. Jaka jest różnica między Static RLS i Dynamic RLS?

**Odpowiedź wzorcowa:**  
Static RLS wykorzystuje stałą regułę, np. `Stores_Metadata[Type] = "A"`, a użytkownicy są ręcznie przypisywani do odpowiednich ról. Dynamic RLS wykorzystuje tożsamość użytkownika, np. przez `USERPRINCIPALNAME()`, i mapę uprawnień, dzięki czemu jedna rola może obsługiwać wielu użytkowników z różnym zakresem danych.

**Punktacja:** 1/1

---
## 38. Co zwraca USERPRINCIPALNAME()?

**Odpowiedź wzorcowa:**  
`USERPRINCIPALNAME()` zwraca identyfikator aktualnie zalogowanego użytkownika, najczęściej w formie podobnej do adresu e-mail, np. `jan.kowalski@firma.pl`. Możemy użyć tej wartości w regule Dynamic RLS.

**Punktacja:** 1/1

---
## 39. Do czego w naszym modelu służy RLS_UserAccess?

**Odpowiedź wzorcowa:**  
`RLS_UserAccess` jest pomocniczą tabelą uprawnień. Łączy tożsamość użytkownika z zakresem danych, do którego ma dostęp, np. z dozwolonym typem sklepu. Dzięki temu Dynamic RLS może ustalić, jakie dane powinien zobaczyć konkretny użytkownik.

**Punktacja:** 1/1

---
## 40. Dlaczego RLS nie ogranicza Admina Workspace w taki sam sposób jak Viewera?

**Odpowiedź wzorcowa:**  
Role `Admin`, `Member` i `Contributor` mają uprawnienia do tworzenia lub zarządzania zawartością Workspace i nie są typowymi odbiorcami podlegającymi RLS jak Viewer. `Viewer` jest rolą konsumpcyjną i to dla takich użytkowników reguły RLS powinny ograniczać dane. Dlatego RLS należy testować w odpowiednim kontekście roli/użytkownika.

**Punktacja:** 1/1

---

# CZĘŚĆ F - Performance i Refresh
## 41. Do czego służy Performance Analyzer?

**Odpowiedź wzorcowa:**  
Performance Analyzer mierzy czas wykonania poszczególnych wizualizacji na stronie raportu. Pomaga ustalić, czy problem z wydajnością wynika z zapytania DAX, renderowania wizualizacji czy innych operacji. Dzięki temu optymalizujemy na podstawie pomiaru, a nie zgadywania.

**Punktacja:** 1/1

---
## 42. Co oznaczają DAX query, Visual display i Other?

**Odpowiedź wzorcowa:**  
`DAX query` to czas potrzebny na wykonanie zapytania do modelu i obliczenie wartości. `Visual display` to czas renderowania wizualizacji na ekranie. `Other` obejmuje pozostały czas, np. oczekiwanie, przygotowanie lub pracę zależną od innych elementów strony.

**Punktacja:** 1/1

---
## 43. Co to jest kardynalność kolumny?

**Odpowiedź wzorcowa:**  
Kardynalność to liczba różnych, unikalnych wartości w kolumnie. Kolumna `Holiday_Flag` ma bardzo niską kardynalność, bo zawiera tylko 0 i 1, natomiast `Weekly_Sales` ma bardzo wysoką kardynalność, ponieważ prawie każdy rekord może mieć inną wartość.

**Punktacja:** 1/1

---
## 44. Czy kolumna o wysokiej kardynalności zawsze powinna zostać usunięta? Wyjaśnij na przykładzie Weekly_Sales.

**Odpowiedź wzorcowa:**  
Nie. Wysoka kardynalność może zwiększać rozmiar modelu i zużycie pamięci, ale decyzja zależy od wartości biznesowej kolumny. `Weekly_Sales` jest kluczową wartością potrzebną do obliczania sprzedaży, średnich, YoY, YTD czy rankingów, więc nie można jej usunąć tylko dlatego, że ma wiele unikalnych wartości.

**Punktacja:** 0,5/1

---
## 45. Co to jest Incremental Refresh i dlaczego w naszym projekcie był bardziej demonstracją techniczną niż koniecznością?

**Odpowiedź wzorcowa:**  
Incremental Refresh dzieli dane na partycje czasowe i pozwala odświeżać głównie najnowsze okresy zamiast całej historii. Jest szczególnie przydatny przy bardzo dużych tabelach. W projekcie Walmart mieliśmy tylko ok. 6435 rekordów, więc pełne odświeżenie było szybkie; funkcję wdrożyliśmy przede wszystkim jako demonstrację rozwiązania stosowanego w większych systemach.

**Punktacja:** 1/1

---

# CZĘŚĆ G - Zadania praktyczne
## 46. Tabela powinna mieć jeden rekord na Store + Date_Sales, ale znajdujesz dwa. Co sprawdzasz i dlaczego jest to niebezpieczne?

**Odpowiedź wzorcowa:**  
Najpierw grupuję dane po `Store + Date_Sales` i szukam przypadków z `COUNT(*) > 1`. Następnie porównuję wszystkie pola duplikujących się rekordów i ustalam, czy to rzeczywisty duplikat, błąd ładowania czy dwa różne zdarzenia biznesowe. Jeśli to duplikat, agregacje takie jak `SUM(Weekly_Sales)` policzą sprzedaż podwójnie i zawyżą wyniki. Dopiero po ustaleniu przyczyny poprawiam źródło lub proces ETL.

**Punktacja:** 1,5/2

---
## 47. Year = 2012 i Type = B, ale Total Sales się nie zmienia. Jakie trzy rzeczy sprawdzisz?

**Odpowiedź wzorcowa:**  
Po pierwsze sprawdzam `Edit interactions`, czyli czy slicery filtrują kartę KPI. Po drugie analizuję miarę DAX, szczególnie użycie `ALL`, `ALLEXCEPT` lub innych funkcji mogących usuwać filtry. Po trzecie sprawdzam, czy relacje `Dim_Date -> Walmart_Sales_Cleaned` i `Stores_Metadata -> Walmart_Sales_Cleaned` są poprawne i aktywne.

**Punktacja:** 2/2

---
## 48. Strona raportu otwiera się 8 sekund. Jak rozpoczniesz diagnozę?

**Odpowiedź wzorcowa:**  
Najpierw uruchamiam Performance Analyzer i rejestruję odświeżenie wizualizacji. Sortuję wyniki po czasie i identyfikuję najwolniejszy visual. Następnie sprawdzam, czy największy koszt stanowi `DAX Query`, `Visual display` czy `Other`. Dopiero potem analizuję przyczynę: DAX/model, złożoność wizualizacji albo - przy odpowiednim trybie połączenia - źródło SQL, sieć i Query Folding. Po zmianie mierzę ponownie.

**Punktacja:** 1/2

---
## 49. Manager powinien widzieć wyłącznie sklepy typu C. Jakie rozwiązanie zastosujesz?

**Odpowiedź wzorcowa:**  
Jeżeli to pojedynczy, stały przypadek, mogę utworzyć Static RLS z regułą `Stores_Metadata[Type] = "C"` i przypisać użytkownika do roli w Service. Jeżeli wielu managerów ma różne zakresy, lepsze będzie Dynamic RLS oparte na `USERPRINCIPALNAME()` i tabeli `RLS_UserAccess`. Dzięki temu jeden raport obsłuży wszystkich użytkowników.

**Punktacja:** 1,75/2

---
## 50. Tabela faktów ma 500 000 000 rekordów i codziennie rośnie. Czy nadal odświeżałbyś całą historię?

**Odpowiedź wzorcowa:**  
Nie odświeżałbym całej historii przy każdym refreshu, jeśli większość starych danych się nie zmienia. Rozważyłbym Incremental Refresh z polityką przechowywania historii i odświeżania tylko najnowszego okresu. Power BI przechowuje wtedy dane w partycjach i nie musi ponownie przetwarzać całego zbioru przy każdym odświeżeniu.

**Punktacja:** 1,75/2

---

# CZĘŚĆ H - Mini rozmowa rekrutacyjna
## 51. Opowiedz mi o swoim projekcie Walmart.

**Odpowiedź wzorcowa:**  
Projekt Walmart jest kompleksowym projektem BI do analizy historycznej sprzedaży sklepów. Dane przygotowałem w SQL Server i Power Query, następnie zbudowałem model Star Schema oraz miary DAX do analizy sprzedaży, YoY, YTD, rankingów i KPI. Raport został opublikowany w Power BI Service, gdzie skonfigurowałem RLS, Gateway i odświeżanie danych. Celem było stworzenie rozwiązania, które pozwala użytkownikom biznesowym monitorować wyniki sklepów i analizować je według czasu oraz typu sklepu.

**Punktacja:** 1,75/2

---
## 52. Dlaczego zdecydowałeś się na Star Schema?

**Odpowiedź wzorcowa:**  
Wybrałem Star Schema, ponieważ oddziela tabelę faktów od tabel wymiarów i upraszcza model. Dzięki temu relacje są bardziej przewidywalne, łatwiej budować miary DAX i kontrolować filter context. Taki model jest dobrze dopasowany do Power BI i zwykle ułatwia osiągnięcie dobrej wydajności oraz czytelności rozwiązania.

**Punktacja:** 1,5/2

---
## 53. Jak zapewniłeś bezpieczeństwo danych w raporcie?

**Odpowiedź wzorcowa:**  
Bezpieczeństwo zapewniłem przede wszystkim przez Row-Level Security. W wariancie Dynamic RLS tożsamość użytkownika może być sprawdzana przez `USERPRINCIPALNAME()`, a tabela `RLS_UserAccess` określa, jaki zakres danych użytkownik może zobaczyć. W Power BI Service stosowałem również odpowiednie role Workspace, aby odbiorcy mieli rolę Viewer zamiast niepotrzebnych uprawnień administracyjnych. Dostęp Power BI Service do lokalnego SQL Servera realizowany jest przez On-premises Data Gateway.

**Punktacja:** 1,5/2

---
## 54. Jak sprawdzałeś wydajność raportu?

**Odpowiedź wzorcowa:**  
Używałem Performance Analyzer w Power BI Desktop i mierzyłem czas odświeżenia poszczególnych wizualizacji. Analizowałem `DAX Query`, `Visual display` i `Other`, aby znaleźć faktyczne wąskie gardła. Dodatkowo korzystałem z DAX Query View i audytu kardynalności modelu. Najpierw mierzyłem, potem lokalizowałem bottleneck i dopiero wtedy rozważałem optymalizację.

**Punktacja:** 2/2

---
## 55. Jak wygląda droga danych od SQL Servera do użytkownika raportu?

**Odpowiedź wzorcowa:**  
Dane znajdują się w SQL Serverze i są pobierane do Power BI przez Power Query, gdzie wykonywane są transformacje. Następnie trafiają do modelu semantycznego z relacjami Star Schema i miarami DAX, a warstwa prezentacyjna powstaje w Power BI Desktop. Po `Publish` w Power BI Service dostępne są raport i Semantic Model; odświeżanie lokalnego SQL Servera odbywa się przez On-premises Data Gateway. Użytkownik otwiera raport lub Power BI App, a jego zakres danych może być ograniczony przez RLS.

**Punktacja:** 1,75/2

---

# Podsumowanie wyników

| Część | Wynik |
|---|---:|
| A - Model danych i Power Query | 9,00 / 10 |
| B - DAX | 9,50 / 10 |
| C - Raport i UX | 4,75 / 5 |
| D - Power BI Service | 9,50 / 10 |
| E - RLS i bezpieczeństwo | 4,75 / 5 |
| F - Performance i Refresh | 4,50 / 5 |
| G - Zadania praktyczne | 8,00 / 10 |
| H - Mini rozmowa rekrutacyjna | 8,50 / 10 |
| **RAZEM** | **58,50 / 65 = 90%** |

# Najważniejsze tematy do utrwalenia

1. `ALL()` vs `ALLSELECTED()` - szczególnie różnica między całkowitym usunięciem filtra a zachowaniem wyboru użytkownika.
2. Pełniejsza składnia `RANKX()` i obsługa remisów `Skip` / `Dense`.
3. Wysoka kardynalność - nie oznacza automatycznie, że kolumnę należy usunąć.
4. Diagnostyka wydajności - najpierw pomiar w Performance Analyzer, potem lokalizacja bottlenecku i dopiero optymalizacja.
5. Precyzyjna terminologia Power BI Service - odświeżamy dane / Semantic Model, nie samą warstwę wizualną raportu.
6. RLS działa na wierszach modelu semantycznego, a nie fizycznie usuwa dane ze źródłowego SQL Servera.
7. Mobile Layout ma poprawiać czytelność i ergonomię na małym ekranie; pionowe przewijanie jest normalne.
8. Star Schema zwykle upraszcza DAX i model, ale nie gwarantuje automatycznie "bezbłędnego DAX" ani zawsze mniejszego PBIX.

# Krótka odpowiedź rekrutacyjna - projekt Walmart

Projekt Walmart jest end-to-end rozwiązaniem BI do analizy sprzedaży sklepów. Dane zostały przygotowane w SQL Serverze i Power Query, a następnie zbudowałem model Star Schema z tabelą faktów `Walmart_Sales_Cleaned` oraz wymiarami `Stores_Metadata` i `Dim_Date`. W DAX przygotowałem KPI, Time Intelligence, rankingi i analizy udziałów. Raport został opublikowany w Power BI Service, gdzie skonfigurowałem RLS, Gateway, odświeżanie, App, dashboard oraz elementy UX i dostępności. Wydajność sprawdzałem w Performance Analyzer, DAX Query View i przez audyt kardynalności modelu.

# Wniosek końcowy

Największym atutem jest rozumienie pełnego przepływu danych: źródło SQL -> transformacje -> model -> DAX -> raport -> Power BI Service -> Gateway / Refresh -> RLS -> użytkownik końcowy. Wiedza nie ogranicza się do znajomości pojedynczych funkcji; potrafisz wyjaśnić ich zastosowanie w konkretnym scenariuszu biznesowym i wskazać sposób diagnozowania problemów.