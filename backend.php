<html>
  <head>
    <title>Update</title>
  </head>
  <body>

		<?php
			// Accessing DB.
			$dbhost = 'dbase.cs.jhu.edu';
			$dbuser = 'cs41515_bowenli';
			$dbpass = 'SDPFOOYW';
			$dbname = 'cs41515_bowenli_db';
			$mysqli = new mysqli($dbhost, $dbuser, $dbpass, $dbname);
			if (mysqli_connect_errno()) {
				printf("Connect failed: %s<br>", mysqli_connect_error());
				exit();
			}

			// Query from now on.
			// Create Views.
			
			//Distinguish Query Types.
			$problem = $_POST["problem"];
			// print "Here shows the result of query of problem ".$problem."<br>";

			// If it is just the query of Getting raw data from an SSN.
			if($problem == "a") {
				$ssn = $_POST["ssn"];
				if ($mysqli->multi_query("CALL ShowRawScores('".$ssn."')")) {
					do {
						if ($result = $mysqli->store_result()) {
							print "Getting raw data from an SSN.<br>";
							while ($row = $result->fetch_row()) {
								foreach($row as $every) {
									printf("%s ", $every);
								}
								printf("<br>");
							}
							$result->close();
						}
						if ($mysqli->more_results()) {
							printf("-----------------<br>");
						}
					} while ($mysqli->next_result());
				}
				else {
					printf("<br>Error: %s<br>", $mysqli->error);
				}
			}

			// If it is just the query of Getting weighted percentage data from an SSN.
			if($problem == "b") {
				$ssn     = $_POST["ssn"];
				$counter = 1;
				if ($mysqli->multi_query("CALL ShowPercentages('".$ssn."')")) {
					do {
						if ($result = $mysqli->store_result()) {
							if ($counter == 1) {
								print "Print out percentage data from an SSN. <br>";
								if ($row = $result->fetch_row()) {
									foreach($row as $every) {
										printf("%s ", $every);
									}
									printf("<br>");
								}
							} else {
								$row = $result->fetch_row();
								printf("The cumulative course average for %s %s is %s. <br>", $row[2], $row[1], $row[4]);
							}
							
							$counter = $counter + 1;
							$result->close();
						}
						if ($mysqli->more_results()) {
							printf("-----------------<br>");
						}
					} while ($mysqli->next_result());
				}
				else {
					printf("<br>Error: %s<br>", $mysqli->error);
				}
			}

			// If show whole table without total and weights.
			if($problem == "c") {
				$password = $_POST["password"];

				if ($mysqli->multi_query("CALL AllRawScores('".$password."')")) {
					do {
						if ($result = $mysqli->store_result()) {
							print "Print out whole table without total and weights.<br>";
							while ($row = $result->fetch_row()) {
								foreach($row as $every) {
									printf("%s ", $every);
								}
								printf("<br>");
							}

							$counter = $counter + 1;
							$result->close();
						}
						if ($mysqli->more_results()) {
							printf("-----------------<br>");
						}
					} while ($mysqli->next_result());
				}
				else {
					printf("<br>Error: %s<br>", $mysqli->error);
				}
			}

			// If show whole table Weighted Score.
			if($problem == "d") {
				$password = $_POST["password"];
				if ($mysqli->multi_query("CALL AllPercentages('".$password."')")) {
					do {
						if ($result = $mysqli->store_result()) {
							print "Print out weighted percentage data from an SSN. <br>";
							while ($row = $result->fetch_row()) {
								foreach($row as $every) {
									printf("%s ", $every);
								}			
								printf("<br>");		
							}
							$result->close();
						}
						if ($mysqli->more_results()) {
							printf("-----------------<br>");
						}
					} while ($mysqli->next_result());
				}
				else {
					printf("<br>Error: %s<br>", $mysqli->error);
				}
			}

			// If show whole table Weighted Score.
			if($problem == "e") {
				if ($mysqli->multi_query("CALL Stats()")) {
					do {
						if ($result = $mysqli->store_result()) {
							print "Print out statistics data from an SSN. <br>";
							while ($row = $result->fetch_row()) {
								foreach($row as $every) {
									printf("%s ", $every);
								}	
								printf("<br>");
							}
							$result->close();
						}
						if ($mysqli->more_results()) {
							printf("-----------------<br>");
						}
					} while ($mysqli->next_result());
				}
				else {
					printf("<br>Error: %s<br>", $mysqli->error);
				}
			}

			// If change table.
			if($problem == "f") {
				$password       = $_POST["password"];
				$ssn            = $_POST["ssn"];
				$assignmentname = $_POST["assignmentname"];
				$score          = $_POST["score"];
				if ($mysqli->multi_query("CALL ChangeScores('".$password."', '".$ssn."', '".$assignmentname."', ".$score.")")) {
					do {
						if ($result = $mysqli->store_result()) {
							print "Print out statistics data from an SSN. <br>";
							while ($row = $result->fetch_row()) {
								foreach($row as $every) {
									printf("%s ", $every);
								}	
								printf("<br>");
							}
							$result->close();
						}
						if ($mysqli->more_results()) {
							printf("-----------------<br>");
						}
					} while ($mysqli->next_result());
				}
				else {
					printf("<br>Error: %s<br>", $mysqli->error);
				}
			}

			// If compare two values.
			if($problem == "g(a)") {
				$a = $_POST["a"];
				$b = $_POST["b"];
				if ($mysqli->multi_query("CALL MyCalc($a, $b, @r)", $mysqli)) {
					echo("@r <br>");
				}
				else {
					printf("<br>Error: %s<br>", $mysqli->error);
				}
			}
			
			mysql_close($conn);
		?>


		<div>
			<a href="http://ugrad.cs.jhu.edu/~bli26/">
				Click to go back to home!
			</a>
		</div>
	</body>
</html>