-- Duplicate layoffs_staging table
CREATE TABLE [dbo].[layoffs_staging2](
	[company] [nvarchar](50) NOT NULL,
	[location] [nvarchar](50) NOT NULL,
	[industry] [nvarchar](50) NULL,
	[total_laid_off] [smallint] NULL,
	[percentage_laid_off] [float] NULL,
	[date] [date] NULL,
	[stage] [nvarchar](50) NOT NULL,
	[country] [nvarchar](50) NOT NULL,
	[funds_raised_millions] [decimal](18, 10) NULL,
	[row_num] [int]
) ON [PRIMARY]
GO

-- Finds duplicate rows
WITH duplicate_cte AS (
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, [date]
ORDER BY (SELECT NULL)
	) AS row_num
FROM layoffs_staging2
)
SELECT*
FROM duplicate_cte
WHERE row_num > 1;

-- Delete duplicate rows
DELETE
FROM layoffs_staging2
WHERE row_num > 1;


-- Remove blank space from company column
SELECT company, TRIM(company)
FROM layoffs_staging2

UPDATE layoffs_staging2
SET company = TRIM(company)


-- Normalize values in industry = ‘crypto%’
SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%'

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%'



-- Remove trailing period from ‘United States’
SELECT DISTINCT(country), TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%'


# UPDATE NULL values under industry
SELECT *
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
	AND t1.location = t2.location
WHERE (t1.industry is NULL or t1.industry = ' ')
AND t2.industry is NOT NULL

UPDATE t1
SET t1.industry = t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
	AND t1.location = t2.location
WHERE (t1.industry is NULL or t1.industry = ' ')
AND t2.industry is NOT NULL






