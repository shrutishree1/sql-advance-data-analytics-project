/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - To explore the structure of dimension tables.
	
SQL Functions Used:
    - DISTINCT
    - ORDER BY
===============================================================================
*/

-- Explore the list of unique countries our customers come from
SELECT 
DISTINCT country 
FROM gold.dim_customers

-- Explore all categories "The major division": list of unique categories, subcategories, and products
SELECT 
DISTINCT 
  category, 
  subcategory,
  product_name 
FROM gold.dim_products
ORDER BY 1,2,3
