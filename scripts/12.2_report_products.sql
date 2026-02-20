/*
==================================================================================================
Product Report
==================================================================================================
Puspose:
      - This report consolidates key product metrics and behaviors.

Highlights:
      1. Gather essential fields such as product name, category, subcategory and cost.
      2. Segement products by revenue to identify High-Performer, Mid-Range or Low-Performers.
      3. Aggregate product-level metrics:
             - total orders
             - total sales
             - total quantity sold
             - total customers (unique)
             - lifespan (in months)
      4. Calculate valuable KPI's:
             - recency (month since last sale)
             - average order revenue (AOR)
             - average monthly revenue
==================================================================================================
*/

CREATE VIEW gold.report_products AS
WITH base_query AS (
/* -----------------------------------------------------------------------------------------------
1. Base Query: Retrives core columns from fact_sales and dim_products
------------------------------------------------------------------------------------------------*/
  SELECT
    f.order_number,
    f.order_date,
    f.sales_amount,
    f.customer_key,
    f.quantity,
    p.product_key,
    p.product_name,
    p.category,
    p.subcategory,
    p.cost
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
    WHERE order_date IS NOT NULL -- only consider valid sales date
),
product_aggregations AS(
/* -----------------------------------------------------------------------------------------------
2. product_aggregations: Summarizes key metrics at the product level
------------------------------------------------------------------------------------------------*/
  SELECT
       product_key,
       product_name,
       category,
       subcategory,
       cost,
       COUNT(DISTINCT order_number) AS total_orders,
       SUM(sales_amount) AS total_sales,
       SUM(quantity) AS total_quantity,
       COUNT(DISTINCT customer_key) AS total_customers,
       MAX(order_date) AS last_sale_date,
       DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan,
       ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity,0)), 1) AS avg_selling_price
FROM base_query
GROUP BY 
    product_key,
    product_name,
    category,
    subcategory,
    cost
)
/* -----------------------------------------------------------------------------------------------
3. Final Query: Combine all product results into one output
------------------------------------------------------------------------------------------------*/
SELECT
    product_key,
    product_name,
    category,
    subcategory,
    cost,
    last_sale_date,
    DATEDIFF(month, last_sale_date, GETDATE()) AS recency_in_months,
    CASE
        WHEN total_sales > 50000 THEN 'High-Performer'
        WHEN total_sales > 10000 THEN 'Mid-Range'
        ELSE 'Low-Performer'
    END AS product_segments,
    lifespan,
    total_orders,
    total_sales,
    total_quantity,
    total_customers,
    avg_selling_price,
    -- Average order revenue (AOR)
    CASE
         WHEN total_orders = 0 THEN 0
         ELSE total_sales / total_orders
    END AS avg_order_revenue,
    -- Average monthly revenue
    CASE
         WHEN lifespan = 0 THEN total_sales
         ELSE total_sales / lifespan
   END AS avg_monthly_revenue
FROM product_aggregations;

-- Checking the view
SELECT
*
FROM gold.report_products;
