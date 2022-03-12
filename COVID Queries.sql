/*
	Queries used in COVID Deaths based on country visualization
	This visualization is the one done by following Alex the Analyst's video
*/

--1
--Total cases, total deaths, and percent of individuals who tested positive and then died (global)
SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths, SUM(CAST(new_deaths AS INT)) / SUM(new_cases) * 100 AS death_percentage
FROM Portfolio_Project_COVID..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2

--2
--Total deaths per continent
SELECT location, SUM(CAST(new_deaths AS INT)) AS total_death_count
FROM Portfolio_Project_COVID..CovidDeaths
WHERE continent IS NULL
AND location NOT IN('World', 'European Union', 'International')
AND location NOT LIKE '%income'
GROUP BY location
ORDER BY total_death_count DESC

--3
--Highest percent infected per location
SELECT location, population, MAX(total_cases) AS highest_infection_count, MAX(total_cases / population) * 100 AS percent_population_infected
FROM Portfolio_Project_COVID..CovidDeaths
WHERE continent IS NOT NULL
AND location NOT IN('World', 'European Union', 'International')
GROUP BY location, population
ORDER BY percent_population_infected DESC

--4
--Highest percented infected per location per day
SELECT location, population, date, MAX(total_cases) AS highest_infection_count, MAX(total_cases / population) * 100 AS percent_population_infected
FROM Portfolio_Project_COVID..CovidDeaths
WHERE continent IS NOT NULL
AND location NOT IN('World', 'European Union', 'International')
GROUP BY location, population, date
ORDER BY percent_population_infected DESC


/*
	Queries used in COVID stats based on income level
*/

--cases based on population
SELECT location, AVG(population) population, SUM(new_cases) AS total_cases, (SUM(new_cases) / AVG(population)) * 100 AS infection_rate
FROM Portfolio_Project_COVID..CovidDeaths
WHERE continent IS NULL
AND location LIKE('%income')
GROUP BY location
ORDER BY infection_rate DESC

--total cases, total deaths, death percentage
SELECT location, SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS INT)) AS total_death_count, SUM(CAST(new_deaths AS INT)) / SUM(new_cases) * 100 AS death_percentage
FROM Portfolio_Project_COVID..CovidDeaths
WHERE continent IS NULL
AND location LIKE('%income')
GROUP BY location
ORDER BY death_percentage DESC

--total vaccinations, percent vaccinated per income level
SELECT vax.location, AVG(death.population) population, MAX(vax.total_vaccinations) vaccinations, (MAX(vax.total_vaccinations) / AVG(death.population)) * 100 AS percent_vax
FROM Portfolio_Project_COVID..CovidVaccinations vax JOIN Portfolio_Project_COVID..CovidDeaths death
ON vax.location = death.location
WHERE vax.continent IS NULL
AND vax.location LIKE ('%income')
GROUP BY vax.location
ORDER BY percent_vax ASC
