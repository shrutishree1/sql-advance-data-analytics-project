/*
===============================================================================
Database Exploration
===============================================================================
Purpose:
    - To explore the structure of the database, including the list of tables and their schemas.
    - To inspect the columns and metadata for specific tables.

Table Used:
    - INFORMATION_SCHEMA.TABLES
    - INFORMATION_SCHEMA.COLUMNS
===============================================================================
*/

-- EXPLORE ALL OBJECTS IN THE DATABASE
SELECT 
* 
FROM INFORMATION_SCHEMA.TABLES

-- EXPLORE ALL COLUMNS IN THE DATABASE
SELECT 
* 
FROM INFORMATION_SCHEMA.COLUMNS

-- EXPLORE ALL COLUMNS IN A SPECIFIC TABLE (dim_customers)
SELECT 
* 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers'
