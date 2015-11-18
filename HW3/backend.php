<html>
  <head>
    <title>Backend</title>
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
				$ssn = (is_numeric($ssn) ? (int)$ssn : 0);
				if($mysqli->multi_query("CALL CheckSSN($ssn)")) {
					if ($result = $mysqli->store_result()) {
						if ($result->fetch_row()) {
							$numrows = 1;
						} else {
							$numrows = 0;
						}
					}
				}
				
				$result->close();
				$mysqli = new mysqli($dbhost, $dbuser, $dbpass, $dbname);

				if ($numrows > 0) {
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
						} while ($mysqli->next_result());
					} else {
						printf("<br>Error: %s<br>", $mysqli->error);
					}
				} else {
					echo "Sorry, we cannot find your SSN. <br>";
				}
			}

			// If it is just the query of Getting weighted percentage data from an SSN.
			if($problem == "b") {
				$ssn     = $_POST["ssn"];
				$ssn = (is_numeric($ssn) ? (int)$ssn : 0);
				if($mysqli->multi_query("CALL CheckSSN($ssn)")) {
					if ($result = $mysqli->store_result()) {
						if ($result->fetch_row()) {
							$numrows = 1;
						} else {
							$numrows = 0;
						}
					}
				}
				
				$result->close();
				$mysqli = new mysqli($dbhost, $dbuser, $dbpass, $dbname);

				if ($numrows > 0) {
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
				} else {
					echo "Sorry, we cannot find your SSN. <br>";
				}
			}

			// If show whole table without total and weights.
			if($problem == "c") {
				$password = $_POST["password"];
				if($mysqli->multi_query("CALL CheckPassword('".$password."')")) {
					if ($result = $mysqli->store_result()) {
						if ($result->fetch_row()) {
							$numrows = 1;
						} else {
							$numrows = 0;
						}
					}
				}
				
				$result->close();
				$mysqli = new mysqli($dbhost, $dbuser, $dbpass, $dbname);

				if ($numrows > 0) {
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
					} else {
						printf("<br>Error: %s<br>", $mysqli->error);
					}
				} else {
					echo "Sorry, you type a wrong password.";
				}
			}

			// If show whole table Weighted Score.
			if($problem == "d") {
				$password = $_POST["password"];
				if($mysqli->multi_query("CALL CheckPassword('".$password."')")) {
					if ($result = $mysqli->store_result()) {
						if ($result->fetch_row()) {
							$numrows = 1;
						} else {
							$numrows = 0;
						}
					}
				}
				
				$result->close();
				$mysqli = new mysqli($dbhost, $dbuser, $dbpass, $dbname);

				if ($numrows > 0) {
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
					} else {
						printf("<br>Error: %s<br>", $mysqli->error);
					}
				} else {
					echo "Sorry, you type a wrong password. <br>";
				}
			}

			// If show whole table Weighted Score.
			if($problem == "e") {
				if ($mysqli->multi_query("CALL Stats()")) {
					do {
						if ($result = $mysqli->store_result()) {
							print "Print out statistics data from an SSN. <br><br>";
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
				} else {
					printf("<br>Error: %s<br>", $mysqli->error);
				}
			}

			// If change table.
			if($problem == "f") {
				$password       = $_POST["password"];
				$ssn            = $_POST["ssn"];
				$assignmentname = $_POST["assignmentname"];
				$score          = $_POST["score"];

				if($mysqli->multi_query("CALL CheckPassword('".$password."')")) {
					if ($result = $mysqli->store_result()) {
						if ($result->fetch_row()) {
							$numrows = 1;
						} else {
							$numrows = 0;
						}
					}
				}
				
				$result->close();
				$mysqli = new mysqli($dbhost, $dbuser, $dbpass, $dbname);

				$ssn = (is_numeric($ssn) ? (int)$ssn : 0);
				if($mysqli->multi_query("CALL CheckSSN($ssn)")) {
					if ($result = $mysqli->store_result()) {
						if ($result->fetch_row()) {
							$numrows_ssn = 1;
						} else {
							$numrows_ssn = 0;
						}
					}
				}
				
				$result->close();
				$mysqli = new mysqli($dbhost, $dbuser, $dbpass, $dbname);

				if ($numrows == 0) {
					echo "You type a wrong password.<br>";
				} elseif ($numrows_ssn == 0) {
					echo "We cannot find the ssn you type.<br>";
				} else {
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
					} else {
						printf("<br>Error: %s<br>", $mysqli->error);
					}
				}
			}
		?>


		<div>
			<a href="http://ugrad.cs.jhu.edu/~bli26/">
				Click to go back to home!
			</a>
		</div>
	</body>
</html>