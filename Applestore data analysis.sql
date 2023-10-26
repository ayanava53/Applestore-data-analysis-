create table applestore_desc_combined AS
select * from appleStore_description1
union ALL
select * from appleStore_description2
union all 
SELECT * from appleStore_description3
union ALL
select * from appleStore_description4

** EXPLORATORY DATA ANALYSIS **

--check the number of unique apps in both tables
select count(DISTINCT id) as uniqueid from AppleStore
select count(DISTINCT id) as uniqueid from applestore_desc_combined

--check for any missing values in key fieldAppleStore
select count(*) as missing_values from AppleStore 
where track_name isNULL or user_rating ISNULL or size_bytes ISNULL or price ISNULL or prime_genre ISNULL
select count(*) as missing_values from applestore_desc_combined 
where app_desc ISNULL

--find out the number of apps
select prime_genre,count(*) as num_apps from AppleStore
group by prime_genre
order by num_apps desc 

--get an overview of app rating 
select min(user_rating) as Minrating ,
       avg(user_rating) as Avgrating ,
       max(user_rating) as Maxrating
from AppleStore

--find out the maximum rated apps
select max(user_rating) from AppleStore
select track_name,user_rating from AppleStore
where user_rating = 5

--find out the minimum rated apps 
select track_name,user_rating from AppleStore
where user_rating = 0

** DATA ANALYSIS **

--determine if paid apps have higher rating or free apps
select case 
when price > 0 then 'Paid'
else 'Free'
end as app_type , avg(user_rating) as avgrating 
from AppleStore
group by app_type

--check apps with more supported languages have higher ratings
SELECT case 
when lang_num <10 then '<10 languages'
when lang_num between 10 and 30 then '10-30 languages'
else '>30 languages' end as language_numbers ,
avg(user_rating) as avgrating
from AppleStore 
group by language_numbers 
order by avgrating desc

--check genre with low ratings 
select prime_genre,avg(user_rating) as rating
from AppleStore
group by prime_genre
order by rating

--check if there's any corelation between the length of the app description and user rsatingAppleStore
select CASE
when length(b.app_desc) < 500 then 'short length'
when length(b.app_desc) between 500 and 1000 then 'medium length'
else 'long length' end as length ,
avg(a.user_rating) as avgrating
from AppleStore as a  join applestore_desc_combined as b
on a.id = b.id 
group by length

--check the top rated apps for each genre
select track_name,prime_genre,user_rating 
from
(select track_name,prime_genre,user_rating , 
 rank()over(partition by prime_genre order by user_rating desc,rating_count_tot desc) as rank
from AppleStore) as a
 where a.rank = 1

-- check out which app genre is most popular 
select prime_genre, avg(user_rating) as avgrating
from AppleStore


