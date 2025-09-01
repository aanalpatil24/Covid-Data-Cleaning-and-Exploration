/*
Covid 19 Data Exploration
Skills used: Joins, CTEs, Temporary Tables, Window Functions, Aggregate Functions, Views, Type Casting
*/

-- Base Data
SELECT *
FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY location, date;

-- SELECT *
-- FROM CovidVaccinations
-- ORDER BY location, date;

--------------------------------------------------
-- Basic Exploration

SELECT location, 
	   date, 
	   total_cases, 
	   new_cases, 
	   total_deaths, 
	   population
FROM CovidDeaths
ORDER BY location, date;

--------------------------------------------------
-- Looking at Total Cases vs Total Deaths

SELECT location, 
	   date, 
	   total_cases, 
	   total_deaths, 
	   (CAST(total_deaths AS DECIMAL(18,2)) / total_cases)*100 AS DeathPercentage
FROM CovidDeaths
WHERE location LIKE '%states%'
ORDER BY location, date;

--------------------------------------------------
-- Total Cases vs Population (percentage infected)

SELECT location,
	   date, 
	   population,
	   total_cases, 
	   (CAST(total_cases AS DECIMAL(18,2)) / population)*100 AS PercentagePopulationEffected
FROM CovidDeaths
WHERE location LIKE '%states%'
ORDER BY location, date;

--------------------------------------------------
-- Countries with Highest Infection Rate compared to Population

SELECT location, 
	   population, 
	   MAX(total_cases) AS HighestInfectionCount, 
	   (MAX(total_cases) / population)*100 AS PercentagePopulationEffected
FROM CovidDeaths
GROUP BY location, population
ORDER BY PercentagePopulationEffected DESC;

--------------------------------------------------
-- Countries with Highest Death Count

SELECT location, 
	   MAX(CAST(total_deaths AS UNSIGNED)) AS TotalDeathCount
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC;

--------------------------------------------------
-- Continent / Group Death Counts

SELECT location, 
       MAX(CAST(total_deaths AS UNSIGNED)) AS TotalDeathCount
FROM CovidDeaths
WHERE continent IS NULL
GROUP BY location
ORDER BY TotalDeathCount DESC;

--------------------------------------------------
-- Global Numbers

SELECT SUM(new_cases) AS total_cases, 
       SUM(CAST(new_deaths AS UNSIGNED)) AS total_deaths, 
	   (SUM(CAST(new_deaths AS UNSIGNED)) / SUM(new_cases))*100 AS DeathPercentage
FROM CovidDeaths
WHERE continent IS NOT NULL;

--------------------------------------------------
-- Rolling Vaccinations (using CTE)

WITH PopvsVac AS (
SELECT dea.continent, 
	   dea.location, 
	   dea.date, 
	   dea.population, 
	   vac.new_vaccinations,
	   SUM(CAST(vac.new_vaccinations AS UNSIGNED)) 
			OVER (PARTITION BY dea.location 
			ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM CovidDeaths dea
JOIN CovidVaccinations vac
	 ON dea.location = vac.location
	 AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
)
SELECT *, (RollingPeopleVaccinated/Population)*100 AS PctPeopleVaccinated
FROM PopvsVac;

--------------------------------------------------
-- Using a Temporary Table for Rolling Vaccinations

CREATE TEMPORARY TABLE PercentPeopleVaccinatedTemp
(
	Continent VARCHAR(255), 
	Location VARCHAR(255), 
	Date DATE, 
	Population BIGINT, 
	New_Vaccinations BIGINT, 
	RollingPeopleVaccinated BIGINT
);

INSERT INTO PercentPeopleVaccinatedTemp
SELECT dea.continent, 
	   dea.location, 
	   dea.date, 
	   dea.population, 
	   vac.new_vaccinations,
	   SUM(CAST(vac.new_vaccinations AS UNSIGNED)) 
			OVER (PARTITION BY dea.location 
			ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM CovidDeaths dea
JOIN CovidVaccinations vac
	 ON dea.location = vac.location
	 AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;

SELECT *, (RollingPeopleVaccinated/Population)*100 AS PctPeopleVaccinated
FROM PercentPeopleVaccinatedTemp;

--------------------------------------------------
-- Creating Views for later use

CREATE OR REPLACE VIEW PercentPeopleVaccinated AS
SELECT dea.continent, 
	   dea.location, 
	   dea.date, 
	   dea.population, 
	   vac.new_vaccinations,
	   SUM(CAST(vac.new_vaccinations AS UNSIGNED)) 
			OVER (PARTITION BY dea.location 
			ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM CovidDeaths dea
JOIN CovidVaccinations vac
	 ON dea.location = vac.location
	 AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;

SELECT *
FROM PercentPeopleVaccinated
ORDER BY location, date;

--------------------------------------------------
-- View for Country Deaths

CREATE OR REPLACE VIEW CountryDeaths AS
SELECT location, 
	   MAX(CAST(total_deaths AS UNSIGNED)) AS TotalDeathCount
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location;

SELECT *
FROM CountryDeaths
ORDER BY TotalDeathCount DESC;

--------------------------------------------------
-- View for Continent Deaths

CREATE OR REPLACE VIEW ContinentDeaths AS
SELECT location, 
       MAX(CAST(total_deaths AS UNSIGNED)) AS TotalDeathCount
FROM CovidDeaths
WHERE continent IS NULL
GROUP BY location;

SELECT * 
FROM ContinentDeaths
ORDER BY TotalDeathCount DESC;
