# Dzień 24 - Projekt końcowy etapu SQL

## Temat
**Walmart Sales Performance - warstwa danych pod Power BI**

## Cel dnia
Połączyć wiedzę z całego etapu SQL: audyt danych, JOIN, CTE, funkcje okienkowe, VIEW, procedury, indeksy i optymalizację.

## Dane
- `dbo.Walmart_Sales_Cleaned`
- `dbo.Stores_Metadata`
- kolumna daty: `Date_Sales`
- relacja: `Stores_Metadata.Store` 1 -> * `Walmart_Sales_Cleaned.Store`

## Wyniki kontrolne
- 6435 rekordów sprzedaży
- 45 sklepów
- zakres dat: 2010-02-05 - 2012-10-26
- sprzedaż całkowita: 6 737 218 987,11
- średnia tygodniowa: 1 046 964,88

## Proces projektu
1. Audyt i walidacja.
2. Utworzenie widoku `dbo.vw_Walmart_Sales_Analysis`.
3. Agregacja do poziomu sklepu.
4. Ranking sklepów przez `RANK()`.
5. Najlepszy tydzień przez `ROW_NUMBER()`.
6. Zmiana WoW przez `LAG()`.
7. Procedura `dbo.usp_Walmart_Store_Performance`.
8. Pomiar wydajności i analiza indeksu.
9. Walidacja wyników.
10. Publikacja w Git/GitHub.

## Najważniejsze wzorce
```sql
AVG(Weekly_Sales) OVER (PARTITION BY Store)
ROW_NUMBER() OVER (PARTITION BY Store ORDER BY Weekly_Sales DESC)
RANK() OVER (ORDER BY Total_Sales DESC)
LAG(Weekly_Sales) OVER (PARTITION BY Store ORDER BY Date_Sales)
```

## Co zapamiętać
- Ranking sklepów wykonujemy po agregacji do jednego rekordu na sklep.
- Alias funkcji okienkowej filtrujemy w CTE lub podzapytaniu.
- Zakres dat jest zwykle lepszy niż `YEAR(Date_Sales)` w `WHERE`.
- Indeks mierzymy przez Actual Plan, `STATISTICS IO` i `STATISTICS TIME`.
- Wynik biznesowy musi pozostać identyczny po optymalizacji.

## Zadanie domowe
- Uruchom cały skrypt w SSMS.
- Potwierdź checklistę wyników.
- Napisz pięć wniosków biznesowych.
- Przygotuj dwuminutową prezentację rekrutacyjną.
- Wykonaj commit i push do GitHub.
