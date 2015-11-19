1.
SELECT h.*
FROM HEALTH AS h, Families AS f
WHERE f.ChildrenPerHousehold >= 2 AND f.State = h.State AND f.Year = h.Year;

2.
SELECT e.*
FROM Economy AS e, 
     (SELECT od.*
      FROM (SELECT d.*
            FROM DiplomaRate AS d
            ORDER BY d.HighSchool) AS od
      LIMIT 10) AS temp
WHERE e.State = temp.State AND e.Year = temp.Year;

3.
SELECT i.PerCapitaIncome, i.MedianHouseholdIncome, f.*
FROM Income AS i, Families AS f, Sex AS s
WHERE s.Male > s.Female AND i.State = f.State AND i.Year = f.Year AND f.State = s.State AND f.Year = s.Year;

4.
SELECT i.PerCapitaIncome, i.MedianHouseholdIncome, f.*
FROM Income AS i, Families AS f, Sex AS s
WHERE s.Male < s.Female AND i.State = f.State AND i.Year = f.Year AND f.State = s.State AND f.Year = s.Year;
