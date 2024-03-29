USE [master]
GO

/****** Object:  Database [CSFD_ML]    Script Date: 2. 2. 2022 15:29:14 ******/
CREATE DATABASE [CSFD_ML]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'CSFD_ML', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\CSFD_ML.mdf' , SIZE = 270336KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'CSFD_ML_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\CSFD_ML_log.ldf' , SIZE = 5840896KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [CSFD_ML].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [CSFD_ML] SET ANSI_NULL_DEFAULT OFF 
GO

ALTER DATABASE [CSFD_ML] SET ANSI_NULLS OFF 
GO

ALTER DATABASE [CSFD_ML] SET ANSI_PADDING OFF 
GO

ALTER DATABASE [CSFD_ML] SET ANSI_WARNINGS OFF 
GO

ALTER DATABASE [CSFD_ML] SET ARITHABORT OFF 
GO

ALTER DATABASE [CSFD_ML] SET AUTO_CLOSE OFF 
GO

ALTER DATABASE [CSFD_ML] SET AUTO_SHRINK OFF 
GO

ALTER DATABASE [CSFD_ML] SET AUTO_UPDATE_STATISTICS ON 
GO

ALTER DATABASE [CSFD_ML] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO

ALTER DATABASE [CSFD_ML] SET CURSOR_DEFAULT  GLOBAL 
GO

ALTER DATABASE [CSFD_ML] SET CONCAT_NULL_YIELDS_NULL OFF 
GO

ALTER DATABASE [CSFD_ML] SET NUMERIC_ROUNDABORT OFF 
GO

ALTER DATABASE [CSFD_ML] SET QUOTED_IDENTIFIER OFF 
GO

ALTER DATABASE [CSFD_ML] SET RECURSIVE_TRIGGERS OFF 
GO

ALTER DATABASE [CSFD_ML] SET  DISABLE_BROKER 
GO

ALTER DATABASE [CSFD_ML] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO

ALTER DATABASE [CSFD_ML] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO

ALTER DATABASE [CSFD_ML] SET TRUSTWORTHY OFF 
GO

ALTER DATABASE [CSFD_ML] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO

ALTER DATABASE [CSFD_ML] SET PARAMETERIZATION SIMPLE 
GO

ALTER DATABASE [CSFD_ML] SET READ_COMMITTED_SNAPSHOT OFF 
GO

ALTER DATABASE [CSFD_ML] SET HONOR_BROKER_PRIORITY OFF 
GO

ALTER DATABASE [CSFD_ML] SET RECOVERY SIMPLE 
GO

ALTER DATABASE [CSFD_ML] SET  MULTI_USER 
GO

ALTER DATABASE [CSFD_ML] SET PAGE_VERIFY CHECKSUM  
GO

ALTER DATABASE [CSFD_ML] SET DB_CHAINING OFF 
GO

ALTER DATABASE [CSFD_ML] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO

ALTER DATABASE [CSFD_ML] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO

ALTER DATABASE [CSFD_ML] SET DELAYED_DURABILITY = DISABLED 
GO

ALTER DATABASE [CSFD_ML] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO

ALTER DATABASE [CSFD_ML] SET QUERY_STORE = OFF
GO

ALTER DATABASE [CSFD_ML] SET  READ_WRITE 
GO


