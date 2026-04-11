CREATE TABLE Employee (
emp_id INT,
emp_name VARCHAR(50),
department VARCHAR(50),
salary INT,
experience INT,
performance_rating CHAR(1)
);
INSERT INTO Employee (emp_id, emp_name, department, salary, experience, performance_rating)
VALUES
(1, 'Karthik', 'Engineering', 95000, 9, 'A'),
(2, 'Prathik', 'HR', 55000, 4, 'B'),
(3, 'Vinay', 'Finance', 78000, 10, 'B'),
(4, 'Vijay', 'Marketing', 48000, 3, 'C'),
(5, 'Anil', 'Engineering', 88000, 6, 'A'),
(6, 'Suresh', 'Finance', 92000, 12, 'A'),
(7, 'Ramesh', 'HR', 46000, 2, 'C'),
(8, 'Mahesh', 'Marketing', 67000, 7, 'B'),
(9, 'Rajesh', 'Engineering', 72000, 5, 'B'),
(10,'Naveen', 'Finance', 61000, 6, 'C'),
(11,'Deepak', 'HR', 83000, 11, 'A'),
(12,'Arjun', 'Engineering', 54000, 3, 'C'),
(13,'Kiran', 'Marketing', 76000, 8, 'A'),
(14,'Rohit', 'Finance', 68000, 4, 'B'),
(15,'Pavan', 'HR', 59000, 5, 'B'),
(16,'Srikanth', 'Engineering', 102000, 14, 'A'),
(17,'Manoj', 'Finance', 47000, 2, 'C'),
(18,'Varun', 'Marketing', 52000, 6, 'B'),
(19,'Ashok', 'HR', 74000, 9, 'A'),
(20,'Sunil', 'Engineering', 66000, 4, 'B'),
(21,'Nikhil', 'Finance', 86000, 7, 'A'),
(22,'Harish', 'Marketing', 45000, 1, 'C'),
(23,'Vamsi', 'Engineering', 79000, 8, 'B'),
(24,'Chaitanya','HR', 91000, 13, 'A'),
(25,'Lokesh', 'Finance', 58000, 5, 'B');

-- Problem 1: Salary Hike Based on Experience and Performance Scenario: You want to give a salary hike based on both experience and performance rating. If the employee has:  Experience ≥ 8 and Performance 'A', they get a 20% hike. · Experience ≥ 5 and Performance 'B', they get a 15% hike.· Performance 'C' gets no hike.· For other cases, they get a 10% hike.
select *,
case
   when experience >= 8 and performance_rating='A' then '20% hike'
   when experience >=5 and performance_rating='B' then '15% hike'
   when performance_rating='c' then 'No hike'
   else '10% hike'
end as salary_hike_percentage
from Employee;

-- 2) Problem 2: Bonus Calculation Based on Department and Performance Scenario: Bonus is calculated based on the department and performance rating: · For Finance department: o If performance is 'A', the bonus is 20% of the salary. o If performance is 'B', the bonus is 15% of the salary. o If performance is 'C', the bonus is 5% of the salary. · For Engineering department: o If performance is 'A', the bonus is 18% of the salary. o If performance is 'B', the bonus is 12% of the salary. o If performance is 'C', the bonus is 3% of the salary. · For other departments, a flat 10% bonus.
SELECT *,
CASE 
    WHEN department = 'Finance' THEN
        CASE 
            WHEN performance_rating = 'A' THEN '20% bonus'
            WHEN performance_rating = 'B' THEN '15% bonus'
            WHEN performance_rating = 'C' THEN '5% bonus'
            ELSE '10% bonus'
        END
    WHEN department = 'Engineering' THEN
        CASE 
            WHEN performance_rating = 'A' THEN '18% bonus'
            WHEN performance_rating = 'B' THEN '12% bonus'
            WHEN performance_rating = 'C' THEN '3% bonus'
            ELSE '10% bonus'
        END
    ELSE '10% bonus'
END AS bonus
FROM Employee;
   
-- Problem 3: Categorizing Employees by Salary Range and Performance Scenario: You want to categorize employees based on salary ranges and their performance: · If salary is greater than 80,000 and performance is 'A', label them as High Performer. · If salary is between 50,000 and 80,000 and performance is 'B', label them as Mid Performer. · If salary is less than 50,000 or performance is 'C', label them as Low Performer.

select *,
case
   when salary>80000 and performance_rating='A' then 'High Performer'
   when salary between 50000 and 80000 or  performance_rating='B' then 'Mid Performer'
   when salary<50000 or performance_rating='C' then 'Low Performer'
 
end as Categorizing_Employee
from Employee;

-- Problem 4: Risk Assessment Based on Experience and Department Scenario: You want to assess employee risk based on their experience and department: · For employees in the HR department: o If experience is less than 5 years, they are High Risk.o If experience is more than 5 years, they are Low Risk. · For employees in Engineering or Finance departments: o If experience is more than 8 years, they are Low Risk. o If experience is less than 8 years, they are Medium Risk. · Employees in other departments are automatically labeled Medium Risk
select *,
CASE 
    WHEN department = 'HR' THEN
        CASE 
            WHEN  experience<5 THEN 'High Risk'
            WHEN experience>=5 THEN 'Low Risk'
            
        END
    WHEN department = 'Engineering' or department='Finance' THEN
        CASE 
           when experience<8 then 'High Risk'
           when experience>=8 then 'Medium Risk'
           
        END
    ELSE 'Medium Risk'
END AS Risk_Assessment
FROM Employee;

-- Nested case and when   Problem 1: Nested CASE for Performance and Salary Hike Based on Multiple Criteria Scenario: You want to determine the salary hike based on performance rating, experience, and current salary. The hike rules are: · If performance is 'A': o For salaries above 80,000, experience above 5 years gets a 25% hike, otherwise 20%. o For salaries between 50,000 and 80,000, the hike is 15%. · If performance is 'B': o For experience above 5 years, the hike is 12%. o Otherwise, it's 10%. · For performance 'C', there is no hike.
SELECT *,
CASE 
    WHEN performance_rating = 'A' THEN
        CASE 
            WHEN salary > 80000 THEN 
                CASE WHEN experience > 5 THEN '25% hike' ELSE '20% hike' END
            WHEN salary BETWEEN 50000 AND 80000 THEN '15% hike'
            ELSE '10% hike' -- Fallback for Salary < 50k with rating A
        END
      
    WHEN performance_rating = 'B' THEN
        CASE 
            WHEN experience > 5 THEN '12% hike'
            ELSE '10% hike'
        END
        
    WHEN performance_rating = 'C' THEN 'No hike'
    
   
    ELSE '10% hike'
END AS detailed_hike
FROM Employee;
 
-- 2.Department and Performance Scenario: You are tasked with giving bonuses based on the department, performance rating, and experience: · For Finance department: o If performance is 'A' and experience is more than 10 years, bonus is 25% of salary. o Otherwise, bonus is 20%.· For HR department: o If performance is 'B' or experience is greater than 5 years, the bonus is 15%.o Otherwise, the bonus is 10%.· For other departments, the bonus is 8%.
SELECT *,
CASE 
    WHEN department = 'Finance' THEN
        CASE 
            WHEN performance_rating = 'A' AND experience > 10 THEN '25% bonus'
            ELSE '20% bonus'
        END
    WHEN department = 'HR' THEN
        CASE 
            WHEN performance_rating = 'B' OR experience > 5 THEN '15% bonus'
            ELSE '10% bonus'
        END
    ELSE '8% bonus'
END AS calculated_bonus
FROM Employee;

-- Problem 3: Nested CASE for Employee Categorization Based on Salary, Performance, and ExperienceScenario: Categorize employees based on their salary, performance rating, and experience: · If salary is above 70,000: o If performance is 'A', and experience is more than 8 years, they are labeled 'Top Performer'. o If experience is less than 8 years, label them as 'Mid Performer'. · If salary is between 50,000 and 70,000, they are 'Average Performer' unless their performance is 'A', in which case they are 'Rising Star'. · If salary is below 50,000, they are 'Low Performer'.
SELECT *,
CASE 
    WHEN salary > 70000 THEN
        CASE 
            WHEN performance_rating = 'A' AND experience > 8 THEN 'Top Performer'
            ELSE 'Mid Performer'
        END
    WHEN salary BETWEEN 50000 AND 70000 THEN
        CASE 
            WHEN performance_rating = 'A' THEN 'Rising Star'
            ELSE 'Average Performer'
        END
    ELSE 'Low Performer'
END AS Category_Status
FROM Employee;

-- 4.Nested CASE for Tax Bracket Based on Salary and Experience Scenario: You want to determine the tax bracket of employees based on their salary and experience: · If salary is above 90,000: o If experience is more than 10 years, they fall into the 35% tax bracket.  o Otherwise, they fall into the 30% tax bracket. · If salary is between 60,000 and 90,000: o If experience is more than 5 years, they fall into the 25% tax bracket. o Otherwise, they fall into the 20% tax bracket.  For salaries below 60,000, the tax rate is 15%.
SELECT *,
CASE 
    WHEN salary > 90000 THEN
        CASE 
            WHEN experience > 10 THEN '35% tax'
            ELSE '30% tax'
        END
    WHEN salary BETWEEN 60000 AND 90000 THEN
        CASE 
            WHEN experience > 5 THEN '25% tax'
            ELSE '20% tax'
        END
    ELSE '15% tax'
END AS tax_bracket
FROM Employee;

-- Problem 5: Nested CASE for Promotion Eligibility Based on Performance, Salary, and ExperienceScenario: You want to determine if employees are eligible for promotion based on their performance rating, salary, and experience:· If performance is 'A':§ If salary is more than 75,000 and experience is greater than 7 years, they are 'Eligible for Senior Role'. § Otherwise, they are 'Eligible for Junior Role'. · If performance is 'B': § If experience is more than 5 years, they are 'Eligible for Consideration'. § Otherwise, they are 'Not Eligible'. · If performance is 'C', they are automatically 'Not Eligible'.
SELECT *,
CASE 
    WHEN performance_rating = 'A' THEN
        CASE 
            WHEN salary > 75000 AND experience > 7 THEN 'Eligible for Senior Role'
            ELSE 'Eligible for Junior Role'
        END
    WHEN performance_rating = 'B' THEN
        CASE 
            WHEN experience > 5 THEN 'Eligible for Consideration'
            ELSE 'Not Eligible'
        END
    WHEN performance_rating = 'C' THEN 'Not Eligible'
    ELSE 'Not Eligible'
END AS promotion_status
FROM Employee;
