USE dkang_db;


#Insert data for the User database using Sakila's customer database
INSERT INTO User (User_ID, User_LName, User_FName,User_Email) 
SELECT customer_id, last_name, first_name, email FROM sakila.customer;

INSERT INTO User Values (NULL,'KANG', 'DANIEL', 'Min.Hyung.Kang.15@dartmouth.edu',0);
INSERT INTO User Values (NULL,'KONG', 'KEVIN', 'Kevin.Kong.15@imemployee.edu',1);
#SELECT * FROM User;

#Insert data for the Account database, using random create dates
#And username is simply the last name, with password for each user 
#being lastname + 0. =>We are assuming that they all have different last
#name just for description purpose
INSERT INTO Account (Account_User_ID, Account_Username, Account_Pwd, Account_Create_Date)
SELECT User_ID, User_LName, concat(User_LName,'0'),
(SELECT NOW() - INTERVAL FLOOR(RAND() * 1000) DAY)
 FROM User;
 
#SELECT * FROM Account;


#Insert values for cities
INSERT INTO City VALUES ('1001','San Francisco','CA','United States');
INSERT INTO City VALUES ('1002','Los Angeles','CA','United States');
INSERT INTO City VALUES ('1003','Aspen','CO','United States');
INSERT INTO City VALUES ('1004','Eagle','CO','United States');
INSERT INTO City VALUES ('1005','Hartford','CT','United States');
INSERT INTO City VALUES ('1006','New Haven','CT','United States');
INSERT INTO City VALUES ('1007','Chicago','IL','United States');
INSERT INTO City VALUES ('1008','Boston','MA','United States');
INSERT INTO City VALUES ('1009','Provincetown','MA','United States');
INSERT INTO City VALUES ('1010','Detroit','MI','United States');
INSERT INTO City VALUES ('1011','Lansing','MI','United States');
INSERT INTO City VALUES ('1012','Duluth','MN','United States');
INSERT INTO City VALUES ('1013','Rochester','MN','United States');
INSERT INTO City VALUES ('1014','Lebanon','NH','United States');
INSERT INTO City VALUES ('1015','Manchester','NH','United States');
INSERT INTO City VALUES ('1016','New York','NY','United States');
INSERT INTO City VALUES ('1017','Syracuse','NY','United States');
INSERT INTO City VALUES ('1018','Raleigh','NC','United States');
INSERT INTO City VALUES ('1019','Cleveland','OH','United States');
INSERT INTO City VALUES ('1020','Philadelphia','PA','United States');
INSERT INTO City VALUES ('1021','Seoul',NULL,'Korea');
INSERT INTO City VALUES ('1022','Tokyo',NULL,'Japan');
INSERT INTO City VALUES ('1023','Beijing',NULL,'China');
INSERT INTO City VALUES ('1024','Paris',NULL,'France');
INSERT INTO City VALUES ('1025','Sydney',NULL,'Australia');

#SELECT * FROM City;


#Create dataset for planes
INSERT INTO Plane VALUES ('101','2002','BOEING 747-400','424');
INSERT INTO Plane VALUES ('102','2007','BOEING 747-400','424');
INSERT INTO Plane VALUES ('103','2008','BOEING 747-700','450');
INSERT INTO Plane VALUES ('104','2008','BOEING 747-800','624');
INSERT INTO Plane VALUES ('105','2013','BOEING 747-800','624');
INSERT INTO Plane VALUES ('201','2010','AIRBUS 380','425');
INSERT INTO Plane VALUES ('202','2011','AIRBUS 380','425');
INSERT INTO Plane VALUES ('203','2011','AIRBUS 380','525');
INSERT INTO Plane VALUES ('204','2014','AIRBUS 380','525');
INSERT INTO Plane VALUES ('301','2012','Jet-15','10');
INSERT INTO Plane VALUES ('302','2014','Jet-16','12');

#SELECT * FROM Plane;


#Create dataset for Flights
INSERT INTO Flight VALUES ('10101','101','1001','1002');
INSERT INTO Flight VALUES ('10102','101','1002','1003');
INSERT INTO Flight VALUES ('10201','102','1003','1004');
INSERT INTO Flight VALUES ('10202','102','1004','1005');
INSERT INTO Flight VALUES ('10301','103','1005','1006');
INSERT INTO Flight VALUES ('10302','103','1006','1007');
INSERT INTO Flight VALUES ('10401','104','1007','1008');
INSERT INTO Flight VALUES ('10402','104','1008','1009');
INSERT INTO Flight VALUES ('10403','104','1009','1010');
INSERT INTO Flight VALUES ('10501','105','1010','1011');
INSERT INTO Flight VALUES ('10502','105','1011','1012');
INSERT INTO Flight VALUES ('10503','105','1011','1012');
INSERT INTO Flight VALUES ('20101','201','1020','1021');
INSERT INTO Flight VALUES ('20102','201','1014','1015');
INSERT INTO Flight VALUES ('20201','202','1016','1018');
INSERT INTO Flight VALUES ('20301','203','1013','1007');
INSERT INTO Flight VALUES ('20302','203','1013','1007');
INSERT INTO Flight VALUES ('20303','203','1013','1007');
INSERT INTO Flight VALUES ('30101','301','1002','1010');
INSERT INTO Flight VALUES ('30102','301','1004','1015');
INSERT INTO Flight VALUES ('30201','302','1011','1018');
INSERT INTO Flight VALUES ('30202','302','1017','1019');

#SELECT * FROM Flight;

#Insert Timetable values
SET @var = FLOOR(1+RAND()*60)+60;
INSERT INTO Timetable VALUES ('1','10101','2015-04-15 09:20:00',Timetable_Dept_Date + INTERVAL @var MINUTE,'Past');
INSERT INTO Timetable VALUES ('2','10101','2015-04-15 12:20:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Past');
INSERT INTO Timetable VALUES ('3','10101','2015-04-15 15:15:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Past');
INSERT INTO Timetable VALUES ('4','10101','2015-04-17 07:15:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Past');
INSERT INTO Timetable VALUES ('5','10101','2015-04-17 12:23:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Past');
INSERT INTO Timetable VALUES ('6','10101','2015-04-20 06:24:00',Timetable_Dept_Date + INTERVAL @var MINUTE,'Past');
INSERT INTO Timetable VALUES ('7','10101','2015-04-20 14:52:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Past');
INSERT INTO Timetable VALUES ('8','10101','2015-04-20 19:27:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Past');
INSERT INTO Timetable VALUES ('9','10101','2015-04-21 23:15:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Past');
INSERT INTO Timetable VALUES ('10','10101','2015-04-23 13:23:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Past');
SET @var = FLOOR(1+RAND()*180)+60;
INSERT INTO Timetable VALUES ('11','10102','2015-04-16 13:20:00',Timetable_Dept_Date + INTERVAL @var MINUTE,'Past');
INSERT INTO Timetable VALUES ('12','10102','2015-04-27 15:20:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Past');
INSERT INTO Timetable VALUES ('13','10102','2015-04-30 15:15:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Past');
INSERT INTO Timetable VALUES ('14','10102','2015-05-01 09:15:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Past');
INSERT INTO Timetable VALUES ('15','10102','2015-05-03 14:57:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Past');
INSERT INTO Timetable VALUES ('16','10102','2015-05-04 09:23:00',Timetable_Dept_Date + INTERVAL @var MINUTE,'Past');
INSERT INTO Timetable VALUES ('17','10102','2015-05-05 07:23:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Past');
INSERT INTO Timetable VALUES ('18','10102','2015-05-05 19:56:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Past');
INSERT INTO Timetable VALUES ('19','10102','2015-05-07 22:10:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Past');
INSERT INTO Timetable VALUES ('20','10102','2015-05-09 18:15:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Past');
SET @var = FLOOR(1+RAND()*180)+60;
INSERT INTO Timetable VALUES ('21','10201','2015-05-01 17:25:00',Timetable_Dept_Date + INTERVAL @var MINUTE,'Past');
INSERT INTO Timetable VALUES ('22','10201','2015-05-02 13:20:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Past');
INSERT INTO Timetable VALUES ('23','10201','2015-05-03 15:13:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Past');
INSERT INTO Timetable VALUES ('24','10201','2015-05-04 07:45:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Past');
INSERT INTO Timetable VALUES ('25','10201','2015-05-05 17:17:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Cancelled');
INSERT INTO Timetable VALUES ('26','10201','2015-05-06 07:22:00',Timetable_Dept_Date + INTERVAL @var MINUTE,'Past');
INSERT INTO Timetable VALUES ('27','10201','2015-05-07 10:43:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Past');
INSERT INTO Timetable VALUES ('28','10201','2015-05-08 12:56:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Past');
INSERT INTO Timetable VALUES ('29','10201','2015-05-09 22:20:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Past');
INSERT INTO Timetable VALUES ('30','10201','2015-05-10 15:14:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Past');
SET @var = FLOOR(1+RAND()*180)+60;
INSERT INTO Timetable VALUES ('31','10301','2015-05-01 07:35:00',Timetable_Dept_Date + INTERVAL @var MINUTE,'Past');
INSERT INTO Timetable VALUES ('32','10301','2015-05-01 13:20:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Past');
INSERT INTO Timetable VALUES ('33','10301','2015-05-03 06:13:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Past');
INSERT INTO Timetable VALUES ('34','10301','2015-05-03 15:35:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Past');
INSERT INTO Timetable VALUES ('35','10301','2015-05-06 10:27:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Past');
INSERT INTO Timetable VALUES ('36','10301','2015-05-06 19:24:00',Timetable_Dept_Date + INTERVAL @var MINUTE,'Past');
INSERT INTO Timetable VALUES ('37','10301','2015-05-08 10:43:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Cancelled');
INSERT INTO Timetable VALUES ('38','10301','2015-05-08 16:56:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Past');
INSERT INTO Timetable VALUES ('39','10301','2015-05-10 09:24:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Past');
INSERT INTO Timetable VALUES ('40','10301','2015-05-10 18:34:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Past');
SET @var = FLOOR(1+RAND()*120)+60;
INSERT INTO Timetable VALUES ('41','10302','2015-05-01 08:35:00',Timetable_Dept_Date + INTERVAL @var MINUTE,'Past');
INSERT INTO Timetable VALUES ('42','10302','2015-05-01 17:20:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Past');
INSERT INTO Timetable VALUES ('43','10302','2015-05-03 09:33:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Past');
INSERT INTO Timetable VALUES ('44','10302','2015-05-03 16:35:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Past');
INSERT INTO Timetable VALUES ('45','10302','2015-05-06 14:27:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Past');
INSERT INTO Timetable VALUES ('46','10302','2015-05-06 20:24:00',Timetable_Dept_Date + INTERVAL @var MINUTE,'Past');
INSERT INTO Timetable VALUES ('47','10302','2015-05-08 11:43:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Past');
INSERT INTO Timetable VALUES ('48','10302','2015-05-08 20:56:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Past');
INSERT INTO Timetable VALUES ('49','10302','2015-05-10 08:24:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Past');
INSERT INTO Timetable VALUES ('50','10302','2015-05-10 15:34:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Past');
SET @var = FLOOR(1+RAND()*120)+480;
INSERT INTO Timetable VALUES ('51','20101','2015-05-08 09:35:00',Timetable_Dept_Date + INTERVAL @var MINUTE,'Scheduled');
INSERT INTO Timetable VALUES ('52','20101','2015-05-10 20:20:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Scheduled');
INSERT INTO Timetable VALUES ('53','20101','2015-05-12 08:23:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Scheduled');
INSERT INTO Timetable VALUES ('54','20101','2015-05-14 19:34:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Scheduled');
INSERT INTO Timetable VALUES ('55','20101','2015-05-16 12:23:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Scheduled');
INSERT INTO Timetable VALUES ('56','20101','2015-05-18 18:25:00',Timetable_Dept_Date + INTERVAL @var MINUTE,'Scheduled');
INSERT INTO Timetable VALUES ('57','20101','2015-05-20 12:46:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Scheduled');
INSERT INTO Timetable VALUES ('58','20101','2015-05-22 22:23:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Scheduled');
INSERT INTO Timetable VALUES ('59','20101','2015-05-24 15:22:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Scheduled');
INSERT INTO Timetable VALUES ('60','20101','2015-05-26 13:31:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Scheduled');
SET @var = FLOOR(1+RAND()*120)+60;
INSERT INTO Timetable VALUES ('61','20301','2015-05-05 20:35:00',Timetable_Dept_Date + INTERVAL @var MINUTE,'Scheduled');
INSERT INTO Timetable VALUES ('62','20301','2015-05-08 08:20:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Scheduled');
INSERT INTO Timetable VALUES ('63','20301','2015-05-11 04:33:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Cancelled');
INSERT INTO Timetable VALUES ('64','20301','2015-05-14 17:32:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Scheduled');
INSERT INTO Timetable VALUES ('65','20301','2015-05-17 11:25:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Scheduled');
INSERT INTO Timetable VALUES ('66','20301','2015-05-20 14:57:00',Timetable_Dept_Date + INTERVAL @var MINUTE,'Scheduled');
INSERT INTO Timetable VALUES ('67','20301','2015-05-23 13:46:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Scheduled');
INSERT INTO Timetable VALUES ('68','20301','2015-05-26 07:25:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Scheduled');
INSERT INTO Timetable VALUES ('69','20301','2015-05-29 12:28:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Scheduled');
INSERT INTO Timetable VALUES ('70','20301','2015-06-01 16:32:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Scheduled');
SET @var = FLOOR(1+RAND()*120)+60;
INSERT INTO Timetable VALUES ('71','20302','2015-05-06 13:25:00',Timetable_Dept_Date + INTERVAL @var MINUTE,'Scheduled');
INSERT INTO Timetable VALUES ('72','20302','2015-05-09 18:23:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Scheduled');
INSERT INTO Timetable VALUES ('73','20302','2015-05-12 20:37:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Scheduled');
INSERT INTO Timetable VALUES ('74','20302','2015-05-16 09:12:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Scheduled');
INSERT INTO Timetable VALUES ('75','20302','2015-05-18 14:29:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Scheduled');
INSERT INTO Timetable VALUES ('76','20302','2015-05-21 12:07:00',Timetable_Dept_Date + INTERVAL @var MINUTE,'Scheduled');
INSERT INTO Timetable VALUES ('77','20302','2015-05-24 17:40:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Scheduled');
INSERT INTO Timetable VALUES ('78','20302','2015-05-27 13:15:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Scheduled');
INSERT INTO Timetable VALUES ('79','20302','2015-05-30 11:48:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Scheduled');
INSERT INTO Timetable VALUES ('80','20302','2015-06-02 20:39:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Scheduled');
SET @var = FLOOR(1+RAND()*120)+60;
INSERT INTO Timetable VALUES ('81','30101','2015-04-01 10:25:00',Timetable_Dept_Date + INTERVAL @var MINUTE,'Scheduled');
INSERT INTO Timetable VALUES ('82','30101','2015-04-11 10:23:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Scheduled');
INSERT INTO Timetable VALUES ('83','30101','2015-04-21 10:37:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Scheduled');
INSERT INTO Timetable VALUES ('84','30101','2015-04-30 10:12:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Scheduled');
INSERT INTO Timetable VALUES ('85','30101','2015-05-10 10:29:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Scheduled');
INSERT INTO Timetable VALUES ('86','30101','2015-05-20 10:07:00',Timetable_Dept_Date + INTERVAL @var MINUTE,'Scheduled');
INSERT INTO Timetable VALUES ('87','30101','2015-05-30 10:40:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Scheduled');
INSERT INTO Timetable VALUES ('88','30101','2015-06-10 10:15:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Scheduled');
INSERT INTO Timetable VALUES ('89','30101','2015-06-20 10:48:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Scheduled');
INSERT INTO Timetable VALUES ('90','30101','2015-06-30 10:39:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Scheduled');
SET @var = FLOOR(1+RAND()*120)+60;
INSERT INTO Timetable VALUES ('91','30201','2015-04-05 13:24:00',Timetable_Dept_Date + INTERVAL @var MINUTE,'Scheduled');
INSERT INTO Timetable VALUES ('92','30201','2015-04-17 13:13:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Scheduled');
INSERT INTO Timetable VALUES ('93','30201','2015-04-28 13:32:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Scheduled');
INSERT INTO Timetable VALUES ('94','30201','2015-05-05 13:25:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Scheduled');
INSERT INTO Timetable VALUES ('95','30201','2015-05-15 13:49:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Scheduled');
INSERT INTO Timetable VALUES ('96','30201','2015-05-25 13:05:00',Timetable_Dept_Date + INTERVAL @var MINUTE,'Scheduled');
INSERT INTO Timetable VALUES ('97','30201','2015-05-30 13:20:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Cancelled');
INSERT INTO Timetable VALUES ('98','30202','2015-05-10 17:23:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Scheduled');
INSERT INTO Timetable VALUES ('99','30202','2015-05-20 17:49:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Scheduled');
INSERT INTO Timetable VALUES ('100','30202','2015-05-30 17:59:00', Timetable_Dept_Date + INTERVAL @var MINUTE,'Scheduled');

#SELECT * FROM Timetable;

#Proecedure to insert Reservation Data
DROP PROCEDURE IF EXISTS insertReservation;
DELIMITER $$
CREATE PROCEDURE insertReservation()
	BEGIN
		SET @i = 1;
        REPEAT 
			IF @i % 50 = 0 then
				INSERT INTO Reservation VALUES (@i,FLOOR(1+RAND()*500),FLOOR(1+RAND()*80),@i % 400,'Cancelled');
            ELSE
				INSERT INTO Reservation VALUES (@i,FLOOR(1+RAND()*500),FLOOR(1+RAND()*80),@i % 400,'Scheduled');
            END IF;
			SET @i = @i + 1;
		UNTIL @i = 500
        END REPEAT;
	END$$
DELIMITER ;
CALL insertReservation();

#Timetable 89 is FULL
INSERT INTO Reservation VALUES (500,FLOOR(1+RAND()*50),89,1,'Scheduled');
INSERT INTO Reservation VALUES (501,FLOOR(1+RAND()*50),89,2,'Scheduled');
INSERT INTO Reservation VALUES (502,FLOOR(1+RAND()*50),89,3,'Scheduled');
INSERT INTO Reservation VALUES (503,FLOOR(1+RAND()*50),89,4,'Scheduled');
INSERT INTO Reservation VALUES (504,FLOOR(1+RAND()*50),89,5,'Scheduled');
INSERT INTO Reservation VALUES (505,FLOOR(1+RAND()*50),89,6,'Scheduled');
INSERT INTO Reservation VALUES (506,FLOOR(1+RAND()*50),89,7,'Scheduled');
INSERT INTO Reservation VALUES (507,FLOOR(1+RAND()*50),89,8,'Scheduled');
INSERT INTO Reservation VALUES (508,FLOOR(1+RAND()*50),89,9,'Scheduled');
INSERT INTO Reservation VALUES (509,FLOOR(1+RAND()*50),89,10,'Scheduled');
INSERT INTO Reservation VALUES (510,FLOOR(1+RAND()*50),88,1,'Cancelled');
INSERT INTO Reservation VALUES (NULL,600,83,1,'Scheduled');
INSERT INTO Reservation VALUES (NULL,600,100,2,'Scheduled');
INSERT INTO Reservation VALUES (NULL,600,100,4,'Cancelled');
INSERT INTO Reservation VALUES (NULL,600,100,3,'Scheduled');

#Update the timetable and reservation so they are up to date
CALL updateTimetable;
CALL updateReservation;
