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

	
SELECT DISTINCT psi.ref_id
FROM p_sales_items_17_20_old psi
LEFT JOIN p_sales_17_20_old p ON psi.ref_id = p.id
WHERE p.id IS NULL
ORDER BY psi.ref_id;

select count(distinct(ref_id)) from p_sales_items_17_20_old;
select count(id) from p_sales_17_20_old;

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
drop table p_sales_items_20rest_new;
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

select * from p_sales_items_21_25_new;

select count(item_color_code)
from p_sales_items_21_25_new
where item_color_code is not null;


select count(distinct(item_color_code)) from p_sales_items_21_25_new;

