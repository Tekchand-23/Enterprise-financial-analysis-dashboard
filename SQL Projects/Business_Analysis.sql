## -- EMPLOYEE --
-- (Employee Count)
SELECT 
    COUNT(*) AS Total_Employees
FROM
    Employee;
    
-- Active vs Inactive Employees
SELECT 
    Employment_Status, COUNT(*) AS Total_Employee
FROM
    Employee
GROUP BY Employment_Status;

-- Employees by Department
SELECT 
    d.Department_Name, COUNT(e.Employee_ID) AS Total_Employee
FROM
    Department d
        LEFT JOIN
    Employee e ON d.Department_ID = e.Department_ID
GROUP BY d.Department_Name
ORDER BY Total_Employee DESC;

-- Average Salary by Department
SELECT 
    d.Department_Name, ROUND(AVG(e.Salary), 2) AS Average_Salary
FROM
    Department d
        LEFT JOIN
    Employee e ON d.Department_ID = e.Department_ID
GROUP BY d.Department_Name
ORDER BY Average_Salary DESC;

-- Highest Paid Employee
SELECT 
    Employee_Name, Designation, Salary
FROM
    Employee
ORDER BY Salary DESC
LIMIT 1;

-- Lowest Paid Employee with Department
SELECT 
    e.Employee_Name, e.Designation, e.Salary, d.Department_Name
FROM
    Employee e
        JOIN
    Department d ON e.Department_ID = d.Department_ID
ORDER BY e.Salary ASC
LIMIT 1; 

-- Gender-wise Employee Distribution
SELECT 
    Gender, COUNT(*) AS Total_Employee
FROM
    Employee
GROUP BY Gender;

-- Department wise Salary Expenses
SELECT 
    d.Department_Name,
    ROUND(SUM(e.Salary), 2) AS Total_Salary_Expense
FROM
    Employee e
        INNER JOIN
    Department d ON e.Department_ID = d.Department_ID
GROUP BY d.Department_Name
ORDER BY Total_Salary_Expense DESC;


## -- BUDGET-- 
-- Total Budget Allocated
SELECT 
    ROUND(SUM(Budget_Amount), 2) AS Total_Budget_Allocated
FROM
    Budget;
    
-- Department wise Budget Allocation
SELECT 
    d.Department_Name,
    ROUND(SUM(Budget_Amount), 2) AS Total_Budget_Allocated
FROM
    Department d
        LEFT JOIN
    Budget b ON d.Department_ID = b.Department_ID
GROUP BY d.Department_Name
ORDER BY Total_Budget_Allocated DESC;

-- Budget vs Actual Expense
SELECT 
    d.Department_Name,
    ROUND(SUM(b.Budget_Amount), 2) AS Total_Budget,
    ROUND(SUM(e.Amount), 2) AS Total_Expense
FROM
    Department d
        JOIN
    Budget b ON d.Department_ID = b.Department_ID
        JOIN
    Expense e ON d.Department_ID = e.Department_ID
GROUP BY d.Department_Name
ORDER BY Total_Budget DESC;

-- Budget Utilization %
SELECT 

    d.Department_Name,
    ROUND(SUM(b.Budget_Amount), 2) AS Total_Budget,
    ROUND(SUM(e.Amount), 2) AS Total_Expense,
    round((sum(e.Amount)/sum(b.Budget_Amount))*100,2) as Budget_utilization
FROM
    Department d
        JOIN
    Budget b ON d.Department_ID = b.Department_ID
        JOIN
    Expense e ON d.Department_ID = e.Department_ID
GROUP BY d.Department_Name
ORDER BY Budget_utilization DESC;

-- Budget Status
WITH BudgetSummary AS (
    SELECT Department_ID, SUM(Budget_Amount) AS Total_Budget
    FROM Budget
    GROUP BY Department_ID
),
ExpenseSummary AS (
    SELECT Department_ID, SUM(Amount) as Total_Expense
    FROM Expense
    GROUP BY Department_ID
)
SELECT 
    d.Department_Name,
    ROUND(b.Total_Budget, 2) AS Budget,
    ROUND(e.Total_Expense, 2) AS Expense,
    CASE
        WHEN e.Total_Expense > b.Total_Budget THEN 'Over Budget'
        WHEN e.Total_Expense >= b.Total_Budget * 0.80 THEN 'On Track'
        ELSE 'Under Budget'
    END AS Budget_Status
FROM Department d
JOIN BudgetSummary b ON d.Department_ID = b.Department_ID
JOIN ExpenseSummary e ON d.Department_ID = e.Department_ID;

-- Budget Ranking
SELECT Department_Name, Total_Budget, DENSE_RANK()
OVER(ORDER BY Total_Budget DESC) AS Budget_Rank
FROM( SELECT d.Department_Name, SUM(b.Budget_Amount) AS Total_Budget FROM Department d JOIN Budget b 
ON d.Department_ID=b.Department_ID GROUP BY d.Department_Name) x;

-- Above Average Budget Departments
SELECT 
    Department_Name, Total_Budget
FROM
    (SELECT 
        d.Department_Name, SUM(b.Budget_Amount) AS Total_Budget
    FROM
        Department d
    JOIN Budget b ON d.Department_ID = b.Department_ID
    GROUP BY d.Department_Name) x
WHERE
    Total_Budget > (SELECT 
            AVG(TotalBudget)
        FROM
            (SELECT 
                SUM(Budget_Amount) AS TotalBudget
            FROM
                Budget
            GROUP BY Department_ID) a);
            
-- Monthly Budget Trend
SELECT 
    YEAR(Budget_Date) AS Year,
    MONTHNAME(Budget_Date) AS Month,
    SUM(Budget_Amount) AS Budget
FROM
    Budget
GROUP BY YEAR(Budget_Date) , MONTHNAME(Budget_Date) , MONTH(Budget_Date)
ORDER BY Year , MONTH(Budget_Date);

-- Budget Distribution by Region
SELECT 
    r.Region_Name,
    ROUND(SUM(b.Budget_Amount), 2) AS Total_Budget
FROM
    Region r
        JOIN
    Department d ON r.Region_ID = d.Region_ID
        JOIN
    Budget b ON d.Department_ID = b.Department_ID
GROUP BY r.Region_Name
ORDER BY Total_Budget DESC;

## REVENUE
-- Total Revenue
SELECT 
    ROUND(SUM(Revenue_Amount), 2) AS Total_Revenue
FROM
    Revenue;

-- Department-wise Revenue
SELECT 
    d.Department_Name,
    ROUND(SUM(r.Revenue_Amount), 2) AS Total_Revenue
FROM
    Department d
        LEFT JOIN
    Revenue r ON d.Department_ID = r.Department_ID
GROUP BY d.Department_Name
ORDER BY Total_Revenue DESC;

-- Revenue by Region 
SELECT
    rg.Region_Name,
    ROUND(SUM(r.Revenue_Amount), 2) AS Total_Revenue
FROM
    Department d
        JOIN
    Revenue r ON d.Department_ID = r.Department_ID
        JOIN
    Region rg ON d.Region_ID = rg.Region_ID
GROUP BY rg.Region_Name
ORDER BY Total_Revenue DESC;

-- Average Revenue per Department
SELECT 
    d.Department_Name,
    ROUND(AVG(r.Revenue_Amount), 2) AS Average_Revenue
FROM
    Revenue r
        JOIN
    Department d ON r.Department_ID = d.Department_ID
GROUP BY d.Department_Name
ORDER BY Average_Revenue DESC;

-- Revenue Performance Status
SELECT 
    d.Department_Name,
    ROUND(SUM(r.Revenue_Amount), 2) AS Total_Revenue,
    CASE
        WHEN SUM(r.Revenue_Amount) >= 15000000 THEN 'Excellent'
        WHEN SUM(r.Revenue_Amount) >= 10000000 THEN 'Good'
        ELSE 'Low'
    END AS Performance_Status
FROM
    Revenue r
        JOIN
    Department d ON r.Department_ID = d.Department_ID
GROUP BY d.Department_Name;

-- Revenue Ranking
SELECT
Department_Name, Total_Revenue,
DENSE_RANK()
OVER(ORDER BY Total_Revenue DESC)AS Revenue_Rank
FROM
(SELECT
d.Department_Name, SUM(r.Revenue_Amount) AS Total_Revenue FROM Revenue r JOIN Department d
ON r.Department_ID=d.Department_ID GROUP BY d.Department_Name)x;

-- Above Average Revenue Departments
SELECT 
    Department_Name, Total_Revenue
FROM
    (SELECT 
        d.Department_Name, SUM(r.Revenue_Amount) AS Total_Revenue
    FROM
        Revenue r
    JOIN Department d ON r.Department_ID = d.Department_ID
    GROUP BY d.Department_Name) x
WHERE
    Total_Revenue > (SELECT 
            AVG(TotalRevenue)
        FROM
            (SELECT 
                SUM(Revenue_Amount) AS TotalRevenue
            FROM
                Revenue
            GROUP BY Department_ID) a);
            
-- Monthly Revenue Trend
SELECT 
    YEAR(Revenue_Date) AS Year,
    MONTHNAME(Revenue_Date) AS Month,
    ROUND(SUM(Revenue_Amount), 2) AS Monthly_Revenue
FROM
    Revenue
GROUP BY YEAR(Revenue_Date) , MONTH(Revenue_Date) , MONTHNAME(Revenue_Date)
ORDER BY Year , MONTH(Revenue_Date);

## EXPENSE 
-- Total Organization Expense 
SELECT 
    ROUND(SUM(Amount), 2) AS Total_Expense
FROM
    Expense;
    
-- Department Spendind More than 1 Crore 
SELECT 
    d.Department_Name, ROUND(SUM(e.Amount), 2) AS Total_Expense
FROM
    Department d
        LEFT JOIN
    Expense e ON d.Department_ID = e.Department_ID
GROUP BY d.Department_Name
HAVING ROUND(SUM(e.Amount), 2) > 10000000
ORDER BY Total_Expense DESC;

-- Month Expense Trend 
SELECT 
    DATE_FORMAT(Expense_Date, '%Y-%M') AS Expense_Month,
    ROUND(SUM(Amount), 2) AS Total_Expense
FROM
    Expense
GROUP BY Expense_Month
ORDER BY Total_Expense;

-- Department-wise Expense using CTE
WITH ExpenseSummary AS (
    SELECT
        Department_ID,
        SUM(Amount) AS Total_Expense
    FROM Expense
    GROUP BY Department_ID
)
SELECT
    d.Department_Name,
    e.Total_Expense
FROM ExpenseSummary e
JOIN Department d
    ON e.Department_ID = d.Department_ID
ORDER BY e.Total_Expense DESC;

-- Expense level
SELECT 
    Expense_ID,
    Amount,
    CASE
        WHEN Amount >= 250000 THEN 'High'
        WHEN Amount >= 100000 THEN 'Medium'
        ELSE 'Low'
    END AS Expense_level
FROM
    Expense;
    
-- Month-over-Month Expense Growth
WITH MonthlyExpense AS (
    SELECT 
        DATE_FORMAT(Expense_Date, '%Y-%m') AS Expense_Month,
        SUM(Amount) AS Monthly_Expense
    FROM Expense
    GROUP BY DATE_FORMAT(Expense_Date, '%Y-%m')
)
SELECT 
    Expense_Month,
    Monthly_Expense,
    LAG(Monthly_Expense) OVER (ORDER BY Expense_Month) AS Previous_Month_Expense
FROM MonthlyExpense;

-- Top Expense Transactions
SELECT 
    Expense_ID, 
    Amount, 
    ROW_NUMBER() OVER (ORDER BY Amount DESC) AS Row_No
FROM Expense;

-- Expense Quartiles
SELECT
	Expense_ID, 
    Amount, 
    NTILE(4) OVER (ORDER BY Amount DESC) AS Expense_Group 
FROM Expense;


## PROJECT
-- Total Project
SELECT 
    COUNT(*) AS Total_Project
FROM
    Projects;
    
-- Project Status Analysis
SELECT 
    status, COUNT(Project_ID) AS Total_Project
FROM
    Projects
GROUP BY status
ORDER BY Total_project DESC;

-- Department-wise Projects
SELECT 
    d.Department_Name, COUNT(p.Project_ID) AS Total_project
FROM
    Department d
        JOIN
    Projects p ON d.Department_ID = p.Department_ID
GROUP BY d.Department_Name
ORDER BY Total_Project DESC;

-- Budget vs Actual Cost Analysis
SELECT 
    Project_ID,
    Project_Name,
    Budget,
    Actual_Cost,
    (Actual_Cost - Budget) AS Cost_Varience,
    ROUND(((Actual_Cost - Budget) / Budget) * 100,
            2) AS varience_Percentage
FROM
    Projects;
    
-- Over Budget Projects
SELECT 
    Project_ID,
    Project_Name,
    Budget,
    Actual_Cost,
    ROUND(((Actual_Cost - Budget) / Budget) * 100,
            2) AS over_budget_project
FROM
    Projects
WHERE
    Actual_Cost > Budget
ORDER BY over_budget_project DESC;

-- High Workload Departments
SELECT
    d.Department_Name,
    COUNT(p.Project_ID) AS Total_Projects
FROM Projects p
JOIN Department d
ON p.Department_ID = d.Department_ID
GROUP BY d.Department_Name
HAVING COUNT(p.Project_ID) >
(
    SELECT AVG(Project_Count)
    FROM
    (
        SELECT COUNT(*) AS Project_Count
        FROM Projects
        GROUP BY Department_ID
    ) AS AvgProjects
);

-- Top 5 Most Expensive Projects
SELECT 
    Project_ID, Project_Name, Actual_Cost
FROM
    projects
ORDER BY Actual_Cost DESC
LIMIT 5;

-- Department Project Cost Summary (CTE)
WITH ProjectCost AS (
    SELECT 
        Department_ID, 
        SUM(Actual_Cost) AS Total_Cost 
    FROM Projects 
    GROUP BY Department_ID
)
SELECT 
    d.Department_Name,
    pc.Total_Cost
FROM ProjectCost pc
JOIN Department d 
    ON pc.Department_ID = d.Department_ID;

## AUDIT 
-- Department-wise Average Compliance Score
SELECT 
    d.Department_Name,
    ROUND(AVG(a.Compliance_Score), 2) AS Avg_Compliance_Score
FROM
    Department d
        JOIN
    Audit a ON d.Department_ID = a.Department_ID
GROUP BY d.Department_Name
ORDER BY Avg_Compliance_Score DESC;

-- Risk Level Distribution
SELECT 
    Risk_Level, COUNT(*) AS Total_Audit
FROM
    Audit
GROUP BY Risk_Level
ORDER BY Total_Audit DESC;

-- Department-wise Total Audit Observations
SELECT 
    d.Department_Name,
    ROUND(SUM(a.Observation_Count), 2) AS Total_Observation
FROM
    Department d
        JOIN
    Audit a ON d.Department_ID = a.Department_ID
GROUP BY d.Department_Name
ORDER BY Total_Observation DESC;

-- Compliance Performance Category
SELECT 
    Audit_ID,
    Audit_Date,
    Compliance_Score,
    CASE
        WHEN Compliance_Score >= 90 THEN 'Excellence'
        WHEN Compliance_Score >= 75 THEN 'Good'
        WHEN Compliance_Score >= 60 THEN 'Average'
        ELSE 'Need Improvement'
    END AS Compliance_Status
FROM
    Audit;
    
-- Departments Having Above Average Audit Observations
SELECT 
    d.Department_Name,
    SUM(a.observation_Count) AS Total_Observation
FROM
    Department d
        JOIN
    Audit a ON d.Department_ID = a.Department_ID
GROUP BY d.Department_Name
HAVING SUM(a.observation_Count) > (SELECT 
        AVG(Total_Observation)
    FROM
        (SELECT 
            SUM(Observation_Count) AS Total_Observation
        FROM
            Audit
        GROUP BY Department_ID) AS observation_Summary);
    
-- Region-wise Average Compliance Score
SELECT 
    Region_Name, AVG(a.Compliance_Score) AS Avg_Compliance_Score
FROM
    Department d
        JOIN
    Region r ON d.Region_ID = r.Region_ID
        JOIN
    Audit a ON d.Department_ID = a.Department_ID
GROUP BY r.Region_Name
ORDER BY Avg_Compliance_Score DESC;

-- Audit Summary using CTE
WITH AuditSummary AS (
    SELECT 
        Department_ID, 
        COUNT(Audit_ID) AS Total_Audit, 
        ROUND(AVG(Compliance_Score), 2) AS Total_Compliance
    FROM Audit 
    GROUP BY Department_ID
)
SELECT 
    d.Department_Name, 
    au.Total_Audit, 
    au.Total_Compliance
FROM AuditSummary au
JOIN Department d 
    ON au.Department_ID = d.Department_ID
ORDER BY Total_Compliance DESC;

-- Top 5 Departments with Lowest Compliance Score
SELECT 
    d.Department_Name,
    ROUND(AVG(Compliance_Score), 2) AS Avg_Compliance_Score
FROM
    Department d
        JOIN
    Audit a ON d.Department_ID = a.Department_ID
GROUP BY d.Department_Name
ORDER BY Avg_Compliance_Score ASC;

## CALENDER
-- Monthly Revenue Trend
SELECT 
    c.Year, c.Month_Name, SUM(r.Revenue_Amount) AS Total_Revenue
FROM
    Revenue r
        JOIN
    Calendar c ON r.Revenue_Date = c.Date
GROUP BY c.Year , c.Month_Number , c.Month_Name
ORDER BY c.Year , c.Month_Number;

-- Quarter-wise Expense Analysis
SELECT 
    c.Year, c.Quarter, SUM(e.Amount) AS Total_Expense
FROM
    Expense e
        JOIN
    Calendar c ON e.Expense_Date = c.Date
GROUP BY c.Year , c.Quarter
ORDER BY c.Year , c.Quarter;

-- Budget Allocation by Quarter
SELECT 
    c.Year, c.Quarter, SUM(b.Budget_Amount) AS Total_Budget
FROM
    Budget b
        JOIN
    Calendar c ON b.Budget_Date = c.Date
GROUP BY c.Year , c.Quarter
ORDER BY c.Year , c.Quarter;

-- Weekday vs Weekend Project Starts
SELECT 
    c.Is_Weekend, COUNT(p.Project_ID) AS Total_Projects
FROM
    Projects p
        JOIN
    Calendar c ON p.Start_Date = c.Date
GROUP BY c.Is_Weekend;

-- Audit Trend by Quarter
SELECT 
    c.Year,
    c.Quarter,
    ROUND(AVG(a.Compliance_Score), 2) AS Avg_Compliance
FROM
    Audit a
        JOIN
    Calendar c ON a.Audit_Date = c.Date
GROUP BY c.Year , c.Quarter
ORDER BY c.Year , c.Quarter;

## Region 
-- Region-wise Revenue
SELECT 
    r.Region_Name,
    ROUND(SUM(rv.Revenue_Amount), 2) AS Total_Revenue
FROM
    Revenue rv
        JOIN
    Department d ON rv.Department_ID = d.Department_ID
        JOIN
    Region r ON d.Region_ID = r.Region_ID
GROUP BY r.Region_Name
ORDER BY Total_Revenue DESC;

-- Region-wise Expense
SELECT 
    r.Region_Name, ROUND(SUM(e.Amount), 2) AS Total_Expense
FROM
    Expense e
        JOIN
    Department d ON e.Department_ID = d.Department_ID
        JOIN
    Region r ON d.Region_ID = r.Region_ID
GROUP BY r.Region_Name
ORDER BY Total_Expense DESC;

-- Region-wise Average Compliance Score
SELECT 
    r.Region_Name,
    ROUND(AVG(a.Compliance_Score), 2) AS Avg_Compliance_Score
FROM
    Audit a
        JOIN
    Department d ON a.Department_ID = d.Department_ID
        JOIN
    Region r ON d.Region_ID = r.Region_ID
GROUP BY r.Region_Name
ORDER BY Avg_Compliance_Score DESC;

-- Region-wise Employee & Project Summary
SELECT 
    r.Region_Name,
    COUNT(DISTINCT e.Employee_ID) AS Total_Employees,
    COUNT(DISTINCT p.Project_ID) AS Total_Projects
FROM
    Region r
        JOIN
    Department d ON r.Region_ID = d.Region_ID
        LEFT JOIN
    Employee e ON d.Department_ID = e.Department_ID
        LEFT JOIN
    Projects p ON d.Department_ID = p.Department_ID
GROUP BY r.Region_Name
ORDER BY Total_Employees DESC;

-- Best Performing Region
SELECT 
    r.Region_Name,
    ROUND(AVG(a.Compliance_Score), 2) AS Avg_Compliance,
    SUM(rv.Revenue_Amount) AS Total_Revenue,
    SUM(e.Amount) AS Total_Expense
FROM
    Region r
        JOIN
    Department d ON r.Region_ID = d.Region_ID
        JOIN
    Audit a ON d.Department_ID = a.Department_ID
        JOIN
    Revenue rv ON d.Department_ID = rv.Department_ID
        JOIN
    Expense e ON d.Department_ID = e.Department_ID
GROUP BY r.Region_Name
HAVING AVG(a.Compliance_Score) > 85
    AND SUM(rv.Revenue_Amount) > SUM(e.Amount)
ORDER BY Avg_Compliance DESC;

 





