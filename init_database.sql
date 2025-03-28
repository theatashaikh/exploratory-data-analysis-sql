USE [master]
GO
/****** Object:  Database [datawarehousesql]    Script Date: 26/03/2025 16:56:23 ******/
CREATE DATABASE [datawarehousesql]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'datawarehousesql', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\datawarehousesql.mdf' , SIZE = 335872KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'datawarehousesql_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\datawarehousesql_log.ldf' , SIZE = 598016KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [datawarehousesql] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [datawarehousesql].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [datawarehousesql] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [datawarehousesql] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [datawarehousesql] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [datawarehousesql] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [datawarehousesql] SET ARITHABORT OFF 
GO
ALTER DATABASE [datawarehousesql] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [datawarehousesql] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [datawarehousesql] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [datawarehousesql] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [datawarehousesql] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [datawarehousesql] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [datawarehousesql] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [datawarehousesql] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [datawarehousesql] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [datawarehousesql] SET  ENABLE_BROKER 
GO
ALTER DATABASE [datawarehousesql] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [datawarehousesql] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [datawarehousesql] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [datawarehousesql] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [datawarehousesql] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [datawarehousesql] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [datawarehousesql] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [datawarehousesql] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [datawarehousesql] SET  MULTI_USER 
GO
ALTER DATABASE [datawarehousesql] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [datawarehousesql] SET DB_CHAINING OFF 
GO
ALTER DATABASE [datawarehousesql] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [datawarehousesql] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [datawarehousesql] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [datawarehousesql] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [datawarehousesql] SET QUERY_STORE = ON
GO
ALTER DATABASE [datawarehousesql] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [datawarehousesql]
GO
/****** Object:  Schema [bronze]    Script Date: 26/03/2025 16:56:23 ******/
CREATE SCHEMA [bronze]
GO
/****** Object:  Schema [gold]    Script Date: 26/03/2025 16:56:23 ******/
CREATE SCHEMA [gold]
GO
/****** Object:  Schema [silver]    Script Date: 26/03/2025 16:56:23 ******/
CREATE SCHEMA [silver]
GO
/****** Object:  Table [silver].[crm_customers]    Script Date: 26/03/2025 16:56:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [silver].[crm_customers](
	[cust_id] [nvarchar](50) NOT NULL,
	[cust_fname] [nvarchar](50) NULL,
	[cust_lname] [nvarchar](50) NULL,
	[gender] [nvarchar](10) NULL,
	[email] [nvarchar](50) NULL,
	[city] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  View [gold].[dim_customers]    Script Date: 26/03/2025 16:56:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [gold].[dim_customers] AS
SELECT
	ROW_NUMBER() OVER(ORDER BY CUST_ID) AS customer_key, -- surrogate key
	cust_id AS customer_id,
	cust_fname AS customer_first_name,
	cust_lname AS customer_last_name,
	gender,
	email,
	city

FROM silver.crm_customers;
GO
/****** Object:  Table [silver].[crm_orders_2023]    Script Date: 26/03/2025 16:56:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [silver].[crm_orders_2023](
	[ord_id] [nvarchar](50) NOT NULL,
	[cust_id] [nvarchar](50) NOT NULL,
	[prd_id] [nvarchar](50) NOT NULL,
	[qty] [int] NULL,
	[order_date] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [silver].[crm_orders_latest]    Script Date: 26/03/2025 16:56:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [silver].[crm_orders_latest](
	[ord_id] [nvarchar](50) NOT NULL,
	[cust_id] [nvarchar](50) NOT NULL,
	[prd_id] [nvarchar](50) NOT NULL,
	[qty] [int] NULL,
	[order_date] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [silver].[erp_products]    Script Date: 26/03/2025 16:56:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [silver].[erp_products](
	[prd_id] [nvarchar](50) NOT NULL,
	[prd_name] [nvarchar](50) NULL,
	[cat_id] [nvarchar](50) NOT NULL,
	[price] [int] NULL,
	[cost] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  View [gold].[fact_orders]    Script Date: 26/03/2025 16:56:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [gold].[fact_orders] AS
SELECT
	o.order_id,
	o.customer_id,
	o.product_id,
	p.prd_name AS product_name,
	p.price,
	o.quantity,
	p.price * o.quantity AS total,
	o.order_date
FROM (SELECT 
	ord_id AS order_id,
	cust_id AS customer_id,
	prd_id AS product_id,
	qty AS quantity,
	order_date
FROM silver.crm_orders_2023

UNION ALL

SELECT 
	ord_id AS order_id,
	cust_id AS customer_id,
	prd_id AS product_id,
	qty AS quantity,
	order_date
FROM silver.crm_orders_latest) o
INNER JOIN silver.erp_products p
	ON o.product_id = p.prd_id;
GO
/****** Object:  View [gold].[dim_products]    Script Date: 26/03/2025 16:56:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [gold].[dim_products] AS
SELECT
	ROW_NUMBER() OVER(ORDER BY prd_id) AS product_key,
	prd_id AS product_id,
	prd_name AS product_name,
	cat_id AS category_id,
	price,
	cost
FROM silver.erp_products;
GO
/****** Object:  Table [silver].[erp_categories]    Script Date: 26/03/2025 16:56:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [silver].[erp_categories](
	[cat_id] [nvarchar](50) NOT NULL,
	[cat_name] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  View [gold].[dim_categories]    Script Date: 26/03/2025 16:56:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [gold].[dim_categories] AS
SELECT 
	ROW_NUMBER() OVER(ORDER BY cat_id) AS category_key,
	cat_id AS category_id,
	cat_name AS category_name
FROM silver.erp_categories;
GO
/****** Object:  Table [bronze].[crm_customers]    Script Date: 26/03/2025 16:56:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bronze].[crm_customers](
	[cust_id] [nvarchar](50) NOT NULL,
	[cust_fname] [nvarchar](50) NULL,
	[cust_lname] [nvarchar](50) NULL,
	[gender] [nvarchar](10) NULL,
	[email] [nvarchar](50) NULL,
	[city] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [bronze].[crm_orders_2023]    Script Date: 26/03/2025 16:56:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bronze].[crm_orders_2023](
	[ord_id] [nvarchar](50) NOT NULL,
	[cust_id] [nvarchar](50) NOT NULL,
	[prd_id] [nvarchar](50) NOT NULL,
	[qty] [int] NULL,
	[order_date] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [bronze].[crm_orders_latest]    Script Date: 26/03/2025 16:56:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bronze].[crm_orders_latest](
	[ord_id] [nvarchar](50) NOT NULL,
	[cust_id] [nvarchar](50) NOT NULL,
	[prd_id] [nvarchar](50) NOT NULL,
	[qty] [int] NULL,
	[order_date] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [bronze].[erp_categories]    Script Date: 26/03/2025 16:56:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bronze].[erp_categories](
	[cat_id] [nvarchar](50) NOT NULL,
	[cat_name] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [bronze].[erp_products]    Script Date: 26/03/2025 16:56:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bronze].[erp_products](
	[prd_id] [nvarchar](50) NOT NULL,
	[prd_name] [nvarchar](50) NULL,
	[cat_id] [nvarchar](50) NOT NULL,
	[price] [int] NULL,
	[cost] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [bronze].[load_bronze]    Script Date: 26/03/2025 16:56:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- EXEC bronze.load_bronze;

CREATE   PROCEDURE [bronze].[load_bronze] AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_end_time = GETDATE();
		PRINT '==============================================='
		PRINT 'LOADING BRONZE LAYER'
		PRINT '==============================================='

		PRINT '-----------------------------------------------'
		PRINT 'LOADING CRM TABLES'
		PRINT '-----------------------------------------------'
		
		PRINT '>>> TRUNCATING TABLE: crm_customers'
		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.crm_customers;

		PRINT '>>> INSERTING DATA INTO: crm_customers'
		BULK INSERT bronze.crm_customers
		FROM 'C:\Users\atash\Downloads\data-engineering\royalwoool\datasets\crm\customers.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_time = GETDATE();
		PRINT 'Duration: '+ CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) +' seconds.'

		PRINT '-----------------------------------------------'

		PRINT '>>> TRUNCATING TABLE: crm_orders_2023'

		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.crm_orders_2023;

		PRINT '>>> INSERTING DATA INTO: crm_orders_2023'
		BULK INSERT bronze.crm_orders_2023
		FROM 'C:\Users\atash\Downloads\data-engineering\royalwoool\datasets\crm\orders_2023.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_time = GETDATE();
		PRINT 'Duration: '+ CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) +' seconds.'

		PRINT '-----------------------------------------------'

		PRINT '>>> TRUNCATING TABLE: crm_orders_latest'

		SET @start_time = GETDATE();

		TRUNCATE TABLE bronze.crm_orders_latest;

		PRINT '>>> INSERTING DATA INTO: crm_orders_latest'
		BULK INSERT bronze.crm_orders_latest
		FROM 'C:\Users\atash\Downloads\data-engineering\royalwoool\datasets\crm\orders_latest.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_time = GETDATE();
		PRINT 'Duration: '+ CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) +' seconds.'

		PRINT '-----------------------------------------------'
		PRINT 'LOADING ERP TABLES'
		PRINT '-----------------------------------------------'

		PRINT '>>> TRUNCATING TABLE: erp_products'

		SET @start_time = GETDATE();

		TRUNCATE TABLE bronze.erp_products;

		PRINT '>>> INSERTING DATA INTO: erp_products'
		BULK INSERT bronze.erp_products
		FROM 'C:\Users\atash\Downloads\data-engineering\royalwoool\datasets\erp\products.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_time = GETDATE();
		PRINT 'Duration: '+ CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) +' seconds.'

		PRINT '-----------------------------------------------'

		PRINT '>>> TRUNCATING TABLE: erp_categories'

		SET @start_time = GETDATE();

		TRUNCATE TABLE bronze.erp_categories;

		PRINT '>>> INSERTING DATA INTO: erp_categories'
		BULK INSERT bronze.erp_categories
		FROM 'C:\Users\atash\Downloads\data-engineering\royalwoool\datasets\erp\categories.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Duration: '+ CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) +' seconds.'
		PRINT '-------------------------------------------------'
		SET @batch_end_time = GETDATE();
		PRINT 'Total duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds.';
	END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END

-- SELECT TOP(10) * FROM bronze.crm_customers;
GO
/****** Object:  StoredProcedure [silver].[load_silver]    Script Date: 26/03/2025 16:56:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure transforms data from the 'bronze' schema into the 'silver' schema.
    It performs the following transformations:
    - Standardizes customer data (names to uppercase, gender normalized, emails to lowercase)
    - Reformats date fields from DD/MM/YYYY to YYYY-MM-DD format
    - Trims and standardizes product and category names
    - Cleans category IDs by removing leading zeros

Parameters:
    None. 
    This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC silver.load_silver;
===============================================================================
*/

CREATE   PROCEDURE [silver].[load_silver] AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '==============================================='
        PRINT 'LOADING SILVER LAYER'
        PRINT '==============================================='

        PRINT '-----------------------------------------------'
        PRINT 'TRANSFORMING CRM TABLES'
        PRINT '-----------------------------------------------'
        
        PRINT '>>> TRUNCATING TABLE: silver.crm_customers'
        SET @start_time = GETDATE();
        TRUNCATE TABLE silver.crm_customers;

        PRINT '>>> INSERTING DATA INTO: silver.crm_customers'
        INSERT INTO silver.crm_customers(
            cust_id,
            cust_fname,
            cust_lname,
            gender,
            email,
            city
        )
        SELECT
            cust_id,
            UPPER(cust_fname) cust_fname,
            UPPER(cust_lname) cust_lname,
            TRIM(LOWER(COALESCE(CASE TRIM(LOWER(gender))
                WHEN 'F' THEN 'female'
                WHEN 'M' THEN 'male'
                ELSE gender
            END, 'unknown'))) as gender,
            LOWER(email) email,
            LOWER(TRIM(COALESCE(city, 'unknown'))) city
        FROM bronze.crm_customers;

        SET @end_time = GETDATE();
        PRINT 'Duration: '+ CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) +' seconds.'

        PRINT '-----------------------------------------------'

        PRINT '>>> TRUNCATING TABLE: silver.crm_orders_2023'
        SET @start_time = GETDATE();
        TRUNCATE TABLE silver.crm_orders_2023;

        PRINT '>>> INSERTING DATA INTO: silver.crm_orders_2023'
        INSERT INTO silver.crm_orders_2023(
            ord_id,
            cust_id,
            prd_id,
            qty,
            order_date
        )
        SELECT
            ord_id,
            cust_id,
            prd_id,
            qty,
            CONCAT(SUBSTRING(order_date, 7, 4), '-', SUBSTRING(order_date, 4, 2), '-', SUBSTRING(order_date, 1, 2)) order_date
        FROM bronze.crm_orders_2023;

        SET @end_time = GETDATE();
        PRINT 'Duration: '+ CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) +' seconds.'

        PRINT '-----------------------------------------------'

        PRINT '>>> TRUNCATING TABLE: silver.crm_orders_latest'
        SET @start_time = GETDATE();
        TRUNCATE TABLE silver.crm_orders_latest;

        PRINT '>>> INSERTING DATA INTO: silver.crm_orders_latest'
        INSERT INTO silver.crm_orders_latest(
            ord_id,
            cust_id,
            prd_id,
            qty,
            order_date
        )
        SELECT
            ord_id,
            cust_id,
            prd_id,
            qty,
            CONCAT(SUBSTRING(order_date, 7, 4), '-', SUBSTRING(order_date, 4, 2), '-', SUBSTRING(order_date, 1, 2)) order_date
        FROM bronze.crm_orders_latest;

        SET @end_time = GETDATE();
        PRINT 'Duration: '+ CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) +' seconds.'

        PRINT '-----------------------------------------------'
        PRINT 'TRANSFORMING ERP TABLES'
        PRINT '-----------------------------------------------'

        PRINT '>>> TRUNCATING TABLE: silver.erp_products'
        SET @start_time = GETDATE();
        TRUNCATE TABLE silver.erp_products;

        PRINT '>>> INSERTING DATA INTO: silver.erp_products'
        INSERT INTO silver.erp_products(
            prd_id,
            prd_name,
            cat_id,
            price,
            cost
        )
        SELECT 
            prd_id,
            LOWER(TRIM(prd_name)) prd_name,
            cat_id,
            price,
            cost
        FROM bronze.erp_products;

        SET @end_time = GETDATE();
        PRINT 'Duration: '+ CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) +' seconds.'

        PRINT '-----------------------------------------------'

        PRINT '>>> TRUNCATING TABLE: silver.erp_categories'
        SET @start_time = GETDATE();
        TRUNCATE TABLE silver.erp_categories;

        PRINT '>>> INSERTING DATA INTO: silver.erp_categories'
        INSERT INTO silver.erp_categories(
            cat_id,
            cat_name
        )
        SELECT 
            REPLACE(cat_id, '0', '') cat_id,
            LOWER(TRIM(cat_name)) cat_name
        FROM bronze.erp_categories;
        
        SET @end_time = GETDATE();
        PRINT 'Duration: '+ CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) +' seconds.'
        PRINT '-------------------------------------------------'
        SET @batch_end_time = GETDATE();
        PRINT 'Total duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds.';
    END TRY
    BEGIN CATCH
        PRINT '=========================================='
        PRINT 'ERROR OCCURED DURING LOADING SILVER LAYER'
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '=========================================='
    END CATCH

END
GO
USE [master]
GO
ALTER DATABASE [datawarehousesql] SET  READ_WRITE 
GO
