USE [master]
GO

-- ============================================================
-- CREATE DATABASE
-- ============================================================
CREATE DATABASE [JobPortal_New1]
GO

-- ============================================================
-- SET DATABASE OPTIONS
-- ============================================================
ALTER DATABASE [JobPortal_New1] SET COMPATIBILITY_LEVEL = 150
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
BEGIN
	EXEC [JobPortal_New1].[dbo].[sp_fulltext_database] @action = 'enable'
END
GO

ALTER DATABASE [JobPortal_New1] SET ANSI_NULL_DEFAULT OFF 
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
ALTER DATABASE [JobPortal_New1] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [JobPortal_New1] SET CURSOR_DEFAULT GLOBAL 
GO
ALTER DATABASE [JobPortal_New1] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [JobPortal_New1] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [JobPortal_New1] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [JobPortal_New1] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [JobPortal_New1] SET DISABLE_BROKER 
GO
ALTER DATABASE [JobPortal_New1] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [JobPortal_New1] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [JobPortal_New1] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [JobPortal_New1] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [JobPortal_New1] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [JobPortal_New1] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [JobPortal_New1] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [JobPortal_New1] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [JobPortal_New1] SET MULTI_USER 
GO
ALTER DATABASE [JobPortal_New1] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [JobPortal_New1] SET DB_CHAINING OFF 
GO
ALTER DATABASE [JobPortal_New1] SET FILESTREAM(NON_TRANSACTED_ACCESS = OFF) 
GO
ALTER DATABASE [JobPortal_New1] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [JobPortal_New1] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [JobPortal_New1] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [JobPortal_New1] SET QUERY_STORE = OFF
GO

USE [JobPortal_New1]
GO

-- ============================================================
-- CREATE TABLES
-- ============================================================

-- Table: Admin
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Admin](
	[AdminID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
	[Username] [varchar](50) NULL,
	[Password] [nvarchar](100) NULL,
	[Email] [varchar](50) NULL,
	[PhoneNumber] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[AdminID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Table: Categories
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categories](
	[CategoryID] [int] IDENTITY(1,1) NOT NULL,
	[CategoryName] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[CategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Table: Skills
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Skills](
	[SkillID] [int] IDENTITY(1,1) NOT NULL,
	[SkillName] [varchar](50) NOT NULL,
CONSTRAINT [PK_Skills] PRIMARY KEY CLUSTERED 
(
	[SkillID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Table: Locations
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Locations](
	[LocationID] [int] IDENTITY(1,1) NOT NULL,
	[LocationName] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[LocationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Table: Employers
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employers](
	[EmployerID] [int] IDENTITY(1,1) NOT NULL,
	[CompanyName] [varchar](100) NULL,
	[OfficialEmail] [varchar](100) NULL,
	[Email] [varchar](100) NOT NULL,
	[ContactPhone] [varchar](20) NULL,
	[Website] [varchar](100) NULL,
	[Name] [varchar](50) NULL,
	[Designation] [varchar](50) NULL,
	[CompanyLogo] [varbinary](max) NOT NULL,
	[Password] [nvarchar](100) NULL,
	[Status] [varchar](10) NOT NULL,
	[Username] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[EmployerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

-- Table: JobSeekers
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JobSeekers](
	[SeekerID] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](50) NULL,
	[LastName] [varchar](50) NULL,
	[Gender] [char](1) NULL,
	[Birthdate] [date] NULL,
	[Email] [varchar](100) NOT NULL,
	[PhoneNumber] [varchar](20) NULL,
	[Resume] [varbinary](max) NULL,
	[Experience] [varchar](25) NULL,
	[Password] [nvarchar](100) NULL,
	[ProfilePicture] [varbinary](max) NULL,
	[Address] [varchar](50) NULL,
	[City] [varchar](20) NULL,
	[State] [varchar](20) NULL,
	[Username] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[SeekerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

-- Table: JobSeekerSkills
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JobSeekerSkills](
	[JobSeekerSkillID] [int] IDENTITY(1,1) NOT NULL,
	[JobSeekerID] [int] NULL,
	[SkillID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[JobSeekerSkillID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Table: EducationDetails
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EducationDetails](
	[EducationID] [int] IDENTITY(1,1) NOT NULL,
	[SeekerID] [int] NULL,
	[University] [varchar](100) NULL,
	[Degree] [varchar](50) NULL,
	[Major] [varchar](100) NULL,
	[GraduationYear] [int] NULL,
	[GPA] [decimal](3, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[EducationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Table: JobVacancies
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JobVacancies](
	[VacancyID] [int] IDENTITY(1,1) NOT NULL,
	[EmployerID] [int] NULL,
	[JobTitle] [varchar](100) NULL,
	[Description] [text] NULL,
	[CategoryID] [int] NULL,
	[Location] [varchar](50) NULL,
	[Salary] [decimal](10, 2) NULL,
	[EmploymentType] [varchar](50) NULL,
	[ApplicationDeadline] [datetime2](7) NULL,
	[IsPublished] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[VacancyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

-- Table: JobApplications
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JobApplications](
	[ApplicationID] [int] IDENTITY(1,1) NOT NULL,
	[JobID] [int] NULL,
	[SeekerID] [int] NULL,
	[ApplicationDate] [datetime2](7) NULL,
	[Status] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[ApplicationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Table: JobViews
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JobViews](
	[ViewID] [int] IDENTITY(1,1) NOT NULL,
	[JobID] [int] NULL,
	[SeekerID] [int] NULL,
	[ViewDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ViewID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Table: Bookmarks
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bookmarks](
	[BookmarkID] [int] IDENTITY(1,1) NOT NULL,
	[SeekerID] [int] NULL,
	[JobID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[BookmarkID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Table: Chats
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Chats](
	[ChatID] [int] IDENTITY(1,1) NOT NULL,
	[SeekerID] [int] NULL,
	[EmployerID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ChatID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Table: ChatMessages
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChatMessages](
	[MessageID] [int] IDENTITY(1,1) NOT NULL,
	[ChatID] [int] NULL,
	[Message] [text] NULL,
	[DateAndTime] [datetime2](7) NULL,
	[Sender] [char](1) NULL,
PRIMARY KEY CLUSTERED 
(
	[MessageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

-- Table: Messages
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Messages](
	[FirstName] [varchar](50) NULL,
	[LastName] [varchar](50) NULL,
	[PhoneNumber] [varchar](50) NULL,
	[Email] [varchar](100) NULL,
	[Message] [text] NULL,
	[ContactId] [int] IDENTITY(1,1) NOT NULL,
	[DateTime] [datetime2](7) NULL,
CONSTRAINT [PK_Messages] PRIMARY KEY CLUSTERED 
(
	[ContactId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

-- ============================================================
-- ADD FOREIGN KEYS
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

-- ============================================================
-- CREATE STORED PROCEDURES
-- ============================================================

-- SP_AdminChangePassword
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_AdminChangePassword]
@Username NVARCHAR(100),
@NewPassword NVARCHAR(100)
AS
BEGIN
	UPDATE [dbo].[Admin] SET Password = @NewPassword WHERE Username = @Username
END
GO

-- SP_AdminLogin
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_AdminLogin]
@Username VARCHAR(100)
AS
BEGIN
	IF EXISTS (SELECT 1 FROM [dbo].[Admin] WHERE Username = @Username)
	BEGIN
		SELECT Password AS Result FROM [dbo].[Admin] WHERE Username = @Username
	END
	ELSE
	BEGIN
		SELECT 0 AS Result
	END
END
GO

-- SP_Bookmark
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Bookmark]
@SeekerId INT,
@JobId INT
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM [dbo].[Bookmarks] WHERE JobID = @JobId AND SeekerID = @SeekerId)
	BEGIN
		INSERT INTO [dbo].[Bookmarks] (JobID, SeekerID) VALUES (@JobId, @SeekerId)
	END
	ELSE
	BEGIN
		DELETE FROM [dbo].[Bookmarks] WHERE JobID = @JobId AND SeekerID = @SeekerId
	END
END
GO

-- SP_ChangeEmployerPassword
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_ChangeEmployerPassword]
@EmployerID INT,
@NewPassword NVARCHAR(100)
AS
BEGIN
	UPDATE [dbo].[Employers] SET Password = @NewPassword WHERE EmployerID = @EmployerID
END
GO

-- SP_ChangeJobSeekerPassword
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_ChangeJobSeekerPassword]
@SeekerID INT,
@NewPassword NVARCHAR(100)
AS
BEGIN
	UPDATE [dbo].[JobSeekers] SET Password = @NewPassword WHERE SeekerID = @SeekerID
END
GO

-- SP_ChatListEmployer
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_ChatListEmployer]
@EmployerID INT
AS
BEGIN
	SELECT C.SeekerID, C.EmployerID, C.ChatID, CONCAT(J.FirstName, ' ', J.LastName) AS SeekerName, E.CompanyName
	FROM [dbo].[Chats] C
	INNER JOIN [dbo].[JobSeekers] J ON C.SeekerID = J.SeekerID
	INNER JOIN [dbo].[Employers] E ON C.EmployerID = E.EmployerID
	WHERE C.EmployerID = @EmployerID
END
GO

-- SP_ChatListSeeker
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_ChatListSeeker]
@SeekerID INT
AS
BEGIN
	SELECT C.SeekerID, C.EmployerID, C.ChatID, CONCAT(J.FirstName, ' ', J.LastName) AS SeekerName, E.CompanyName
	FROM [dbo].[Chats] C
	INNER JOIN [dbo].[JobSeekers] J ON C.SeekerID = J.SeekerID
	INNER JOIN [dbo].[Employers] E ON C.EmployerID = E.EmployerID
	WHERE C.SeekerID = @SeekerID
END
GO

-- SP_CheckPhoneNumber
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CheckPhoneNumber]
@PhoneNumber VARCHAR(30)
AS
BEGIN
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
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CheckUsername]
@Username VARCHAR(30)
AS
BEGIN
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
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CreateAdmin]
@Name VARCHAR(20),
@Username VARCHAR(20),
@Password NVARCHAR(100),
@Email VARCHAR(50),
@PhoneNumber VARCHAR(20)
AS
BEGIN
	INSERT INTO [dbo].[Admin](Name, Username, Password, Email, PhoneNumber)
	VALUES (@Name, @Username, @Password, @Email, @PhoneNumber)
END
GO

-- SP_CreateCategory
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CreateCategory]
@CategoryName VARCHAR(50)
AS
BEGIN
	INSERT INTO [dbo].[Categories] (CategoryName)
	VALUES (@CategoryName)
END
GO

-- SP_CreateContactUsMessage
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CreateContactUsMessage]
@FirstName VARCHAR(50),
@LastName VARCHAR(20),
@PhoneNumber VARCHAR(20),
@Email VARCHAR(100),
@DateTime DATETIME2,
@Message TEXT
AS
BEGIN
	INSERT INTO [dbo].[Messages] (FirstName, LastName, PhoneNumber, Email, DateTime, Message)
	VALUES(@FirstName, @LastName, @PhoneNumber, @Email, @DateTime, @Message)
END
GO

-- SP_CreateEducationDetail
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CreateEducationDetail]
@SeekerID INT,
@University VARCHAR(100),
@Degree VARCHAR(50),
@Major VARCHAR(100),
@GraduationYear INT,
@GPA DECIMAL(3, 2)
AS
BEGIN
	INSERT INTO [dbo].[EducationDetails] (SeekerID, Degree, University, Major, GraduationYear, GPA)
	VALUES (@SeekerID, @Degree, @University, @Major, @GraduationYear, @GPA)
END
GO

-- SP_CreateEmployer
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CreateEmployer]
@CompanyName VARCHAR(100),
@OfficialEmail VARCHAR(100),
@Email VARCHAR(100),
@ContactPhone VARCHAR(20),
@Website VARCHAR(100),
@Name VARCHAR(50),
@Designation VARCHAR(50),
@CompanyLogo VARBINARY(MAX),
@Username VARCHAR(20),
@Password NVARCHAR(100),
@Status VARCHAR(10) = 'Pending'
AS
BEGIN
	INSERT INTO [dbo].[Employers] (CompanyName, OfficialEmail, Email, ContactPhone, Website, Name, Designation, CompanyLogo, Username, Password, Status)
	VALUES (@CompanyName, @OfficialEmail, @Email, @ContactPhone, @Website, @Name, @Designation, @CompanyLogo, @Username, @Password, @Status)
END
GO

-- SP_CreateJobApplication
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CreateJobApplication]
@JobID INT,
@SeekerID INT,
@ApplicationDate DATETIME2,
@Status VARCHAR(50) = 'Pending'
AS
BEGIN
	INSERT INTO [dbo].[JobApplications] (JobID, SeekerID, ApplicationDate, Status)
	VALUES (@JobID, @SeekerID, @ApplicationDate, @Status)
END
GO

-- SP_CreateJobSeeker
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CreateJobSeeker]
@FirstName VARCHAR(50),
@LastName VARCHAR(50),
@Gender CHAR(1),
@Birthdate DATE,
@Email VARCHAR(100),
@PhoneNumber VARCHAR(20),
@Password NVARCHAR(100),
@Resume VARBINARY(MAX),
@Experience VARCHAR(255),
@Image VARBINARY(MAX),
@Address VARCHAR(50),
@City VARCHAR(20),
@State VARCHAR(20),
@Username VARCHAR(50)
AS
BEGIN
	INSERT INTO [dbo].[JobSeekers] (FirstName, LastName, Gender, Birthdate, Email, PhoneNumber, Password, Resume, Experience, ProfilePicture, Address, City, State, Username)
	VALUES (@FirstName, @LastName, @Gender, @Birthdate, @Email, @PhoneNumber, @Password, @Resume, @Experience, @Image, @Address, @City, @State, @Username)
END
GO

-- SP_CreateJobSeekerSkills
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CreateJobSeekerSkills]
@SkillId INT,
@SeekerId INT
AS
BEGIN
	INSERT INTO [dbo].[JobSeekerSkills](SkillID, JobSeekerID)
	VALUES (@SkillId, @SeekerId)
END
GO

-- SP_CreateJobVacancy
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CreateJobVacancy]
@EmployerID INT,
@JobTitle VARCHAR(100),
@Description TEXT,
@CategoryID INT,
@Location VARCHAR(50),
@Salary DECIMAL(10, 2),
@EmploymentType VARCHAR(50),
@ApplicationDeadline DATETIME2,
@IsPublished BIT = 1
AS
BEGIN
	INSERT INTO [dbo].[JobVacancies] (EmployerID, JobTitle, Description, CategoryID, Location, Salary, EmploymentType, ApplicationDeadline, IsPublished)
	VALUES (@EmployerID, @JobTitle, @Description, @CategoryID, @Location, @Salary, @EmploymentType, @ApplicationDeadline, @IsPublished)
END
GO

-- SP_CreateJobView
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CreateJobView]
@JobID INT,
@SeekerID INT,
@ViewDate DATETIME
AS
BEGIN
	IF NOT EXISTS(SELECT 1 FROM [dbo].[JobViews] WHERE JobID = @JobID AND SeekerID = @SeekerID)
	BEGIN
		INSERT INTO [dbo].[JobViews] VALUES (@JobID, @SeekerID, @ViewDate)
	END
END
GO

-- SP_CreateMessage
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CreateMessage]
@SeekerID INT,
@EmployerID INT,
@Message TEXT,
@DateAndTime DATETIME2,
@Sender CHAR(1)
AS
BEGIN
	DECLARE @ChatID INT
	IF EXISTS (SELECT TOP 1 ChatID FROM [dbo].[Chats] WHERE SeekerID = @SeekerID AND EmployerID = @EmployerID)
	BEGIN
		SELECT @ChatID = ChatID FROM [dbo].[Chats] WHERE SeekerID = @SeekerID AND EmployerID = @EmployerID
	END
	ELSE
	BEGIN
		INSERT INTO [dbo].[Chats] (SeekerID, EmployerID) VALUES (@SeekerID, @EmployerID)
		SET @ChatID = SCOPE_IDENTITY()
	END
	INSERT INTO [dbo].[ChatMessages] (ChatID, Message, DateAndTime, Sender) VALUES (@ChatID, @Message, @DateAndTime, @Sender)
END
GO

-- SP_CreateSkill
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CreateSkill]
@SkillName VARCHAR(100)
AS
BEGIN
	INSERT INTO [dbo].[Skills] (SkillName)
	VALUES (@SkillName)
END
GO

-- SP_DeleteCategory
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_DeleteCategory]
@CategoryID INT
AS
BEGIN
	DELETE FROM [dbo].[Categories] WHERE CategoryID = @CategoryID
END
GO

-- SP_DeleteEducationDetail
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_DeleteEducationDetail]
@EducationID INT
AS
BEGIN
	DELETE FROM [dbo].[EducationDetails] WHERE EducationID = @EducationID
END
GO

-- SP_DeleteEmployer
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_DeleteEmployer]
@EmployerID INT
AS
BEGIN
	DELETE FROM [dbo].[Employers] WHERE EmployerID = @EmployerID
END
GO

-- SP_DeleteJobApplication
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_DeleteJobApplication]
@ApplicationID INT
AS
BEGIN
	DELETE FROM [dbo].[JobApplications] WHERE ApplicationID = @ApplicationID
END
GO

-- SP_DeleteJobSeeker
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_DeleteJobSeeker]
@SeekerID INT
AS
BEGIN
	DELETE FROM [dbo].[JobSeekers] WHERE SeekerID = @SeekerID
END
GO

-- SP_DeleteJobSeekerSkill
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_DeleteJobSeekerSkill]
@JobSeekerSkillID INT
AS
BEGIN
	DELETE FROM [dbo].[JobSeekerSkills] WHERE JobSeekerSkillID = @JobSeekerSkillID
END
GO

-- SP_DeleteJobVacancy
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_DeleteJobVacancy]
@VacancyID INT
AS
BEGIN
	DELETE FROM [dbo].[JobVacancies] WHERE VacancyID = @VacancyID
END
GO

-- SP_DeleteSkill
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_DeleteSkill]
@SkillID INT
AS
BEGIN
	DELETE FROM [dbo].[Skills] WHERE SkillID = @SkillID
END
GO

-- SP_EmployerApprove
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_EmployerApprove]
@EmployerId INT
AS
BEGIN
	UPDATE [dbo].[Employers] SET Status = 'Approved' WHERE EmployerID = @EmployerId
END
GO

-- SP_EmployerLogin
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_EmployerLogin]
@Username VARCHAR(100)
AS
BEGIN
	IF EXISTS (SELECT 1 FROM [dbo].[Employers] WHERE Username = @Username)
	BEGIN
		SELECT Password AS Result FROM [dbo].[Employers] WHERE Username = @Username
	END
	ELSE
	BEGIN
		SELECT 0 AS Result
	END
END
GO

-- SP_EmployerReject
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_EmployerReject]
@EmployerId INT
AS
BEGIN
	UPDATE [dbo].[Employers] SET Status = 'Rejected' WHERE EmployerID = @EmployerId
END
GO

-- SP_JobApplicationApprove
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_JobApplicationApprove]
@ApplicationId INT
AS
BEGIN
	UPDATE [dbo].[JobApplications] SET Status = 'Approved' WHERE ApplicationID = @ApplicationId
END
GO

-- SP_JobApplicationRead
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_JobApplicationRead]
@ApplicationId INT
AS
BEGIN
	DECLARE @Current VARCHAR(20)
	SELECT @Current = Status FROM [dbo].[JobApplications] WHERE ApplicationID = @ApplicationId
	IF @Current = 'Pending'
	BEGIN
		UPDATE [dbo].[JobApplications] SET Status = 'Read' WHERE ApplicationID = @ApplicationId
	END
END
GO

-- SP_JobApplicationReject
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_JobApplicationReject]
@ApplicationId INT
AS
BEGIN
	UPDATE [dbo].[JobApplications] SET Status = 'Rejected' WHERE ApplicationID = @ApplicationId
END
GO

-- SP_JobSeekerLogin
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_JobSeekerLogin]
@Username VARCHAR(100)
AS
BEGIN
	IF EXISTS (SELECT 1 FROM [dbo].[JobSeekers] WHERE Username = @Username)
	BEGIN
		SELECT Password AS Result FROM [dbo].[JobSeekers] WHERE Username = @Username
	END
	ELSE
	BEGIN
		SELECT 0 AS Result
	END
END
GO

-- SP_ReadAdminPassword
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_ReadAdminPassword]
@Username VARCHAR(20)
AS
BEGIN
	SELECT Password FROM [dbo].[Admin] WHERE Username = @Username
END
GO

-- SP_ReadBookMarks
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_ReadBookMarks]
@SeekerId INT
AS
BEGIN
	SELECT B.BookmarkID, B.JobID, JV.JobTitle
	FROM [dbo].[Bookmarks] B
	INNER JOIN [dbo].[JobVacancies] JV ON B.JobID = JV.VacancyID
	WHERE B.SeekerID = @SeekerId
END
GO

-- SP_ReadCategories
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_ReadCategories]
AS
BEGIN
	SELECT CategoryID, CategoryName FROM [dbo].[Categories]
END
GO

-- SP_ReadContactUsMessages
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_ReadContactUsMessages]
AS
BEGIN
	SELECT * FROM [dbo].[Messages]
END
GO

-- SP_ReadEducationDetails
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_ReadEducationDetails]
@SeekerId INT
AS
BEGIN
	SELECT EducationID, SeekerID, University, Degree, Major, GraduationYear, GPA
	FROM [dbo].[EducationDetails]
	WHERE SeekerID = @SeekerId
END
GO

-- SP_ReadEmployer
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_ReadEmployer]
AS
BEGIN
	SELECT EmployerID, CompanyName, OfficialEmail, Email, ContactPhone, Website, Name, Designation, CompanyLogo, Status, Username
	FROM [dbo].[Employers]
END
GO

-- SP_ReadEmployerPassword
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_ReadEmployerPassword]
@EmployerId INT
AS
BEGIN
	SELECT Password FROM [dbo].[Employers] WHERE EmployerID = @EmployerId
END
GO

-- SP_ReadJobApplication
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_ReadJobApplication]
@JobId INT
AS
BEGIN
	SELECT ApplicationID, JobID, JA.SeekerID, JS.FirstName, ApplicationDate, Status
	FROM [dbo].[JobApplications] JA
	INNER JOIN [dbo].[JobSeekers] JS ON JA.SeekerID = JS.SeekerID
	WHERE JobID = @JobId
END
GO

-- SP_ReadJobApplicationSeeker
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_ReadJobApplicationSeeker]
@SeekerId INT
AS
BEGIN
	SELECT JA.ApplicationID, JA.JobID, JV.JobTitle, JA.SeekerID, JA.ApplicationDate, Status
	FROM [dbo].[JobApplications] AS JA
	INNER JOIN [dbo].[JobVacancies] AS JV ON JV.VacancyID = JA.JobID
	WHERE JA.SeekerID = @SeekerId
END
GO

-- SP_ReadJobDetails
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_ReadJobDetails]
AS
BEGIN
	SELECT 
		JV.VacancyID, JV.EmployerID, JV.JobTitle, JV.Description,
		C.CategoryName AS Category, C.CategoryID, JV.Location, JV.Salary,
		JV.EmploymentType, JV.ApplicationDeadline, JV.IsPublished,
		E.CompanyName, E.OfficialEmail, E.Email, E.ContactPhone,
		E.Website, E.Name AS EmployerName, E.Designation, E.CompanyLogo,
		(SELECT COUNT(*) FROM [dbo].[JobApplications] WHERE JobID = JV.VacancyID) AS Applications,
		(SELECT COUNT(*) FROM [dbo].[JobViews] WHERE JobID = JV.VacancyID) AS JobViews
	FROM [dbo].[JobVacancies] JV
	INNER JOIN [dbo].[Categories] C ON JV.CategoryID = C.CategoryID
	INNER JOIN [dbo].[Employers] E ON JV.EmployerID = E.EmployerID
END
GO

-- SP_ReadJobSeeker
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_ReadJobSeeker]
AS
BEGIN
	SELECT SeekerID, FirstName, LastName, Gender, Birthdate, Email, PhoneNumber, Experience, ProfilePicture, State, City, Address, Username, Resume
	FROM [dbo].[JobSeekers]
END
GO

-- SP_ReadJobSeekerPassword
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_ReadJobSeekerPassword]
@SeekerId INT
AS
BEGIN
	SELECT Password FROM [dbo].[JobSeekers] WHERE SeekerID = @SeekerId
END
GO

-- SP_ReadJobSeekerSkills
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_ReadJobSeekerSkills]
@JobSeekerId INT
AS
BEGIN
	SELECT JS.JobSeekerSkillID, S.SkillID, S.SkillName, JS.JobSeekerID
	FROM [dbo].[Skills] S
	INNER JOIN [dbo].[JobSeekerSkills] JS ON S.SkillID = JS.SkillID
	WHERE JS.JobSeekerID = @JobSeekerId
	ORDER BY S.SkillName ASC
END
GO

-- SP_ReadJobVacancy
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_ReadJobVacancy]
AS
BEGIN
	SELECT VacancyID, EmployerID, JobTitle, Description, CategoryID, Location, Salary, EmploymentType, ApplicationDeadline, IsPublished
	FROM [dbo].[JobVacancies]
END
GO

-- SP_ReadJobView
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_ReadJobView]
@JobId INT
AS
BEGIN
	SELECT ViewID, JobID, JobViews.SeekerID, JobSeekers.Username, ViewDate
	FROM [dbo].[JobViews]
	INNER JOIN [dbo].[JobSeekers] ON JobViews.SeekerID = JobSeekers.SeekerID
	WHERE JobID = @JobId
END
GO

-- SP_ReadMessage
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_ReadMessage]
@SeekerID INT,
@EmployerID INT
AS
BEGIN
	SELECT C.SeekerID, C.EmployerID, C.ChatID, CM.MessageID, CM.Message,
		CONCAT(J.FirstName, ' ', J.LastName) AS SeekerName, E.CompanyName, CM.DateAndTime, CM.Sender
	FROM [dbo].[ChatMessages] CM
	INNER JOIN [dbo].[Chats] C ON C.ChatID = CM.ChatID
	INNER JOIN [dbo].[JobSeekers] J ON C.SeekerID = J.SeekerID
	INNER JOIN [dbo].[Employers] E ON C.EmployerID = E.EmployerID
	WHERE C.SeekerID = @SeekerID AND C.EmployerID = @EmployerID
END
GO

-- SP_ReadSkills
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_ReadSkills]
AS
BEGIN
	SELECT SkillID, SkillName FROM [dbo].[Skills] ORDER BY SkillName ASC
END
GO

-- SP_UpdateCategory
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_UpdateCategory]
@CategoryID INT,
@CategoryName VARCHAR(50)
AS
BEGIN
	UPDATE [dbo].[Categories]
	SET CategoryName = @CategoryName
	WHERE CategoryID = @CategoryID
END
GO

-- SP_UpdateEducationDetail
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_UpdateEducationDetail]
@EducationID INT,
@University VARCHAR(100),
@Degree VARCHAR(50),
@Major VARCHAR(100),
@GraduationYear INT,
@GPA DECIMAL(3, 2)
AS
BEGIN
	UPDATE [dbo].[EducationDetails]
	SET University = @University, Degree = @Degree, Major = @Major, GraduationYear = @GraduationYear, GPA = @GPA
	WHERE EducationID = @EducationID
END
GO

-- SP_UpdateEmployer
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_UpdateEmployer]
@EmployerID INT,
@CompanyName VARCHAR(100),
@OfficialEmail VARCHAR(100),
@Email VARCHAR(100),
@ContactPhone VARCHAR(20),
@Website VARCHAR(100),
@Name VARCHAR(50),
@Designation VARCHAR(50),
@CompanyLogo VARBINARY(MAX) = NULL
AS
BEGIN
	UPDATE [dbo].[Employers]
	SET CompanyName = @CompanyName, OfficialEmail = @OfficialEmail, Email = @Email,
		ContactPhone = @ContactPhone, Website = @Website, Name = @Name, Designation = @Designation
	WHERE EmployerID = @EmployerID
	
	IF @CompanyLogo IS NOT NULL
	BEGIN
		UPDATE [dbo].[Employers]
		SET CompanyLogo = @CompanyLogo
		WHERE EmployerID = @EmployerID
	END
END
GO

-- SP_UpdateJobApplication
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_UpdateJobApplication]
@ApplicationID INT,
@JobID INT,
@SeekerID INT,
@ApplicationDate DATETIME2,
@Status VARCHAR(50)
AS
BEGIN
	UPDATE [dbo].[JobApplications]
	SET JobID = @JobID, SeekerID = @SeekerID, ApplicationDate = @ApplicationDate, Status = @Status
	WHERE ApplicationID = @ApplicationID
END
GO

-- SP_UpdateJobSeeker
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_UpdateJobSeeker]
@SeekerID INT,
@FirstName VARCHAR(50),
@LastName VARCHAR(50),
@Gender CHAR(1),
@Birthdate DATE,
@Email VARCHAR(100),
@PhoneNumber VARCHAR(20),
@ProfilePicture VARBINARY(MAX) = NULL,
@Experience VARCHAR(25),
@Address VARCHAR(50),
@City VARCHAR(40),
@State VARCHAR(40)
AS
BEGIN
	UPDATE [dbo].[JobSeekers]
	SET FirstName = @FirstName, LastName = @LastName, Gender = @Gender, Birthdate = @Birthdate,
		Email = @Email, PhoneNumber = @PhoneNumber, Experience = @Experience, State = @State,
		City = @City, Address = @Address
	WHERE SeekerID = @SeekerID
	
	IF @ProfilePicture IS NOT NULL
	BEGIN
		UPDATE [dbo].[JobSeekers]
		SET ProfilePicture = @ProfilePicture
		WHERE SeekerID = @SeekerID
	END
END
GO

-- SP_UpdateJobSeekerResume
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_UpdateJobSeekerResume]
@Resume VARBINARY(MAX),
@SeekerId INT
AS
BEGIN
	UPDATE [dbo].[JobSeekers] SET Resume = @Resume WHERE SeekerID = @SeekerId
END
GO

-- SP_UpdateJobVacancy
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_UpdateJobVacancy]
@VacancyID INT,
@JobTitle VARCHAR(100),
@Description TEXT,
@CategoryID INT,
@Location VARCHAR(50),
@Salary DECIMAL(10, 2),
@EmploymentType VARCHAR(50),
@ApplicationDeadline DATETIME2,
@IsPublished BIT
AS
BEGIN
	UPDATE [dbo].[JobVacancies]
	SET JobTitle = @JobTitle, Description = @Description, CategoryID = @CategoryID,
		Location = @Location, Salary = @Salary, EmploymentType = @EmploymentType,
		ApplicationDeadline = @ApplicationDeadline, IsPublished = @IsPublished
	WHERE VacancyID = @VacancyID
END
GO

-- SP_UpdateSkill
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_UpdateSkill]
@SkillID INT,
@SkillName VARCHAR(100)
AS
BEGIN
	UPDATE [dbo].[Skills]
	SET SkillName = @SkillName
	WHERE SkillID = @SkillID
END
GO

-- SP_ViewJob
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_ViewJob]
@JobID INT,
@SeekerID INT,
@ViewDate DATETIME
AS
BEGIN
	IF NOT EXISTS(SELECT 1 FROM [dbo].[JobViews] WHERE JobID = @JobID AND SeekerID = @SeekerID)
	BEGIN
		INSERT INTO [dbo].[JobViews](JobID, SeekerID, ViewDate)
		VALUES (@JobID, @SeekerID, @ViewDate)
	END
END
GO

-- ============================================================
-- SET DATABASE TO READ-WRITE
-- ============================================================
USE [master]
GO
ALTER DATABASE [JobPortal_New1] SET READ_WRITE
GO

PRINT 'Job Portal Database created successfully!'