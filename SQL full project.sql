select location, date, total_cases, new_cases, total_deaths, population
from coviddeaths
order by 1,2;

-- loking total cases vs total deaths; shows likehood od fying if you contractcovid in yuour country;

select location, date, total_cases, total_deaths, population, (total_deaths/total_cases)*100 as deathpercentage
from coviddeaths
order by 1,2

-- looking at total cases vs population; shows what percentage of population got covid in Albania;

select location, date, total_cases, population, (total_cases/population)*100 as percentpopulationinfected
from coviddeaths
where location like '%Albania%'
order by 1,2;

-- looking at countries with the highest infection rate compared to population;

select location, MAX(total_cases) as highestinfectioncount, population, MAX((total_cases/population))*100 as percentpopulationinfected
from coviddeaths
group by location, population
order by percentpopulationinfected desc;

-- showing countries with the highest death count por population;

select location, max(total_deaths) as totaldeathcount
from coviddeaths
where continent is not null
group by location
order by totaldeathcount desc;

 -- showing the continents with the highest deathcounts;

select continent, max(total_deaths) as totaldeathcount
from coviddeaths
where continent is not null
group by continent
order by
 totaldeathcount desc;
 
-- global numbers;

select date, sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, sum(new_deaths)/sum(new_cases)*100 as deathpercentage
from coviddeaths
where continent is not null
group by date 
order by 1,2;

-- looking at total population vs vaccinations;

select *
from coviddeaths dea
join covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date;

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from coviddeaths dea
join covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date 
where dea.continent is not null
order by 1,2,3;

create view percentpopulationvaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
from coviddeaths dea
join covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date 
where dea.continent is not null
order by 2,3;

create view percentpopulationvaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
from coviddeaths dea
join covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date 
where dea.continent is not null;

-- final data table

select *
from percentpopulationvaccinated
