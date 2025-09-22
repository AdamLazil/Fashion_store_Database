-- Terminals section

create table establishments_terminal_ids (
	id integer primary key generated always as identity,
	terminal_code varchar(10) not null unique,
	establishment text not null
);

insert into establishments_terminal_ids(terminal_code, establishment)
values (682071, 'Luhacovice'),
		(682076, 'Zlin'),
		(732406, 'Outlet');



create table card_transactions (
id_ct integer not null primary key generated always as identity,
card text,
time_date timestamp,
transaction decimal,
transaction_clear decimal(10,2),
transaction_cost decimal(10,4),
card_number varchar(20),
bank_cost decimal,
card_cost decimal,
region text,
currency text,
terminal_code varchar(10) references establishments_terminal_ids(terminal_code) 
);

drop table card_transactions;

copy card_transactions (
						card,
						time_date,
						transaction,
						transaction_clear,
						transaction_cost,
						card_number,
						bank_cost,
						card_cost,
						region,
						currency,
						terminal_code	
)
from 'C:\Program Files\PostgreSQL\17\data\TopFashion\dataUpload\transactions_transformed.csv'
with (format csv, header, delimiter ';');


-- Store section

create table creator_ids (
id_creator smallint not null,
mark varchar(2) unique,
establishment text
);

insert into creator_ids(id_creator, mark, establishment)
values (1,'t1','Zlin'),
		(2, 't2', 'Luhacovice'),
		(3, 't3', 'Butik'),
		(4,'@', 'Admin')
;

create table income_form_ids (
id_form smallint not null unique,
form_name text 
)
;

insert into income_form_ids (id_form, form_name)
values ('5', 'Card'),
		('2','Cash')
;


create table p_sales_17_20_old (
id smallint , -- join on sales products
form smallint, -- cash or card 
reciept_id varchar(10)primary key unique, -- join on movements table
notes text,
reciept_date date, -- creation
price_netto decimal(10,2),
price_dph decimal(10,2),
price_bruto integer,
price_check integer,
datcreate timestamp,
datsave timestamp,
ref_store smallint, -- store number
creator varchar(10),-- t1,t2,t3 @
foreign key (form)references income_form_ids(id_form),
foreign key (creator)references creator_ids(mark)
);
drop table p_sales_17_20_old;


create index idx_reciept_id on p_sales_17_20_old(reciept_id);
create index idx_form on p_sales_17_20_old(form);
create index idx_creator on p_sales_17_20_old(creator);

copy p_sales_17_20_old (
						id,
						form,
						reciept_id,
						notes,
						reciept_date,
						price_netto,
						price_dph,
						price_bruto,
						price_check,
						datcreate, 
						datsave,
						ref_store,
						creator
)
from 'C:\Program Files\PostgreSQL\17\data\TopFashion\mergedCleanToSql\prodej17_20test.csv'
with (format csv, header, delimiter ';',encoding 'win1250');

create table p_sales_20rest_new (
id smallint , -- join on sales products
form smallint, -- cash or card 
reciept_id varchar(10)primary key unique, -- join on movements table
notes text,
reciept_date date, -- creation
price_netto decimal(10,2),
price_dph decimal(10,2),
price_bruto integer,
price_check integer,
datcreate timestamp,
datsave timestamp,
ref_store smallint, -- store number
creator varchar(10),-- t1,t2,t3 @
foreign key (form)references income_form_ids(id_form),
foreign key (creator)references creator_ids(mark)
);

alter table p_sales_20rest_new
alter column price_bruto type decimal(10,2);

alter table p_sales_20rest_new
alter column price_check type decimal(10,2);

create index idx_reciept_id_20new on p_sales_20rest_new(reciept_id);
create index idx_form_20new on p_sales_20rest_new(form);
create index idx_creator_20new on p_sales_20rest_new(creator);

copy p_sales_20rest_new (
						id,
						form,
						reciept_id,
						notes,
						reciept_date,
						price_netto,
						price_dph,
						price_bruto,
						price_check,
						datcreate, 
						datsave,
						ref_store,
						creator
)
from 'C:\Program Files\PostgreSQL\17\data\TopFashion\mergedCleanToSql\prodej20_restClean.csv'
with (format csv, header, delimiter ';',encoding 'win1250');

select * from p_sales_20rest_new;

create table p_sales_21_25_new (
id smallint , -- join on sales products
form smallint, -- cash or card 
reciept_id varchar(10)primary key unique, -- join on movements table
notes text,
reciept_date date, -- creation
price_netto decimal(10,2),
price_dph decimal(10,2),
price_bruto decimal(10,2),
price_check decimal(10,2),
datcreate timestamp,
datsave timestamp,
ref_store smallint, -- store number
creator varchar(10),-- t1,t2,t3 @
foreign key (form)references income_form_ids(id_form),
foreign key (creator)references creator_ids(mark)
);

create index idx_reciept_id_21_25_new on p_sales_21_25_new(reciept_id);
create index idx_form_21_25_new on p_sales_21_25_new(form);
create index idx_creator_21_25_new on p_sales_21_25_new(creator);

copy p_sales_21_25_new (
						id,
						form,
						reciept_id,
						notes,
						reciept_date,
						price_netto,
						price_dph,
						price_bruto,
						price_check,
						datcreate, 
						datsave,
						ref_store,
						creator
)
from 'C:\Program Files\PostgreSQL\17\data\TopFashion\mergedCleanToSql\prodej21_25clean.csv'
with (format csv, header, delimiter ';',encoding 'win1250');

select * from p_sales_21_25_new;

select * from p_sales_17_20_old
where extract(year from reciept_date) = 2017
and extract(month from reciept_date)= 06;

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
where extract (year from ps.reciept_date) = 2020
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



