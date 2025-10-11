-- Analyze

-- Questions
  -- prijem zbozi
	 -- kolik bylo v jednotlivych letech naprijmano zbozi celkove ?
	 -- kolik kusu podle druhu zbozi ?
	 -- kolik kusu podle znacky ?



  -- prodej zbozi
	 -- kolik se prodalo v jednotlivych letech zbozi celkove ?
	 -- kolik kusu podle druhu zbozi ?
	 -- kolik kusu podle druhu znacky ?
     -- v jakem casovem rozmezi(podle hodin) jsou uskutecneny nejvetsi prodeje ?
	 -- v jakem obdobi se prodava nejmene (mesice) ?
	 -- podle velikosti ? 
	 -- nejprodavanejsi vec ?
     



-- 
select * from storage;
select * from movements_all ma ;

-- according datcreate
select 
	 sum(amount),
	 sum(buy),
	 sum(pricewage)
from(
	select sum(amount) as amount,
		   sum(price_buy) as buy,
		   sum(amount * price_buy) as pricewage
	from storage
	where extract(year from datcreate) = 2017 and creator in ('t1', 't2','t3') 
	group by amount, price_buy
	having amount > 0
	);

----
select sum(amount)
from(
	select * from "storage" s 
	where datcreate < '2017-12-31'
	and amount > 0);

--- remove duplicity values

start transaction;

with cte as (
select * 
from storage
where extract(year from datcreate) = extract(year from datsave )
)
select sum(cte.amount)
from cte
where cte.amount > 0 and extract(year from cte.datcreate) = 2021
;



-----

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

-- zjisti počet opakujících se karet(zákazníků)
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
select count(*),
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
;


---------- Storage

select 
	sum(amount),
	sum(price_buy),
	storage
from storage21_25
where year = '2021'
group by storage;


select count(*),
	   sum(amount) as pocet,
	   creator
from storage17_20  
where amount > 0 and extract(year from datcreate ) = 2017
group by rollup(creator) ;

------------
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
where product = 'Boty'
group by extract(year from date)
)
select
	  c.*,
	  cc.*
from cte c
left join cte2 cc on c.year = cc.year
order by c.year asc
;
