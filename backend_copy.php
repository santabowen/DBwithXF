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

	//Distinguish Query Types.
	$problem  = $_POST["problem"];
	$argument = $_POST["argument"];

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
		} else {
			printf("<br>Error: %s<br>", $mysqli->error);
		}
	} elseif($problem == "g") {
		printf("There is no g");
	} else {
		switch ($problem) {
			case "a":
				$callargument = "CALL ShowRawScores('".$argument."')";
				$printmsg = "Print out statistics data from an SSN. <br>";
				break;
			case "c":
				$callargument = "CALL AllRawScores('".$argument."')";
				$printmsg = "Print out statistics data from an SSN. <br>";
				break;
			case "d":
				$callargument = "CALL AllPercentages('".$argument."')";
				$printmsg = "Print out statistics data from an SSN. <br>";
				break;
			case "e":
				$callargument = "CALL Stats()";
				$printmsg = "Print out statistics data from an SSN. <br>";
				break;
			case default:
				$printmsg = "Error Problem choosing. <br>";
				break;
		}
    if ($mysqli->multi_query($callargument)) {
			do {
				if ($result = $mysqli->store_result()) {
					print $printmsg;
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
	mysql_close($conn);
?>

<div>
	<a href="http://ugrad.cs.jhu.edu/~bli26/">
		Click to go back to home!
	</a>
</div>