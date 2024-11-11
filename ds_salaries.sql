create database salaries;
use salaries;
select * from ds_salaries;

-- Windows function:
-- 1)Row_number()
-- 2)rank()
-- 3)Dense_rank()
-- 4) AGGREGATE FUNCTIONS: MIN()/MAX()/AVG()/SUM()
-- 5)value functions:
	-- * lag():comparing with previous values
    -- * lead():comparing with future values
	-- * first_value():comparing with firt value/initial values
	-- * last_value():comparing with last value/current values
    -- * nth_value():comparing with nth value


/* Q: How can we assign a unique rank to each employee within their job title,
 based on salary (in USD) in descending order,to identify the top earners in each role? */
 
SELECT work_year,job_title,salary,salary_in_usd,company_size,
ROW_NUMBER() OVER(PARTITION BY job_title ORDER BY salary_in_usd DESC) AS ROW_NUM
FROM ds_salaries;

/* Q: How can we rank employees based on their salary within each company size, allowing for tied salaries,
 to understand salary hierarchy within companies of different sizes? */
 
SELECT work_year, company_size, job_title, salary_in_usd,salary,
RANK() OVER(PARTITION BY company_size ORDER BY salary DESC) AS SALARY_RANK
FROM ds_salaries;

/* Q: What is the ranking of employees’ salaries within each company location, 
without gaps in ranking numbers, to identify the top earners in each location?  */

SELECT work_year, company_location, job_title, salary_in_usd,
DENSE_RANK() OVER(PARTITION BY company_location ORDER BY salary_in_usd DESC) AS RANKING
FROM ds_salaries;


/* Q: What are the minimum, maximum, average, and total salaries for each employment type,
 to understand salary distribution across different employment arrangements? */

SELECT employment_type, salary,
MIN(salary) OVER(PARTITION BY employment_type) AS MINIMUM_SALARY,
MAX(salary) OVER(PARTITION BY employment_type) AS MAXIMUM_SALARY,
AVG(salary) OVER(PARTITION BY employment_type) AS AVERAGE_SALARY,
SUM(salary) OVER(PARTITION BY employment_type) AS TOTAL_SALARY
FROM ds_salaries;


/* Q: How can we compare each employee’s salary with the previous employee’s salary 
within the same job title to observe salary progression within roles? */

SELECT work_year, job_title, salary_in_usd,
LAG(salary_in_usd,1,0) OVER(PARTITION BY job_title ORDER BY salary_in_usd) AS PREVIOUS_SAALRY
FROM ds_salaries;

/* Q: How can we view each employee’s salary alongside the salary of the next employee within the same experience level,
 to anticipate salary progression within experience tiers? */

SELECT work_year, experience_level, salary,
LEAD(salary,1,0) OVER(PARTITION BY experience_level ORDER BY salary) AS FUTURE_SALARY
FROM ds_salaries;

/* Q: How can we retrieve the first (minimum) salary recorded
 for each company location to determine the base salary level in each location? */

SELECT work_year, company_location, salary_in_usd,
FIRST_VALUE(salary_in_usd) OVER(PARTITION BY company_location ORDER BY salary_in_usd) AS FIRST_SALARY
FROM ds_salaries;

/* Q: How can we retrieve the last (maximum) salary 
in each company size group to see the highest salary level offered across different company sizes? */

SELECT work_year,job_title, company_size, salary_in_usd,
LAST_VALUE(salary_in_usd) OVER(PARTITION BY company_size ORDER BY salary_in_usd RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) 
AS LAST_SALARY  FROM ds_salaries;

/* Q: How can we identify the third-highest salary within each experience level
 to understand mid-tier salaries across experience categories? */
 
SELECT work_year, experience_level, salary,
NTH_VALUE(salary,3) OVER(PARTITION BY experience_level ORDER BY salary DESC  range between unbounded preceding and unbounded following) 
AS THIRD_SALARY FROM ds_salaries;

-- SPECIAL OPERATORS:
-- 1.IN
-- 2.NOT IN
-- 3.BETWEEN
-- 4.NOT BETWEEN
-- 5.IS NULL
-- 6.IS NOT NULL
-- 7.LIKE:
-- 8.NOT LIKE
-- 9.AS
-- 10.DISTINCT:TO ACCESS UNIQUE VALUE
-- 11.ANY

select * from ds_salaries;
-- Q: How can we retrieve information for employees with specific job titles, such as "Data Scientist" and "Data Analyst"?

SELECT work_year, job_title, salary_in_usd, company_size
FROM ds_salaries
WHERE job_title IN ('Data Scientist', 'Data Analyst');

-- Q: How can we find employees who do not have certain job titles, like "Data Analyst" or "Machine Learning Engineer"?

SELECT work_year, job_title, salary_in_usd, company_size
FROM ds_salaries
WHERE job_title NOT IN ('Data Analyst', 'Machine Learning Engineer');

-- Q: Which employees have salaries (in USD) between 50,000 and 100,000?

SELECT work_year, job_title, salary_in_usd, employee_residence
FROM ds_salaries
WHERE salary_in_usd BETWEEN 50000 AND 100000;

-- Q: Which employees have salaries (in USD) that are not in the range of $60,000 to $120,000?

SELECT work_year, job_title, salary_in_usd, employee_residence
FROM ds_salaries
WHERE salary_in_usd NOT BETWEEN 60000 AND 120000;

-- Q: Which records have missing salary information?

SELECT work_year, job_title, salary, salary_in_usd
FROM ds_salaries
WHERE salary IS NULL OR salary_in_usd IS NULL;

-- Q: Which records have valid (non-missing) salary information?

SELECT work_year, job_title, salary, salary_in_usd
FROM ds_salaries
WHERE salary IS NOT NULL AND salary_in_usd IS NOT NULL;

-- Q: How can we find job titles that start with the word "Data"?

SELECT work_year, job_title, salary_in_usd, company_location
FROM ds_salaries
WHERE job_title LIKE 'Data%';

-- Q: Which job titles do not contain the word "Engineer"?

SELECT work_year, job_title, salary_in_usd, company_location
FROM ds_salaries
WHERE job_title NOT LIKE '%Engineer%';

-- Q: How can we rename the salary_in_usd column as usd_salary in the results?

SELECT work_year, job_title, salary_in_usd AS usd_salary, company_size
FROM ds_salaries;

-- Q: What are the unique job titles available in the dataset?

SELECT DISTINCT job_title FROM ds_salaries;

-- Q: Which employees have a salary greater than any of the salaries offered for "Data Analyst" roles?

SELECT work_year, job_title, salary_in_usd, company_location
FROM ds_salaries
WHERE salary_in_usd > ANY (SELECT salary_in_usd FROM ds_salaries WHERE job_title = 'Data Analyst');