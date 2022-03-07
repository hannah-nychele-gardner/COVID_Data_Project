--SELECT *
--FROM Portfolio_Project_COVID..CovidDeaths
--WHERE continent IS NOT NULL
--ORDER BY 3, 4

--SELECT *
--FROM Portfolio_Project_COVID..CovidVaccinations
--ORDER BY 3, 4

--SELECT location, date, total_cases, new_cases, total_deaths, population
--FROM Portfolio_Project_COVID..CovidDeaths
--ORDER BY 1, 2

--Total cases vs total deaths in the US (likelihood of individuals to die if they contract COVID)
SELECT location, date, total_cases, total_deaths, (total_deaths / total_cases)*100 AS DeathPercentage
FROM Portfolio_Project_COVID..CovidDeaths
WHERE location LIKE '%states%'
ORDER BY 1, 2

--Total cases vs population in the US
SELECT location, date, population, total_cases, (total_cases / population)*100 AS ContractionPercentage
FROM Portfolio_Project_COVID..CovidDeaths
WHERE location LIKE '%states%'
ORDER BY 1, 2

-- Countries with the highest infection rate compared to their population
SELECT location, population, MAX(total_cases) AS HighestInfectionCount, (MAX(total_cases) / population)*100 AS ContractionPercentage
FROM Portfolio_Project_COVID..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY ContractionPercentage DESC

--Countries with highest death count
SELECT location, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM Portfolio_Project_COVID..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC

--Continents with highest death count (accurate version)
SELECT location, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM Portfolio_Project_COVID..CovidDeaths
WHERE continent IS NULL
AND location NOT LIKE '%income%'
AND location NOT LIKE '%world%'
AND location NOT LIKE '%union%'
AND location NOT LIKE '%international%'
GROUP BY location
ORDER BY TotalDeathCount DESC

--Continents with highest death count (inaccurate version -- use this for purposes of Tableau drill down for the time being, see video 1 at 35 min for more info)
SELECT continent, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM Portfolio_Project_COVID..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC

--Total cases, deaths, and percentage of deaths globally
SELECT --date,
SUM(new_cases) AS RunningTotalCases, SUM(CAST(new_deaths AS INT)) AS RunningTotalDeaths, SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS DeathPercentage
FROM Portfolio_Project_COVID..CovidDeaths
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1, 2


--Global population vs vaccinations


-- Using CTE
WITH PopulationVsVaccination (Continent, Location, Date, Population, New_Vaccinations, RollingVaccinationNum)
AS
(
SELECT death.continent, death.location, death.date, death.population, vax.new_vaccinations
, SUM(CAST(vax.new_vaccinations AS BIGINT)) OVER (PARTITION BY death.location ORDER BY death.location, death.date) AS RollingVaccinationNum
FROM Portfolio_Project_COVID..CovidDeaths death
JOIN Portfolio_Project_COVID..CovidVaccinations vax
ON death.location = vax.location
AND death.date = vax.date
WHERE death.continent IS NOT NULL
)
SELECT *, (RollingVaccinationNum/Population) * 100
FROM PopulationVsVaccination



--Using Temp Table
DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingVaccinationNum numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT death.continent, death.location, death.date, death.population, vax.new_vaccinations
, SUM(CAST(vax.new_vaccinations AS BIGINT)) OVER (PARTITION BY death.location ORDER BY death.location, death.date) AS RollingVaccinationNum
FROM Portfolio_Project_COVID..CovidDeaths death
JOIN Portfolio_Project_COVID..CovidVaccinations vax
ON death.location = vax.location
AND death.date = vax.date
WHERE death.continent IS NOT NULL

SELECT *, (RollingVaccinationNum/Population) * 100
FROM #PercentPopulationVaccinated

-- View to store global percent population vaccinated
CREATE VIEW PercentPopulationVaccinated AS
SELECT death.continent, death.location, death.date, death.population, vax.new_vaccinations
, SUM(CAST(vax.new_vaccinations AS BIGINT)) OVER (PARTITION BY death.location ORDER BY death.location, death.date) AS RollingVaccinationNum
FROM Portfolio_Project_COVID..CovidDeaths death
JOIN Portfolio_Project_COVID..CovidVaccinations vax
ON death.location = vax.location
AND death.date = vax.date
WHERE death.continent IS NOT NULL

--View to store total deaths by continent (accurate version)
CREATE VIEW TotalDeathsByContinent_Accurate AS
SELECT location, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM Portfolio_Project_COVID..CovidDeaths
WHERE continent IS NULL
AND location NOT LIKE '%income%'
AND location NOT LIKE '%world%'
AND location NOT LIKE '%union%'
AND location NOT LIKE '%international%'
GROUP BY location

--View to store total deaths by continent (inaccurate version)
CREATE VIEW TotalDeathsByContinent_Inaccurate AS
SELECT continent, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM Portfolio_Project_COVID..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent