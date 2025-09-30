-- ids list of clothing items

create table clothes_code (
 id integer  generated always as identity primary key,
 product text,
 code integer unique not null
);

insert into clothes_code(product, code)
values
	   ('Kabelka', 1),
	   ('Taska', 2),
		('Darkovy poukaz', 3),
		('Kabat', 10),
		('Saty', 14),
		('Bunda', 20),
		('Blazer/sako/kosile', 21),
		('Vesta', 22),
		('Mikina/Svetr/Cardigan', 25),
		('Svetr/Pullover', 30),
		('Triko', 31),
		('Triko/Top', 32),
		('Halenka/Tunika', 34),
		('Sukne', 36),
	   ('Kalhoty/Jeans', 37),
	   ('Satek', 57),
	   ('Poncho', 58),
	   ('Penezenka', 971),
	   ('Kufr', 972),
	   ('Pasek', 973),
	   ('Destnik', 974),
	   ('Sala', 975),
	   ('Siltovka', 976),
	   ('Ledvinka', 977),
	   ('Klobouk', 978),
	   ('Bizuterie', 979),
	   ('Batoh', 980),
	   ('Cepice', 981),
	   ('Pasky', 982),
	   ('Rukavice', 983),
	   ('Plavky', 984),
	   ('Kratasy', 985),
	   ('Teplaky', 986),
	   ('Boty', 987)
	 ;
	   
	 select * from clothes_code cc   
	   
	   
	   
	   
	   
	   

