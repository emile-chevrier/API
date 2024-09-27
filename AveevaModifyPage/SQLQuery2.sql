CREATE TABLE PasswordRemainDays (
    Username VARCHAR(255) UNIQUE,  -- Ensures 'User' values are unique
    DaysRemaining varchar(400)     -- Stores the remaining days for the password
);

-- Create the login with the specified password
CREATE LOGIN [PS_user] 
WITH PASSWORD = 'random password', 
     CHECK_POLICY = OFF;  -- Disable password policy checks
GO

-- Switch to the target database
USE [mesdb];
GO

-- Create the user in the 'mesdb' database for the created login
CREATE USER [PS_user] 
FOR LOGIN [PS_user];
GO

-- Grant specific CRUD permissions on all tables within the dbo schema
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.PasswordRemainDays TO [PS_user];
GO


select * from  PasswordRemainDays where Upper(Username) like '%Test%'