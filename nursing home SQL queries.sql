--Sets proper capitalization to all values for a specified column
UPDATE t
SET Location = ca.ProperCaseValue
FROM Nursing_home1 t
CROSS APPLY (
    SELECT STRING_AGG(
             UPPER(LEFT(value,1)) + LOWER(SUBSTRING(value,2,100)),
             ' '
           ) WITHIN GROUP (ORDER BY ordinal) AS ProperCaseValue
    FROM STRING_SPLIT(t.Location, ' ', 1)
) ca;

--Finds and deletes duplicate rows
WITH Duplicate_cte AS (
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY CMS_Certification_Number, Provider_Name, Provider_Address
ORDER BY (SELECT NULL)
	) AS row_num
FROM Nursing_home1
)
DELETE 
FROM duplicate_cte
WHERE row_num > 1;

--Set all values for date columns to 'yyyy-mm-dd'
ALTER TABLE Nursing_home1
ALTER COLUMN Processing_Date DATE;

--Query used to detect outliers in dataset
SELECT CMS_Certification_Number, Number_of_Certified_beds,
(Number_of_Certified_Beds - AVG(Number_of_Certified_Beds) OVER())/STDEV(Number_of_Certified_Beds) OVER() AS zscore
FROM Nursing_home
ORDER BY zscore DESC

--Find the sum of nursing homes for each rating category
SELECT Overall_Rating, COUNT(*) AS number_of_providers
FROM Nursing_home1
WHERE Overall_Rating IS NOT NULL
GROUP BY Overall_Rating
ORDER BY Overall_Rating DESC;

--Find the average nursing staff hours per nursing homes by ownership type
SELECT Ownership_Type, AVG(Reported_Total_Nurse_Staffing_Hours_per_Resident_per_Day) AS avg_nurse_staff_hours_per_resident
FROM Nursing_home1
GROUP BY Ownership_Type
ORDER BY avg_nurse_staff_hours_per_resident;

-- Which states have the highest and lowest average registered nurse hours per resident per day?
SELECT State, 
 CAST(
        AVG(Reported_RN_Staffing_Hours_per_Resident_per_Day) 
        AS DECIMAL(10,2)
	) AS RN_staffing_hours_per_resident
FROM Nursing_home1
WHERE Reported_RN_Staffing_Hours_per_Resident_per_Day IS NOT NULL
GROUP BY State
ORDER BY RN_staffing_hours_per_resident

--Which nursing homes have the most deficiencies?
WITH Avg_num_deficiencies AS (
SELECT Provider_Name,
City,
State,
Rating_Cycle_1_Total_Number_of_Health_Deficiencies
 + Rating_Cycle_2_3_Total_Number_of_Health_Deficiencies
 AS Total_num_deficiencies
FROM Nursing_home1
)
SELECT Provider_Name, Total_num_deficiencies, City, State
FROM Avg_num_deficiencies
ORDER BY Total_num_deficiencies DESC;

--How does ownership type affect overall ratings and staffing?
SELECT DISTINCT(Ownership_Type), 
CAST(
AVG(Overall_Rating) AS DECIMAL(10,2)) AS Avg_Overall_rating,
CAST(
AVG(Reported_Total_Nurse_Staffing_Hours_per_Resident_per_Day) AS DECIMAL(10,2)) AS Avg_nurse_staffing_per_res_per_day
FROM Nursing_home1
WHERE Overall_Rating IS NOT NULL
AND Reported_Total_Nurse_Staffing_Hours_per_Resident_per_Day IS NOT NULL
GROUP BY Ownership_Type
ORDER BY Avg_nurse_staffing_per_res_per_day DESC;

--States that have the highest ratio of deficiencies (avg number of deficiencies per nursing home)
SELECT DISTINCT State, 
SUM(Rating_Cycle_1_Total_Number_of_Health_Deficiencies
 + Rating_Cycle_2_3_Total_Number_of_Health_Deficiencies)
 AS Total_num_deficiencies,
 COUNT(*) AS total_nursing_homes,
 CAST(
 (COUNT(*)) / SUM(Rating_Cycle_1_Total_Number_of_Health_Deficiencies
 + Rating_Cycle_2_3_Total_Number_of_Health_Deficiencies) * 100.0 AS DECIMAL(10,2)) AS deficiency_ratio
FROM Nursing_home1
GROUP BY State
ORDER BY deficiency_ratio DESC;

--Is there a relationship between average number of residents per day and total staffing hours per resident per day?
SELECT Provider_Name, City, State, Average_Number_of_Residents_per_Day, 
CAST(
SUM(Reported_Total_Nurse_Staffing_Hours_per_Resident_per_Day
+ Reported_Licensed_Staffing_Hours_per_Resident_per_Day
+ Reported_Physical_Therapist_Staffing_Hours_per_Resident_Per_Day)  AS DECIMAL(10,2)) AS total_staff_hours_per_resident
FROM Nursing_home1
WHERE Average_Number_of_Residents_per_Day IS NOT NULL
AND Reported_Total_Nurse_Staffing_Hours_per_Resident_per_Day IS NOT NULL
AND Reported_Licensed_Staffing_Hours_per_Resident_per_Day IS NOT NULL
AND Reported_Physical_Therapist_Staffing_Hours_per_Resident_Per_Day IS NOT NULL
GROUP BY Provider_Name, City, State, Average_Number_of_Residents_per_Day
ORDER BY Average_Number_of_Residents_per_Day DESC;

--The effect of total nursing staff hours per resident per day on ratings:
SELECT Provider_Name, City, State, Overall_Rating,
CAST(
SUM(Reported_Total_Nurse_Staffing_Hours_per_Resident_per_Day
+ Reported_Licensed_Staffing_Hours_per_Resident_per_Day)
  AS DECIMAL(10,2)) AS total_staff_hours_per_resident
FROM Nursing_home1
WHERE Reported_Total_Nurse_Staffing_Hours_per_Resident_per_Day IS NOT NULL
AND Reported_Licensed_Staffing_Hours_per_Resident_per_Day IS NOT NULL
GROUP BY Provider_Name, City, State, Overall_Rating
ORDER BY total_staff_hours_per_resident DESC;

--Find average number of health deficiencies for each state
SELECT State, COUNT(*) AS number_of_providers,
CAST(SUM(Rating_Cycle_1_Total_Number_of_Health_Deficiencies +
Rating_Cycle_2_3_Total_Number_of_Health_Deficiencies) / COUNT(*) AS DECIMAL(10,2)) AS avg_health_deficiencies
FROM Nursing_home1
GROUP BY State
ORDER BY avg_health_deficiencies DESC
