-- Find average revenue per restaurant
SELECT ROUND(AVG(revenue), 2) AS avg_revenue
FROM restaurant_revenue

-- Find average meal price per restaurant
SELECT ROUND(AVG(Average_Meal_Price), 2) AS avg_meal_price
FROM restaurant_revenue

-- Find average marketing budget per restaurant
SELECT AVG(Marketing_Budget) AS avg_marketing_budget
FROM restaurant_revenue

-- Find average rating per restaurant
SELECT ROUND(AVG(rating), 1) AS avg_rating
FROM restaurant_revenue

-- Find average service quality score per restaurant
SELECT ROUND(AVG(Service_Quality_Score), 1) AS avg_quality_score
FROM restaurant_revenue

-- Find average revenue by seating capacity
WITH seating_capacity AS(
SELECT 
	seating_capacity, 
	Revenue,
CASE
	WHEN Seating_Capacity BETWEEN 30 AND 39 THEN '30 - 39'
	WHEN Seating_Capacity BETWEEN 40 AND 49 THEN '40 - 49'
	WHEN Seating_Capacity BETWEEN 50 AND 59 THEN '50 - 59'
	WHEN Seating_Capacity BETWEEN 60 AND 69 THEN '60 - 69'
	WHEN Seating_Capacity BETWEEN 70 AND 79 THEN '70 - 79'
	WHEN Seating_Capacity BETWEEN 80 AND 89 THEN '80 - 89'
	ELSE '90 - 100'
END AS seating_capacity_range
FROM restaurant_revenue
)
SELECT 
	seating_capacity_range, 
	ROUND(AVG(Revenue), 0) AS avg_revenue
FROM seating_capacity
GROUP BY seating_capacity_range
ORDER BY seating_capacity_range

-- Find Total Revenue and Percent of Total Revenue by Cuisine Type
SELECT Cuisine,
ROUND(SUM(Revenue), 2) as total_revenue,
ROUND(SUM(Revenue) * 100 / (SELECT SUM(Revenue) FROM restaurant_revenue), 2) AS pct_total_revenue
FROM restaurant_revenue
GROUP BY Cuisine
ORDER BY pct_total_revenue DESC

-- Find Average Revenue and percent of total revenue by Restaurant Location
SELECT Location,
ROUND(SUM(Revenue), 2) as total_revenue,
ROUND(SUM(Revenue) * 100 / (SELECT SUM(Revenue) FROM restaurant_revenue), 2) AS pct_total_revenue
FROM restaurant_revenue
GROUP BY Location
ORDER BY pct_total_revenue DESC

-- Find average rating for each cuisine Type
SELECT Cuisine, ROUND(AVG(rating), 2) AS avg_rating
FROM restaurant_revenue
GROUP BY Cuisine
ORDER by avg_rating DESC

-- Find the average meal price for each cuisine Type
SELECT Cuisine,
ROUND(AVG(Average_Meal_Price), 2) AS avg_meal_price
FROM restaurant_revenue
GROUP BY Cuisine
ORDER BY avg_meal_price DESC

-- Find the average meal price by restaurant Location
SELECT Location,
ROUND(AVG(Average_Meal_Price), 2) AS avg_meal_price
FROM restaurant_revenue
GROUP BY Location
ORDER BY avg_meal_price DESC

-- Find the most common cuisine type at each location (downtown, suburban, rural)
WITH cuisine_count AS (
	SELECT Location, Cuisine,
	Count(*) AS Cuisine_count,
	ROW_NUMBER() OVER(
		PARTITION BY Location
		ORDER BY COUNT(*) DESC
	) AS rank_number
FROM restaurant_revenue
GROUP BY Location, Cuisine
)
SELECT Location, Cuisine, cuisine_count AS restaurant_count
FROM cuisine_count
WHERE rank_number = 1;
 

