-- =====================================================
-- Gold Layer: Star Schema (dim_employee, dim_department, fact_attrition)
-- Note: no dim_date — dataset has no real calendar dates, only durations
-- =====================================================

-- dim_employee: natural key (EmployeeNumber already unique, no surrogate needed)
CREATE TABLE dim_employee (
    EmployeeNumber INT PRIMARY KEY,
    Gender VARCHAR(10),
    MaritalStatus VARCHAR(10),
    Age INT,
    Education VARCHAR(20),
    EducationField VARCHAR(20)
);

INSERT INTO dim_employee (EmployeeNumber, Gender, MaritalStatus, Age, Education, EducationField)
SELECT EmployeeNumber, Gender, MaritalStatus, Age, Education, EducationField
FROM silver_hr_attrition;

SELECT * FROM dim_employee LIMIT 5;
SELECT COUNT(*) FROM dim_employee;


-- dim_department: no natural key (Department/JobRole repeats), surrogate key added
CREATE TABLE dim_department AS 
SELECT DISTINCT Department, JobRole
FROM silver_hr_attrition;

ALTER TABLE dim_department
ADD COLUMN department_key INT AUTO_INCREMENT PRIMARY KEY FIRST;

SELECT * FROM dim_department LIMIT 10;
SELECT COUNT(*) FROM dim_department;


-- fact_attrition: measures + per-employee derived labels, FKs to both dimensions
-- EmployeeNumber serves as both PK and FK (one row per employee, no repeating time dimension)
CREATE TABLE fact_attrition (
    DailyRate INT,
    DistanceFromHome INT, 
    HourlyRate INT,
    JobLevel TINYINT,
    MonthlyRate INT,
    MonthlyIncome INT,
    NumCompaniesWorked INT,
    PercentSalaryHike INT,
    StockOptionLevel INT,
    TotalWorkingYears INT,
    YearsAtCompany INT,
    YearsInCurrentRole TINYINT,
    YearsSinceLastPromotion TINYINT,
    YearsWithCurrManager TINYINT,
    Attrition VARCHAR(20),
    attrition_status TINYINT,
    department_key INT,
    EmployeeNumber INT PRIMARY KEY,
    tenure_band VARCHAR(20),
    income_band VARCHAR(20),
    FOREIGN KEY (department_key) REFERENCES dim_department(department_key),
    FOREIGN KEY (EmployeeNumber) REFERENCES dim_employee(EmployeeNumber)
);

INSERT INTO fact_attrition (
    DailyRate, DistanceFromHome, HourlyRate, JobLevel, MonthlyRate, MonthlyIncome, 
    NumCompaniesWorked, PercentSalaryHike, StockOptionLevel, TotalWorkingYears, 
    YearsAtCompany, YearsInCurrentRole, YearsSinceLastPromotion, YearsWithCurrManager,
    Attrition, attrition_status, department_key, EmployeeNumber, tenure_band, income_band
)
SELECT 
    DailyRate, DistanceFromHome, HourlyRate, JobLevel, MonthlyRate, MonthlyIncome,
    NumCompaniesWorked, PercentSalaryHike, StockOptionLevel, TotalWorkingYears,
    YearsAtCompany, YearsInCurrentRole, YearsSinceLastPromotion, YearsWithCurrManager,
    Attrition, attrition_status, dept.department_key, EmployeeNumber, tenure_band, income_band
FROM silver_hr_attrition hr_att
JOIN dim_department dept 
    ON dept.Department = hr_att.Department AND dept.JobRole = hr_att.JobRole;

SELECT COUNT(*) FROM fact_attrition;
SELECT * FROM fact_attrition LIMIT 5;