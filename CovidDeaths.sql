select *
from PortfolioProject..['Covid-Vaccination']
where continent is not null
order by 3, 4

--select *
--from PortfolioProject..['Covid-Deaths']
--order by 3, 4

--Show only location, date, total cases, new cases, deaths, and population
select location, date, total_cases, new_cases,total_deaths, population
from PortfolioProject..['Covid-Deaths']
order by 1,2

--Death Percentage Count
select location, date, total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..['Covid-Deaths']
where location = 'Philippines'
order by 1,2

--Population Percentage Infected
select location, date, total_cases,population,(total_cases/population)*100 as PopulationPercentage
from PortfolioProject..['Covid-Deaths']
--where location = 'Philippines'
order by 1,2

--Highest Population Infection Count
select location,population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PopulationInfectedPercentage
from PortfolioProject..['Covid-Deaths']
--where location = 'Philippines'
Group By location, population
order by PopulationInfectedPercentage desc

--Highest Death Count Population
select location, Max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..['Covid-Deaths']
--where location = 'Philippines'
where continent is not null
Group By location, population
order by TotalDeathCount desc

--Total Death Count in Continent
select continent, Max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..['Covid-Deaths']
--where location = 'Philippines'
where continent is not null
Group By continent
order by TotalDeathCount desc

--Global Numbers

--by Date
select date, SUM(new_cases) as 'Total Cases', SUM(cast(new_deaths as int)) as 'Total Deaths', ((SUM(cast(new_deaths as int)))/(sum(new_cases))*100) as 'Death Percentage'
from PortfolioProject..['Covid-Deaths']
--where location = 'Philippines' 
where continent is not null
group by date
order by 1,2

--Globally
select SUM(new_cases) as 'Total Cases', SUM(cast(new_deaths as int)) as 'Total Deaths', ((SUM(cast(new_deaths as int)))/(sum(new_cases))*100) as 'Death Percentage'
from PortfolioProject..['Covid-Deaths']
--where location = 'Philippines' 
where continent is not null
--group by date
order by 1,2









