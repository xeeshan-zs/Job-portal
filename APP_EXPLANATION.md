# Job Portal App Explanation

This is an **ASP.NET MVC (Framework 4.7.2)** job portal connected to **SQL Server** (`JobPortal_New1`).  
It supports three main actor types:

1. **Job Seekers**: register, maintain profile/education/skills, browse jobs, apply, bookmark, and chat.
2. **Employers**: register company profile, post vacancies, manage applications, and chat with seekers.
3. **Admin**: manage categories/skills, review employer accounts, and oversee portal data.

## Core Technical Structure

- **Presentation layer**: MVC controllers + Razor views (`JobPortal\JobPortal\Controllers`, `Views`)
- **Data access layer**: repository classes in `JobPortal\JobPortal\Repository`
- **Database interaction**: SQL Server stored procedures (defined in `JobPortal_New1.sql`)
- **Authentication**: form auth (`Web.config`) with role routing (JobSeeker / Employer / Admin)
- **Password storage**: BCrypt-hashed passwords

## Main Database Entities

- `Admin`
- `Employers`
- `JobSeekers`
- `JobVacancies`
- `JobApplications`
- `EducationDetails`
- `JobSeekerSkills`
- `Categories`
- `Skills`
- `Chats`, `ChatMessages`

## Added Setup Assets

- `seed_sample_data.sql`  
  Idempotent sample seeding for admin, employers, job seekers, job postings, education, and skills mappings.

- `LOGIN_GUIDE.md`  
  Ready-to-use seeded login credentials.

- `run_jobportal.bat`  
  One-step helper script to:
  1. seed DB via `sqlcmd`
  2. launch app in IIS Express (`http://localhost:5050`)

## Quick Run

1. Ensure SQL Server is running and database `JobPortal_New1` exists.
2. Ensure `Web.config` connection string matches your SQL instance.
3. Double-click `run_jobportal.bat`.
4. Use credentials from `LOGIN_GUIDE.md`.
