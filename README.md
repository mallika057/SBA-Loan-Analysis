# SBA Loan Analysis — Data Analytics Capstone Project

## 1. Project Overview

This project analyzes U.S. Small Business Administration (SBA) loan data to understand loan approval trends, loan status, charge-offs, interest rates, and the economic impact of small-business lending.

The project follows an end-to-end data analytics workflow using **Python, MySQL, and Microsoft Power BI**. The goal is to transform raw loan data into meaningful business insights that can support data-driven decision-making.

## 2. Project Objectives

- Analyze loan approval trends across fiscal years.
- Understand the distribution of loan statuses.
- Examine charge-offs and loan risk patterns.
- Compare loan performance across business types and business ages.
- Analyze state-level loan approval amounts.
- Explore the relationship between SBA lending and jobs supported.
- Build an interactive dashboard for business users.

## 3. Dataset Information

- **Dataset:** SBA Loan Data
- **Records:** 5,000
- **Columns:** 18
- **Data types:** Numerical, categorical, and date-related fields
- **CSV dataset:** 5,000 records × 18 columns
- **MySQL source table:** 5,000 records × 19 columns (including the additional `LoanID` primary key) 
- **Source:** [U.S. Small Business Administration — 7(a) and 504 FOIA Data](https://data.sba.gov/dataset/7a-504-foia)

The dataset contains information related to loan approvals, business characteristics, loan status, interest rates, loan terms, charge-offs, and jobs supported.

## 4. Tools and Technologies

| Tool | Purpose |
|---|---|
| Python | Data cleaning, transformation, and exploratory data analysis |
| Pandas | Data manipulation and analysis |
| MySQL | Data storage and SQL-based business analysis |
| SQL | Aggregations, joins, subqueries, CASE statements, views, and window functions |
| Power BI | Interactive dashboards, KPI cards, slicers, and visual analysis |
| Jupyter Notebook | Python workflow and documentation |

## 5. Project Workflow

1. Collected the raw SBA loan dataset.
2. Inspected the dataset structure, data types, missing values, and data quality.
3. Cleaned and transformed the data using Python and Pandas.
4. Exported the cleaned dataset to CSV.
5. Loaded the cleaned data into MySQL.
6. Developed SQL queries to answer business questions and created analytical views.
7. Connected the data to Power BI.
8. Created an interactive dashboard with three pages.
9. Summarized findings, limitations, and business recommendations.

## 6. Data Cleaning and Preparation

The following data quality checks and cleaning steps were performed:

- Checked for duplicate records.
- Identified missing values in business and date-related columns.
- Replaced missing business type and business age values with `Unknown`.
- Parsed date fields using the appropriate date format.
- Checked loan approval amounts, charge-off amounts, and jobs-supported values for invalid or unexpected values.
- Exported the cleaned data and verified that it retained 5,000 rows and 18 columns.

Missing paid-in-full and charge-off dates were retained where unavailable because these dates are not applicable or recorded for every loan.

## 7. MySQL Analysis

The cleaned data was stored in the `sba_loan_analysis` database.

SQL analysis included:

- Loan status distribution
- Annual loan approval trends
- State-wise loan approval analysis
- Business age analysis
- Loan term analysis
- Interest rate analysis
- Jobs-supported analysis
- Processing method comparisons
- Charge-off analysis
- Ranking states by loan approval amount

SQL techniques included `GROUP BY`, aggregate functions, `CASE`, subqueries, `JOIN`, `NULLIF`, window functions, and views.

Eight analytical SQL views were created to support reusable analysis.

## 8. MySQL Star Schema Design

A star schema was implemented to organize the SBA loan data into a central fact table and four dimension tables.

### Fact Table
- `fact_sba_loan` – Stores loan-level measures and foreign keys for dimensional analysis.

### Dimension Tables
- `dim_state` – Contains state information.
- `dim_approval_date` – Contains approval date and fiscal-year details.
- `dim_business` – Contains business type and business age details.
- `dim_loan_details` – Contains loan characteristics and status information.

### Relationships
The fact table is connected to all four dimension tables through foreign keys:
- `StateKey`
- `DateKey`
- `BusinessKey`
- `LoanDetailsKey`

Each dimension has a one-to-many relationship with the fact table. This structure supports consistent filtering and analysis in Power BI.

The star schema contains 5,000 fact records and the following dimension records:
- State: 54
- Approval Date: 1,604
- Business: 1,649
- Loan Details: 71

 ## 9. SQL Views

The project includes eight reusable SQL views for analyzing
loan activity and supporting business questions.

1. `vw_loan_status_summary` – Summarizes loan records by status.
2. `vw_yearly_loan_summary` – Summarizes loan metrics by fiscal year.
3. `vw_processing_method_summary` – Compares loan processing methods.
4. `vw_state_loan_summary` – Summarizes loan activity by state.
5. `vw_business_age_summary` – Compares business-age categories.
6. `vw_loan_term_summary` – Summarizes loan terms.
7. `vw_jobs_supported_summary` – Summarizes jobs supported.
8. `vw_interest_rate_summary` – Summarizes interest-rate metrics.

## 10. Project Setup and Execution

### Python

1. Install Python and Jupyter Notebook.
2. Install the required libraries, including pandas.
3. Open the project notebook.
4. Update the dataset path if required.
5. Run the notebook cells to inspect, clean, and analyze the data.
6. Verify that the cleaned dataset contains 5,000 rows and 18 columns.

### MySQL

1. Install MySQL Server and MySQL Workbench.
2. Create or select the `sba_loan_analysis` database.
3. Import the cleaned CSV into the source table if setting up a new database.
4. Execute the SQL schema, analysis queries, and view definitions in the documented order.
5. Verify the source table and fact table contain 5,000 records.
6. Verify that all eight SQL views are available.

Note: The SQL script contains table creation and data-loading
operations. Do not rerun it against an already populated database
without checking which statements have already been executed.
Keep the existing backup table unchanged.

### Power BI

1. Open the supplied Power BI `.pbix` file.
2. Update the MySQL connection details if required.
3. Refresh the data model.
4. Verify the relationships between the fact and dimension tables.
5. Test the slicers, KPI cards, and charts across all three pages.


## 11. Power BI Dashboard

The interactive Power BI dashboard contains three pages.

### Page 1: Executive Summary
- Total loan approval amount
- Total number of loans
- Total charge-off amount
- Jobs supported
- Average interest rate
- Average loan approval amount
- Loan approval trends by fiscal year
- Loan status distribution
- Annual charge-off trends

### Page 2: Loan Risk and Status Analysis
- Charge-offs by loan status
- Average interest rate by business type
- Number of loans by status
- Key loan approval and charge-off KPIs

### Page 3: Business and Economic Impact
- Jobs supported
- Total loan approval amount
- Average loan term
- Business age group analysis

Interactive slicers allow users to explore the data by fiscal year, state, loan status, and business type.

## 12. Dashboard Screenshots

The three-page Power BI dashboard screenshots are available here:

[View Dashboard Screenshots (PDF)](SBA_Dashboard_Screenshots.pdf)
## 13. Project Repository

The complete project files, including the Python notebook, SQL scripts, cleaned dataset, Power BI dashboard, and project documentation, are available on GitHub.

**GitHub Repository:**  
https://github.com/mallika057/SBA-Loan-Analysis

## 14. Key Findings

- The dataset contains 5,000 loan records across 18 columns.
- The sum of annual loan approval amounts in the analysis is approximately **$2.57 billion**.
- The average loan approval amount is approximately **$513,861**.
- The average recorded initial interest rate is approximately **8.86%**.
- The average loan term is approximately **138 months**.
- Total recorded gross charge-off amounts are approximately **$10.87 million**, across 89 records with positive charge-off amounts.
- The analyzed records show approximately 52,000 jobs supported, based on the dashboard's rounded KPI.

These findings describe the available dataset and should not automatically be interpreted as evidence of causation or as measures of overall SBA program effectiveness.

## 15. Business Recommendations

- Monitor loan approval trends over time to understand changes in lending activity.
- Review charge-off patterns across loan statuses and processing methods.
- Consider sample sizes when comparing business age groups or processing methods.
- Investigate state-level differences to identify areas that may require further analysis.
- Track jobs-supported measures alongside loan approval amounts to understand reported economic impact.
- Validate loan status definitions and reporting conventions before making lending policy decisions.

## 16. Limitations

- The analysis is limited to the fields and records available in the dataset.
- Missing dates may limit analysis of loan repayment and charge-off timelines.
- Loan status categories require an authoritative data dictionary for precise interpretation.
- Some business categories contain relatively few records, so their observed charge-off percentages may be unstable.
- Observed associations do not establish causation.

## 17. Project Deliverables

- Python Jupyter Notebook (`.ipynb`)
- Raw dataset (`.csv`)
- Cleaned dataset (`.csv`)
- MySQL script (`.sql`)
- Power BI dashboard (`.pbix`)
- Dashboard screenshots
- Project report (`.pdf`)
- Project presentation (`.pptx`)

## 18. Folder Structure

```text
SBA-Loan-Analysis/
├── sample.ipynb
├── sba_loan_analysis.sql
├── SBA_Loan_Analysis.pbix
├── SBA_Loan_Analysis_Project_Report.pdf
├── SBA_Loan_Analysis_Presentation.pptx
├── SBALoanData-LoanApproval_DefaultAnalysis.csv
├── sba_loan_cleaned.csv
├── SBA_Dashboard_Screenshots.pdf
└── README.md
```

*Note: Update the folder and file names above to match the actual files in the GitHub repository.*

## 19. Conclusion

This capstone project demonstrates an end-to-end data analytics workflow, from raw data inspection and Python-based cleaning to SQL analysis and interactive Power BI visualization. The resulting analysis provides an overview of SBA loan approval trends, loan status patterns, charge-offs, and reported business impact.

**Project Type:** Data Analytics Capstone  
**Pattern:** Pattern 1 — Python + MySQL + Power BI  
**Tools:** Python, Pandas, MySQL, SQL, Power BI
