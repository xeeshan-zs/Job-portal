USE [JobPortal_New1];
SET NOCOUNT ON;

DECLARE @DefaultPasswordHash NVARCHAR(100) = '$2a$11$GuWOeMKqqZ8d2uCBzuUTy.E.oPeCCHjgnwLFRyKxVHTwYj7GRgR2.';
DECLARE @TinyPng VARBINARY(MAX) = 0x89504E470D0A1A0A0000000D49484452000000010000000108060000001F15C4890000000D4944415478DA63646000000002000114AF72110000000049454E44AE426082;

BEGIN TRY
    BEGIN TRANSACTION;

    -- Admin
    IF NOT EXISTS (SELECT 1 FROM dbo.Admin WHERE Username = 'admin')
    BEGIN
        INSERT INTO dbo.Admin (Name, Username, Password, Email, PhoneNumber)
        VALUES ('Portal Administrator', 'admin', @DefaultPasswordHash, 'admin@jobportal.local', '000-000-0000');
    END;

    -- Categories used by sample jobs
    IF NOT EXISTS (SELECT 1 FROM dbo.Categories WHERE CategoryName = 'Software Development')
        INSERT INTO dbo.Categories (CategoryName) VALUES ('Software Development');
    IF NOT EXISTS (SELECT 1 FROM dbo.Categories WHERE CategoryName = 'Web Development')
        INSERT INTO dbo.Categories (CategoryName) VALUES ('Web Development');
    IF NOT EXISTS (SELECT 1 FROM dbo.Categories WHERE CategoryName = 'Testing')
        INSERT INTO dbo.Categories (CategoryName) VALUES ('Testing');
    IF NOT EXISTS (SELECT 1 FROM dbo.Categories WHERE CategoryName = 'Network & Security')
        INSERT INTO dbo.Categories (CategoryName) VALUES ('Network & Security');

    -- Skills used by sample seekers
    IF NOT EXISTS (SELECT 1 FROM dbo.Skills WHERE SkillName = 'C#')
        INSERT INTO dbo.Skills (SkillName) VALUES ('C#');
    IF NOT EXISTS (SELECT 1 FROM dbo.Skills WHERE SkillName = 'JavaScript')
        INSERT INTO dbo.Skills (SkillName) VALUES ('JavaScript');
    IF NOT EXISTS (SELECT 1 FROM dbo.Skills WHERE SkillName = 'React.js')
        INSERT INTO dbo.Skills (SkillName) VALUES ('React.js');
    IF NOT EXISTS (SELECT 1 FROM dbo.Skills WHERE SkillName = 'Software Testing')
        INSERT INTO dbo.Skills (SkillName) VALUES ('Software Testing');

    -- Employers
    IF NOT EXISTS (SELECT 1 FROM dbo.Employers WHERE Username = 'systemsltd')
    BEGIN
        INSERT INTO dbo.Employers
            (CompanyName, OfficialEmail, Email, ContactPhone, Website, Name, Designation, CompanyLogo, Username, Password, Status)
        VALUES
            ('Systems Limited', 'hr@systemsltd.com', 'systems@jobportal.local', '042-111-797-836', 'https://www.systemsltd.com', 'Adeel', 'HR Director', @TinyPng, 'systemsltd', @DefaultPasswordHash, 'Approved');
    END;

    IF NOT EXISTS (SELECT 1 FROM dbo.Employers WHERE Username = 'netsolpk')
    BEGIN
        INSERT INTO dbo.Employers
            (CompanyName, OfficialEmail, Email, ContactPhone, Website, Name, Designation, CompanyLogo, Username, Password, Status)
        VALUES
            ('NetSol Technologies', 'hr@netsolpk.com', 'netsol@jobportal.local', '042-111-448-800', 'https://www.netsol.com', 'Salim', 'HR Manager', @TinyPng, 'netsolpk', @DefaultPasswordHash, 'Approved');
    END;

    IF NOT EXISTS (SELECT 1 FROM dbo.Employers WHERE Username = 'jazzpk')
    BEGIN
        INSERT INTO dbo.Employers
            (CompanyName, OfficialEmail, Email, ContactPhone, Website, Name, Designation, CompanyLogo, Username, Password, Status)
        VALUES
            ('Jazz Pakistan', 'jobs@jazz.com.pk', 'jazz@jobportal.local', '051-111-300-300', 'https://www.jazz.com.pk', 'Aisha', 'Talent Acquisition', @TinyPng, 'jazzpk', @DefaultPasswordHash, 'Approved');
    END;

    IF NOT EXISTS (SELECT 1 FROM dbo.Employers WHERE Username = 'ublpk')
    BEGIN
        INSERT INTO dbo.Employers
            (CompanyName, OfficialEmail, Email, ContactPhone, Website, Name, Designation, CompanyLogo, Username, Password, Status)
        VALUES
            ('UBL Bank', 'careers@ubldirect.com', 'ubl@jobportal.local', '021-111-825-888', 'https://www.ubldirect.com', 'Bilal', 'Recruitment Head', @TinyPng, 'ublpk', @DefaultPasswordHash, 'Approved');
    END;

    DECLARE @CatSoftwareDev INT = (SELECT TOP 1 CategoryID FROM dbo.Categories WHERE CategoryName = 'Software Development');
    DECLARE @CatWebDev INT = (SELECT TOP 1 CategoryID FROM dbo.Categories WHERE CategoryName = 'Web Development');
    DECLARE @CatTesting INT = (SELECT TOP 1 CategoryID FROM dbo.Categories WHERE CategoryName = 'Testing');
    DECLARE @CatNetwork INT = (SELECT TOP 1 CategoryID FROM dbo.Categories WHERE CategoryName = 'Network & Security');

    DECLARE @EmpSystems INT = (SELECT TOP 1 EmployerID FROM dbo.Employers WHERE Username = 'systemsltd');
    DECLARE @EmpNetsol INT = (SELECT TOP 1 EmployerID FROM dbo.Employers WHERE Username = 'netsolpk');
    DECLARE @EmpJazz INT = (SELECT TOP 1 EmployerID FROM dbo.Employers WHERE Username = 'jazzpk');
    DECLARE @EmpUbl INT = (SELECT TOP 1 EmployerID FROM dbo.Employers WHERE Username = 'ublpk');

    -- Job postings (only employers with postings are listed in LOGIN_GUIDE.md)
    IF @EmpSystems IS NOT NULL AND @CatSoftwareDev IS NOT NULL
       AND NOT EXISTS (SELECT 1 FROM dbo.JobVacancies WHERE EmployerID = @EmpSystems AND JobTitle = '.NET Backend Developer')
    BEGIN
        INSERT INTO dbo.JobVacancies
            (EmployerID, JobTitle, Description, CategoryID, Location, Salary, EmploymentType, ApplicationDeadline, IsPublished)
        VALUES
            (@EmpSystems, '.NET Backend Developer', 'Build and maintain ASP.NET MVC APIs and services.', @CatSoftwareDev, 'Lahore', 180000.00, 'Full Time', DATEADD(DAY, 30, GETDATE()), 1);
    END;

    IF @EmpSystems IS NOT NULL AND @CatWebDev IS NOT NULL
       AND NOT EXISTS (SELECT 1 FROM dbo.JobVacancies WHERE EmployerID = @EmpSystems AND JobTitle = 'React Frontend Developer')
    BEGIN
        INSERT INTO dbo.JobVacancies
            (EmployerID, JobTitle, Description, CategoryID, Location, Salary, EmploymentType, ApplicationDeadline, IsPublished)
        VALUES
            (@EmpSystems, 'React Frontend Developer', 'Develop user interfaces for enterprise web applications.', @CatWebDev, 'Karachi', 150000.00, 'Full Time', DATEADD(DAY, 30, GETDATE()), 1);
    END;

    IF @EmpNetsol IS NOT NULL AND @CatTesting IS NOT NULL
       AND NOT EXISTS (SELECT 1 FROM dbo.JobVacancies WHERE EmployerID = @EmpNetsol AND JobTitle = 'QA Engineer')
    BEGIN
        INSERT INTO dbo.JobVacancies
            (EmployerID, JobTitle, Description, CategoryID, Location, Salary, EmploymentType, ApplicationDeadline, IsPublished)
        VALUES
            (@EmpNetsol, 'QA Engineer', 'Plan and execute manual plus automation testing for web apps.', @CatTesting, 'Lahore', 120000.00, 'Full Time', DATEADD(DAY, 30, GETDATE()), 1);
    END;

    IF @EmpJazz IS NOT NULL AND @CatNetwork IS NOT NULL
       AND NOT EXISTS (SELECT 1 FROM dbo.JobVacancies WHERE EmployerID = @EmpJazz AND JobTitle = 'Network Security Engineer')
    BEGIN
        INSERT INTO dbo.JobVacancies
            (EmployerID, JobTitle, Description, CategoryID, Location, Salary, EmploymentType, ApplicationDeadline, IsPublished)
        VALUES
            (@EmpJazz, 'Network Security Engineer', 'Manage network security controls, VPN and firewall operations.', @CatNetwork, 'Islamabad', 200000.00, 'Full Time', DATEADD(DAY, 30, GETDATE()), 1);
    END;

    IF @EmpUbl IS NOT NULL AND @CatSoftwareDev IS NOT NULL
       AND NOT EXISTS (SELECT 1 FROM dbo.JobVacancies WHERE EmployerID = @EmpUbl AND JobTitle = 'Full Stack Engineer')
    BEGIN
        INSERT INTO dbo.JobVacancies
            (EmployerID, JobTitle, Description, CategoryID, Location, Salary, EmploymentType, ApplicationDeadline, IsPublished)
        VALUES
            (@EmpUbl, 'Full Stack Engineer', 'Build and support digital banking features across frontend and backend.', @CatSoftwareDev, 'Karachi', 220000.00, 'Full Time', DATEADD(DAY, 30, GETDATE()), 1);
    END;

    -- Job Seekers
    IF NOT EXISTS (SELECT 1 FROM dbo.JobSeekers WHERE Username = 'alikhan')
    BEGIN
        INSERT INTO dbo.JobSeekers
            (FirstName, LastName, Gender, Birthdate, Email, PhoneNumber, Password, Resume, Experience, ProfilePicture, Address, City, State, Username)
        VALUES
            ('Ali', 'Khan', 'M', '1998-05-10', 'alikhan@jobportal.local', '0300-1234567', @DefaultPasswordHash, @TinyPng, '3', @TinyPng, 'DHA Phase 5', 'Lahore', 'Punjab', 'alikhan');
    END;

    IF NOT EXISTS (SELECT 1 FROM dbo.JobSeekers WHERE Username = 'fatimabibi')
    BEGIN
        INSERT INTO dbo.JobSeekers
            (FirstName, LastName, Gender, Birthdate, Email, PhoneNumber, Password, Resume, Experience, ProfilePicture, Address, City, State, Username)
        VALUES
            ('Fatima', 'Bibi', 'F', '1999-08-22', 'fatimabibi@jobportal.local', '0312-7654321', @DefaultPasswordHash, @TinyPng, '2', @TinyPng, 'Gulshan-e-Iqbal', 'Karachi', 'Sindh', 'fatimabibi');
    END;

    IF NOT EXISTS (SELECT 1 FROM dbo.JobSeekers WHERE Username = 'ahmedraza')
    BEGIN
        INSERT INTO dbo.JobSeekers
            (FirstName, LastName, Gender, Birthdate, Email, PhoneNumber, Password, Resume, Experience, ProfilePicture, Address, City, State, Username)
        VALUES
            ('Ahmed', 'Raza', 'M', '1996-03-15', 'ahmedraza@jobportal.local', '0321-4567890', @DefaultPasswordHash, @TinyPng, '5', @TinyPng, 'Sector F-7', 'Islamabad', 'Federal', 'ahmedraza');
    END;

    DECLARE @SeekerAli INT = (SELECT TOP 1 SeekerID FROM dbo.JobSeekers WHERE Username = 'alikhan');
    DECLARE @SeekerFatima INT = (SELECT TOP 1 SeekerID FROM dbo.JobSeekers WHERE Username = 'fatimabibi');
    DECLARE @SeekerAhmed INT = (SELECT TOP 1 SeekerID FROM dbo.JobSeekers WHERE Username = 'ahmedraza');

    IF @SeekerAli IS NOT NULL
       AND NOT EXISTS (SELECT 1 FROM dbo.EducationDetails WHERE SeekerID = @SeekerAli AND University = 'FAST NUCES')
    BEGIN
        INSERT INTO dbo.EducationDetails (SeekerID, University, Degree, Major, GraduationYear, GPA)
        VALUES (@SeekerAli, 'FAST NUCES', 'BS', 'Computer Science', 2020, 3.40);
    END;

    IF @SeekerFatima IS NOT NULL
       AND NOT EXISTS (SELECT 1 FROM dbo.EducationDetails WHERE SeekerID = @SeekerFatima AND University = 'NED University')
    BEGIN
        INSERT INTO dbo.EducationDetails (SeekerID, University, Degree, Major, GraduationYear, GPA)
        VALUES (@SeekerFatima, 'NED University', 'BE', 'Software Engineering', 2021, 3.60);
    END;

    IF @SeekerAhmed IS NOT NULL
       AND NOT EXISTS (SELECT 1 FROM dbo.EducationDetails WHERE SeekerID = @SeekerAhmed AND University = 'NUST')
    BEGIN
        INSERT INTO dbo.EducationDetails (SeekerID, University, Degree, Major, GraduationYear, GPA)
        VALUES (@SeekerAhmed, 'NUST', 'MS', 'Information Technology', 2018, 3.80);
    END;

    DECLARE @SkillCSharp INT = (SELECT TOP 1 SkillID FROM dbo.Skills WHERE SkillName = 'C#');
    DECLARE @SkillJs INT = (SELECT TOP 1 SkillID FROM dbo.Skills WHERE SkillName = 'JavaScript');
    DECLARE @SkillReact INT = (SELECT TOP 1 SkillID FROM dbo.Skills WHERE SkillName = 'React.js');
    DECLARE @SkillTesting INT = (SELECT TOP 1 SkillID FROM dbo.Skills WHERE SkillName = 'Software Testing');

    IF @SeekerAli IS NOT NULL AND @SkillCSharp IS NOT NULL
       AND NOT EXISTS (SELECT 1 FROM dbo.JobSeekerSkills WHERE JobSeekerID = @SeekerAli AND SkillID = @SkillCSharp)
        INSERT INTO dbo.JobSeekerSkills (JobSeekerID, SkillID) VALUES (@SeekerAli, @SkillCSharp);

    IF @SeekerAli IS NOT NULL AND @SkillJs IS NOT NULL
       AND NOT EXISTS (SELECT 1 FROM dbo.JobSeekerSkills WHERE JobSeekerID = @SeekerAli AND SkillID = @SkillJs)
        INSERT INTO dbo.JobSeekerSkills (JobSeekerID, SkillID) VALUES (@SeekerAli, @SkillJs);

    IF @SeekerFatima IS NOT NULL AND @SkillReact IS NOT NULL
       AND NOT EXISTS (SELECT 1 FROM dbo.JobSeekerSkills WHERE JobSeekerID = @SeekerFatima AND SkillID = @SkillReact)
        INSERT INTO dbo.JobSeekerSkills (JobSeekerID, SkillID) VALUES (@SeekerFatima, @SkillReact);

    IF @SeekerAhmed IS NOT NULL AND @SkillTesting IS NOT NULL
       AND NOT EXISTS (SELECT 1 FROM dbo.JobSeekerSkills WHERE JobSeekerID = @SeekerAhmed AND SkillID = @SkillTesting)
        INSERT INTO dbo.JobSeekerSkills (JobSeekerID, SkillID) VALUES (@SeekerAhmed, @SkillTesting);

    COMMIT TRANSACTION;
    PRINT 'Sample seeding completed successfully.';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
    DECLARE @ErrorState INT = ERROR_STATE();
    RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH;
