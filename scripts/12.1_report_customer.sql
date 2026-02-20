/*
==================================================================================================
Customer Report
==================================================================================================
Puspose:
      - This report consolidates key customer metrics and behaviors.

Highlights:
      1. Gather essential fields such as names, ages and transactional details.
      2. Segement customers into categories (VIP, Regualar, New) and age groups.
      3. Aggregate customer-level metrics:
             - total orders
             - total sales
             - total quantity purchased
             - total products
             - lifespan (in months)
      4. Calculate valuable KPI's:
             - recency (month since last order)
             - average order value
             - average monthly spend
==================================================================================================
*/

CREATE VIEW gold.report_customers AS
WITH base_query AS (
/* -----------------------------------------------------------------------------------------------
1. Base Query: Retrives core columns from tables
------------------------------------------------------------------------------------------------*/
   SELECT
    f.order_number,
    f.product_key,
    f.order_date,
    f.sales_amount,
    f.quantity,
    c.customer_key,
    c.customer_number,
    CONCAT(c.first_name,' ',c.last_name) AS customer_name,
    DATEDIFF(YEAR, c.birthdate, GETDATE()) AS age
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
    WHERE order_date IS NOT NULL -- only consider valid sales date
),
customer_aggregation AS (
/* -----------------------------------------------------------------------------------------------
2. customer_aggregation: Summarizes key metrics at the customer level
------------------------------------------------------------------------------------------------*/
SELECT
    customer_key,
    customer_number,
    customer_name,
    age,
    COUNT(DISTINCT order_number) AS total_orders,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_quantity,
    COUNT(DISTINCT product_key) AS total_products,
    MAX(order_date) AS last_order_date,
    DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan
FROM base_query
GROUP BY 
    customer_key,
    customer_number,
    customer_name,
    age
)
SELECT
    customer_key,
    customer_number,
    customer_name,
    age,
    CASE
         WHEN age < 20 THEN 'Under 20' 
         WHEN age BETWEEN 20 AND 29 THEN '20-29'
         WHEN age BETWEEN 30 AND 39 THEN '30-39'
         WHEN age BETWEEN 40 AND 49 THEN '40-49'
         ELSE '50 and Above'
    END age_group,
    CASE 
         WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
         WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
         ELSE 'New'
    END customer_segment,
    last_order_date,
    DATEDIFF(month, last_order_date, GETDATE()) AS recency,
    total_orders,
    total_sales,
    total_quantity,
    -- total_products,
    lifespan,
    -- Compute average order value (AVO)
    CASE
         WHEN total_orders = 0 THEN 0
         ELSE total_sales / total_orders
    END AS avg_order_value,
/* -----------------------------------------------------------------------------------------------
3. Compute average monthly spend (avg monthly spend = total sales / nr. of months)
   Here we are using the lifespan as nr. of months.
------------------------------------------------------------------------------------------------*/
   CASE
         WHEN lifespan = 0 THEN 0
         ELSE total_sales / lifespan
   END AS avg_monthly_spend
FROM customer_aggregation;


-- Checking the view
SELECT
*
FROM gold.report_customers

/* We can do any kind of query on top of our view for dashboard or reporting */
-- Example
SELECT 
age_group,
COUNT(customer_number) AS total_customers,
SUM(total_sales) total_sales
FROM gold.report_customers
GROUP BY age_group;

SELECT 
customer_segment,
COUNT(customer_number) AS total_customers,
SUM(total_sales) total_sales
FROM gold.report_customers
GROUP BY customer_segment;
