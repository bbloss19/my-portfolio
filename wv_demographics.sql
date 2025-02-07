--Returns the correlation coefficient between the poverty rate and life expectancy for each state
SELECT state,
(COUNT(*) * SUM(poverty_rate * life_expectancy) - SUM(poverty_rate) * SUM(life_expectancy)) /
    (SQRT(COUNT(*) * SUM(POWER(poverty_rate, 2)) - POWER(SUM(poverty_rate), 2)) *
     SQRT(COUNT(*) * SUM(POWER(life_expectancy, 2)) - POWER(SUM(life_expectancy), 2)))
    AS correlation_coefficient
FROM pennsylvania
GROUP BY state
UNION
SELECT state,
(COUNT(*) * SUM(poverty_rate * life_expectancy) - SUM(poverty_rate) * SUM(life_expectancy)) /
    (SQRT(COUNT(*) * SUM(POWER(poverty_rate, 2)) - POWER(SUM(poverty_rate), 2)) *
     SQRT(COUNT(*) * SUM(POWER(life_expectancy, 2)) - POWER(SUM(life_expectancy), 2)))
    AS correlation_coefficient
FROM wv_demographics
GROUP BY state
UNION
SELECT state,
(COUNT(*) * SUM(poverty_rate * life_expectancy) - SUM(poverty_rate) * SUM(life_expectancy)) /
    (SQRT(COUNT(*) * SUM(POWER(poverty_rate, 2)) - POWER(SUM(poverty_rate), 2)) *
     SQRT(COUNT(*) * SUM(POWER(life_expectancy, 2)) - POWER(SUM(life_expectancy), 2)))
    AS correlation_coefficient
FROM maryland
GROUP BY state
ORDER BY correlation_coefficient;


--Classifies each regions poverty rate as either ‘poor’, ‘borderline poor’, or ‘not poor’ based on average poverty rate in descending order.
SELECT DISTINCT region, state, ROUND(AVG(poverty_rate), 1) AS avg_poverty_rate,
CASE
	WHEN AVG(poverty_rate) > 15 THEN 'Poor'
	WHEN AVG(poverty_rate) < 12 THEN 'Not poor'
	ELSE 'Borderline poor'
END AS 'classification'
FROM pennsylvania
GROUP BY state, region
UNION ALL
SELECT DISTINCT region, state, ROUND(AVG(poverty_rate), 1) AS avg_poverty_rate,
CASE
	WHEN AVG(poverty_rate) > 15 THEN 'Poor'
	WHEN AVG(poverty_rate) < 12 THEN 'Not poor'
	ELSE 'Borderline poor'
END AS 'classification'
FROM wv_demographics
GROUP BY state, region
UNION ALL
SELECT DISTINCT region, state, ROUND(AVG(poverty_rate), 1) AS avg_poverty_rate,
CASE
	WHEN AVG(poverty_rate) > 15 THEN 'Poor'
	WHEN AVG(poverty_rate) < 12 THEN 'Not poor'
	ELSE 'Borderline poor'
END AS 'classification'
FROM maryland
GROUP BY state, region
ORDER BY avg_poverty_rate DESC;

--Takes average income from each region in PA, WV, and MD, and then classifies it as either wealthy, average, or poor.
SELECT DISTINCT region, state, ROUND(AVG(median_income), 0) AS avg_income,
CASE
	WHEN AVG(median_income) > 90000 THEN 'Wealthy'
	WHEN AVG(median_income) < 60000 THEN 'poor'
	ELSE 'Average'
END AS 'classification'
FROM pennsylvania
GROUP BY state, region
UNION ALL
SELECT DISTINCT region, state, ROUND(AVG(median_income), 0) AS avg_income,
CASE
	WHEN AVG(median_income) > 90000 THEN 'Wealthy'
	WHEN AVG(median_income) < 60000 THEN 'poor'
	ELSE 'Average'
END AS 'classification'
FROM wv_demographics
GROUP BY state, region
UNION ALL
SELECT DISTINCT region, state, ROUND(AVG(median_income), 0) AS avg_income,
CASE
	WHEN AVG(median_income) > 90000 THEN 'Wealthy'
	WHEN AVG(median_income) < 60000 THEN 'poor'
	ELSE 'Average'
END AS 'classification'
FROM maryland
GROUP BY state, region
ORDER BY avg_income DESC;

--Compares the pecent increase median income in WV counties from 2010 to 2022 
SELECT wv.county, 
wv.median_income AS median_income_2022, 
wva.median_income AS median_income_2010,
ROUND((wv.median_income - wva.median_income)/wva.median_income * 100, 1) AS percent_increase
FROM wv_demographics AS wv
LEFT JOIN wv_income2010 AS wva
ON wv.county_id = wva.county_id
ORDER BY percent_increase DESC;
