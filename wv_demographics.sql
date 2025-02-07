--Compares the pecent increase median income in WV counties from 2010 to 2022 
SELECT wv.county, 
wv.median_income AS median_income_2022, 
wva.median_income AS median_income_2010,
ROUND((wv.median_income - wva.median_income)/wva.median_income * 100, 1) AS percent_increase
FROM wv_demographics AS wv
LEFT JOIN wv_income2010 AS wva
ON wv.county_id = wva.county_id
ORDER BY percent_increase DESC;
