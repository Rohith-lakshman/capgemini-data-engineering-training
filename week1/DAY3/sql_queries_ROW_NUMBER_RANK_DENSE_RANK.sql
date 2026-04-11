CREATE TABLE employees (
    emp_id INT,
    emp_name VARCHAR(50),
    department VARCHAR(50),
    salary INT,
    join_date DATE
);

INSERT INTO employees VALUES
(1, 'Amit', 'Chennai', 2000, '2023-01-01'),
(2, 'Ravi', 'Hyderabad', 1500, '2023-01-02'),
(3, 'Sneha', 'Chennai', 3000, '2023-01-03'),
(4, 'Kiran', 'Bangalore', 2500, '2023-01-04'),
(5, 'Priya', 'Chennai', 2000, '2023-01-05'),
(6, 'Arjun', 'Hyderabad', 1800, '2023-01-06'),
(7, 'Neha', 'Bangalore', 2200, '2023-01-07'),
(8, 'Vikas', 'Chennai', 3000, '2023-01-08'),
(9, 'Anjali', 'Hyderabad', 1700, '2023-01-09'),
(10, 'Rahul', 'Bangalore', 2600, '2023-01-10'),
(11, 'Suresh', 'Chennai', 2800, '2023-01-11'),
(12, 'Pooja', 'Hyderabad', 1600, '2023-01-12'),
(13, 'Manoj', 'Bangalore', 2400, '2023-01-13'),
(14, 'Divya', 'Chennai', 2100, '2023-01-14'),
(15, 'Karthik', 'Hyderabad', 1900, '2023-01-15'),
(16, 'Meena', 'Bangalore', 2300, '2023-01-16'),
(17, 'Raj', 'Chennai', 2700, '2023-01-17'),
(18, 'Simran', 'Hyderabad', 2000, '2023-01-18'),
(19, 'Deepak', 'Bangalore', 2500, '2023-01-19'),
(20, 'Nisha', 'Chennai', 2600, '2023-01-20');
-- ROW_NUMBER() ONLY Questions
-- 1.	Assign a unique row number to all employees based on salary (highest first).
SELECT *,
ROW_NUMBER() over(order by salary DESC) as rownumber
from employees;

-- 2.	Assign row numbers to employees within each department based on salary descending. 
SELECT *,
ROW_NUMBER() over(partition by department order by salary desc) AS employee_numbers
from employees;

-- 3.	Assign row numbers based on employee joining date (latest first). 
SELECT *,
ROW_NUMBER() over(order by join_date desc) AS employee_numbers
from employees;

-- 4.	Assign row numbers within each department based on earliest joining date. 
SELECT *,
ROW_NUMBER() over(partition by department order by join_date) AS employee_numbers
from employees;

-- 7.	Assign row numbers to employees based on salary (lowest first). 
SELECT *,
ROW_NUMBER() over(order by salary) as rownumber
from employees;

-- 8.	Assign row numbers within department for employees based on name alphabetically. 
SELECT * , 
ROW_NUMBER() OVER(PARTITION BY department ORDER BY emp_name ASC) AS name_row_num
FROM employees;

--  RANK() ONLY Questions
-- 9.	Rank all employees based on salary (highest first). 
SELECT *,
Rank() over(order by salary DESC) as ramknumber
from employees;

-- 10.	Rank employees within each department based on salary.
SELECT *,
Rank() over(partition by department order by salary desc) AS employee_RANK
from employees;


-- 11.	Rank employees based on joining date (latest gets rank 1). 
SELECT *,
Rank() over(order by join_date desc) AS employee_RANK
from employees;
 
 -- 14.	Rank employees within department based on salary (lowest first). 
 SELECT *,
RANK() over(PARTITION BY department order by salary) as RANKnumber
from employees;

-- 15.	Rank employees based on name alphabetically. 
SELECT * , 
Rank() OVER(ORDER BY emp_name ASC) AS name_rank
FROM employees;

--  DENSE_RANK() ONLY Questions

-- 17.	Assign dense rank to employees based on salary (highest first). 
SELECT *,
DENSE_RANK() over(order by salary DESC) as DESE_RANK_number
from employees;

-- 18.	Assign dense rank within each department based on salary. 
 SELECT *,
DENSE_RANK() over(PARTITION BY department order by salary) as DENSE_RANK_number
from employees;

-- 19.	Assign dense rank to employees based on joining date.
SELECT *,
DENSE_RANK() over(order by join_date) AS employee_dense_rank
from employees;

-- 22.	Assign dense rank to employees based on salary (lowest first). 

SELECT *,
DENSE_RANK() over(order by salary) as DENSE_RANK_EMPLOYEE
from employees;

-- 23.	Assign dense rank within department based on joining date. 
SELECT *,
DENSE_RANK() over(partition by department order by join_date) AS DENSE_RANK_employee_numbers
from employees;

