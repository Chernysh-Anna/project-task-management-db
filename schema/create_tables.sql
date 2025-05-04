CREATE DATABASE Local;
USE Local;

-- Projects status 

CREATE TABLE [dbo].[Project_Statuses](
	[status_id] [int] NOT NULL,
	[status_name] [varchar](20) NOT NULL,
 CONSTRAINT [PK_Project_Statuses] PRIMARY KEY CLUSTERED 
(
	[status_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

--Employees table

CREATE TABLE [dbo].[Employee](
	[employee_id] [int] NOT NULL,
	[first_name] [varchar](50) NOT NULL,
	[last_name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Employee] PRIMARY KEY CLUSTERED 
(
	[employee_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

-- Projects table

CREATE TABLE [dbo].[Projects](
	[project_id] [int] NOT NULL,
	[project_name] [varchar](100) NOT NULL,
	[creation_date] [date] NOT NULL,
	[status_id] [int] NOT NULL,
	[close_date] [date] NULL,
 CONSTRAINT [PK_Projects] PRIMARY KEY CLUSTERED 
(
	[project_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Projects]  WITH CHECK ADD  CONSTRAINT [FK_Projects_Project_Statuses] FOREIGN KEY([status_id])
REFERENCES [dbo].[Project_Statuses] ([status_id])
GO

ALTER TABLE [dbo].[Projects] CHECK CONSTRAINT [FK_Projects_Project_Statuses]
GO



--Roles table

CREATE TABLE [dbo].[Roles](
	[role_id] [int] NOT NULL,
	[role_name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Roles] PRIMARY KEY CLUSTERED 
(
	[role_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

--  Employee_Project_Roles

CREATE TABLE [dbo].[Employee_Project_Roles](
	[employee_id] [int] NOT NULL,
	[project_id] [int] NOT NULL,
	[role_id] [int] NOT NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Employee_Project_Roles]  WITH CHECK ADD  CONSTRAINT [FK_Employee_Project_Roles_Employee] FOREIGN KEY([employee_id])
REFERENCES [dbo].[Employee] ([employee_id])
GO

ALTER TABLE [dbo].[Employee_Project_Roles] CHECK CONSTRAINT [FK_Employee_Project_Roles_Employee]
GO

ALTER TABLE [dbo].[Employee_Project_Roles]  WITH CHECK ADD  CONSTRAINT [FK_Employee_Project_Roles_Projects] FOREIGN KEY([project_id])
REFERENCES [dbo].[Projects] ([project_id])
GO

ALTER TABLE [dbo].[Employee_Project_Roles] CHECK CONSTRAINT [FK_Employee_Project_Roles_Projects]
GO

ALTER TABLE [dbo].[Employee_Project_Roles]  WITH CHECK ADD  CONSTRAINT [FK_Employee_Project_Roles_Roles] FOREIGN KEY([role_id])
REFERENCES [dbo].[Roles] ([role_id])
GO

ALTER TABLE [dbo].[Employee_Project_Roles] CHECK CONSTRAINT [FK_Employee_Project_Roles_Roles]
GO

--  Task_Statuses

CREATE TABLE [dbo].[Task_Status](
	[status_id] [int] NOT NULL,
	[status_name] [varchar](20) NOT NULL,
 CONSTRAINT [PK_Task_Status] PRIMARY KEY CLUSTERED 
(
	[status_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

--  Task

CREATE TABLE [dbo].[Tasks](
	[task_id] [int] NOT NULL,
	[task_name] [varchar](100) NOT NULL,
	[project_id] [int] NOT NULL,
	[assigned_to] [int] NOT NULL,
 CONSTRAINT [PK_Tasks] PRIMARY KEY CLUSTERED 
(
	[task_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Tasks]  WITH CHECK ADD  CONSTRAINT [FK_Tasks_Employee] FOREIGN KEY([assigned_to])
REFERENCES [dbo].[Employee] ([employee_id])
GO

ALTER TABLE [dbo].[Tasks] CHECK CONSTRAINT [FK_Tasks_Employee]
GO

ALTER TABLE [dbo].[Tasks]  WITH CHECK ADD  CONSTRAINT [FK_Tasks_Projects] FOREIGN KEY([project_id])
REFERENCES [dbo].[Projects] ([project_id])
GO

ALTER TABLE [dbo].[Tasks] CHECK CONSTRAINT [FK_Tasks_Projects]
GO



--Status_History
CREATE TABLE [dbo].[Status_History](
	[history_id] [int] NOT NULL,
	[task_id] [int] NOT NULL,
	[status_id] [int] NOT NULL,
	[changed_by] [int] NOT NULL,
	[date] [datetime] NOT NULL,
 CONSTRAINT [PK_Status_History] PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Status_History]  WITH CHECK ADD  CONSTRAINT [FK_Status_History_Employee] FOREIGN KEY([changed_by])
REFERENCES [dbo].[Employee] ([employee_id])
GO

ALTER TABLE [dbo].[Status_History] CHECK CONSTRAINT [FK_Status_History_Employee]
GO

ALTER TABLE [dbo].[Status_History]  WITH CHECK ADD  CONSTRAINT [FK_Status_History_Task_Status] FOREIGN KEY([status_id])
REFERENCES [dbo].[Task_Status] ([status_id])
GO

ALTER TABLE [dbo].[Status_History] CHECK CONSTRAINT [FK_Status_History_Task_Status]
GO

ALTER TABLE [dbo].[Status_History]  WITH CHECK ADD  CONSTRAINT [FK_Status_History_Tasks] FOREIGN KEY([task_id])
REFERENCES [dbo].[Tasks] ([task_id])
GO

ALTER TABLE [dbo].[Status_History] CHECK CONSTRAINT [FK_Status_History_Tasks]
GO



