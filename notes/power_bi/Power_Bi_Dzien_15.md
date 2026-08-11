# Power BI – Dzień 15 – Row-Level Security (RLS)

## Cel

Poznanie zabezpieczeń na poziomie wierszy
oraz utworzenie statycznych ról RLS w projekcie Walmart.

## RLS

Row-Level Security ogranicza wiersze danych,
które użytkownik może zobaczyć.

RLS nie jest zwykłym filtrem raportu.

## RLS vs slicer

Slicer:
użytkownik wybiera dane do analizy.

RLS:
system określa dane, do których użytkownik ma dostęp.

## Model

Stores_Metadata
      1
      |
      *
Walmart_Sales_Cleaned

RLS nakładamy na tabelę wymiaru:

Stores_Metadata

## Role

Role_Type_A

[Type] = "A"

Role_Type_B

[Type] = "B"

Role_Type_C

[Type] = "C"

## Propagacja filtra

RLS
→ Stores_Metadata
→ Store
→ relacja 1:*
→ Walmart_Sales_Cleaned
→ miary DAX

## Miary

Nie tworzymy osobnych miar dla ról.

Ta sama:

Total Sales =
SUM(Walmart_Sales_Cleaned[Weekly_Sales])

jest liczona tylko na danych dostępnych
dla aktualnej roli.

## Testowanie

Modelowanie
→ Wyświetl jako / View as
→ wybierz rolę

Role_Type_A powinna pokazywać wyłącznie Type A.

## Static RLS

Reguła zawiera stałą wartość:

[Type] = "A"

Dlatego jest to statyczne RLS.

## Dynamic RLS

Dynamiczne RLS może korzystać z tożsamości
zalogowanego użytkownika, np. USERPRINCIPALNAME().

To będzie kolejny etap.

## Najważniejsze

RLS = bezpieczeństwo danych.

Slicer = analiza danych.

Relacje modelu są kluczowe,
ponieważ filtr RLS propaguje się przez model.