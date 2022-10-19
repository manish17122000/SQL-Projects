select * from [dbo].[Covid-Death] order by 1

--Total Cases Vs Total Deaths
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 percentage_death from [dbo].[Covid-Death]
order by 1, 2

--Max Death Percentage by Location
select location, max((total_deaths/total_cases)*100) from [dbo].[Covid-Death] 
group by location order by 1

--Total Cases Vs Total Deaths in India only

Select location, date, total_cases, Total_deaths, (total_deaths/total_cases)*100 from [dbo].[Covid-Death] 
where location like '%India%'
order by 2

--Max percentage death in India
select max((total_deaths/total_cases)*100) from [dbo].[Covid-Death] 
where location like '%India%'


--Total cases VS Population in india
select location, date, total_cases, population, (total_cases/population)*100 from  [dbo].[Covid-Death] 
where location like '%india%' order by date

--Max Total cases VS Population in a country
select location,max( (total_cases/population)*100) from  [dbo].[Covid-Death] 
group by location 


--max and min total cases vs population and Total cases vs total deaths

select 
max(Total_cases/population)*100 max_TC_P, min(total_cases/population)*100 min_TC_P, 
max(total_deaths/total_cases)*100 max_TD_TC, min (total_deaths/ total_cases)*100 min_TD_TC
from [dbo].[Covid-Death]

/*
select max((total_deaths/total_cases)*100), location  from [dbo].[Covid-Death] 
group by location order by 1 desc

select total_deaths, total_cases  from [dbo].[Covid-Death] where location like '%iran%'
*/

--Countries with highest infection rate compared to Population

select location,population, max(total_cases) Highest_Infection_Count, max(total_cases/population)*100  Percent_Population_Infected
from [dbo].[Covid-Death]
group by location, population
order by Percent_Population_Infected desc

--Country with highest deaths and population
select location, max(cast(total_deaths as int)) max_total_deaths from 
[dbo].[Covid-Death]
where continent is not null
group by location 
order by max_total_deaths desc 

-- Cotinent with highest deaths and population
select location , max(cast(total_deaths as int)) max_deatyh_by_con from [dbo].[Covid-Death]
where continent is null
group by location
order by max_deatyh_by_con desc



--Joining datas
select * from [dbo].[Covid-Vaccination]
select * from [dbo].[Covid-Death]


with Pop_VS_VAC (Continent, location, date, population, new_vaccinations, total_vaccination_over_area)
as(
select 
dea.continent, 
dea.location, 
dea.date, 
dea.population, 
vac.new_vaccinations,
sum(cast(ltrim(vac.new_vaccinations) as float)) over (partition by dea.location order by dea.location, dea.date) as total_vaccination_over_area
from [dbo].[Covid-Death] as dea
join [dbo].[Covid-Vaccination] as vac
on dea.location= vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 1,2
)

--CTE Common Table Expression
select *, (total_vaccination_over_area/population)*100 from Pop_VS_VAC

--Temp Table
create table #Pop_VS_VAC(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
total_vaccination_over_area numeric
)

insert into #Pop_VS_VAC
select 
dea.continent, 
dea.location, 
dea.date, 
dea.population, 
vac.new_vaccinations,
sum(cast(ltrim(vac.new_vaccinations) as float)) over (partition by dea.location order by dea.location, dea.date) as total_vaccination_over_area
from [dbo].[Covid-Death] as dea
join [dbo].[Covid-Vaccination] as vac
on dea.location= vac.location
and dea.date=vac.date
where dea.continent is not null

 


