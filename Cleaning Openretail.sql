-- Cleaning Data 

-- 1. Remove Rows with Missing Data
DELETE FROM onlineretail
WHERE InvoiceNo IS NULL 
   OR StockCode IS NULL 
   OR Description IS NULL 
   OR Quantity IS NULL 
   OR InvoiceDate IS NULL 
   OR UnitPrice IS NULL 
   OR CustomerID IS NULL 
   OR Country IS NULL;
   
-- 2. Remove Invalid
DELETE FROM onlineretail
WHERE Quantity <= 0 OR UnitPrice <= 0;

-- 3. Remove Duplicate Rows
 
CREATE TABLE temp_retail AS
SELECT DISTINCT * FROM onlineretail;

DROP TABLE onlineretail;

RENAME TABLE temp_retail TO onlineretail;

-- 4. Convert InvoiceDate to DATETIME
ALTER TABLE onlineretail
ADD COLUMN InvoiceDate_clean DATETIME;

UPDATE onlineretail
SET InvoiceDate_clean = STR_TO_DATE(InvoiceDate, '%m/%d/%Y %H:%i');

ALTER TABLE onlineretail DROP COLUMN InvoiceDate;
ALTER TABLE onlineretail CHANGE InvoiceDate_clean InvoiceDate DATETIME;

SELECT *
FROM onlineretail;

-- 5. Add TotalPrice Column
ALTER TABLE online_retail ADD COLUMN TotalPrice DOUBLE;

UPDATE online_retail
SET TotalPrice = Quantity * UnitPrice;

-- 6. Standardize
UPDATE online_retail
SET Description = UPPER(TRIM(Description));

DELETE FROM online_retail
WHERE Description IN ('?', 'UNKNOWN', '', 'TEST');



