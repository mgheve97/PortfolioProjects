--Joining two Tables
select *
from PortfolioProject..['Covid-Deaths'] dea
join PortfolioProject..['Covid-Vaccination'] va
	on dea.location = va.location
	and dea.date = va.date

--Total Population vs Vaccination
select dea.continent, dea.location, dea.date, dea.population, va.new_vaccinations
	,SUM(convert(int, va.new_vaccinations)) over (partition by dea.location order by dea.location, 
	dea.date) as RollingPeopleVaccinated
	--,(RollingPeopleVaccinated/population)*100
from PortfolioProject..['Covid-Deaths'] dea
join PortfolioProject..['Covid-Vaccination'] va
	on dea.location = va.location
	and dea.date = va.date
where dea.continent is not null --and va.new_vaccinations is not null
order by 2,3

--CTE
with PopvsVac (Cintinent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, va.new_vaccinations
	,SUM(convert(int, va.new_vaccinations)) over (partition by dea.location order by dea.location, 
	dea.date) as RollingPeopleVaccinated
	--,(RollingPeopleVaccinated/population)*100
from PortfolioProject..['Covid-Deaths'] dea
join PortfolioProject..['Covid-Vaccination'] va
	on dea.location = va.location
	and dea.date = va.date
where dea.continent is not null --and va.new_vaccinations is not null
--order by 2,3
)

Select *, (RollingPeopleVaccinated/Population)*100
from PopvsVac

--Temp Table

Drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinated numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, va.new_vaccinations
	,SUM(cast(va.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, 
	dea.date) as RollingPeopleVaccinated
	--,(RollingPeopleVaccinated/population)*100
from PortfolioProject..['Covid-Deaths'] dea
join PortfolioProject..['Covid-Vaccination'] va
	on dea.location = va.location
	and dea.date = va.date
where dea.continent is not null --and va.new_vaccinations is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated



--creating view to store data for later visualisation

create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, va.new_vaccinations
	,SUM(cast(va.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, 
	dea.date) as RollingPeopleVaccinated
	--,(RollingPeopleVaccinated/population)*100
from PortfolioProject..['Covid-Deaths'] dea
join PortfolioProject..['Covid-Vaccination'] va
	on dea.location = va.location
	and dea.date = va.date
where dea.continent is not null --and va.new_vaccinations is not null
--order by 2,3

select *
from PercentPopulationVaccinated