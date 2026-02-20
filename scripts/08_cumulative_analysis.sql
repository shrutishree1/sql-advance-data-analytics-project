/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
===============================================================================
*/

-- Calculate the total sales per month and the running total of sales over time
SELECT
  order_date,
  total_Sales,
  SUM(total_Sales) OVER(ORDER BY order_date) AS running_total_Sales
FROM 
(
  SELECT
  DATETRUNC(month,order_date) AS order_date,
  SUM(sales_amount) AS total_Sales
  FROM gold.fact_sales
  WHERE order_date IS NOT NULL
  GROUP BY DATETRUNC(month,order_date)
)t


/* partition by each year */
SELECT
  order_date,
  total_Sales,
  SUM(total_Sales) OVER(PARTITION BY order_date ORDER BY order_date) AS running_total_Sales
FROM 
(
  SELECT
  DATETRUNC(month,order_date) AS order_date,
  SUM(sales_amount) AS total_Sales
  FROM gold.fact_sales
  WHERE order_date IS NOT NULL
  GROUP BY DATETRUNC(month,order_date)
)t

/* Changing the granuality to year */
SELECT
  order_date,
  total_Sales,
  SUM(total_Sales) OVER(ORDER BY order_date) AS running_total_Sales,
  AVG(avg_price) OVER(ORDER BY order_date) AS moving_avg_price
FROM 
(
  SELECT
  DATETRUNC(year,order_date) AS order_date,
  SUM(sales_amount) AS total_Sales,
  AVG(price) AS avg_price
  FROM gold.fact_sales
  WHERE order_date IS NOT NULL
  GROUP BY DATETRUNC(year,order_date)
)t
