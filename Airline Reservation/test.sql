USE dkang_db;

#Update the Timetable to make sure schedules are up to date
CALL updateTimetable;

#Update the Reservations to make sure reservations are up to date
CALL updateReservation;

#See current Schedules
SELECT * FROM viewSchedule;

#See all the reservations
SELECT * FROM viewReservations;

#See schedule between dates
CALL setupDates('2015-05-20','2015-05-30');
SELECT * FROM viewScheduleDate;

#Select reservation within certain dates
#Select reservation between May 20th and May 30th
CALL setupDates('2015-05-20','2015-05-30');
SELECT * FROM viewReservationsDate;

#Select reservation within certain dates (just for employee)
#Select every reservation (since a user is asking, does not give result)
CALL viewReservationsDateProcedure('KANG','KANG0',NULL,NULL);
#Select every reservation
CALL viewReservationsDateProcedure('KONG','KONG0',NULL,NULL);
#Select reservation that occurred after May 20th
CALL viewReservationsDateProcedure('KONG','KONG0','2015-05-20',NULL);
#Select reservation that occurred before May 30th
CALL viewReservationsDateProcedure('KONG','KONG0',NULL,'2015-05-30');
#Select reservation that occurred between May 20th and May 30th
CALL viewReservationsDateProcedure('KONG','KONG0','2015-05-20','2015-05-30');

#See reservations for a customer
#Since a customer is trying to see someone else's, returns nothing
CALL viewReservationPerCustomer('KANG','KANG0','599',NULL,NULL);
#A customer is trying to see one's own reservations, so return the data
CALL viewReservationPerCustomer('KANG','KANG0','600',NULL,NULL);
#An employee is trying to see a customer's reservations, so return the data
CALL viewReservationPerCustomer('KONG','KONG0','600',NULL,NULL);
#An employee is trying to see a customer's reservations, that happened after May 1st.
#Should give one entry
CALL viewReservationPerCustomer('KONG','KONG0','600','2015-05-01',NULL);
#An employee is trying to see a customer's reservations, that happened after May 1st and
#Before May 30th. Should give two entries
CALL viewReservationPerCustomer('KONG','KONG0','600','2015-05-01','2015-05-30');


#See reservations for a flight
#Since a customer is trying to see reservation data, return nothing
CALL viewReservationPerFlight('SMITH','SMITH0','10101',NULL,NULL);
#Since an employee is trying to see reservation data, return the data
CALL viewReservationPerFlight('KONG','KONG0','10101',NULL,NULL);
#Since an employee is trying to see reservation data, return the data that happened after 
#April 17th
CALL viewReservationPerFlight('KONG','KONG0','10101','2015-04-17',NULL);
#Since an employee is trying to see reservation data, return the data that happened after 
#April 17th and before April 25th
CALL viewReservationPerFlight('KONG','KONG0','10101','2015-04-17','2015-04-20');

#See reservations for a timetable
#Since a customer is trying to see reservation data, return nothing
CALL viewReservationPerTimetable('SMITH','SMITH0','89');
#Since an employee is trying to see reservation data, return the data
CALL viewReservationPerTimetable('KONG','KONG0','89');

#See popular flights given a time range (Only for employees)
#Since a customer is trying to see popular flights, return nothing
CALL viewPopularFlights('KANG','KANG0','2015-04-20','2015-05-20');
#Since an employee is trying to see popular flights, return the data
CALL viewPopularFlights('KONG','KONG0','2015-04-20','2015-05-20');

#Show available seats for a timetable
#Since timetable 89 is full, it should show null
CALL viewSeatsForTimetable(89);
#Since timetable 86 is not full, it should show values between 1 and 10
CALL viewSeatsForTimetable(86);


#Check if the seat is Available
#Since the 89 timetable is full, should show 0 (false)
SELECT Timetable_ID, isAvailable(Timetable_ID,1)
FROM Timetable WHERE timetable_ID=89;
#Since the 86 timetable is not full, should show 1 (true)
SELECT Timetable_ID, isAvailable(Timetable_ID,1)
FROM Timetable WHERE timetable_ID=86;
#Since the 86 timetable only has capacity of 10, should show 0 (false)
SELECT Timetable_ID, isAvailable(Timetable_ID,15)
FROM Timetable WHERE timetable_ID=86;
#Since seat 1 for timetable 88 was cancelled, should show 1 (true)
SELECT Timetable_ID, isAvailable(Timetable_ID,1)
FROM Timetable WHERE timetable_ID=88;

#Reserve a seat for customer
#Since timetable 89 is full, success should be false
CALL reserveSeat('KONG','KONG0',89,1,1,@success);
SELECT @success;
#Since timetable 86 is not full and employee is making reservation, success should be true
CALL reserveSeat('KONG','KONG0',86,1,1,@success);
SELECT @success;
#Since timetable 86 is not full but user is trying to reserve for someone else
#success should be false
CALL reserveSeat('KANG','KANG0',86,2,1,@success);
SELECT @success;
#Since timetable 86 is not full and user is trying to reserve for oneself
#success should be true
CALL reserveSeat('KANG','KANG0',86,2,600,@success);
SELECT @success;
#Since timetable 86 is not full and user is trying to reserve for oneself
#but the seat is already booked, success should be false
CALL reserveSeat('KANG','KANG0',86,2,600,@success);
SELECT @success;


#Cancels a seat for customer
#Since a customer is trying to see someone else's, returns false
CALL cancelSeat('KANG','KANG0','3',@success);
SELECT @success;
CALL cancelSeat('KANG','KANG0','',@success);
SELECT @success;
#A customer is trying to cancel one's own reservation which has passed, returns false
CALL cancelSeat('KANG','KANG0','511',@success);
SELECT @success;
#A customer is trying to cancel one's own reservation, returns true
CALL cancelSeat('KANG','KANG0','512',@success);
SELECT @success;
#An employee is trying to cancel someone's reservation, returns true
CALL cancelSeat('KONG','KONG0','513',@success);
SELECT @success;

#Logs in 
#Invalid login. Should return 0.
CALL login('KING','KONG0',@success);
SELECT @success;
#Valid login. Should return 2.
CALL login('KONG','KONG0',@success);
SELECT @success;

#Since an employee is logged in, should show the results.
CALL viewReservationsDateProcedure(@CurrentUser,@CurrentPwd,NULL,NULL);

#Log out
CALL logout;

#Since no one is logged in, should not show the results.
CALL viewReservationsDateProcedure(@CurrentUser,@CurrentPwd,NULL,NULL);

#Valid login. Should return 1 (customer).
CALL login('KANG','KANG0',@success);
SELECT @success;
#Since a is logged in, should not show the results.
CALL viewReservationsDateProcedure(@CurrentUser,@CurrentPwd,NULL,NULL);
