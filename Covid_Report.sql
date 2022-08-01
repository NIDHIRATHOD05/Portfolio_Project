use covid_data;
select *
from covid_death
order by location

select * 
from covid_vaccination
order by location
 
 -- data that we will work on 
 
select location, date, total_cases, new_cases, total_deaths, new_deaths, population
from covid_death
order by location

-- total cases v/s total death = death_percentage

select location, date, total_cases, total_deaths, 
		population,
		(total_deaths/total_cases)*100 as death_percentage
from covid_death
-- where location like "india"
order by location

-- toatal case v/s population

select location, date, total_cases,
		population,
		(total_cases/population)*100 as infection_rate,
         total_deaths,
		(total_deaths/total_cases)*100 as death_percentage
from covid_death
-- where location like "india"
order by location

-- countries with higest infection rate 

select location, population,
		max(total_cases) as higest_infection_count,
		max((total_cases/population))*100 as infection_rate_percentage
from covid_death
-- where location like "india"
group by location, population
order by infection_rate_percentage desc

-- higest death count per population

select location,
		MAX(total_deaths) as total_death_count
from covid_death
-- where location like "india"
where continent is not null 
group by location
order by total_death_count desc

-- data by continent

select continent, 
		MAX(total_deaths) as total_death_count
from covid_death
where continent is not null 
group by continent
order by total_death_count desc

-- global numbers

select sum(new_cases) as total_cases,
		sum(new_deaths) as total_deaths,
        sum(new_cases)/sum(new_deaths)*100 as death_percentage
from covid_data.covid_death
where continent is not null
order by 1,2

-- covid data including the cases and vaccination project

select *
from covid_death cd
join covid_vaccination cv
	on cd.location = cv.location
    and cd.date = cv.date
    
-- total population v/s vaccination 

select cd.continent, cd.location, cd.date, cd.population, 
		cv.new_vaccinations 
from covid_death cd
join covid_vaccination cv
	on cd.location = cv.location
    and cd.date = cv.date
-- where cd.continent is not null
order by 2

--

select cd.continent, cd.location, cd.date, cd.population, 
		cv.new_vaccinations,
        sum(cv.new_vaccinations) over (partition by cd.location order by cd.location , cd.date) as rolling_people_vaccinated
        -- (rolling_people_vaccinated / population)*100 
from covid_death cd
join covid_vaccination cv
	on cd.location = cv.location
    and cd.date = cv.date
-- where cd.continent is not null
order by 2

-- use comman table expression

with PopvsVac (continent, location, date, population, new_vaccinations, rolling_people_vaccinated) as
(
select cd.continent, cd.location, cd.date, cd.population, 
		cv.new_vaccinations,
        sum(cv.new_vaccinations) over (partition by cd.location order by cd.location , cd.date) as rolling_people_vaccinated
        -- (rolling_people_vaccinated / population)*100 
from covid_death cd
join covid_vaccination cv
	on cd.location = cv.location
    and cd.date = cv.date
where cd.continent is not null
-- order by 2
)
select * ,(rolling_people_vaccinated / population)*100 as vacc_percent
from PopvsVac 


-- temp table 


create table PercentPopulationVaccinated
(
continent text,
location text,
date text,
population int,
new_vaccinations text,
rolling_people_vaccinated text
)
insert into PercentPopulationVaccinated
	select cd.continent, cd.location, cd.date, cd.population, 
		cv.new_vaccinations,
        sum(cv.new_vaccinations) over (partition by cd.location order by cd.location , cd.date) as rolling_people_vaccinated
        -- (rolling_people_vaccinated / population)*100 
from covid_death cd
join covid_vaccination cv
	on cd.location = cv.location
    and cd.date = cv.date
-- where cd.continent is not null
-- order by 2

select * ,(rolling_people_vaccinated / population)*100 as vacc_percent
from PercentPopulationVaccinated


-- creating view to store data for visualizations

create view percent_population_vaccinated as
select cd.continent, cd.location, cd.date, cd.population, 
		cv.new_vaccinations,
        sum(cv.new_vaccinations) over (partition by cd.location order by cd.location , cd.date) as rolling_people_vaccinated
        -- (rolling_people_vaccinated / population)*100 
from covid_death cd
join covid_vaccination cv
	on cd.location = cv.location
    and cd.date = cv.date
where cd.continent is not null
-- order by 2v













































































 


