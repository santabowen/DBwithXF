DROP VIEW TotalPoints;
CREATE VIEW TotalPoints AS 
       SELECT * 
       FROM Rawscores 
       WHERE SSN = '0001';

DROP VIEW Weights;
CREATE VIEW Weights AS 
       SELECT * 
       FROM Rawscores 
       WHERE SSN = '0002';

DROP VIEW WtdPts;
CREATE VIEW WtdPts AS 
       SELECT t.SSN, w.HW1/t.HW1 AS HW1, w.HW2a/t.HW2a AS HW2a, 
              w.HW2b/t.HW2b AS HW2b, w.Midterm/t.Midterm AS Midterm, 
              w.HW3/t.HW3 AS HW3, w.FExam/t.FExam AS FExam 
       FROM TotalPoints AS t, Weights AS w;

DELIMITER |

DROP PROCEDURE IF EXISTS CheckPassword;
|
CREATE PROCEDURE CheckPassword (PASSWORD VARCHAR(10))
BEGIN
  SELECT * 
  FROM Passwords
  WHERE CurPasswords = PASSWORD;
END
|

DROP PROCEDURE IF EXISTS CheckSSN;
|
CREATE PROCEDURE CheckSSN (s INT)
BEGIN
  SELECT * 
  FROM Rawscores 
  WHERE SSN = s;
END
|

DROP PROCEDURE IF EXISTS ShowRawScores;
|
CREATE PROCEDURE ShowRawScores (s INT)
BEGIN
  SELECT * 
  FROM Rawscores 
  WHERE SSN = s;
END
|

DROP PROCEDURE IF EXISTS ShowPercentages;
|
CREATE PROCEDURE ShowPercentages (s INT)
BEGIN
  SELECT r.SSN, r.LName, r.FName, r.Section, 
         FORMAT(w.HW1 * r.HW1 * 100, 2) AS HW1, FORMAT(w.HW2a * r.HW2a * 100, 2) AS HW2a, 
         FORMAT(w.HW2b * r.HW2b * 100, 2) AS HW2b, FORMAT(w.Midterm * r.Midterm * 100, 2) AS Midterm, 
         FORMAT(w.HW3 * r.HW3 * 100, 2) AS HW3, FORMAT(w.FExam * r.FExam * 100, 2) AS FExam
  FROM Rawscores AS r, WtdPts AS w 
  WHERE r.SSN = s;
  SELECT r.SSN, r.LName, r.FName, r.Section, 
         FORMAT((w.HW1 * r.HW1 + w.HW2a * r.HW2a + w.HW2b * r.HW2b + w.Midterm * r.Midterm + 
          w.HW3 * r.HW3 + w.FExam * r.FExam) * 100, 2) AS WeightedScore 
  FROM Rawscores AS r, WtdPts AS w 
  WHERE r.SSN = s;
END
|

DROP PROCEDURE IF EXISTS AllRawScores;
|

CREATE PROCEDURE AllRawScores (PASSWORD VARCHAR(20))
BEGIN
  SELECT r.*
  FROM Rawscores AS r, Passwords AS p
  WHERE r.SSN != '0001' AND r.SSN != '0002' AND p.CurPasswords = PASSWORD
  ORDER BY r.Section, r.LName, r.FName;
END
|

DROP PROCEDURE IF EXISTS AllPercentages;
|
CREATE PROCEDURE AllPercentages (PASSWORD VARCHAR(20))
BEGIN
  SELECT ws.SSN, ws.LName, ws.FName, ws.Section, FORMAT(ws.WeightedScore, 2)
  FROM (SELECT r.SSN, r.LName, r.FName, r.Section, 
               w.HW1 * r.HW1 * 100 AS HW1, w.HW2a * r.HW2a * 100 AS HW2a, 
               w.HW2b * r.HW2b * 100 AS HW2b, w.Midterm * r.Midterm * 100 AS Midterm, 
               w.HW3 * r.HW3 * 100 AS HW3, w.FExam * r.FExam * 100 AS FExam,
               (w.HW1 * r.HW1 + w.HW2a * r.HW2a + w.HW2b * r.HW2b + w.Midterm * r.Midterm 
                + w.HW3 * r.HW3 + w.FExam * r.FExam) * 100 AS WeightedScore 
        FROM Rawscores AS r, WtdPts AS w, Passwords AS p
        WHERE r.SSN != '0001' AND r.SSN != '0002' AND p.CurPasswords = PASSWORD) AS ws
  ORDER BY ws.Section, ws.WeightedScore;
END
|

DROP PROCEDURE IF EXISTS Stats;
|
CREATE PROCEDURE Stats ()
BEGIN
  SELECT "MEAN" AS Statistic, w.Section, FORMAT(AVG(w.HW1), 2) AS HW1, FORMAT(AVG(w.HW2a), 2) AS HW2a, 
         FORMAT(AVG(w.HW2b), 2) AS HW2b, FORMAT(AVG(w.Midterm),2) AS Midterm, 
         FORMAT(AVG(w.HW3), 2) AS HW3, FORMAT(AVG(w.FExam), 2) AS FExam, 
         FORMAT(AVG(w.WeightedScore), 2) AS WeightedScore
  FROM (SELECT r.SSN, r.LName, r.FName, r.Section, 
               w.HW1 * r.HW1 * 100 AS HW1, w.HW2a * r.HW2a * 100 AS HW2a, 
               w.HW2b * r.HW2b * 100 AS HW2b, w.Midterm * r.Midterm * 100 AS Midterm, 
               w.HW3 * r.HW3 * 100 AS HW3, w.FExam * r.FExam * 100 AS FExam,
               (w.HW1 * r.HW1 + w.HW2a * r.HW2a + w.HW2b * r.HW2b + w.Midterm * r.Midterm 
                + w.HW3 * r.HW3 + w.FExam * r.FExam) * 100 AS WeightedScore 
        FROM Rawscores AS r, WtdPts AS w
        WHERE r.SSN != '0001' AND r.SSN != '0002') AS w
  WHERE w.Section = "315";

  SELECT "MEAN" AS Statistic, w.Section, FORMAT(AVG(w.HW1), 2) AS HW1, FORMAT(AVG(w.HW2a), 2) AS HW2a, 
         FORMAT(AVG(w.HW2b), 2) AS HW2b, FORMAT(AVG(w.Midterm),2) AS Midterm, 
         FORMAT(AVG(w.HW3), 2) AS HW3, FORMAT(AVG(w.FExam), 2) AS FExam, 
         FORMAT(AVG(w.WeightedScore), 2) AS WeightedScore
  FROM (SELECT r.SSN, r.LName, r.FName, r.Section, 
               w.HW1 * r.HW1 * 100 AS HW1, w.HW2a * r.HW2a * 100 AS HW2a, 
               w.HW2b * r.HW2b * 100 AS HW2b, w.Midterm * r.Midterm * 100 AS Midterm, 
               w.HW3 * r.HW3 * 100 AS HW3, w.FExam * r.FExam * 100 AS FExam,
               (w.HW1 * r.HW1 + w.HW2a * r.HW2a + w.HW2b * r.HW2b + w.Midterm * r.Midterm 
                + w.HW3 * r.HW3 + w.FExam * r.FExam) * 100 AS WeightedScore 
        FROM Rawscores AS r, WtdPts AS w
        WHERE r.SSN != '0001' AND r.SSN != '0002') AS w
  WHERE w.Section = "415";

  SELECT "MINIMUM" AS Statistic, w.Section, FORMAT(MIN(w.HW1), 2) AS HW1, FORMAT(MIN(w.HW2a), 2) AS HW2a, 
         FORMAT(MIN(w.HW2b), 2) AS HW2b, FORMAT(MIN(w.Midterm),2) AS Midterm, 
         FORMAT(MIN(w.HW3), 2) AS HW3, FORMAT(MIN(w.FExam), 2) AS FExam, 
         FORMAT(MIN(w.WeightedScore), 2) AS WeightedScore
  FROM (SELECT r.SSN, r.LName, r.FName, r.Section, 
               w.HW1 * r.HW1 * 100 AS HW1, w.HW2a * r.HW2a * 100 AS HW2a, 
               w.HW2b * r.HW2b * 100 AS HW2b, w.Midterm * r.Midterm * 100 AS Midterm, 
               w.HW3 * r.HW3 * 100 AS HW3, w.FExam * r.FExam * 100 AS FExam,
               (w.HW1 * r.HW1 + w.HW2a * r.HW2a + w.HW2b * r.HW2b + w.Midterm * r.Midterm 
                + w.HW3 * r.HW3 + w.FExam * r.FExam) * 100 AS WeightedScore 
        FROM Rawscores AS r, WtdPts AS w
        WHERE r.SSN != '0001' AND r.SSN != '0002') AS w
  WHERE w.Section = "315";

  SELECT "MINIMUM" AS Statistic, w.Section, FORMAT(MIN(w.HW1), 2) AS HW1, FORMAT(MIN(w.HW2a), 2) AS HW2a, 
         FORMAT(MIN(w.HW2b), 2) AS HW2b, FORMAT(MIN(w.Midterm),2) AS Midterm, 
         FORMAT(MIN(w.HW3), 2) AS HW3, FORMAT(MIN(w.FExam), 2) AS FExam, 
         FORMAT(MIN(w.WeightedScore), 2) AS WeightedScore
  FROM (SELECT r.SSN, r.LName, r.FName, r.Section, 
               w.HW1 * r.HW1 * 100 AS HW1, w.HW2a * r.HW2a * 100 AS HW2a, 
               w.HW2b * r.HW2b * 100 AS HW2b, w.Midterm * r.Midterm * 100 AS Midterm, 
               w.HW3 * r.HW3 * 100 AS HW3, w.FExam * r.FExam * 100 AS FExam,
               (w.HW1 * r.HW1 + w.HW2a * r.HW2a + w.HW2b * r.HW2b + w.Midterm * r.Midterm 
                + w.HW3 * r.HW3 + w.FExam * r.FExam) * 100 AS WeightedScore 
        FROM Rawscores AS r, WtdPts AS w
        WHERE r.SSN != '0001' AND r.SSN != '0002') AS w
  WHERE w.Section = "415";

  SELECT "MAXIMUM" AS Statistic, w.Section, FORMAT(MAX(w.HW1), 2) AS HW1, FORMAT(MAX(w.HW2a), 2) AS HW2a, 
         FORMAT(MAX(w.HW2b), 2) AS HW2b, FORMAT(MAX(w.Midterm),2) AS Midterm, 
         FORMAT(MAX(w.HW3), 2) AS HW3, FORMAT(MAX(w.FExam), 2) AS FExam, 
         FORMAT(MAX(w.WeightedScore), 2) AS WeightedScore
  FROM (SELECT r.SSN, r.LName, r.FName, r.Section, 
               w.HW1 * r.HW1 * 100 AS HW1, w.HW2a * r.HW2a * 100 AS HW2a, 
               w.HW2b * r.HW2b * 100 AS HW2b, w.Midterm * r.Midterm * 100 AS Midterm, 
               w.HW3 * r.HW3 * 100 AS HW3, w.FExam * r.FExam * 100 AS FExam,
               (w.HW1 * r.HW1 + w.HW2a * r.HW2a + w.HW2b * r.HW2b + w.Midterm * r.Midterm 
                + w.HW3 * r.HW3 + w.FExam * r.FExam) * 100 AS WeightedScore 
        FROM Rawscores AS r, WtdPts AS w
        WHERE r.SSN != '0001' AND r.SSN != '0002') AS w
  WHERE w.Section = "315";

  SELECT "MAXIMUM" AS Statistic, w.Section, FORMAT(MAX(w.HW1), 2) AS HW1, FORMAT(MAX(w.HW2a), 2) AS HW2a, 
         FORMAT(MAX(w.HW2b), 2) AS HW2b, FORMAT(MAX(w.Midterm),2) AS Midterm, 
         FORMAT(MAX(w.HW3), 2) AS HW3, FORMAT(MAX(w.FExam), 2) AS FExam, 
         FORMAT(MAX(w.WeightedScore), 2) AS WeightedScore
  FROM (SELECT r.SSN, r.LName, r.FName, r.Section, 
               w.HW1 * r.HW1 * 100 AS HW1, w.HW2a * r.HW2a * 100 AS HW2a, 
               w.HW2b * r.HW2b * 100 AS HW2b, w.Midterm * r.Midterm * 100 AS Midterm, 
               w.HW3 * r.HW3 * 100 AS HW3, w.FExam * r.FExam * 100 AS FExam,
               (w.HW1 * r.HW1 + w.HW2a * r.HW2a + w.HW2b * r.HW2b + w.Midterm * r.Midterm 
                + w.HW3 * r.HW3 + w.FExam * r.FExam) * 100 AS WeightedScore 
        FROM Rawscores AS r, WtdPts AS w
        WHERE r.SSN != '0001' AND r.SSN != '0002') AS w
  WHERE w.Section = "415";

  SELECT "Std. Dev." AS Statistic, w.Section, FORMAT(STDDEV(w.HW1), 2) AS HW1, FORMAT(STDDEV(w.HW2a), 2) AS HW2a, 
         FORMAT(STDDEV(w.HW2b), 2) AS HW2b, FORMAT(STDDEV(w.Midterm),2) AS Midterm, 
         FORMAT(STDDEV(w.HW3), 2) AS HW3, FORMAT(STDDEV(w.FExam), 2) AS FExam, 
         FORMAT(STDDEV(w.WeightedScore), 2) AS WeightedScore
  FROM (SELECT r.SSN, r.LName, r.FName, r.Section, 
               w.HW1 * r.HW1 * 100 AS HW1, w.HW2a * r.HW2a * 100 AS HW2a, 
               w.HW2b * r.HW2b * 100 AS HW2b, w.Midterm * r.Midterm * 100 AS Midterm, 
               w.HW3 * r.HW3 * 100 AS HW3, w.FExam * r.FExam * 100 AS FExam,
               (w.HW1 * r.HW1 + w.HW2a * r.HW2a + w.HW2b * r.HW2b + w.Midterm * r.Midterm 
                + w.HW3 * r.HW3 + w.FExam * r.FExam) * 100 AS WeightedScore 
        FROM Rawscores AS r, WtdPts AS w
        WHERE r.SSN != '0001' AND r.SSN != '0002') AS w
  WHERE w.Section = "315";

  SELECT "Std. Dev." AS Statistic, w.Section, FORMAT(STDDEV(w.HW1), 2) AS HW1, FORMAT(STDDEV(w.HW2a), 2) AS HW2a, 
         FORMAT(STDDEV(w.HW2b), 2) AS HW2b, FORMAT(STDDEV(w.Midterm),2) AS Midterm, 
         FORMAT(STDDEV(w.HW3), 2) AS HW3, FORMAT(STDDEV(w.FExam), 2) AS FExam, 
         FORMAT(STDDEV(w.WeightedScore), 2) AS WeightedScore
  FROM (SELECT r.SSN, r.LName, r.FName, r.Section, 
               w.HW1 * r.HW1 * 100 AS HW1, w.HW2a * r.HW2a * 100 AS HW2a, 
               w.HW2b * r.HW2b * 100 AS HW2b, w.Midterm * r.Midterm * 100 AS Midterm, 
               w.HW3 * r.HW3 * 100 AS HW3, w.FExam * r.FExam * 100 AS FExam,
               (w.HW1 * r.HW1 + w.HW2a * r.HW2a + w.HW2b * r.HW2b + w.Midterm * r.Midterm 
                + w.HW3 * r.HW3 + w.FExam * r.FExam) * 100 AS WeightedScore 
        FROM Rawscores AS r, WtdPts AS w
        WHERE r.SSN != '0001' AND r.SSN != '0002') AS w
  WHERE w.Section = "415";
END
|

DROP PROCEDURE IF EXISTS ChangeScores;
|

CREATE PROCEDURE ChangeScores (PASSWORD VARCHAR(20), ssn VARCHAR(10), 
                               Assignmentname VARCHAR(10), NewScore INT)
BEGIN
  SET @a = Assignmentname;
  SET @s = ssn;
  SET @n = NewScore;
  SET @p = PASSWORD;
  SET @query = CONCAT("UPDATE Rawscores SET ", @a, " = ", @n," WHERE SSN = '", @s, 
    "' AND EXISTS (SELECT * FROM Passwords WHERE CurPasswords = '", @p, "');");
  PREPARE changesc FROM @query;
  SET @show = CONCAT("SELECT * FROM Rawscores WHERE SSN = '", @s,"';");
  PREPARE showscore FROM @show;
  EXECUTE showscore;
  EXECUTE changesc;
  EXECUTE showscore;
  DEALLOCATE PREPARE changesc;
  DEALLOCATE PREPARE showscore;
END
|

DROP PROCEDURE IF EXISTS MyCalc;
|

CREATE PROCEDURE MyCalc (IN first INT, IN second INT, OUT indicator INT)
BEGIN
  SELECT IF(first > second, 1, (SELECT IF(second > first, -1, 0))) INTO indicator;
END
|

DROP PROCEDURE IF EXISTS UpdateMidterm;
|

CREATE PROCEDURE UpdateMidterm (PASSWORD VARCHAR(20), ssn VARCHAR(10), NewScore INT)
BEGIN
  SET @s = ssn;
  SET @n = NewScore;
  SET @p = PASSWORD;
  SELECT IF( EXISTS(SELECT * FROM Passwords WHERE CurPasswords = PASSWORD), 
             (SELECT "Update successful!" AS result), (SELECT "Update failed!" AS result));
  SET @upmid = CONCAT("UPDATE Rawscores SET Midterm = ", @n," WHERE SSN = '", @s, 
    "' AND EXISTS (SELECT * FROM Passwords WHERE CurPasswords = '", @p, "');");
  PREPARE updatemid FROM @upmid;
  EXECUTE updatemid;
  DEALLOCATE PREPARE updatemid;
END
|




DELIMITER ;
