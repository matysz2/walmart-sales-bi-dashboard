# Power BI – Dzień 18 – Gateway i Scheduled Refresh

## Cel

Połączenie Power BI Service z lokalnym SQL Serverem
i konfiguracja automatycznego odświeżania danych.

## Gateway

On-premises Data Gateway jest mostem pomiędzy:

SQL Server lokalny
a
Power BI Service.

## Architektura

SQL Server
→ Gateway
→ Power BI Service
→ Semantic Model
→ Report

## Standard vs Personal

Standard:
- wielu użytkowników,
- wiele źródeł,
- centralne zarządzanie,
- DirectQuery,
- zastosowanie firmowe.

Personal:
- jeden użytkownik,
- tylko Power BI,
- prostsza konfiguracja.

W projekcie używamy Standard Gateway.

## Ważne

Komputer z gateway musi być:

- włączony,
- połączony z internetem,
- mieć dostęp do SQL Servera.

## SQL Connection

Server:
musi odpowiadać wartości użytej w Power BI Desktop.

Database:
TreningData

Authentication:
Windows lub Basic.

## Refresh

Refresh now:
ręczne pobranie aktualnych danych.

Scheduled Refresh:
automatyczne odświeżanie według harmonogramu.

## Diagnostyka

Refresh History pokazuje:

- status,
- godzinę,
- czas trwania,
- błędy.

## Najczęstsze błędy

- gateway offline,
- złe credentials,
- różna nazwa Server,
- różna nazwa Database,
- komputer wyłączony,
- SQL Server zatrzymany,
- stare hasło.

## Najważniejsze

Publish:
Desktop → Service

Gateway:
Service → lokalny SQL

Refresh:
SQL → aktualizacja Semantic Model

## Power BI Service, Gateway and Data Refresh

The report was published from Power BI Desktop to Power BI Service.

To enable refresh of data stored in the local Microsoft SQL Server
database, I configured an On-premises Data Gateway in Standard mode.

### Architecture

Microsoft SQL Server
        ↓
On-premises Data Gateway
        ↓
Power BI Service
        ↓
Semantic Model
        ↓
Power BI Report

### Configuration

- Published the `Walmart_Sales_SQL` report to Power BI Service.
- Configured a Standard On-premises Data Gateway.
- Created a SQL Server connection for the `TreningData` database.
- Mapped the Power BI semantic model to the gateway connection.
- Configured authentication for the SQL Server data source.
- Successfully tested manual refresh using `Refresh now`.
- Verified refresh execution in `Refresh History`.
- Configured Scheduled Refresh for automatic data updates.

### Refresh process

When new data is added to SQL Server:

1. Power BI Service starts the refresh process.
2. The On-premises Data Gateway connects to the local SQL Server.
3. Power Query transformations are executed.
4. The Semantic Model is updated.
5. The Power BI report displays the refreshed data.

### Troubleshooting

During configuration I diagnosed and resolved several real-world issues:

- missing data source credentials,
- incorrect use of Personal Gateway instead of Standard Gateway,
- mapping the semantic model to the correct gateway connection,
- SQL Server authentication configuration,
- failed refresh attempts identified through Refresh History.

The final refresh completed successfully and Scheduled Refresh was enabled.