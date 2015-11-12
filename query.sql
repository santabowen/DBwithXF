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

DROP PROCEDURE IF EXISTS ShowRawScores;
|
CREATE PROCEDURE ShowRawScores (SSN INT)
BEGIN
  SELECT * 
  FROM Rawscores 
  WHERE SSN = SSN;
END
|

DROP PROCEDURE IF EXISTS ShowPercentages;
|
CREATE PROCEDURE ShowPercentages (SSN INT)
BEGIN
  SELECT r.SSN, r.LName, r.FName, r.Section, 
         w.HW1 * r.HW1 * 100 AS HW1, w.HW2a * r.HW2a * 100 AS HW2a, 
         w.HW2b * r.HW2b * 100 AS HW2b, w.Midterm * r.Midterm * 100 AS Midterm, 
         w.HW3 * r.HW3 * 100 AS HW3, w.FExam * r.FExam * 100 AS FExam
  FROM Rawscores AS r, WtdPts AS w 
  WHERE r.SSN = SSN;
  SELECT r.SSN, r.LName, r.FName, r.Section, 
         (w.HW1 * r.HW1 + w.HW2a * r.HW2a + w.HW2b * r.HW2b + w.Midterm * r.Midterm + 
          w.HW3 * r.HW3 + w.FExam * r.FExam) * 100 AS WeightedScore 
  FROM Rawscores AS r, WtdPts AS w 
  WHERE r.SSN = SSN;
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
  SELECT ws.SSN, ws.LName, ws.FName, ws.Section, ws.WeightedScore
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
  SELECT "MEAN" AS Statistic, AVG(w.HW1) AS HW1, AVG(w.HW2a) AS HW2a, AVG(w.HW2b) AS HW2b, 
         AVG(w.Midterm) AS Midterm, AVG(w.HW3) AS HW3, AVG(w.FExam) AS FExam, 
         AVG(w.WeightedScore) AS WeightedScore
  FROM (SELECT r.SSN, r.LName, r.FName, r.Section, 
               w.HW1 * r.HW1 * 100 AS HW1, w.HW2a * r.HW2a * 100 AS HW2a, 
               w.HW2b * r.HW2b * 100 AS HW2b, w.Midterm * r.Midterm * 100 AS Midterm, 
               w.HW3 * r.HW3 * 100 AS HW3, w.FExam * r.FExam * 100 AS FExam,
               (w.HW1 * r.HW1 + w.HW2a * r.HW2a + w.HW2b * r.HW2b + w.Midterm * r.Midterm 
                + w.HW3 * r.HW3 + w.FExam * r.FExam) * 100 AS WeightedScore 
        FROM Rawscores AS r, WtdPts AS w
        WHERE r.SSN != '0001' AND r.SSN != '0002') AS w
  WHERE w.Section = "315";

  SELECT "MEAN" AS Statistic, AVG(w.HW1) AS HW1, AVG(w.HW2a) AS HW2a, AVG(w.HW2b) AS HW2b, 
         AVG(w.Midterm) AS Midterm, AVG(w.HW3) AS HW3, AVG(w.FExam) AS FExam, 
         AVG(w.WeightedScore) AS WeightedScore
  FROM (SELECT r.SSN, r.LName, r.FName, r.Section, 
               w.HW1 * r.HW1 * 100 AS HW1, w.HW2a * r.HW2a * 100 AS HW2a, 
               w.HW2b * r.HW2b * 100 AS HW2b, w.Midterm * r.Midterm * 100 AS Midterm, 
               w.HW3 * r.HW3 * 100 AS HW3, w.FExam * r.FExam * 100 AS FExam,
               (w.HW1 * r.HW1 + w.HW2a * r.HW2a + w.HW2b * r.HW2b + w.Midterm * r.Midterm 
                + w.HW3 * r.HW3 + w.FExam * r.FExam) * 100 AS WeightedScore 
        FROM Rawscores AS r, WtdPts AS w
        WHERE r.SSN != '0001' AND r.SSN != '0002') AS w
  WHERE w.Section = "415";

  SELECT "MINIMUM" AS Statistic, MIN(w.HW1) AS HW1, MIN(w.HW2a) AS HW2a, MIN(w.HW2b) AS HW2b, 
         MIN(w.Midterm) AS Midterm, MIN(w.HW3) AS HW3, MIN(w.FExam) AS FExam, 
         MIN(w.WeightedScore) AS WeightedScore
  FROM (SELECT r.SSN, r.LName, r.FName, r.Section, 
               w.HW1 * r.HW1 * 100 AS HW1, w.HW2a * r.HW2a * 100 AS HW2a, 
               w.HW2b * r.HW2b * 100 AS HW2b, w.Midterm * r.Midterm * 100 AS Midterm, 
               w.HW3 * r.HW3 * 100 AS HW3, w.FExam * r.FExam * 100 AS FExam,
               (w.HW1 * r.HW1 + w.HW2a * r.HW2a + w.HW2b * r.HW2b + w.Midterm * r.Midterm 
                + w.HW3 * r.HW3 + w.FExam * r.FExam) * 100 AS WeightedScore 
        FROM Rawscores AS r, WtdPts AS w
        WHERE r.SSN != '0001' AND r.SSN != '0002') AS w
  WHERE w.Section = "315";

  SELECT "MINIMUM" AS Statistic, MIN(w.HW1) AS HW1, MIN(w.HW2a) AS HW2a, MIN(w.HW2b) AS HW2b, 
         MIN(w.Midterm) AS Midterm, MIN(w.HW3) AS HW3, MIN(w.FExam) AS FExam, 
         MIN(w.WeightedScore) AS WeightedScore
  FROM (SELECT r.SSN, r.LName, r.FName, r.Section, 
               w.HW1 * r.HW1 * 100 AS HW1, w.HW2a * r.HW2a * 100 AS HW2a, 
               w.HW2b * r.HW2b * 100 AS HW2b, w.Midterm * r.Midterm * 100 AS Midterm, 
               w.HW3 * r.HW3 * 100 AS HW3, w.FExam * r.FExam * 100 AS FExam,
               (w.HW1 * r.HW1 + w.HW2a * r.HW2a + w.HW2b * r.HW2b + w.Midterm * r.Midterm 
                + w.HW3 * r.HW3 + w.FExam * r.FExam) * 100 AS WeightedScore 
        FROM Rawscores AS r, WtdPts AS w
        WHERE r.SSN != '0001' AND r.SSN != '0002') AS w
  WHERE w.Section = "415";

  SELECT "MAXIMUM" AS Statistic, MAX(w.HW1) AS HW1, MAX(w.HW2a) AS HW2a, MAX(w.HW2b) AS HW2b, 
         MAX(w.Midterm) AS Midterm, MAX(w.HW3) AS HW3, MAX(w.FExam) AS FExam, 
         MAX(w.WeightedScore) AS WeightedScore
  FROM (SELECT r.SSN, r.LName, r.FName, r.Section, 
               w.HW1 * r.HW1 * 100 AS HW1, w.HW2a * r.HW2a * 100 AS HW2a, 
               w.HW2b * r.HW2b * 100 AS HW2b, w.Midterm * r.Midterm * 100 AS Midterm, 
               w.HW3 * r.HW3 * 100 AS HW3, w.FExam * r.FExam * 100 AS FExam,
               (w.HW1 * r.HW1 + w.HW2a * r.HW2a + w.HW2b * r.HW2b + w.Midterm * r.Midterm 
                + w.HW3 * r.HW3 + w.FExam * r.FExam) * 100 AS WeightedScore 
        FROM Rawscores AS r, WtdPts AS w
        WHERE r.SSN != '0001' AND r.SSN != '0002') AS w
  WHERE w.Section = "315";

  SELECT "MAXIMUM" AS Statistic, MAX(w.HW1) AS HW1, MAX(w.HW2a) AS HW2a, MAX(w.HW2b) AS HW2b, 
         MAX(w.Midterm) AS Midterm, MAX(w.HW3) AS HW3, MAX(w.FExam) AS FExam, 
         MAX(w.WeightedScore) AS WeightedScore
  FROM (SELECT r.SSN, r.LName, r.FName, r.Section, 
               w.HW1 * r.HW1 * 100 AS HW1, w.HW2a * r.HW2a * 100 AS HW2a, 
               w.HW2b * r.HW2b * 100 AS HW2b, w.Midterm * r.Midterm * 100 AS Midterm, 
               w.HW3 * r.HW3 * 100 AS HW3, w.FExam * r.FExam * 100 AS FExam,
               (w.HW1 * r.HW1 + w.HW2a * r.HW2a + w.HW2b * r.HW2b + w.Midterm * r.Midterm 
                + w.HW3 * r.HW3 + w.FExam * r.FExam) * 100 AS WeightedScore 
        FROM Rawscores AS r, WtdPts AS w
        WHERE r.SSN != '0001' AND r.SSN != '0002') AS w
  WHERE w.Section = "415";

  SELECT "Std. Dev." AS Statistic, STDDEV(w.HW1) AS HW1, STDDEV(w.HW2a) AS HW2a, 
         STDDEV(w.HW2b) AS HW2b, STDDEV(w.Midterm) AS Midterm, STDDEV(w.HW3) AS HW3, 
         STDDEV(w.FExam) AS FExam, STDDEV(w.WeightedScore) AS WeightedScore
  FROM (SELECT r.SSN, r.LName, r.FName, r.Section, 
               w.HW1 * r.HW1 * 100 AS HW1, w.HW2a * r.HW2a * 100 AS HW2a, 
               w.HW2b * r.HW2b * 100 AS HW2b, w.Midterm * r.Midterm * 100 AS Midterm, 
               w.HW3 * r.HW3 * 100 AS HW3, w.FExam * r.FExam * 100 AS FExam,
               (w.HW1 * r.HW1 + w.HW2a * r.HW2a + w.HW2b * r.HW2b + w.Midterm * r.Midterm 
                + w.HW3 * r.HW3 + w.FExam * r.FExam) * 100 AS WeightedScore 
        FROM Rawscores AS r, WtdPts AS w
        WHERE r.SSN != '0001' AND r.SSN != '0002') AS w
  WHERE w.Section = "315";

  SELECT "Std. Dev." AS Statistic, STDDEV(w.HW1) AS HW1, STDDEV(w.HW2a) AS HW2a, 
         STDDEV(w.HW2b) AS HW2b, STDDEV(w.Midterm) AS Midterm, STDDEV(w.HW3) AS HW3, 
         STDDEV(w.FExam) AS FExam, STDDEV(w.WeightedScore) AS WeightedScore
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
  SET @query = CONCAT("UPDATE Rawscores SET ", @a, " = ", @n," WHERE SSN = '", 
      @s, "' AND EXISTS (SELECT * FROM Passwords WHERE CurPasswords = '", @p, "');");
  PREPARE changesc FROM @query;
  EXECUTE changesc;
  DEALLOCATE PREPARE changesc;
END
|

DELIMITER ;
