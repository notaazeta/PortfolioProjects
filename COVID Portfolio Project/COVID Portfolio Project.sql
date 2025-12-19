Select *
from [Portfolio Project]..CovidDeaths
order by 3,4

--Select *
--from [Portfolio Project]..CovidVaccinations
--order by 3,4

--Select data to be used

select location, date, total_cases,  new_cases, total_deaths, population
from [Portfolio Project]..CovidDeaths
order by 1,2


--total cases vs total deaths
--Shows likelihood of dying if you get covid in Nigeria

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from [Portfolio Project]..CovidDeaths
where location like '%nigeria%'
order by 1,2


--Total cases vs Population
-- shows what percentage of population got covid

select location, date, Population, total_cases, (total_cases/population)*100 as PercentInfectedPopulation
from [Portfolio Project]..CovidDeaths
where location like '%nigeria%'
order by 1,2


--countries with highest infection rate compared to population

select location, Population, MAX(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as PercentInfectedPopulation
from [Portfolio Project]..CovidDeaths
--where location like '%nigeria%'
Group by location, population
order by PercentInfectedPopulation desc


--countries with highest death count per population

select location, max(cast(total_deaths as int)) as TotaldeathCount
from [Portfolio Project]..CovidDeaths
--where location like '%nigeria%'
where continent is not null
Group by location
order by TotaldeathCount desc


--BREAKING DOWN BY CONTINENT

--continents with highest death count per population
select continent, max(cast(total_deaths as int)) as TotaldeathCount
from [Portfolio Project]..CovidDeaths
--where location like '%nigeria%'
where continent is not null
Group by continent
order by TotaldeathCount desc



--global numbers
select date, sum(new_cases) as Total_Cases, sum(cast(new_deaths as int)) as Total_Deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from [Portfolio Project]..CovidDeaths
--where location like '%nigeria%'
where continent is not null
group by date
order by 1,2


--global numbers cases vs deaths
select sum(new_cases) as Total_Cases, sum(cast(new_deaths as int)) as Total_Deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from [Portfolio Project]..CovidDeaths
--where location like '%nigeria%'
where continent is not null
order by 1,2


-- Total Population vs vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from [Portfolio Project]..CovidDeaths dea
join [Portfolio Project]..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3


-- using CTE

with popvsvac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from [Portfolio Project]..CovidDeaths dea
join [Portfolio Project]..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *, (RollingPeopleVaccinated/population)*100
from popvsvac



--Temp table


drop table if exists #PercentPopulationvaccinated
create table #PercentPopulationvaccinated
(
Continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vacccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationvaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from [Portfolio Project]..CovidDeaths dea
join [Portfolio Project]..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

select *, (RollingPeopleVaccinated/population)*100
from #PercentPopulationvaccinated








--creating View to store data for later visualization

create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from [Portfolio Project]..CovidDeaths dea
join [Portfolio Project]..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3



