<!DOCTYPE html>
<html>

<!--This is employee page file. Displays options for employees -->

<head>
<link rel="stylesheet" href="dbstyle.css">
<title>employee</title>
</head>

<body>
<header>
<center><h2>Please select your action</h2>
<header>

<!--Different options -->
<div id="wrapper">
<center>
<form action="<?php $_PHP_SELF ?>" method="get">
<h4>Leave the forms blank if you do not want to specify dates</h4>
Begin Date : <input type="text" name="beginDate"> 
   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;End Date : <input type="text" name="endDate"><br><br>
The following options may just be used for viewing reservations : <br>
<!--Viewing reservations/Schedules -->
<input type="radio" name="option" value="All" checked>All<br>
<input type="radio" name="option" value="byFlight">by Flight ID : <input type="text" name="byFlightText"><br>
<input type="radio" name="option" value="byTimetable">by Timetable ID : <input type="text" name="byTimetableText"><br>
<input type="radio" name="option" value="byCustomer">by Customer ID : <input type="text" name="byCustomerText"><br>
<input type="submit" name="Schedule" value="View Schedules"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<input type="submit" name="Reservation" value="View Reservations">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<input type="submit" name="Top5" value="View Top5 Most Booked Flights"><br><br><br><br>
<!--See seat availablities -->
Timetable : <input type="text" name="seat_Timetable"> <input type="submit" name="Seats" value="Show Seat Availability"><br><br>
<!--Reserve a seat for a user -->
Timetable : <input type="text" name="reserve_Timetable"> Seat : <input type="text" name="reserve_seat"> User ID: <input type="text" name="reserve_user"> <input type="submit" name="Book" value="Book Flight"><br><br>
<!--Cancel a seat -->
Reservation ID : <input type="text" name="cancel_ID"> <input type="submit" name="Cancel" value="Cancel Reservation"><br><br>
<br><br><br>
<input type="submit" name="Log Out" value="Log Out"><br>
</center>
</form>

<?php
	//Depending on user input take different actions
	if(!empty($_GET)){

		mb_internal_encoding('UTF-8');
		mb_http_output('UTF-8');

		session_start();
	
		include 'database.php';
		$db = new SunapeeDB();
		$db ->connect();

		if(isset($_GET['Schedule'])){ //show schedules
			$db -> viewSchedule($_GET["beginDate"],$_GET["endDate"]);
		}elseif(isset($_GET['Reservation'])){ //show reservations
			switch($_GET['option']){//Depending on chosen option, display different results
				case "All":
					$db -> viewReservationAll($_GET["beginDate"],$_GET["endDate"]);
					break;
				case "byFlight":
					$db -> viewReservationFlight($_GET["beginDate"],$_GET["endDate"],$_GET["byFlightText"]);
					break;
				case "byTimetable":
					$db -> viewReservationTimetable($_GET["byTimetableText"]);
					break;
				case "byCustomer":
					$db -> viewReservationCustomer($_GET["beginDate"],$_GET["endDate"],$_GET["byCustomerText"]);
					break;
				default : 
					echo "Default";
					
			}
		}elseif(isset($_GET['Top5'])){//show top 5 booked flights
			$db -> viewMostBooked($_GET["beginDate"],$_GET["endDate"]);
		}elseif(isset($_GET['Seats'])){//show seats
			$db -> viewSeats($_GET["seat_Timetable"]);		
		}elseif(isset($_GET['Book'])){//book a seat
			$db -> reserveSeatForUser($_GET["reserve_Timetable"],$_GET["reserve_seat"],$_GET["reserve_user"]);	
		}elseif(isset($_GET['Cancel'])){//cancel a reservation
			$db -> cancelSeat($_GET["cancel_ID"]);	
		}else{
			$db->logout();

		}

		$db ->disconnect();
	}
?>

</div>

<footer>
<center>
<br><br><br><br><br>
Designed and Implemented by : Min Hyung (Daniel) Kang '15<br>
Database : dkang_db <br>
Course : CS61-Spring 2015
</center>
</footer>

</div>
</body>
</html>
