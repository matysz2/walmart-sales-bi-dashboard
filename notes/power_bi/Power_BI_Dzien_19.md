# Power BI – Dzień 19 – Workspace, Sharing, App i RLS

## Cel

Poznanie sposobów dystrybucji raportów Power BI
i zarządzania dostępem użytkowników.

## Workspace

Workspace jest przestrzenią do przechowywania
i współpracy nad:

- raportami,
- modelami semantycznymi,
- dashboardami,
- innymi elementami Power BI/Fabric.

## Role Workspace

- Viewer
- Contributor
- Member
- Admin

Viewer jest typową rolą odbiorcy raportu.

## RLS

RLS działa na poziomie modelu semantycznego.

Role definiujemy w Power BI Desktop.

Po publikacji użytkowników przypisujemy
do ról w Power BI Service.

## Dynamic RLS

USERPRINCIPALNAME()
→ RLS_UserAccess
→ AllowedType
→ Stores_Metadata
→ Walmart_Sales_Cleaned

## Workspace vs App

Workspace:
miejsce pracy autorów.

App:
gotowa zawartość dla użytkowników biznesowych.

## Audience

Audience określa odbiorców Power BI App.

## App vs RLS

App:
dostęp do raportu.

RLS:
dostęp do wierszy danych.

## Publish vs Share

Publish:
Desktop → Service

Share:
nadanie użytkownikowi dostępu.

## Build

Build pozwala tworzyć nową zawartość
na podstawie Semantic Model.

Nie nadajemy go zwykłym odbiorcom bez potrzeby.

## Security

Viewer + RLS
= typowy bezpieczny odbiorca raportu.

Admin / Member / Contributor
= role przeznaczone do pracy nad zawartością.

## Najważniejsze

Workspace
→ Report + Semantic Model
→ RLS
→ App
→ Viewer
→ User