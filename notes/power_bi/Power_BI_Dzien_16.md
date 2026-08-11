# Power BI – Dzień 16 – Dynamic RLS

## Cel

Poznanie dynamicznego Row-Level Security opartego
na tożsamości zalogowanego użytkownika.

## Static RLS

Role_Type_A
→ [Type] = "A"

Role_Type_B
→ [Type] = "B"

Role_Type_C
→ [Type] = "C"

## Dynamic RLS

Jedna rola:

Dynamic_RLS

Zakres danych zależy od użytkownika.

## USERPRINCIPALNAME

USERPRINCIPALNAME()

zwraca UPN aktualnego użytkownika.

## Tabela uprawnień

RLS_UserAccess

UserEmail | Type

manager.a@contoso.com | A
manager.b@contoso.com | B
manager.c@contoso.com | C

## Reguła

VAR CurrentUser =
    USERPRINCIPALNAME()

VAR AllowedType =
    LOOKUPVALUE(
        RLS_UserAccess[Type],
        RLS_UserAccess[UserEmail], CurrentUser
    )

RETURN
    Stores_Metadata[Type] = AllowedType

## Mechanizm

User
→ USERPRINCIPALNAME()
→ RLS_UserAccess
→ Type
→ Stores_Metadata
→ relacja Store
→ Walmart_Sales_Cleaned
→ miary DAX

## Bezpieczeństwo

Nieznany użytkownik
→ brak dopasowania
→ brak danych

Nie należy stosować domyślnego TRUE(),
które mogłoby przyznać pełny dostęp.

## Najważniejsze

Static RLS:
wartość jest zapisana w roli.

Dynamic RLS:
zakres wynika z tożsamości użytkownika.

Dynamic RLS:
1 rola + tabela uprawnień