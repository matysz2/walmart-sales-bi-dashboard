# Walmart Sales BI Dashboard

## Project Overview

This project presents an end-to-end sales analysis based on Walmart historical sales data.

The main goal is to build a complete Business Intelligence solution using Microsoft SQL Server and Power BI. The project covers data validation, data cleaning, relational modeling, SQL analysis, reporting views, stored procedures, query optimization, Power Query transformations, DAX measures and an interactive sales dashboard.

The project is being developed as part of my portfolio for Junior Data Analyst, BI Analyst and SQL Analyst roles.

---

## Business Goal

The purpose of the analysis is to:

- evaluate sales performance across stores,
- compare store types and store sizes,
- identify the highest-performing and lowest-performing stores,
- analyze sales trends over time,
- compare holiday and non-holiday sales,
- measure week-over-week changes,
- create business KPIs for management reporting,
- prepare a reusable reporting layer for Power BI.

---

## Business Questions

The project is designed to answer the following questions:

1. Which stores generate the highest total sales?
2. What is the average weekly sales value for each store?
3. How do store types A, B and C differ in sales performance?
4. Is store size related to weekly sales?
5. Are average sales higher during holiday weeks?
6. Which weeks generated the highest sales for each store?
7. How did sales change compared with the previous week?
8. Which stores perform above or below the company average?
9. What sales trends can be observed over time?
10. Which KPIs should be monitored in the Power BI dashboard?

---

## Technologies

- Microsoft SQL Server
- SQL Server Management Studio
- T-SQL
- Power BI Desktop
- Power Query
- DAX
- Visual Studio Code
- Git
- GitHub

---

## Data Sources

The project uses two CSV files:

- `Walmart_Sales.csv` — weekly sales data,
- `stores.csv` — store type and store size information.

### Main source columns

#### Walmart sales data

- `Store`
- `Date_Sales`
- `Weekly_Sales`
- `Holiday_Flag`
- `Temperature`
- `Fuel_Price`
- `CPI`
- `Unemployment`

#### Store metadata

- `Store`
- `Type`
- `Size`

---

## Data Model

The SQL data model contains two main tables.

### Fact table

`dbo.Walmart_Sales_Cleaned`

Grain:

> One row represents the weekly sales result of one store for one date.

Target key:

```sql
PRIMARY KEY (Store, Date_Sales)
```

### Dimension table

`dbo.Stores_Metadata`

Each store occurs once and contains descriptive attributes:

- store type,
- store size.

### Relationship

```text
dbo.Stores_Metadata (1)
        |
        | Store
        |
        v
dbo.Walmart_Sales_Cleaned (*)
```

The relationship is one-to-many:

- one store in `dbo.Stores_Metadata`,
- many weekly sales records in `dbo.Walmart_Sales_Cleaned`.

---

## Data Quality and Preparation

The imported sales file initially contained duplicated records.

| Validation metric | Result |
|---|---:|
| Raw sales rows | 12,870 |
| Cleaned unique sales rows | 6,435 |
| Removed duplicate rows | 6,435 |
| Number of stores | 45 |
| Duplicate stores in metadata | 0 |

The SQL preparation process included:

- checking row counts,
- identifying duplicate records,
- validating missing values,
- converting text columns to correct SQL data types,
- converting the sales date to the `date` type,
- creating the cleaned sales table,
- validating store identifiers,
- defining the one-to-many relationship,
- preparing the composite key `(Store, Date_Sales)`.

---

## SQL Analysis

The SQL stage includes practical use of:

- `SELECT`
- `WHERE`
- `ORDER BY`
- `DISTINCT`
- `CASE`
- `GROUP BY`
- `HAVING`
- `INNER JOIN`
- `LEFT JOIN`
- `RIGHT JOIN`
- `FULL JOIN`
- `SELF JOIN`
- `UNION`
- `UNION ALL`
- Common Table Expressions
- window functions
- `ROW_NUMBER`
- `RANK`
- `DENSE_RANK`
- `LAG`
- `LEAD`
- views
- nonclustered indexes
- stored procedures
- input validation
- `OUTPUT` parameters
- query execution plans
- query optimization

---

## SQL Reporting Layer

The reporting layer prepares reusable datasets for business reporting.

It includes:

- detailed sales data enriched with store type and size,
- sales summaries by store,
- rankings by total sales,
- best-performing weeks for each store,
- week-over-week sales changes,
- holiday and non-holiday comparisons,
- parameterized reports by store and date range,
- indexes supporting commonly used filters,
- optimized date filters based on ranges.

Example date filter:

```sql
WHERE Date_Sales >= '20110101'
  AND Date_Sales <  '20120101'
```

This form is preferred over:

```sql
WHERE YEAR(Date_Sales) = 2011
```

because the range condition can work more effectively with an index on `Date_Sales`.

---

## Stored Procedures and Automation

Stored procedures are used to create reusable reports with parameters such as:

- store number,
- start date,
- end date,
- holiday flag.

Example execution:

```sql
EXEC dbo.usp_Walmart_Sales_By_Store
    @Store = 20,
    @Date_From = '20110101',
    @Date_To = '20111231',
    @Holiday_Flag = 1;
```

The project also documents how a stored procedure can be scheduled automatically with:

- SQL Server Agent,
- a SQL Server Agent Job,
- a recurring schedule.

---

## Query Optimization

The optimization stage includes:

- Estimated Execution Plan,
- Actual Execution Plan,
- `SET STATISTICS IO ON`,
- `SET STATISTICS TIME ON`,
- `Index Seek`,
- `Index Scan`,
- `Key Lookup`,
- SARGable filters,
- avoiding unnecessary `SELECT *`,
- avoiding functions on filtered columns,
- testing the same query before and after optimization.

Optimization workflow:

```text
Correct result
    ↓
Measure performance
    ↓
Apply one change
    ↓
Measure again
    ↓
Compare the result
```

---

## Power BI Scope

The Power BI stage will include:

- importing SQL Server data,
- Power Query transformations,
- a star schema data model,
- a dedicated date table,
- relationships,
- DAX measures,
- KPI cards,
- sales trend charts,
- store rankings,
- holiday analysis,
- filters and slicers,
- drill-through pages,
- tooltips,
- dashboard design.

### Planned KPIs

- Total Sales
- Average Weekly Sales
- Store Count
- Number of Sales Weeks
- Holiday Sales
- Non-Holiday Sales
- Holiday Sales Difference
- Week-over-Week Change
- Store Rank
- Best Sales Week
- Sales by Store Type
- Sales by Store Size

---

## Preliminary Findings

The SQL and Python analysis produced the following preliminary findings:

- Store 20 generated the highest total sales in the dataset.
- Store size had the strongest positive relationship with weekly sales, with a correlation of approximately `0.81`.
- Holiday weeks had a higher average weekly sales value than non-holiday weeks.
- Total non-holiday sales were higher because the dataset contains many more non-holiday observations.
- Store types and store sizes should be analyzed together rather than treating store type as the only performance factor.
- Correlation between store size and sales does not prove that increasing store size directly causes sales growth.

These findings will be validated and presented visually in the Power BI dashboard.

---

## Project Workflow

1. Import CSV files into SQL Server.
2. Audit the source data.
3. Detect duplicates and missing values.
4. Create `dbo.Walmart_Sales_Cleaned`.
5. Validate data types and keys.
6. Create the relationship with `dbo.Stores_Metadata`.
7. Perform SQL business analysis.
8. Create reporting views.
9. Create stored procedures.
10. Add indexes and measure query performance.
11. Import the reporting layer into Power BI.
12. Transform data in Power Query.
13. Create the data model.
14. Develop DAX measures.
15. Build the interactive dashboard.
16. Document business conclusions and recommendations.

---

## Repository Structure

```text
walmart-sales-bi-dashboard/
│
├── data/
│   └── raw/
│       ├── Walmart_Sales.csv
│       └── stores.csv
│
├── sql/
│   ├── 01_data_audit.sql
│   ├── 02_data_cleaning.sql
│   ├── 03_joins_and_relations.sql
│   ├── 04_cte_and_window_functions.sql
│   ├── 05_views.sql
│   ├── 06_indexes.sql
│   ├── 07_stored_procedures.sql
│   ├── 08_query_optimization.sql
│   └── 09_final_reporting_layer.sql
│
├── power-bi/
│   └── walmart_sales_dashboard.pbix
│
├── docs/
│   ├── data_dictionary.md
│   ├── business_requirements.md
│   └── sql_notes.md
│
├── screenshots/
│   └── dashboard-preview.png
│
└── README.md
```

---

## How to Run the Project

### 1. Prepare SQL Server

Create or select the project database in SQL Server Management Studio.

### 2. Import the source files

Import:

```text
Walmart_Sales.csv
stores.csv
```

### 3. Run SQL scripts

Execute the scripts from the `sql` directory in numerical order.

### 4. Validate the cleaned tables

Expected main results:

```text
dbo.Walmart_Sales_Cleaned → 6,435 rows
dbo.Stores_Metadata       → 45 rows
```

### 5. Open Power BI

Connect Power BI Desktop to SQL Server and import the prepared reporting objects.

### 6. Refresh the model

Run Power Query transformations, refresh the model and validate relationships and measures.

---

## Project Status

### Completed

- source data audit,
- duplicate detection,
- cleaned SQL table,
- data type conversion,
- one-to-many relationship,
- SQL joins and aggregations,
- CTEs,
- window functions,
- rankings,
- sales change analysis,
- reporting views,
- indexes,
- stored procedures,
- SQL Server Agent instructions,
- query optimization,
- final SQL reporting layer.

### In progress

- Power Query transformations,
- Power BI data model,
- DAX measures,
- dashboard design,
- final business recommendations,
- dashboard screenshots.

---

## Skills Demonstrated

This project demonstrates practical knowledge of:

- relational data modeling,
- data quality validation,
- SQL data cleaning,
- business-oriented SQL analysis,
- analytical window functions,
- ranking and trend analysis,
- stored procedure development,
- parameter validation,
- SQL performance analysis,
- reporting layer design,
- Power BI preparation,
- Git and GitHub project documentation.

---

## Future Improvements

Planned improvements include:

- adding a dedicated calendar dimension,
- implementing additional DAX time-intelligence measures,
- adding year-over-year comparisons,
- creating drill-through pages for individual stores,
- adding report tooltips,
- adding data refresh automation,
- publishing the report to Power BI Service,
- adding Row-Level Security,
- preparing a short project presentation for job interviews.

---

## Author

**Mateusz Czarnik**

Portfolio project developed as part of preparation for Junior Data Analyst, BI Analyst and SQL Analyst roles.
