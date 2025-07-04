/*************************************************************************************************
*
* Project: Phân Tích Dữ Liệu Phim Điện Ảnh từ nguồn IMDb và TMDb
* Author: Nguyễn Hồng Phát
* Student ID: 22521072
* Class: IS217.P12
*
* Description:
* This script creates the 'Movie_wh' data warehouse. It drops existing objects first
* to ensure it is re-runnable, then creates all tables and constraints.
*
*************************************************************************************************/

-- =========================================================================================
-- 1. CREATE AND USE THE DATABASE
-- =========================================================================================
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'Movie_wh')
CREATE DATABASE Movie_wh;
GO

USE Movie_wh;
GO

-- =========================================================================================
-- 2. DROP EXISTING OBJECTS
-- Dropping objects in reverse order of dependency to avoid errors.
-- Foreign keys are dropped implicitly when the table is dropped.
-- =========================================================================================
IF OBJECT_ID('dbo.Fact_Movie', 'U') IS NOT NULL
    DROP TABLE dbo.Fact_Movie;
IF OBJECT_ID('dbo.Fact_Raw', 'U') IS NOT NULL
    DROP TABLE dbo.Fact_Raw;
IF OBJECT_ID('dbo.Dim_Date', 'U') IS NOT NULL
    DROP TABLE dbo.Dim_Date;
IF OBJECT_ID('dbo.Dim_Language', 'U') IS NOT NULL
    DROP TABLE dbo.Dim_Language;
IF OBJECT_ID('dbo.Dim_Genres_List', 'U') IS NOT NULL
    DROP TABLE dbo.Dim_Genres_List;
IF OBJECT_ID('dbo.Dim_Movie', 'U') IS NOT NULL
    DROP TABLE dbo.Dim_Movie;
IF OBJECT_ID('dbo.Dim_Country', 'U') IS NOT NULL
    DROP TABLE dbo.Dim_Country;
IF OBJECT_ID('dbo.Dim_Director', 'U') IS NOT NULL
    DROP TABLE dbo.Dim_Director;
IF OBJECT_ID('dbo.Dim_Company', 'U') IS NOT NULL
    DROP TABLE dbo.Dim_Company;
GO

-- =========================================================================================
-- 3. CREATE DIMENSION TABLES
-- =========================================================================================

CREATE TABLE [Dim_Date] (
    [release_date] datetime constraint PK_Date primary key,
    [Day] int,
    [Month] int,
    [Year] int
);
GO

CREATE TABLE [Dim_Language] (
    [language_id] int identity(1,1) constraint PK_Language primary key,
    [original_language] varchar(2),
    [spoken_languages] varchar(87)
);
GO

CREATE TABLE [Dim_Genres_List] (
    [genres_list_id] int identity(1,1) constraint PK_Genres_List primary key,
    [genres_list] varchar(106)
);
GO

CREATE TABLE [Dim_Movie] (
    [movie_id] int identity(1,1) constraint PK_Movie primary key,
    [title] varchar(156),
    [status] varchar(15),
    [imdb_id] varchar(10)
);
GO

CREATE TABLE [Dim_Country] (
    [country_id] int identity(1,1) constraint PK_Country primary key,
    [production_countries] varchar(90)
);
GO

CREATE TABLE [Dim_Director] (
    [director_id] int identity(1,1) constraint PK_Director primary key,
    [Director] varchar(163)
);
GO

CREATE TABLE [Dim_Company] (
    [company_id] int identity(1,1) constraint PK_Company primary key,
    [production_companies] varchar(258)
);
GO

-- =========================================================================================
-- 4. CREATE STAGING AND FACT TABLES
-- =========================================================================================

CREATE TABLE [Fact_Raw] (
    [Fact_id] int constraint PK_Fact_Raw primary key,
    [release_date] datetime,
    [title] varchar(156),
    [vote_average] real,
    [vote_count] smallint,
    [status] varchar(15),
    [revenue] int,
    [runtime] smallint,
    [budget] int,
    [imdb_id] varchar(10),
    [original_language] varchar(2),
    [popularity] real,
    [production_companies] varchar(258),
    [production_countries] varchar(90),
    [spoken_languages] varchar(87),
    [Director] varchar(163),
    [genres_list] varchar(106)
);
GO

CREATE TABLE [Fact_Movie] (
    [Fact_id] int constraint PK_Fact_Movie primary key,
    [release_date] datetime,
    [language_id] int,
    [genres_list_id] int,
    [movie_id] int,
    [country_id] int,
    [director_id] int,
    [company_id] int,
    [vote_average] real,
    [vote_count] smallint,
    [revenue] int,
    [runtime] smallint,
    [budget] int,
    [popularity] real
);
GO

-- =========================================================================================
-- 5. ADD FOREIGN KEY CONSTRAINTS TO FACT_MOVIE
-- =========================================================================================
ALTER TABLE Fact_Movie ADD CONSTRAINT FK_Fact_Movie_Dim_Date FOREIGN KEY (release_date) REFERENCES Dim_Date(release_date);
ALTER TABLE Fact_Movie ADD CONSTRAINT FK_Fact_Movie_Dim_Language FOREIGN KEY (language_id) REFERENCES Dim_Language(language_id);
ALTER TABLE Fact_Movie ADD CONSTRAINT FK_Fact_Movie_Dim_Genres_List FOREIGN KEY (genres_list_id) REFERENCES Dim_Genres_List(genres_list_id);
ALTER TABLE Fact_Movie ADD CONSTRAINT FK_Fact_Movie_Dim_Movie FOREIGN KEY (movie_id) REFERENCES Dim_Movie(movie_id);
ALTER TABLE Fact_Movie ADD CONSTRAINT FK_Fact_Movie_Dim_Country FOREIGN KEY (country_id) REFERENCES Dim_Country(country_id);
ALTER TABLE Fact_Movie ADD CONSTRAINT FK_Fact_Movie_Dim_Director FOREIGN KEY (director_id) REFERENCES Dim_Director(director_id);
ALTER TABLE Fact_Movie ADD CONSTRAINT FK_Fact_Movie_Dim_Company FOREIGN KEY (company_id) REFERENCES Dim_Company(company_id);
GO