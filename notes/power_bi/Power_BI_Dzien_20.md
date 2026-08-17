# Power BI — Dzień 20
## Dashboard, Tiles, Data Alerts i Subscriptions

## Cel dnia
Poznanie Dashboardów w Power BI Service oraz praktyczne wykonanie pulpitu managerskiego dla projektu Walmart.

Po zakończeniu dnia potrafię:
- utworzyć Dashboard w Power BI Service,
- przypinać wizualizacje z raportu jako kafelki,
- wyjaśnić różnicę między Report a Dashboard,
- rozumieć pojęcie Tile,
- ustawić Data Alert dla kafelka typu Card,
- skonfigurować subskrypcję Dashboardu,
- uporządkować Dashboard pod odbiorcę biznesowego.

---

## 1. Dashboard

Dashboard to jednostronicowy pulpit tworzony w Power BI Service.

Służy do szybkiego monitorowania najważniejszych KPI i wyników biznesowych.

W projekcie Walmart utworzono:

`Walmart Executive Dashboard`

Najważniejsze elementy:
- Total Sales,
- Stores Count,
- Sales YoY %,
- Top Stores,
- tabela podsumowująca sprzedaż.

---

## 2. Report a Dashboard

### Report
- może mieć wiele stron,
- zawiera slicery, filtry i interakcje,
- służy do szczegółowej analizy,
- może być tworzony w Power BI Desktop.

### Dashboard
- ma jedną stronę,
- tworzony jest w Power BI Service,
- składa się z kafelków,
- służy głównie do monitorowania KPI,
- może zawierać elementy z różnych raportów i modeli semantycznych.

---

## 3. Tile

`Tile` to kafelek znajdujący się na Dashboardzie.

Przykładowe kafelki:
- `Total Sales`,
- `Stores Count`,
- `Sales YoY %`,
- `Top 5 Stores`.

Kafelki można:
- przesuwać,
- zmieniać ich rozmiar,
- edytować ich właściwości,
- usuwać,
- dla wybranych typów ustawiać alerty.

---

## 4. Pin visual

`Pin visual` oznacza przypięcie pojedynczej wizualizacji z raportu do Dashboardu.

```text
Semantic Model
    ↓
Report
    ↓
Visualization
    ↓
Pin
    ↓
Dashboard
    ↓
Tile
```

---

## 5. Data Alert

Data Alert służy do powiadamiania użytkownika po spełnieniu określonego warunku.

Przykład użyty w projekcie Walmart:

```text
Jeżeli Total Sales < 6 000 000 000
→ wyślij alert
```

Alert został skonfigurowany dla kafelka `Total Sales`.

Typowe kafelki obsługujące klasyczne alerty:
- Card,
- KPI,
- Gauge.

Alert reaguje na wartość danych po ich odświeżeniu.

---

## 6. Subscription

Subscription to subskrypcja raportu lub Dashboardu.

Przykład:

```text
Walmart Executive Dashboard
→ codziennie
→ określona godzina
→ e-mail
```

### Alert a Subscription

**Alert**
- działa warunkowo,
- reaguje na przekroczenie ustawionego progu.

**Subscription**
- działa według harmonogramu,
- wysyła Dashboard lub raport e-mailem.

---

## 7. Finalny układ Dashboardu Walmart

Najważniejsze KPI umieszczono na górze:

```text
[ Total Sales ]    [ Stores Count ]
```

Niżej:
- tabela podsumowująca sprzedaż,
- Sales YoY %,
- ranking sklepów według Total Sales.

Dashboard został uporządkowany tak, aby najważniejsze KPI były widoczne jako pierwsze.

---

## 8. Typowe błędy

- Mylenie Report z Dashboardem.
- Próba tworzenia Dashboardu w Power BI Desktop.
- Traktowanie pojedynczego kafelka jak pełnej interaktywnej strony raportu.
- Ustawianie alertu na typie wizualizacji, który go nie obsługuje.
- Mylenie Alert z Subscription.
- Zbyt duża liczba szczegółowych wizualizacji na Dashboardzie.

---

## 9. Co zapamiętać

- `Report` = szczegółowa analiza.
- `Dashboard` = monitoring KPI.
- `Tile` = kafelek Dashboardu.
- `Pin visual` = przypięcie wizualizacji do Dashboardu.
- `Data Alert` = powiadomienie po spełnieniu warunku.
- `Subscription` = cykliczna wysyłka Dashboardu lub raportu.
- Dashboard nie zastępuje RLS.

---

## 10. Pytania kontrolne

1. Co to jest Power BI Dashboard?
2. Gdzie tworzymy Dashboard?
3. Czy Dashboard można utworzyć w Power BI Desktop?
4. Co to jest Tile?
5. Jaka jest różnica między Report i Dashboard?
6. Ile stron ma Dashboard?
7. Czy Dashboard może korzystać z kilku raportów?
8. Czy jeden Dashboard może prezentować dane z kilku modeli semantycznych?
9. Co dzieje się po kliknięciu typowego kafelka?
10. Co oznacza Pin visual?
11. Jaka jest różnica między przypięciem pojedynczego visuala i całej strony?
12. Czy zwykły kafelek zachowuje wszystkie slicery raportu?
13. Do czego służy Data Alert?
14. Dla jakich kafelków możemy ustawiać klasyczne alerty?
15. Dlaczego Refresh jest ważny dla alertów?
16. Co to jest Subscription?
17. Jaka jest różnica między Alert i Subscription?
18. Jaka jest różnica między Dashboard i App?
19. Czy Dashboard zastępuje RLS?
20. Do czego manager może użyć Dashboardu Walmart?

---

## 11. Przykład biznesowy

Manager Walmart może na jednej stronie szybko sprawdzić:
- łączną sprzedaż,
- liczbę sklepów,
- zmianę sprzedaży rok do roku,
- najlepsze sklepy.

Jeżeli potrzebuje szczegółów, przechodzi z Dashboardu do źródłowego raportu.

---

## 12. Architektura projektu

```text
SQL Server
    ↓
Gateway
    ↓
Semantic Model
    ↓
Power BI Report
    ↓
Dashboard
    ↓
Alert / Subscription
    ↓
Power BI App
    ↓
Użytkownik
```
