CREATE database sqlproject;
use sqlproject;
select * from dataset1;
desc dataset2;
select * from dataset2;

# calculate total number of rows in our dataset
select count(*) from dataset1;

select count(*) from dataset2;
-- ------------------------------------------------------ --
# dataset for jharkhand and bihar
select * from dataset1 where State in ("Jharkhand", "Bihar");
select * from dataset2 where State in ("Jharkhand", "Bihar");
-- ------------------------------------------------------- --
# find out total population of india
select sum(population) as Total_Population from dataset22;

-- --------------------------------------------------------------------- --
# Average growth of india
select avg(growth) as avg_growth from dataset1;

-- ------------------------------------------------------------------- --
# Average growth by state
select state, round(avg(growth) ,2)as avg_growth from dataset1 group by state;
-- ------------------------------------------------------------------- --
# Average sex ratio 
select round(avg(sex_ratio),0) as avg_sex_ratio  from dataset1 ;
-- --------------------------------------------------------------------- --
# Average sex ratio statewise
select state, round(avg(sex_ratio) ,0)as avg_sex_ratio from dataset1 group by state order by avg_sex_ratio desc;

-- ---------------------------------------------------------------------- --
# Average literacy rate
select * from dataset1;
select round(avg(literacy),2) as avg_literacy_rate from dataset1;
-- -------------------------------------------------------------------- --
# Average literacy rate statewise for which rate is greater than 90

select state, round(avg(literacy),2) as avg_literacy_rate from dataset1 group by state having avg_literacy_rate >90;

-- --------------------------------------------------------------------- --
# top 3 state showing highest growth rate

select state, round(avg(growth) ,2)as avg_growth from dataset1 group by state order by avg_growth desc limit 3;

-- -------------------------------------------------------------------- --
# bottom 3 state showing highest sex ratio
select state, round(avg(sex_ratio) ,2)as avg_sex_ratio from dataset1 group by state order by avg_sex_ratio limit 3;

-- --------------------------------------------------------------------- --
# select top and bottom 3 state with literacy rate
select * from
(select state, round(avg(literacy) ,2)as avg_literacy_rate from dataset1 group by state order by avg_literacy_rate  desc limit 3) a
union
select * from
(select state, round(avg(literacy) ,2)as avg_literacy_rate  from dataset1 group by state order by avg_literacy_rate  limit 3) b;

-- --------------------------------------------------------------------- --
# states starting with letter A:
select distinct(state) from dataset1 where state like "a%";
-- --------------------------------------------------------------------- --
# states starting with letter  A or B
select distinct(state) from dataset1 where state like "a%" or state like "b%";
-- --------------------------------------------------------------------- --
# states starting with letter  A and eending with letter m
select distinct(state) from dataset1 where state like "a%m";
-- --------------------------------------------------------------------- --
# find out total number of males and females
select d.state, sum(d.males) males, sum(d.females) females, d.population  from 
(select c.district, c.state,c.population, round(c.population/(c.sex_ratio+1),0) males, round((c.population*c.sex_ratio)/(c.sex_ratio+1),0) females from 
(select a.district , a.state, a.sex_ratio/1000 sex_ratio, population from dataset1 a inner join dataset22 b on a.district = b.district) c) d
group by d.state;

-- --------------------------------------------------------------------- --
# literate people state wise
select d.state, sum(literate_people) total_literate_population, sum(illiterate_people)  total_illiterate_population from 
(select district, state, round(literacy* population,0) literate_people, round((1-literacy) * Population ,0) illiterate_people from
(select a.district , a.state, a.Literacy/100 Literacy, population from dataset1 a inner join dataset22 b on a.district = b.district) c) d
group by state;

-- ---------------------------------------------------------------------------------- --
# previous year population statewise
select m.state, sum(m.previous_census_population),sum( m.current_year_census) from 
(select d.district , d.state, round(d.population/(1+d.growth),0) previous_census_population, d.population current_year_census from 
(SELECT a.district , a.state, a.growth, b.population from dataset1 a 
inner join dataset22 b on a.district = b.district) d) m group by m.state;
-- ---------------------------------------------------------------------------------- --
# previous year population
select sum(e. previous_census_population) previous_census_population , sum(e.current_year_census) current_year_census from
(select m.state, sum(m.previous_census_population)  previous_census_population,sum( m.current_year_census) current_year_census from 
(select d.district , d.state, round(d.population/(1+d.growth),0) previous_census_population, d.population current_year_census from 
(SELECT a.district , a.state, a.growth, b.population from dataset1 a 
inner join dataset22 b on a.district = b.district) d) m group by m.state ) e;

-- ---------------------------------------------------------------------------------- --
# top 3 district from each state with hisgest literacy rate
select a.* from 
(select district, state, literacy, rank() over (partition by state order by literacy desc)  rn
from dataset1) a where rn<=3;
