#use database to avoid writing it as prefix before every table
#example : use '{DB_NAME}'
use mydb;

set foreign_key_checks = 0;

truncate table routes;
truncate table passenger_transport;
truncate table other_transport;
truncate table cargo_transport;
truncate table drivers;
truncate table assigned_drivers;
truncate table locksmith;
truncate table welders;
truncate table tech_support;
truncate table storage_manager;
truncate table department_manager;
truncate table site_manager;
truncate table masters;
truncate table brigades;
truncate table passenger_routes;
truncate table cargo_routes;

#delete all content in all tables for correct data init

truncate table global_employee_register;
truncate table global_transport_register;
truncate table daily_activity_register;
truncate table repair_register;
truncate table estate;
truncate table assigned_vehicles;


#reseting auto increment value to default
ALTER TABLE global_employee_register AUTO_INCREMENT = 1;
ALTER TABLE global_transport_register AUTO_INCREMENT = 1;
ALTER TABLE daily_activity_register AUTO_INCREMENT = 1;
ALTER TABLE repair_register AUTO_INCREMENT = 1;
ALTER TABLE estate AUTO_INCREMENT = 1;
ALTER TABLE routes AUTO_INCREMENT = 1;
ALTER TABLE passenger_transport AUTO_INCREMENT = 1;
ALTER TABLE other_transport AUTO_INCREMENT = 1;
ALTER TABLE cargo_transport AUTO_INCREMENT = 1;
ALTER TABLE drivers AUTO_INCREMENT = 1;
ALTER TABLE assigned_drivers AUTO_INCREMENT = 1;
ALTER TABLE locksmith AUTO_INCREMENT = 1;
ALTER TABLE welders AUTO_INCREMENT = 1;
ALTER TABLE tech_support AUTO_INCREMENT = 1;
ALTER TABLE storage_manager AUTO_INCREMENT = 1;
ALTER TABLE department_manager AUTO_INCREMENT = 1;
ALTER TABLE site_manager AUTO_INCREMENT = 1;
ALTER TABLE masters AUTO_INCREMENT = 1;
ALTER TABLE brigades AUTO_INCREMENT = 1;
ALTER TABLE assigned_vehicles AUTO_INCREMENT = 1;

drop function if exists verbose_time_interval;
delimiter $$

create function mydb.verbose_time_interval(per_begin DATE, per_end DATE)
returns varchar(15) deterministic
begin
set @date_day_difference = timestampdiff(day, per_begin, per_end);

return
	case 
		when @date_day_difference > 365 then concat(floor(@date_day_difference / 365), ' years'  )
        when @date_day_difference = 365 then concat(floor(@date_day_difference / 365), ' year'   )
        when @date_day_difference > 31  then concat(floor(@date_day_difference / 31 ), ' months' )
        when @date_day_difference = 31  then concat(floor(@date_day_difference / 31 ), ' month'  )
        when @date_day_difference > 7   then concat(floor(@date_day_difference / 7  ), ' weeks'  )
        when @date_day_difference = 7   then concat(floor(@date_day_difference / 7  ), ' week'   )
        when @date_day_difference < 7   then concat(@date_day_difference, 'days')
    end ;

end$$

delimiter ;

delimiter $$

create function is_head(proffession VARCHAR(45))
returns BOOL deterministic
begin
set @flag = false;
case 
	when proffession in ('department_manager', 'site_manager', 'master', 'brigadier') then set @flag = true;
    when proffession not in ('department_manager', 'site_manager', 'master', 'brigadier') then set @flag = false;
end case;

return @flag;
end$$

delimiter ;

#create data
#note: order of tables is important (u can change places only of insertions to global registers)
#      repair and action registers filling only at the end

#vehicle_purpose is enum : 
# B - bus , R - route taxi , T - taxi, C - cargo truck, O - other

#global_id : 1 - 10
insert into global_transport_register values 
(NULL, 'AA-5788-BA', 'Bohdan', 'YellowMarshrutka', 'R', '2021-09-01 15:38:48', NULL),
(NULL, 'AA-5887-BB', 'Bohdan', 'YellowMarshrutka', 'R', '2021-09-01 15:39:00', NULL),
(NULL, 'AA-5986-BC', 'Bohdan', 'YellowMarshrutka', 'R', '2021-09-01 15:39:12', NULL),
(NULL, 'AA-5085-BE', 'Bohdan', 'YellowMarshrutka', 'R', '2021-09-01 15:39:24', NULL),
(NULL, 'AA-5184-BH', 'Bohdan', 'YellowMarshrutka', 'R', '2021-09-01 15:39:36', NULL),
(NULL, 'AA-5283-BI', 'Bohdan', 'YellowMarshrutka', 'R', '2021-09-01 15:39:48', NULL),
(NULL, 'AA-5382-BK', 'Bohdan', 'YellowMarshrutka', 'R', '2021-09-01 15:40:00', NULL),
(NULL, 'AA-5481-BM', 'Bohdan', 'YellowMarshrutka', 'R', '2021-09-01 15:40:13', NULL),
(NULL, 'AA-5580-BO', 'Bohdan', 'YellowMarshrutka', 'R', '2021-09-01 15:40:26', NULL),
(NULL, 'AA-5689-BP', 'Bohdan', 'YellowMarshrutka', 'R', '2021-09-01 15:40:39', NULL);

#global_id : 11 - 20
insert into global_transport_register values 
(NULL, 'AA-2788-BA', 'Toyota', 'Prius', 'T', '2021-09-02 15:38:48', NULL),
(NULL, 'AA-2887-BB', 'Toyota', 'Prius', 'T', '2021-09-02 15:39:00', NULL),
(NULL, 'AA-2986-BC', 'Toyota', 'Prius', 'T', '2021-09-02 15:39:12', NULL),
(NULL, 'AA-2085-BE', 'Toyota', 'Prius', 'T', '2021-09-02 15:39:24', NULL),
(NULL, 'AA-2184-BH', 'Toyota', 'Prius', 'T', '2021-09-02 15:39:36', NULL),
(NULL, 'AA-2283-BI', 'Toyota', 'Prius', 'T', '2021-09-02 15:39:48', NULL),
(NULL, 'AA-2382-BK', 'Toyota', 'Prius', 'T', '2021-09-02 15:40:00', NULL),
(NULL, 'AA-2481-BM', 'Toyota', 'Prius', 'T', '2021-09-02 15:40:13', NULL),
(NULL, 'AA-2580-BO', 'Toyota', 'Prius', 'T', '2021-09-02 15:40:26', NULL),
(NULL, 'AA-2689-BP', 'Toyota', 'Prius', 'T', '2021-09-02 15:40:39', NULL);

#global_id : 21 - 30
insert into global_transport_register values 
(NULL, 'AA-8788-BA', 'Ikarus', 'Kubik', 'B', '2021-09-03 15:38:48', NULL),
(NULL, 'AA-8887-BB', 'Ikarus', 'Kubik', 'B', '2021-09-03 15:39:00', NULL),
(NULL, 'AA-8986-BC', 'Ikarus', 'Kubik', 'B', '2021-09-03 15:39:12', NULL),
(NULL, 'AA-8085-BE', 'Ikarus', 'Kubik', 'B', '2021-09-03 15:39:24', NULL),
(NULL, 'AA-8184-BH', 'Ikarus', 'Kubik', 'B', '2021-09-03 15:39:36', NULL),
(NULL, 'AA-8283-BI', 'Ikarus', 'Kubik', 'B', '2021-09-03 15:39:48', NULL),
(NULL, 'AA-8382-BK', 'Ikarus', 'Kubik', 'B', '2021-09-03 15:40:00', NULL),
(NULL, 'AA-8481-BM', 'Ikarus', 'Kubik', 'B', '2021-09-03 15:40:13', NULL),
(NULL, 'AA-8580-BO', 'Ikarus', 'Kubik', 'B', '2021-09-03 15:40:26', NULL),
(NULL, 'AA-8689-BP', 'Ikarus', 'Kubik', 'B', '2021-09-03 15:40:39', NULL);

#global_id : 31 - 40
insert into global_transport_register values 
(NULL, 'AA-0788-BA', 'BelAZ', 'Gruzovik', 'C', '2021-09-04 15:38:48', NULL),
(NULL, 'AA-0887-BB', 'BelAZ', 'Gruzovik', 'C', '2021-09-04 15:39:00', NULL),
(NULL, 'AA-0986-BC', 'BelAZ', 'Gruzovik', 'C', '2021-09-04 15:39:12', NULL),
(NULL, 'AA-0085-BE', 'BelAZ', 'Gruzovik', 'C', '2021-09-04 15:39:24', NULL),
(NULL, 'AA-0184-BH', 'BelAZ', 'Gruzovik', 'C', '2021-09-04 15:39:36', NULL),
(NULL, 'AA-0283-BI', 'BelAZ', 'Gruzovik', 'C', '2021-09-04 15:39:48', NULL),
(NULL, 'AA-0382-BK', 'BelAZ', 'GruzovikR', 'C', '2021-09-04 15:40:00', NULL),
(NULL, 'AA-0481-BM', 'BelAZ', 'Gruzovik', 'C', '2021-09-04 15:40:13', NULL),
(NULL, 'AA-0580-BO', 'BelAZ', 'Gruzovik', 'C', '2021-09-04 15:40:26', NULL),
(NULL, 'AA-0689-BP', 'BelAZ', 'Gruzovik', 'C', '2021-09-04 15:40:39', NULL);

#other vehicles used by company owners and their families ( we r trully Ukainian company )
#global_id : 41 - 46
insert into global_transport_register values 
(NULL, 'AA-0001-AA', 'Land Rover', 'Range Rover SVR', 'O', '2021-08-31 15:38:48', NULL),
(NULL, 'AA-1111-BB', 'Mersedes', 'E63 AMG 2020', 'O', '2021-09-01 15:39:00', NULL),
(NULL, 'AA-7777-CC', 'Mersedes', 'G63 AMG 2020', 'O', '2021-09-02 15:39:12', NULL),
(NULL, 'II-1001-II', 'Lexus', 'LC500', 'O', '2021-09-03 15:39:24', NULL),
(NULL, 'KA-1111-AK', 'Mersedes', 'G63 AMG 2020', 'O', '2021-09-05 15:39:36', NULL),
(NULL, 'AA-1234-BC', 'Land Rover', 'Range Rover Evoque', 'O', '2021-09-07 15:39:48', NULL);

#debug point
#select * from global_transport_register;

insert into passenger_transport values
(NULL, 'route_taxi', 31, 1),
(NULL, 'route_taxi', 30, 2),
(NULL, 'route_taxi', 32, 3),
(NULL, 'route_taxi', 33, 4),
(NULL, 'route_taxi', 29, 5),
(NULL, 'route_taxi', 28, 6),
(NULL, 'route_taxi', 30, 7),
(NULL, 'route_taxi', 31, 8),
(NULL, 'route_taxi', 33, 9),
(NULL, 'route_taxi', 30, 10);

insert into passenger_transport values
(NULL, 'taxi', 4, 11),
(NULL, 'taxi', 4, 12),
(NULL, 'taxi', 4, 13),
(NULL, 'taxi', 4, 14),
(NULL, 'taxi', 4, 15),
(NULL, 'taxi', 4, 16),
(NULL, 'taxi', 4, 17),
(NULL, 'taxi', 4, 18),
(NULL, 'taxi', 4, 19),
(NULL, 'taxi', 4, 20);

insert into passenger_transport values
(NULL, 'bus', 50, 21),
(NULL, 'bus', 49, 22),
(NULL, 'bus', 48, 23),
(NULL, 'bus', 47, 24),
(NULL, 'bus', 51, 25),
(NULL, 'bus', 53, 26),
(NULL, 'bus', 50, 27),
(NULL, 'bus', 50, 28),
(NULL, 'bus', 51, 29),
(NULL, 'bus', 51, 30);

#debug point
#select * from passenger_transport;

insert into cargo_transport values
(NULL, 4000, 31),
(NULL, 4000, 32),
(NULL, 4000, 33),
(NULL, 4000, 34),
(NULL, 4000, 35),
(NULL, 4000, 36),
(NULL, 4000, 37),
(NULL, 4000, 38),
(NULL, 4000, 39),
(NULL, 4000, 40);

#debug point
#select * from cargo_transport;

insert into other_transport values
(NULL, 41),
(NULL, 42),
(NULL, 43),
(NULL, 44),
(NULL, 45),
(NULL, 46);

#debug point
#select * from other_transport;
insert into routes values
(NULL, 13, 'route_13', 26, 'passenger'),
(NULL, 14, 'route_14', 28, 'passenger'),
(NULL, 46, 'route_46', 92, 'passenger'),
(NULL, 69, 'route_69', 138, 'passenger'),
(NULL, 124, 'route_124', 248, 'passenger'),
(NULL, 389, 'route_389', 778, 'passenger'),
(NULL, 491, 'route_491', 982, 'passenger'),
(NULL, 522, 'route_522', 1044, 'passenger'),
(NULL, 1, 'route_1', 500, 'cargo'),
(NULL, 2, 'route_2', 765, 'cargo');


insert into passenger_routes values
(6, 1, 1),
(6, 3, 3),
(6, 4, 4),
(7, 2, 2),
(7, 5, 5),
(8, 6, 6),
(8, 7, 7),
(8, 8, 8),
(5, 9, 9),
(5, 10, 10);

insert into passenger_routes values
(4, 21, 21),
(4, 23, 23),
(4, 24, 24),
(2, 22, 22),
(2, 25, 25),
(1, 26, 26),
(1, 27, 27),
(1, 28, 28),
(3, 29, 29),
(3, 30, 30);

insert into cargo_routes values
(9, 4,34),
(10, 5, 35);


#debug point
#select * from passanger_routes;

#global-ids : 1 - 23
insert into global_employee_register values
(NULL, 'Nikolay', 'Azarov', 'Yanovich', '73', '2014-02-22 00:00:00', 'department_manager', NULL),
(NULL, 'Yulia', 'Timoshenko', 'Vladimirovna', '60', '2016-05-21 00:00:00', 'department_manager', NULL),
(NULL, 'David', 'Arahmiya', 'Georgievich', '42', '2021-08-13 00:00:00', 'site_manager', 1),
(NULL, 'Vladimir', 'Rybak', 'Vasylievich', '74', '2014-02-22 00:00:00', 'site_manager', 1),
(NULL, 'Arseniy', 'Yatseniuk', 'Petrovich', '46', '2015-06-21 00:00:00', 'site_manager', 2),
(NULL, 'Alex', 'Zabrak', NULL, '21', '2014-02-22 00:00:00', 'master', 3),
(NULL, 'Boris', 'Ywleev', NULL, '23', '2014-02-22 00:00:00', 'master', 3),
(NULL, 'Charlie', 'Xerxs', NULL, '20', '2014-02-22 00:00:00', 'master', 4),
(NULL, 'Dmitry', 'Wolovets', NULL, '28', '2014-02-22 00:00:00', 'master', 5),
(NULL, 'Egor', 'Vardanov', NULL, '25', '2014-02-22 00:00:00', 'master', 5),
(NULL, 'Farrid', 'Uhram', NULL, '31', '2014-02-22 00:00:00', 'master', 5),
(NULL, 'George', 'Talov', NULL, '41', '2014-02-22 00:00:00', 'brigadir', 6),
(NULL, 'Howard', 'Septim', NULL, '27', '2014-02-22 00:00:00', 'brigadir', 6),
(NULL, 'Igor', 'Ryazanov', NULL, '25', '2014-02-22 00:00:00', 'brigadir', 7),
(NULL, 'Jimmy', 'Quatar', NULL, '23', '2014-02-22 00:00:00', 'brigadir', 7),
(NULL, 'Kamal', 'Palshi', NULL, '24', '2014-02-22 00:00:00', 'brigadir', 8),
(NULL, 'Lev', 'Ohripov', NULL, '22', '2014-02-22 00:00:00', 'brigadir', 8),
(NULL, 'Mitrandir', 'Navie', NULL, '25', '2014-02-22 00:00:00', 'brigadir', 8),
(NULL, 'Nil', 'Milovanov', NULL, '27', '2014-02-22 00:00:00', 'brigadir', 9),
(NULL, 'Opra', 'Levshin', NULL, '28', '2014-02-22 00:00:00', 'brigadir', 10),
(NULL, 'Pavel', 'Kalisto', NULL, '24', '2014-02-22 00:00:00', 'brigadir', 10),
(NULL, 'Quom', 'Jilli', NULL, '27', '2014-02-22 00:00:00', 'brigadir', 11),
(NULL, 'Ravesh', 'Ifrim', NULL, '20', '2014-02-22 00:00:00', 'brigadir', 11);

#global-ids : 24 - 53
insert into global_employee_register values
(NULL, 'driver_1', 'driver__1', 'driver___1', '1', '1970-01-01 00:00:00', 'driver', 12),
(NULL, 'driver_2', 'driver__2', 'driver___2', '3', '1970-01-01 00:00:00', 'driver', 12),
(NULL, 'driver_3', 'driver__3', 'driver___3', '6', '1970-01-01 00:00:00', 'driver', 12),
(NULL, 'driver_4', 'driver__4', 'driver___4', '9', '1970-01-01 00:00:00', 'driver', 13),
(NULL, 'driver_5', 'driver__5', 'driver___5', '12', '1970-01-01 00:00:00', 'driver', 13),
(NULL, 'driver_6', 'driver__6', 'driver___6', '15', '1970-01-01 00:00:00', 'driver', 13),
(NULL, 'driver_7', 'driver__7', 'driver___7', '18', '1970-01-01 00:00:00', 'driver', 14),
(NULL, 'driver_8', 'driver__8', 'driver___8', '21', '1970-01-01 00:00:00', 'driver', 14),
(NULL, 'driver_9', 'driver__9', 'driver___9', '24', '1970-01-01 00:00:00', 'driver', 15),
(NULL, 'driver_10', 'driver__10', 'driver___10', '27', '1970-01-01 00:00:00', 'driver', 15),
(NULL, 'driver_11', 'driver__11', 'driver___11', '30', '1970-01-01 00:00:00', 'driver', 16),
(NULL, 'driver_12', 'driver__12', 'driver___12', '33', '1970-01-01 00:00:00', 'driver', 16),
(NULL, 'driver_13', 'driver__13', 'driver___13', '36', '1970-01-01 00:00:00', 'driver', 17),
(NULL, 'driver_14', 'driver__14', 'driver___14', '39', '1970-01-01 00:00:00', 'driver', 17),
(NULL, 'driver_15', 'driver__15', 'driver___15', '42', '1970-01-01 00:00:00', 'driver', 18),
(NULL, 'driver_16', 'driver__16', 'driver___16', '45', '1970-01-01 00:00:00', 'driver', 18),
(NULL, 'driver_17', 'driver__17', 'driver___17', '48', '1970-01-01 00:00:00', 'driver', 19),
(NULL, 'driver_18', 'driver__18', 'driver___18', '51', '1970-01-01 00:00:00', 'driver', 19),
(NULL, 'driver_19', 'driver__19', 'driver___19', '54', '1970-01-01 00:00:00', 'driver', 20),
(NULL, 'driver_20', 'driver__20', 'driver___20', '57', '1970-01-01 00:00:00', 'driver', 20),
(NULL, 'driver_21', 'driver__21', 'driver___21', '60', '1970-01-01 00:00:00', 'driver', 21),
(NULL, 'driver_22', 'driver__22', 'driver___22', '63', '1970-01-01 00:00:00', 'driver', 21),
(NULL, 'driver_23', 'driver__23', 'driver___23', '66', '1970-01-01 00:00:00', 'driver', 21),
(NULL, 'driver_24', 'driver__24', 'driver___24', '69', '1970-01-01 00:00:00', 'driver', 22),
(NULL, 'driver_25', 'driver__25', 'driver___25', '72', '1970-01-01 00:00:00', 'driver', 22),
(NULL, 'driver_26', 'driver__26', 'driver___26', '75', '1970-01-01 00:00:00', 'driver', 22),
(NULL, 'driver_27', 'driver__27', 'driver___27', '78', '1970-01-01 00:00:00', 'driver', 23),
(NULL, 'driver_28', 'driver__28', 'driver___28', '81', '1970-01-01 00:00:00', 'driver', 23),
(NULL, 'driver_29', 'driver__29', 'driver___29', '84', '1970-01-01 00:00:00', 'driver', 15),
(NULL, 'driver_30', 'driver__30', 'driver___30', '87', '1970-01-01 00:00:00', 'driver', 16);

#global-ids : 54 - 65 
insert into global_employee_register values
(NULL, 'welder_1' , NULL, NULL, '1' , '1970-01-01 00:00:00', 'welder', 12),
(NULL, 'welder_2' , NULL, NULL, '3' , '1970-01-01 00:00:00', 'welder', 13),
(NULL, 'welder_3' , NULL, NULL, '5' , '1970-01-01 00:00:00', 'welder', 14),
(NULL, 'welder_4' , NULL, NULL, '7' , '1970-01-01 00:00:00', 'welder', 15),
(NULL, 'welder_5' , NULL, NULL, '11', '1970-01-01 00:00:00', 'welder', 16),
(NULL, 'welder_6' , NULL, NULL, '13', '1970-01-01 00:00:00', 'welder', 17),
(NULL, 'welder_7' , NULL, NULL, '17', '1970-01-01 00:00:00', 'welder', 18),
(NULL, 'welder_8' , NULL, NULL, '19', '1970-01-01 00:00:00', 'welder', 19),
(NULL, 'welder_9' , NULL, NULL, '23', '1970-01-01 00:00:00', 'welder', 20),
(NULL, 'welder_10', NULL, NULL, '29', '1970-01-01 00:00:00', 'welder', 21),
(NULL, 'welder_11', NULL, NULL, '31', '1970-01-01 00:00:00', 'welder', 22),
(NULL, 'welder_12', NULL, NULL, '37', '1970-01-01 00:00:00', 'welder', 23);

#global-ids : 66 - 77 
insert into global_employee_register values
(NULL, 'locksmith_1' , NULL, NULL, '0' , '1970-01-01 00:00:00', 'locksmith', 12),
(NULL, 'locksmith_2' , NULL, NULL, '1' , '1970-01-01 00:00:00', 'locksmith', 13),
(NULL, 'locksmith_3' , NULL, NULL, '1' , '1970-01-01 00:00:00', 'locksmith', 14),
(NULL, 'locksmith_4' , NULL, NULL, '2' , '1970-01-01 00:00:00', 'locksmith', 15),
(NULL, 'locksmith_5' , NULL, NULL, '3' , '1970-01-01 00:00:00', 'locksmith', 16),
(NULL, 'locksmith_6' , NULL, NULL, '5' , '1970-01-01 00:00:00', 'locksmith', 17),
(NULL, 'locksmith_7' , NULL, NULL, '8' , '1970-01-01 00:00:00', 'locksmith', 18),
(NULL, 'locksmith_8' , NULL, NULL, '13', '1970-01-01 00:00:00', 'locksmith', 19),
(NULL, 'locksmith_9' , NULL, NULL, '21', '1970-01-01 00:00:00', 'locksmith', 20),
(NULL, 'locksmith_10', NULL, NULL, '34', '1970-01-01 00:00:00', 'locksmith', 21),
(NULL, 'locksmith_11', NULL, NULL, '55', '1970-01-01 00:00:00', 'locksmith', 22),
(NULL, 'locksmith_12', NULL, NULL, '89', '1970-01-01 00:00:00', 'locksmith', 23);

#global-ids : 78 - 89 
insert into global_employee_register values
(NULL, 'tech_support_1' , NULL, NULL, '1'   , '1970-01-01 00:00:00', 'tech_support', 12),
(NULL, 'tech_support_2' , NULL, NULL, '2'   , '1970-01-01 00:00:00', 'tech_support', 13),
(NULL, 'tech_support_3' , NULL, NULL, '4'   , '1970-01-01 00:00:00', 'tech_support', 14),
(NULL, 'tech_support_4' , NULL, NULL, '8'   , '1970-01-01 00:00:00', 'tech_support', 15),
(NULL, 'tech_support_5' , NULL, NULL, '16'  , '1970-01-01 00:00:00', 'tech_support', 16),
(NULL, 'tech_support_6' , NULL, NULL, '32'  , '1970-01-01 00:00:00', 'tech_support', 17),
(NULL, 'tech_support_7' , NULL, NULL, '64'  , '1970-01-01 00:00:00', 'tech_support', 18),
(NULL, 'tech_support_8' , NULL, NULL, '128' , '1970-01-01 00:00:00', 'tech_support', 19),
(NULL, 'tech_support_9' , NULL, NULL, '256' , '1970-01-01 00:00:00', 'tech_support', 20),
(NULL, 'tech_support_10', NULL, NULL, '512' , '1970-01-01 00:00:00', 'tech_support', 21),
(NULL, 'tech_support_11', NULL, NULL, '1024', '1970-01-01 00:00:00', 'tech_support', 22),
(NULL, 'tech_support_12', NULL, NULL, '2048', '1970-01-01 00:00:00', 'tech_support', 23);

#global-ids : 90 - 101 
insert into global_employee_register values
(NULL, 'storage_manager_1' , NULL, NULL, '001', '1970-01-01 00:00:00', 'storage_manager', 12),
(NULL, 'storage_manager_2' , NULL, NULL, '002', '1970-01-01 00:00:00', 'storage_manager', 13),
(NULL, 'storage_manager_3' , NULL, NULL, '010', '1970-01-01 00:00:00', 'storage_manager', 14),
(NULL, 'storage_manager_4' , NULL, NULL, '011', '1970-01-01 00:00:00', 'storage_manager', 15),
(NULL, 'storage_manager_5' , NULL, NULL, '012', '1970-01-01 00:00:00', 'storage_manager', 16),
(NULL, 'storage_manager_6' , NULL, NULL, '020', '1970-01-01 00:00:00', 'storage_manager', 17),
(NULL, 'storage_manager_7' , NULL, NULL, '021', '1970-01-01 00:00:00', 'storage_manager', 18),
(NULL, 'storage_manager_8' , NULL, NULL, '022', '1970-01-01 00:00:00', 'storage_manager', 19),
(NULL, 'storage_manager_9' , NULL, NULL, '100', '1970-01-01 00:00:00', 'storage_manager', 20),
(NULL, 'storage_manager_10', NULL, NULL, '101', '1970-01-01 00:00:00', 'storage_manager', 21),
(NULL, 'storage_manager_11', NULL, NULL, '102', '1970-01-01 00:00:00', 'storage_manager', 22),
(NULL, 'storage_manager_12', NULL, NULL, '110', '1970-01-01 00:00:00', 'storage_manager', 23);

#mandatory debug point
#select * from global_employee_register;

insert into department_manager values 
(NULL, 1), (NULL, 2);

insert into site_manager values 
(NULL, 3, 1), (NULL, 4, 1), (NULL, 5, 2);

insert into masters values 
(NULL, 6, 1), (NULL, 7, 1) , (NULL, 8, 2) , 
(NULL, 9, 3), (NULL, 10, 3), (NULL, 11, 3);

insert into brigades values 
(NULL, 12, 1) , (NULL, 13, 1) , (NULL, 14, 2) , (NULL, 15, 2) ,
(NULL, 16, 3) , (NULL, 17, 3) , (NULL, 18, 3) , (NULL, 19, 4) ,
(NULL, 20, 5), (NULL, 21, 5), (NULL, 22, 6), (NULL, 23, 6);


# inserting into proffecional tables
insert into drivers values
(NULL, 24, floor(rand()*(30-1)+1)),
(NULL, 25, floor(rand()*(30-1)+1)),
(NULL, 26, floor(rand()*(30-1)+1)),
(NULL, 27, floor(rand()*(30-1)+1)),
(NULL, 28, floor(rand()*(30-1)+1)),
(NULL, 29, floor(rand()*(30-1)+1)),
(NULL, 30, floor(rand()*(30-1)+1)),
(NULL, 31, floor(rand()*(30-1)+1)),
(NULL, 32, floor(rand()*(30-1)+1)),
(NULL, 33, floor(rand()*(30-1)+1)),
(NULL, 34, floor(rand()*(30-1)+1)),
(NULL, 35, floor(rand()*(30-1)+1)),
(NULL, 36, floor(rand()*(30-1)+1)),
(NULL, 37, floor(rand()*(30-1)+1)),
(NULL, 38, floor(rand()*(30-1)+1)),
(NULL, 39, floor(rand()*(30-1)+1)),
(NULL, 40, floor(rand()*(30-1)+1)),
(NULL, 41, floor(rand()*(30-1)+1)),
(NULL, 42, floor(rand()*(30-1)+1)),
(NULL, 43, floor(rand()*(30-1)+1)),
(NULL, 44, floor(rand()*(30-1)+1)),
(NULL, 45, floor(rand()*(30-1)+1)),
(NULL, 46, floor(rand()*(30-1)+1)),
(NULL, 47, floor(rand()*(30-1)+1)),
(NULL, 48, floor(rand()*(30-1)+1)),
(NULL, 49, floor(rand()*(30-1)+1)),
(NULL, 50, floor(rand()*(30-1)+1)),
(NULL, 51, floor(rand()*(30-1)+1)),
(NULL, 52, floor(rand()*(30-1)+1)),
(NULL, 53, floor(rand()*(30-1)+1));

#debug point
#select * from drivers;

insert into welders values
(NULL, md5(rand()), 54),
(NULL, md5(rand()), 55),
(NULL, md5(rand()), 56),
(NULL, md5(rand()), 57),
(NULL, md5(rand()), 58),
(NULL, md5(rand()), 59),
(NULL, md5(rand()), 60),
(NULL, md5(rand()), 61),
(NULL, md5(rand()), 62),
(NULL, md5(rand()), 63),
(NULL, md5(rand()), 64),
(NULL, md5(rand()), 65);

insert into locksmith values
(NULL, md5(rand()), 66),
(NULL, md5(rand()), 67),
(NULL, md5(rand()), 68),
(NULL, md5(rand()), 69),
(NULL, md5(rand()), 70),
(NULL, md5(rand()), 71),
(NULL, md5(rand()), 72),
(NULL, md5(rand()), 73),
(NULL, md5(rand()), 74),
(NULL, md5(rand()), 75),
(NULL, md5(rand()), 76),
(NULL, md5(rand()), 77);

insert into tech_support values
(NULL, md5(rand()), 78),
(NULL, md5(rand()), 79),
(NULL, md5(rand()), 80),
(NULL, md5(rand()), 81),
(NULL, md5(rand()), 82),
(NULL, md5(rand()), 83),
(NULL, md5(rand()), 84),
(NULL, md5(rand()), 85),
(NULL, md5(rand()), 86),
(NULL, md5(rand()), 87),
(NULL, md5(rand()), 88),
(NULL, md5(rand()), 89);

insert into storage_manager values
(NULL, md5(rand()), 90),
(NULL, md5(rand()), 91),
(NULL, md5(rand()), 92),
(NULL, md5(rand()), 93),
(NULL, md5(rand()), 94),
(NULL, md5(rand()), 95),
(NULL, md5(rand()), 96),
(NULL, md5(rand()), 97),
(NULL, md5(rand()), 98),
(NULL, md5(rand()), 99),
(NULL, md5(rand()), 100),
(NULL, md5(rand()), 101);

#estate fill
insert into estate values
(NULL, 'tseh', 1), 
(NULL, 'tseh', 2), 
(NULL, 'garage', 1), 
(NULL, 'garage', 3), 
(NULL, 'garage', 4), 
(NULL, 'garage', 5), 
(NULL, 'box', 6), 
(NULL, 'box', 7), 
(NULL, 'box', 8), 
(NULL, 'box', 9), 
(NULL, 'box', 10), 
(NULL, 'box', 11), 
(NULL, 'box', 12), 
(NULL, 'box', 13), 
(NULL, 'box', 14), 
(NULL, 'box', 15), 
(NULL, 'box', 16), 
(NULL, 'box', 17), 
(NULL, 'box', 18), 
(NULL, 'box', 19), 
(NULL, 'box', 20), 
(NULL, 'box', 21), 
(NULL, 'box', 22);

#assing drivers (1 per car but it could be more)
insert into assigned_drivers values
(floor(rand()*(30-1)+1), floor(rand()*(40-1)+1), NULL),
(floor(rand()*(30-1)+1), floor(rand()*(40-1)+1), NULL),
(floor(rand()*(30-1)+1), floor(rand()*(40-1)+1), NULL),
(floor(rand()*(30-1)+1), floor(rand()*(40-1)+1), NULL),
(floor(rand()*(30-1)+1), floor(rand()*(40-1)+1), NULL),
(floor(rand()*(30-1)+1), floor(rand()*(40-1)+1), NULL),
(floor(rand()*(30-1)+1), floor(rand()*(40-1)+1), NULL),
(floor(rand()*(30-1)+1), floor(rand()*(40-1)+1), NULL),
(floor(rand()*(30-1)+1), floor(rand()*(40-1)+1), NULL),
(floor(rand()*(30-1)+1), floor(rand()*(40-1)+1), NULL),
(floor(rand()*(30-1)+1), floor(rand()*(40-1)+1), NULL),
(floor(rand()*(30-1)+1), floor(rand()*(40-1)+1), NULL),
(floor(rand()*(30-1)+1), floor(rand()*(40-1)+1), NULL),
(floor(rand()*(30-1)+1), floor(rand()*(40-1)+1), NULL),
(floor(rand()*(30-1)+1), floor(rand()*(40-1)+1), NULL),
(floor(rand()*(30-1)+1), floor(rand()*(40-1)+1), NULL),
(floor(rand()*(30-1)+1), floor(rand()*(40-1)+1), NULL),
(floor(rand()*(30-1)+1), floor(rand()*(40-1)+1), NULL),
(floor(rand()*(30-1)+1), floor(rand()*(40-1)+1), NULL),
(floor(rand()*(30-1)+1), floor(rand()*(40-1)+1), NULL),
(floor(rand()*(30-1)+1), floor(rand()*(40-1)+1), NULL),
(floor(rand()*(30-1)+1), floor(rand()*(40-1)+1), NULL),
(floor(rand()*(30-1)+1), floor(rand()*(40-1)+1), NULL),
(floor(rand()*(30-1)+1), floor(rand()*(40-1)+1), NULL),
(floor(rand()*(30-1)+1), floor(rand()*(40-1)+1), NULL),
(floor(rand()*(30-1)+1), floor(rand()*(40-1)+1), NULL),
(floor(rand()*(30-1)+1), floor(rand()*(40-1)+1), NULL),
(floor(rand()*(30-1)+1), floor(rand()*(40-1)+1), NULL),
(floor(rand()*(30-1)+1), floor(rand()*(40-1)+1), NULL),
(floor(rand()*(30-1)+1), floor(rand()*(40-1)+1), NULL),
(1, 43, NULL), (2, 43, NULL);

#assign vehicle to the estate
insert into assigned_vehicles values
(3, 41) , (3, 43) , (3, 45) , (3, 46) , (4, 42) , (4, 44) ,
(1, 31) , (1, 32) , (1, 33) , (1, 34) , (1, 1)  , (2, 35) ,
(2, 36) , (2, 37) , (2, 38) , (2, 2)  , (5, 39) , (5, 40) ,
(5, 3)  , (5, 4)  , (5, 11) , (6, 12) , (6, 13) , (6, 5)  ,
(6, 6)  , (6, 7)  , (7, 8)  , (7, 9)  , (8, 10) , (8, 14) ,
(9, 15) , (9, 16) , (10, 17), (10, 18), (11, 19), (11, 20),
(12, 21), (12, 22), (13, 23), (13, 24), (14, 25), (14, 26),
(15, 27), (15, 28), (16, 29), (16, 30);

#daily activity fill
insert into daily_activity_register values 		
(NULL, '2021-09-03', 'distance_update' , 100, 35, 7),
(NULL, '2021-09-03', 'distance_update' , 123, 34, 7),
(NULL, '2021-09-03', 'cargo_transfered', 1256, 35, 7),
(NULL, '2021-09-03', 'cargo_transfered', 1000, 34, 7);

#repair register fill
insert into repair_register values
(NULL, 1000, 'engine_change', 36, 78, '2021-09-02'),
(NULL, 999, 'transmission_change', 37, 79, '2021-09-02'),
(NULL, 1000, 'engine_change', 37, 78, '2021-09-02'),
(NULL, 1001, 'most_change', 37, 79, '2021-09-02');

set foreign_key_checks = 1;