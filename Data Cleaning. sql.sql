-- SQL Project-- Data Cleaning

-- Skill used  : Windows Function, CTE's, Self Joins, String Functions, Filtering Functions

SELECT *
FROM layoffs;

-- first thing we want to do is create staging table. This is one we will work in and clean the data . we want table with the raw data in case something happens

CREATE TABLE layoffs_staging
LIKE layoffs;

-- 1. Remove Duplicate
-- 2. Standerdize The Data
-- 3. Null Values Or blank values
-- 4. Remove Any Columns

INSERT INTO layoffs_staging
SELECT *
FROM layoffs

-- 1. Remove Duplicates

# FIRST lets check for duplicates

SELECT *
FROM layoffs_staging;

SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

-- these are the ones we want to delete where the row number is > 1 or 2 or greater essentially
WITH  duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num >1;


-- one solution which i think good one  is create a new column  and add the number in. Then delete where row numbers are over 2 then delete the column
-- so let's do it

ALTER TABLE layoffs_staging ADD row_num INT;
  
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL, 
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

-- now that we have this  we can delete row were row_num is greater then 2

DELETE 
FROM layoffs_staging2
WHERE row_num > 1;

-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- 2. Standerdize Data

SELECT company
FROM layoffs_staging2;

SELECT company , TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

-- I also noticed the Crypto has multiple different variations. WE need to standardize that - let's say all to Crypto

SELECT DISTINCT industry
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';


-- Let's fix the date column
SELECT `date` ,STR_TO_DATE(`date` , '%m/%d/%Y')
FROM layoffs_staging2;

-- we  can use str to date to update this field
UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date` , '%m/%d/%Y');

-- now we can convert the data type properly
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- We have some  "United States" and some "United states." with a period at the end. Let's standerdize this

SELECT DISTINCT COUNTRY
FROM layoffs_staging2
WHERE country LIKE 'United states%';

SELECT DISTINCT country , TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
WHERE country LIKE 'United States%';

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- now if we run this again it is fixed
SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

  -- if we look at industry is look  like we some null and empty rows, let's take a look at these

SELECT  DISTINCT industry
FROM layoffs_staging2
WHERE industry IS NULL
AND industry = '';

-- let's take a look at these

SELECT *
FROM layoffs_sstaging2
WHERE company LIKE 'Bally%';

-- nothing wrong here 

SELECT *
FROM layoffs_staging2
WHERE company LIKE 'airbnb%';

-- it look like airbnb is travel, but this one just isn't populated
--write a query that if there is another row with the same company name, it will update it to the non-null industry values
--make it easy so if there were thousands we wound't have manually check them all

-- we should set blanks to nulls since those are typically easser to work with

UPDATE layoffs_staging2
SET industry = null
WHERE industry = '';

-- now if we check those are all null
SELECT *
FROM layoffs_staging
WHERE industry IS NULL
OR industry = ''
ORDER BY industry;

SELECT *
FROM layoffs_staging2
WHERE company = 'airbnb';

SELECT t1.industry , t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL;

-- now we need to pupulate those null if possible 

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL;

-- and if we check it looks Bally's was the only one without populated row to populate this null values

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = ''
ORDER BY industry;


-- 3. Look at null Values
-- the null values in total_laid_off, percentage_laid_off and funds_raised_millions all look normal. i don't think i want to change that
-- I like having them null because it make it eassier for calculation during the EDA phase

-- so there isn't anything i want to change with null values


-- 4 Remove any column and rows we need to

SELECT *
FROM layoffs_staging2
WHERE total_laid_off is NULL
AND percentage_laid_off IS NULL;

-- Delete Uselase data we can't really use 
DELETE 
FROM layoffs_staging2
WHERE total_laid_off is NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;
