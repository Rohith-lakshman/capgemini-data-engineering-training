CREATE TABLE Employees (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50),
    department_id INT,
    salary INT,
    manager_id INT
);
INSERT INTO Employees VALUES
(1, 'Alice', 101, 60000, NULL),
(2, 'Bob', 102, 45000, 1),
(3, 'Charlie', 101, 70000, 1),
(4, 'David', 103, 40000, 2),
(5, 'Eve', 102, 50000, 2);
CREATE TABLE Departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50)
);
INSERT INTO Departments VALUES
(101, 'HR'),
(102, 'IT'),
(103, 'Finance');
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    emp_id INT,
    order_amount INT,
    order_date DATE
);
INSERT INTO Orders VALUES
(1, 1, 5000, '2024-01-10'),
(2, 2, 3000, '2024-02-15'),
(3, 3, 7000, '2024-03-12'),
(4, 1, 2000, '2024-04-01'),
(5, 4, 1000, '2024-05-05');

-- CTE (Common Table Expression) Questions (Basic – 5)

-- 1. Create a CTE to show employees with salary > 50,000 and fetch all records
with HighestSalary AS (
  Select *
  from Employees
  where salary > 50000
 )
 select * From HighestSalary;


-- 2. Find average salary per department using CTE
with AvgSalary As (
  Select avg(salary) as AVG_SALARY
  from Employees
  group by department_id
)

select * from AvgSalary;

-- 3 Use CTE to get employees and their department names
with Dept_names AS(
  select  e.emp_id,e.name,d.dept_name
   from Employees e join Departments d 
   ON e.department_id=d.dept_id
  )
  select *from Dept_names;
  
  
 -- 4. Find total order amount per employee using CTE
 with amount_employee AS(
   select sum(order_amount)as total_spend,emp_id
   from Orders
   Group BY emp_id
 )
 select e.name,coalesce(eo.total_spend,0) AS total_order_amount
 from Employees e 
 Left join amount_employee eo ON e.emp_id=eo.emp_id;
 
 -- 5. Find employees whose salary is above department average using CTE
with dept_avg as(
  select avg(salary) as avg_sal,department_id
    from Employees
     Group by department_id
  )
  select e.name,e.salary,d.avg_sal
  from Employees e Join dept_avg d 
  ON e.department_id=d.department_id
  where e.salary > d.avg_sal;
 