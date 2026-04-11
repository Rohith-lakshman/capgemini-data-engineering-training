CREATE TABLE Employee (
emp_id INT PRIMARY KEY,
emp_name VARCHAR(50),
department VARCHAR(50),
salary DECIMAL(10, 2),
joining_date DATE
);
INSERT INTO Employee (emp_id, emp_name, department, salary, joining_date) VALUES
(1, 'Karthik', 'HR', 60000.00, '2021-01-15'),
(2, 'Pratik', 'Finance', 70000.00, '2021-03-10'),
(3, 'Veer', 'HR', 55000.00, '2021-06-20'),
(4, 'Priya', 'Finance', 80000.00, '2022-01-05'),
(5, 'Ajay', 'Engineering', 75000.00, '2020-11-01'),
(6, 'Vijay', 'Engineering', 78000.00, '2019-05-22'),
(7, 'Veena', 'HR', 62000.00, '2023-03-12'),
(8, 'Meena', 'Marketing', 65000.00, '2022-08-18');

CREATE TABLE Sales (
sales_id INT PRIMARY KEY,
emp_id INT,
product VARCHAR(50),
amount DECIMAL(10, 2),
sale_date DATE
);
INSERT INTO Sales (sales_id, emp_id, product, amount, sale_date) VALUES
(1, 1, 'Laptop', 50000.00, '2023-01-15'),
(2, 2, 'Mobile', 30000.00, '2023-02-18'),
(3, 3, 'Tablet', 20000.00, '2023-02-25'),
(4, 4, 'Laptop', 45000.00, '2023-03-05'),
(5, 5, 'Mobile', 35000.00, '2023-03-12'),
(6, 6, 'Tablet', 25000.00, '2023-03-20'),
(7, 7, 'Laptop', 60000.00, '2023-04-01'),
(8, 8, 'Mobile', 40000.00, '2023-04-10');


-- 1. Find the total salary for each department in the Employee table.
SELECT 
    SUM(salary) AS total_salary, 
    department 
FROM Employee 
GROUP BY department; 

-- 2. Count the number of employees in each department.
SELECT 
    COUNT(emp_id) AS emp_count, 
    department 
FROM Employee 
GROUP BY department;

-- 3. Calculate the average salary of employees in each department.
SELECT
    AVG(salary) as avg_salary,
    department
FROM Employee
GROUP BY department;

-- 4. Find the maximum salary in each department.
SELECT
    max(salary) as max_salary,
    department
FROM Employee
GROUP BY department;

-- 5. Find the minimum salary in each department.
SELECT
    min(salary) as min_salary,
    department
FROM Employee
GROUP BY department;

-- 6. Find the total salary for departments where the total salary exceeds 100,000.
SELECT 
    SUM(salary) AS total_salary, 
    department 
FROM Employee 
GROUP BY department
HAVING total_salary > 100000;

-- 7. Count the number of employees in departments with more than 2 employees.
SELECT 
    COUNT(emp_id) AS emp_count, 
    department 
FROM Employee 
GROUP BY department
HAVING emp_count > 2;

-- 8. Calculate the average salary for employees who joined after 2021-01-01, grouped by department.
SELECT
    AVG(salary) as avg_salary,
    department
FROM Employee
WHERE joining_date > '2021-01-01'
GROUP BY department;

-- 9. Find the departments where the maximum salary is greater than 75,000.
SELECT
    max(salary) as max_salary,
    department
FROM Employee
GROUP BY department
HAVING max_salary > 75000;

-- 10. List the departments where the total salary is less than 150,000.GROUP BY with HAVING
SELECT 
    SUM(salary) AS total_salary, 
    department 
FROM Employee 
GROUP BY department
HAVING total_salary < 150000; 

-- 11. Find the total number of employees grouped by department, but only include departments with more than 1 employee.
SELECT 
    COUNT(emp_id) AS emp_count, 
    department 
FROM Employee 
GROUP BY department
HAVING emp_count > 1;

-- 12. Calculate the total salary of each department and show only those where the total exceeds 125,000
SELECT 
    SUM(salary) AS total_salary, 
    department 
FROM Employee 
GROUP BY department
HAVING total_salary > 125000; 

-- 13. Count the number of employees in each department, but include only departments with more than 2 employees.
SELECT 
    COUNT(emp_id) AS emp_count, 
    department 
FROM Employee 
GROUP BY department
HAVING emp_count > 2;

-- 14. Find the average salary in each department where the average salary is above 60,000.
SELECT
    AVG(salary) as avg_salary,
    department
FROM Employee
GROUP BY department
HAVING avg_salary > 60000;

-- 15. Show departments where the sum of salaries is between 100,000 and 200,000. GROUP BY 

SELECT 
    SUM(salary) AS total_salary, 
    department 
FROM Employee 
GROUP BY department
HAVING total_salary between 100000 and 200000;

-- 16. Find the total sales amount for each employee.
SELECT
    e.emp_name,
    sum(s.amount) as total_sales
 FROM Employee e
 Join Sales s ON e.emp_id=s.emp_id
 GROUP BY e.emp_id,e.emp_name;
 
 -- 17. List the number of sales made by each employee.
 SELECT 
     e.emp_name,
     count(s.sales_id) as toal_count
 from Employee e
 JOIN Sales s ON e.emp_id=s.emp_id
 GROUP BY e.emp_id,e.emp_name;
 
 -- 18. Find the total sales amount grouped by product.
 SELECT
    product,
    sum(amount) as total_amount
FROM Sales
Group by product;

-- 19. Calculate the average sales amount grouped by product.
 SELECT
    product,
    avg(amount) as total_amount
FROM Sales
Group by product;

 -- 20. Find employees who have made more than 2 sales, grouped by their names. 
SELECT 
    e.emp_name, 
    COUNT(s.sales_id) AS sales_count
FROM Employee e
JOIN Sales s ON e.emp_id = s.emp_id
GROUP BY e.emp_id, e.emp_name
HAVING sales_count >= 2;

-- 21. Calculate the total salary and total sales amount for each employee.
SELECT 
    sum(e.salary) AS "total_salay",
    sum(s.amount) as "total_amount"
from Employee e
JOIN Sales s ON e.emp_id=s.emp_id
GROUP BY e.emp_id,e.emp_name;

-- 22. Count the number of unique products sold by each employee.
SELECT 
    e.emp_name,
    count(DISTINCT s.product) as unique_products
from Employee e
JOIN Sales s ON e.emp_id=s.emp_id
GROUP BY e.emp_id,e.emp_name;

-- 23. Find the highest sales amount made by each employee.
SELECT 
    e.emp_name,
    max(s.amount) as Highest_sales_amount
from Employee e
JOIN Sales s ON e.emp_id=s.emp_id
GROUP BY e.emp_id,e.emp_name;
   
-- 24. Calculate the total sales amount grouped by product and filtered by products where the total exceeds 50,000.
SELECT 
    e.emp_name, 
    s.product, 
    SUM(s.amount) AS total_amount
FROM Employee e
JOIN Sales s ON e.emp_id = s.emp_id
GROUP BY e.emp_id, e.emp_name, s.product
HAVING total_amount > 50000;

-- 25. Find the departments with the highest average sales amount.
SELECT 
    e.department,
    avg(s.amount) as AVG_Highest_sales_amount
from Employee e
JOIN Sales s ON e.emp_id=s.emp_id
GROUP BY e.department;

-- 26. Find the department with the highest total sales amount.
SELECT 
    e.department, 
    SUM(s.amount) AS Highest_sales_amount
FROM Employee e
JOIN Sales s ON e.emp_id = s.emp_id
GROUP BY e.department
ORDER BY Highest_sales_amount DESC
LIMIT 1;

-- 27. Show the top 3 employees with the highest total sales amount, grouped by employee names.
SELECT 
    e.emp_name, 
    SUM(s.amount) AS Highest_sales_amount
FROM Employee e
JOIN Sales s ON e.emp_id = s.emp_id
GROUP BY e.emp_name
ORDER BY Highest_sales_amount DESC
LIMIT 3;


-- 28. Calculate the total number of employees and the average salary, grouped by the year of joining.
SELECT 
    YEAR(e.joining_date) AS joining_year, 
    COUNT(e.emp_id) AS total_employees, 
    AVG(e.salary) AS avg_salary
FROM Employee e
GROUP BY YEAR(e.joining_date);

-- 29. Find the total sales amount for each department (using a join between Employee and Sales).
SELECT 
    e.department as dept, 
    SUM(s.amount) AS Highest_sales_amount
FROM Employee e
JOIN Sales s ON e.emp_id = s.emp_id
GROUP BY e.department;

-- 30. Show employees who have not made any sales, grouped by their department
SELECT 
    e.department as dept, 
    e.emp_name as emp_name
    
FROM Employee e
LEFT JOIN Sales s ON e.emp_id = s.emp_id
where s.sales_id IS NULL
ORDER BY e.department;









