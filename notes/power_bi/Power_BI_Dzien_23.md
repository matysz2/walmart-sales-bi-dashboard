# Power BI — Dzień 23
## UX raportu, Mobile Layout i Accessibility

**Projekt:** Walmart Sales Analytics  
**Narzędzie:** Power BI Desktop  
**Strona ćwiczeniowa:** `01_Overview`

---

## Cel dnia

Po tej lekcji potrafię:

- zaprojektować czytelną hierarchię informacji w raporcie,
- przygotować osobny **Mobile Layout** dla telefonu,
- zdecydować, które wizualizacje powinny trafić do wersji mobilnej,
- dodać **Alt Text** do ważnych elementów raportu,
- ustawić logiczny **Tab Order**,
- rozpoznać elementy dekoracyjne, które nie powinny przeszkadzać w nawigacji,
- wyjaśnić, dlaczego raport nie powinien przekazywać znaczenia wyłącznie kolorem,
- opisać podstawy UX i accessibility na rozmowie rekrutacyjnej.

---

# 1. UX w Power BI

**UX (User Experience)** oznacza doświadczenie użytkownika podczas korzystania z raportu.

Raport może być technicznie poprawny, a mimo to niewygodny, jeśli użytkownik:

- nie wie, gdzie patrzeć,
- nie wie, co kliknąć,
- ma zbyt wiele wizualizacji na jednej stronie,
- musi przewijać duże tabele,
- nie rozumie tytułów i KPI.

Dobry raport powinien prowadzić użytkownika od informacji najważniejszych do szczegółów.

Przykładowa hierarchia strony:

```text
KPI
↓
filtry
↓
trend / porównanie
↓
ranking / podział
↓
tabela szczegółowa
```

---

# 2. Hierarchia informacji w projekcie Walmart

Na stronie `01_Overview` użytkownik powinien najpierw zobaczyć najważniejsze KPI:

```text
Total Sales
Average Weekly Sales
Maximum Weekly Sales
Stores Count
```

następnie filtry:

```text
Year
Type
```

a dalej:

```text
Sales YoY % wg Year
Total Sales by Store Type
Tabela podsumowująca
```

Dzięki temu użytkownik szybko rozumie ogólny wynik, a dopiero później przechodzi do analizy szczegółowej.

---

# 3. Mobile Layout

**Mobile Layout** to alternatywny układ tej samej strony raportu przeznaczony dla telefonu.

Nie tworzy:

- nowego modelu,
- nowych miar,
- nowej bazy danych,
- osobnego raportu.

Zmienia jedynie rozmieszczenie wizualizacji dla małego ekranu.

Przykład:

```text
Desktop:
KPI | KPI | KPI | KPI
Wykres | Tabela | Slicery

Mobile:
Total Sales
Average Weekly Sales
Maximum Weekly Sales
Stores Count
Year
Type
Wykres
```

---

# 4. Co umieszczać w Mobile Layout

Na telefonie nie trzeba pokazywać wszystkich elementów dostępnych na desktopie.

Najważniejsza zasada:

> Mobile Layout powinien pokazywać przede wszystkim informacje potrzebne użytkownikowi do szybkiej decyzji.

W projekcie Walmart na wersji mobilnej umieszczono między innymi:

- `Total Sales`,
- `Average Weekly Sales`,
- `Maximum Weekly Sales`,
- `Stores Count`,
- `Year`.

Duże tabele lub elementy techniczne mogą zostać pominięte albo umieszczone niżej.

---

# 5. Czytelność KPI na telefonie

W pierwszej wersji układu mobilnego część wartości była ucięta.

Przykład problemu:

```text
472,...
725,...
```

Poprawny układ powinien pozwalać odczytać całą wartość:

```text
472,61 tys.
725,04 tys.
```

Wniosek:

> KPI na telefonie musi być czytelny bez dodatkowego klikania i domyślania się wartości.

---

# 6. Alt Text

**Alt Text (tekst alternatywny)** opisuje znaczenie elementu raportu.

Przykład dla `Total Sales`:

```text
Karta pokazująca całkowitą sprzedaż
dla aktualnie wybranych filtrów raportu.
```

Dla `Year`:

```text
Filtr umożliwiający wybór roku analizy.
```

Dla `Type`:

```text
Filtr umożliwiający wybór typu sklepu.
```

Alt Text powinien opisywać **funkcję i znaczenie** elementu, a nie przepisywać aktualną wartość.

Źle:

```text
Total Sales wynosi 6,74 mld.
```

Dlaczego źle?

Po zmianie filtra wartość może się zmienić, a statyczny opis pozostanie nieaktualny.

---

# 7. Przykładowe Alt Text dla projektu

```text
Total Sales
Karta pokazująca całkowitą sprzedaż dla aktualnie wybranych filtrów raportu.

Average Weekly Sales
Karta pokazująca średnią tygodniową sprzedaż dla aktualnych filtrów.

Maximum Weekly Sales
Karta pokazująca najwyższą tygodniową sprzedaż dla aktualnych filtrów.

Stores Count
Karta pokazująca liczbę sklepów uwzględnionych w analizie.

Year
Filtr umożliwiający wybór roku analizy.

Type
Filtr umożliwiający wybór typu sklepu.

Sales YoY % wg Year
Wykres przedstawiający procentową zmianę sprzedaży rok do roku.

Total Sales by Store Type
Wykres przedstawiający całkowitą sprzedaż według typu sklepu.
```

---

# 8. Tab Order

**Tab Order** określa kolejność, w której użytkownik przechodzi między elementami raportu przy użyciu klawiatury.

Dobra kolejność powinna odpowiadać naturalnej pracy z raportem:

```text
filtry
↓
KPI
↓
wykresy
↓
tabele
↓
nawigacja
```

W projekcie ustawiono kolejność rozpoczynającą się od:

```text
1. Year
2. Type
3. Total Sales
4. Average Weekly Sales
5. Maximum Weekly Sales
...
```

---

# 9. Dlaczego slicery są na początku Tab Order

Użytkownik często najpierw wybiera zakres analizy:

```text
Year
Type
```

dopiero potem analizuje KPI.

Logiczny scenariusz:

```text
wybieram rok
↓
wybieram typ sklepu
↓
sprawdzam Total Sales
↓
sprawdzam pozostałe KPI
↓
analizuję wykres
↓
wchodzę w szczegóły
```

---

# 10. Elementy dekoracyjne a Tab Order

Nie każdy obiekt powinien znajdować się w kolejności tabulacji.

Przykładowe elementy dekoracyjne:

```text
tło
linia
prostokąt
ozdobny napis
nieklikalny kształt
```

Jeżeli element niczego nie robi i nie przekazuje istotnej informacji, nie powinien utrudniać użytkownikowi nawigacji klawiaturą.

Jeżeli jednak `YOY`, `SPRZEDAŻ`, `View_Sales` lub `View_YoY` są klikalnymi przyciskami, powinny pozostać dostępne w Tab Order.

---

# 11. Nazwy elementów w panelu Selection

Domyślne nazwy typu:

```text
Karta
Karta
Karta
```

są trudne do zarządzania w większym raporcie.

Lepsze nazwy:

```text
Card_TotalSales
Card_AvgWeeklySales
Card_MaxWeeklySales
Card_RecordsCount
Card_StoresCount

Slicer_Year
Slicer_Type

Chart_SalesYoY
Chart_TotalSalesByType
Table_SalesSummary
```

To nie zmienia raportu dla odbiorcy, ale ułatwia pracę autorowi raportu.

---

# 12. Kolor i dostępność

Nie należy przekazywać znaczenia wyłącznie kolorem.

Słabszy przykład:

```text
zielony = dobrze
czerwony = źle
```

Lepszy:

```text
+5,2% ↑
-3,1% ↓
```

i dopiero dodatkowo kolor.

Wtedy użytkownik rozumie wynik nawet wtedy, gdy nie rozróżnia wszystkich barw.

---

# 13. Czytelne tytuły

Tytuł powinien mówić użytkownikowi, co przedstawia wizualizacja.

Dobrze:

```text
Sales YoY % by Year
Top Stores by Total Sales
Total Sales by Store Type
```

Słabiej:

```text
Chart 1
Viz 2
KPI #3
```

Nazwy techniczne mogą być używane w panelu Selection, ale tytuły widoczne w raporcie powinny być biznesowe.

---

# 14. Poziom Junior BI Analyst

Na poziomie Junior BI Analyst warto znać przede wszystkim:

```text
Mobile Layout
Alt Text
Tab Order
czytelne tytuły
hierarchię informacji
kontrast
zasadę: nie tylko kolor
```

Nie trzeba na tym etapie znać całego WCAG ani zaawansowanych testów czytnikami ekranu.

---

# 15. Zadanie praktyczne wykonane

W projekcie Walmart wykonano:

- przygotowanie Mobile Layout dla `01_Overview`,
- poprawienie czytelności KPI,
- ustawienie tekstów alternatywnych,
- otwarcie panelu `Wybór`,
- przełączenie na `Kolejność tabulacji`,
- ustawienie logicznej kolejności Tab Order,
- ocenę elementów interaktywnych i dekoracyjnych,
- audyt hierarchii informacji na stronie.

---

# 16. Typowe błędy

## Błąd 1
Przeniesienie całej strony desktopowej 1:1 na telefon.

**Poprawa:** wybieramy tylko najważniejsze elementy.

## Błąd 2
Ucięte wartości KPI.

**Poprawa:** zwiększamy rozmiar wizualizacji lub zmniejszamy rozmiar tekstu.

## Błąd 3
Alt Text zawiera konkretną wartość.

**Poprawa:** opisujemy funkcję wizualizacji.

## Błąd 4
Chaotyczny Tab Order.

**Poprawa:** filtry → KPI → wykresy → tabela → nawigacja.

## Błąd 5
Dekoracje znajdują się w Tab Order.

**Poprawa:** usuwamy je z kolejności, jeśli nie są interaktywne.

## Błąd 6
Znaczenie przekazywane tylko kolorem.

**Poprawa:** kolor + tekst/liczba/symbol.

## Błąd 7
Nieczytelne nazwy typu `Karta`, `Karta`, `Karta`.

**Poprawa:** nadawanie logicznych nazw technicznych.

---

# 17. Co zapamiętać

```text
Dobry raport BI
=
poprawne dane
+
poprawny model
+
poprawny DAX
+
czytelny UX
+
dostępność
```

Mobile Layout odpowiada za wygodę na telefonie.

Alt Text pomaga opisać znaczenie elementu.

Tab Order odpowiada za logiczną nawigację klawiaturą.

---

# 18. Test wiedzy — 20 pytań i odpowiedzi

## 1. Co oznacza UX w Power BI?

UX oznacza User Experience, czyli doświadczenie użytkownika podczas korzystania z raportu. Obejmuje między innymi czytelność, kolejność informacji, nawigację i łatwość interpretacji wyników.

## 2. Dlaczego raport technicznie poprawny może mieć słaby UX?

Ponieważ poprawne dane i DAX nie gwarantują, że użytkownik szybko znajdzie najważniejsze informacje albo będzie wiedział, co kliknąć.

## 3. Co to jest hierarchia informacji?

To zaplanowana kolejność prezentowania informacji od najważniejszych do najbardziej szczegółowych, np. KPI → filtry → wykresy → tabela.

## 4. Co to jest Mobile Layout?

To osobny układ wizualizacji tej samej strony raportu zoptymalizowany dla urządzeń mobilnych.

## 5. Czy Mobile Layout tworzy nowy raport?

Nie. Korzysta z tego samego modelu, danych, miar i wizualizacji. Zmienia tylko ich rozmieszczenie.

## 6. Czy wszystkie wizualizacje desktopowe powinny być na telefonie?

Nie. Na telefon wybieramy najważniejsze informacje biznesowe, aby raport pozostał czytelny.

## 7. Dlaczego duża tabela często jest słaba na telefonie?

Ponieważ mały ekran utrudnia czytanie wielu kolumn i wymaga nadmiernego przewijania.

## 8. Co to jest Alt Text?

To tekst alternatywny opisujący funkcję lub znaczenie wizualizacji.

## 9. Dlaczego nie należy wpisywać do Alt Text konkretnej wartości KPI?

Ponieważ wartość może zmienić się po zastosowaniu filtrów, a statyczny tekst pozostałby nieaktualny.

## 10. Jak może wyglądać dobry Alt Text dla Total Sales?

„Karta pokazująca całkowitą sprzedaż dla aktualnie wybranych filtrów raportu.”

## 11. Co to jest Tab Order?

To kolejność, w której użytkownik przechodzi między elementami raportu przy użyciu klawisza Tab.

## 12. Dlaczego Year i Type warto umieścić wysoko w Tab Order?

Ponieważ są filtrami i użytkownik może najpierw wybrać zakres analizy, a następnie sprawdzać KPI i wykresy.

## 13. Czy element dekoracyjny powinien być w Tab Order?

Zazwyczaj nie, jeśli nie jest interaktywny i nie przekazuje istotnej informacji.

## 14. Czy przyciski i nawigator zakładek powinny pozostać w Tab Order?

Tak, jeśli użytkownik musi móc ich użyć za pomocą klawiatury.

## 15. Dlaczego warto zmieniać nazwy `Karta` na np. `Card_TotalSales`?

Ułatwia to zarządzanie dużą liczbą wizualizacji w panelu Selection i zmniejsza ryzyko edycji niewłaściwego elementu.

## 16. Dlaczego kolor nie powinien być jedynym sposobem przekazywania znaczenia?

Ponieważ nie każdy użytkownik rozróżnia kolory w ten sam sposób. Warto używać także tekstu, liczb, ikon lub strzałek.

## 17. Co jest ważniejsze w wersji mobilnej: liczba wizualizacji czy czytelność?

Czytelność. Mobile Layout powinien być prostszy i skupiać się na najważniejszych informacjach.

## 18. Jak sprawdzić, czy Mobile Layout jest dobrze zaprojektowany?

Należy sprawdzić, czy KPI są czytelne, filtry łatwe do użycia, tekst nie jest ucięty, a użytkownik może przejść od wyniku ogólnego do szczegółów.

## 19. Jakie elementy accessibility powinien znać Junior BI Analyst?

Przede wszystkim Alt Text, Tab Order, czytelne tytuły, logiczną hierarchię informacji, podstawy kontrastu i zasadę nieprzekazywania znaczenia wyłącznie kolorem.

## 20. Jak odpowiedzieć rekruterowi na pytanie o UX i dostępność raportów?

> Przy projektowaniu raportów zwracam uwagę nie tylko na model danych i DAX, ale także na doświadczenie użytkownika. Przygotowuję Mobile Layout, dodaję Alt Text do istotnych elementów, ustawiam logiczny Tab Order, stosuję czytelne tytuły i dbam o to, aby znaczenie nie zależało wyłącznie od koloru.

---

# 19. Zadanie rekrutacyjne

### Pytanie

Jak poprawiłbyś raport, który ma 25 wizualizacji na jednej stronie?

### Przykładowa odpowiedź

Najpierw określiłbym, które KPI i wizualizacje są rzeczywiście potrzebne do podjęcia decyzji biznesowej. Następnie pogrupowałbym informacje według hierarchii, ograniczył liczbę wizualizacji na stronie i przeniósł szczegóły na osobne strony lub drill-through. Sprawdziłbym również Mobile Layout, tytuły, Tab Order i dostępność.

---

# 20. Zadanie domowe

1. Przejrzeć wszystkie główne strony raportu.
2. Sprawdzić, czy tytuły są jednoznaczne.
3. Zidentyfikować elementy dekoracyjne.
4. Sprawdzić, czy nawigacja jest logiczna.
5. Zapisać trzy najważniejsze zasady UX z pamięci.

### Trzy zasady do zapamiętania

```text
1. Najważniejsza informacja ma być widoczna jako pierwsza.
2. Mobile Layout ma być prostszy od desktopu.
3. Raport powinien być zrozumiały bez polegania wyłącznie na kolorze.
```

---

# 21. Screenshoty do dokumentacji GitHub

Sugerowane nazwy:

```text
docs/screenshots/day23-mobile-layout.png
docs/screenshots/day23-tab-order.png
docs/screenshots/day23-overview-accessibility.png
```

W README:

```markdown
![Mobile Layout](docs/screenshots/day23-mobile-layout.png)

![Tab Order](docs/screenshots/day23-tab-order.png)
```

---

# 22. Podsumowanie Dnia 23

Dzień 23 pokazał, że praca BI Analysta nie kończy się na danych i DAX.

Profesjonalny raport powinien być:

- poprawny technicznie,
- czytelny biznesowo,
- wygodny na różnych urządzeniach,
- logiczny w nawigacji,
- możliwie dostępny dla różnych użytkowników.

**Status:** Dzień 23 zakończony.
