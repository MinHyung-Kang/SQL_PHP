<?php

//Database class that include necessary functions and constants
//The sample code that was distributed for the assignment was used/referenced
class SunapeeDB
{
	const HOST = "sunapee.cs.dartmouth.edu";
	const USER = "dkang";
	const PASS = "!s926zE";
	const DB   = "dkang_db";
	private $con = NULL;

	//Connects to the sunapee database
	public function connect()
	{
		$this->con = mysql_connect(self::HOST, self::USER, self::PASS);
		if(!$this->con) { die("SQL Error: " . mysql_error()); }
		mysql_select_db(self::DB, $this->con);
		mysql_set_charset("utf8mb4");
	}

	//retrieves a table from the database
	public function get_table($table)
	{
		if($this->con === NULL) { return; }

		$result = mysql_query("SELECT * FROM $table;");

		if(!$result) { die("SQL Error: " . mysql_error()); }

		$this->print_table($result);

		mysql_free_result($result);
	}

	//Prints the table
	private function print_table($result)
	{
		print("<table>\n<thead><tr>");
		for($i=0; $i < mysql_num_fields($result); $i++) {
			print("<th>" . mysql_field_name($result, $i) . "</th>");
		}
		print("</tr></thead>\n");

		while ($row = mysql_fetch_assoc($result)) {
			print("\t<tr>\n");
			foreach ($row as $col) {
				print("\t\t<td>$col</td>\n");
			}
	      		print("\t</tr>\n");
		}
		print("</table>\n");    
	}	

	//Disconnects from the database
	public function disconnect()
	{
	if($this->con != NULL) { mysql_close($this->con);}
	}

	//Attempts login
	public function login($username, $passwd)
	{
		$query = "CALL login('$username', '$passwd', @success)";
		$res = mysql_query($query);if(!$res) { die("SQL Error: " . mysql_error()); }
		$result = mysql_query('SELECT @success');
		$row = mysql_fetch_row($result);
		
		mysql_free_result($res);
		mysql_free_result($result);


		//Login failed
		if($row[0] == '0'){
			echo "<script type=\"text/javascript\"> window.location = \"Main.php\"</script>";
		}
		//Login successful 
		else{
			session_start();
			$_SESSION['current_user']=$username;
			$_SESSION['current_pwd']=$passwd;
			$id = mysql_query("SELECT User_ID FROM User, Account WHERE User_ID=Account_User_ID AND Account_Username = '".$_SESSION['current_user']."'");
			$idrow = mysql_fetch_row($id);
			$id = $idrow[0];
			$_SESSION['current_id']=$id;
			mysql_free_result($id);
			if($row[0] == '1'){//User was a customer
				echo "<script type=\"text/javascript\"> window.location = \"customer.php\"</script>";
			}else{//User was an employee
				echo "<script type=\"text/javascript\"> window.location = \"employee.php\"</script>";
			}
		}
	}


	//Logout
	public function logout()
	{
		$query = "CALL logout()";
		$_SESSION['current_user']=NULL;
		$_SESSION['current_pwd']=NULL;
		$_SESSION['current_id']=NULL;
		echo "<script type=\"text/javascript\"> window.location = \"Main.php\"</script>";
	}

	//Show all schedules between dates
	public function viewSchedule($beginDate, $endDate){
		mysql_query("CALL setupDates('$beginDate', '$endDate')");
		$res = mysql_query("SELECT * from viewScheduleDate");
		$this->print_table($res);
	}

	//Show all the current user's reservations between dates
	public function viewReservation($beginDate, $endDate){
		$res = mysql_query("CALL viewReservationPerCustomer('".$_SESSION['current_user']."','".$_SESSION['current_pwd']."','".$_SESSION['current_id']."','$beginDate','$endDate')");
		$this->print_table($res);
	}

	//Show all the reservations 
	public function viewReservationAll($beginDate, $endDate){
		mysql_query("CALL setupDates('$beginDate', '$endDate')");
		$res = mysql_query("SELECT * FROM viewReservationsDate;");
		$this->print_table($res);
	}

	//Show the reservations for specified flight
	public function viewReservationFlight($beginDate, $endDate, $flightID){
		$res = mysql_query("CALL viewReservationPerFlight('".$_SESSION['current_user']."','".$_SESSION['current_pwd']."','$flightID','$beginDate','$endDate')");
		$this->print_table($res);
	}

	//Show the reservations for specified Timetable
	public function viewReservationTimetable($timeTableID){
		$res = mysql_query("CALL viewReservationPerTimetable('".$_SESSION['current_user']."','".$_SESSION['current_pwd']."','$timeTableID')");
		$this->print_table($res);
	}

	//Show the reservations for specified customer
	public function viewReservationCustomer($beginDate, $endDate, $targetID){
		$res = mysql_query("CALL viewReservationPerCustomer('".$_SESSION['current_user']."','".$_SESSION['current_pwd']."','$targetID','$beginDate','$endDate')");
		$this->print_table($res);
	}

	//Show all available seats for the chosen timetable
	public function viewSeats($timetable){
		$res=mysql_query("CALL viewSeatsForTimetable($timetable)");
		$this->print_table($res);
		//$row = mysql_fetch_row($res);
		//if(empty($row)){print("No seat available for timetable : ".$timetable);}
		//if(empty($row[0])){print("No seat available for timetable : ".$timetable);}
		//if(is_null($row[0])){print("No seaterere available for timetable : ".$timetable);}
		//if(is_null($res)){print("No seat available for timetable : ".$timetable);}
		//if($res == NULL){print("Something")}
	}

	//Book the given timetable with given seat number
	public function reserveSeat($timetable, $seat){
		$res = mysql_query("CALL reserveSeat('".$_SESSION['current_user']."','".$_SESSION['current_pwd']."','$timetable','$seat',".$_SESSION['current_id'].",@success)");
		$result = mysql_query('SELECT @success');
		$row = mysql_fetch_row($result);
		if($row[0] == '0'){
			echo "Reservation failed. Please check again.";
		}else{
			echo "Your seat was successfully reserved.";
		}
	}

	//Book the given timetable with given seat number for a specified user
	public function reserveSeatForUser($timetable, $seat, $user_id){
		$res = mysql_query("CALL reserveSeat('".$_SESSION['current_user']."','".$_SESSION['current_pwd']."','$timetable','$seat','$user_id',@success)");
		$result = mysql_query('SELECT @success');
		$row = mysql_fetch_row($result);
		if($row[0] == '0'){
			echo "Reservation failed. Please check again.";
		}else{
			echo "Your seat was successfully reserved.";
		}
	}

	//Cancel the given reservation
	public function cancelSeat($reservationID){
		$res = mysql_query("CALL cancelSeat('".$_SESSION['current_user']."','".$_SESSION['current_pwd']."','$reservationID',@success)");
		$result = mysql_query('SELECT @success');
		$row = mysql_fetch_row($result);
		if($row[0] == '0'){
			echo "Cancellation failed. Please check again.";
		}else{
			echo "The reservation was successfully cancelled.";
		}
	}

	//Show popular flights for the given daterange
	public function viewMostBooked($beginDate, $endDate){
		$res=mysql_query("CALL viewPopularFlights('".$_SESSION['current_user']."','".$_SESSION['current_pwd']."','$beginDate','$endDate')");
		$this->print_table($res);
	}

}
?>
