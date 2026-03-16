SELECT * FROM ecommerce.hr_data;
USE ecommerce;

SELECT * FROM hr_data;

-- Employees older than 30
SELECT *
FROM hr_data
WHERE Age > 30;

-- Employees in Sales department
SELECT *
FROM hr_data
WHERE Department = 'Sales';

-- Average MonthlyIncome
SELECT AVG(MonthlyIncome) AS Avg_Salary
FROM hr_data;

-- Total employees in each department
SELECT Department, COUNT(*) AS Total_Employees
FROM hr_data
GROUP BY Department;

-- Employees who work overtime
SELECT *
FROM hr_data
WHERE OverTime = 'Yes';

-- Number of employees by gender
SELECT Gender, COUNT(*) AS Total_Employees
FROM hr_data
GROUP BY Gender;

-- Average salary per department
SELECT Department, AVG(MonthlyIncome) AS Avg_Salary
FROM hr_data
GROUP BY Department;

-- Top 5 highest paid employees
SELECT *
FROM hr_data
ORDER BY MonthlyIncome DESC
LIMIT 5;

-- Employees who left the company
SELECT COUNT(*) AS Employees_Left
FROM hr_data
WHERE Attrition = 'Yes';

-- Average age per job role
SELECT JobRole, AVG(Age) AS Avg_Age
FROM hr_data
GROUP BY JobRole;

-- Employees with >10 years experience and salary >15000
SELECT *
FROM hr_data
WHERE TotalWorkingYears > 10
AND MonthlyIncome > 15000;

-- Department with highest average salary
SELECT Department, AVG(MonthlyIncome) AS Avg_Salary
FROM hr_data
GROUP BY Department
ORDER BY Avg_Salary DESC
LIMIT 1;

-- Employees earning more than company average salary
SELECT *
FROM hr_data
WHERE MonthlyIncome >
(
SELECT AVG(MonthlyIncome)
FROM hr_data
);

-- Top 3 Highest Paid Employees per Department
WITH ranking_table AS (
SELECT *, RANK() OVER(PARTITION BY Department ORDER BY MonthlyIncome DESC) AS 'rnk'
FROM hr_data)
SELECT Department,MonthlyIncome,rnk FROM ranking_table
WHERE rnk<=3;

-- Department Salary Report Show for each department:Average salary, Maximum salary, Minimum salary, Total employees
SELECT Department,ROUND(AVG(MonthlyIncome), 2) AS 'Avg_salary',
ROUND(MAX(MonthlyIncome),2) AS 'Max_salary',
ROUND(MIN(MonthlyIncome),2) AS 'Min_salary',
ROUND(SUM(MonthlyIncome),2) AS 'Total_salary'
FROM hr_data
GROUP BY Department;

-- Find employees whose salary > department average salary.
SELECT *
FROM hr_data t1
WHERE t1.MonthlyIncome >
(
    SELECT AVG(t2.MonthlyIncome)
    FROM hr_data t2
    WHERE t1.Department = t2.Department
);

-- Find the second highest MonthlyIncome in every department.
WITH ranking_table AS(
SELECT Department,MonthlyIncome,
DENSE_RANK() OVER(PARTITION BY Department ORDER BY MonthlyIncome DESC) AS 'rnk'
FROM hr_data)
SELECT * FROM ranking_table
WHERE rnk = 2;

-- Find the department where most employees left the company.
SELECT Department,COUNT(*) FROM hr_data
WHERE Attrition = 'Yes'
GROUP BY Department
ORDER BY COUNT(*) DESC LIMIT 1;

SELECT 
    Department,
    ROUND(
        (SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100,
        2
    ) AS Attrition_rate
FROM hr_data
GROUP BY Department;

-- Difference between employee salary and department average salary
SELECT 
    JobRole,
    Department,
    MonthlyIncome,
    AVG(MonthlyIncome) OVER(PARTITION BY Department) AS Dept_Avg_Salary,
    MonthlyIncome - AVG(MonthlyIncome) OVER(PARTITION BY Department) AS Salary_Gap
FROM hr_data;

-- Calculate cumulative salary inside each department.
SELECT 
    Department,
    JobRole,
    MonthlyIncome,
    SUM(MonthlyIncome) OVER(
        PARTITION BY Department
        ORDER BY MonthlyIncome
    ) AS Running_Salary_Total   
FROM hr_data;


-- Find employees who: YearsAtCompany > 5, PerformanceRating >= 4 and JobLevel < 4
SELECT YearsAtCompany,PerformanceRating, JobLevel FROM hr_data
WHERE YearsAtCompany > 5 AND PerformanceRating >=4 AND JobLevel < 4;

-- Calculate male vs female ratio per department.
SELECT Department , Gender, COUNT(*) FROM hr_data
GROUP BY Department , Gender;

-- High Salary but Low Satisfaction
SELECT * FROM (
SELECT Department,MonthlyIncome,JobSatisfaction,
AVG(MonthlyIncome) OVER(PARTITION BY Department) AS 'Avg_salary'
FROM hr_data) T1
WHERE MonthlyIncome > Avg_salary AND JobSatisfaction <=2;

-- Find employees whose salary is greater than 2× department average.
SELECT * FROM (
SELECT Department,MonthlyIncome,JobSatisfaction,
AVG(MonthlyIncome) OVER(PARTITION BY Department) AS 'Avg_salary'
FROM hr_data) T1
WHERE MonthlyIncome > 2*(Avg_salary);

-- Rank employees by experience
SELECT Department, JobRole, MonthlyIncome, TotalWorkingYears,
RANK() OVER(PARTITION BY Department ORDER BY TotalWorkingYears DESC)
FROM hr_data;

-- Previous Salary Comparison
-- Show salary difference using: LAG(MonthlyIncome)
 SELECT MonthlyIncome, LAG(MonthlyIncome) OVER(),
MonthlyIncome -  LAG(MonthlyIncome) OVER()
FROM hr_data;

