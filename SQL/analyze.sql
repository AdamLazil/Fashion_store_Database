-- Analyze

-- Questions
  ----------- Reception section----------
	 -- How much total of goods were received in each year?

	
	with cte as (
	select 
		  sum(amount),
		  extract(year from date) as year
	from reception
	where amount <= 6
	group by extract(year from date) 
	order by extract(year from date)
	),
	cte2 as (
	select
		 sum(amount_left),
		 extract(year from date) as year
	from reception
	where extract(year from date) = 1900 and
	amount_left > 0
	group by extract(year from date)
	)
	select * from cte
	union 
	select * from cte2
	order by year
	;
	
	-- version 2 according to receipt code (more accurate)
	select 
		  sum(amount),
		  substring(reciept_id,1,2) as year,
		  sum(price_buy)
	from reception
	where amount <= 6
	group by substring(reciept_id,1,2)
	having length(substring(reciept_id,1,2)) >= 2
	order by substring(reciept_id,1,2)
	;
	
	
	 -- How many pieces depending on the type of product?
	
	select * from reception;
	
	copy(
	select product,
	   sum(amount)filter(where extract(year from date) = 2017) as cn2017,
	   sum(amount)filter(where extract(year from date) = 2018) as cn2018,
	   sum(amount_left)filter(where extract(year from date) = 1900) as cn2019,
	   sum(amount)filter(where extract(year from date) = 2020) as cn2020,
	   sum(amount)filter(where extract(year from date) = 2021) as cn2021,
	   sum(amount)filter(where extract(year from date) = 2022) as cn2022,
	   sum(amount)filter(where extract(year from date) = 2023) as cn2023,
	   sum(amount)filter(where extract(year from date) = 2024) as cn2024,
	   sum(amount)filter(where extract(year from date) = 2025) as cn2025
from reception
where amount_left > 0 and amount_left < 10 or null
group by rollup(product)
)
to 'C:\Program Files\PostgreSQL\17\data\TopFashion\export\prijatezbozidruh.csv'
with(format csv, header, delimiter ';');
	
	 -- How many pieces depending on the brand ?
	 
	 select brand,
	   count(*)filter(where extract(year from date) = 2017) as cn2017,
	   count(*)filter(where extract(year from date) = 2018) as cn2018,
	   count(*)filter(where extract(year from date) = 1900) as cn2019,
	   count(*)filter(where extract(year from date) = 2020) as cn2020,
	   count(*)filter(where extract(year from date) = 2021) as cn2021,
	   count(*)filter(where extract(year from date) = 2022) as cn2022,
	   count(*)filter(where extract(year from date) = 2023) as cn2023,
	   count(*)filter(where extract(year from date) = 2024) as cn2024,
	   count(*)filter(where extract(year from date) = 2025) as cn2025
from reception
group by rollup(brand);


	 -- How many pieces according the store ? 

select * from reception;

	select
		extract(year from date) as  year,
		sum(amount),
		establishment
	from reception
	where amount > 0
	group by extract(year from date), establishment
	having sum(amount) > 50
	order by year
	;


	-- How many shoes by brand in each year ?
	
	with cte as (
select 
	   extract(year from datcreate) as year,
	   product,
	   count(*) as pocet_ks,
	   sum(price_netto) as revenue,
	   sum(dph) as dph  
from sales_final
where year in (2017,2018,2019,2020,2021,2022,2023,2024,2025) and product = 'Boty'
group by product,extract(year from datcreate)  
order by extract(year from datcreate) asc
),
cte2 as (
select
	  extract(year from r.date) as year,
	  sum(r.amount) as prijate_ks,
	  sum(r.price_buy) as costs
from reception r
where product = 'Boty' and amount > 0
group by extract(year from date)
)
select
	  c.*,
	  cc.*
from cte c
left join cte2 cc on c.year = cc.year
order by c.year asc
;


		-- How many pieces and at what price were received in the month of the given year ? 
		
	select
		  substring(reciept_id,1,2) as year,
		  extract(month from date) as month,
		  sum(amount) as pocet,
		  sum(price_buy) as cena
	from reception
	where amount <= 6
	and substring(reciept_id,1,2) = substring(cast(extract(year from date) as varchar),3,2)
	group by substring(reciept_id,1,2),extract(month from date) 
	having length(substring(reciept_id,1,2)) >= 2
	order by substring(reciept_id,1,2)
	;
	
		------ crosstab -------
		select * 
		from crosstab(
		$$
		select
		  extract(month from date) as month,
		  substring(reciept_id,1,2) as year,
		  sum(price_buy)
	from reception
	where amount <= 6
	and substring(reciept_id,1,2) = substring(cast(extract(year from date) as varchar),3,2)
	group by 1,2
	having length(substring(reciept_id,1,2)) >= 2
	order by 1,2
		$$
	)as ct (
		month numeric,
		"17" numeric,
     	"20" numeric,
    	"21" numeric,
    	"22" numeric,
    	"23" numeric,
    	"24" numeric,
    	"25" numeric
	)	
		;


	
	
  								----------- Sell section -----------------

		-- How many reciepts in total ?
explain(	
SELECT
    sf_t2.year,
    COUNT(DISTINCT sf_t2.reciept) AS luh,
    COUNT(DISTINCT sf_t1.reciept) AS zl
FROM sales_final sf_t2
LEFT JOIN sales_final sf_t1
    ON sf_t1.year = sf_t2.year
   AND sf_t1.store = 't1'
WHERE sf_t2.store = 't2'
GROUP BY sf_t2.year
ORDER BY sf_t2.year);

------ cte
WITH t1 AS (
    SELECT year, COUNT(DISTINCT reciept) AS zl
    FROM sales_final
    WHERE store = 't1'
    GROUP BY year
),
t2 AS (
    SELECT year, COUNT(DISTINCT reciept) AS luh
    FROM sales_final
    WHERE store = 't2'
    GROUP BY year
)
SELECT
    COALESCE(t2.year, t1.year) AS year,
    t2.luhacovice,
    (t2.luhacovice - lag(t2.luhacovice)over(order by year))as dif_luha,
    t1.zlín,
    (t1.zlín - lag(t1.zlín)over(order by year))as dif_zl
FROM t2
FULL JOIN t1 USING (year)
ORDER BY year;git status
	
	
	

	 -- How much total goods were sold in each year?
	 
	 select * from sales_final sf ;
	 select
	 	year,
	 	count(*),
	 	sum(price_brutto)
	 from sales_final
	 group by year
	 order by year asc;
	 
	
	 
	 -- Best-selling item ?
	 select * from sales_final
		where store = 't3';
	 
	 
	 with cte as (
	 select
	 		product,
	 		count(product) as t1
	 from sales_final
	 where store = 't1'
	 group by product
	 ),
	 cte2 as (
	 	 select
	 		product,
	 		count(product) as t2
	 from sales_final
	 where store = 't2'
	 group by product
	 )
	 select
	 	  coalesce(t1.product,t2.product) as product,
	 	  t1.t1,
	 	  t2.t2
	 from cte t1
	 full join cte2 t2 on t1.product = t2.product	  
	 order by (coalesce(t1.t1,0) + coalesce(t2.t2, 0)) desc;
	 
	 -- how much of each product was sold in each year ?
	 
	 select product,
	   count(*)filter(where year = 2017) as cn2017,
	   count(*)filter(where year = 2018) as cn2018,
	   count(*)filter(where year = 2019) as cn2019,
	   count(*)filter(where year = 2020) as cn2020,
	   count(*)filter(where year = 2021) as cn2021,
	   count(*)filter(where year = 2022) as cn2022,
	   count(*)filter(where year = 2023) as cn2023,
	   count(*)filter(where year = 2024) as cn2024,
	   count(*)filter(where year = 2025) as cn2025
from sales_final
group by rollup(product)
;
	 
		-- According months for choosen products 

			select 
				product,
				extract(month from date) as month,
				count(product)
			from sales_final
			where year = 2025 and product = 'Boty'
			group by extract(month from date),product;
			
			
	 
	 -- How many pieces of merchandise are there on average per reciept?
	 
	 select * from sales_final 
	 ;
	  
	 -- avg for t1
	 with cte as (
	 select
	 	year,
	 	reciept,
	 	count(name) as pocet_na_r,
	 	store
	 from sales_final sm
	 where name not ilike 'sleva%' and
	 store = 't1'
	 group by reciept,year, store
	 )
	 select
	 	  year,
	 	  avg(c.pocet_na_r) as prumer
	 from cte c
	 group by year 
	 order by year asc
	 ;
	 
	 -- avg for t2
	 with cte as (
	 select
	 	year,
	 	reciept,
	 	count(name) as pocet_na_r,
	 	store
	 from sales_final sm
	 where name not ilike 'sleva%' and
	 store = 't2'
	 group by reciept,year, store
	 )
	 select
	 	  year,
	 	  avg(c.pocet_na_r) as prumer
	 from cte c
	 group by year 
	 order by year asc
	 ;
	 
	 
	 -- median
	 
	 with cte_cont as (
	  select
	 	year,
	 	reciept,
	 	count(name) as pocet_na_r
	 from sales_final sm
	 where name not ilike 'sleva%'
	 group by reciept,year
	 )
	 select
	 	  year,
	 	  PERCENTILE_CONT(0.5)within group(order by pocet_na_r) as cont
	 from cte_cont
	 group by year
	 ;
	 
	 
	 
	 
	 -- Average spending per sale by form ?
	 
	 
	 select
	 	store,
	 	form,
	 	avg(price_netto) as prumer
	 from sales_final sf 
	 where form in (2,5)
	 and store = 't2'
	 group by store, form
	 union all
	  select
	  	store,
	  	form,
	 	avg(price_netto) as prumer
	 from sales_final sf 
	 where form in (2,5)
	  and store = 't1'
	  group by store, form;
	  
	  -- in main season
	 
	 select
	 	store,
	 	form,
	 	avg(price_netto) as prumer
	 from sales_final sf 
	 where form in (2,5)
	 and store = 't2'
	 and extract(month from date) in (06,07,08,09,10)
	 group by store, form
	 union all
	  select
	  	store,
	  	form,
	 	avg(price_netto) as prumer
	 from sales_final sf 
	 where form in (2,5)
	  and store = 't1'
	  and extract(month from date) in (06,07,08,09,10)
	  group by store, form;
	 
	  
	 --- average selling price when purchasing more than 2 items
	 with cte as ( 
	 select 
	 	  reciept,
	 	  sum(price_netto) as cena,
	 	  count(name) as pocet_pr
	 from sales_final sf 
	 where form = 5
	 group by reciept
	 having count(name)>2
	 )
	 select
	 	  avg(c.cena) as prumer
	 from cte c
	 ;
	 
	 
	 -- How many discounts were granted in each year ?
	 	
	 -- sleva je ve dvou podobach. Ve sloupci discount a potom v name. Nejdrive se musi vypocitat discount ktery je procentne vzcislen a nasledne sleva y name ktera je na prodejku
	 
	 
	 select 
	 	  year,
	 	  count(sf.discount),
	 	  sum((discount::numeric(10,2)/100)*(price_netto)) as discountgive,
	 	  (select
	 	  		count(sf3.name) 
	 	  	from sales_final sf3
	 	  	where name ilike 'sleva%' and
	 	  	sf.year = sf3.year) as count_2,
	 	  (select
	 	  		sum(abs(sf2.price_brutto_bd))
	 	  	from sales_final sf2 
	 	  	where name ilike 'sleva%'
	 	  	and sf.year = sf2.year) as discountgive_2
	 from sales_final sf 
	 where discount > 0
	 group by year
	 order by year asc
	 ;

	 
	 -- According store
	 
	  select 
	 	  year,
	 	  store as prodejna,
	 	  count(sf.discount),
	 	  sum((discount::numeric(10,2)/100)*(price_netto)) as discountgive
	 from sales_final sf 
	 where name ilike 'sleva%' or discount > 0
	 group by year, store
	 order by year asc;
	  
	
	  -- according store (better visual)
SELECT 
    year,
    SUM(CASE WHEN store = 't1' THEN 1 ELSE 0 END) AS count_zlin,
    SUM(CASE WHEN store = 't1' THEN (discount/100.0)*price_netto ELSE 0 END) AS sum_zlin,
    SUM(CASE WHEN store = 't2' THEN 1 ELSE 0 END) AS count_luhacovice,
    SUM(CASE WHEN store = 't2' THEN (discount/100.0)*price_netto ELSE 0 END) AS sum_luhacovice,
    SUM(CASE WHEN store = 't3' THEN 1 ELSE 0 END) AS count_butik,
    SUM(CASE WHEN store = 't3' THEN (discount/100.0)*price_netto ELSE 0 END) AS sum_butik
FROM sales_final
WHERE discount > 0
GROUP BY year
ORDER BY year;
	  
	  
-- What percentage was the discount given?
-- by percentage of the discount column
select 
	discount as perc_dis,
	count(discount) as pocet
from sales_final sf
where discount > 0
group by sf.discount
having count(discount) > 1;



-- by sales discount in the name column

select 
	name as perc_dis,
	count(name) as pocet
from sales_final sf
where name ilike 'sleva%'
group by sf.name
having count(name) > 6;

select * from sales_final;
	 
---------- Performance t3 -------------

-- according hours and year


select
				 year,
				 date_part('hour', datcreate) as hour,
				 sum(price_netto),
				 count(distinct(reciept))
from sales_final sf 
where store = 't1' and establishment = 'OutletZlín'
group by year,date_part('hour', datcreate);
			
			-- crosstab
select *
from crosstab(
$$
	select
	date_part('hour', datcreate)::int as hour,
	year::int as year,
	sum(price_netto)::numeric as total
	from sales_final
	where store = 't1' and establishment = 'OutletZlín'
	group by year, date_part('hour', datcreate)
	order by 1,2
$$
)as ct(hour int, "2022" numeric, "2023" numeric);
		
			
			--------- Performance t1 -------------
			-- according time of sale (compare from previous years due to opening hours)
			
			select
				 year,
				 date_part('hour', datcreate) as hour,
				 sum(price_netto),
				 count(distinct(reciept))
			from sales_final sf 
			where store = 't1' and establishment != 'OutletZlín'
			group by year,date_part('hour', datcreate);
			
select *
from crosstab(
	 $$
	 select
	 	date_part('hour', datcreate)::int as hour,
	 	year::int as year,
	 	sum(price_netto)::numeric as total
	 from sales_final
	 where store = 't1' and establishment != 'OutletZlín'
	 group by rollup(year, date_part('hour', datcreate))
	 order by 1,2
	 $$,
	 $$select distinct year from sales_final order by year$$
)as ct(hour int,"2017" numeric,"2018" numeric,"2019" numeric,"2020" numeric,"2021" numeric, "2022" numeric, "2023" numeric,"2024" numeric,"2025" numeric)
			;
	 
			--------- Performance t2 -------------
			-- according time of sale (compare from previous years due to opening hours)
			
			select
				 year,
				 date_part('hour', datcreate) as hour,
				 sum(price_netto),
				 count(distinct(reciept))
			from sales_final sf 
			where store = 't2' 
			group by year,date_part('hour', datcreate);
			
			copy (	
			select *
				from crosstab(
				$$
				 select
				 	date_part('hour', datcreate)::int as hour,
				 	year::int as year,
				 	sum(price_netto)::numeric as total
				 from sales_final
				 where store = 't2' 
				 group by year, date_part('hour', datcreate)
				 order by 1,2
				 $$,
				 $$select distinct year from sales_final order by year$$
				)as ct(hour int,"2017" numeric,"2018" numeric,"2019" numeric,"2020" numeric,"2021" numeric, "2022" numeric, "2023" numeric,"2024" numeric,"2025" numeric)
				)
			to 'C:\Program Files\PostgreSQL\17\data\TopFashion\export\timesaleLuhacovice.csv'
			with(format csv, header, delimiter ';');

			
			
			
-------------- warehouse stock (exact data from 2021, imprecise until 2021)------------
			
	-- How many pieces of goods were in stock at the end of the year ?

	select * from storage21_25clothes sc ;
	
	select 	
		 year,
		 sum(amount)
	from storage21_25clothes sc 
	group by "year" ;
	
	select * from storage17_20 s ;
	select 
		 extract(year from datcreate) as year,
		 sum(amount)
	from storage17_20
	where ean in (
					select
							distinct(ean)
					from storage17_20)
	group by extract(year from datcreate);
	
	
select 
	count(*),
	extract(year from s.datcreate )
from storage17_20 s
where amount > 0
group by extract(year from s.datcreate )
union all
select 
	count(distinct(ean)),
	extract(year from s.datcreate )
from storage17_20 s 
where amount > 0
group by extract(year from s.datcreate);

	
	-- How many pieces of goods were in the stores' warehouses at the end of the year ?

SELECT
    product,
    SUM(CASE WHEN year = '2021' THEN amount ELSE 0 END) AS y2021,
    SUM(CASE WHEN year = '2022' THEN amount ELSE 0 END) AS y2022,
    SUM(CASE WHEN year = '2023' THEN amount ELSE 0 END) AS y2023,
    SUM(CASE WHEN year = '2024' THEN amount ELSE 0 END) AS y2024,
    SUM(CASE WHEN year = '2025' THEN amount ELSE 0 END) AS y2025
FROM storage21_25clothes
GROUP BY rollup(product)
ORDER BY product;
--- comperisson 
with cte as (
SELECT
    product,
    SUM(CASE WHEN year = '2021' THEN amount ELSE 0 END) AS y2021,
    SUM(CASE WHEN year = '2022' THEN amount ELSE 0 END) AS y2022,
    SUM(CASE WHEN year = '2023' THEN amount ELSE 0 END) AS y2023,
    SUM(CASE WHEN year = '2024' THEN amount ELSE 0 END) AS y2024,
    SUM(CASE WHEN year = '2025' THEN amount ELSE 0 END) AS y2025
FROM storage21_25clothes
GROUP BY product
ORDER BY product
),
cte2 as (
select
	  c.product,
	  c.y2022 - c.y2021 as dif21,
	  c.y2023 - c.y2022 as dif22,
	  c.y2024 - c.y2023 as dif23,
	  c.y2025 - c.y2024 as dif24   
from cte c
)
select * from cte2
;
	
	-- Whose goods last the most ? 
with cte as (
SELECT
    product,
    SUM(CASE WHEN year = '2021' THEN amount ELSE 0 END) AS y2021,
    SUM(CASE WHEN year = '2022' THEN amount ELSE 0 END) AS y2022,
    SUM(CASE WHEN year = '2023' THEN amount ELSE 0 END) AS y2023,
    SUM(CASE WHEN year = '2024' THEN amount ELSE 0 END) AS y2024,
    SUM(CASE WHEN year = '2025' THEN amount ELSE 0 END) AS y2025
FROM storage21_25clothes
GROUP BY rollup(product)
)
select 
	 c.product,
	 c.y2021,
	 c.y2022,
	 c.y2023,
	 c.y2024,
	 c.y2025
from cte c
order by c.y2021,c.y2022,c.y2023,c.y2024,c.y2025 desc
limit 3
;

-- quick overwiev according store 

select 
	sum(amount) as pocet,
	sum(price_buy) as value,
	storage
from storage21_25
where year = '2022' and amount > 0
group by storage;


select count(*),
	   sum(amount) as pocet,
	   creator
from storage17_20  
where amount > 0 
and datsave > datcreate 
and extract(year from datsave) = 2020
group by rollup(creator) ;


----------- terminal section -----------------

select  
	count(id_ct)
from card_transactions
where extract(year from time_date) = 2025
and terminal_code = '682071'
;

select  
	count(id_ct)
from card_transactions
where extract(year from time_date) = 2025
and terminal_code = '682076';

-- find out the number of recurring cards (customers)
select 
	count(card_number) as celkovy_pocet,
	count(distinct(card_number)) as jedinecne_pocet
from card_transactions ct ;


-- for all establishmenets
select count(*)
from (select
		  card_number
		  from card_transactions ct
		  group by card_number
		  having count(*) > 1
		);

-- for each establishment
select 
	count(*),
	terminal_code
from (select
		  card_number,
		  terminal_code,
		  extract(year from time_date)
		  from card_transactions ct
		  where extract(year from time_date) = 2025
		  group by card_number,terminal_code, extract(year from time_date)
		  having count(*) > 1
		)
group by terminal_code
		;



select * from card_transactions ct ;


-- terminal fees after sales

with costs_cte as (
select terminal_code,
	   extract(year from time_date) as year_cc,
	   sum(transaction_cost) as trans_cost,
	   sum(bank_cost) as bank_cost,
	   sum(card_cost) as card_cost,
	   sum(transaction_clear) as total_income_clear
from card_transactions ct 
group by terminal_code, extract(year from time_date)
)
select
	terminal_code,
	year_cc,
	(trans_cost + bank_cost + card_cost) as total_cost,
	total_income_clear
from costs_cte
order by year_cc
;



-- avg price on product

select * from reception;

select 
	  product,
	  round((sum(price_clean) / count(product)),2)
from reception sc 
group by product;


------------ specific products ---------------
-- shoes
  -- compare income vs outcome
with cte as (
select 
	   extract(year from datcreate) as year,
	   product,
	   count(*) as pocet_ks,
	   sum(price_netto) as revenue,
	   sum(dph) as dph  
from sales_final
where year in (2017,2018,2019,2020,2021,2022,2023,2024,2025) and product = 'Boty'
group by product,extract(year from datcreate)  
order by extract(year from datcreate) asc
),
cte2 as (
select
	  extract(year from r.date) as year,
	  sum(r.amount) as prijate_ks,
	  sum(r.price_buy) as costs
from reception r
where product = 'Boty' and amount > 0
group by extract(year from date)
)
select
	  c.*,
	  cc.*
from cte c
left join cte2 cc on c.year = cc.year
order by c.year asc
;

-- Find out how many shoes are left in the store at the end of the year

create temporary table shoestoragecheck as 
with cte as (
select 
	   extract(year from datcreate) as year,
	   product,
	   count(*) as pocet_ks,
	   sum(price_netto) as revenue,
	   sum(dph) as dph  
from sales_final
where year in (2017,2018,2019,2020,2021,2022,2023,2024,2025) and product = 'Boty'
group by product,extract(year from datcreate)  
order by extract(year from datcreate) asc
),
cte2 as (
select
	  extract(year from r.date) as year,
	  sum(r.amount) as prijate_ks,
	  sum(r.price_buy) as costs
from reception r
where product = 'Boty' and amount > 0
group by extract(year from date)
)
select
	  c.year,
	  c.pocet_ks as prodane,
	  cc.prijate_ks as prijate
from cte c
left join cte2 cc on c.year = cc.year
order by c.year asc
;

select 
    ssc.year,
    (ssc.prodane - ssc.prijate) as zustatek,
    (
        select sum(sc.amount)
        from storage21_25clothes sc
        where sc.amount > 0 
          and sc.product = 'Boty'
          and sc.year::numeric = ssc.year
    ) as sklad_za_rok
from shoestoragecheck ssc
order by ssc.year;


with cte1 as (
select 
	  sf.year,
	  sum(sf.price_netto) as prodej
from sales_final sf
where sf.brand = 'Olivia Shoes'
group by year
),
cte2 as (
select
	extract(year from date) as year,
	sum(price_buy) as prijem
from reception
where brand = 'Olivia Shoes'
group by extract(year from date)
)
select
	 c1.year,
	 c1.prodej,
	 c2.prijem
from cte1 c1
join cte2 c2 using(year)
;

-- NU

select * from reception r ;
with cte as (
select  
	 product,
	 sum(price_buy) as costs,
	 count(product) as prijate
from reception 
where brand = 'NÜ'
group by product 
),
cte2 as (
select
	  product,
	  sum(price_netto) as revenue,
	  count(product) as prodane
from sales_final
where brand = 'NÜ'
group by product
)
select
	 sf.product,
	 r.prijate,
	 r.costs,
	 sf.prodane,
	 sf.revenue
from cte2 sf
full join cte r on r.product = sf.product;


--

select
	  extract(month from ps.reciept_date) as month,
	  ci.establishment,
	  ifi.form_name,
	  sum(ps.price_netto) as revenue,
	  sum(ps.price_dph) as dph,
	  count(ps.price_netto),
	  rank()over(partition by ci.establishment order by count(ps.price_netto) asc) as rank
from p_sales_17_20_old ps
join creator_ids ci on ci.mark = ps.creator
join income_form_ids ifi on ifi.id_form = ps.form
where extract (year from ps.reciept_date) = 2018
group by ci.establishment,ifi.form_name,extract(month from ps.reciept_date)
order by month asc;


