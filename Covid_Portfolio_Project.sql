select *
from portfolio_project..coviddeaths
order by 3,4
;

select *
from portfolio_project..covidvaccinations
order by 3,4
;

select location, date, total_cases, new_cases, total_deaths, population
from portfolio_project..coviddeaths
order by 1,2
;


--Looking at total cases vs total deaths
--Shows the likelihood of dying if contracted.

select location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
from portfolio_project..coviddeaths
where location like '%states%'
order by 1,2
;

--Looking at Total Cases vs Population
--Shows percentage of population if contracted Covid

select location, date, population, total_cases, (total_cases/population)*100 as case_percentage
from portfolio_project..coviddeaths
--where location like '%states%'
order by 1,2
;

--Looking at countries with highest infection rate compareed to population

select location, population, max(total_cases) as highestinfectioncount, max((total_cases/population))*100 as percentpopulationinfected
from portfolio_project..coviddeaths
group by location, population
order by percentpopulationinfected desc
;

--Showing the countries with the highest death count per population

select location, max(cast(total_deaths as int)) as TotalDeathCount
from portfolio_project..coviddeaths
where continent is not null
group by location
order by  TotalDeathCount desc
;

--Breaking things down by Continent


select *
from portfolio_project..coviddeaths
where continent is not null
order by 3,4
;


select location, max(cast(total_deaths as int)) as TotalDeathCount
from portfolio_project..coviddeaths
where continent is not null
group by location
order by  TotalDeathCount desc
;

-- Global numbers

select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as death_percentage
from portfolio_project..coviddeaths
where continent is not null
group by date
order by 1,2
;


select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as death_percentage
from portfolio_project..coviddeaths
where continent is not null
order by 1,2
;


--Joins

select *
from portfolio_project..coviddeaths cd
join portfolio_project..covidvaccinations cv
	on cd.date = cv.date
	and cd.location = cv.location
;


--Total population vs vaccinations
--use CTE

with popvsvac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
sum(convert(int, cv.new_vaccinations)) over (partition by cd.location order by cd.location, cd.date)
as RollingPeopleVaccinated
from portfolio_project..coviddeaths cd
join portfolio_project..covidvaccinations cv
	on cd.location = cv.location
	and cd.date = cv.date
where cd.continent is not null
)
select *
from popvsvac
where RollingPeopleVaccinated is not null
;


--Temp Table


drop table if exists #PercentpopulationVaccinated
Create table #PercentpopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255), 
date datetime,
population numeric,
new_vaccinations numeric, 
RollingPeopleVaccinated numeric
)
insert into #PercentpopulationVaccinated
select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
sum(convert(int, cv.new_vaccinations)) over (partition by cd.location order by cd.location, cd.date)
as RollingPeopleVaccinated
from portfolio_project..coviddeaths cd
join portfolio_project..covidvaccinations cv
	on cd.location = cv.location
	and cd.date = cv.date
where cd.continent is not null

select *
from #PercentpopulationVaccinated
where RollingPeopleVaccinated is not null
;


--creating view for visualizations

create view PercentpopulationVaccinated as
select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
sum(convert(int, cv.new_vaccinations)) over (partition by cd.location order by cd.location, cd.date)
as RollingPeopleVaccinated
from portfolio_project..coviddeaths cd
join portfolio_project..covidvaccinations cv
	on cd.location = cv.location
	and cd.date = cv.date
where cd.continent is not null
;

create view percentpopulationinfected as
select location, population, max(total_cases) as highestinfectioncount, max((total_cases/population))*100 as percentpopulationinfected
from portfolio_project..coviddeaths
group by location, population
;