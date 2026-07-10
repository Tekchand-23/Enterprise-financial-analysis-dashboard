# CREATE REGION TABLE
CREATE TABLE Region (
    Region_ID VARCHAR(5) PRIMARY KEY,
    Region_Name VARCHAR(50) NOT NULL
);

# CREATE DEPARTMENT TABLE
CREATE TABLE Department (
    Department_ID VARCHAR(5) PRIMARY KEY,
    Department_Name VARCHAR(100) NOT NULL,
    Region_ID VARCHAR(5) NOT NULL,
    Manager_ID VARCHAR(10),
    Location VARCHAR(100)
);

# CREATE EMPLOYEE TABLE
CREATE TABLE Employee (
    Employee_ID VARCHAR(10) PRIMARY KEY,
    Employee_Name VARCHAR(100) NOT NULL,
    Gender VARCHAR(10),
    Age INT,
    Department_ID VARCHAR(5),
    Designation VARCHAR(100),
    Joining_Date DATE,
    Salary DECIMAL(12,2),
    Employment_Status VARCHAR(20)
);

# CREATE CALENDER TABLE
CREATE TABLE Calendar (
    Date DATE PRIMARY KEY,
    Year INT,
    Quarter VARCHAR(2),
    Month_Number INT,
    Month_Name VARCHAR(20),
    Week_Number INT,
    Day_Number INT,
    Day_Name VARCHAR(20),
    Is_Weekend VARCHAR(3)
);

# CREATE BUDGET TABLE
CREATE TABLE Budget (
    Budget_ID VARCHAR(10) PRIMARY KEY,
    Department_ID VARCHAR(5),
    Budget_Date DATE,
    Budget_Amount DECIMAL(12,2)
);

# CREATE REVENUE TABLE
CREATE TABLE Revenue (
    Revenue_ID VARCHAR(10) PRIMARY KEY,
    Department_ID VARCHAR(5),
    Revenue_Date DATE,
    Revenue_Amount DECIMAL(12,2)
);

# CREATE EXPENSE TABLE
CREATE TABLE Expense (
    Expense_ID VARCHAR(10) PRIMARY KEY,
    Department_ID VARCHAR(5),
    Expense_Date DATE,
    Expense_Type VARCHAR(50),
    Amount DECIMAL(12,2)
);

# CREATE PROJECTS TABLE
CREATE TABLE Projects (
    Project_ID VARCHAR(10) PRIMARY KEY,
    Department_ID VARCHAR(5),
    Project_Name VARCHAR(150),
    Start_Date DATE,
    End_Date DATE,
    Budget DECIMAL(12,2),
    Actual_Cost DECIMAL(12,2),
    Status VARCHAR(20)
);

# CREATE AUDIT TABLE
CREATE TABLE Audit (
    Audit_ID VARCHAR(10) PRIMARY KEY,
    Department_ID VARCHAR(5),
    Audit_Date DATE,
    Compliance_Score INT,
    Risk_Level VARCHAR(20),
    Observation_Count INT
);

