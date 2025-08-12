# Global_Tech_Salary_Project

![](https://github.com/DQuanBui/Global_Tech_Salary/blob/main/technology.webp)

## Project Overview
The Global Technology Salary Project explores over 145K job records across 416 unique tech positions and 96 countries, providing a comprehensive view of the technology job market. Using KNIME for cleaning, MySQL for advanced analysis, and Power BI for interactive visualizations, the project examines salaries, job demand, work types, experience levels, and geographic trends. This end-to-end analysis offers valuable insights into global pay patterns, market demand, and the evolving landscape of tech careers.

- **Dataset Link:** [Global Tech Salary Dataset](https://www.kaggle.com/datasets/adilshamim8/salaries-for-data-science-jobs/data)
- **SQL Scripts:** [Global Tech Salary SQL Scripts](https://github.com/DQuanBui/Global_Tech_Salary/blob/main/SQL_Queries_Answers/global_tech_salary_sql_queries.sql)
- **SQL Questions/Answers:** [Global Tech Salary SQL Questions/Answers](https://github.com/DQuanBui/Global_Tech_Salary/blob/main/SQL_Queries_Answers/GlobalTechSalary_SQL_Answers.pdf)
- **Power BI Dashboards:** [Global Tech Salary](https://github.com/DQuanBui/Global_Tech_Salary/blob/main/PowerBI_Dashboards.pdf)

## Architecture Overview
![](https://github.com/DQuanBui/Global_Tech_Salary/blob/main/ArchitectureOverview.png)

## Tools 
- Language: SQL
- Tools: MySQLWorkbench, KNIME, Power BI

## Dataset Overview
```sql 
-- Dataset Overview
SELECT 
	*
FROM 
	tech_salary;

-- Key Metrics Overview
SELECT
    COUNT(jobs) AS Total_Jobs,
    COUNT(DISTINCT jobs) AS Total_Unique_Positions,
    COUNT(DISTINCT employee_residence) AS Unique_Employee_Residence,
    COUNT(DISTINCT experience_level) AS Unique_Experience_Level,
    COUNT(DISTINCT employment_type) AS Unique_Employment_Type,
    COUNT(DISTINCT salary_bucket) AS Unique_Salary_Bucket,
    COUNT(DISTINCT work_type) AS Unique_Work_Type,
    COUNT(DISTINCT company_size) AS Unique_Company_Size,
    COUNT(DISTINCT company_location) AS Unique_Company_Location,
    COUNT(DISTINCT region) AS Unique_Region
FROM
	tech_salary;
```

## Objectives
- Analyze global job market dynamics by assessing salary trends, hiring demand, and role diversity across countries, company sizes, and experience levels.
- Leverage MySQL to perform advanced aggregations, comparisons, and growth analyses, uncovering key factors driving compensation differences.
- Clean and standardize 145K+ job records using KNIME to ensure a consistent, high-quality dataset for reliable analysis.
- Build 5 interactive Power BI dashboards that enable stakeholders to explore salary distributions, growth trends, and strategic hiring opportunities.

## Project Results
![](https://github.com/DQuanBui/Global_Tech_Salary/blob/main/PowerBI_Results/Overview.png)

![](https://github.com/DQuanBui/Global_Tech_Salary/blob/main/PowerBI_Results/Jobs.png)

![](https://github.com/DQuanBui/Global_Tech_Salary/blob/main/PowerBI_Results/Salary.png)

![](https://github.com/DQuanBui/Global_Tech_Salary/blob/main/PowerBI_Results/Location.png)

![](https://github.com/DQuanBui/Global_Tech_Salary/blob/main/PowerBI_Results/Details.png)

## Conclusion
The analysis reveals clear patterns in the global tech job market, including the dominance of senior-level and full-time roles, the competitive pay offered by large companies, and the significant salary advantages in leadership positions. High-demand roles like Data Scientist, Software Engineer, and Data Engineer continue to drive market growth, while specialized AI and data leadership positions command premium salaries. These insights can guide companies in competitive hiring strategies, inform professionals in career planning, and support policymakers in understanding global tech workforce trends.

## Contact
For any inquiries or questions regarding the project, please contact me at dbui10@fordham.edu
