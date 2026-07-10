SELECT COUNT(*) FROM Region;
SELECT COUNT(*) FROM Department;
SELECT COUNT(*) FROM Employee;
SELECT COUNT(*) FROM Calendar;
SELECT COUNT(*) FROM Budget;
SELECT COUNT(*) FROM Revenue;
SELECT COUNT(*) FROM Expense;
SELECT COUNT(*) FROM Projects;
SELECT COUNT(*) FROM Audit;				

-- DUPLICATE CHECK
SELECT Employee_ID,
COUNT(*)
FROM Employee
GROUP BY Employee_ID
HAVING COUNT(*) > 1;

-- NULL VALUE CHECK 
SELECT *
FROM Employee
WHERE Department_ID IS NULL;

-- RELATIONSHIP CHECK 
SELECT
e.Employee_Name,
d.Department_Name
FROM Employee e
JOIN Department d
ON e.Department_ID = d.Department_ID;