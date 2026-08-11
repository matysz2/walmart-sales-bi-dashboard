
---

## `day_14_sync_slicers_interactions`

```markdown
# Power BI – Dzień 14 – Sync Slicers i Edit Interactions

## Cel

Celem dnia było poznanie dwóch mechanizmów sterujących zachowaniem raportu:

1. synchronizacja slicerów pomiędzy stronami,
2. kontrolowanie interakcji pomiędzy wizualizacjami.

---

## Czego się nauczyłem

- jak synchronizować slicer `Year`,
- czym różni się `Synchronizuj` od `Widoczne`,
- jak ukryty slicer może nadal filtrować stronę,
- jak działa `Edit interactions`,
- czym różnią się Filter, Highlight i None,
- jak wyłączyć wpływ slicera na konkretną wizualizację,
- czym Sync slicers różni się od Edit interactions.

---

# Sync Slicers

## Pole

W projekcie Walmart synchronizuję:

```text
Dim_Date[Year]