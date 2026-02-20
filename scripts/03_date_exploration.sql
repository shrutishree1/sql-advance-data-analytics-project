/*
===============================================================================
Date Range Exploration 
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.

SQL Functions Used:
    - MIN(), MAX(), DATEDIFF()
===============================================================================
*/

-- Find the date of the first and last order and how many years & months of sales are available.
SELECT
    MIN(order_date) first_order_date,
    MAX(order_date) last_order_date,
    DATEDIFF(YEAR, MIN(order_date), MAX(order_date)) Order_range_years,
    DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) Order_range_month
FROM gold.fact_sales

-- Find the youngest and oldest customers based on their birthdate.
SELECT
    MIN(birthdate) oldest_birthdate,
    DATEDIFF(YEAR, MIN(birthdate), GETDATE()) oldest_age,
    MAX(birthdate) youngest_birthdate,
    DATEDIFF(YEAR, MAX(birthdate), GETDATE()) youngest_age
FROM gold.dim_customers
