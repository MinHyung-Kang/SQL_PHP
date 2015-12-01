USE dkang_db;

#Drop all the tables if they already exist, so that we can recreate them
DROP TABLE IF EXISTS Reservation;
DROP TABLE IF EXISTS Timetable;
DROP TABLE IF EXISTS Flight;
DROP TABLE IF EXISTS Plane;
DROP TABLE IF EXISTS City;
DROP TABLE IF EXISTS Account;
DROP TABLE IF EXISTS User;

#Create table that includes information about the users.
#The user may be an Employee or just a customer
CREATE TABLE User (
	User_ID                  INT          NOT NULL  UNIQUE AUTO_INCREMENT CHECK(User_ID>0),
    User_LName               VARCHAR(45)  NOT NULL,
	User_FName	             VARCHAR(45)  NOT NULL,
    User_Email               VARCHAR(45)  NOT NULL,
    User_IsEmployee          INT          NOT NULL DEFAULT '-1' CHECK (User_IsEmployee IN(0,1)),     
    PRIMARY KEY (User_ID)
);

#Create a table that includes information about users' account
#Table is used to check login credentials
CREATE TABLE Account(
	Account_User_ID          INT          NOT NULL  UNIQUE CHECK(Account_User_ID > 0),
    Account_Username         VARCHAR(45)  NOT NULL  UNIQUE,
	Account_Pwd	             VARCHAR(45)  NOT NULL,
    Account_Create_Date      DATE         NOT NULL,
    PRIMARY KEY (Account_User_ID),
    FOREIGN KEY (Account_User_ID) REFERENCES User(User_ID)
);
	
#Create a table that includes information about cities where
#airports are placed.
CREATE TABLE City(
	City_ID                  INT          NOT NULL  UNIQUE CHECK (City_ID BETWEEN 1000 AND 9999),
    City_Name                VARCHAR(45)  NOT NULL,
	City_State	             CHAR(2),      
    City_Country             VARCHAR(45)  NOT NULL,
    PRIMARY KEY (City_ID)
);


#Create a table that includes information about the planes the
#company has
CREATE TABLE Plane(
	Plane_ID                 INT          NOT NULL  UNIQUE CHECK (Plane_ID BETWEEN 100 AND 999),
    Plane_Year               INT          NOT NULL CHECK (Plane_Year BETWEEN 1000 AND 9999),
	Plane_Model	             VARCHAR(45)  NOT NULL,      
    Plane_SeatCap            INT          NOT NULL CHECK (Plane_Year BETWEEN 1 AND 999),
    PRIMARY KEY (Plane_ID)
);

#Create a table that includes information about the flights
#of the companys. A flight consists of a plane flying from
#one city to another city.
CREATE TABLE Flight(
	Flight_ID                INT          NOT NULL UNIQUE CHECK (Flight_ID BETWEEN 10000 AND 99999),
    Flight_Plane_ID          INT          NOT NULL CHECK (Flight_PLANE_ID BETWEEN 100 AND 999),
    Flight_Dept_City	     INT          NOT NULL CHECK (Dept_City BETWEEN 1000 AND 9999),
    Flight_Arr_City          INT          NOT NULL CHECK (Arr_City BETWEEN 1000 AND 9999),
    PRIMARY KEY (Flight_ID),
    FOREIGN KEY (Flight_Plane_ID) REFERENCES Plane(Plane_ID),
    FOREIGN KEY (Flight_Dept_City) REFERENCES City(City_ID),
    FOREIGN KEY (Flight_Arr_City) REFERENCES City(City_ID)
);

#Create a timetable that includes information about
#each flight for different dates.
CREATE TABLE Timetable(
	Timetable_ID             INT          NOT NULL UNIQUE CHECK(Timetable_ID > 0),
    Timetable_Flight         INT          NOT NULL CHECK(Timetable_Flight BETWEEN 10000 AND 99999),
	Timetable_Dept_Date      DATETIME     NOT NULL,
    Timetable_Arr_Date       DATETIME     NOT NULL,
    Timetable_State          ENUM('Scheduled','Cancelled','Past','In Flight')
										  NOT NULL,
    PRIMARY KEY (Timetable_ID),
    FOREIGN KEY (Timetable_Flight) REFERENCES Flight(Flight_ID)
);

#Create a table that includes information about 
#customer's reservations
CREATE TABLE Reservation(
	Reservation_ID           INT          NOT NULL UNIQUE AUTO_INCREMENT CHECK(Reservation_ID >0),
    Reservation_User_ID      INT          NOT NULL CHECK(Reservation_User_ID >0),
	Reservation_Timetable_ID INT          NOT NULL CHECK(Reservation_Timetable_ID >0),
    Reservation_Seat_Num     INT          NOT NULL CHECK(Seat_Num BETWEEN 1 AND 999),
    Reservation_State        ENUM('Scheduled','Cancelled','Past','In Flight')
								   		  NOT NULL,
    PRIMARY KEY (Reservation_ID),
    FOREIGN KEY (Reservation_User_ID) REFERENCES User(User_ID),
    FOREIGN KEY (Reservation_Timetable_ID) REFERENCES Timetable(Timetable_ID)
);


#Create Trigger to automatically choose the employees among the input people dataset
DROP TRIGGER IF EXISTS ChooseEmployee;

DELIMITER $$
CREATE TRIGGER ChooseEmployee
	BEFORE INSERT ON User
    FOR EACH ROW
    
    BEGIN
		DECLARE var INT;
		SET var = FLOOR(1+RAND()*10);
        IF NEW.User_IsEmployee = -1 THEN
			IF var = 1 THEN
				SET NEW.User_IsEmployee = TRUE;
			ELSE 
				SET NEW.User_IsEmployee = FALSE;
			END IF;
        END IF;
    END $$
DELIMITER ;

SET SQL_SAFE_UPDATES = 0;


#Procedure that updates the current state of the Timetables
#If the plane has already arrived, set it as Past
#If the plane is still flying, set it as flying
#If the plane was cancelled, leave it as cancelled
#If the plane has not departed yet, leave it as scheduled
DROP PROCEDURE IF EXISTS updateTimetable;
DELIMITER $$
CREATE PROCEDURE updateTimetable()
	BEGIN
    UPDATE Timetable
    SET Timetable_State = CASE
		WHEN Timetable_State = 'Cancelled' THEN 'Cancelled'
        WHEN Timetable_ARR_Date < NOW() THEN 'Past'
        WHEN Timetable_Dept_Date < NOW() THEN 'In Flight'
        ELSE 'Scheduled'
    END;
		
    END$$
DELIMITER ;

#Procedure that updates the current state of the Reservations
DROP PROCEDURE IF EXISTS updateReservation;
DELIMITER $$
CREATE PROCEDURE updateReservation()
	BEGIN
    
    UPDATE Reservation, Timetable
		SET Reservation_State = Timetable_State
        WHERE Reservation_Timetable_ID = Timetable_ID
        AND Reservation_State != 'Cancelled';
		
    END$$
DELIMITER ;
#Function : Attempt to make a reservation

#View : See plane schedules
DROP VIEW IF EXISTS viewSchedule;
CREATE VIEW viewSchedule AS
SELECT Timetable_ID AS ID,Timetable_Flight AS Flight,Timetable_Dept_Date AS Departure, 
	Dept.City_Name AS Departure_City, Timetable_Arr_Date AS Arrival, Arr.City_Name AS Arrival_City,Timetable_State As State
FROM Timetable, City AS Dept, City As Arr, Flight
WHERE Timetable_Flight = Flight.Flight_ID
AND Flight.Flight_Dept_City = Dept.City_ID
AND Flight.Flight_Arr_City = Arr.City_ID
ORDER BY Departure;

#Shows the reservations only within the specified dates
DROP VIEW IF EXISTS viewScheduleDate;
CREATE VIEW viewScheduleDate AS
SELECT * FROM viewSchedule
WHERE DATE(Departure) BETWEEN fn_getStartDate() AND fn_getEndDate()
ORDER BY Departure;


#View : See all the reservation states 
DROP VIEW IF EXISTS viewReservations;
CREATE VIEW viewReservations AS
SELECT Reservation_ID, Timetable_Flight AS Flight,Timetable_Dept_Date AS Departure, 
	Dept.City_Name AS Departure_City, Timetable_Arr_Date AS Arrival, 
    Arr.City_Name AS Arrival_City,Timetable_State As State,
    User_LName As Last_Name, User_FName AS First_Name, Reservation_State, 
    Reservation_Seat_Num AS Seat, User_ID, Timetable_ID
FROM User, Reservation, Timetable, City AS Dept, City As Arr, Flight
WHERE User_ID = Reservation_User_ID
AND Reservation_Timetable_ID = Timetable_ID
AND Timetable_Flight = Flight.Flight_ID
AND Flight.Flight_Dept_City = Dept.City_ID
AND Flight.Flight_Arr_City = Arr.City_ID
ORDER BY Departure, Last_Name;

#Function used to get start date
DROP FUNCTION IF EXISTS fn_getStartDate;
CREATE FUNCTION fn_getStartDate()
	RETURNS DATE
    DETERMINISTIC NO SQL
	RETURN @StartDate;

#Function used to get End date
DROP FUNCTION IF EXISTS fn_getEndDate;
CREATE FUNCTION fn_getEndDate()
	RETURNS DATE
    DETERMINISTIC NO SQL
	RETURN @EndDate;


#Shows the reservations only within the specified dates
DROP VIEW IF EXISTS viewReservationsDate;
CREATE VIEW viewReservationsDate AS
SELECT * FROM viewReservations
WHERE DATE(Departure) BETWEEN fn_getStartDate() AND fn_getEndDate()
ORDER BY Departure;


#Procedure : sets up begin/end dates to set up other queries
DROP PROCEDURE IF EXISTS setupDates;
DELIMITER $$
CREATE PROCEDURE setupDates
(IN beginDate DATE, IN endDate DATE)
	BEGIN
		IF beginDate IS NULL || beginDate = '' THEN
			SET @StartDate:= '0000-01-01';
		ELSE
			SET @StartDate:= beginDate;
		END IF;
        IF endDate IS NULL || endDate = '' THEN
			SET @EndDate:= '9999-12-31';
		ELSE
			SET @EndDate:= endDate; 			
		END IF;
    END$$
DELIMITER ;


#Returns the reservations for selected Date
DROP PROCEDURE IF EXISTS viewReservationsDateProcedure;
DELIMITER $$
CREATE PROCEDURE viewReservationsDateProcedure
(IN username VARCHAR(45), IN pwd VARCHAR(45), IN beginDate DATE, IN endDate DATE)
	BEGIN
		CALL updateTimetable;
		CALL updateReservation;
        
        IF isEmployee(username, pwd) THEN
			IF beginDate IS NULL THEN
				IF endDate IS NULL THEN
					SELECT * FROM viewReservations;
				ELSE
					SELECT * FROM viewReservations
					WHERE DATE(Departure) <= endDate;
				END IF;
			ELSE
				IF endDate IS NULL THEN
					SELECT * FROM viewReservations
					WHERE DATE(Departure) >= beginDate;
				ELSE
					SELECT * FROM viewReservations
					WHERE Departure >= beginDate
					AND DATE(Departure) <= endDate;
				END IF;
			END IF;
        END IF;
	END$$
DELIMITER ;


#Function : view reservation state for specified customer ID (Only for Employee)
#Returns true if the user was employee and false if the user was not employee

#Function : Checks if the user is an employee.
DROP FUNCTION IF EXISTS isEmployee;
DELIMITER $$

CREATE FUNCTION isEmployee(username VARCHAR(45), passwd VARCHAR(45))
RETURNS BOOLEAN
BEGIN
	IF (SELECT User_IsEmployee FROM Account, User 
    WHERE Account_User_ID = User_ID 
    AND Account_Username = username
    AND Account_Pwd = passwd) = 1 THEN
        RETURN TRUE;
    ELSE 
		RETURN FALSE;
    END IF;
END $$
DELIMITER ;


#Procedure : View reservations for a particular customer (Only for Employee or oneself)
DROP PROCEDURE IF EXISTS viewReservationPerCustomer;

DELIMITER $$
CREATE PROCEDURE viewReservationPerCustomer
(IN username VARCHAR(45), IN pwd VARCHAR(45), IN targetid INT, IN beginDate DATE, IN endDate DATE)
	BEGIN
		CALL updateTimetable;
		CALL updateReservation;
	
		CALL setupDates(beginDate, endDate);
    
		IF isEmployee(username,pwd) THEN
			SELECT * FROM viewReservationsDate
            WHERE User_ID = targetid;
		ELSEIF (
        SELECT Account_User_ID
        FROM Account
        WHERE Account_Username = username
        AND Account_Pwd = pwd
        )=targetid THEN
			SELECT * FROM viewReservationsDate
            WHERE User_ID = targetid;
        END IF;
    END$$
DELIMITER ;

#View reservations for a particular flight (Only for Employee)
DROP PROCEDURE IF EXISTS viewReservationPerFlight;

DELIMITER $$
CREATE PROCEDURE viewReservationPerFlight
(IN username VARCHAR(45), IN pwd VARCHAR(45), IN flightid INT, IN beginDate DATE, IN endDate DATE)
	BEGIN
		CALL updateTimetable;
		CALL updateReservation;
        
		CALL setupDates(beginDate, endDate);

		IF isEmployee(username,pwd) THEN
			SELECT * FROM viewReservationsDate
            WHERE flight = flightid;
        END IF;
    END$$
DELIMITER ;


#View reservations for a particular schedule (Only for Employee)
DROP PROCEDURE IF EXISTS viewReservationPerTimetable;

DELIMITER $$
CREATE PROCEDURE viewReservationPerTimetable
(IN username VARCHAR(45), IN pwd VARCHAR(45), IN timetableid INT)
	BEGIN
		CALL updateTimetable;
		CALL updateReservation;

		IF isEmployee(username,pwd) THEN
			SELECT * FROM viewReservations
            WHERE Timetable_ID = timetableid;
        END IF;
    END$$
DELIMITER ;


#Show available seats for a flight
DROP PROCEDURE IF EXISTS viewSeatsForTimetable;

DELIMITER $$
CREATE PROCEDURE viewSeatsForTimetable
(IN timetableID INT)
	BEGIN
    
    CALL updateTimetable;
    CALL updateReservation;

	DROP TABLE IF EXISTS tempSeats;
	CREATE TABlE tempSeats(
		Available_Seats INT UNIQUE NOT NULL,
		PRIMARY KEY(Available_Seats)
	);
    
	IF (SELECT Timetable_State
	FROM Timetable
	WHERE Timetable_ID = timetableID) = 'Scheduled' THEN
		#Capacity of the plane
		SET @cap = (SELECT Plane_SeatCap
		FROM Timetable, Flight, Plane
		WHERE Timetable_ID = timetableID
		AND Timetable_Flight= Flight_ID
		AND Flight_Plane_ID = Plane_ID);
		
	   
		SET @i = 1;
		REPEAT 
			IF @i NOT IN ( #Currently reserved seats
				SELECT Reservation_Seat_Num 
				FROM Reservation
				WHERE Reservation_Timetable_ID = timetableID
				AND Reservation_State = 'Scheduled') THEN
				INSERT INTO tempSeats VALUES (@i);
			END IF;
			SET @i = @i + 1;
		UNTIL @i = @cap + 1
		END REPEAT;
			
		SELECT * FROM tempSeats;
		DROP TABLE IF EXISTS tempSeats;
    END IF;
    END$$
DELIMITER ;

#View popular flights given a range of dates(Only for Employee)
DROP PROCEDURE IF EXISTS viewPopularFlights;

DELIMITER $$
CREATE PROCEDURE viewPopularFlights
(IN username VARCHAR(45), IN pwd VARCHAR(45), IN beginDate DATE, IN endDate DATE)
	BEGIN
		CALL updateTimetable;
		CALL updateReservation;

		CALL setupDates(beginDate, endDate);
		IF isEmployee(username,pwd) THEN
			SELECT Flight, Departure_City, Arrival_City, COUNT(Reservation_ID) AS Num_Reservations
            FROM viewReservationsDate
            GROUP BY Flight
            ORDER BY Num_Reservations DESC
            LIMIT 5;
        END IF;
    END$$
DELIMITER ;



#Function : Check if a particular seat is available for a timetable
DROP FUNCTION IF EXISTS isAvailable;
DELIMITER $$

CREATE FUNCTION isAvailable(timetableID INT, seat INT)
RETURNS BOOLEAN
BEGIN
	SET @cap = (SELECT Plane_SeatCap
    FROM Timetable, Flight, Plane
    WHERE Timetable_ID = timetableID
    AND Timetable_Flight= Flight_ID
    AND Flight_Plane_ID = Plane_ID);
    
	#If the seat is not already selected
    #and if the seat is within plane capacity.
    IF seat NOT IN (SELECT Reservation_Seat_Num 
		FROM Reservation
		WHERE Reservation_Timetable_ID = timetableID
		AND Reservation_State = 'Scheduled') &&
        seat <= @cap THEN
        RETURN TRUE;
    ELSE 
		RETURN FALSE;
    END IF;
END $$
DELIMITER ;

#Procedure : Reserves a seat for customer if the seat is available
DROP PROCEDURE IF EXISTS reserveSeat;
DELIMITER $$

CREATE PROCEDURE reserveSeat
(IN username VARCHAR(45), IN pwd VARCHAR(45),IN timetableID INT, IN seat INT, IN userID INT, OUT result BOOLEAN)
BEGIN
	IF isEmployee(username,pwd) || (SELECT Account_User_ID
        FROM Account
		WHERE Account_Username = username
        AND Account_Pwd = pwd)=userID THEN
		IF isAvailable(timetableID, seat) THEN
			INSERT INTO Reservation VALUES(NULL,userID,timetableID,seat,'Scheduled');
			SET result = TRUE;
		ELSE
			SET result = FALSE;
		END IF;
	ELSE
		SET result = FALSE;
    END IF;
END $$
DELIMITER ;

#Procedure : Cancels a seat for customer 
#Only cancels if the customer cancels it oneself or if the employee does it
DROP PROCEDURE IF EXISTS cancelSeat;
DELIMITER $$

CREATE PROCEDURE cancelSeat
(IN username VARCHAR(45), IN pwd VARCHAR(45), IN reservationID INT, OUT result BOOLEAN)
BEGIN
	IF isEmployee(username, pwd) || 
		(SELECT Account_Username
        FROM Reservation, User, Account
		WHERE Reservation_ID = reservationID
        AND Reservation_User_ID = User_ID
        AND User_ID = Account_User_ID) = username THEN
			IF (SELECT Reservation_State
            FROM Reservation
            WHERE Reservation_ID = reservationID)= 'Scheduled'
            THEN
				UPDATE Reservation 
                SET Reservation_State = 'Cancelled'
                Where Reservation_ID = reservationID;
				SET result = TRUE;
			ELSE
				SET result = FALSE;
            END IF;
    ELSE
		SET result = FALSE;
	END IF;
END $$
DELIMITER ;

#Procedure : Attempts a login, returns true if login was successful
# Saves current credentials if login was successful
DROP PROCEDURE IF EXISTS login;
DELIMITER $$

CREATE PROCEDURE login
(IN username VARCHAR(45), IN pwd VARCHAR(45), OUT result INT)
BEGIN
	IF (SELECT Account_Pwd
		FROM Account
		WHERE Account_Username = username) = pwd THEN
        SET result = 1+(SELECT User_IsEmployee
			FROM User, Account
			WHERE Account_Username = username
            AND Account_User_ID = User_ID);
		SET @CurrentUser = username;
        SET @CurrentPwd = pwd;
	ELSE
		SET result = 0;
	END IF;
END $$
DELIMITER ;

#Procedure : Logs out, clears saved credentials
DROP PROCEDURE IF EXISTS logout;
DELIMITER $$

CREATE PROCEDURE logout()
BEGIN
	SET @CurrentUser = NULL;
	SET @CurrentPwd = NULL;
END $$
DELIMITER ;

#Function used to get current User
DROP FUNCTION IF EXISTS fn_getCurrentUser;
CREATE FUNCTION fn_getCurrentUser()
	RETURNS DATE
    DETERMINISTIC NO SQL
	RETURN @CurrentUser;

#Function used to get current pwd
DROP FUNCTION IF EXISTS fn_getCurrentPwd;
CREATE FUNCTION fn_getCurrentPwd()
	RETURNS DATE
    DETERMINISTIC NO SQL
	RETURN @CurrentPwd;