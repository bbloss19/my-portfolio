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
