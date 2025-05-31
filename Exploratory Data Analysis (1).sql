-- Exploratory Data Analysis

-- Here we are just going to explorethe data and find or petterns or anything interesting like outliers

-- Normally when you start the EDA process you have some ideas of what you're looking for

-- with this info we are just going to look around see what we find!

-- SKILL use : Aggregate Functions, CTE, Sorting,  Windows Function, String Functions

SELECT *
FROM layoffs_staging2;

-- EASIER QUERIES
-- Looking at percentage to see how big these layoffs were

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

-- Companies with the biggest single layoffs

SELECT Company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company 
ORDER BY 2 DESC;

SELECT MIN(`date`) , MAX(`date`)
FROM layoffs_staging2;

-- this is total in the past 3 years or in the dataset

SELECT industry ,SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry 
ORDER BY 2 DESC;

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country 
ORDER BY 2 DESC;

SELECT  YEAR(`date`) , SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`) 
ORDER BY 1 DESC;

SELECT stage , SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage 
ORDER BY 2 DESC;

SELECT company , SUM(percentage_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT company , AVG(percentage_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- Rolling Total of Layoffs Per Month
SELECT SUBSTRING(`date`, 1, 7) AS `MONTH` , SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7)  IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;

-- now use it in a CTE so we can query off of it

WITH Rolling_Total  AS
(
SELECT SUBSTRING(`date` , 1, 7 ) AS `MONTH` , SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date` , 1, 7 )  IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH` , total_off,
SUM(total_off) OVER(ORDER BY `MONTH` ) AS rolling_total
FROM Rolling_Total;

-- TOUGHER QUERIES
-- Earlier we looked at companies with most layoffs. Now let's  look at that per year. It's a little more difficult
-- We also look for Rolling Total Per Month 
-- I want to look at

SELECT company , SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company 
ORDER BY 2 DESC;

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company , YEAR(`date`)
ORDER BY 3 DESC;

WITH Company_Year (company, years, total_laid_off) AS 
(
SELECT company , YEAR(`date`), SUM(Total_laid_off)
FROM layoffs_staging2
GROUP BY company , YEAR(`date`) 
), Company_Year_Rank AS 
(
SELECT *,
DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5 ;
