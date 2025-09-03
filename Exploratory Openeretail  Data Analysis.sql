SELECT *
FROM onlineretail;

SELECT COUNT(*) AS TotalRows
FROM onlineretail;

SELECT MIN(InvoiceDate) AS FirstDate, MAX(InvoiceDate) AS LastDate
FROM onlineretail;

SELECT COUNT(DISTINCT InvoiceNo) AS UniqueInvoices 
FROM onlineretail;

SELECT COUNT(DISTINCT CustomerID) AS UniqueCustomers
FROM onlineretail
WHERE CustomerID IS NOT NULL;

SELECT COUNT(DISTINCT StockCode) AS UniqueProducts 
FROM onlineretail;

SELECT COUNT(DISTINCT Country) AS CountryCount 
FROM onlineretail;

-- Revenue Analysis
SELECT ROUND(SUM(Quantity * UnitPrice), 2) AS TotalRevenue
FROM onlineretail;

SELECT ROUND(SUM(Quantity * UnitPrice) / COUNT(DISTINCT InvoiceNo), 2) AS AvgOrderValue
FROM onlineretail;

SELECT Country, ROUND(SUM(Quantity * UnitPrice), 2) AS Revenue
FROM onlineretail
GROUP BY Country
ORDER BY Revenue DESC
LIMIT 10;

-- Time-Based Analysis
SELECT DATE_FORMAT(InvoiceDate, '%Y-%m') AS Month, 
      ROUND(SUM(Quantity * UnitPrice), 2) AS Revenue
FROM onlineretail
GROUP BY Month
ORDER BY Month;


SELECT DATE(InvoiceDate) AS Date, 
       ROUND(SUM(UnitPrice), 2) AS Revenue
FROM onlineretail
GROUP BY Date
ORDER BY Date;

SELECT HOUR(InvoiceDate) AS HourOfDay, 
       ROUND(SUM(UnitPrice), 2) AS Revenue
FROM onlineretail
GROUP BY HourOfDay
ORDER BY HourOfDay;

-- Product Analysis
SELECT Description, SUM(Quantity) AS TotalSold
FROM onlineretail
GROUP BY Description
ORDER BY TotalSold DESC
LIMIT 10;

SELECT Description, ROUND(SUM(UnitPrice), 2) AS Revenue
FROM onlineretail
GROUP BY Description
ORDER BY Revenue DESC
LIMIT 10;

SELECT Description, SUM(Quantity) AS TotalReturned
FROM onlineretail
WHERE Quantity < 0
GROUP BY Description
ORDER BY TotalReturned DESC
LIMIT 10;


-- Customer Behavior
SELECT CustomerID, COUNT(DISTINCT InvoiceNo) AS OrdersCount
FROM onlineretail
GROUP BY CustomerID
ORDER BY OrdersCount DESC
LIMIT 10;

SELECT CustomerID, ROUND(SUM(UnitPrice), 2) AS TotalSpent
FROM onlineretail
GROUP BY CustomerID
ORDER BY TotalSpent DESC
LIMIT 10;

