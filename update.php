<html>
  <head>
    <title>Update</title>
  </head>
  <body>



  <?php
  // PHP code just started

  ini_set('error_reporting', E_ALL);
  ini_set('display_errors', true);
  // display errors

  $db = mysql_connect("dbase.cs.jhu.edu", "your_username", "your_password");
  // ********* Remember to use your MySQL username and password here ********* //

  if (!$db) {

  echo "Connection failed!";

  } else {

  $str = $_POST['str'];
  // This says that the $str variable should be assigned a value obtained as an
  // input to the PHP code. In this case, the input is called 'str'.

  mysql_select_db("your_db_name",$db);
  // ********* Remember to use the name of your database here ********* //

  $result1 = mysql_query("CALL strLen('$str',@x)",$db);
  // a simple call to a MySQL stored procedure.

  $result2 = mysql_query("SELECT @x AS x_val",$db);
  // Yes, this actually works!

  if (!$result1) {

  echo "Query 1 failed!\n";
  print mysql_error();

  } else {

  if (!$result2) {

  echo "Query 2 failed!\n";
  print mysql_error();

  } else {

  echo "The value of @x (i.e. the length) is:";
  echo "<table border=1>\n";
  echo "<tr><td>x_val</td></tr>\n";

  while ($myrow = mysql_fetch_array($result2)) {
    printf("<tr><td>%s</td></tr>\n", $myrow["x_val"]);
  }

  echo "</table>\n";

  }

  }

  }

  // PHP code about to end

  ?>



  </body>
</html>