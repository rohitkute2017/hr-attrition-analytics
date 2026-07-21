-- =====================================================
-- Bronze Layer Setup & Verification
-- Note: bronze_hr_attrition table itself was created and loaded 
-- via pandas (df.to_sql()) in the Python notebook, not via SQL.
-- This file sets up the database and verifies the load landed correctly.
-- =====================================================

-- Create the project database
CREATE DATABASE hr_attrition;
SHOW DATABASES;

USE hr_attrition;
SHOW TABLES;

-- Inspect auto-generated schema from pandas to_sql()
DESCRIBE bronze_hr_attrition;

-- Verify row count and preview data
SELECT COUNT(*) FROM bronze_hr_attrition;
SELECT * FROM bronze_hr_attrition;