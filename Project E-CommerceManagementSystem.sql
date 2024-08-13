--Project E-Commerce Management System--
---CREATE DATABASE--
CREATE DATABASE E_CommerceManagementSystem
ON 
(Name='E_Commerce',
FileName='C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\E_Commerce.mdf',
Size=10MB,
MaxSize=100MB,
FileGrowth=10%
)
LOG ON 
(Name='E_Commerce1',
FileName='C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\E_Commerce1.ldf',
Size=10MB,
MaxSize=25MB,
FileGrowth=10%
)
GO
--USE THIS DATABASE--
USE E_CommerceManagementSystem
--DATABASE DETAILS
EXEC sp_helpdb 'E_CommerceManagementSystem'
GO
--TABLE FOR USERS--
CREATE TABLE Users(UserId INT PRIMARY KEY IDENTITY NOT NULL,
UserName VARCHAR(30) NOT NULL,
PassWord VARCHAR(255)  NOT NULL,
Email VARCHAR(40) NOT NULL CHECK (Email LIKE'%[@]%'),
CreatedAt DATETIME DEFAULT GETDATE()
)
GO
INSERT INTO Users
VALUES('Asif Hossain','Asif@123','ah9312248@gmail.com','6-28-2024'),
('Jaber Hossain','Jaber@123','Jaber12248@gmail.com','7-28-2024'),
('Abdur Rahman','Rahim@123','Rahman48@gmail.com','6-29-2024'),
('Mezba Hossain','Mejba@123','Mejba12248@gmail.com','6-22-2024')
GO
SELECT * FROM Users
GO
--CHECK CONSTRAINT--
EXEC sp_helpconstraint'Users'
GO
--TABLE FOR CATEGORIS--
CREATE TABLE Categories
(CategoryId INT PRIMARY KEY,
CategoryName VARCHAR(30))
GO
INSERT INTO Categories
VALUES(1,'Electronics'),
(2,'Clothing'),
(3,'Books'),
(4,'Home & Kitchen'),
(5,'Toys'),
(6,'SportsKit'),
(7,'Shoes'),
(8,'light'),
(9,'Fan'),
(10,'Vegetables')
GO
SELECT * FROM Categories
GO
--TABLE DETAILS--
EXEC sp_help 'Categories'
GO
CREATE TABLE Products
(ProductId INT PRIMARY KEY IDENTITY NOT NULL,
Name VARCHAR(30)NOT NULL,
Price MONEY NOT NULL,
CategoryId INT,
FOREIGN KEY(CategoryId)REFERENCES Categories(CategoryId),
Createdat DATETIME DEFAULT GETDATE()NOT NULL
)
GO
--RENAME TABLE Column NAME--
EXEC sp_rename'Products.Name','ProductName','COLUMN'
GO
INSERT INTO Products
VALUES('SmartPhone',15000.00,1,'7-28-2024'),
  ('Laptop',30000.00,2,'7-28-2024'),
  ('T-Shirt',1500.00,3,'7-28-2024'),
  ('Sql server Book',100.00,4,'7-28-2024'),
  ('Blender',500.00,5,'7-28-2024'),('Fan',2000.00,6,'7-28-2024')
  GO
  SELECT * FROM Products
  GO
  --TABLE FOR ORDERS--
  CREATE TABLE Orders(OrderId INT PRIMARY KEY NOT NULL ,
  UserId INT,
  OrderDate DATETIME NOT NULL,
  Total MONEY NOT NULL
  FOREIGN KEY (UserId) REFERENCES Users(UserId))
  GO
  INSERT INTO Orders
  VALUES(1,1,'5-28-2024',1000.00),
  (2,2,'6-29-2024',2000.00),
  (3,3,'7-30-2024',500.00),
  (4,4,'2-22-2023',700.00)
  GO
  SELECT * FROM Orders
  GO
  --TABLE FOR ORDERITEMS--
  CREATE TABLE OrderItems
  (OrderItemId INT PRIMARY KEY NOT NULL,
  OrderId INT,
  ProductId INT,
  UnitPrice MONEY NOT NULL,
  Quantity INT NOT NULL,
  DiscountPercent FLOAT DEFAULT .05,
  Date DATETIME DEFAULT GETDATE(),
  FOREIGN KEY (OrderId) REFERENCES Orders(OrderId),
  FOREIGN KEY (ProductId) REFERENCES Products(ProductId)
  )
  GO
  INSERT INTO OrderItems
  VALUES(1,1,1,15000.00,2,.05,'2024-07-08'),
  (2,2,2,30000.00,3,.05,'2024-07-09'),
  (3,3,3,1500.00,5,.05,'2024-07-10'),
  (4,4,4,100.00,15,.05,'2024-07-11')
  GO
  SELECT * FROM OrderItems
  GO
  --FUNCTION FOR ORDERITEMS--
  CREATE FUNCTION OrderItemsFUNCTIONS
  (@Year INT,
  @Month INT,
  @Day INT)
  RETURNS TABLE 
  AS 
  RETURN
  (SELECT SUM(UnitPrice*Quantity)AS'TOTALSALE',
  SUM(Unitprice*Quantity*DiscountPercent)AS'TOTAL DISCOUNT',
  SUM(UnitPrice*Quantity*(1-DiscountPercent))AS'NET AMOUNT'
  FROM OrderItems
  WHERE YEAR(DATE)=@Year AND MONTH(DATE)=@Month AND DAY(DATE)=@Day)
  GO
  SELECT * FROM dbo.OrderItemsFUNCTIONS(2024,07,08)
    SELECT * FROM dbo.OrderItemsFUNCTIONS(2024,07,09)
	    SELECT * FROM dbo.OrderItemsFUNCTIONS(2024,07,10)
			    SELECT * FROM dbo.OrderItemsFUNCTIONS(2024,07,11)
--USE GROUP BY FOR OrderItemId --
SELECT OrderItemId,SUM(UnitPrice*Quantity)AS'TOTAL AMOUNT'
FROM OrderItems
GROUP BY OrderItemId
GO
SELECT OrderItemId,SUM(UnitPrice*Quantity*(1-DiscountPercent))AS'CurrentPrice'
FROM OrderItems
GROUP BY OrderItemId
GO
--USE HAVING FOR FIND OUT OrderItemId=2--
SELECT OrderItemId,SUM(UnitPrice*Quantity)AS'TOTAL AMOUNT'
FROM OrderItems
GROUP BY OrderItemId
HAVING OrderItemId=2
GO
--INNER JOIN  BETWEEN OrderItems AND Products  FOR MAKE A RELATIONSHIP  --
SELECT Products.ProductId,Products.ProductName,OrderItems.ProductId,OrderItems.UnitPrice*Quantity*(1-DiscountPercent)AS 'CurrentPrice' FROM Products
INNER JOIN OrderItems
ON Products.ProductId=OrderItems.ProductId
GO
--LEFT JOIN BETWEEN OrderItems AND Products  FOR MAKE A RELATIONSHIP--
SELECT Products.ProductId,Products.ProductName,OrderItems.UnitPrice*Quantity*(1-DiscountPercent)AS 'CurrentPrice',OrderItems.ProductId,OrderItems.UnitPrice*Quantity*(1-DiscountPercent)AS 'CurrentPrice' FROM Products
LEFT JOIN OrderItems
ON Products.ProductId=OrderItems.ProductId
GO
--RIGHT JOIN BETWEEN OrderItems AND Products  FOR MAKE A RELATIONSHIP--
SELECT Products.ProductId,Products.ProductName,OrderItems.UnitPrice*Quantity*(1-DiscountPercent)AS 'CurrentPrice',OrderItems.ProductId,OrderItems.Date FROM Products
RIGHT JOIN OrderItems
ON Products.ProductId=OrderItems.ProductId
GO
--OUTER JOIN BETWEEN OrderItems AND Products  FOR MAKE A RELATIONSHIP--
SELECT Products.ProductId,Products.ProductName,OrderItems.UnitPrice*Quantity*(1-DiscountPercent)AS 'CurrentPrice',OrderItems.Quantity,OrderItems.ProductId,OrderItems.Date FROM Products
FULL OUTER JOIN OrderItems
ON Products.ProductId=OrderItems.OrderItemId
GO
--ADD COLUMN IN OrderItems--
ALTER TABLE OrderItems
ADD LoseProduct VARCHAR(30) DEFAULT 'N\A'
GO
SELECT * FROM OrderItems
GO
--CHECK MAX WITH SUBQUERY--
SELECT * FROM OrderItems
WHERE Quantity=(SELECT MAX(Quantity)FROM OrderItems)
GO
--USE NOT EXISTS FOR FIND OUT UNCOMMON DATA--
SELECT * FROM OrderItems
WHERE NOT EXISTS (SELECT * FROM Products
WHERE Products.ProductId=OrderItems.OrderItemId)
GO
--CHECK SOME
IF 4>= SOME(SELECT ProductId FROM Products)
PRINT 'AVAILABLE'
ELSE
PRINT 'NOT AVAILABLE'
GO
--CHECK ANY--
IF 4>= ANY(SELECT ProductId FROM Products)
PRINT 'AVAILABLE'
ELSE
PRINT 'NOT AVAILABLE'
GO
--CHECK ALL--
IF 4>= ALL(SELECT ProductId FROM Products)
PRINT 'AVAILABLE'
ELSE
PRINT 'NOT AVAILABLE'
GO
--USE CTE(COMMON TABLE EXPRESSION ) WITH UNION ALL--
WITH USERCTE
AS(
SELECT * FROM Users WHERE Email='ah9312248@gmail.com'
),
USERCTE2 AS(SELECT * FROM Users
WHERE UserName='Jaber Hossain')
SELECT * FROM USERCTE
UNION ALL
SELECT * FROM USERCTE2
GO
--UPDATE ON TABLE Users--
UPDATE Users
SET UserName='FAHIM FOYSAL'
WHERE UserId=4
GO
SELECT * FROM Users
GO
UPDATE Users
SET UserName='MEJBA'
WHERE UserId=4
GO
--USE DENSE_RANK WITH CTE IN TABLE OrderItems--
WITH RANKINGCTE
AS
(SELECT UnitPrice,DENSE_RANK()OVER (ORDER BY UnitPrice)AS 'MAX UNITPRICE'FROM OrderItems )
SELECT * FROM RANKINGCTE
GO
--USE DENSE RANK IN OrderItems--
SELECT UnitPrice,Quantity,UnitPrice*Quantity AS'TOTAL AMOUNT',UnitPrice*Quantity*DiscountPercent AS'TOTAL DISCOUNT',UnitPrice*Quantity*(1-DiscountPercent)AS'CURRENT PRICE', DENSE_RANK()OVER (ORDER BY UnitPrice)AS 'MAX UNITPRICE'FROM OrderItems 
GO
--MERGE TABLE BETWEEN Categories AND Products--
MERGE Categories AS TARGET
USING Products AS SOURCE
ON SOURCE.CategoryId=TARGET.CategoryId
WHEN NOT MATCHED THEN INSERT (CategoryId)
VALUES(SOURCE.CategoryId);
GO
--SELF JOIN IN Products--
SELECT P.CategoryId,P.ProductId, P.Createdat,P.ProductName,PD.ProductName
FROM Products P
INNER JOIN Products PD
ON P.CategoryId=PD.ProductId
GO
--TABLE FOR REVIEWS WITH CHECK AND DEFAULT--
CREATE TABLE Reviews (
ReviewId INT ,
ProductId INT,
UserId INT,
Rating INT CHECK (Rating>=1 AND Rating<=5),
ReviewDate DATETIME DEFAULT GETDATE()
FOREIGN KEY (ProductId)REFERENCES Products(ProductId),
FOREIGN KEY (UserId)REFERENCES Users
(UserId),
)
--CHANGE DATATYPE IN TABLE Reviews--
ALTER TABLE Reviews
ALTER COLUMN ReviewId INT
GO
INSERT INTO Reviews
VALUES
(NULL,1,1,5,'2024-7-28'),
(NULL,2,2,4,'2024-7-28'),
(NULL,3,3,3,'2024-7-28'),
(NULL,4,4,5,'2024-7-28')
GO
SELECT * FROM Reviews
GO
--USE SEQUENCE FOR Reviews TABLE--
CREATE SEQUENCE S_Reviews
AS INT
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 4
CYCLE 
GO
UPDATE Reviews
SET ReviewId=NEXT 
VALUE FOR S_Reviews
GO
--USE CLUSTERED INDEX ON Reviews IN Rating--
CREATE CLUSTERED INDEX MYREVIEWS
ON Reviews(Rating)
GO
--DROP CLUSTERED INDEX--
DROP  INDEX Reviews.MYREVIEWS
GO
--USE CLUSTERED INDEX ON Reviews IN Rating--
CREATE CLUSTERED INDEX USERINDEX
ON Reviews(UserId)
GO
SELECT * FROM Reviews
GO
--use roll up for sum recentprice--
SELECT COALESCE (OrderItemId ,'')AS'OrderItemId',SUM (Quantity*UnitPrice*(1-DiscountPercent))AS 'RecentPrice' FROM OrderItems
GROUP BY ROLLUP (OrderItemId)
GO
--USE VIEW FOR Reviews--
CREATE VIEW V_Review
AS 
SELECT Userid,Rating
FROM Reviews
SELECT * FROM V_Review
GO
--view with encrption--
CREATE VIEW V_TRAINEE
WITH ENCRYPTION
AS 
SELECT UserId,Rating
FROM dbo.Reviews
GO
SELECT * FROM V_TRAINEE
GO
--view with encrption and schemabinding--
CREATE VIEW V_loger
WITH ENCRYPTION,SCHEMABINDING
AS 
SELECT UserId,Rating
FROM dbo.Reviews
GO
SELECT * FROM V_loger
GO
--CHECK ENCRYPT AND SCHEMABINDING--
EXEC sp_helptext 'V_loger'
GO
--SP with Output IN Products Table--
CREATE PROCEDURE SP_IN
(@ProductId INT OUTPUT)
AS
SELECT COUNT(@ProductId)
FROM Products
EXECUTE SP_IN 1
GO
--SP WITH RETURN IN Product Table--
CREATE PROCEDURE SP_Returns
(@ProductId INT)
AS
SELECT ProductId,ProductName FROM Products
WHERE ProductId=@ProductId
GO
--EXECUTE QUERY--
DECLARE @Return_Value INT
EXECUTE @Return_Value=SP_Returns @ProductId=2 
GO
---use SP WITH INSERT UPDATE DELETE TRANSACTION--
CREATE PROCEDURE SP_Category
(@CategoryId INT,
@CategoryName VARCHAR(30),
@StatementType VARCHAR(100))
AS
IF @StatementType='SELECT'
BEGIN
SELECT * FROM Categories
END
IF @StatementType='INSERT'
BEGIN
INSERT INTO Categories(CategoryId,CategoryName)
VALUES(@CategoryId,@CategoryName)
END
IF @StatementType='UPDATE'
BEGIN
UPDATE Categories
SET CategoryName=@CategoryName WHERE CategoryId=@CategoryId
END
IF @StatementType='DELETE'
BEGIN
DELETE Categories
WHERE CategoryId=@CategoryId
END
EXEC SP_Category '11','Sports','INSERT'
EXEC SP_Category '11','Sports','SELECT'
EXEC SP_Category '8','Cosmetics','UPDATE'
GO
--TRIGGER WITH RAISEERROR IN Categories Table --

CREATE TABLE AccountlogIN
(
logID INT IDENTITY(1,1),
CategoryId INT,
CategoryName VARCHAR(100)
)
GO
CREATE TRIGGER Tr_Categories
ON Categories
INSTEAD OF DELETE
AS
BEGIN
DECLARE @CategoryId INT
SELECT @CategoryId=DELETED.CategoryId FROM DELETED
IF @CategoryId=1
BEGIN
RAISERROR
('Deleted not granted by owner',16,1)
ROLLBACK
INSERT INTO AccountlogIN
VALUES (@CategoryId,'INVALID')
END
ELSE
BEGIN
DELETE Categories
WHERE @CategoryId=CategoryId
INSERT INTO Categories
VALUES(@CategoryId,'DELETE')
END
END
DELETE Categories
WHERE CategoryId=1
GO
SELECT * FROM AccountlogIN
GO
---READ ALL
SELECT * FROM Categories
GO
SELECT * FROM OrderItems
GO
SELECT * FROM Orders
GO
SELECT * FROM Products
GO
SELECT * FROM Reviews
GO
SELECT * FROM Users
GO
--PROJECT E_COMMERCE MANAGEMENT SYTEM  DONE--












	

  
