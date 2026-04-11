SQL GROUP BY Assignment README

Overview
This project is about learning how to use GROUP BY in SQL to analyze data.
We use two tables: Employee and Sales.

Tables Used

Employee Table
emp_id - employee id
emp_name - name
department - department
salary - salary
joining_date - joining date

Sales Table
sales_id - sales id
emp_id - employee id
product - product sold
amount - sales amount
sale_date - date

What you learned

1. GROUP BY basics
   Group data based on a column like department.
   Used to find total salary, average salary, max salary, min salary, and employee count.

Example
Find total salary in each department.

2. WHERE vs HAVING
   WHERE filters data before grouping.
   HAVING filters data after grouping.

Example
Find departments where total salary is greater than 100000.

3. Using JOIN
   Combine Employee and Sales tables using emp_id.
   Used to find total sales per employee, number of sales, and product-wise sales.

4. Advanced queries
   Find highest sales per employee.
   Count unique products sold.
   Calculate salary and sales together.

Important point
When using JOIN, salary can repeat for multiple sales records.
So use MAX(salary) instead of SUM(salary).

5. Real world queries
   Top 3 employees with highest sales
   Department with highest sales
   Sales grouped by year
   Employees who did not make any sales

Corrections made

toal_count changed to total_count
In query 21, used MAX(salary) instead of SUM(salary)
In query 24, grouped by product instead of employee and product

What results show

Salary details for each department
Top performing employees
Best selling products
Employees with no sales

Final learning

You can now use GROUP BY correctly
You understand difference between WHERE and HAVING
You can use JOIN with aggregation
You can solve real world SQL problems

Simple idea

GROUP BY means grouping similar data and performing calculations on it

Conclusion

This project helps you move from basic SQL to real world SQL queries in a simple and clear way
