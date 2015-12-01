<!DOCTYPE html>
<html>

<!--This is main page file. Displays logo and login -->

<head>
<link rel="stylesheet" href="dbstyle.css">
<title>Almost There Airlines</title>
</head>

<body>
<header>
<center><h2>Welcome to Almost There Airlines</h2>
<img src="logo.jpg" alt="Logo"></center>
<header>

<!--Ask for user credentials -->
<div id="wrapper">
<center>
<form action="<?php $_PHP_SELF ?>" method="get">
Username : <input type="text" name="username"> <br>
Password : <input type="text" name="password"><br>
<input type="submit" value="Login">
</center>
</form>

<?php
	//Check user login
	if(!empty($_GET)){
		mb_internal_encoding('UTF-8');
		mb_http_output('UTF-8');
	
		include 'database.php';
		$db = new SunapeeDB();
		$db ->connect();

		$db ->login($_GET["username"],$_GET["password"]);	

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
