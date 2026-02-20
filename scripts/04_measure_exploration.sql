/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/

  -- Find the total sales.
  SELECT 
    SUM(sales_amount) AS total_sales 
  FROM gold.fact_sales;

  -- Find how many items are sold
  SELECT 
    SUM(quantity) AS total_quantity 
  FROM gold.fact_sales;

  -- Find the average selling price
  SELECT 
    avg(price) AS avg_price 
  FROM gold.fact_sales;

  -- Find the Total number of Orders
  SELECT 
    COUNT(order_number) AS total_order 
  FROM gold.fact_sales; --worng duplicate order no

  /* The customer did order multiple things in the same order so that's why to count
  the total orders we need to first fetch the distinct orders and then count them. */
  SELECT 
    COUNT(DISTINCT order_number) AS total_order; 
  FROM gold.fact_sales;

  -- Find the Total number of Products
  SELECT 
    COUNT(product_name) AS total_products 
  FROM gold.dim_products;

  SELECT 
    COUNT(DISTINCT product_name) AS total_products 
  FROM gold.dim_products;

  -- Find the Total number of Customers
  SELECT 
    COUNT(customer_key) AS total_products 
  FROM gold.dim_customers;

  -- Find the total number of customers that has placed an order
  SELECT 
    COUNT(DISTINCT customer_key) AS total_products 
  FROM gold.fact_sales;

  /* Verifing --- 
  SELECT COUNT(customer_key) AS total_products FROM gold.dim_customers ; 
  SELECT COUNT(DISTINCT customer_key) AS total_products FROM gold.fact_sales ;
  The output is same for these so it means all our registered customers did placed an order */

  
  -- Generate a report that shows all key metrics of the business

  SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
  UNION ALL
  SELECT 'Total Quantity', SUM(quantity) FROM gold.fact_sales
  UNION ALL
  SELECT 'Average Price', AVG(price) FROM gold.fact_sales
  UNION ALL
  SELECT 'Total Nr Orders', COUNT(DISTINCT order_number) FROM gold.fact_sales
  UNION ALL
  SELECT 'Total Nr Products', COUNT(product_name) FROM gold.dim_products
  UNION ALL
  SELECT 'Total Nr Customers', COUNT(customer_key) FROM gold.dim_customers
