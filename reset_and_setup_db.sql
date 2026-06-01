-- ============================================================
-- JOB PORTAL - FULL RESET + SETUP + SEED
-- Run this on the target machine via sqlcmd or SSMS
-- ============================================================

USE [master]
GO

-- ============================================================
-- STEP 1: DROP DATABASE IF EXISTS
-- ============================================================
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'JobPortal_New1')
BEGIN
    ALTER DATABASE [JobPortal_New1] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [JobPortal_New1];
    PRINT 'Old database dropped.';
END
GO

-- ============================================================
-- STEP 2: CREATE FRESH DATABASE
-- ============================================================
CREATE DATABASE [JobPortal_New1]
GO

ALTER DATABASE [JobPortal_New1] SET COMPATIBILITY_LEVEL = 150
GO
ALTER DATABASE [JobPortal_New1] SET ANSI_NULLS OFF
GO
ALTER DATABASE [JobPortal_New1] SET ANSI_PADDING OFF
GO
ALTER DATABASE [JobPortal_New1] SET ANSI_WARNINGS OFF
GO
ALTER DATABASE [JobPortal_New1] SET ARITHABORT OFF
GO
ALTER DATABASE [JobPortal_New1] SET AUTO_CLOSE OFF
GO
ALTER DATABASE [JobPortal_New1] SET AUTO_SHRINK OFF
GO
ALTER DATABASE [JobPortal_New1] SET AUTO_UPDATE_STATISTICS ON
GO
ALTER DATABASE [JobPortal_New1] SET RECOVERY SIMPLE
GO
ALTER DATABASE [JobPortal_New1] SET MULTI_USER
GO
ALTER DATABASE [JobPortal_New1] SET PAGE_VERIFY CHECKSUM
GO

PRINT 'Database created.'
GO

USE [JobPortal_New1]
GO

-- ============================================================
-- STEP 3: CREATE TABLES
-- ============================================================

-- Admin
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Admin](
    [AdminID]     [int] IDENTITY(1,1) NOT NULL,
    [Name]        [varchar](50)       NULL,
    [Username]    [varchar](50)       NULL,
    [Password]    [nvarchar](100)     NULL,
    [Email]       [varchar](50)       NULL,
    [PhoneNumber] [nvarchar](50)      NULL,
PRIMARY KEY CLUSTERED ([AdminID] ASC),
UNIQUE NONCLUSTERED  ([Username] ASC)
) ON [PRIMARY]
GO

-- Categories
CREATE TABLE [dbo].[Categories](
    [CategoryID]   [int] IDENTITY(1,1) NOT NULL,
    [CategoryName] [varchar](100)      NULL,
PRIMARY KEY CLUSTERED ([CategoryID] ASC)
) ON [PRIMARY]
GO

-- Skills
CREATE TABLE [dbo].[Skills](
    [SkillID]   [int] IDENTITY(1,1) NOT NULL,
    [SkillName] [varchar](50) NOT NULL,
CONSTRAINT [PK_Skills] PRIMARY KEY CLUSTERED ([SkillID] ASC)
) ON [PRIMARY]
GO

-- Locations
CREATE TABLE [dbo].[Locations](
    [LocationID]   [int] IDENTITY(1,1) NOT NULL,
    [LocationName] [varchar](100)      NULL,
PRIMARY KEY CLUSTERED ([LocationID] ASC)
) ON [PRIMARY]
GO

-- Employers
CREATE TABLE [dbo].[Employers](
    [EmployerID]    [int] IDENTITY(1,1) NOT NULL,
    [CompanyName]   [varchar](100)      NULL,
    [OfficialEmail] [varchar](100)      NULL,
    [Email]         [varchar](100)      NOT NULL,
    [ContactPhone]  [varchar](20)       NULL,
    [Website]       [varchar](100)      NULL,
    [Name]          [varchar](50)       NULL,
    [Designation]   [varchar](50)       NULL,
    [CompanyLogo]   [varbinary](max)    NOT NULL,
    [Password]      [nvarchar](100)     NULL,
    [Status]        [varchar](10)       NOT NULL,
    [Username]      [varchar](50)       NULL,
PRIMARY KEY CLUSTERED ([EmployerID] ASC),
UNIQUE NONCLUSTERED  ([Email] ASC)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

-- JobSeekers
CREATE TABLE [dbo].[JobSeekers](
    [SeekerID]      [int] IDENTITY(1,1) NOT NULL,
    [FirstName]     [varchar](50)       NULL,
    [LastName]      [varchar](50)       NULL,
    [Gender]        [char](1)           NULL,
    [Birthdate]     [date]              NULL,
    [Email]         [varchar](100)      NOT NULL,
    [PhoneNumber]   [varchar](20)       NULL,
    [Resume]        [varbinary](max)    NULL,
    [Experience]    [varchar](25)       NULL,
    [Password]      [nvarchar](100)     NULL,
    [ProfilePicture][varbinary](max)    NULL,
    [Address]       [varchar](50)       NULL,
    [City]          [varchar](20)       NULL,
    [State]         [varchar](20)       NULL,
    [Username]      [varchar](50)       NOT NULL,
PRIMARY KEY CLUSTERED ([SeekerID] ASC),
UNIQUE NONCLUSTERED  ([Username] ASC),
UNIQUE NONCLUSTERED  ([Email] ASC)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

-- JobSeekerSkills
CREATE TABLE [dbo].[JobSeekerSkills](
    [JobSeekerSkillID] [int] IDENTITY(1,1) NOT NULL,
    [JobSeekerID]      [int]               NULL,
    [SkillID]          [int]               NULL,
PRIMARY KEY CLUSTERED ([JobSeekerSkillID] ASC)
) ON [PRIMARY]
GO

-- EducationDetails
CREATE TABLE [dbo].[EducationDetails](
    [EducationID]    [int] IDENTITY(1,1)  NOT NULL,
    [SeekerID]       [int]                NULL,
    [University]     [varchar](100)       NULL,
    [Degree]         [varchar](50)        NULL,
    [Major]          [varchar](100)       NULL,
    [GraduationYear] [int]                NULL,
    [GPA]            [decimal](3, 2)      NULL,
PRIMARY KEY CLUSTERED ([EducationID] ASC)
) ON [PRIMARY]
GO

-- JobVacancies
CREATE TABLE [dbo].[JobVacancies](
    [VacancyID]          [int] IDENTITY(1,1)  NOT NULL,
    [EmployerID]         [int]                 NULL,
    [JobTitle]           [varchar](100)        NULL,
    [Description]        [text]                NULL,
    [CategoryID]         [int]                 NULL,
    [Location]           [varchar](50)         NULL,
    [Salary]             [decimal](10, 2)      NULL,
    [EmploymentType]     [varchar](50)         NULL,
    [ApplicationDeadline][datetime2](7)        NULL,
    [IsPublished]        [bit]                 NULL,
PRIMARY KEY CLUSTERED ([VacancyID] ASC)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

-- JobApplications
CREATE TABLE [dbo].[JobApplications](
    [ApplicationID]  [int] IDENTITY(1,1) NOT NULL,
    [JobID]          [int]               NULL,
    [SeekerID]       [int]               NULL,
    [ApplicationDate][datetime2](7)      NULL,
    [Status]         [varchar](50)       NULL,
PRIMARY KEY CLUSTERED ([ApplicationID] ASC)
) ON [PRIMARY]
GO

-- JobViews
CREATE TABLE [dbo].[JobViews](
    [ViewID]   [int] IDENTITY(1,1) NOT NULL,
    [JobID]    [int]               NULL,
    [SeekerID] [int]               NULL,
    [ViewDate] [datetime]          NULL,
PRIMARY KEY CLUSTERED ([ViewID] ASC)
) ON [PRIMARY]
GO

-- Bookmarks
CREATE TABLE [dbo].[Bookmarks](
    [BookmarkID] [int] IDENTITY(1,1) NOT NULL,
    [SeekerID]   [int]               NULL,
    [JobID]      [int]               NULL,
PRIMARY KEY CLUSTERED ([BookmarkID] ASC)
) ON [PRIMARY]
GO

-- Chats
CREATE TABLE [dbo].[Chats](
    [ChatID]    [int] IDENTITY(1,1) NOT NULL,
    [SeekerID]  [int]               NULL,
    [EmployerID][int]               NULL,
PRIMARY KEY CLUSTERED ([ChatID] ASC)
) ON [PRIMARY]
GO

-- ChatMessages
CREATE TABLE [dbo].[ChatMessages](
    [MessageID]  [int] IDENTITY(1,1) NOT NULL,
    [ChatID]     [int]               NULL,
    [Message]    [text]              NULL,
    [DateAndTime][datetime2](7)      NULL,
    [Sender]     [char](1)           NULL,
PRIMARY KEY CLUSTERED ([MessageID] ASC)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

-- Messages (Contact Us)
CREATE TABLE [dbo].[Messages](
    [FirstName]  [varchar](50)       NULL,
    [LastName]   [varchar](50)       NULL,
    [PhoneNumber][varchar](50)       NULL,
    [Email]      [varchar](100)      NULL,
    [Message]    [text]              NULL,
    [ContactId]  [int] IDENTITY(1,1) NOT NULL,
    [DateTime]   [datetime2](7)      NULL,
CONSTRAINT [PK_Messages] PRIMARY KEY CLUSTERED ([ContactId] ASC)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

PRINT 'All tables created.'
GO

-- ============================================================
-- STEP 4: FOREIGN KEYS
-- ============================================================

ALTER TABLE [dbo].[Bookmarks] WITH CHECK ADD CONSTRAINT [FK__Bookmarks__JobID] FOREIGN KEY([JobID])
    REFERENCES [dbo].[JobVacancies] ([VacancyID])
GO
ALTER TABLE [dbo].[Bookmarks] CHECK CONSTRAINT [FK__Bookmarks__JobID]
GO

ALTER TABLE [dbo].[Bookmarks] WITH CHECK ADD CONSTRAINT [FK_Bookmarks_JobSeekers] FOREIGN KEY([SeekerID])
    REFERENCES [dbo].[JobSeekers] ([SeekerID])
GO
ALTER TABLE [dbo].[Bookmarks] CHECK CONSTRAINT [FK_Bookmarks_JobSeekers]
GO

ALTER TABLE [dbo].[ChatMessages] WITH CHECK ADD FOREIGN KEY([ChatID])
    REFERENCES [dbo].[Chats] ([ChatID])
GO

ALTER TABLE [dbo].[Chats] WITH CHECK ADD FOREIGN KEY([EmployerID])
    REFERENCES [dbo].[Employers] ([EmployerID])
GO

ALTER TABLE [dbo].[Chats] WITH CHECK ADD FOREIGN KEY([SeekerID])
    REFERENCES [dbo].[JobSeekers] ([SeekerID])
GO

ALTER TABLE [dbo].[EducationDetails] WITH CHECK ADD FOREIGN KEY([SeekerID])
    REFERENCES [dbo].[JobSeekers] ([SeekerID])
GO

ALTER TABLE [dbo].[JobApplications] WITH CHECK ADD FOREIGN KEY([JobID])
    REFERENCES [dbo].[JobVacancies] ([VacancyID])
GO

ALTER TABLE [dbo].[JobApplications] WITH CHECK ADD FOREIGN KEY([SeekerID])
    REFERENCES [dbo].[JobSeekers] ([SeekerID])
GO

ALTER TABLE [dbo].[JobSeekerSkills] WITH CHECK ADD CONSTRAINT [FK_JobSeekerSkills_JobSeeker] FOREIGN KEY([JobSeekerID])
    REFERENCES [dbo].[JobSeekers] ([SeekerID])
GO
ALTER TABLE [dbo].[JobSeekerSkills] CHECK CONSTRAINT [FK_JobSeekerSkills_JobSeeker]
GO

ALTER TABLE [dbo].[JobSeekerSkills] WITH CHECK ADD CONSTRAINT [FK_JobSeekerSkills_Skill] FOREIGN KEY([SkillID])
    REFERENCES [dbo].[Skills] ([SkillID])
GO
ALTER TABLE [dbo].[JobSeekerSkills] CHECK CONSTRAINT [FK_JobSeekerSkills_Skill]
GO

ALTER TABLE [dbo].[JobVacancies] WITH CHECK ADD FOREIGN KEY([CategoryID])
    REFERENCES [dbo].[Categories] ([CategoryID])
GO

ALTER TABLE [dbo].[JobVacancies] WITH CHECK ADD FOREIGN KEY([EmployerID])
    REFERENCES [dbo].[Employers] ([EmployerID])
GO

ALTER TABLE [dbo].[JobViews] WITH CHECK ADD FOREIGN KEY([JobID])
    REFERENCES [dbo].[JobVacancies] ([VacancyID])
GO

ALTER TABLE [dbo].[JobViews] WITH CHECK ADD FOREIGN KEY([SeekerID])
    REFERENCES [dbo].[JobSeekers] ([SeekerID])
GO

PRINT 'All foreign keys created.'
GO

-- ============================================================
-- STEP 5: STORED PROCEDURES
-- ============================================================

-- SP_AdminChangePassword
CREATE PROCEDURE [dbo].[SP_AdminChangePassword]
@Username NVARCHAR(100), @NewPassword NVARCHAR(100)
AS BEGIN
    UPDATE [dbo].[Admin] SET Password = @NewPassword WHERE Username = @Username
END
GO

-- SP_AdminLogin
CREATE PROCEDURE [dbo].[SP_AdminLogin]
@Username VARCHAR(100)
AS BEGIN
    IF EXISTS (SELECT 1 FROM [dbo].[Admin] WHERE Username = @Username)
        SELECT Password AS Result FROM [dbo].[Admin] WHERE Username = @Username
    ELSE
        SELECT 0 AS Result
END
GO

-- SP_Bookmark
CREATE PROCEDURE [dbo].[SP_Bookmark]
@SeekerId INT, @JobId INT
AS BEGIN
    IF NOT EXISTS (SELECT 1 FROM [dbo].[Bookmarks] WHERE JobID = @JobId AND SeekerID = @SeekerId)
        INSERT INTO [dbo].[Bookmarks] (JobID, SeekerID) VALUES (@JobId, @SeekerId)
    ELSE
        DELETE FROM [dbo].[Bookmarks] WHERE JobID = @JobId AND SeekerID = @SeekerId
END
GO

-- SP_ChangeEmployerPassword
CREATE PROCEDURE [dbo].[SP_ChangeEmployerPassword]
@EmployerID INT, @NewPassword NVARCHAR(100)
AS BEGIN
    UPDATE [dbo].[Employers] SET Password = @NewPassword WHERE EmployerID = @EmployerID
END
GO

-- SP_ChangeJobSeekerPassword
CREATE PROCEDURE [dbo].[SP_ChangeJobSeekerPassword]
@SeekerID INT, @NewPassword NVARCHAR(100)
AS BEGIN
    UPDATE [dbo].[JobSeekers] SET Password = @NewPassword WHERE SeekerID = @SeekerID
END
GO

-- SP_ChatListEmployer
CREATE PROCEDURE [dbo].[SP_ChatListEmployer]
@EmployerID INT
AS BEGIN
    SELECT C.SeekerID, C.EmployerID, C.ChatID,
           CONCAT(J.FirstName, ' ', J.LastName) AS SeekerName, E.CompanyName
    FROM [dbo].[Chats] C
    INNER JOIN [dbo].[JobSeekers] J  ON C.SeekerID  = J.SeekerID
    INNER JOIN [dbo].[Employers]  E  ON C.EmployerID = E.EmployerID
    WHERE C.EmployerID = @EmployerID
END
GO

-- SP_ChatListSeeker
CREATE PROCEDURE [dbo].[SP_ChatListSeeker]
@SeekerID INT
AS BEGIN
    SELECT C.SeekerID, C.EmployerID, C.ChatID,
           CONCAT(J.FirstName, ' ', J.LastName) AS SeekerName, E.CompanyName
    FROM [dbo].[Chats] C
    INNER JOIN [dbo].[JobSeekers] J  ON C.SeekerID  = J.SeekerID
    INNER JOIN [dbo].[Employers]  E  ON C.EmployerID = E.EmployerID
    WHERE C.SeekerID = @SeekerID
END
GO

-- SP_CheckPhoneNumber
CREATE PROCEDURE [dbo].[SP_CheckPhoneNumber]
@PhoneNumber VARCHAR(30)
AS BEGIN
    IF EXISTS (SELECT 1 FROM [dbo].[JobSeekers] WHERE PhoneNumber = @PhoneNumber)
        SELECT 1 AS Result
    ELSE IF EXISTS(SELECT 1 FROM [dbo].[Employers] WHERE ContactPhone = @PhoneNumber)
        SELECT 1 AS Result
    ELSE IF EXISTS(SELECT 1 FROM [dbo].[Admin] WHERE PhoneNumber = @PhoneNumber)
        SELECT 1 AS Result
    ELSE
        SELECT 0 AS Result
END
GO

-- SP_CheckUsername
CREATE PROCEDURE [dbo].[SP_CheckUsername]
@Username VARCHAR(30)
AS BEGIN
    IF EXISTS (SELECT 1 FROM [dbo].[JobSeekers] WHERE Username = @Username)
        SELECT 1 AS Result
    ELSE IF EXISTS(SELECT 1 FROM [dbo].[Employers] WHERE Username = @Username)
        SELECT 1 AS Result
    ELSE IF EXISTS(SELECT 1 FROM [dbo].[Admin] WHERE Username = @Username)
        SELECT 1 AS Result
    ELSE
        SELECT 0 AS Result
END
GO

-- SP_CreateAdmin
CREATE PROCEDURE [dbo].[SP_CreateAdmin]
@Name VARCHAR(20), @Username VARCHAR(20), @Password NVARCHAR(100),
@Email VARCHAR(50), @PhoneNumber VARCHAR(20)
AS BEGIN
    INSERT INTO [dbo].[Admin](Name, Username, Password, Email, PhoneNumber)
    VALUES (@Name, @Username, @Password, @Email, @PhoneNumber)
END
GO

-- SP_CreateCategory
CREATE PROCEDURE [dbo].[SP_CreateCategory]
@CategoryName VARCHAR(50)
AS BEGIN
    INSERT INTO [dbo].[Categories] (CategoryName) VALUES (@CategoryName)
END
GO

-- SP_CreateContactUsMessage
CREATE PROCEDURE [dbo].[SP_CreateContactUsMessage]
@FirstName VARCHAR(50), @LastName VARCHAR(20), @PhoneNumber VARCHAR(20),
@Email VARCHAR(100), @DateTime DATETIME2, @Message TEXT
AS BEGIN
    INSERT INTO [dbo].[Messages] (FirstName, LastName, PhoneNumber, Email, DateTime, Message)
    VALUES(@FirstName, @LastName, @PhoneNumber, @Email, @DateTime, @Message)
END
GO

-- SP_CreateEducationDetail
CREATE PROCEDURE [dbo].[SP_CreateEducationDetail]
@SeekerID INT, @University VARCHAR(100), @Degree VARCHAR(50),
@Major VARCHAR(100), @GraduationYear INT, @GPA DECIMAL(3,2)
AS BEGIN
    INSERT INTO [dbo].[EducationDetails] (SeekerID, Degree, University, Major, GraduationYear, GPA)
    VALUES (@SeekerID, @Degree, @University, @Major, @GraduationYear, @GPA)
END
GO

-- SP_CreateEmployer
CREATE PROCEDURE [dbo].[SP_CreateEmployer]
@CompanyName VARCHAR(100), @OfficialEmail VARCHAR(100), @Email VARCHAR(100),
@ContactPhone VARCHAR(20), @Website VARCHAR(100), @Name VARCHAR(50),
@Designation VARCHAR(50), @CompanyLogo VARBINARY(MAX), @Username VARCHAR(20),
@Password NVARCHAR(100), @Status VARCHAR(10) = 'Pending'
AS BEGIN
    INSERT INTO [dbo].[Employers]
        (CompanyName, OfficialEmail, Email, ContactPhone, Website, Name, Designation, CompanyLogo, Username, Password, Status)
    VALUES
        (@CompanyName, @OfficialEmail, @Email, @ContactPhone, @Website, @Name, @Designation, @CompanyLogo, @Username, @Password, @Status)
END
GO

-- SP_CreateJobApplication
CREATE PROCEDURE [dbo].[SP_CreateJobApplication]
@JobID INT, @SeekerID INT, @ApplicationDate DATETIME2, @Status VARCHAR(50) = 'Pending'
AS BEGIN
    INSERT INTO [dbo].[JobApplications] (JobID, SeekerID, ApplicationDate, Status)
    VALUES (@JobID, @SeekerID, @ApplicationDate, @Status)
END
GO

-- SP_CreateJobSeeker
CREATE PROCEDURE [dbo].[SP_CreateJobSeeker]
@FirstName VARCHAR(50), @LastName VARCHAR(50), @Gender CHAR(1), @Birthdate DATE,
@Email VARCHAR(100), @PhoneNumber VARCHAR(20), @Password NVARCHAR(100),
@Resume VARBINARY(MAX), @Experience VARCHAR(255), @Image VARBINARY(MAX),
@Address VARCHAR(50), @City VARCHAR(20), @State VARCHAR(20), @Username VARCHAR(50)
AS BEGIN
    INSERT INTO [dbo].[JobSeekers]
        (FirstName, LastName, Gender, Birthdate, Email, PhoneNumber, Password, Resume, Experience, ProfilePicture, Address, City, State, Username)
    VALUES
        (@FirstName, @LastName, @Gender, @Birthdate, @Email, @PhoneNumber, @Password, @Resume, @Experience, @Image, @Address, @City, @State, @Username)
END
GO

-- SP_CreateJobSeekerSkills
CREATE PROCEDURE [dbo].[SP_CreateJobSeekerSkills]
@SkillId INT, @SeekerId INT
AS BEGIN
    INSERT INTO [dbo].[JobSeekerSkills](SkillID, JobSeekerID)
    VALUES (@SkillId, @SeekerId)
END
GO

-- SP_CreateJobVacancy
CREATE PROCEDURE [dbo].[SP_CreateJobVacancy]
@EmployerID INT, @JobTitle VARCHAR(100), @Description TEXT, @CategoryID INT,
@Location VARCHAR(50), @Salary DECIMAL(10,2), @EmploymentType VARCHAR(50),
@ApplicationDeadline DATETIME2, @IsPublished BIT = 1
AS BEGIN
    INSERT INTO [dbo].[JobVacancies]
        (EmployerID, JobTitle, Description, CategoryID, Location, Salary, EmploymentType, ApplicationDeadline, IsPublished)
    VALUES
        (@EmployerID, @JobTitle, @Description, @CategoryID, @Location, @Salary, @EmploymentType, @ApplicationDeadline, @IsPublished)
END
GO

-- SP_CreateJobView
CREATE PROCEDURE [dbo].[SP_CreateJobView]
@JobID INT, @SeekerID INT, @ViewDate DATETIME
AS BEGIN
    IF NOT EXISTS(SELECT 1 FROM [dbo].[JobViews] WHERE JobID = @JobID AND SeekerID = @SeekerID)
        INSERT INTO [dbo].[JobViews] VALUES (@JobID, @SeekerID, @ViewDate)
END
GO

-- SP_CreateMessage
CREATE PROCEDURE [dbo].[SP_CreateMessage]
@SeekerID INT, @EmployerID INT, @Message TEXT, @DateAndTime DATETIME2, @Sender CHAR(1)
AS BEGIN
    DECLARE @ChatID INT
    IF EXISTS (SELECT TOP 1 ChatID FROM [dbo].[Chats] WHERE SeekerID = @SeekerID AND EmployerID = @EmployerID)
        SELECT @ChatID = ChatID FROM [dbo].[Chats] WHERE SeekerID = @SeekerID AND EmployerID = @EmployerID
    ELSE
    BEGIN
        INSERT INTO [dbo].[Chats] (SeekerID, EmployerID) VALUES (@SeekerID, @EmployerID)
        SET @ChatID = SCOPE_IDENTITY()
    END
    INSERT INTO [dbo].[ChatMessages] (ChatID, Message, DateAndTime, Sender)
    VALUES (@ChatID, @Message, @DateAndTime, @Sender)
END
GO

-- SP_CreateSkill
CREATE PROCEDURE [dbo].[SP_CreateSkill]
@SkillName VARCHAR(100)
AS BEGIN
    INSERT INTO [dbo].[Skills] (SkillName) VALUES (@SkillName)
END
GO

-- SP_DeleteCategory
CREATE PROCEDURE [dbo].[SP_DeleteCategory]
@CategoryID INT
AS BEGIN
    DELETE FROM [dbo].[Categories] WHERE CategoryID = @CategoryID
END
GO

-- SP_DeleteEducationDetail
CREATE PROCEDURE [dbo].[SP_DeleteEducationDetail]
@EducationID INT
AS BEGIN
    DELETE FROM [dbo].[EducationDetails] WHERE EducationID = @EducationID
END
GO

-- SP_DeleteEmployer
CREATE PROCEDURE [dbo].[SP_DeleteEmployer]
@EmployerID INT
AS BEGIN
    DELETE FROM [dbo].[Employers] WHERE EmployerID = @EmployerID
END
GO

-- SP_DeleteJobApplication
CREATE PROCEDURE [dbo].[SP_DeleteJobApplication]
@ApplicationID INT
AS BEGIN
    DELETE FROM [dbo].[JobApplications] WHERE ApplicationID = @ApplicationID
END
GO

-- SP_DeleteJobSeeker
CREATE PROCEDURE [dbo].[SP_DeleteJobSeeker]
@SeekerID INT
AS BEGIN
    DELETE FROM [dbo].[JobSeekers] WHERE SeekerID = @SeekerID
END
GO

-- SP_DeleteJobSeekerSkill
CREATE PROCEDURE [dbo].[SP_DeleteJobSeekerSkill]
@JobSeekerSkillID INT
AS BEGIN
    DELETE FROM [dbo].[JobSeekerSkills] WHERE JobSeekerSkillID = @JobSeekerSkillID
END
GO

-- SP_DeleteJobVacancy
CREATE PROCEDURE [dbo].[SP_DeleteJobVacancy]
@VacancyID INT
AS BEGIN
    DELETE FROM [dbo].[JobVacancies] WHERE VacancyID = @VacancyID
END
GO

-- SP_DeleteSkill
CREATE PROCEDURE [dbo].[SP_DeleteSkill]
@SkillID INT
AS BEGIN
    DELETE FROM [dbo].[Skills] WHERE SkillID = @SkillID
END
GO

-- SP_EmployerApprove
CREATE PROCEDURE [dbo].[SP_EmployerApprove]
@EmployerId INT
AS BEGIN
    UPDATE [dbo].[Employers] SET Status = 'Approved' WHERE EmployerID = @EmployerId
END
GO

-- SP_EmployerLogin
CREATE PROCEDURE [dbo].[SP_EmployerLogin]
@Username VARCHAR(100)
AS BEGIN
    IF EXISTS (SELECT 1 FROM [dbo].[Employers] WHERE Username = @Username)
        SELECT Password AS Result FROM [dbo].[Employers] WHERE Username = @Username
    ELSE
        SELECT 0 AS Result
END
GO

-- SP_EmployerReject
CREATE PROCEDURE [dbo].[SP_EmployerReject]
@EmployerId INT
AS BEGIN
    UPDATE [dbo].[Employers] SET Status = 'Rejected' WHERE EmployerID = @EmployerId
END
GO

-- SP_JobApplicationApprove
CREATE PROCEDURE [dbo].[SP_JobApplicationApprove]
@ApplicationId INT
AS BEGIN
    UPDATE [dbo].[JobApplications] SET Status = 'Approved' WHERE ApplicationID = @ApplicationId
END
GO

-- SP_JobApplicationRead
CREATE PROCEDURE [dbo].[SP_JobApplicationRead]
@ApplicationId INT
AS BEGIN
    DECLARE @Current VARCHAR(20)
    SELECT @Current = Status FROM [dbo].[JobApplications] WHERE ApplicationID = @ApplicationId
    IF @Current = 'Pending'
        UPDATE [dbo].[JobApplications] SET Status = 'Read' WHERE ApplicationID = @ApplicationId
END
GO

-- SP_JobApplicationReject
CREATE PROCEDURE [dbo].[SP_JobApplicationReject]
@ApplicationId INT
AS BEGIN
    UPDATE [dbo].[JobApplications] SET Status = 'Rejected' WHERE ApplicationID = @ApplicationId
END
GO

-- SP_JobSeekerLogin
CREATE PROCEDURE [dbo].[SP_JobSeekerLogin]
@Username VARCHAR(100)
AS BEGIN
    IF EXISTS (SELECT 1 FROM [dbo].[JobSeekers] WHERE Username = @Username)
        SELECT Password AS Result FROM [dbo].[JobSeekers] WHERE Username = @Username
    ELSE
        SELECT 0 AS Result
END
GO

-- SP_ReadAdminPassword
CREATE PROCEDURE [dbo].[SP_ReadAdminPassword]
@Username VARCHAR(20)
AS BEGIN
    SELECT Password FROM [dbo].[Admin] WHERE Username = @Username
END
GO

-- SP_ReadBookMarks
CREATE PROCEDURE [dbo].[SP_ReadBookMarks]
@SeekerId INT
AS BEGIN
    SELECT B.BookmarkID, B.JobID, JV.JobTitle
    FROM [dbo].[Bookmarks] B
    INNER JOIN [dbo].[JobVacancies] JV ON B.JobID = JV.VacancyID
    WHERE B.SeekerID = @SeekerId
END
GO

-- SP_ReadCategories
CREATE PROCEDURE [dbo].[SP_ReadCategories]
AS BEGIN
    SELECT CategoryID, CategoryName FROM [dbo].[Categories]
END
GO

-- SP_ReadContactUsMessages
CREATE PROCEDURE [dbo].[SP_ReadContactUsMessages]
AS BEGIN
    SELECT * FROM [dbo].[Messages]
END
GO

-- SP_ReadEducationDetails
CREATE PROCEDURE [dbo].[SP_ReadEducationDetails]
@SeekerId INT
AS BEGIN
    SELECT EducationID, SeekerID, University, Degree, Major, GraduationYear, GPA
    FROM [dbo].[EducationDetails]
    WHERE SeekerID = @SeekerId
END
GO

-- SP_ReadEmployer
CREATE PROCEDURE [dbo].[SP_ReadEmployer]
AS BEGIN
    SELECT EmployerID, CompanyName, OfficialEmail, Email, ContactPhone, Website, Name, Designation, CompanyLogo, Status, Username
    FROM [dbo].[Employers]
END
GO

-- SP_ReadEmployerPassword
CREATE PROCEDURE [dbo].[SP_ReadEmployerPassword]
@EmployerId INT
AS BEGIN
    SELECT Password FROM [dbo].[Employers] WHERE EmployerID = @EmployerId
END
GO

-- SP_ReadJobApplication
CREATE PROCEDURE [dbo].[SP_ReadJobApplication]
@JobId INT
AS BEGIN
    SELECT ApplicationID, JobID, JA.SeekerID, JS.FirstName, ApplicationDate, Status
    FROM [dbo].[JobApplications] JA
    INNER JOIN [dbo].[JobSeekers] JS ON JA.SeekerID = JS.SeekerID
    WHERE JobID = @JobId
END
GO

-- SP_ReadJobApplicationSeeker
CREATE PROCEDURE [dbo].[SP_ReadJobApplicationSeeker]
@SeekerId INT
AS BEGIN
    SELECT JA.ApplicationID, JA.JobID, JV.JobTitle, JA.SeekerID, JA.ApplicationDate, Status
    FROM [dbo].[JobApplications] AS JA
    INNER JOIN [dbo].[JobVacancies] AS JV ON JV.VacancyID = JA.JobID
    WHERE JA.SeekerID = @SeekerId
END
GO

-- SP_ReadJobDetails
CREATE PROCEDURE [dbo].[SP_ReadJobDetails]
AS BEGIN
    SELECT
        JV.VacancyID, JV.EmployerID, JV.JobTitle, JV.Description,
        C.CategoryName AS Category, C.CategoryID, JV.Location, JV.Salary,
        JV.EmploymentType, JV.ApplicationDeadline, JV.IsPublished,
        E.CompanyName, E.OfficialEmail, E.Email, E.ContactPhone,
        E.Website, E.Name AS EmployerName, E.Designation, E.CompanyLogo,
        (SELECT COUNT(*) FROM [dbo].[JobApplications] WHERE JobID = JV.VacancyID) AS Applications,
        (SELECT COUNT(*) FROM [dbo].[JobViews]        WHERE JobID = JV.VacancyID) AS JobViews
    FROM [dbo].[JobVacancies] JV
    INNER JOIN [dbo].[Categories] C ON JV.CategoryID = C.CategoryID
    INNER JOIN [dbo].[Employers]  E ON JV.EmployerID = E.EmployerID
END
GO

-- SP_ReadJobSeeker
CREATE PROCEDURE [dbo].[SP_ReadJobSeeker]
AS BEGIN
    SELECT SeekerID, FirstName, LastName, Gender, Birthdate, Email, PhoneNumber,
           Experience, ProfilePicture, State, City, Address, Username, Resume
    FROM [dbo].[JobSeekers]
END
GO

-- SP_ReadJobSeekerPassword
CREATE PROCEDURE [dbo].[SP_ReadJobSeekerPassword]
@SeekerId INT
AS BEGIN
    SELECT Password FROM [dbo].[JobSeekers] WHERE SeekerID = @SeekerId
END
GO

-- SP_ReadJobSeekerSkills
CREATE PROCEDURE [dbo].[SP_ReadJobSeekerSkills]
@JobSeekerId INT
AS BEGIN
    SELECT JS.JobSeekerSkillID, S.SkillID, S.SkillName, JS.JobSeekerID
    FROM [dbo].[Skills] S
    INNER JOIN [dbo].[JobSeekerSkills] JS ON S.SkillID = JS.SkillID
    WHERE JS.JobSeekerID = @JobSeekerId
    ORDER BY S.SkillName ASC
END
GO

-- SP_ReadJobVacancy
CREATE PROCEDURE [dbo].[SP_ReadJobVacancy]
AS BEGIN
    SELECT VacancyID, EmployerID, JobTitle, Description, CategoryID, Location,
           Salary, EmploymentType, ApplicationDeadline, IsPublished
    FROM [dbo].[JobVacancies]
END
GO

-- SP_ReadJobView
CREATE PROCEDURE [dbo].[SP_ReadJobView]
@JobId INT
AS BEGIN
    SELECT ViewID, JobID, JobViews.SeekerID, JobSeekers.Username, ViewDate
    FROM [dbo].[JobViews]
    INNER JOIN [dbo].[JobSeekers] ON JobViews.SeekerID = JobSeekers.SeekerID
    WHERE JobID = @JobId
END
GO

-- SP_ReadMessage
CREATE PROCEDURE [dbo].[SP_ReadMessage]
@SeekerID INT, @EmployerID INT
AS BEGIN
    SELECT C.SeekerID, C.EmployerID, C.ChatID, CM.MessageID, CM.Message,
           CONCAT(J.FirstName, ' ', J.LastName) AS SeekerName,
           E.CompanyName, CM.DateAndTime, CM.Sender
    FROM [dbo].[ChatMessages] CM
    INNER JOIN [dbo].[Chats]      C ON C.ChatID     = CM.ChatID
    INNER JOIN [dbo].[JobSeekers] J ON C.SeekerID   = J.SeekerID
    INNER JOIN [dbo].[Employers]  E ON C.EmployerID = E.EmployerID
    WHERE C.SeekerID = @SeekerID AND C.EmployerID = @EmployerID
END
GO

-- SP_ReadSkills
CREATE PROCEDURE [dbo].[SP_ReadSkills]
AS BEGIN
    SELECT SkillID, SkillName FROM [dbo].[Skills] ORDER BY SkillName ASC
END
GO

-- SP_UpdateCategory
CREATE PROCEDURE [dbo].[SP_UpdateCategory]
@CategoryID INT, @CategoryName VARCHAR(50)
AS BEGIN
    UPDATE [dbo].[Categories] SET CategoryName = @CategoryName WHERE CategoryID = @CategoryID
END
GO

-- SP_UpdateEducationDetail
CREATE PROCEDURE [dbo].[SP_UpdateEducationDetail]
@EducationID INT, @University VARCHAR(100), @Degree VARCHAR(50),
@Major VARCHAR(100), @GraduationYear INT, @GPA DECIMAL(3,2)
AS BEGIN
    UPDATE [dbo].[EducationDetails]
    SET University = @University, Degree = @Degree, Major = @Major,
        GraduationYear = @GraduationYear, GPA = @GPA
    WHERE EducationID = @EducationID
END
GO

-- SP_UpdateEmployer
CREATE PROCEDURE [dbo].[SP_UpdateEmployer]
@EmployerID INT, @CompanyName VARCHAR(100), @OfficialEmail VARCHAR(100),
@Email VARCHAR(100), @ContactPhone VARCHAR(20), @Website VARCHAR(100),
@Name VARCHAR(50), @Designation VARCHAR(50), @CompanyLogo VARBINARY(MAX) = NULL
AS BEGIN
    UPDATE [dbo].[Employers]
    SET CompanyName = @CompanyName, OfficialEmail = @OfficialEmail, Email = @Email,
        ContactPhone = @ContactPhone, Website = @Website, Name = @Name, Designation = @Designation
    WHERE EmployerID = @EmployerID

    IF @CompanyLogo IS NOT NULL
        UPDATE [dbo].[Employers] SET CompanyLogo = @CompanyLogo WHERE EmployerID = @EmployerID
END
GO

-- SP_UpdateJobApplication
CREATE PROCEDURE [dbo].[SP_UpdateJobApplication]
@ApplicationID INT, @JobID INT, @SeekerID INT, @ApplicationDate DATETIME2, @Status VARCHAR(50)
AS BEGIN
    UPDATE [dbo].[JobApplications]
    SET JobID = @JobID, SeekerID = @SeekerID, ApplicationDate = @ApplicationDate, Status = @Status
    WHERE ApplicationID = @ApplicationID
END
GO

-- SP_UpdateJobSeeker
CREATE PROCEDURE [dbo].[SP_UpdateJobSeeker]
@SeekerID INT, @FirstName VARCHAR(50), @LastName VARCHAR(50), @Gender CHAR(1),
@Birthdate DATE, @Email VARCHAR(100), @PhoneNumber VARCHAR(20),
@ProfilePicture VARBINARY(MAX) = NULL, @Experience VARCHAR(25),
@Address VARCHAR(50), @City VARCHAR(40), @State VARCHAR(40)
AS BEGIN
    UPDATE [dbo].[JobSeekers]
    SET FirstName = @FirstName, LastName = @LastName, Gender = @Gender, Birthdate = @Birthdate,
        Email = @Email, PhoneNumber = @PhoneNumber, Experience = @Experience,
        State = @State, City = @City, Address = @Address
    WHERE SeekerID = @SeekerID

    IF @ProfilePicture IS NOT NULL
        UPDATE [dbo].[JobSeekers] SET ProfilePicture = @ProfilePicture WHERE SeekerID = @SeekerID
END
GO

-- SP_UpdateJobSeekerResume
CREATE PROCEDURE [dbo].[SP_UpdateJobSeekerResume]
@Resume VARBINARY(MAX), @SeekerId INT
AS BEGIN
    UPDATE [dbo].[JobSeekers] SET Resume = @Resume WHERE SeekerID = @SeekerId
END
GO

-- SP_UpdateJobVacancy
CREATE PROCEDURE [dbo].[SP_UpdateJobVacancy]
@VacancyID INT, @JobTitle VARCHAR(100), @Description TEXT, @CategoryID INT,
@Location VARCHAR(50), @Salary DECIMAL(10,2), @EmploymentType VARCHAR(50),
@ApplicationDeadline DATETIME2, @IsPublished BIT
AS BEGIN
    UPDATE [dbo].[JobVacancies]
    SET JobTitle = @JobTitle, Description = @Description, CategoryID = @CategoryID,
        Location = @Location, Salary = @Salary, EmploymentType = @EmploymentType,
        ApplicationDeadline = @ApplicationDeadline, IsPublished = @IsPublished
    WHERE VacancyID = @VacancyID
END
GO

-- SP_UpdateSkill
CREATE PROCEDURE [dbo].[SP_UpdateSkill]
@SkillID INT, @SkillName VARCHAR(100)
AS BEGIN
    UPDATE [dbo].[Skills] SET SkillName = @SkillName WHERE SkillID = @SkillID
END
GO

-- SP_ViewJob
CREATE PROCEDURE [dbo].[SP_ViewJob]
@JobID INT, @SeekerID INT, @ViewDate DATETIME
AS BEGIN
    IF NOT EXISTS(SELECT 1 FROM [dbo].[JobViews] WHERE JobID = @JobID AND SeekerID = @SeekerID)
        INSERT INTO [dbo].[JobViews](JobID, SeekerID, ViewDate) VALUES (@JobID, @SeekerID, @ViewDate)
END
GO

PRINT 'All stored procedures created.'
GO

-- ============================================================
-- STEP 6: SEED DATA
-- All passwords = Pak@123  (BCrypt hash below)
-- ============================================================
USE [JobPortal_New1]
SET NOCOUNT ON
GO

DECLARE @pwd  NVARCHAR(100) = '$2a$11$GuWOeMKqqZ8d2uCBzuUTy.E.oPeCCHjgnwLFRyKxVHTwYj7GRgR2.';
DECLARE @logo VARBINARY(MAX) = 0x89504E470D0A1A0A0000000D49484452000000010000000108060000001F15C4890000000D4944415478DA63646000000002000114AF72110000000049454E44AE426082;

BEGIN TRY
    BEGIN TRANSACTION;

    -- ---- Admin ----
    INSERT INTO dbo.Admin (Name, Username, Password, Email, PhoneNumber)
    VALUES ('Portal Administrator', 'admin', @pwd, 'admin@jobportal.local', '000-000-0000');

    -- ---- Categories (IDs will be 1-15 in insertion order) ----
    -- ID 1
    INSERT INTO dbo.Categories (CategoryName) VALUES ('Accounting & Finance');
    -- ID 2
    INSERT INTO dbo.Categories (CategoryName) VALUES ('Software Development');
    -- ID 3
    INSERT INTO dbo.Categories (CategoryName) VALUES ('Web Development');
    -- ID 4
    INSERT INTO dbo.Categories (CategoryName) VALUES ('Mobile Development');
    -- ID 5
    INSERT INTO dbo.Categories (CategoryName) VALUES ('Data Science & AI');
    -- ID 6
    INSERT INTO dbo.Categories (CategoryName) VALUES ('Cloud & DevOps');
    -- ID 7
    INSERT INTO dbo.Categories (CategoryName) VALUES ('Network & Security');
    -- ID 8
    INSERT INTO dbo.Categories (CategoryName) VALUES ('Database Administration');
    -- ID 9
    INSERT INTO dbo.Categories (CategoryName) VALUES ('Testing & QA');
    -- ID 10
    INSERT INTO dbo.Categories (CategoryName) VALUES ('Project Management');
    -- ID 11
    INSERT INTO dbo.Categories (CategoryName) VALUES ('UI/UX Design');
    -- ID 12
    INSERT INTO dbo.Categories (CategoryName) VALUES ('Full Stack Development');
    -- ID 13
    INSERT INTO dbo.Categories (CategoryName) VALUES ('Technical Support');
    -- ID 14
    INSERT INTO dbo.Categories (CategoryName) VALUES ('Marketing & SEO');
    -- ID 15
    INSERT INTO dbo.Categories (CategoryName) VALUES ('Human Resources');

    -- ---- Skills (IDs 1-36 in insertion order) ----
    INSERT INTO dbo.Skills (SkillName) VALUES ('C++');            -- 1
    INSERT INTO dbo.Skills (SkillName) VALUES ('C#');             -- 2
    INSERT INTO dbo.Skills (SkillName) VALUES ('Java');           -- 3
    INSERT INTO dbo.Skills (SkillName) VALUES ('Python');         -- 4
    INSERT INTO dbo.Skills (SkillName) VALUES ('PHP');            -- 5
    INSERT INTO dbo.Skills (SkillName) VALUES ('Ruby');           -- 6
    INSERT INTO dbo.Skills (SkillName) VALUES ('Swift');          -- 7
    INSERT INTO dbo.Skills (SkillName) VALUES ('Kotlin');         -- 8
    INSERT INTO dbo.Skills (SkillName) VALUES ('TypeScript');     -- 9
    INSERT INTO dbo.Skills (SkillName) VALUES ('Go');             -- 10
    INSERT INTO dbo.Skills (SkillName) VALUES ('Cybersecurity');  -- 11
    INSERT INTO dbo.Skills (SkillName) VALUES ('SQL');            -- 12
    INSERT INTO dbo.Skills (SkillName) VALUES ('MongoDB');        -- 13
    INSERT INTO dbo.Skills (SkillName) VALUES ('PostgreSQL');     -- 14
    INSERT INTO dbo.Skills (SkillName) VALUES ('MySQL');          -- 15
    INSERT INTO dbo.Skills (SkillName) VALUES ('HTML/CSS');       -- 16
    INSERT INTO dbo.Skills (SkillName) VALUES ('DevOps');         -- 17
    INSERT INTO dbo.Skills (SkillName) VALUES ('Software Testing');-- 18
    INSERT INTO dbo.Skills (SkillName) VALUES ('Git');            -- 19
    INSERT INTO dbo.Skills (SkillName) VALUES ('Network Admin');  -- 20
    INSERT INTO dbo.Skills (SkillName) VALUES ('Linux');          -- 21
    INSERT INTO dbo.Skills (SkillName) VALUES ('Docker');         -- 22
    INSERT INTO dbo.Skills (SkillName) VALUES ('Kubernetes');     -- 23
    INSERT INTO dbo.Skills (SkillName) VALUES ('AWS');            -- 24
    INSERT INTO dbo.Skills (SkillName) VALUES ('Azure');          -- 25
    INSERT INTO dbo.Skills (SkillName) VALUES ('Figma');          -- 26
    INSERT INTO dbo.Skills (SkillName) VALUES ('React.js');       -- 27
    INSERT INTO dbo.Skills (SkillName) VALUES ('Angular');        -- 28
    INSERT INTO dbo.Skills (SkillName) VALUES ('Vue.js');         -- 29
    INSERT INTO dbo.Skills (SkillName) VALUES ('Node.js');        -- 30
    INSERT INTO dbo.Skills (SkillName) VALUES ('Django');         -- 31
    INSERT INTO dbo.Skills (SkillName) VALUES ('ASP.NET MVC');    -- 32
    INSERT INTO dbo.Skills (SkillName) VALUES ('Spring Boot');    -- 33
    INSERT INTO dbo.Skills (SkillName) VALUES ('Flutter');        -- 34
    INSERT INTO dbo.Skills (SkillName) VALUES ('JavaScript');     -- 35
    INSERT INTO dbo.Skills (SkillName) VALUES ('Machine Learning');-- 36

    -- ---- Employers (all Approved, Password = Pak@123) ----
    INSERT INTO dbo.Employers (CompanyName, OfficialEmail, Email, ContactPhone, Website, Name, Designation, CompanyLogo, Username, Password, Status)
    VALUES ('Systems Limited',    'hr@systemsltd.com',      'systems@jobportal.local', '042-111-797-836', 'https://www.systemsltd.com', 'Adeel', 'HR Director',        @logo, 'systemsltd', @pwd, 'Approved');

    INSERT INTO dbo.Employers (CompanyName, OfficialEmail, Email, ContactPhone, Website, Name, Designation, CompanyLogo, Username, Password, Status)
    VALUES ('NetSol Technologies', 'hr@netsolpk.com',       'netsol@jobportal.local',  '042-111-448-800', 'https://www.netsol.com',      'Salim', 'HR Manager',        @logo, 'netsolpk',   @pwd, 'Approved');

    INSERT INTO dbo.Employers (CompanyName, OfficialEmail, Email, ContactPhone, Website, Name, Designation, CompanyLogo, Username, Password, Status)
    VALUES ('Jazz Pakistan',       'jobs@jazz.com.pk',       'jazz@jobportal.local',    '051-111-300-300', 'https://www.jazz.com.pk',     'Aisha', 'Talent Acquisition',@logo, 'jazzpk',     @pwd, 'Approved');

    INSERT INTO dbo.Employers (CompanyName, OfficialEmail, Email, ContactPhone, Website, Name, Designation, CompanyLogo, Username, Password, Status)
    VALUES ('UBL Bank',            'careers@ubldirect.com',  'ubl@jobportal.local',     '021-111-825-888', 'https://www.ubldirect.com',   'Bilal', 'Recruitment Head',  @logo, 'ublpk',      @pwd, 'Approved');

    INSERT INTO dbo.Employers (CompanyName, OfficialEmail, Email, ContactPhone, Website, Name, Designation, CompanyLogo, Username, Password, Status)
    VALUES ('Arbisoft',            'careers@arbisoft.com',   'arbisoft@jobportal.local','042-111-272-476', 'https://www.arbisoft.com',    'Zara',  'HR Lead',           @logo, 'arbisoft',   @pwd, 'Approved');

    -- ---- Job Vacancies ----
    DECLARE @emp1 INT = (SELECT EmployerID FROM dbo.Employers WHERE Username = 'systemsltd');
    DECLARE @emp2 INT = (SELECT EmployerID FROM dbo.Employers WHERE Username = 'netsolpk');
    DECLARE @emp3 INT = (SELECT EmployerID FROM dbo.Employers WHERE Username = 'jazzpk');
    DECLARE @emp4 INT = (SELECT EmployerID FROM dbo.Employers WHERE Username = 'ublpk');
    DECLARE @emp5 INT = (SELECT EmployerID FROM dbo.Employers WHERE Username = 'arbisoft');

    INSERT INTO dbo.JobVacancies (EmployerID, JobTitle, Description, CategoryID, Location, Salary, EmploymentType, ApplicationDeadline, IsPublished)
    VALUES
    (@emp1, '.NET Core Senior Developer',
     'We are looking for a highly skilled C# .NET Core developer with 5+ years of experience building enterprise-grade APIs and services using ASP.NET MVC and Web API. Strong SQL Server skills required.',
     2, 'Lahore', 180000.00, 'Full Time', DATEADD(DAY, 45, GETDATE()), 1),

    (@emp1, 'React Frontend Developer',
     'Join our dynamic frontend team and build beautiful, performant enterprise React applications. You will collaborate with UX designers and backend engineers to deliver world-class user experiences.',
     3, 'Karachi', 150000.00, 'Full Time', DATEADD(DAY, 30, GETDATE()), 1),

    (@emp2, 'Senior QA Engineer',
     'Plan and execute manual and automated testing strategies for complex web applications. Experience with Selenium, TestNG, and Jira required.',
     9, 'Lahore', 120000.00, 'Full Time', DATEADD(DAY, 30, GETDATE()), 1),

    (@emp3, 'Network Security Engineer',
     'Manage corporate firewall, VPN infrastructure, and core network routing. CCNA/CCNP certification preferred. Experience with Cisco ASA and Palo Alto firewalls.',
     7, 'Islamabad', 200000.00, 'Full Time', DATEADD(DAY, 30, GETDATE()), 1),

    (@emp4, 'Full Stack Engineer',
     'Help digitize our retail banking platform. You will own full-stack features using React on the frontend and Java Spring Boot on the backend. Fintech experience is a big plus.',
     12, 'Karachi', 220000.00, 'Full Time', DATEADD(DAY, 35, GETDATE()), 1),

    (@emp5, 'Python Backend Developer',
     'Build scalable Python Django REST APIs for our ed-tech SaaS products. Proficiency in PostgreSQL, Redis, and Docker is required. Remote-friendly role.',
     2, 'Lahore', 160000.00, 'Full Time', DATEADD(DAY, 40, GETDATE()), 1),

    (@emp5, 'Data Scientist',
     'Apply machine learning models to solve real business problems. Hands-on experience with Python, pandas, scikit-learn, and TensorFlow preferred. Degree in Statistics, CS or related field.',
     5, 'Islamabad', 250000.00, 'Full Time', DATEADD(DAY, 60, GETDATE()), 1),

    (@emp2, 'DevOps Engineer',
     'Design and maintain CI/CD pipelines, manage Kubernetes clusters on AWS, and automate infrastructure provisioning with Terraform. Strong Linux and shell scripting skills required.',
     6, 'Remote', 190000.00, 'Full Time', DATEADD(DAY, 30, GETDATE()), 1);

    -- ---- Job Seekers ----
    DECLARE @img VARBINARY(MAX) = 0x89504E470D0A1A0A0000000D49484452000000010000000108060000001F15C4890000000D4944415478DA63646000000002000114AF72110000000049454E44AE426082;

    INSERT INTO dbo.JobSeekers (FirstName, LastName, Gender, Birthdate, Email, PhoneNumber, Password, Resume, Experience, ProfilePicture, Address, City, State, Username)
    VALUES
    ('Ali',     'Khan',   'M', '1998-05-10', 'alikhan@jobportal.local',     '0300-1234567', @pwd, @img, '3', @img, 'DHA Phase 5',       'Lahore',    'Punjab',   'alikhan'),
    ('Fatima',  'Bibi',   'F', '1999-08-22', 'fatimabibi@jobportal.local',  '0312-7654321', @pwd, @img, '2', @img, 'Gulshan-e-Iqbal',   'Karachi',   'Sindh',    'fatimabibi'),
    ('Ahmed',   'Raza',   'M', '1996-03-15', 'ahmedraza@jobportal.local',   '0321-4567890', @pwd, @img, '5', @img, 'Sector F-7',        'Islamabad', 'Federal',  'ahmedraza'),
    ('Sara',    'Ahmed',  'F', '2000-11-02', 'saraahmed@jobportal.local',   '0333-9876543', @pwd, @img, '1', @img, 'Johar Town',        'Lahore',    'Punjab',   'saraahmed'),
    ('Zeeshan', 'Malik',  'M', '1997-12-25', 'zeeshanmalik@jobportal.local','0345-6543210', @pwd, @img, '4', @img, 'Peshawar Road',     'Rawalpindi','Punjab',   'zeeshanmalik');

    -- ---- Education Details ----
    DECLARE @sid1 INT = (SELECT SeekerID FROM dbo.JobSeekers WHERE Username = 'alikhan');
    DECLARE @sid2 INT = (SELECT SeekerID FROM dbo.JobSeekers WHERE Username = 'fatimabibi');
    DECLARE @sid3 INT = (SELECT SeekerID FROM dbo.JobSeekers WHERE Username = 'ahmedraza');
    DECLARE @sid4 INT = (SELECT SeekerID FROM dbo.JobSeekers WHERE Username = 'saraahmed');
    DECLARE @sid5 INT = (SELECT SeekerID FROM dbo.JobSeekers WHERE Username = 'zeeshanmalik');

    INSERT INTO dbo.EducationDetails (SeekerID, University, Degree, Major, GraduationYear, GPA)
    VALUES
    (@sid1, 'FAST NUCES',      'BS', 'Computer Science',      2020, 3.40),
    (@sid2, 'NED University',  'BE', 'Software Engineering',  2021, 3.60),
    (@sid3, 'NUST',            'MS', 'Information Technology',2018, 3.80),
    (@sid4, 'Punjab University','BS','Information Technology', 2022, 3.20),
    (@sid5, 'COMSATS',         'BS', 'Computer Engineering',  2019, 3.50);

    -- ---- Job Seeker Skills (using fixed IDs from the Skills insert above) ----
    -- Ali Khan:     C#(2), JavaScript(35), ASP.NET MVC(32)
    -- Fatima Bibi:  React.js(27), JavaScript(35), HTML/CSS(16)
    -- Ahmed Raza:   Network Admin(20), Cybersecurity(11), Linux(21)
    -- Sara Ahmed:   Software Testing(18), SQL(12), Git(19)
    -- Zeeshan Malik: C#(2), DevOps(17), Docker(22)
    INSERT INTO dbo.JobSeekerSkills (JobSeekerID, SkillID)
    VALUES
    (@sid1, 2),  -- C#
    (@sid1, 35), -- JavaScript
    (@sid1, 32), -- ASP.NET MVC
    (@sid2, 27), -- React.js
    (@sid2, 35), -- JavaScript
    (@sid2, 16), -- HTML/CSS
    (@sid3, 20), -- Network Admin
    (@sid3, 11), -- Cybersecurity
    (@sid3, 21), -- Linux
    (@sid4, 18), -- Software Testing
    (@sid4, 12), -- SQL
    (@sid4, 19), -- Git
    (@sid5, 2),  -- C#
    (@sid5, 17), -- DevOps
    (@sid5, 22); -- Docker

    -- ---- Sample Job Applications ----
    DECLARE @vac1 INT = (SELECT TOP 1 VacancyID FROM dbo.JobVacancies WHERE JobTitle = '.NET Core Senior Developer');
    DECLARE @vac2 INT = (SELECT TOP 1 VacancyID FROM dbo.JobVacancies WHERE JobTitle = 'React Frontend Developer');
    DECLARE @vac3 INT = (SELECT TOP 1 VacancyID FROM dbo.JobVacancies WHERE JobTitle = 'Senior QA Engineer');
    DECLARE @vac4 INT = (SELECT TOP 1 VacancyID FROM dbo.JobVacancies WHERE JobTitle = 'Network Security Engineer');
    DECLARE @vac5 INT = (SELECT TOP 1 VacancyID FROM dbo.JobVacancies WHERE JobTitle = 'Full Stack Engineer');

    INSERT INTO dbo.JobApplications (JobID, SeekerID, ApplicationDate, Status)
    VALUES
    (@vac1, @sid1, DATEADD(DAY, -5, GETDATE()), 'Pending'),
    (@vac2, @sid2, DATEADD(DAY, -3, GETDATE()), 'Read'),
    (@vac3, @sid4, DATEADD(DAY, -7, GETDATE()), 'Approved'),
    (@vac4, @sid3, DATEADD(DAY, -2, GETDATE()), 'Pending'),
    (@vac5, @sid5, DATEADD(DAY, -1, GETDATE()), 'Pending'),
    (@vac1, @sid5, DATEADD(DAY, -4, GETDATE()), 'Rejected');

    -- ---- Sample Bookmarks ----
    INSERT INTO dbo.Bookmarks (SeekerID, JobID)
    VALUES
    (@sid1, @vac2),
    (@sid1, @vac5),
    (@sid2, @vac1),
    (@sid3, @vac4),
    (@sid4, @vac3);

    -- ---- Sample Job Views ----
    INSERT INTO dbo.JobViews (JobID, SeekerID, ViewDate)
    VALUES
    (@vac1, @sid1, DATEADD(DAY, -6, GETDATE())),
    (@vac1, @sid2, DATEADD(DAY, -5, GETDATE())),
    (@vac2, @sid1, DATEADD(DAY, -4, GETDATE())),
    (@vac2, @sid2, DATEADD(DAY, -3, GETDATE())),
    (@vac3, @sid4, DATEADD(DAY, -8, GETDATE())),
    (@vac4, @sid3, DATEADD(DAY, -2, GETDATE())),
    (@vac5, @sid5, DATEADD(DAY, -1, GETDATE()));

    -- ---- Sample Chat & Messages ----
    INSERT INTO dbo.Chats (SeekerID, EmployerID)
    VALUES (@sid1, @emp1);

    DECLARE @chat1 INT = SCOPE_IDENTITY();

    INSERT INTO dbo.ChatMessages (ChatID, Message, DateAndTime, Sender)
    VALUES
    (@chat1, 'Hello, I am interested in the .NET Core Developer position.', DATEADD(HOUR, -3, GETDATE()), 'S'),
    (@chat1, 'Thank you for reaching out! Please share your portfolio link.', DATEADD(HOUR, -2, GETDATE()), 'E'),
    (@chat1, 'Sure! Here is my GitHub: github.com/alikhan', DATEADD(HOUR, -1, GETDATE()), 'S');

    COMMIT TRANSACTION;
    PRINT '============================================';
    PRINT 'Seeding completed successfully!';
    PRINT '============================================';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @ErrSev INT            = ERROR_SEVERITY();
    DECLARE @ErrSta INT            = ERROR_STATE();
    PRINT 'ERROR: ' + @ErrMsg;
    RAISERROR(@ErrMsg, @ErrSev, @ErrSta);
END CATCH;
GO

-- Final check
USE [master]
GO
ALTER DATABASE [JobPortal_New1] SET READ_WRITE
GO
PRINT 'Database is ready. JobPortal_New1 is online.'
GO
