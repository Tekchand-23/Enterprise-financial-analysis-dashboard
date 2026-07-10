-- Department Financial Performance
WITH BudgetSummary AS (
    SELECT Department_ID, ROUND(SUM(Budget_Amount),2) AS Total_Budget
    FROM Budget
    GROUP BY Department_ID
),
RevenueSummary AS (
    SELECT Department_ID, ROUND(SUM(Revenue_Amount),2) AS Total_Revenue
    FROM Revenue
    GROUP BY Department_ID
),
ExpenseSummary AS (
    SELECT Department_ID, ROUND(SUM(Amount),2) AS Total_Expense
    FROM Expense
    GROUP BY Department_ID
)
SELECT 
    d.Department_Name, 
    bs.Total_Budget, 
    rs.Total_Revenue, 
    es.Total_Expense
FROM Department d
JOIN BudgetSummary bs ON d.Department_ID = bs.Department_ID
JOIN RevenueSummary rs ON d.Department_ID = rs.Department_ID
JOIN ExpenseSummary es ON d.Department_ID = es.Department_ID
ORDER BY Total_Budget, Total_Revenue, Total_Expense DESC;

-- Revenue to Expense Ratio
WITH RevenueSummary AS
(
    SELECT Department_ID,
           SUM(Revenue_Amount) AS Revenue
    FROM Revenue
    GROUP BY Department_ID
),
ExpenseSummary AS
(
    SELECT Department_ID,
           SUM(Amount) AS Expense
    FROM Expense
    GROUP BY Department_ID
)

SELECT
    d.Department_Name,
    Revenue,
    Expense,
    ROUND(Revenue / NULLIF(Expense,0),2) AS Revenue_Expense_Ratio
FROM Department d
JOIN RevenueSummary r
ON d.Department_ID=r.Department_ID
JOIN ExpenseSummary e
ON d.Department_ID=e.Department_ID
ORDER BY Revenue_Expense_Ratio DESC;

-- Revenue per Employee
WITH RevenueData AS (
    SELECT Department_ID, SUM(Revenue_Amount) AS Revenue
    FROM Revenue
    GROUP BY Department_ID
),
EmployeeData AS (
    SELECT Department_ID, COUNT(Employee_ID) AS Employees
    FROM Employee
    GROUP BY Department_ID
)
SELECT 
    d.Department_Name,
    Revenue,
    Employees,
    ROUND(Revenue/Employees,2) AS Revenue_Per_Employee
FROM RevenueData r
JOIN EmployeeData e ON r.Department_ID = e.Department_ID
JOIN Department d ON r.Department_ID = d.Department_ID
ORDER BY Revenue_Per_Employee DESC;

-- Departments Needing Management Attention
WITH RevenueSummary AS
(
    SELECT Department_ID,
           SUM(Revenue_Amount) AS Revenue
    FROM Revenue
    GROUP BY Department_ID
),
ExpenseSummary AS
(
    SELECT Department_ID,
           SUM(Amount) AS Expense
    FROM Expense
    GROUP BY Department_ID
),
AuditSummary AS
(
    SELECT Department_ID,
           AVG(Compliance_Score) AS Compliance
    FROM Audit
    GROUP BY Department_ID
)

SELECT
    d.Department_Name,
    Revenue,
    Expense,
    ROUND(Compliance,2) AS Compliance,
    CASE
        WHEN Compliance < 75 THEN 'Low Compliance'
        WHEN Revenue < Expense THEN 'Financial Loss'
        ELSE 'Healthy'
    END AS Department_Status
FROM Department d
JOIN RevenueSummary r
ON d.Department_ID = r.Department_ID
JOIN ExpenseSummary e
ON d.Department_ID = e.Department_ID
JOIN AuditSummary a
ON d.Department_ID = a.Department_ID
ORDER BY Compliance ASC, Revenue - Expense ASC;

-- Department Performance Ranking
WITH RevenueSummary AS (
    SELECT Department_ID,
           SUM(Revenue_Amount) AS Revenue
    FROM Revenue
    GROUP BY Department_ID
)
SELECT
    d.Department_Name,
    Revenue,
    DENSE_RANK() OVER (ORDER BY Revenue DESC) AS Department_Rank
FROM RevenueSummary rs
JOIN Department d
    ON rs.Department_ID = d.Department_ID;

-- Executive Performance Report
WITH RevenueSummary AS (
    SELECT Department_ID, SUM(Revenue_Amount) AS Revenue
    FROM Revenue
    GROUP BY Department_ID
),
ExpenseSummary AS (
    SELECT Department_ID, SUM(Amount) AS Expense
    FROM Expense
    GROUP BY Department_ID
),
AuditSummary AS (
    SELECT Department_ID, ROUND(AVG(Compliance_Score),2) AS Compliance
    FROM Audit
    GROUP BY Department_ID
),
ProjectSummary AS (
    SELECT Department_ID, COUNT(Project_ID) AS Projects
    FROM Projects
    GROUP BY Department_ID
)
SELECT
    d.Department_Name,
    r.Revenue,
    e.Expense,
    a.Compliance,
    p.Projects,
    (r.Revenue - e.Expense) AS Profit
FROM Department d
LEFT JOIN RevenueSummary r ON d.Department_ID = r.Department_ID
LEFT JOIN ExpenseSummary e ON d.Department_ID = e.Department_ID
LEFT JOIN AuditSummary a ON d.Department_ID = a.Department_ID
LEFT JOIN ProjectSummary p ON d.Department_ID = p.Department_ID
ORDER BY Profit DESC;
