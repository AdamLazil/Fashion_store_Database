-- table for all items since 2017

start transaction;

create table storage (
id int primary key generated always as identity,
intern_id int,
refstorage smallint,
refstruct smallint,
refgroup int,
ids varchar(8),
ean varchar,
name varchar,
sttext varchar,
amount int,
price_buy int,
price_buy_waged int,
price_sell int,
price_sell_dph int,
currency text,
reltpfix smallint,
collection varchar, -- year of the collection
datcreate timestamp,
datsave timestamp,
marked varchar(3),
creator varchar(3) -- establishment and storage
);

create index ean_idx on storage(ean);



copy storage (
			intern_id,
			refstorage,
			refstruct,
			refgroup,
			ids,
			ean,
			name,
			sttext,
			amount,
			price_buy,
			price_buy_waged,
			price_sell,
			price_sell_dph,
			currency,
			reltpfix,
			collection, 
			datcreate,
			datsave,
			marked,
			creator )
from 'C:\Program Files\PostgreSQL\17\data\TopFashion\mergedCleanToSql\storageMerged.csv'
with (format csv, header, delimiter ';',encoding 'win1250');

commit;

alter table storage
rename to storage17_20;


start transaction;

delete from storage
where extract(year from datcreate) in (2021, 2022, 2023, 2024, 2025);

commit;
select * from "storage17_20" s ;


start transaction;

create table storage21_25 (
ids varchar(8),
ean varchar(25),
name varchar,
stext varchar,
price_buy int,
price_sell int,
price_sell_dph int,
amount smallint,
refstruct smallint,
storage text,
datcreate timestamp,
datsave timestamp,
year varchar(4)
);

copy storage21_25 (
			ids ,
			ean ,
			name ,
			stext ,
			price_buy ,
			price_sell ,
			price_sell_dph ,
			amount ,
			refstruct ,
			storage ,
			datcreate ,
			datsave ,
			year 
)
from 'C:\Program Files\PostgreSQL\17\data\TopFashion\mergedCleanToSql\storageMerged_21_25.csv'
with (format csv, header, delimiter ';',encoding 'win1250'); 

commit;