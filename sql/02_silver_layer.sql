-- =====================================================
-- Silver Layer: Cleaned view with derived business columns
-- =====================================================

-- Check MonthlyIncome range to design income_band cutoffs
SELECT MIN(MonthlyIncome), MAX(MonthlyIncome), AVG(MonthlyIncome) 
FROM bronze_hr_attrition;

-- Final Silver view definition
-- Note: ALTER VIEW replaces the entire definition, so all derived 
-- columns are included together, built up incrementally in earlier drafts.
CREATE OR REPLACE VIEW silver_hr_attrition AS
SELECT 
    *,
    -- Numeric flag for DAX/aggregation (Attrition text kept for display/filtering)
    CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END AS attrition_status,

    -- Business-defined tenure bins: 0-3 New, 4-8 Mid, 9+ Senior
    CASE 
        WHEN YearsAtCompany BETWEEN 0 AND 3 THEN 'New'
        WHEN YearsAtCompany BETWEEN 4 AND 8 THEN 'Mid'
        ELSE 'Senior'
    END AS tenure_band,

    -- Business-defined income bins: Low <=6000, Medium 6001-12000, High >=12001
    CASE 
        WHEN MonthlyIncome <= 6000 THEN 'Low'
        WHEN MonthlyIncome BETWEEN 6001 AND 12000 THEN 'Medium'
        ELSE 'High'
    END AS income_band

FROM bronze_hr_attrition;

-- Verify all three derived columns
SELECT Attrition, attrition_status, YearsAtCompany, tenure_band, MonthlyIncome, income_band 
FROM silver_hr_attrition 
LIMIT 10;