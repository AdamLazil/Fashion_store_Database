
-- analyze

-- Table or view only for prijem 



create materialized view reception as
	select
		 m.group_name,
		 m.establishment,
		 m.ean_code,
		 m.ids_color,
		 m.date,
		 m.amount,
		 m.price_clean,
		 m.price_buy,
		 m.amount_left,
		 m.reciept_id,
		 m.brand,
		 cc.product
	from movements_all m
	join clothes_code cc on m.clothes_code = cc.code
    where m.form_code = 6; 

SELECT * FROM reception;


-----
select * from p_sales_17_20_old pso; -- form, reciept_id, reciept_date, creator,datcreate,datsave
select * from p_sales_items_17_20_old psio; -- id, ref_id, item_name, price_brutto, price_discount, price_netto,price_dph,price_brutto_bd,
select * from p_sales_items_20rest_new psirn ;
select * from p_sales_items_21_25_new psin ;

create view sales_merged as
select
	 psc.form,
	 psc.reciept_id as reciept,
	 psic.item_name as name,
	 psc.reciept_date as date,
	 psc.creator as establishmnet,
	 psic.price_discount as discount,
	 psic.price_brutto,
	 psic.price_netto,
	 psic.price_dph as dph,
	 psic.price_brutto_bd,
	 psc.datcreate,
	 psc.datsave,
	 extract(year from psc.reciept_date) as year
from p_sales_items_17_20_old psic
join p_sales_17_20_old psc on psc.id = psic.ref_id 
union 
select
	 psr.form,
	 psr.reciept_id as reciept,
	 psir.item_name as name,
	 psr.reciept_date as date,
	 psr.creator as establishmnet,
	 psir.price_discount as discount,
	 psir.price_brutto,
	 psir.price_netto,
	 psir.price_dph as dph,
	 psir.price_brutto_bd,
	 psr.datcreate,
	 psr.datsave,
	 extract(year from psr.reciept_date) as year
from p_sales_items_20rest_new psir
join p_sales_20rest_new psr on psr.id = psir.ref_id
union 
select
     psn.form,
	 psn.reciept_id as reciept,
	 psin.item_name as name,
	 psn.reciept_date as date,
	 psn.creator as establishmnet,
	 psin.price_discount as discount,
	 psin.price_brutto,
	 psin.price_netto,
	 psin.price_dph as dph,
	 psin.price_brutto_bd,
	 psn.datcreate,
	 psn.datsave,
	 extract(year from psn.reciept_date) as year
from p_sales_items_21_25_new psin 
join p_sales_21_25_new psn  on psn.id = psin.ref_id;

drop view sales_merged;


------ view storage with clothes code



start transaction;

create view storage21_25clothes as 
SELECT 
    s.*,
    cc.product,
    ma.brand
FROM storage21_25 s
INNER JOIN (
    SELECT DISTINCT ean_code, 
    				clothes_code, 
    				brand
    FROM movements_all
) ma 
    ON CAST(ma.ean_code AS varchar) = s.ean
join clothes_code cc on cc.code = ma.clothes_code;

select * from storage21_25clothes;

commit;


select 
	 sum(amount) as pocet,
	 product as product
from storage21_25clothes sc 
where year = '2024'
group by product;


------- table sales final

create table sales_final as
select 
 	  sm.*,
 	  ma.establishment,
 	  ma.brand,
 	  cc.product,
 	  ma.group_name
from sales_merged sm
left join movements_all ma on ma.reciept_id = sm.reciept and
	 sm.name = ma.product_name
left join clothes_code cc on cc.code = ma.clothes_code
where ma.form_code = 10 or ma.form_code is null;

alter table sales_final
rename column establishmnet to store;



----------

select 
	   extract(year from datcreate) as year,
	   product,
	   count(*) as pocet_ks,
	   sum(price_netto) as revenue,
	   sum(dph) as dph  
from sales_final
where year in (2017,2018,2019,2020,2021,2022,2023,2024,2025) and product = 'Boty'
group by product,extract(year from datcreate)  
order by extract(year from datcreate) asc;

select brand,
	   count(*),
	   sum(price_netto),
	   sum(dph)   
from sales_final
where year = 2024 and establishmnet = 't2'
group by rollup (brand);



---- How much of products ware recepted since inception
select product,
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
--where establishment = 'Luhacovice' or establishment = 'Luhačovice'
group by rollup(product);
------- according brand
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
group by brand;

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
group by product;











