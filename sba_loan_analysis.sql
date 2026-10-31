CREATE DATABASE IF NOT EXISTS sba_loan_analysis;

USE sba_loan_analysis;

-- =====================================================
-- SOURCE TABLE SCHEMA
-- Existing table structure captured using SHOW CREATE TABLE
-- =====================================================

CREATE TABLE IF NOT EXISTS sba_loan_data (
    LoanID BIGINT NOT NULL AUTO_INCREMENT,
    ApprovalDate TEXT,
    ApprovalFY INT DEFAULT NULL,
    ProcessingMethod TEXT,
    GrossApproval INT DEFAULT NULL,
    SBAGuaranteedApproval DOUBLE DEFAULT NULL,
    InitialInterestRate DOUBLE DEFAULT NULL,
    FixedorVariableInterestInd TEXT,
    TermInMonths INT DEFAULT NULL,
    NaicsDescription TEXT,
    ProjectState TEXT,
    BusinessType TEXT,
    BusinessAge TEXT,
    LoanStatus TEXT,
    PaidInFullDate TEXT,
    ChargeOffDate TEXT,
    GrossChargeOffAmount DOUBLE DEFAULT NULL,
    RevolverStatus TEXT,
    JobsSupported INT DEFAULT NULL,
    PRIMARY KEY (LoanID)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci;

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

-- Verify all SQL views
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
    
SHOW KEYS FROM sba_loan_data
WHERE Key_name = 'PRIMARY';

SELECT
    COUNT(*) AS TotalRows,
    COUNT(LoanID) AS NonNullIDs,
    COUNT(DISTINCT LoanID) AS UniqueIDs
FROM sba_loan_data;


DESCRIBE sba_loan_data;

USE sba_loan_analysis;

-- 1. Dimension: Approval year and date
CREATE TABLE IF NOT EXISTS dim_approval_date (
    DateKey INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ApprovalDateText VARCHAR(30),
    ApprovalFY INT,
    UNIQUE KEY uq_approval_date_year (ApprovalDateText, ApprovalFY)
);

-- 2. Dimension: State
CREATE TABLE IF NOT EXISTS dim_state (
    StateKey INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ProjectState VARCHAR(100) NOT NULL UNIQUE
);

-- 3. Dimension: Business details
CREATE TABLE IF NOT EXISTS dim_business (
    BusinessKey INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    BusinessType VARCHAR(255),
    BusinessAge VARCHAR(255),
    NaicsDescription VARCHAR(500),
    UNIQUE KEY uq_business_details
        (BusinessType, BusinessAge, NaicsDescription(191))
);

-- 4. Dimension: Loan details
CREATE TABLE IF NOT EXISTS dim_loan_details (
    LoanDetailsKey INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ProcessingMethod VARCHAR(100),
    LoanStatus VARCHAR(100),
    FixedorVariableInterestInd VARCHAR(100),
    RevolverStatus VARCHAR(100),
    UNIQUE KEY uq_loan_details
        (ProcessingMethod, LoanStatus,
         FixedorVariableInterestInd, RevolverStatus)
);

-- 5. Fact table: Loan-level measures
CREATE TABLE IF NOT EXISTS fact_sba_loan (
    LoanID BIGINT NOT NULL PRIMARY KEY,
    DateKey INT,
    StateKey INT,
    BusinessKey INT,
    LoanDetailsKey INT,
    GrossApproval DECIMAL(18,2),
    SBAGuaranteedApproval DECIMAL(18,2),
    InitialInterestRate DECIMAL(10,4),
    TermInMonths INT,
    GrossChargeOffAmount DECIMAL(18,2),
    JobsSupported INT,
    FOREIGN KEY (DateKey) REFERENCES dim_approval_date(DateKey),
    FOREIGN KEY (StateKey) REFERENCES dim_state(StateKey),
    FOREIGN KEY (BusinessKey) REFERENCES dim_business(BusinessKey),
    FOREIGN KEY (LoanDetailsKey)
        REFERENCES dim_loan_details(LoanDetailsKey)
);

SHOW TABLES;

DESCRIBE fact_sba_loan;

SELECT 'sba_loan_data' AS TableName, COUNT(*) AS TotalRows
FROM sba_loan_data
UNION ALL
SELECT 'dim_state', COUNT(*) FROM dim_state
UNION ALL
SELECT 'dim_approval_date', COUNT(*) FROM dim_approval_date
UNION ALL
SELECT 'dim_business', COUNT(*) FROM dim_business
UNION ALL
SELECT 'dim_loan_details', COUNT(*) FROM dim_loan_details
UNION ALL
SELECT 'fact_sba_loan', COUNT(*) FROM fact_sba_loan;

USE sba_loan_analysis;

-- 1. Approval date dimension
INSERT INTO dim_approval_date (ApprovalDateText, ApprovalFY)
SELECT DISTINCT ApprovalDate, ApprovalFY
FROM sba_loan_data
WHERE ApprovalDate IS NOT NULL
   OR ApprovalFY IS NOT NULL;

-- 2. State dimension
INSERT INTO dim_state (ProjectState)
SELECT DISTINCT ProjectState
FROM sba_loan_data
WHERE ProjectState IS NOT NULL;

-- 3. Business dimension
INSERT INTO dim_business (
    BusinessType, BusinessAge, NaicsDescription
)
SELECT DISTINCT
    BusinessType, BusinessAge, NaicsDescription
FROM sba_loan_data;

-- 4. Loan details dimension
INSERT INTO dim_loan_details (
    ProcessingMethod,
    LoanStatus,
    FixedorVariableInterestInd,
    RevolverStatus
)
SELECT DISTINCT
    ProcessingMethod,
    LoanStatus,
    FixedorVariableInterestInd,
    RevolverStatus
FROM sba_loan_data;

SELECT 'dim_state' AS TableName, COUNT(*) AS TotalRows
FROM dim_state
UNION ALL
SELECT 'dim_approval_date', COUNT(*) FROM dim_approval_date
UNION ALL
SELECT 'dim_business', COUNT(*) FROM dim_business
UNION ALL
SELECT 'dim_loan_details', COUNT(*) FROM dim_loan_details;

SELECT
    COUNT(*) AS TotalRows,
    COUNT(ApprovalDate) AS ApprovalDateCount,
    COUNT(ApprovalFY) AS ApprovalFYCount,
    COUNT(ProjectState) AS ProjectStateCount,
    COUNT(BusinessType) AS BusinessTypeCount,
    COUNT(BusinessAge) AS BusinessAgeCount,
    COUNT(NaicsDescription) AS NaicsDescriptionCount
FROM sba_loan_data;

SELECT * FROM dim_state LIMIT 5;

SELECT * FROM dim_approval_date LIMIT 5;

SELECT * FROM dim_business LIMIT 5;

SELECT * FROM dim_loan_details LIMIT 5;

USE sba_loan_analysis;

INSERT INTO fact_sba_loan (
    LoanID,
    DateKey,
    StateKey,
    BusinessKey,
    LoanDetailsKey,
    GrossApproval,
    SBAGuaranteedApproval,
    InitialInterestRate,
    TermInMonths,
    GrossChargeOffAmount,
    JobsSupported
)
SELECT
    s.LoanID,
    d.DateKey,
    st.StateKey,
    b.BusinessKey,
    ld.LoanDetailsKey,
    s.GrossApproval,
    s.SBAGuaranteedApproval,
    s.InitialInterestRate,
    s.TermInMonths,
    s.GrossChargeOffAmount,
    s.JobsSupported
FROM sba_loan_data AS s
LEFT JOIN dim_approval_date AS d
    ON d.ApprovalDateText = s.ApprovalDate
   AND d.ApprovalFY = s.ApprovalFY
LEFT JOIN dim_state AS st
    ON st.ProjectState = s.ProjectState
LEFT JOIN dim_business AS b
    ON b.BusinessType <=> s.BusinessType
   AND b.BusinessAge <=> s.BusinessAge
   AND b.NaicsDescription <=> s.NaicsDescription
LEFT JOIN dim_loan_details AS ld
    ON ld.ProcessingMethod <=> s.ProcessingMethod
   AND ld.LoanStatus <=> s.LoanStatus
   AND ld.FixedorVariableInterestInd <=> s.FixedorVariableInterestInd
   AND ld.RevolverStatus <=> s.RevolverStatus;
   
   SELECT COUNT(*) AS FactRows
FROM fact_sba_loan;

SELECT
    COUNT(*) AS TotalLoans,
    SUM(DateKey IS NULL) AS MissingDateKey,
    SUM(StateKey IS NULL) AS MissingStateKey,
    SUM(BusinessKey IS NULL) AS MissingBusinessKey,
    SUM(LoanDetailsKey IS NULL) AS MissingLoanDetailsKey
FROM fact_sba_loan;

SELECT
    TABLE_NAME,
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'sba_loan_analysis'
  AND TABLE_NAME = 'fact_sba_loan'
  AND REFERENCED_TABLE_NAME IS NOT NULL;
  
  SELECT
    COUNT(*) AS TotalRows,
    COUNT(DISTINCT LoanDetailsKey) AS UniqueKeys
FROM dim_loan_details;

USE sba_loan_analysis;

SELECT 'fact_sba_loan' AS table_name, COUNT(*) AS row_count
FROM fact_sba_loan
UNION ALL
SELECT 'dim_state', COUNT(*) FROM dim_state
UNION ALL
SELECT 'dim_approval_date', COUNT(*) FROM dim_approval_date
UNION ALL
SELECT 'dim_business', COUNT(*) FROM dim_business
UNION ALL
SELECT 'dim_loan_details', COUNT(*) FROM dim_loan_details;

SELECT
    TABLE_NAME,
    COLUMN_NAME,
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'sba_loan_analysis'
  AND TABLE_NAME = 'fact_sba_loan'
  AND REFERENCED_TABLE_NAME IS NOT NULL
ORDER BY TABLE_NAME, COLUMN_NAME;

SELECT
    COUNT(*) AS TotalLoans,
    SUM(CASE WHEN d.DateKey IS NULL THEN 1 ELSE 0 END) AS MissingDateKey,
    SUM(CASE WHEN s.StateKey IS NULL THEN 1 ELSE 0 END) AS MissingStateKey,
    SUM(CASE WHEN b.BusinessKey IS NULL THEN 1 ELSE 0 END) AS MissingBusinessKey,
    SUM(CASE WHEN l.LoanDetailsKey IS NULL THEN 1 ELSE 0 END) AS MissingLoanDetailsKey
FROM fact_sba_loan f
LEFT JOIN dim_approval_date d
    ON f.DateKey = d.DateKey
LEFT JOIN dim_state s
    ON f.StateKey = s.StateKey
LEFT JOIN dim_business b
    ON f.BusinessKey = b.BusinessKey
LEFT JOIN dim_loan_details l
    ON f.LoanDetailsKey = l.LoanDetailsKey;
    
    SHOW CREATE TABLE sba_loan_data;




   