UPDATE projects 
SET 
    End_Date = NULL
WHERE
    status = 'Running';

-- Employee
UPDATE Employee 
SET 
    Employment_status = 'Inactive'
WHERE
    Employee_ID IN ('EMP016','EMP034','EMP052','EMP071','EMP089',
        'EMP101','EMP118','EMP135','EMP149','EMP167',
        'EMP182','EMP201','EMP219','EMP236','EMP248');