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

