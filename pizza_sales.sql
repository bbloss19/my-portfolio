-- Find total revenue
SELECT SUM(CAST(total_price AS DECIMAL(18,2))) AS total_revenue
FROM pizza_sales;

-- Find average order value
SELECT SUM(total_price) / COUNT(DISTINCT order_id) AS average_order_value
FROM pizza_sales;

-- Find total quantity of pizza sold
SELECT SUM(quantity) AS total_pizza_sold
FROM pizza_sales;

-- Find total number of orders placed
SELECT COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales;

-- Find average quantity per order
SELECT CAST(SUM(CAST(quantity AS INT)) AS DECIMAL(10,2)) /
CAST(COUNT(DISTINCT order_id) AS DECIMAL(10,2)) AS avg_quantity_per_order
FROM pizza_sales;

-- Find total orders placed for each day
SELECT DATENAME(WEEKDAY, TRY_CONVERT(date, order_date, 105)) AS order_day, 
COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY DATENAME(WEEKDAY, TRY_CONVERT(date, order_date, 105)), 
DATEPART(WEEKDAY, TRY_CONVERT(date, order_date, 105))
ORDER BY DATEPART(WEEKDAY, TRY_CONVERT(date, order_date, 105))

-- Find total number of orders for each month and rank them by total orders in descending order
SELECT DATENAME(MONTH, TRY_CONVERT(date, order_date, 105)) AS month_name, 
COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY DATENAME(MONTH, TRY_CONVERT(date, order_date, 105)), 
DATEPART(MONTH, TRY_CONVERT(date, order_date, 105))
ORDER BY total_orders DESC;

-- Find total sales and percent of total sales by pizza category
SELECT pizza_category, 
CAST(sum(total_price) as DECIMAL(10,2)) AS Total_Sales, 
CAST(sum(total_price) * 100 / (SELECT sum(total_price) from pizza_sales) AS DECIMAL(10,2)) AS PCT_total_sales
FROM pizza_sales
GROUP BY pizza_category
ORDER BY Total_Sales DESC;

-- Find total sales and percent of total sales by pizza size category
-- Order by total sales in descending order
SELECT pizza_size, 
CAST(sum(total_price) as DECIMAL(10,2)) AS Total_Sales, 
CAST(sum(total_price) * 100 / (SELECT sum(total_price) from pizza_sales) AS DECIMAL(10,2)) AS PCT_total_sales
FROM pizza_sales
GROUP BY pizza_size
ORDER BY Total_Sales DESC;

-- Find top 5 pizza categories by revenue
SELECT TOP 5 pizza_name, CAST(SUM(total_price) AS DECIMAL (10,2)) AS revenue_per_pizza
FROM pizza_sales
GROUP BY pizza_name
ORDER BY revenue_per_pizza DESC;

-- Find bottom 5 pizza categories by revenue
SELECT TOP 5 pizza_name, CAST(SUM(total_price) AS DECIMAL (10,2)) AS revenue_per_pizza
FROM pizza_sales
GROUP BY pizza_name
ORDER BY revenue_per_pizza;

-- Find top 5 pizza categories by total quantity sold
SELECT TOP 5 pizza_name, SUM(quantity)  AS quantity_sold
FROM pizza_sales
GROUP BY pizza_name
ORDER BY quantity_sold DESC;

-- Find bottom 5 pizza categories by total quantity sold
SELECT TOP 5 pizza_name, SUM(quantity) AS quantity_sold
FROM pizza_sales
GROUP BY pizza_name
ORDER BY quantity_sold;
