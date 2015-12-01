README.TESTING
--------------------------------------------------------------------------------------
CS61
Assignment 6
Min Hyung (Daniel) KANG
--------------------------------------------------------------------------------------
This assignment deals with implementing the database system designed for assignment 5.
It is a database for Almost There Airlines, which allows customers to view plane
schedules, reserve/cancel seats, and allows employees to view all schedules, reservations,
reserve/cancel seats. This document will talk about how I tested the implementation.

* Login Test Credentials
Customer : Username = KANG   /  Password = KANG0
Employee : Username = KONG   /  Password = KONG0

1. Main.php
LOGIN
- Attempt invalid login (wrong match of username and password / ID = KANG   PWD = KONG0)
  => Returns to home page
- Attempt customer login (ID = KANG PWD = KANG0)
  => Takes to customer page
- Attempt Employee login (ID = KONG PWD = KONG0)
  => Takes to Employee page
- Attempt void login (ID =  PWD = )
  => Returns to home page

2. Customer.php

SCHEDULES
- Attempt Viewing All the schedules
  => returns all the schedules
- Attempt viewing schedules after 2015-05-22
  => returns schedules after 2015-05-22
- Attempt viewing schedules between 2015-05-10 and 2015-05-30
  => returns schedules between two dates

RESEVATIONS
- Attempt viewing all the reservations
  => shows all of user's reservations
- Attempt vieiwng all reservations between 2015-05-10 and 2015-05-30
  => shows all of user's reservations between two dates

SEAT SEARCH
- Attempt void seat search (Timetable : )
  => returns nothing
- Attempt seat search for a full plane (Timetable : 89)
  => returns empty
- Attempt seat search for past timetables (Timetable : 1)
  => returns nothing
- Attemp seat search for future timetables (Timetable : 88)
  => Shows available seats

BOOK FLIGHT
- Attempt invalid flight reservation (Timetable : 130 Seat : 1)
  => Tells failure
- Attempt invalid seating (Timetable : 88 Seat : 15)
  => Tells failure
- Attempt full plane (Timetable : 89 Seat : 1)
  => Tells failure
- Attempt valid reservation (Timetable : 99 Seat : 1)
  => Success
- Attemp void reservation (Timetable :  Seat : )
  => Failure

CANCEL RESERVATION
- Attempt to cancel someone else's reservation (Reservation_ID = 1)
  => Failure
- Attempt to cancel past reservation (Reservation_ID = 511)
  => Failure
- Attempt to cancel Cancelled reservation (Reservation_ID = 513)
  => Failure
- Attempt to cancel regular reservation (Reservation_ID = 512)
  => Success
- Attempt to cancel void (Reservation_ID = )
  => Failure

LOGOUT
- Attempt to log out
  => redirects to Main.php. If we go back to customer.php, we cannot retrieve the credentials.

3. Employee.php
SCHEDULES
- Attempt Viewing All the schedules
  => returns all the schedules
- Attempt viewing schedules after 2015-05-22
  => returns schedules after 2015-05-22
- Attempt viewing schedules between 2015-05-10 and 2015-05-30
  => returns schedules between two dates

RESEVATIONS
- Attempt viewing all the reservations
  => shows all the reservations
- Attempt vieiwng all reservations between 2015-05-10 and 2015-05-30
  => shows all the reservations between two dates

RESERVATION BY FLIGHT ID
- Attempt viewing with void parameter (Flight ID : )
  => shows nothing
- Attempt viewing all the reservations for a flight (Flight ID : 10101)
  => shows all reservations for flight 10101
- Attempt vieiwng all reservations for a flight between 2015-04-17 and 2015-04-20
  => shows all the reservations between two dates

RESERVATION BY TIMETABLE
- Attempt viewing with void parameter (Timetable ID : )
  => shows nothing
- Attempt viewing all the reservations for a timetable (Timetable ID : 89)
  => shows all reservations for timetable 89
- Attempt vieiwng all reservations for a timetable between 2015-04-17 and 2015-04-20
  => since there is not much point in restricting date for timetable, still returns same result as above


RESERVATION BY CUSTOMER
- Attempt viewing with void parameter (Customer ID : )
  => shows nothing
- Attempt viewing all the reservations for a customer (customer ID : 600)
  => shows all reservations for customer 600
- Attempt vieiwng all reservations for a customer between 2015-05-17 and 2015-05-20
  => shows all reservations for customer 600 between two dates

VIEW TOP5 MOST BOOKED
- Attempt to see most booked flights 
  => shows top 5
- Attempt to see most booked flights between two dates
  => shows top 5 between two dates


SEAT SEARCH
- Attempt void seat search (Timetable : )
  => returns nothing
- Attempt seat search for a full plane (Timetable : 89)
  => returns empty
- Attempt seat search for past timetables (Timetable : 1)
  => returns nothing
- Attemp seat search for future timetables (Timetable : 88)
  => Shows available seats

BOOK FLIGHT FOR USER
- Attempt invalid flight reservation (Timetable : 130 Seat : 1 User = 600)
  => Tells failure
- Attempt invalid seating (Timetable : 88 Seat : 15 User = 600)
  => Tells failure
- Attempt full plane (Timetable : 89 Seat : 1  User = 600)
  => Tells failure
- Attempt valid reservation (Timetable : 100 Seat : 7  User = 600)
  => Success
- Attemp void reservation (Timetable :  Seat : )
  => Failure

CANCEL RESERVATION
- Attempt to cancel someone else's reservation (Reservation_ID = 349)
  => Success
- Attempt to cancel past reservation (Reservation_ID = 511)
  => Failure
- Attempt to cancel Cancelled reservation (Reservation_ID = 513)
  => Failure
- Attempt to cancel regular reservation (Reservation_ID = 512)
  => Success
- Attempt to cancel void (Reservation_ID = )
  => Failure


LOGOUT
- Attempt to log out
  => redirects to Main.php. If we go back to customer.php, we cannot retrieve the credentials.