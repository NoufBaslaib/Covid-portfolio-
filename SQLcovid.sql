SELECT *
FROM PortfolioProject..CovidDeaths


SELECT *
FROM PortfolioProject..CovidVaccinations

SELECT location, date, total_cases, total_deaths, (total_deaths/ total_cases)*100 AS DeathsPercentage, population
FROM PortfolioProject..CovidDeaths
--WHERE location LIKE 'Saudi%'
ORDER BY 1,2

--ALTER TABLE PortfolioProject..CovidDeaths
--ALTER COLUMN total_cases float

SELECT location, date, population, total_cases, (total_cases/ population)*100 AS PopulationPercentage
FROM PortfolioProject..CovidDeaths
WHERE location LIKE 'Saudi%'
ORDER BY 1,2

--DELETE FROM PortfolioProject..CovidDeaths
--WHERE total_cases is null and total_deaths is null

SELECT location, population, MAX(total_cases) AS HighiestTotalCases, MAX((total_cases/ population)*100) AS PrecentageofPopulationInfectrd
FROM PortfolioProject..CovidDeaths
GROUP BY location, population
ORDER BY PrecentageofPopulationInfectrd DESC


SELECT location, MAX(CAST(total_deaths as int)) AS HighestDeathes
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP BY location
ORDER BY HighestDeathes DESC


SELECT date, SUM(new_cases) AS TodayCases, SUM(new_deaths) AS TodayNumberofDeathes
FROM PortfolioProject..CovidDeaths
GROUP BY date


SELECT SUM(total_cases) AS TotalCases, SUM(total_deaths) AS TotalDeaths, SUM(total_deaths)/SUM(total_cases)*100 AS Deathpercentage
FROM PortfolioProject..CovidDeaths


SELECT de.continent ,de.location, de.date, de.population, vac.new_vaccianations, 
SUM(CONVERT(int, vac.new_vaccianations)) OVER (PARTITION BY de.location
ORDER BY de.location, de.date) AS RollingpeopleVaccinated
FROM PortfolioProject..CovidDeaths de
JOIN PortfolioProject..CovidVaccinations vac
	ON de.location = vac.location
	AND de.date = vac.date
WHERE de.continent is not null
ORDER BY 2,3

WITH PopulationVsVac(contienent, location, date, population, new_vaccianations, RollingpeopleVaccinated)
AS 
(SELECT de.continent ,de.location, de.date, de.population, vac.new_vaccianations, 
SUM(CONVERT(int, vac.new_vaccianations)) OVER (PARTITION BY de.location
ORDER BY de.location, de.date) AS RollingpeopleVaccinated
FROM PortfolioProject..CovidDeaths de
JOIN PortfolioProject..CovidVaccinations vac
	ON de.location = vac.location
	AND de.date = vac.date
WHERE de.continent is not null
)

SELECT (RollingpeopleVaccinated / population) * 100 
FROM PopulationVsVac