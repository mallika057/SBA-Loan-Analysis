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

## 8. Power BI Dashboard

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

## 9. Key Findings

- The dataset contains 5,000 loan records across 18 columns.
- The sum of annual loan approval amounts in the analysis is approximately **$2.569 billion**.
- The average loan approval amount is approximately **$513,861**.
- The average recorded initial interest rate is approximately **8.86%**.
- The average loan term is approximately **138 months**.
- Total recorded gross charge-off amounts are approximately **$10.87 million**, across 89 records with positive charge-off amounts.
- The analyzed records show approximately 52,000 jobs supported, based on the dashboard's rounded KPI.

These findings describe the available dataset and should not automatically be interpreted as evidence of causation or as measures of overall SBA program effectiveness.

## 10. Business Recommendations

- Monitor loan approval trends over time to understand changes in lending activity.
- Review charge-off patterns across loan statuses and processing methods.
- Consider sample sizes when comparing business age groups or processing methods.
- Investigate state-level differences to identify areas that may require further analysis.
- Track jobs-supported measures alongside loan approval amounts to understand reported economic impact.
- Validate loan status definitions and reporting conventions before making lending policy decisions.

## 11. Limitations

- The analysis is limited to the fields and records available in the dataset.
- Missing dates may limit analysis of loan repayment and charge-off timelines.
- Loan status categories require an authoritative data dictionary for precise interpretation.
- Some business categories contain relatively few records, so their observed charge-off percentages may be unstable.
- Observed associations do not establish causation.

## 12. Project Deliverables

- Python Jupyter Notebook (`.ipynb`)
- Raw dataset (`.csv`)
- Cleaned dataset (`.csv`)
- MySQL script (`.sql`)
- Power BI dashboard (`.pbix`)
- Dashboard screenshots
- Project report (`.pdf`)
- Project presentation (`.pptx`)

## 13. Folder Structure

```text
SBA-Loan-Analysis/
├── data/
│   ├── SBALoanData-LoanApproval_DefaultAnalysis.csv
│   └── processed/
│       └── sba_loan_cleaned.csv
├── notebooks/
│   └── sample.ipynb
├── sql/
│   └── sba_loan_analysis.sql
├── powerbi/
│   └── SBA_Loan_Analysis.pbix
├── report/
│   └── SBA_Loan_Analysis_Project_Report.pdf
├── presentation/
│   └── SBA_Loan_Analysis_Presentation.pptx
├── screenshots/
└── README.md
```

*Note: Update the folder and file names above to match the actual files in the GitHub repository.*

## 14. Conclusion

This capstone project demonstrates an end-to-end data analytics workflow, from raw data inspection and Python-based cleaning to SQL analysis and interactive Power BI visualization. The resulting analysis provides an overview of SBA loan approval trends, loan status patterns, charge-offs, and reported business impact.

**Project Type:** Data Analytics Capstone  
**Pattern:** Pattern 1 — Python + MySQL + Power BI  
**Tools:** Python, Pandas, MySQL, SQL, Power BI
