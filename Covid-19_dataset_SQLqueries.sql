-- Find the Covid-19 death rate for each date in the U.S.
SELECT location, date,
MAX(total_cases) AS total_cases, 
MAX(total_deaths) AS total_deaths,
(MAX(total_deaths)/MAX(total_cases) * 100.0) AS death_rate
FROM CovidDeaths
WHERE location = 'United States'
GROUP BY location, date
ORDER BY 1,2

-- Find percent of U.S. population that contracts Covid-19
SELECT location,  date,
MAX(population) AS population,
MAX(total_cases) AS total_cases, 
(MAX(total_cases)/MAX(population) * 100.0) AS percent_infected
FROM CovidDeaths
WHERE location LIKE '%States%'
GROUP BY location, date
ORDER BY 1,2

-- Find country with the highest infection rate
SELECT 
DISTINCT location, 
MAX(population) AS population,
MAX(total_cases) AS total_cases, 
(MAX(total_cases)/MAX(population) * 100.0) AS percent_infected
FROM CovidDeaths
GROUP BY location
ORDER BY percent_infected DESC

-- Find countries with the highest death COUNT from Covid-19
SELECT 
DISTINCT location, 
MAX(population) AS population,
MAX(CAST(total_deaths AS int)) AS total_deaths, 
(MAX(total_deaths)/MAX(population) * 100.0) AS death_rate
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY total_deaths DESC

-- Find death count by continent
SELECT 
continent, 
SUM(CAST(new_deaths AS int)) AS total_deaths 
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY total_deaths DESC

-- Find worldwide total cases, death count, and death rate at each date
SELECT 
date, 
SUM(new_cases) AS total_cases,
SUM(CAST(new_deaths AS int)) AS total_deaths, 
SUM(CAST(new_deaths AS int))/SUM(new_cases) * 100.0 AS death_rate
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1

-- Find total population vs vaccinations at each date under country and continent
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations
FROM CovidDeaths d
JOIN CovidVaccinations v
ON d.location = v.location
AND d.date = v.date
WHERE d.continent IS NOT NULL
ORDER BY 2,3

-- Find rolling total of new vaccinations for each country
SELECT d.continent, d.location, MAX(d.date) AS date, MAX(d.population) AS population, MAX(v.new_vaccinations) AS new_vaccinations,
SUM(CAST(new_vaccinations AS int)) OVER (PARTITION BY d.location ORDER BY d.location, MAX(d.date)) AS rolling_total
FROM CovidDeaths d
JOIN CovidVaccinations v
ON d.location = v.location
AND d.date = v.date
WHERE d.continent IS NOT NULL
GROUP BY d.continent, d.location, v.new_vaccinations
ORDER BY 2,3

-- Find rolling percent total of population that is vaccinated per country
WITH populationvaccination (continent, location, date, population, new_vaccinations, rolling_total)
AS
(
SELECT d.continent, d.location, 
MAX(d.date) AS date, 
MAX(d.population) AS population, 
MAX(v.new_vaccinations) AS new_vaccinations,
SUM(CAST(new_vaccinations AS int)) OVER (PARTITION BY d.location ORDER BY d.location, MAX(d.date)) AS rolling_total
FROM CovidDeaths d
JOIN CovidVaccinations v
ON d.location = v.location
AND d.date = v.date
WHERE d.continent IS NOT NULL
GROUP BY d.continent, d.location, v.new_vaccinations
)
SELECT *, rolling_total/population * 100.0 AS percent_vaccinated
FROM populationvaccination

-- Find the effect of a countries life expectancy on death rate
SELECT d.location, MAX(d.total_cases) AS total_cases, MAX(d.total_deaths) AS total_deaths, v.life_expectancy,
(MAX(d.total_deaths)/MAX(total_cases) * 100.0) AS death_rate
FROM CovidDeaths d
JOIN CovidVaccinations v
On d.date = v.date
AND d.location = v.location
WHERE d.continent IS NOT NULL
AND v.life_expectancy IS NOT NULL
GROUP BY d.location, v.life_expectancy
ORDER BY 4 DESC






