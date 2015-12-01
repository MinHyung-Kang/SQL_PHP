<!DOCTYPE html>
<html>

<!--This is customer page file. Displays options for customers -->

<head>
<link rel="stylesheet" href="dbstyle.css">
<title>customer</title>
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
<input type="submit" name="Schedule" value="View Schedules"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<input type="submit" name="Reservation" value="View Reservations"><br><br><br><br>
Timetable : <input type="text" name="seat_Timetable"> <input type="submit" name="Seats" value="Show Seat Availability"><br><br>
Timetable : <input type="text" name="reserve_Timetable"> Seat : <input type="text" name="reserve_seat"> <input type="submit" name="Book" value="Book Flight"><br><br>
Reservation ID : <input type="text" name="cancel_ID"> <input type="submit" name="Cancel" value="Cancel Reservation"><br><br>
<br><br><br><br><br>
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

		if(isset($_GET['Schedule'])){//show schedules
			$db -> viewSchedule($_GET["beginDate"],$_GET["endDate"]);
		}elseif(isset($_GET['Reservation'])){//show user's reservations
			$db -> viewReservation($_GET["beginDate"],$_GET["endDate"]);
		}elseif(isset($_GET['Seats'])){ // show available seats for a timetable
			$db -> viewSeats($_GET["seat_Timetable"]);		
		}elseif(isset($_GET['Book'])){//book a seat
			$db -> reserveSeat($_GET["reserve_Timetable"],$_GET["reserve_seat"]);	
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
