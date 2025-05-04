
--1. Retrieve a list of all roles in the company, which should include the number of employees for each of role assigned
SELECT 
    r.role_name,
    COUNT(DISTINCT epr.employee_id) AS employee_count
FROM 
    [dbo].[Roles] r
LEFT JOIN 
    [dbo].[Employee_Project_Roles] epr ON r.role_id = epr.role_id
GROUP BY 
    r.role_id, r.role_name
ORDER BY 
    employee_count DESC;


--2. Get roles which has no employees assigned

SELECT 
    r.role_id,
    r.role_name
FROM 
    [dbo].[Roles] r
LEFT JOIN 
    [dbo].[Employee_Project_Roles] epr ON r.role_id = epr.role_id
WHERE epr.employee_id IS NULL;

--  3. Get projects list where every project has list of roles supplied with number of employees
SELECT * FROM [dbo].[Projects];
SELECT * FROM  [dbo].[Employee_Project_Roles];
SELECT * FROM [dbo].[Roles];

SELECT 
    p.project_name,
    r.role_name,
    COUNT(DISTINCT epr.employee_id) AS employee_count
FROM 
    [dbo].[Projects] p
JOIN 
    [dbo].[Employee_Project_Roles] epr ON p.project_id = epr.project_id
JOIN 
    [dbo].[Roles] r ON epr.role_id = r.role_id
GROUP BY 
    p.project_id, p.project_name, r.role_name
ORDER BY 
    p.project_id, r.role_name;

-- 4.  For every project count how many tasks there are assigned for every employee in average

SELECT 
    p.project_name,
    COUNT(t.task_id) AS total_tasks,
    COUNT(DISTINCT t.assigned_to) AS employees_with_tasks,
    CASE 
        WHEN COUNT(DISTINCT t.assigned_to) > 0 
        THEN CAST(COUNT(t.task_id) AS FLOAT) / COUNT(DISTINCT t.assigned_to)
        ELSE 0
    END AS avg_tasks_per_employee
FROM 
    [dbo].[Projects] p
LEFT JOIN 
    [dbo].[Tasks] t ON p.project_id = t.project_id
GROUP BY 
    p.project_id, p.project_name;

-- 5. Determine duration for each project

SELECT 
    project_name,
    CASE 
        WHEN close_date IS NOT NULL 
        THEN DATEDIFF(DAY, creation_date, close_date)
        ELSE DATEDIFF(DAY, creation_date, GETDATE()) -- no close date --> duration up to today 
    END AS duration_days
FROM 
    [dbo].[Projects];

--6.Identify which employees has the lowest number tasks with non-closed statuses.

SELECT 
    e.employee_id,
    e.first_name + ' ' + e.last_name AS employee_name,
    COUNT(t.task_id) AS open_tasks
FROM [dbo].[Employee] e
LEFT JOIN [dbo].[Tasks] t ON e.employee_id = t.assigned_to
LEFT JOIN (
    SELECT 
        task_id, 
        MAX(sh.date) AS latest_date
    FROM [dbo].[Status_History] sh
    GROUP BY task_id
) latest ON t.task_id = latest.task_id
LEFT JOIN [dbo].[Status_History] sh ON latest.task_id = sh.task_id AND latest.latest_date = sh.date
WHERE sh.status_id IN (1, 3) OR sh.status_id IS NULL
GROUP BY e.employee_id, e.first_name, e.last_name
ORDER BY open_tasks;

--7. Identify which employees has the most tasks with non-closed statuses with failed deadlines.
SELECT
    e.full_name,
    COUNT(pt.id) AS overdue_tasks
FROM employees e
JOIN employee_tasks et ON e.id = et.employee_id
JOIN project_tasks pt ON et.task_id = pt.id
WHERE pt.status != 'closed' AND pt.deadline < CURRENT_DATE
GROUP BY e.id
ORDER BY overdue_tasks DESC;

--8. For each project count how many there are tasks which were not started yet.
SELECT
    p.name AS project_name,
    COUNT(pt.id) AS not_started_tasks
FROM projects p
JOIN project_tasks pt ON p.id = pt.project_id
WHERE pt.status = 'not started'
GROUP BY p.name;



-- 9.For each project which has all tasks marked as closed move status to closed. Close date for such project should match close date for the last accepted task.


UPDATE [dbo].[Projects]
SET 
    status_id = 2, -- Closed
    close_date = (
        SELECT MAX(sh.date)
        FROM [dbo].[Tasks] t
        JOIN [dbo].[Status_History] sh ON t.task_id = sh.task_id
        WHERE t.project_id = Projects.project_id
        AND sh.status_id = 4 -- Accepted
    )
FROM 
    [dbo].[Projects]
WHERE 
    status_id = 1 -- Open
    AND NOT EXISTS (
        SELECT 1
        FROM [dbo].[Tasks] t
        JOIN (
            SELECT sh.task_id, sh.status_id
            FROM [dbo].[Status_History] sh
            JOIN (
                SELECT task_id, MAX(date) AS max_date
                FROM [dbo].[Status_History]
                GROUP BY task_id
            ) latest ON sh.task_id = latest.task_id AND sh.date = latest.max_date
        ) latest_status ON t.task_id = latest_status.task_id
        WHERE t.project_id = Projects.project_id
        AND latest_status.status_id != 4 -- Not Accepted
    );

--10. Determine employees across all projects which has not non-closed tasks assigned.
SELECT * FROM  [dbo].[Employee];
SELECT * FROM [dbo].[Status_History];
SELECT * FROM [dbo].[Tasks];
SELECT 
    e.employee_id,
    e.first_name,
	e.last_name 
FROM 
    [dbo].[Employee] e
WHERE NOT EXISTS (
    SELECT 1
    FROM [dbo].[Tasks] t
    JOIN (
        SELECT sh.task_id, sh.status_id
        FROM [dbo].[Status_History] sh
        JOIN (
            SELECT task_id, MAX(date) AS max_date
            FROM [dbo].[Status_History]
            GROUP BY task_id
        ) latest ON sh.task_id = latest.task_id AND sh.date = latest.max_date
    ) latest_status ON t.task_id = latest_status.task_id
    WHERE t.assigned_to = e.employee_id
    AND latest_status.status_id IN (1, 3) 
);

--11. Assign given project task (using task name as identifier) to an employee which has minimum tasks with open status.
INSERT INTO employee_tasks (task_id, employee_id)
SELECT
    (SELECT id FROM project_tasks WHERE name = 'TASK_NAME'),
    e.id
FROM employees e
LEFT JOIN employee_tasks et ON e.id = et.employee_id
LEFT JOIN project_tasks pt ON et.task_id = pt.id AND pt.status = 'open'
GROUP BY e.id
ORDER BY COUNT(pt.id) ASC
LIMIT 1;






