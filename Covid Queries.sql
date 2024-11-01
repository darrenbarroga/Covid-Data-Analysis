## Checking the imported table
SELECT * FROM portfolioproject1.coviddeaths;

SELECT * FROM portfolioproject1.covidvaccinations;

## Renaming column
ALTER TABLE PortfolioProject1.CovidDeaths CHANGE COLUMN `ï»¿iso_code` iso_code TEXT;

ALTER TABLE PortfolioProject1.CovidVaccinations CHANGE COLUMN `ï»¿iso_code` iso_code TEXT;

## Changing the date column for both tables into a date data type instead of a text data type
-- For CovidDeaths Table
ALTER TABLE portfolioproject1.coviddeaths ADD COLUMN new_date DATE;
UPDATE portfolioproject1.coviddeaths
SET new_date = STR_TO_DATE(date, '%m/%d/%Y');
ALTER TABLE portfolioproject1.coviddeaths DROP COLUMN date;
ALTER TABLE portfolioproject1.coviddeaths CHANGE COLUMN new_date date DATE;

-- For CovidVaccinations Table
ALTER TABLE portfolioproject1.covidvaccinations ADD COLUMN new_date DATE;
UPDATE portfolioproject1.covidvaccinations
SET new_date = STR_TO_DATE(date, '%m/%d/%Y');
ALTER TABLE portfolioproject1.covidvaccinations DROP COLUMN date;
ALTER TABLE portfolioproject1.covidvaccinations CHANGE COLUMN new_date date DATE;

## Selecting data to use for the project
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM portfolioproject1.coviddeaths
ORDER by 1,2;

## Total Cases vs Total Deaths (Odds of dying if contracted the virus in countries during specific dates)
SELECT location, date, total_cases, new_cases, total_deaths, population, (total_deaths/total_cases)*100 AS death_percentage
FROM portfolioproject1.coviddeaths
ORDER by 1,2;

## Total Cases vs Population (Percentage of the population that is infected with the virus in countries during specific dates)
SELECT location, date, total_cases, population, (total_cases/population)*100 AS percent_infected_population
FROM portfolioproject1.coviddeaths
ORDER by 1,2;

## Ranking of Countries with highest infection rate
SELECT location, population, MAX(total_cases) AS highest_infection_count, MAX((total_cases/population)*100) AS percent_infected_population
FROM portfolioproject1.coviddeaths
GROUP BY coviddeaths.location, coviddeaths.population
ORDER by percent_infected_population desc;

## Ranking of Countries with highest death count per population
SELECT location, SUM(total_deaths) AS total_death_count
FROM portfolioproject1.coviddeaths
GROUP BY location
ORDER BY total_death_count desc;

## Ranking of Continents with highest death count per population
SELECT continent, SUM(total_deaths) AS total_death_count
FROM portfolioproject1.coviddeaths
GROUP BY continent
ORDER BY total_death_count desc;

## Sum of total of cases during specific year and month date
SELECT DATE_FORMAT(date, '%Y-%m') AS date_year_month, SUM(total_cases) AS total_cases_sum
FROM portfolioproject1.coviddeaths
GROUP BY date_year_month
ORDER BY date_year_month;

## Sum of total of deaths during specific year and month date
SELECT DATE_FORMAT(date, '%Y-%m') AS date_year_month, SUM(total_deaths) AS total_deaths_sum
FROM portfolioproject1.coviddeaths
GROUP BY date_year_month
ORDER BY date_year_month;

## ## Death percentage during specific year and month date
SELECT DATE_FORMAT(date, '%Y-%m') AS date_year_month, SUM(total_cases) AS total_cases_sum, SUM(total_deaths) AS total_deaths_sum, (SUM(total_deaths)/SUM(total_cases))*100 AS death_percentage
FROM portfolioproject1.coviddeaths
GROUP BY date_year_month
ORDER BY date_year_month;

## Trend analysis of new cases and deaths
SELECT DATE_FORMAT(date, '%Y-%m') AS date_year_month, SUM(new_cases) AS total_new_cases, SUM(new_deaths) AS total_new_deaths
FROM portfolioproject1.coviddeaths
GROUP BY date_year_month
ORDER BY date_year_month;

## Vaccination Progress Analysis
SELECT DATE_FORMAT(date, '%Y-%m') AS date_year_month, SUM(new_vaccinations) AS total_new_vaccinations, SUM(total_vaccinations) AS total_vaccinations
FROM  portfolioproject1.covidvaccinations
GROUP BY date_year_month
ORDER BY date_year_month;

## Case fatality rate by location and continent
SELECT location, SUM(total_deaths) / SUM(total_cases)*100 AS case_fatality_rate
FROM portfolioproject1.coviddeaths
GROUP BY location
ORDER BY case_fatality_rate desc;

## Vaccination Effectiveness
SELECT DATE_FORMAT(cd.date, '%Y-%m') AS date_year_month, SUM(cd.new_cases) AS total_new_cases, SUM(cv.new_vaccinations) AS total_new_vaccinations
FROM portfolioproject1.coviddeaths cd
LEFT JOIN portfolioproject1.covidvaccinations cv
ON cd.date = cv.date
GROUP BY date_year_month
ORDER BY date_year_month;


## Hospitization and ICU analysis
SELECT DATE_FORMAT(date, '%Y-%m') AS date_year_month, SUM(icu_patients) AS total_icu_patients, SUM(hosp_patients) AS total_hosp_patients
FROM portfolioproject1.coviddeaths
GROUP BY date_year_month
ORDER BY date_year_month;

## Hospitalization analysis
SELECT location, DATE_FORMAT(date, '%Y-%m') AS date_year_month, SUM(icu_patients) AS total_icu_patients
FROM portfolioproject1.coviddeaths
GROUP BY location, date_year_month
ORDER BY total_icu_patients desc
LIMIT 10;

## High-risk popolation analysis
SELECT cv.location, cv.population_density, SUM(cd.total_cases) AS total_cases
FROM portfolioproject1.covidvaccinations cv
LEFT JOIN portfolioproject1.coviddeaths cd
ON cv.iso_code = cd.iso_code
GROUP BY cv.location, cv.population_density
ORDER BY cv.population_density desc;


## Life expentancy impact
SELECT cv.location,cv.life_expectancy, SUM(cd.total_deaths) AS total_deaths
FROM portfolioproject1.covidvaccinations cv
LEFT JOIN portfolioproject1.coviddeaths cd
ON cv.iso_code = cd.iso_code
GROUP BY cv.location, cv.life_expectancy
ORDER BY total_deaths desc;

## Stringency Index Analysis
SELECT DATE_FORMAT(date, '%Y-%m') AS date_year_month, AVG(stringency_index) AS avg_stringency_index, SUM(new_cases) AS total_new_cases, SUM(new_deaths) AS total_new_deaths
FROM portfolioproject1.coviddeaths
GROUP BY date_year_month
ORDER BY date_year_month;
