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
      
      if (!$db) {
        echo "Connection failed!";
      } else {
        $psw   = "'".$_POST['password']."'";
        $ssn   = $_POST['ssn'];
        $score = $_POST['score'];
        mysql_select_db("$dbname", $db);
        $checkpsw = mysql_query("SELECT * 
                               FROM Passwords
                               WHERE CurPasswords = $psw", $db);
        if($myrow = mysql_fetch_array($checkpsw)) {
          $result = mysql_query("SELECT r.* 
                               FROM Rawscores AS r, Passwords AS p
                               WHERE r.SSN != '0001' AND r.SSN != '0002' AND p.CurPasswords = $psw
                               ORDER BY r.Section, r.LName, r.FName", $db);
          while ($myrow = mysql_fetch_array($result)) {
            $index = 0;
            foreach($myrow as $every) {
              if ($index % 2 == 0){
                printf("%s ", $every);
              }
              $index = $index + 1;
            } 
            printf("<br>");
          }
        } else {
          echo "Wrong Password. <br>";
        }
      }
    ?>


    <div>
      <a href="http://ugrad.cs.jhu.edu/~bli26/list">
        Click to go back to home!
      </a>
    </div>
  </body>
</html>

