USE [JobPortal_New1]
GO

-- 1. CLEAN UP JOB SEEKER DATA AS REQUESTED
PRINT 'Cleaning old JobSeeker data...'
DELETE FROM dbo.ChatMessages;
DELETE FROM dbo.Chats;
DELETE FROM dbo.Bookmarks;
DELETE FROM dbo.JobApplications;
DELETE FROM dbo.JobViews;
DELETE FROM dbo.JobSeekerSkills;
DELETE FROM dbo.EducationDetails;
DELETE FROM dbo.JobSeekers;
GO

-- 2. SEED PAKISTANI COMPANIES (EMPLOYERS)
PRINT 'Seeding Pakistani Companies...'
DECLARE @logo VARBINARY(MAX);
SELECT TOP 1 @logo = CompanyLogo FROM dbo.Employers WHERE EmployerID = 5;
IF @logo IS NULL
    SELECT TOP 1 @logo = CompanyLogo FROM dbo.Employers;
IF @logo IS NULL
    SET @logo = 0x89504E470D0A1A0A0000000D49484452000000010000000108060000001F15C4890000000D4944415478DA63646000000002000114AF72110000000049454E44AE426082;

-- Insert Pakistani Companies (Password: Pak@123)
INSERT INTO [dbo].[Employers] (CompanyName, OfficialEmail, Email, ContactPhone, Website, Name, Designation, CompanyLogo, Username, Password, Status)
VALUES
('Systems Limited', 'hr@systemsltd.com', 'systems@pakistan.com', '042-111-797-836', 'www.systemsltd.com', 'Adeel', 'HR Director', @logo, 'systemsltd', '$2a$11$GuWOeMKqqZ8d2uCBzuUTy.E.oPeCCHjgnwLFRyKxVHTwYj7GRgR2.', 'Approved'),
('NetSol Technologies', 'hr@netsolpk.com', 'netsol@pakistan.com', '042-111-44-88-00', 'www.netsol.com', 'Salim', 'HR Manager', @logo, 'netsolpk', '$2a$11$GuWOeMKqqZ8d2uCBzuUTy.E.oPeCCHjgnwLFRyKxVHTwYj7GRgR2.', 'Approved'),
('Jazz Pakistan', 'jobs@jazz.com.pk', 'jazz@pakistan.com', '051-111-300-300', 'www.jazz.com.pk', 'Aisha', 'Talent Acquisition', @logo, 'jazzpk', '$2a$11$GuWOeMKqqZ8d2uCBzuUTy.E.oPeCCHjgnwLFRyKxVHTwYj7GRgR2.', 'Approved'),
('UBL Bank', 'careers@ubldirect.com', 'ubl@pakistan.com', '021-111-825-888', 'www.ubldirect.com', 'Bilal', 'Recruitment Head', @logo, 'ublpk', '$2a$11$GuWOeMKqqZ8d2uCBzuUTy.E.oPeCCHjgnwLFRyKxVHTwYj7GRgR2.', 'Approved');
GO

-- 3. SEED PAKISTANI JOBS (JOB VACANCIES)
PRINT 'Seeding Pakistani Jobs...'
DECLARE @emp1 INT, @emp2 INT, @emp3 INT, @emp4 INT;
SELECT @emp1 = EmployerID FROM dbo.Employers WHERE CompanyName = 'Systems Limited';
SELECT @emp2 = EmployerID FROM dbo.Employers WHERE CompanyName = 'NetSol Technologies';
SELECT @emp3 = EmployerID FROM dbo.Employers WHERE CompanyName = 'Jazz Pakistan';
SELECT @emp4 = EmployerID FROM dbo.Employers WHERE CompanyName = 'UBL Bank';

-- Insert Jobs
-- Category IDs: 2=Software Dev, 3=Web Dev, 7=Network Admin, 9=Testing, 12=Full stack
INSERT INTO [dbo].[JobVacancies] (EmployerID, JobTitle, Description, CategoryID, Location, Salary, EmploymentType, ApplicationDeadline, IsPublished)
VALUES
(@emp1, '.NET Core Senior Developer', 'Looking for highly skilled C# .NET Core developers with 5 years of experience.', 2, 'Lahore', 180000.00, 'Full Time', DATEADD(day, 30, GETDATE()), 1),
(@emp1, 'React Web Developer', 'Join our dynamic frontend team building enterprise React apps.', 3, 'Karachi', 150000.00, 'Full Time', DATEADD(day, 30, GETDATE()), 1),
(@emp2, 'Senior QA Engineer', 'Responsible for manual and automated web application testing.', 9, 'Lahore', 120000.00, 'Full Time', DATEADD(day, 30, GETDATE()), 1),
(@emp3, 'Network Security Engineer', 'Manage corporate firewall, VPN, and core network routing.', 7, 'Islamabad', 200000.00, 'Full Time', DATEADD(day, 30, GETDATE()), 1),
(@emp4, 'Full Stack Engineer', 'Help digitize our retail banking platform with React and Java.', 12, 'Karachi', 220000.00, 'Full Time', DATEADD(day, 30, GETDATE()), 1);
GO

-- 4. SEED PAKISTANI JOB SEEKERS (Password: Pak@123)
PRINT 'Seeding Pakistani Job Seekers...'
DECLARE @img VARBINARY(MAX) = 0x89504E470D0A1A0A0000000D49484452000000010000000108060000001F15C4890000000D4944415478DA63646000000002000114AF72110000000049454E44AE426082;

INSERT INTO [dbo].[JobSeekers] (FirstName, LastName, Gender, Birthdate, Email, PhoneNumber, Password, Resume, Experience, ProfilePicture, Address, City, State, Username)
VALUES
('Ali', 'Khan', 'M', '1998-05-10', 'alikhan@email.com', '0300-1234567', '$2a$11$GuWOeMKqqZ8d2uCBzuUTy.E.oPeCCHjgnwLFRyKxVHTwYj7GRgR2.', @img, '3', @img, 'DHA Phase 5', 'Lahore', 'Punjab', 'alikhan'),
('Fatima', 'Bibi', 'F', '1999-08-22', 'fatimabibi@email.com', '0312-7654321', '$2a$11$GuWOeMKqqZ8d2uCBzuUTy.E.oPeCCHjgnwLFRyKxVHTwYj7GRgR2.', @img, '2', @img, 'Gulshan-e-Iqbal', 'Karachi', 'Sindh', 'fatimabibi'),
('Ahmed', 'Raza', 'M', '1996-03-15', 'ahmedraza@email.com', '0321-4567890', '$2a$11$GuWOeMKqqZ8d2uCBzuUTy.E.oPeCCHjgnwLFRyKxVHTwYj7GRgR2.', @img, '5', @img, 'Sector F-7', 'Islamabad', 'Federal', 'ahmedraza'),
('Sara', 'Ahmed', 'F', '2000-11-02', 'saraahmed@email.com', '0333-9876543', '$2a$11$GuWOeMKqqZ8d2uCBzuUTy.E.oPeCCHjgnwLFRyKxVHTwYj7GRgR2.', @img, '1', @img, 'Johar Town', 'Lahore', 'Punjab', 'saraahmed'),
('Zeeshan', 'Malik', 'M', '1997-12-25', 'zeeshanmalik@email.com', '0345-6543210', '$2a$11$GuWOeMKqqZ8d2uCBzuUTy.E.oPeCCHjgnwLFRyKxVHTwYj7GRgR2.', @img, '4', @img, 'Peshawar Road', 'Rawalpindi', 'Punjab', 'zeeshanmalik');
GO

-- 5. SEED EDUCATION DETAILS & SKILLS FOR JOB SEEKERS
PRINT 'Mapping Seekers with Education and Skills...'
DECLARE @sid1 INT, @sid2 INT, @sid3 INT, @sid4 INT, @sid5 INT;
SELECT @sid1 = SeekerID FROM dbo.JobSeekers WHERE Username = 'alikhan';
SELECT @sid2 = SeekerID FROM dbo.JobSeekers WHERE Username = 'fatimabibi';
SELECT @sid3 = SeekerID FROM dbo.JobSeekers WHERE Username = 'ahmedraza';
SELECT @sid4 = SeekerID FROM dbo.JobSeekers WHERE Username = 'saraahmed';
SELECT @sid5 = SeekerID FROM dbo.JobSeekers WHERE Username = 'zeeshanmalik';

INSERT INTO [dbo].[EducationDetails] (SeekerID, University, Degree, Major, GraduationYear, GPA)
VALUES
(@sid1, 'FAST NUCES', 'BS', 'Computer Science', 2020, 3.4),
(@sid2, 'NED University', 'BE', 'Software Engineering', 2021, 3.6),
(@sid3, 'NUST', 'MS', 'Information Technology', 2018, 3.8),
(@sid4, 'Punjab University', 'BS', 'Information Technology', 2022, 3.2),
(@sid5, 'COMSATS', 'BS', 'Computer Engineering', 2019, 3.5);

-- Skills mapping: 1=C++, 2=C#, 11=Cybersecurity, 17=DevOps, 18=Software Testing, 20=Network Admin, 27=React.js, 35=JavaScript
INSERT INTO [dbo].[JobSeekerSkills] (JobSeekerID, SkillID)
VALUES
(@sid1, 2), -- C#
(@sid1, 35), -- JavaScript
(@sid2, 27), -- React.js
(@sid2, 35), -- JavaScript
(@sid3, 20), -- Network Admin
(@sid3, 11), -- Cybersecurity
(@sid4, 18), -- Software Testing
(@sid5, 2), -- C#
(@sid5, 17); -- DevOps
GO

PRINT 'Seeding successfully completed!'
GO
