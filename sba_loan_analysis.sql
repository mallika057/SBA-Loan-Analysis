CREATE DATABASE sba_loan_analysis;

USE sba_loan_analysis;

SELECT COUNT(*) AS total_records
FROM sba_loan_data;

SELECT *
FROM sba_loan_data
LIMIT 5;

SELECT
    LoanStatus,
    COUNT(*) AS TotalLoans,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM sba_loan_data),
        2
    ) AS Percentage
FROM sba_loan_data
GROUP BY LoanStatus
ORDER BY TotalLoans DESC;

SELECT
    ApprovalFY,
    COUNT(*) AS TotalLoans,
    SUM(GrossApproval) AS TotalApprovalAmount,
    ROUND(AVG(GrossApproval), 2) AS AverageLoanAmount
FROM sba_loan_data
GROUP BY ApprovalFY
ORDER BY ApprovalFY;

SELECT
    LoanStatus,
    COUNT(*) AS TotalLoans,
    SUM(GrossChargeOffAmount) AS TotalChargeOffAmount,
    ROUND(AVG(GrossChargeOffAmount), 2) AS AvgChargeOffAmount
FROM sba_loan_data
GROUP BY LoanStatus
ORDER BY TotalChargeOffAmount DESC;

SELECT
    ProjectState,
    COUNT(*) AS TotalLoans,
    SUM(GrossApproval) AS TotalApprovalAmount,
    SUM(GrossChargeOffAmount) AS TotalChargeOffAmount
FROM sba_loan_data
GROUP BY ProjectState
ORDER BY TotalApprovalAmount DESC;

SELECT
    BusinessType,
    COUNT(*) AS TotalLoans,
    ROUND(SUM(GrossApproval), 2) AS TotalApprovalAmount,
    SUM(CASE
        WHEN LoanStatus = 'CHGOFF' THEN 1
        ELSE 0
    END) AS ChargeOffLoans
FROM sba_loan_data
GROUP BY BusinessType
ORDER BY TotalLoans DESC;

SELECT
    ProcessingMethod,
    COUNT(*) AS TotalLoans,
    ROUND(SUM(GrossApproval), 2) AS TotalApprovalAmount,
    SUM(
        CASE
            WHEN LoanStatus = 'CHGOFF' THEN 1
            ELSE 0
        END
    ) AS ChargeOffLoans
FROM sba_loan_data
GROUP BY ProcessingMethod
ORDER BY TotalLoans DESC;

SELECT
    BusinessAge,
    COUNT(*) AS TotalLoans,
    ROUND(SUM(GrossApproval), 2) AS TotalApprovalAmount,
    SUM(
        CASE
            WHEN LoanStatus = 'CHGOFF' THEN 1
            ELSE 0
        END
    ) AS ChargeOffLoans,
    ROUND(
        100.0 * SUM(
            CASE WHEN LoanStatus = 'CHGOFF' THEN 1 ELSE 0 END
        ) / COUNT(*),
        2
    ) AS ChargeOffSharePct
FROM sba_loan_data
GROUP BY BusinessAge
ORDER BY ChargeOffSharePct DESC;

SELECT
    CASE
        WHEN TermInMonths <= 60 THEN '0-60 Months'
        WHEN TermInMonths <= 120 THEN '61-120 Months'
        WHEN TermInMonths <= 240 THEN '121-240 Months'
        ELSE 'Above 240 Months'
    END AS LoanTermCategory,
    COUNT(*) AS TotalLoans,
    ROUND(SUM(GrossApproval), 2) AS TotalApprovalAmount,
    SUM(
        CASE WHEN LoanStatus = 'CHGOFF' THEN 1 ELSE 0 END
    ) AS ChargeOffLoans
FROM sba_loan_data
GROUP BY LoanTermCategory
ORDER BY TotalLoans DESC;

SELECT
    ApprovalFY,
    COUNT(*) AS TotalLoans,
    SUM(JobsSupported) AS TotalJobsSupported,
    ROUND(AVG(JobsSupported), 2) AS AvgJobsPerLoan
FROM sba_loan_data
GROUP BY ApprovalFY
ORDER BY ApprovalFY;

SELECT
    ProcessingMethod,
    COUNT(*) AS TotalLoans,
    ROUND(AVG(InitialInterestRate), 2) AS AvgInterestRate,
    MIN(InitialInterestRate) AS MinInterestRate,
    MAX(InitialInterestRate) AS MaxInterestRate
FROM sba_loan_data
WHERE InitialInterestRate IS NOT NULL
GROUP BY ProcessingMethod
ORDER BY AvgInterestRate DESC;

SELECT
    ApprovalFY,
    COUNT(*) AS TotalLoans,
    ROUND(SUM(GrossApproval), 2) AS TotalApprovalAmount,
    ROUND(SUM(SBAGuaranteedApproval), 2) AS TotalGuaranteedAmount,
    ROUND(
        100.0 * SUM(SBAGuaranteedApproval)
        / NULLIF(SUM(GrossApproval), 0),
        2
    ) AS GuaranteePercentage
FROM sba_loan_data
GROUP BY ApprovalFY
ORDER BY ApprovalFY;

CREATE OR REPLACE VIEW vw_loan_status_summary AS
SELECT
    LoanStatus,
    COUNT(*) AS TotalLoans,
    ROUND(SUM(GrossApproval), 2) AS TotalApprovalAmount,
    ROUND(SUM(GrossChargeOffAmount), 2) AS TotalChargeOffAmount
FROM sba_loan_data
GROUP BY LoanStatus;

SELECT *
FROM vw_loan_status_summary;

CREATE OR REPLACE VIEW vw_yearly_loan_summary AS
SELECT
    ApprovalFY,
    COUNT(*) AS TotalLoans,
    ROUND(SUM(GrossApproval), 2) AS TotalApprovalAmount,
    ROUND(AVG(GrossApproval), 2) AS AverageLoanAmount,
    SUM(JobsSupported) AS TotalJobsSupported
FROM sba_loan_data
GROUP BY ApprovalFY;

SELECT *
FROM vw_yearly_loan_summary
ORDER BY ApprovalFY;

CREATE OR REPLACE VIEW vw_processing_method_summary AS
SELECT
    ProcessingMethod,
    COUNT(*) AS TotalLoans,
    ROUND(SUM(GrossApproval), 2) AS TotalApprovalAmount,
    SUM(
        CASE
            WHEN LoanStatus = 'CHGOFF' THEN 1
            ELSE 0
        END
    ) AS ChargeOffLoans
FROM sba_loan_data
GROUP BY ProcessingMethod;

SELECT *
FROM vw_processing_method_summary
ORDER BY TotalLoans DESC;

CREATE OR REPLACE VIEW vw_state_loan_summary AS
SELECT
    ProjectState,
    COUNT(*) AS TotalLoans,
    ROUND(SUM(GrossApproval), 2) AS TotalApprovalAmount,
    SUM(
        CASE
            WHEN LoanStatus = 'CHGOFF' THEN 1
            ELSE 0
        END
    ) AS ChargeOffLoans
FROM sba_loan_data
GROUP BY ProjectState;

SELECT *
FROM vw_state_loan_summary
ORDER BY TotalApprovalAmount DESC;

CREATE OR REPLACE VIEW vw_business_age_summary AS
SELECT
    BusinessAge,
    COUNT(*) AS TotalLoans,
    ROUND(SUM(GrossApproval), 2) AS TotalApprovalAmount,
    SUM(
        CASE
            WHEN LoanStatus = 'CHGOFF' THEN 1
            ELSE 0
        END
    ) AS ChargeOffLoans
FROM sba_loan_data
GROUP BY BusinessAge;

SELECT *
FROM vw_business_age_summary
ORDER BY TotalLoans DESC;

CREATE OR REPLACE VIEW vw_loan_term_summary AS
SELECT
    CASE
        WHEN TermInMonths <= 60 THEN '0-60 Months'
        WHEN TermInMonths <= 120 THEN '61-120 Months'
        WHEN TermInMonths <= 240 THEN '121-240 Months'
        ELSE 'Above 240 Months'
    END AS LoanTermCategory,
    COUNT(*) AS TotalLoans,
    ROUND(SUM(GrossApproval), 2) AS TotalApprovalAmount,
    SUM(
        CASE
            WHEN LoanStatus = 'CHGOFF' THEN 1
            ELSE 0
        END
    ) AS ChargeOffLoans
FROM sba_loan_data
GROUP BY LoanTermCategory;

SELECT *
FROM vw_loan_term_summary
ORDER BY TotalLoans DESC;

CREATE OR REPLACE VIEW vw_jobs_supported_summary AS
SELECT
    ApprovalFY,
    COUNT(*) AS TotalLoans,
    SUM(JobsSupported) AS TotalJobsSupported,
    ROUND(AVG(JobsSupported), 2) AS AvgJobsPerLoan
FROM sba_loan_data
GROUP BY ApprovalFY;

SELECT *
FROM vw_jobs_supported_summary
ORDER BY ApprovalFY;

CREATE OR REPLACE VIEW vw_interest_rate_summary AS
SELECT
    ProcessingMethod,
    COUNT(*) AS TotalLoans,
    ROUND(AVG(InitialInterestRate), 2) AS AvgInterestRate,
    MIN(InitialInterestRate) AS MinInterestRate,
    MAX(InitialInterestRate) AS MaxInterestRate
FROM sba_loan_data
WHERE InitialInterestRate IS NOT NULL
GROUP BY ProcessingMethod;

SELECT *
FROM vw_interest_rate_summary
ORDER BY AvgInterestRate DESC;

USE sba_loan_analysis;

SHOW FULL TABLES
WHERE Table_type = 'VIEW';

USE sba_loan_analysis;

CREATE TABLE state_loan_summary AS
SELECT
    ProjectState,
    COUNT(*) AS TotalLoans,
    SUM(GrossApproval) AS TotalApprovalAmount,
    SUM(GrossChargeOffAmount) AS TotalChargeOffAmount
FROM sba_loan_data
GROUP BY ProjectState;

SELECT
    s.ProjectState,
    s.TotalLoans,
    s.TotalApprovalAmount,
    s.TotalChargeOffAmount
FROM sba_loan_data AS l
INNER JOIN state_loan_summary AS s
    ON l.ProjectState = s.ProjectState
GROUP BY
    s.ProjectState,
    s.TotalLoans,
    s.TotalApprovalAmount,
    s.TotalChargeOffAmount
ORDER BY s.TotalApprovalAmount DESC;

SELECT
    l.ProjectState,
    s.TotalLoans,
    s.TotalApprovalAmount,
    s.TotalChargeOffAmount
FROM sba_loan_data AS l
INNER JOIN state_loan_summary AS s
    ON l.ProjectState = s.ProjectState
GROUP BY
    l.ProjectState,
    s.TotalLoans,
    s.TotalApprovalAmount,
    s.TotalChargeOffAmount
ORDER BY s.TotalApprovalAmount DESC;

SELECT
    ProjectState,
    TotalLoans,
    TotalApprovalAmount,
    RANK() OVER (
        ORDER BY TotalApprovalAmount DESC
    ) AS ApprovalRank
FROM state_loan_summary
ORDER BY ApprovalRank;

SELECT COUNT(*) AS TotalRows
FROM sba_loan_analysis.sba_loan_data;

SELECT COUNT(*) AS BackupRows
FROM sba_loan_analysis.sba_loan_data_backup;

USE sba_loan_analysis;

SHOW FULL TABLES;


CREATE TABLE sba_loan_data_backup AS
SELECT *
FROM sba_loan_data;

SELECT
    (SELECT COUNT(*) FROM sba_loan_data) AS OriginalRows,
    (SELECT COUNT(*) FROM sba_loan_data_backup) AS BackupRows;
    
ALTER TABLE sba_loan_data
ADD COLUMN LoanID BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST;    

SHOW KEYS FROM sba_loan_data
WHERE Key_name = 'PRIMARY';

SELECT
    COUNT(*) AS TotalRows,
    COUNT(LoanID) AS NonNullIDs,
    COUNT(DISTINCT LoanID) AS UniqueIDs
FROM sba_loan_data;


   