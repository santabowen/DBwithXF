<html>
  <head>
    <title>Update</title>
  </head>

  <body>

  <?php
    // PHP code just started
    $dbhost = 'dbase.cs.jhu.edu';
    $dbuser = 'cs41515_bowenli';
    $dbpass = 'SDPFOOYW';
    $dbname = 'cs41515_bowenli_db';

    // display errors
    $db = mysql_connect($dbhost, $dbuser, $dbpass);
    $problem = $_POST['problem'];

    
    if (!$db) {
      echo "Connection failed!";
    } else {

      if ($problem == "a"){
        $a = $_POST['a'];
        $b = $_POST['b'];
        mysql_select_db("$dbname", $db);
        $result = mysql_query("CALL MyCalc($a, $b, @x)", $db);

        if (!($res = mysql_query("SELECT @x AS _result;"))) {
          echo "Query failed! \n";
          print mysql_error();
        } else {
          while ($myrow = mysql_fetch_array($res)) {
            echo "The value is ";
            echo $myrow['_result'];
          }
        }
      }
      
      if ($problem == "b") {
        $psw   = "'".$_POST['password']."'";
        $ssn   = $_POST['ssn'];
        $score = $_POST['score'];
        mysql_select_db("$dbname", $db);
        $result = mysql_query("CALL UpdateMidterm($psw, $ssn, $score)", $db);

        if (!($result)) {
          echo "Query failed! \n";
          print mysql_error();
        } else {
          while ($myrow = mysql_fetch_array($result)) {
            echo $myrow[0];
          }
        }
      }

      if ($problem == "c") {
        $psw   = "'".$_POST['password']."'";
        $ssn   = $_POST['ssn'];
        $score = $_POST['score'];
        mysql_select_db("$dbname", $db);
        $result = mysql_query("SELECT r.* 
                               FROM Rawscores AS r, Passwords AS p
                               WHERE r.SSN != '0001' AND r.SSN != '0002' AND p.CurPasswords = $psw
                               ORDER BY r.Section, r.LName, r.FName", $db);
        if (!($result)) {
          echo "Wrong Password \n";
          print mysql_error();
        } else {
          while ($myrow = mysql_fetch_array($result)) {
            foreach($myrow as $every) {
              printf("%s ", $every);
            } 
            printf("<br>");
          }
        }
      }
    }
  ?>


  <div>
    <a href="http://ugrad.cs.jhu.edu/~bli26/update">
      Click to go back to home!
    </a>
  </div>
  </body>
</html>

