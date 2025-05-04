--- Project Statuses
INSERT INTO [dbo].[Project_Statuses] ([status_id], [status_name])
VALUES 
(1, 'Open'),
(2, 'Closed');

-- Task Statuses
INSERT INTO [dbo].[Task_Status] ([status_id], [status_name])
VALUES 
(1, 'Open'),
(2, 'Done'),
(3, 'Need Work'),
(4, 'Accepted');

-- Employee
INSERT INTO [dbo].[Employee] ([employee_id], [first_name], [last_name])
VALUES 
(101, 'Sem', 'Kroks'),
(102, 'Emily', 'Watson'),
(103, 'Michael', 'Andrade'),
(104, 'Sara', 'Brown'),
(105, 'David', 'Ivasenko'),
(106, 'Tom', 'Garcia'),
(107, 'Robin', 'Been');

--  Roles
INSERT INTO [dbo].[Roles] ([role_id], [role_name])
VALUES 
(1, 'Project Manager'),
(2, 'Developer'),
(3, 'QA Engineer'),
(4, 'UI/UX Designer'),
(5, 'Business Analyst');

--  Projects 
INSERT INTO [dbo].[Projects] ([project_id], [project_name], [creation_date], [status_id], [close_date]) VALUES 
-- Closed project
(1001, 'Website Redesign', '2025-01-10', 2, '2025-02-28'),
-- Active project 
(1002, 'Mobile App Development', '2025-02-01', 1, NULL),
-- Active project with + overdue tasks
(1003, 'Database Migration', '2025-03-02', 1, NULL),
-- Closed project + unaccepted tasks 
(1004, 'CRM Implementation', '2025-03-20', 2, '2025-04-15'),
-- New project with not started tasks
(1005, 'E-commerce Platform', '2025-04-01', 1, NULL),
-- Project with no tasks 
(1006, 'Internal Tools', '2025-01-15', 1, NULL);

--  Employee Project Roles
INSERT INTO [dbo].[Employee_Project_Roles] ([employee_id], [project_id], [role_id])
VALUES 
(101, 1001, 1), 
(102, 1001, 2),
(103, 1001, 4), 
(101, 1002, 1), 
(104, 1002, 2),
(105, 1002, 3),
(106, 1003, 1), 
(107, 1003, 2), 
(102, 1004, 1),
(103, 1004, 5), 
(101, 1005, 1), 
(104, 1005, 2)

--  Tasks 
INSERT INTO [dbo].[Tasks] ([task_id], [task_name], [project_id], [assigned_to])
VALUES 
(5001, 'Design Homepage', 1001, 103),
(5002, 'Implement User Authentication', 1002, 104),
(5003, 'Migrate Customer Data', 1003, 107),
(5004, 'Create Product Catalog', 1004, 103),
(5005, 'Setup Payment Gateway', 1005, 105),
(5006, 'Develop REST API', 1002, 102),
(5007, 'Write Test Cases', 1002, 105),
(5008, 'Optimize Database Queries', 1003, 107),
(5009, 'Implement Search Functionality', 1001, 102),
(5010, 'Mobile App UI Design', 1002, 103);



-- Status History with realistic timelines (some overdue)
INSERT INTO [dbo].[Status_History] ([history_id], [task_id], [status_id], [changed_by], [date]) VALUES 
-- Task 5001 /completed
(1, 5001, 1, 101, '2025-01-16 09:00:00'), 
(2, 5001, 3, 101, '2025-01-20 14:30:00'), 
(3, 5001, 2, 103, '2025-01-25 16:45:00'), 
(4, 5001, 4, 101, '2025-01-26 10:15:00'), 


-- Task 5002 - Completed and Accepted
(5, 5002, 1, 104, '2025-03-07 10:00:00'),
(6, 5002, 2, 104, '2025-03-10 12:00:00'),
(7, 5002, 4, 101, '2025-03-12 09:00:00'),

-- Task 5003 - Overdue, still Open
(8, 5003, 1, 107, '2025-03-15 15:00:00'),

-- Task 5004 - Done but Not Accepted (Project is Closed)
(9, 5004, 1, 103, '2025-03-18 11:00:00'),
(10, 5004, 2, 103, '2025-04-01 16:00:00'),

-- Task 5005 - Not Started (only status 'Open')
(11, 5005, 1, 105, '2025-04-03 09:00:00'),

-- Task 5006 - Done but Not Accepted
(12, 5006, 1, 102, '2025-03-10 13:00:00'),
(13, 5006, 3, 102, '2025-03-14 10:00:00'),
(14, 5006, 2, 102, '2025-03-20 17:00:00'),

-- Task 5007 - Still Open
(15, 5007, 1, 105, '2025-04-01 10:00:00'),

-- Task 5008 - Completed and Accepted
(16, 5008, 1, 107, '2025-03-22 09:00:00'),
(17, 5008, 2, 107, '2025-03-26 14:30:00'),
(18, 5008, 4, 106, '2025-03-27 09:15:00'),

-- Task 5009 - Open only (simulating not started)
(19, 5009, 1, 104, '2025-04-04 10:00:00'),

-- Task 5010 - Need Work, Still Unresolved
(20, 5010, 1, 103, '2025-03-28 11:00:00'),
(21, 5010, 3, 105, '2025-04-02 15:00:00');






