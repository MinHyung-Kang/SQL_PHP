README
--------------------------------------------------------------------------------------
CS61
Assignment 6
Min Hyung (Daniel) KANG
--------------------------------------------------------------------------------------
This assignment deals with implementing the database system designed for assignment 5.
It is a database for Almost There Airlines, which allows customers to view plane
schedules, reserve/cancel seats, and allows employees to view all schedules, reservations,
reserve/cancel seats. This document will talk about how the database is implemented and
how to run it.

--------------------------------------------------------------------------------------
The code was already tested and can be accessed via the following url : 

	http://cs.dartmouth.edu/~dkang/CS61/hw6/Main.php
---------------------------------------------------------------------------------------

SQL : 
   -schema.sql : sql file that sets up the database, defines all the procedures, tables, 
	etc. 
   -data.sql : sql file that inputs all the testing information.  
   -test.sql : sql file to test the tables, procedures, functions, etc. This file is not
	necessary for the database setup. 

PHP : 
   -Main.php : The main page that everyone sees. It contains the logo and title of the 
	company. It also shows my name, the class and section. One can input id and password
	to login. Employees will be taken to employee pages, and general customers to theirs.
	If login fails, one will stay on the same page, and will need to input again.
   -employee.php : The page that is viewable only for employees. 
	The employees can :
	=>View all the schedules (with or without date limits)
	=>View all the reservations (with or without date limits)
	=>VIew all the reservations by flight (with or without date limits)
	=>View all the reservations by timetable
	=>View all the reservations by user (with or without date limits)
	=>View Top5 most booked flights (with or without date limits)
	=>View seat availabilites for any flight
	=>Book flight for anyone
	=>Cancel any reservation
   -customer.php : The page that is viewable only for regular customers. 
	Customers can : 
	=>View all the schedules (with or without date limits)
	=>View seat availabilites for any flight
	=>Book flight for oneself
	=>Cancel one's own reservations
   -database.php : php file used to handle all the functions for the webpages
	=> Constants : HOST,USER,PAST,DB which are all necessary for connection setup
	Functions : 
	=>connect() : connects to the database
	=>get_table($table) : retrieves a table from the database
	=>print_table($result) : prints out the table
	=>disconnect() : disconnects from the database
	=>login($username,$passwd) : attempts to login and determines if someone is non-user, a customer, or an employee
	=>logout() logs out, deleting all the credentials
	=>viewSchedule($beginDate, $endDate) : show schedule between two dates
	=>viewReservation($beginDate, $endDate) : show one's own reservations between two dates
	=>viewReservationAll($beginDate, $endDate) : show everyone's reservations between two dates
	=>viewReservationFlight($beginDate, $endDate, $flightID) : show reservation per flight between two dates
	=>viewReservationTimetable($timetTableID) : show reservation per timetable
	=>viewReservationCustomer($beginDate, $endDate,$targetID) : show reservation per user between two dates
	=>viewSeats($timetable, $seat) : shows the available seats for a particular timetable
	=>reserveSeat($timetable, $seat) : reserves the seat for oneself
	=>reserveSeatForUser($timetable, $seat,$user_id) : reserves the seat for some user (one must be an employee)
	=>cancelSeat($reservationID) : cancels the reservation
	=>viewMostBooked($beginDate,$endDate) : shows the most popular flights within given dates.

How to set up and run : 
------------------------
1. Run schema.sql
2. Run data.sql
3. Go to : http://cs.dartmouth.edu/~dkang/CS61/hw6/Main.php    or run Main.php
4. Login* and test
5. Logout

* Login Test Credentials
Customer : Username = KANG   /  Password = KANG0
Employee : Username = KONG   /  Password = KONG0