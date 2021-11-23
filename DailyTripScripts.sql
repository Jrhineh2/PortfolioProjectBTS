--Verify all data was imported
select *
from Trips_by_Distance$
-- level like '%State%'

--(TABLE ONE FOR TABLEAU)View participation by state  
select state, avg(population_sampled) as avg_population_participation
from Trips_by_Distance$
where state is not null
group by state
order by  State

--(TABLE ONE ALTERNATE) View if population grew each year
select year, state, avg(population_sampled) as avg_population_participation
from Trips_by_Distance$
where state is not null
group by state, year
order by  State, year


--View average pct staying home by level (should return the same percent)
select Level, Avg(Population_Staying_at_Home) as average_population_home, avg(Population_Sampled) as average_population_sampled, avg(Population_Staying_at_Home)/avg(Population_Sampled) *100 as pct_at_home
from Trips_by_Distance$
group by level


--(TABLE TWO FOR TABLEAU) View Percent of People staying home by state 
select state, Avg(Population_Staying_at_Home) as average_population_home, avg(Population_Sampled) as average_population_sampled, avg(Population_Staying_at_Home)/avg(Population_Sampled) *100 as avg_pct_at_home
from Trips_by_Distance$
where state is not null
group by State


--(TABLE 3 FOR TABLEAU) View pct staying home by month 
select month, year, Avg(Population_Staying_at_Home) as average_population_home, avg(Population_Sampled) as average_population_sampled, avg(Population_Staying_at_Home)/avg(Population_Sampled) *100 as avg_pct_at_home
from Trips_by_Distance$
where level like '%national%'
group by month, year
order by Year


--Look at percentage of people going over 500 miles
select year, Avg(Number_of_Trips) as average_trips, avg([Number_of_Trips_>=500]) as trips_over_500, avg([Number_of_Trips_>=500])/avg(Number_of_Trips) *100 as avg_pct_over_500
from Trips_by_Distance$
group by Year
order by year
--Look at percentage of people going 250-500 miles
select year, Avg(Number_of_Trips) as average_trips, avg([Number_of_Trips_250-500]) as trips_around_500, avg([Number_of_Trips_250-500])/avg(Number_of_Trips) *100 as avg_pct_around_500
from Trips_by_Distance$
group by year
order by Year
--Look at percentage of people going under 1 mile
select year, Avg(Number_of_Trips) as average_trips, avg([Number_of_Trips_<1]) as trips_less_1, avg([Number_of_Trips_<1])/avg(Number_of_Trips) *100 as avg_pct_less_1
from Trips_by_Distance$
group by year
order by Year


--(TABLE FOUR FOR TABLEAU) Look at percentage of people going Different distances 
select year,avg([Number_of_Trips_<1])/avg(Number_of_Trips) *100 as avg_pct_less_1, 
avg([Number_of_Trips_1-3])/avg(Number_of_Trips) *100 as avg_pct_1to3,
avg([Number_of_Trips_3-5])/avg(Number_of_Trips) *100 as avg_pct_3to5,
avg([Number_of_Trips_5-10])/avg(Number_of_Trips) *100 as avg_pct_5to10,
avg([Number_of_Trips_10-25])/avg(Number_of_Trips) *100 as avg_pct_10to25,
avg([Number_of_Trips_25-50])/avg(Number_of_Trips) *100 as avg_pct_25to50,
avg([Number_of_Trips_50-100])/avg(Number_of_Trips) *100 as avg_pct_50to100,
avg([Number_of_Trips_100-250])/avg(Number_of_Trips) *100 as avg_pct_100to250,
avg([Number_of_Trips_250-500])/avg(Number_of_Trips) *100 as avg_pct_250to500,
avg([Number_of_Trips_>=500])/avg(Number_of_Trips) *100 as avg_pct_more_500
from Trips_by_Distance$
group by year
order by Year


--Temp table for previous problem to veryify total pct==100 (Not sure how efficient this is but it is functional) 
--(TABLE FOUR FOR TABLEAU) Also can be used for tableau table 3
drop table if exists #pct_distance_breakdown
create table #pct_distance_breakdown
(
year float,
avg_pct_less_1 float,
avg_pct_1to3 float,
avg_pct_3to5 float,
avg_pct_5to10 float,
avg_pct_10to25 float,
avg_pct_25to50 float,
avg_pct_50to100 float,
avg_pct_100to250 float,
avg_pct_250to500 float,
avg_pct_more_500 float
)

insert into #pct_distance_breakdown
select year,
avg([Number_of_Trips_<1])/avg(Number_of_Trips) *100 as avg_pct_less_1, 
avg([Number_of_Trips_1-3])/avg(Number_of_Trips) *100 as avg_pct_1to3,
avg([Number_of_Trips_3-5])/avg(Number_of_Trips) *100 as avg_pct_3to5,
avg([Number_of_Trips_5-10])/avg(Number_of_Trips) *100 as avg_pct_5to10,
avg([Number_of_Trips_10-25])/avg(Number_of_Trips) *100 as avg_pct_10to25,
avg([Number_of_Trips_25-50])/avg(Number_of_Trips) *100 as avg_pct_25to50,
avg([Number_of_Trips_50-100])/avg(Number_of_Trips) *100 as avg_pct_50to100,
avg([Number_of_Trips_100-250])/avg(Number_of_Trips) *100 as avg_pct_100to250,
avg([Number_of_Trips_250-500])/avg(Number_of_Trips) *100 as avg_pct_250to500,
avg([Number_of_Trips_>=500])/avg(Number_of_Trips) *100 as avg_pct_more_500
from Trips_by_Distance$
group by year
order by Year

select year, avg_pct_less_1, 
avg_pct_1to3,
avg_pct_3to5,
avg_pct_5to10,
avg_pct_10to25,
avg_pct_25to50,
avg_pct_50to100,
avg_pct_100to250,
avg_pct_250to500,
avg_pct_more_500,
avg_pct_less_1 + avg_pct_1to3 + avg_pct_3to5 + avg_pct_5to10 + avg_pct_10to25 + avg_pct_25to50 + avg_pct_50to100 + avg_pct_100to250 + avg_pct_250to500 + avg_pct_more_500 as total_percentage
from #pct_distance_breakdown
--where year = 2019
order by Year
