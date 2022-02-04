/****** Object:  Database ist722_hhkhan_ob1_dw    Script Date: 13-01-2022 00:59:47 ******/
/*
Kimball Group, The Microsoft Data Warehouse Toolkit
Generate a database from the datamodel worksheet, version: 4

You can use this Excel workbook as a data modeling tool during the logical design phase of your project.
As discussed in the book, it is in some ways preferable to a real data modeling tool during the inital design.
We expect you to move away from this spreadsheet and into a real modeling tool during the physical design phase.
The authors provide this macro so that the spreadsheet isn't a dead-end. You can 'import' into your
data modeling tool by generating a database using this script, then reverse-engineering that database into
your tool.

Uncomment the next lines if you want to drop and create the database
*/
/*
DROP DATABASE ist722_hhkhan_ob1_dw
GO
CREATE DATABASE ist722_hhkhan_ob1_dw
GO
ALTER DATABASE ist722_hhkhan_ob1_dw
SET RECOVERY SIMPLE
GO
*/
USE ist722_hhkhan_ob1_dw
;
IF EXISTS (SELECT Name from sys.extended_properties where Name = 'Description')
    EXEC sys.sp_dropextendedproperty @name = 'Description'
EXEC sys.sp_addextendedproperty @name = 'Description', @value = 'Default description - you should change this.'
;



-- Create a schema to hold user views (set schema name on home page of workbook).
-- It would be good to do this only if the schema doesn't exist already.
/*
GO
CREATE SCHEMA FudgeMF2
GO
*/





/* Drop table FudgeMF2.FactSales */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'FudgeMF2.FactSales') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE FudgeMF2.FactSales 
;

/* Create table FudgeMF2.FactSales */

/* Create table FudgeMF2.FactSales */
CREATE TABLE FudgeMF2.FactSales (
   [ProductKey]  int   NOT NULL
,  [CustomerKey]  int   NOT NULL
,  [OrderDateKey]  int   NOT NULL
,  [OrderID]  int   NOT NULL
,  [Mart_Or_Flix]  varchar(2)   NOT NULL
,  [SoldAmount] decimal(30,4) NOT   NULL
,  [Quantity]  int  DEFAULT 0 NOT NULL
,  [UnitPrice]  money   NOT NULL
,  [OrderDate] datetime NOT NULL
, CONSTRAINT [PK_FudgeMF2.FactSales] PRIMARY KEY NONCLUSTERED 
( [ProductKey], [OrderID], [CustomerKey] )
) ON [PRIMARY]
;



-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[FudgeMF2].[Sales]'))
DROP VIEW [FudgeMF2].[Sales]
GO
CREATE VIEW [FudgeMF2].[Sales] AS 
SELECT [ProductKey] AS [ProductKey]
, [CustomerKey] AS [CustomerKey]
, [OrderDateKey] AS [OrderDateKey]
, [OrderID] AS [OrderID]
, [Mart_Or_Flix] AS [Mart_Or_Flix]
, [SoldAmount] AS [SoldAmount]
, [Quantity] AS [Quantity]
, [UnitPrice] AS [UnitPrice]
, [OrderDate] AS [OrderDate]
FROM FudgeMF2.FactSales
GO






/* Drop table FudgeMF2.DimProduct */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'FudgeMF2.DimProduct') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE FudgeMF2.DimProduct 
;

/* Create table FudgeMF2.DimProduct */
CREATE TABLE FudgeMF2.DimProduct (
   [ProductKey]  int IDENTITY  NOT NULL
,  [ProductID]  int   NOT NULL
,  [ProductName]  varchar(200)   NOT NULL
,  [ProductDepartment]  varchar(50)   NOT NULL
,  [Mart_Or_Flix]  varchar(2)   NOT NULL
,  [RowIsCurrent]  bit  DEFAULT 1 NOT NULL
,  [RowStartDate]  datetime  DEFAULT '12/31/1899' NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  nvarchar(200)   NULL
, CONSTRAINT [PK_FudgeMF2.DimProduct] PRIMARY KEY CLUSTERED 
( [ProductKey] )
) ON [PRIMARY]
;



SET IDENTITY_INSERT FudgeMF2.DimProduct ON
;
INSERT INTO FudgeMF2.DimProduct (ProductKey, ProductID, ProductName, ProductDepartment, Mart_Or_Flix, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, -1, 'None', 'None', 'NA', 1, '12/31/1899', '12/31/9999', 'N/A')
;
SET IDENTITY_INSERT FudgeMF2.DimProduct OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[FudgeMF2].[Product]'))
DROP VIEW [FudgeMF2].[Product]
GO
CREATE VIEW [FudgeMF2].[Product] AS 
SELECT [ProductKey] AS [ProductKey]
, [ProductID] AS [ProductID]
, [ProductName] AS [ProductName]
, [ProductDepartment] AS [ProductDepartment]
, [Mart_Or_Flix] AS [Mart_Or_Flix]
, [RowIsCurrent] AS [Row Is Current]
, [RowStartDate] AS [Row Start Date]
, [RowEndDate] AS [Row End Date]
, [RowChangeReason] AS [Row Change Reason]
FROM FudgeMF2.DimProduct
GO




/* Drop table FudgeMF2.DimCustomer */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'FudgeMF2.DimCustomer') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE FudgeMF2.DimCustomer 
;

/* Create table FudgeMF2.DimCustomer */
CREATE TABLE FudgeMF2.DimCustomer (
   [CustomerKey]  int IDENTITY  NOT NULL
,  [CustomerID]  int   NOT NULL
,  [CustomerName]  varchar(101)   NOT NULL
,  [CustomerAddress]  varchar(1000)  DEFAULT 'None' NOT NULL
,  [CustomerZipcode]  varchar(20)   NULL
,  [CustomerState]  char(2)   NULL
,  [Mart_Or_Flix]  varchar(2)   NOT NULL
,  [RowIsCurrent]  bit  DEFAULT 1 NOT NULL
,  [RowStartDate]  datetime  DEFAULT '12/31/1899' NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  nvarchar(200)   NULL
, CONSTRAINT [PK_FudgeMF2.DimCustomer] PRIMARY KEY CLUSTERED 
( [CustomerKey] )
) ON [PRIMARY]
;

SET IDENTITY_INSERT FudgeMF2.DimCustomer ON
;
INSERT INTO FudgeMF2.DimCustomer (CustomerKey, CustomerID, CustomerName, CustomerAddress, CustomerZipcode, CustomerState, Mart_Or_Flix, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, -1, 'None', 'None', 'None', 'NA', 'NA', 1, '12/31/1899', '12/31/9999', 'N/A')
;
SET IDENTITY_INSERT FudgeMF2.DimCustomer OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[FudgeMF2].[Customer]'))
DROP VIEW [FudgeMF2].[Customer]
GO
CREATE VIEW [FudgeMF2].[Customer] AS 
SELECT [CustomerKey] AS [CustomerKey]
, [CustomerID] AS [CustomerID]
, [CustomerName] AS [CustomerName]
, [CustomerAddress] AS [CustomerAddress]
, [CustomerZipcode] AS [CustomerZipcode]
, [CustomerState] AS [CustomerState]
, [Mart_Or_Flix] AS [Mart_Or_Flix]
, [RowIsCurrent] AS [Row Is Current]
, [RowStartDate] AS [Row Start Date]
, [RowEndDate] AS [Row End Date]
, [RowChangeReason] AS [Row Change Reason]
FROM FudgeMF2.DimCustomer
GO






/* Drop table FudgeMF2.DimDate */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'FudgeMF2.DimDate') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE FudgeMF2.DimDate 
;

/* Create table FudgeMF2.DimDate */
CREATE TABLE FudgeMF2.DimDate (
   [DateKey]  int   NOT NULL
,  [Date]  datetime   NULL
,  [FullDateUSA]  nchar(11)   NOT NULL
,  [DayOfWeek]  tinyint   NOT NULL
,  [DayName]  nchar(10)   NOT NULL
,  [DayOfMonth]  tinyint   NOT NULL
,  [DayOfYear]  int   NOT NULL
,  [WeekOfYear]  tinyint   NOT NULL
,  [MonthName]  nchar(10)   NOT NULL
,  [MonthOfYear]  tinyint   NOT NULL
,  [Quarter]  tinyint   NOT NULL
,  [QuarterName]  nchar(10)   NOT NULL
,  [Year]  int   NOT NULL
,  [IsAWeekday]  varchar(1)  DEFAULT 'N' NOT NULL
, CONSTRAINT [PK_FudgeMF2.DimDate] PRIMARY KEY CLUSTERED 
( [DateKey] )
) ON [PRIMARY]
;


INSERT INTO FudgeMF2.DimDate (DateKey, Date, FullDateUSA, DayOfWeek, DayName, DayOfMonth, DayOfYear, WeekOfYear, MonthName, MonthOfYear, Quarter, QuarterName, Year, IsAWeekday)
VALUES (-1, '', 'Unk date', 0, 'Unk day', 0, 0, 0, 'Unk month', 0, 0, 'Unk qtr', 0, '?')
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[FudgeMF2].[Date]'))
DROP VIEW [FudgeMF2].[Date]
GO
CREATE VIEW [FudgeMF2].[Date] AS 
SELECT [DateKey] AS [DateKey]
, [Date] AS [Date]
, [FullDateUSA] AS [FullDateUSA]
, [DayOfWeek] AS [DayOfWeek]
, [DayName] AS [DayName]
, [DayOfMonth] AS [DayOfMonth]
, [DayOfYear] AS [DayOfYear]
, [WeekOfYear] AS [WeekOfYear]
, [MonthName] AS [MonthName]
, [MonthOfYear] AS [MonthOfYear]
, [Quarter] AS [Quarter]
, [QuarterName] AS [QuarterName]
, [Year] AS [Year]
, [IsAWeekday] AS [IsAWeekday]
FROM FudgeMF2.DimDate
GO


ALTER TABLE FudgeMF2.FactSales ADD CONSTRAINT
   FK_FudgeMF2_FactSales_ProductKey FOREIGN KEY
   (
   ProductKey
   ) REFERENCES FudgeMF2.DimProduct
   ( ProductKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE FudgeMF2.FactSales ADD CONSTRAINT
   FK_FudgeMF2_FactSales_CustomerKey FOREIGN KEY
   (
   CustomerKey
   ) REFERENCES FudgeMF2.DimCustomer
   ( CustomerKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE FudgeMF2.FactSales ADD CONSTRAINT
   FK_FudgeMF2_FactSales_OrderDateKey FOREIGN KEY
   (
   OrderDateKey
   ) REFERENCES FudgeMF2.DimDate
   ( DateKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
