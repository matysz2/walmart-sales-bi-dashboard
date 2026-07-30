USE TreningData;
GO

/*
DZIEN 13 - SELF JOIN
Projekt: Walmart Sales
Temat: porownywanie rekordow w tej samej tabeli
*/

-- 1. Wszystkie rozne sklepy tego samego typu
-- Uwaga: wynik zawiera pary lustrzane, np. (1, 2) i (2, 1).
SELECT
    s1.Type AS Typ_Sklepu,
    s1.Store AS Sklep_1,
    s2.Store AS Sklep_2
FROM dbo.Stores_Metadata AS s1
INNER JOIN dbo.Stores_Metadata AS s2
    ON s1.Type = s2.Type
   AND s1.Store <> s2.Store
ORDER BY
    s1.Type,
    s1.Store,
    s2.Store;
GO

-- 2. Unikalne pary sklepow tego samego typu
SELECT
    s1.Type AS Typ_Sklepu,
    s1.Store AS Sklep_1,
    s2.Store AS Sklep_2
FROM dbo.Stores_Metadata AS s1
INNER JOIN dbo.Stores_Metadata AS s2
    ON s1.Type = s2.Type
   AND s1.Store < s2.Store
ORDER BY
    s1.Type,
    s1.Store,
    s2.Store;
GO

-- Kontrola: 382 wiersze.
-- Typ A: 231, typ B: 136, typ C: 15.

-- 3. Porownanie powierzchni
SELECT
    s1.Type AS Typ_Sklepu,
    s1.Store AS Sklep_1,
    s1.Size AS Powierzchnia_1,
    s2.Store AS Sklep_2,
    s2.Size AS Powierzchnia_2,
    ABS(s1.Size - s2.Size) AS Roznica_Powierzchni
FROM dbo.Stores_Metadata AS s1
INNER JOIN dbo.Stores_Metadata AS s2
    ON s1.Type = s2.Type
   AND s1.Store < s2.Store
ORDER BY
    Roznica_Powierzchni,
    s1.Type;
GO

-- 4. Porownanie sklepu 1 z pozostalymi sklepami typu A
SELECT
    s1.Store AS Sklep_Bazowy,
    s1.Type AS Typ_Sklepu,
    s1.Size AS Powierzchnia_Bazowa,
    s2.Store AS Sklep_Porownywany,
    s2.Size AS Powierzchnia_Porownywana,
    ABS(s1.Size - s2.Size) AS Roznica_Powierzchni
FROM dbo.Stores_Metadata AS s1
INNER JOIN dbo.Stores_Metadata AS s2
    ON s1.Type = s2.Type
   AND s1.Store <> s2.Store
WHERE s1.Store = 1
ORDER BY Roznica_Powierzchni;
GO

/*
ZADANIE PRAKTYCZNE

Przygotuj raport unikalnych par sklepow tego samego typu.

Wynik:
- s1.Type AS Typ_Sklepu
- s1.Store AS Sklep_1
- s1.Size AS Powierzchnia_1
- s2.Store AS Sklep_2
- s2.Size AS Powierzchnia_2
- ABS(s1.Size - s2.Size) AS Roznica_Powierzchni
- CASE ... END AS Kategoria_Roznicy

Klasyfikacja:
- roznica <= 20000 -> Podobna powierzchnia
- roznica <= 60000 -> Umiarkowana roznica
- pozostale -> Duza roznica

Warunki:
- SELF JOIN tabeli dbo.Stores_Metadata
- ten sam Type
- s1.Store < s2.Store
- ORDER BY Type i Roznica_Powierzchni rosnaco

Kontrola:
- 382 wiersze
- 179 Podobna powierzchnia
- 127 Umiarkowana roznica
- 76 Duza roznica
*/
-- Napisz rozwiazanie ponizej:

SELECT
    s1.Type AS Typ_Sklepu,
    s1.Store AS Sklep_1,
    s1.Size AS Powierzchnia_1,
    s2.Store AS Sklep_2,
    s2.Size AS Powierzchnia_2,
    ABS(s1.Size - s2.Size) AS Roznica_Powierzchni,
    CASE
        WHEN ABS(s1.Size - s2.Size) <= 20000 THEN 'Podobna powierzchnia'
        WHEN ABS(s1.Size - s2.Size) <= 60000 THEN 'Umiarkowana roznica'
        ELSE 'Duza roznica'
    END AS Kategoria_Roznicy
FROM dbo.Stores_Metadata AS s1
INNER JOIN dbo.Stores_Metadata AS s2
    ON s1.Type = s2.Type
   AND s1.Store < s2.Store
ORDER BY
    s1.Type,
    Roznica_Powierzchni;
GO
/*
ZADANIE DOMOWE

1. Pokaz pary tego samego typu przez s1.Store <> s2.Store.
2. Zmien warunek na s1.Store < s2.Store.
3. Pokaz pary z roznica powierzchni maksymalnie 10000.
4. Policz liczbe unikalnych par wedlug Type.
*/
SELECT
    s1.Type AS Typ_Sklepu,
    COUNT(*) AS Liczba_Unikalnych_Par
FROM dbo.Stores_Metadata AS s1
INNER JOIN dbo.Stores_Metadata AS s2
    ON s1.Type = s2.Type
   AND s1.Store < s2.Store
GROUP BY s1.Type;

SELECT
    s1.Type AS Typ_Sklepu,
    COUNT(*) AS Liczba_Unikalnych_Par
FROM dbo.Stores_Metadata AS s1
INNER JOIN dbo.Stores_Metadata AS s2
    ON s1.Type = s2.Type
   AND s1.Store < s2.Store
WHERE ABS(s1.Size - s2.Size) <= 10000
GROUP BY s1.Type;

SELECT
    s1.Type,
    COUNT(*) AS Unique_Pairs_Count
FROM dbo.Stores_Metadata AS s1
INNER JOIN dbo.Stores_Metadata AS s2
    ON s1.Type = s2.Type
   AND s1.Store < s2.Store
GROUP BY s1.Type
ORDER BY s1.Type;