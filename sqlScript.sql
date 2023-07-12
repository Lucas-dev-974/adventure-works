-- ---------------------------
SELECT *  
FROM humanresources.employee  
ORDER BY jobtitle;
-- ---------------------------
SELECT e.*
FROM person.person AS e  
ORDER BY LastName ASC;
-- ---------------------------
SELECT firstname, lastname, businessentityid as Employee_id  
FROM person.person AS e  
ORDER BY lastname;
-- ---------------------------
SELECT productid, productnumber, name as producName
FROM production.product
WHERE sellstartdate IS NOT NULL
AND production.product.productline= 'T'
ORDER BY name;
-- ---------------------------
SELECT salesorderid,customerid,orderdate,subtotal,
(taxamt*100)/subtotal AS Tax_percent
FROM sales.salesorderheader
ORDER BY subtotal desc;
-- ---------------------------
SELECT DISTINCT jobtitle  
FROM humanresources.employee  
ORDER BY jobtitle;
-- ---------------------------
SELECT customerid,sum(freight) as total_freight 
FROM sales.salesorderheader
group by customerid
ORDER BY customerid ASC;
-- ---------------------------
SELECT productid, sum(quantity) AS total_quantity
FROM production.productinventory
WHERE shelf IN ('A','C','H')
GROUP BY productid
HAVING SUM(quantity)>500
ORDER BY productid;
-- ---------------------------
SELECT productid, sum(quantity) AS total_quantity
FROM production.productinventory
WHERE shelf IN ('A','C','H')
GROUP BY productid
HAVING SUM(quantity)>500
ORDER BY productid;
-- ---------------------------
SELECT SUM(quantity) AS total_quantity
FROM production.productinventory
GROUP BY (locationid*10);
-- ---------------------------
SELECT p.BusinessEntityID, FirstName, LastName, PhoneNumber AS Person_Phone  
FROM Person.Person AS p  
JOIN Person.PersonPhone AS ph 
ON p.BusinessEntityID  = ph.BusinessEntityID  
WHERE LastName LIKE 'L%'  
ORDER BY LastName, FirstName;
-- ---------------------------
SELECT salespersonid,customerid,sum(subtotal) AS sum_subtotal
FROM sales.salesorderheader s 
GROUP BY ROLLUP (salespersonid, customerid);
-- ---------------------------
SELECT locationid, shelf, SUM(quantity) AS TotalQuantity
FROM production.productinventory
GROUP BY CUBE (locationid, shelf);
-- ---------------------------
SELECT locationid, shelf, SUM(quantity) AS TotalQuantity
FROM production.productinventory
GROUP BY GROUPING SETS ( ROLLUP (locationid, shelf), CUBE (locationid, shelf) );
-- ---------------------------
SELECT locationid, SUM(quantity) AS TotalQuantity
FROM production.productinventory
GROUP BY GROUPING SETS ( locationid, () );

-- ---------------------------
SELECT a.City, COUNT(b.AddressID) NoOfEmployees 
FROM Person.BusinessEntityAddress AS b   
    INNER JOIN Person.Address AS a  
        ON b.AddressID = a.AddressID  
GROUP BY a.City  
ORDER BY a.City;
-- ---------------------------
SELECT DATEPART(year,OrderDate) AS YEAR
    ,SUM(TotalDue) AS "Order Amount"  
FROM Sales.SalesOrderHeader  
GROUP BY DATEPART(year,OrderDate)  
ORDER BY DATEPART(year,OrderDate);
-- ---------------------------
SELECT DATEPART(year,OrderDate) AS YearOfOrderDate  
    ,SUM(TotalDue) AS TotalDueOrder  
FROM Sales.SalesOrderHeader  
GROUP BY DATEPART(year,OrderDate)  
HAVING DATEPART(year,OrderDate) <= '2016'  
ORDER BY DATEPART(year,OrderDate);
-- ---------------------------
SELECT ContactTypeID, Name
    FROM Person.ContactType
    WHERE Name LIKE '%Manager%'
    ORDER BY Name DESC;
-- ---------------------------
SELECT pp.BusinessEntityID, LastName, FirstName
    FROM Person.BusinessEntityContact AS pb 
        INNER JOIN Person.ContactType AS pc
            ON pc.ContactTypeID = pb.ContactTypeID
        INNER JOIN Person.Person AS pp
            ON pp.BusinessEntityID = pb.PersonID
    WHERE pc.Name = 'Purchasing Manager'
    ORDER BY LastName, FirstName;
-- ---------------------------
SELECT ROW_NUMBER() OVER (PARTITION BY PostalCode ORDER BY SalesYTD DESC) AS "Row Number",
pp.LastName, sp.SalesYTD, pa.PostalCode
FROM Sales.SalesPerson AS sp
    INNER JOIN Person.Person AS pp
        ON sp.BusinessEntityID = pp.BusinessEntityID
    INNER JOIN Person.Address AS pa
        ON pa.AddressID = pp.BusinessEntityID
WHERE TerritoryID IS NOT NULL
    AND SalesYTD <> 0
ORDER BY PostalCode;
-- ---------------------------
SELECT pc.ContactTypeID, pc.Name AS CTypeName, COUNT(*) AS NOcontacts
    FROM Person.BusinessEntityContact AS pbe
        INNER JOIN Person.ContactType AS pc
            ON pc.ContactTypeID = pbe.ContactTypeID
    GROUP BY pc.ContactTypeID, pc.Name
	HAVING COUNT(*) >= 100
    ORDER BY COUNT(*) DESC;
-- ---------------------------
SELECT CAST(hur.RateChangeDate as VARCHAR(10) ) AS FromDate
        , CONCAT(LastName, ', ', FirstName, ' ', MiddleName) AS NameInFull
        , (40 * hur.Rate) AS SalaryInAWeek
    FROM Person.Person AS pp
        INNER JOIN HumanResources.EmployeePayHistory AS hur
            ON hur.BusinessEntityID = pp.BusinessEntityID      
    ORDER BY NameInFull;
-- ---------------------------
SELECT CAST(hur.RateChangeDate as VARCHAR(10) ) AS FromDate
        , CONCAT(LastName, ', ', FirstName, ' ', MiddleName) AS NameInFull
        , (40 * hur.Rate) AS SalaryInAWeek
    FROM Person.Person AS pp
        INNER JOIN HumanResources.EmployeePayHistory AS hur
            ON hur.BusinessEntityID = pp.BusinessEntityID
             WHERE hur.RateChangeDate = (SELECT MAX(RateChangeDate)
                                FROM HumanResources.EmployeePayHistory 
                                WHERE BusinessEntityID = hur.BusinessEntityID)
    ORDER BY NameInFull;
-- ---------------------------
SELECT SalesOrderID, ProductID, OrderQty
    ,SUM(OrderQty) OVER (PARTITION BY SalesOrderID) AS "Total Quantity"
    ,AVG(OrderQty) OVER (PARTITION BY SalesOrderID) AS "Avg Quantity"
    ,COUNT(OrderQty) OVER (PARTITION BY SalesOrderID) AS "No of Orders"
    ,MIN(OrderQty) OVER (PARTITION BY SalesOrderID) AS "Min Quantity"
    ,MAX(OrderQty) OVER (PARTITION BY SalesOrderID) AS "Max Quantity"
    FROM Sales.SalesOrderDetail
WHERE SalesOrderID IN(43659,43664);
-- ---------------------------
SELECT SalesOrderID AS OrderNumber, ProductID,
    OrderQty AS Quantity,
    SUM(OrderQty) OVER (ORDER BY SalesOrderID, ProductID) AS Total,
    AVG(OrderQty) OVER(PARTITION BY SalesOrderID ORDER BY SalesOrderID, ProductID) AS Avg,
    COUNT(OrderQty) OVER(ORDER BY SalesOrderID, ProductID ROWS BETWEEN UNBOUNDED PRECEDING AND 1 FOLLOWING) AS Count
FROM Sales.SalesOrderDetail
WHERE SalesOrderID IN(43659,43664) and CAST(ProductID AS TEXT) LIKE '71%';
-- ---------------------------
SELECT SalesOrderID, SUM(orderqty*unitprice) AS OrderIDCost  
FROM Sales.SalesOrderDetail  
GROUP BY SalesOrderID  
HAVING SUM(orderqty*unitprice) > 100000.00  
ORDER BY SalesOrderID;
-- ---------------------------
SELECT ProductID, Name 
FROM Production.Product  
WHERE Name LIKE 'Lock Washer%'  
ORDER BY ProductID;
-- ---------------------------
SELECT ProductID, Name, Color  
FROM Production.Product  
ORDER BY ListPrice;
-- ---------------------------
SELECT BusinessEntityID, JobTitle, HireDate  
FROM HumanResources.Employee  
ORDER BY DATEPART(year,HireDate);
-- ---------------------------
SELECT LastName, FirstName 
FROM Person.Person  
WHERE LastName LIKE 'R%'  
ORDER BY FirstName ASC, LastName DESC ;
-- ---------------------------
SELECT BusinessEntityID, SalariedFlag  
FROM HumanResources.Employee  
ORDER BY CASE SalariedFlag WHEN 'true' THEN BusinessEntityID END DESC  
        ,CASE WHEN SalariedFlag ='false' THEN BusinessEntityID END;
-- ---------------------------
SELECT BusinessEntityID, LastName, TerritoryName, CountryRegionName  
FROM Sales.vSalesPerson  
WHERE TerritoryName IS NOT NULL  
ORDER BY CASE CountryRegionName WHEN 'United States' THEN TerritoryName  
         ELSE CountryRegionName END;
-- ---------------------------
SELECT p.FirstName, p.LastName  
    ,ROW_NUMBER() OVER (ORDER BY a.PostalCode) AS "Row Number"  
    ,RANK() OVER (ORDER BY a.PostalCode) AS "Rank"  
    ,DENSE_RANK() OVER (ORDER BY a.PostalCode) AS "Dense Rank"  
    ,NTILE(4) OVER (ORDER BY a.PostalCode) AS "Quartile"  
    ,s.SalesYTD, a.PostalCode  
FROM Sales.SalesPerson AS s   
    INNER JOIN Person.Person AS p   
        ON s.BusinessEntityID = p.BusinessEntityID  
    INNER JOIN Person.Address AS a   
        ON a.AddressID = p.BusinessEntityID  
WHERE TerritoryID IS NOT NULL AND SalesYTD <> 0;
-- ---------------------------
SELECT DepartmentID, Name, GroupName  
FROM HumanResources.Department  
ORDER BY DepartmentID OFFSET 10 ROWS;
-- ---------------------------
SELECT DepartmentID, Name, GroupName  
FROM HumanResources.Department  
ORDER BY DepartmentID   
    OFFSET 5 ROWS  
    FETCH NEXT 5 ROWS ONLY;
-- ---------------------------
SELECT Name, Color, ListPrice  
FROM Production.Product  
WHERE Color = 'Red'  
UNION ALL  
SELECT Name, Color, ListPrice  
FROM Production.Product  
WHERE Color = 'Blue'  
ORDER BY ListPrice ASC;
-- ---------------------------
SELECT p.Name, sod.SalesOrderID  
FROM Production.Product AS p  
FULL OUTER JOIN Sales.SalesOrderDetail AS sod  
ON p.ProductID = sod.ProductID  
ORDER BY p.Name;
-- ---------------------------
SELECT p.Name, sod.SalesOrderID  
FROM Production.Product AS p  
INNER JOIN Sales.SalesOrderDetail AS sod  
ON p.ProductID = sod.ProductID  
ORDER BY p.Name ;
-- ---------------------------
SELECT st.Name AS Territory, sp.BusinessEntityID  
FROM Sales.SalesTerritory AS st   
RIGHT OUTER JOIN Sales.SalesPerson AS sp  
ON st.TerritoryID = sp.TerritoryID ;
-- ---------------------------
SELECT concat(RTRIM(p.FirstName),' ', LTRIM(p.LastName)) AS Name, d.City  
FROM Person.Person AS p  
INNER JOIN HumanResources.Employee e ON p.BusinessEntityID = e.BusinessEntityID   
INNER JOIN  
   (SELECT bea.BusinessEntityID, a.City   
    FROM Person.Address AS a  
    INNER JOIN Person.BusinessEntityAddress AS bea  
    ON a.AddressID = bea.AddressID) AS d  
ON p.BusinessEntityID = d.BusinessEntityID  
ORDER BY p.LastName, p.FirstName;
-- ---------------------------
SELECT businessentityid, firstname,lastname  
FROM  
   (SELECT * FROM person.person  
    WHERE persontype = 'IN') AS personDerivedTable 
WHERE lastname = 'Adams'  
ORDER BY firstname;
-- ---------------------------
SELECT businessentityid, firstname,LastName  
FROM person.person 
WHERE businessentityid <= 1500 AND LastName LIKE '%Al%' AND FirstName LIKE '%M%';
-- ---------------------------
SELECT ProductID, a.Name, Color  
FROM Production.Product AS a  
INNER JOIN (VALUES ('Blade'), ('Crown Race'), ('AWC Logo Cap')) AS b(Name)   
ON a.Name = b.Name;
-- ---------------------------
WITH Sales_CTE (SalesPersonID, SalesOrderID, SalesYear)
AS
(
    SELECT SalesPersonID, SalesOrderID, DATEPART(year,OrderDate) AS SalesYear
    FROM Sales.SalesOrderHeader
    WHERE SalesPersonID IS NOT NULL
)
SELECT SalesPersonID, COUNT(SalesOrderID) AS TotalSales, SalesYear
FROM Sales_CTE
GROUP BY SalesYear, SalesPersonID
ORDER BY SalesPersonID, SalesYear;
-- ---------------------------
WITH Sales_CTE (SalesPersonID, NumberOfOrders)
AS
(
    SELECT SalesPersonID, COUNT(*)
    FROM Sales.SalesOrderHeader
    WHERE SalesPersonID IS NOT NULL
    GROUP BY SalesPersonID
)
SELECT AVG(NumberOfOrders) AS "Average Sales Per Person"
FROM Sales_CTE;
-- ---------------------------
SELECT *   
FROM Production.ProductPhoto  
WHERE LargePhotoFileName LIKE '%greena_%' ESCAPE 'a' ;
-- ---------------------------
SELECT AddressLine1, AddressLine2, City, PostalCode, CountryRegionCode    
FROM Person.Address AS a  
JOIN Person.StateProvince AS s ON a.StateProvinceID = s.StateProvinceID  
WHERE CountryRegionCode NOT IN ('US')  
AND City LIKE 'Pa%' ;
-- ---------------------------
SELECT JobTitle,HireDate
  FROM [AdventureWorks2019].[HumanResources].[Employee]
  ORDER BY HireDate DESC
-- ---------------------------
SELECT *
  FROM [AdventureWorks2019].[Sales].[SalesOrderHeader] as sOrders
  INNER JOIN [Sales].[SalesOrderDetail] as sDetails
	ON (sDetails.SalesOrderDetailID = sOrders.SalesOrderID)
	WHERE sOrders.TotalDue > 100
	AND (sDetails.OrderQty > 5 OR sDetails.UnitPriceDiscount < 1000)
-- ---------------------------
SELECT name, Color
	FROM Production.Product
	WHERE color = 'red'
-- ---------------------------
SELECT name, ListPrice
	FROM Production.Product
	WHERE ListPrice = 80.99
-- ---------------------------
SELECT name, Color
    FROM Production.Product
	WHERE (name LIKE '%Mountain%' OR name LIKE '%Road%')
-- ---------------------------
SELECT name, Color
    FROM Production.Product
	WHERE (name LIKE '%Mountain%' OR name LIKE '%Black%')
-- ---------------------------
SELECT name, Color
    FROM Production.Product
	WHERE name LIKE '%chain%' 
-- ---------------------------
SELECT name, Color
    FROM Production.Product
	WHERE (name LIKE '%chain%' OR name LIKE '%full%')
-- ---------------------------
SELECT p.FirstName, p.LastName, pEmail.EmailAddress
  FROM Person.Person as p
  INNER JOIN Person.EmailAddress as pEmail
	ON (p.BusinessEntityID = pEmail.BusinessEntityID)
-- ---------------------------
SELECT name, CHARINDEX('Yellow', name) as 'str_pos'
	FROM Production.Product
	WHERE CHARINDEX('Yellow', name) > 0
-- ---------------------------
SELECT CONCAT(name,color,productnumber ) as 'result', color
    FROM Production.Product
-- ---------------------------
SELECT CONCAT_WS(',',name,productnumber, Color) as 'databaseinfo'
    FROM Production.Product
-- ---------------------------
SELECT LEFT(name,5 ) as 'left'
	FROM Production.Product
-- ---------------------------
SELECT LEN(FirstName) as 'length',FirstName, LastName
		FROM Sales.vindividualcustomer
-- ---------------------------
SELECT LEN(sContact.FirstName) as 'fnamelength--',sContact.FirstName, sContact.LastName
  FROM Sales.vstorewithcontacts as sContact
  INNER JOIN Sales.vstorewithaddresses as sAddress
	ON (sContact.BusinessEntityID = sAddress.BusinessEntityID)
-- ---------------------------
SELECT LOWER(SUBSTRING(Name, 1, 25)) AS Lower,   
       UPPER(SUBSTRING(Name, 1, 25)) AS Upper,   
       LOWER(UPPER(SUBSTRING(Name, 1, 25))) As LowerUpper  
      FROM production.Product  
      WHERE standardcost between 1000.00 and 1220.00;
-- ---------------------------
SELECT  '     five space then the text' as "Original Text",
LTRIM('     five space then the text') as "Trimmed Text(space removed)";
-- ---------------------------
SELECT productnumber,LTRIM(productnumber , 'HN') as "TrimmedProductnumber"
from production.product
where left(productnumber,2)='HN';
-- ---------------------------
SELECT Name, CONCAT(REPLICATE('0', 4) , ProductLine) AS "Line Code"  
FROM Production.Product  
WHERE ProductLine = 'T'  
ORDER BY Name;
-- ---------------------------
SELECT FirstName, REVERSE(FirstName) AS Reverse  
FROM Person.Person  
WHERE BusinessEntityID < 6 
ORDER BY FirstName;
-- ---------------------------
SELECT name, productnumber, RIGHT(name, 8) AS "Product Name"  
FROM production.product 
ORDER BY productnumber;
-- ---------------------------
SELECT  CONCAT('text then five spaces     ','after space') as "Original Text",
CONCAT(RTRIM('text then five spaces     '),'after space') as "Trimmed Text(space removed)";
-- ---------------------------
SELECT productnumber, name
FROM production.product
WHERE RIGHT(name,1) in ('S','M','L');
-- ---------------------------
SELECT STRING_AGG(CONVERT(NVARCHAR(max), ISNULL(FirstName,'N/A')), ',')  AS test 
FROM Person.Person;
-- ---------------------------
SELECT STRING_AGG(CONVERT(NVARCHAR(max), CONCAT(FirstName, ' ', LastName, '(', ModifiedDate, ')')), CHAR(13)) AS names 
FROM Person.Person;
-- ---------------------------
SELECT TOP (10) City,STRING_AGG(CONVERT(NVARCHAR(max), ISNULL(EA.EmailAddress,'N/A')), ',')
FROM Person.BusinessEntityAddress AS BEntityAddress  
INNER JOIN Person.Address AS A ON BEntityAddress.AddressID = A.AddressID
INNER JOIN Person.EmailAddress AS EA 
ON BEntityAddress.BusinessEntityID = EA.BusinessEntityID 
GROUP BY CITY
-- ---------------------------
SELECT jobtitle, REPLACE(JobTitle, 'Production Supervisor', 'Production Assistant') AS NewJob
	FROM humanresources.employee e 
	WHERE SUBSTRING(jobtitle,12,10)='Supervisor';
-- ---------------------------
SELECT pepe.firstname, pepe.middlename, pepe.lastname, huem.jobtitle
FROM person.person pepe
INNER JOIN humanresources.employee huem
ON pepe.businessentityid=huem.businessentityid
WHERE SUBSTRING(huem.jobtitle,1,5)='Sales';
-- ---------------------------
SELECT CONCAT(UPPER(RTRIM(LastName)) , ', ' , FirstName) AS Name  
FROM person.person  
ORDER BY LastName;
-- ---------------------------
SELECT p.FirstName, p.LastName, SUBSTRING(p.Title, 1, 25) AS Title,CAST(e.SickLeaveHours AS VARCHAR(1)) AS "Sick Leave"  
FROM HumanResources.Employee e JOIN Person.Person p 
    ON e.BusinessEntityID = p.BusinessEntityID  
WHERE NOT e.BusinessEntityID > 5;
-- ---------------------------
SELECT Name AS ProductName, ListPrice  
	FROM Production.Product
	WHERE ListPrice LIKE '33%'
-- ---------------------------
SELECT SalesYTD,CommissionPCT,CAST(ROUND(SalesYTD/CommissionPCT, 0) AS INT) AS Computed  
FROM Sales.SalesPerson   
WHERE CommissionPCT != 0;
-- ---------------------------
SELECT p.FirstName, p.LastName, saleP.SalesYTD, saleP.BusinessEntityID  
FROM Person.Person AS p   
JOIN Sales.SalesPerson AS saleP
    ON p.BusinessEntityID = saleP.BusinessEntityID  
WHERE CAST(CAST(saleP.SalesYTD AS INT) AS char(20)) LIKE '2%';
-- ---------------------------
SELECT  CAST(Name AS CHAR(16)) AS Name, ListPrice  
FROM production.Product  
WHERE Name LIKE 'Long-Sleeve Logo Jersey%';
-- ---------------------------
SELECT productid, UnitPrice,UnitPriceDiscount,  
       CAST(ROUND (UnitPrice*UnitPriceDiscount,0) AS int) AS DiscountPrice  
FROM sales.salesorderdetail  
WHERE SalesOrderid = 46672   
      AND UnitPriceDiscount > .02;
-- ---------------------------
SELECT AVG(VacationHours)AS "Average vacation hours",   
    SUM(SickLeaveHours) AS "Total sick leave hours"  
FROM HumanResources.Employee  
WHERE JobTitle LIKE 'Vice President%';
-- ---------------------------
SELECT TerritoryID, AVG(Bonus)as "Average bonus", 
SUM(SalesYTD) as "YTD sales"  
FROM Sales.SalesPerson  
GROUP BY TerritoryID;
-- ---------------------------
SELECT AVG(DISTINCT ListPrice)  
FROM Production.Product;
-- ---------------------------
SELECT BusinessEntityID, TerritoryID,
   DATEPART(YEAR,ModifiedDate) AS SalesYear,
   cast(SalesYTD as VARCHAR(20)) AS  SalesYTD,
   AVG(SalesYTD) OVER (PARTITION BY TerritoryID ORDER BY DATEPART(YEAR,ModifiedDate)) AS MovingAvg,
   SUM(SalesYTD) OVER (PARTITION BY TerritoryID ORDER BY DATEPART(YEAR,ModifiedDate)) AS CumulativeTotal
	FROM Sales.SalesPerson  
	WHERE TerritoryID IS NULL OR TerritoryID < 5  
	ORDER BY TerritoryID,SalesYear;
-- ---------------------------
SELECT BusinessEntityID, TerritoryID   
   ,DATEPART(YEAR,ModifiedDate) AS SalesYear  
   ,cast(SalesYTD as VARCHAR(20)) AS  SalesYTD  
   ,AVG(SalesYTD) OVER (ORDER BY DATEPART(year,ModifiedDate)) AS MovingAvg  
   ,SUM(SalesYTD) OVER (ORDER BY DATEPART(year,ModifiedDate)) AS CumulativeTotal  
FROM Sales.SalesPerson  
WHERE TerritoryID IS NULL OR TerritoryID < 5  
ORDER BY SalesYear;
-- ---------------------------
SELECT COUNT(DISTINCT jobTitle) as "Number of Jobtitles" 
FROM HumanResources.Employee;
-- ---------------------------
SELECT COUNT(*)  as "Number of Employees"
FROM HumanResources.Employee;
-- ---------------------------
SELECT COUNT(*) as counts, AVG(Bonus) as bonus
FROM Sales.SalesPerson  
WHERE SalesQuota > 25000;
-- ---------------------------
SELECT DISTINCT Name, 
        MIN(Rate) OVER (PARTITION BY edh.DepartmentID) AS MinSalary,
        MAX(Rate) OVER (PARTITION BY edh.DepartmentID) AS MaxSalary,
        AVG(Rate) OVER (PARTITION BY edh.DepartmentID) AS AvgSalary,
       COUNT(edh.BusinessEntityID) OVER (PARTITION BY edh.DepartmentID) AS EmployeesPerDept
	FROM HumanResources.EmployeePayHistory AS eph  
JOIN HumanResources.EmployeeDepartmentHistory AS edh  
     ON eph.BusinessEntityID = edh.BusinessEntityID  
JOIN HumanResources.Department AS d  
ON d.DepartmentID = edh.DepartmentID
WHERE edh.EndDate IS NULL  
ORDER BY Name;
-- ---------------------------
SELECT jobtitle,   
       COUNT(businessentityid) AS EmployeesInDesig  
FROM humanresources.employee e  
GROUP BY jobtitle  
HAVING COUNT(businessentityid) > 15;
-- ---------------------------
SELECT DISTINCT COUNT(Productid) OVER(PARTITION BY SalesOrderid) AS ProductCount  
    ,SalesOrderid  
FROM sales.salesorderdetail  
WHERE SalesOrderid IN (45363,45365);
-- ---------------------------
SELECT quotadate AS Year, datepart(quarter,quotadate) AS Quarter, SalesQuota,
	VAR(SalesQuota) OVER (ORDER BY datepart(year,quotadate), datepart(quarter,quotadate)) AS Variance
	FROM sales.salespersonquotahistory
	WHERE businessentityid = 277 AND datepart(year,quotadate) = 2012
-- ---------------------------
SELECT VAR(DISTINCT SalesQuota), VAR(SalesQuota) AS All_Values  
FROM sales.salespersonquotahistory;
-- ---------------------------
SELECT Color, SUM(ListPrice) as totalListprice, SUM(StandardCost) as totalStandardCost
FROM Production.Product  
WHERE Color IS NOT NULL   
    AND ListPrice > 0   
    AND Name LIKE 'Mountain%'  
GROUP BY Color  
ORDER BY Color;
-- ---------------------------
SELECT SalesQuota, SUM(SalesYTD) as "TotalSalesYTD" , 
GROUPING(SalesQuota) as "Grouping" 
FROM Sales.SalesPerson  
GROUP BY rollup(SalesQuota);
-- ---------------------------
SELECT Color, SUM(ListPrice)AS TotalList,   
       SUM(StandardCost) AS TotalCost  
FROM production.product  
GROUP BY Color  
ORDER BY Color;
-- ---------------------------