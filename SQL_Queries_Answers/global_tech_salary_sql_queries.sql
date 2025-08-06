-- SQL Scripts for Global Technology Salary Project
-- Author: Dang Quan Bui

USE global_tech_salary;

-- Look at the database to understand the key metrics
SELECT 
	* 
FROM 
	tech_salary;
    
-- ========================
-- PART 1: OVERVIEW SUMMARY
-- ========================

-- 1.1: Look at the Total Number of Jobs
SELECT 
	COUNT(*) as Total_Jobs
FROM 
	tech_salary;
    
-- 1.2: Look at the Total Number of Unique Positions
SELECT 
	COUNT(DISTINCT jobs) AS Total_Unique_Positions
FROM 
	tech_salary;
    
-- 1.3: Look at all the Unique Positions
SELECT 
	DISTINCT jobs AS Position
FROM 
	tech_salary;
    
-- 1.4: Look at the Total Jobs by Work Type
SELECT 
	work_type, 
    COUNT(*) AS Total_Jobs
FROM 
	tech_salary 
GROUP BY 
	work_type
ORDER BY 
	Total_Jobs DESC;
    
-- 1.5: Look at the Total Jobs by Employment Type
SELECT 
	employment_type, 
    COUNT(*) AS Total_Jobs
FROM 
	tech_salary 
GROUP BY 
	employment_type
ORDER BY 
	Total_Jobs DESC;
    
-- 1.6: Look at the Total Jobs by Experience Level
SELECT 
	experience_level, 
    COUNT(*) AS Total_Jobs
FROM 
	tech_salary 
GROUP BY 
	experience_level
ORDER BY 
	Total_Jobs DESC;
    
-- 1.7: Look at the Total Jobs by Company Size
SELECT 
	company_size, 
    COUNT(*) AS Total_Jobs
FROM 
	tech_salary 
GROUP BY 
	company_size
ORDER BY 
	Total_Jobs DESC;
    
-- 1.8: Look at the Top 10 Countries with the Most Number of Jobs
SELECT
	company_location, 
    COUNT(*) AS Total_Jobs 
FROM 
	tech_salary 
GROUP BY 
	company_location 
ORDER BY 
	Total_Jobs DESC
LIMIT 10;

-- 1.9: Look at the Top 10 Most Common Jobs
SELECT 
	jobs, 
    COUNT(*) AS Total_Jobs
FROM 
	tech_salary
GROUP BY 
	jobs
ORDER BY 
	Total_Jobs DESC
LIMIT 10;

-- =======================
-- PART 2: SALARY ANALYSIS
-- =======================

-- 2.1: Look at the Average Salary of All Jobs
SELECT 
	ROUND(AVG(annual_salary), 0) AS Average_Salary 
FROM 
	tech_salary;
    
-- 2.2: Look at the Average Salary by Experience Level
SELECT 
	experience_level, 
    ROUND(AVG(Annual_Salary), 0) AS Average_Salary 
FROM 
	tech_salary 
GROUP BY 
	experience_level
ORDER BY 
	Average_Salary DESC;
    
-- 2.3: Look at the Average Salary by Company Size
SELECT 
	company_size, 
    ROUND(AVG(Annual_Salary), 0) AS Average_Salary
FROM 
	tech_salary 
GROUP BY 
	company_size
ORDER BY 
	Average_Salary DESC;
    
-- 2.4: Look at the Top 10 Highest-Paying Jobs (by Average)
SELECT 
	jobs, 
    ROUND(AVG(Annual_Salary), 0) AS Average_Salary 
FROM 
	tech_salary 
GROUP BY 
	jobs 
ORDER BY 
	Average_Salary DESC 
LIMIT 10;

-- 2.5: Look at the Most Common Salary Bucket per Job Title
WITH bucket_salary AS (
    SELECT 
		jobs, 
        salary_bucket, 
        COUNT(*) AS Total_Jobs,
		ROW_NUMBER() OVER (PARTITION BY jobs ORDER BY COUNT(*) DESC) AS ranking
    FROM 
		tech_salary
    GROUP BY 
		jobs, 
        salary_bucket
)
SELECT 
	jobs, 
    salary_bucket, 
    Total_Jobs
FROM 
	bucket_salary
WHERE 
	ranking = 1
ORDER BY 
	Total_Jobs DESC;
    
-- 2.6: Look at Job Titles That Are Most Likely to Be Remote and Highly Paid
SELECT 
	jobs, 
    COUNT(*) AS Total_Jobs, 
    ROUND(AVG(Annual_Salary), 0) AS Average_Remote_Salary
FROM 
	tech_salary
WHERE 
	work_type = 'Remote'
GROUP BY 
	jobs
HAVING 
	COUNT(*) >= 5
ORDER BY 
	Average_Remote_Salary DESC,
    Total_Jobs DESC
LIMIT 10;

-- 2.7: Look at Top 10 Job Titles That Are Paid Below Average in Most Countries
WITH country_avg AS (
  SELECT 
	company_location, 
    AVG(annual_salary) AS loc_avg
  FROM 
	tech_salary
  GROUP BY 
	company_location
),
job_vs_avg AS (
  SELECT 
	t.jobs, 
    t.company_location, 
    t.annual_salary, 
    c.loc_avg
  FROM 
	tech_salary t
  JOIN country_avg c 
  ON t.company_location = c.company_location
)
SELECT 
	jobs, 
    COUNT(*) AS Total_Jobs
FROM 
	job_vs_avg
WHERE 
	annual_salary < loc_avg
GROUP BY 
	jobs
ORDER BY 
	Total_Jobs DESC
LIMIT 10;

-- 2.8: Look at Job Titles with the Largest Difference in Salary Between Company Size Categories
WITH size_salary AS (
  SELECT 
	jobs, 
    company_size, 
    ROUND(AVG(Annual_Salary), 0) AS average_salary
  FROM 
	tech_salary
  GROUP BY 
	jobs, 
    company_size
),
pivoted AS (
  SELECT 
	jobs,
	MAX(CASE WHEN Company_Size = 'Small' THEN average_salary END) AS small,
	MAX(CASE WHEN Company_Size = 'Medium' THEN average_salary END) AS medium,
	MAX(CASE WHEN Company_Size = 'Large' THEN average_salary END) AS large
  FROM 
	size_salary
  GROUP BY 
	jobs
)
SELECT 
	jobs,
	COALESCE(large, 0) - COALESCE(small, 0) AS salary_difference_large_vs_small
FROM 
	pivoted
WHERE 
	large IS NOT NULL 
    AND small IS NOT NULL
ORDER BY 
	salary_difference_large_vs_small DESC
LIMIT 10;

-- ============================
-- PART 3: TIME TRENDS & GROWTH
-- ============================

-- 3.1: Look at the Year-over-Year Salary Growth for Each Job
WITH job_yearly_average AS (
  SELECT 
	Jobs, 
    Work_Year, 
    ROUND(AVG(Annual_Salary), 0) AS Average_Salary
  FROM 
	tech_salary
  GROUP BY 
	Jobs, 
    Work_Year
),
salary_growth AS (
  SELECT 
	*,
	LAG(average_salary) OVER (PARTITION BY Jobs ORDER BY Work_Year) AS Prev_Year_Salary,
	ROUND(average_salary - LAG(average_salary) OVER (PARTITION BY Jobs ORDER BY Work_Year), 0) AS Salary_Change
  FROM 
	job_yearly_average
)
SELECT 
	* 
FROM 
	salary_growth
WHERE 
	prev_year_salary IS NOT NULL;
    
-- 3.2: Look at the Top 10 Jobs with Biggest Salary Change Across Years
WITH yearly_average AS (
    SELECT 
		jobs, 
        work_Year, 
        AVG(annual_salary) AS Average_Salary
    FROM 
		tech_salary
    GROUP BY 
		jobs, 
        work_year
),
salary_difference AS (
    SELECT 
		jobs, 
        ROUND(MAX(average_salary) - MIN(average_salary), 0) AS salary_change
    FROM 
		yearly_average
    GROUP BY
		jobs
)
SELECT 
	* 
FROM 
	salary_difference
ORDER BY 
	salary_change DESC
LIMIT 10;

-- 3.3: Look at the Jobs Where Salary Has Consistently Increased Every Year
WITH job_trends AS (
  SELECT 
	jobs, 
    work_year, 
    ROUND(AVG(Annual_Salary), 0) AS average_salary
  FROM 
	tech_salary
  GROUP BY 
	jobs, work_year
),
ranked_trends AS (
  SELECT 
	*, 
	LAG(average_salary) OVER (PARTITION BY jobs ORDER BY work_year) AS previous_salary
  FROM 
	job_trends
)
SELECT 
	jobs
FROM 
	ranked_trends
WHERE 
	previous_salary IS NOT NULL 
    AND average_salary > previous_salary
GROUP BY 
	jobs
HAVING 
	COUNT(*) >= 2;

-- 3.4: Look at the Top 3 Highest-Paid Jobs in Each Year
SELECT 
	*
FROM (
  SELECT 
	Jobs, 
    Work_Year, 
    Annual_Salary,
	RANK() OVER (PARTITION BY Work_Year ORDER BY Annual_Salary DESC) AS salary_rank
  FROM 
	tech_salary
) AS ranked
WHERE 
	salary_rank <= 3
ORDER BY 
	Work_Year DESC;
    
-- 3.5: Look at the Fastest Growing Job Titles Over the Years (by Job Count Growth)
WITH job_year_count AS (
  SELECT 
	jobs, 
    work_year, 
    COUNT(*) AS total_jobs
  FROM 
	tech_salary
  GROUP BY 
	jobs, 
    work_year
),
growth_calc AS (
  SELECT 
	*,
	LAG(total_jobs) OVER (PARTITION BY jobs ORDER BY work_Year) AS previous_total_jobs,
	total_jobs - LAG(total_jobs) OVER (PARTITION BY jobs ORDER BY work_year) AS growth
  FROM 
	job_year_count
)
SELECT 
	jobs, 
    work_Year, 
    previous_total_jobs, 
    total_jobs, 
    growth
FROM 
	growth_calc
WHERE 
	previous_total_jobs IS NOT NULL
ORDER BY 
	growth DESC
LIMIT 10;

-- ============================================
-- PART 4: STRATEGIC BUSINESS & REMOTE INSIGHTS
-- ============================================

-- 4.1: Look at the Company Sizes That Offer the Most Remote Jobs
SELECT 
	company_size, 
    COUNT(*) AS Total_Jobs
FROM 
	tech_salary
WHERE 
	work_type = 'Remote'
GROUP BY 
	company_size
ORDER BY 
	Total_Jobs DESC;
    
-- 4.2: Look at the Top 3 Highest-Paid Roles per Employment Type
SELECT 
	*
FROM (
    SELECT 
		jobs, 
        employment_type, 
        annual_salary,
		RANK() OVER (PARTITION BY employment_type ORDER BY annual_salary DESC) AS ranking
    FROM 
		tech_salary
) AS ranked
WHERE 
	ranking <= 3;
    
-- 4.3: Look at job titles showing the clearest Salary Progression across all experience levels (Entry-level → Mid-level → Senior-level → Director)
WITH exp_salary AS (
  SELECT 
	jobs, 
    experience_level, 
    ROUND(AVG(Annual_Salary), 0) AS average_salary
  FROM 
	tech_salary
  GROUP BY 
	jobs, 
    experience_level
),
pivoted AS (
  SELECT 
	Jobs,
	MAX(CASE WHEN Experience_Level = 'Entry-level' THEN average_salary END) AS entry_level,
	MAX(CASE WHEN Experience_Level = 'Mid-level' THEN average_salary END) AS mid_level,
	MAX(CASE WHEN Experience_Level = 'Senior-level' THEN average_salary END) AS senior_level,
	MAX(CASE WHEN Experience_Level = 'Director' THEN average_salary END) AS director_level
  FROM 
	exp_salary
  GROUP BY 
	jobs
)
SELECT 
	jobs, 
    entry_level, 
    mid_level, 
    senior_level, 
    director_level
FROM 
	pivoted
WHERE 
	entry_level IS NOT NULL 
    AND mid_level IS NOT NULL 
    AND senior_level IS NOT NULL 
    AND director_level IS NOT NULL
	AND mid_level > entry_level 
	AND senior_level > mid_level 
	AND director_level > senior_level
ORDER BY 
	director_level DESC
LIMIT 10;

-- =====================================
-- THE END OF GLOBAL TECH SALARY PROJECT
-- =====================================