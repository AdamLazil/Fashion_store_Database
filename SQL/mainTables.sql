-- sales items tables
-- year 17 - 20 to month 09 old company

create table p_sales_items_17_20_old (
	id integer,
	ref_id integer,
	item_name varchar,
	item_code integer,
	item_color_code integer,
	price_brutto decimal(10,2),
	price_discount integer,
	price_netto decimal(10,2),
	price_dph decimal(10,2),
	price_brutto_bd decimal(10,2), -- price netto before discount 
	datcreate timestamp,
	datsave timestamp,
	foreign key (ref_id)references p_sales_17_20_old(id)
);

copy p_sales_items_17_20_old (
							id,
							ref_id,
							item_name,
							item_code,
							item_color_code,
							price_brutto,
							price_discount,
							price_netto,
							price_dph,
							price_brutto_bd,  
							datcreate,
							datsave							
)
from 'C:\Program Files\PostgreSQL\17\data\TopFashion\mergedCleanToSql\prodejpol17_20clean.csv'
with(format csv, header, delimiter ';', encoding 'win1250');

	


-- year 2020 from month 10 new company 

create table p_sales_items_20rest_new (
	id integer,
	ref_id integer,
	item_name varchar,
	item_code integer,
	item_color_code integer,
	price_brutto decimal(10,2),
	price_discount integer,
	price_netto decimal(10,2),
	price_dph decimal(10,2),
	price_brutto_bd decimal(10,2), -- price netto before discount 
	datcreate timestamp,
	datsave timestamp,
	foreign key (ref_id)references p_sales_20rest_new(id)
);

copy p_sales_items_20rest_new (
							id,
							ref_id,
							item_name,
							item_code,
							item_color_code,
							price_brutto,
							price_discount,
							price_netto,
							price_dph,
							price_brutto_bd,  
							datcreate,
							datsave							
)
from 'C:\Program Files\PostgreSQL\17\data\TopFashion\mergedCleanToSql\prodejpol20_restclean.csv'
with(format csv, header, delimiter ';', encoding 'win1250');

-- year 21 - 25 to month 09 new company

create table p_sales_items_21_25_new (
	id integer,
	ref_id integer,
	item_name varchar,
	item_code integer,
	item_color_code integer,
	price_brutto decimal(10,2),
	price_discount integer,
	price_netto decimal(10,2),
	price_dph decimal(10,2),
	price_brutto_bd decimal(10,2), -- price netto before discount 
	datcreate timestamp,
	datsave timestamp,
	foreign key (ref_id)references p_sales_21_25_new(id)
);

copy p_sales_items_21_25_new (
							id,
							ref_id,
							item_name,
							item_code,
							item_color_code,
							price_brutto,
							price_discount,
							price_netto,
							price_dph,
							price_brutto_bd,  
							datcreate,
							datsave							
)
from 'C:\Program Files\PostgreSQL\17\data\TopFashion\mergedCleanToSql\prodejpol21_25clean.csv'
with(format csv, header, delimiter ';', encoding 'win1250');




-- movement table

create table movements_all (
form_code smallint,
form_name text,
group_code smallint,
group_name varchar(10),
establishment text,
ids_type int, -- mainly for brand st,c
ean_code bigint,
product_name varchar,
ids_color varchar, -- code for colors
movement_code smallint,
movement_name text,
date timestamp, -- include wrong data. Musst be join to the reciept_date
amount int,
price_clean decimal(10,2),
price_buy decimal(10,2),
amount_left int,
reciept_id varchar(15), -- connection for other tables
control_type text, -- type of clothes for ST,C for control purpase
name_norm text,
brand text,
product_norm text, -- control value for code
clothes_code smallint
);


alter table movements_all
add constraint clothes
foreign key(clothes_code) references clothes_code(code);

delete from movements_all 
where clothes_code =13;


copy movements_all
from 'C:\Program Files\PostgreSQL\17\data\TopFashion\mergedCleanToSql\item_movements_ver.csv'
with (format csv, header, delimiter ';', encoding 'win1250');


select * from movements_all ma
where clothes_code = 13;




