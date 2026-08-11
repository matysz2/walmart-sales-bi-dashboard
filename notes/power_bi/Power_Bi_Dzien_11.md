# Power BI – Dzień 11 – Drill-through

## Cel

Celem dnia było poznanie mechanizmu Drill-through i utworzenie strony
szczegółowej dla pojedynczego sklepu.

W projekcie Walmart utworzyłem stronę:

`06_Store_Details`

która automatycznie pokazuje dane sklepu wybranego na innej stronie raportu.

---

## Czego się nauczyłem

- czym jest Drill-through,
- jak utworzyć stronę szczegółową,
- jak przekazywany jest filter context pomiędzy stronami,
- jak używać `Stores_Metadata[Store]` jako pola Drill-through,
- jak istniejące miary DAX reagują na przekazany filtr,
- jak działa `Keep all filters`,
- czym różni się Drill-through od Drill-down,
- jak dodać przycisk Powrót.

---

## Model danych

W projekcie korzystam z modelu:

```text
Stores_Metadata
      1
      |
      |
      *
Walmart_Sales_Cleaned