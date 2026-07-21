-- =====================================================
-- Analysis Queries: Attrition Rate by Department
-- =====================================================

-- Query 1: Attrition rate per department, ranked using a window function (RANK)
SELECT 
    department,
    attrition_rate,
    RANK() OVER (ORDER BY attrition_rate DESC) AS attrition_rank
FROM (
    SELECT 
        dd.Department AS department,
        (SUM(attrition_status) / COUNT(*)) * 100 AS attrition_rate
    FROM fact_attrition fa
    JOIN dim_department dd 
        ON dd.department_key = fa.department_key
    GROUP BY dd.Department
) AS attrition_table;


-- Query 2: Departments with attrition rate above the company-wide average
-- Uses two CTEs: one for company-wide rate, one for department-level rates
WITH company_attrition AS (
    SELECT 
        (SUM(attrition_status) / COUNT(*)) * 100 AS avg_company_attrition
    FROM fact_attrition
),
dept_attrition AS (
    SELECT 
        department,
        attrition_rate,
        RANK() OVER (ORDER BY attrition_rate DESC) AS attrition_rank
    FROM (
        SELECT 
            dd.Department AS department,
            (SUM(attrition_status) / COUNT(*)) * 100 AS attrition_rate
        FROM fact_attrition fa
        JOIN dim_department dd 
            ON dd.department_key = fa.department_key
        GROUP BY dd.Department
    ) AS attrition_table
)
SELECT * 
FROM dept_attrition
WHERE attrition_rate > (SELECT avg_company_attrition FROM company_attrition);