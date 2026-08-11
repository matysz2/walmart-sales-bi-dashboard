# Dzień 13 - SELF JOIN w SQL Server

## Cel dnia

Nauczyć się porównywać rekordy znajdujące się w tej samej tabeli oraz tworzyć unikalne pary sklepów.

## Najważniejsza definicja

`SELF JOIN` nie jest osobnym słowem kluczowym. Jest to zwykły `JOIN`, w którym ta sama tabela występuje dwa razy pod różnymi aliasami.

## Składnia

```sql
SELECT
    kolumny
FROM tabela AS a
INNER JOIN tabela AS b
    ON warunek_laczenia;
```

## Aliasy

W projekcie Walmart używamy:

- `s1` - pierwszy sklep,
- `s2` - drugi sklep.

## Usuwanie duplikatów porównań

```sql
s1.Store <> s2.Store
```

Usuwa porównanie rekordu z nim samym, ale pozostawia pary lustrzane.

```sql
s1.Store < s2.Store
```

Usuwa porównanie rekordu z nim samym oraz pozostawia tylko jedną wersję każdej pary.

## Przykład

```sql
SELECT
    s1.Type AS Typ_Sklepu,
    s1.Store AS Sklep_1,
    s2.Store AS Sklep_2,
    ABS(s1.Size - s2.Size) AS Roznica_Powierzchni
FROM dbo.Stores_Metadata AS s1
INNER JOIN dbo.Stores_Metadata AS s2
    ON s1.Type = s2.Type
   AND s1.Store < s2.Store
ORDER BY Roznica_Powierzchni;
```

## Kontrola wyniku

- 382 unikalne pary,
- typ A: 231 par,
- typ B: 136 par,
- typ C: 15 par.

## ON i WHERE

- `ON` określa, które dwa rekordy mogą utworzyć parę,
- `WHERE` filtruje pary po wykonaniu połączenia.

## Co zapamiętać

- SELF JOIN łączy tabelę z nią samą.
- Każda rola tabeli musi mieć inny alias.
- `<>` usuwa tylko ten sam rekord.
- `<` usuwa także pary lustrzane.
- `ABS` oblicza dodatnią różnicę wartości.

## Zadanie praktyczne

Przygotuj raport unikalnych par sklepów tego samego typu, oblicz różnicę powierzchni i sklasyfikuj ją jako:

- `Podobna powierzchnia` - do 20000,
- `Umiarkowana roznica` - do 60000,
- `Duza roznica` - powyżej 60000.


1.SELF JOIN to połączenie tabeli z nią samą.
2.Nie jest osobnym słowem kluczowym SQL. Wykorzystuje standardowy JOIN.
3.Aliasy pozwalają rozróżnić dwie role tej samej tabeli.
4.s1.Store = s2.Store łączy każdy sklep wyłącznie z nim samym.
5.s1.Store <> s2.Store usuwa porównanie rekordu z nim samym.
6.Pary lustrzane pozostają, ponieważ zarówno 1 <> 2, jak i 2 <> 1 są prawdziwe.
7.s1.Store < s2.Store usuwa porównania własne i pary lustrzane.
8.ON określa sposób tworzenia par, a WHERE filtruje utworzony wynik.
9.ABS zwraca dodatnią, bezwzględną różnicę wartości.
10.SELF JOIN pozwala porównywać sklepy tego samego typu, ich powierzchnię oraz – po dołączeniu danych sprzedażowych – wyniki biznesowe.