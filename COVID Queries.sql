/*
	Queries used in COVID Deaths based on regions visualization
	These queries and their corresponding visualizations were completed by following Alex the Analyst's video (https://www.youtube.com/watch?v=QILNlRvJlfQ)
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



---------- Planned Visualizations ----------


/*
	Queries used in COVID Deaths based on income visualization
*/

--Total cases, total deaths, and percent of individuals who tested positive and then died (income level)
SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths, SUM(CAST(new_deaths AS INT)) / SUM(new_cases) * 100 AS death_percentage
FROM Portfolio_Project_COVID..CovidDeaths
WHERE continent IS NULL
AND location LIKE('%income')
ORDER BY 1, 2

--Total deaths per income level
SELECT location, SUM(CAST(new_deaths AS INT)) AS total_death_count
FROM Portfolio_Project_COVID..CovidDeaths
WHERE continent IS NULL
AND location LIKE('%income')
GROUP BY location
ORDER BY total_death_count DESC

--Highest percent infected per income level
SELECT location, population, MAX(total_cases) AS highest_infection_count, MAX(total_cases / population) * 100 AS percent_population_infected
FROM Portfolio_Project_COVID..CovidDeaths
WHERE continent IS NULL
AND location LIKE('%income')
GROUP BY location, population
ORDER BY percent_population_infected DESC


/*
	Queries used in COVID Vaccinations based on country visualization
*/


/*
	Queries used in COVID Vaccinations based on income visualization
*/
