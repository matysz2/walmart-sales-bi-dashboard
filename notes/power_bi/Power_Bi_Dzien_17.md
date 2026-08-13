# Power BI – Dzień 17 – Publikacja do Power BI Service

## Cel

Publikacja raportu z Power BI Desktop do Power BI Service
oraz zrozumienie Workspace, Report, Semantic Model i RLS po publikacji.

## Desktop

Power BI Desktop służy do:

- Power Query
- modelowania
- DAX
- tworzenia raportu
- RLS

## Power BI Service

Power BI Service służy między innymi do:

- publikowania raportów
- współpracy
- udostępniania
- bezpieczeństwa
- odświeżania danych

## Publikacja

Power BI Desktop
→ Publikuj
→ Workspace

## Po publikacji

PBIX
↓
Power BI Service
↓
Report
+
Semantic Model

## Report

Warstwa prezentacji:

- strony
- wykresy
- KPI
- slicery
- Drill-through
- Tooltip
- Bookmarks

## Semantic Model

Warstwa danych:

- tabele
- relacje
- miary DAX
- model
- RLS

## Workspace

Obszar organizowania i współdzielenia zawartości.

Role:

- Viewer
- Contributor
- Member
- Admin

## RLS

Role tworzymy w Power BI Desktop.

Po publikacji użytkowników przypisujemy
do ról na semantic model.

RLS stosujemy do odbiorców typu Viewer.

Admin, Member i Contributor mają uprawnienia edycyjne
i RLS nie ogranicza ich tak jak Viewer.

## Publish vs Share

Publish:
Desktop → Service

Share:
nadanie dostępu użytkownikowi

## Lokalny SQL Server

Publikacja nie oznacza automatycznej aktualizacji danych.

Dla lokalnego SQL Servera potrzebujemy później:

Gateway
+
Credentials
+
Scheduled Refresh

## Najważniejsze

Desktop
→ Publish
→ Service
→ Workspace
→ Report + Semantic Model
→ RLS
→ User