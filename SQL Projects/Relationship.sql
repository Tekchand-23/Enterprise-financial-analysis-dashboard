ALTER TABLE Department
ADD CONSTRAINT fk_department_region
FOREIGN KEY (Region_ID)
REFERENCES Region(Region_ID);

ALTER TABLE Employee
ADD CONSTRAINT fk_Employee_Department
FOREIGN KEY (Department_ID)
REFERENCES Department(Department_ID);

ALTER TABLE Budget
ADD CONSTRAINT fk_Budget_Department
FOREIGN KEY (Department_ID)
REFERENCES Department(Department_ID);

ALTER TABLE Revenue
ADD CONSTRAINT fk_Revenue_Department
FOREIGN KEY (Department_ID)
REFERENCES Department(Department_ID);

ALTER TABLE Expense
ADD CONSTRAINT fk_Expense_Department
FOREIGN KEY (Department_ID)
REFERENCES Department(Department_ID);

ALTER TABLE Projects
ADD CONSTRAINT fk_Projects_Department
FOREIGN KEY (Department_ID)
REFERENCES Department(Department_ID);

ALTER TABLE Audit
ADD CONSTRAINT fk_Audit_Department
FOREIGN KEY (Department_ID)
REFERENCES Department(Department_ID);