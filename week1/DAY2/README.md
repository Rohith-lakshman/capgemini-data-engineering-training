Advanced SQL JOINs Assignment README

Overview
This project is about learning advanced SQL JOIN operations to combine data from multiple tables.
We use tables like Employee and Sales to demonstrate different join types.

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

1. INNER JOIN
   Returns records that have matching values in both tables.
   Used to combine related data where both sides have data.

Example
Find employees who have made sales.

2. LEFT JOIN (LEFT OUTER JOIN)
   Returns all records from the left table, and matched records from the right table.
   If no match, NULL values are returned for right table columns.

Example
Find all employees and their sales (including employees with no sales).

3. RIGHT JOIN (RIGHT OUTER JOIN)
   Returns all records from the right table, and matched records from the left table.
   If no match, NULL values are returned for left table columns.

Example
Find all sales and the employees who made them (including sales without employee data).

4. FULL OUTER JOIN
   Returns all records when there is a match in either left or right table.
   Combines results of both LEFT and RIGHT joins.

Example
Find all employees and all sales, showing matches and non-matches.

5. Advanced JOIN queries
   Joining multiple tables, using JOIN with WHERE and GROUP BY.
   Handling NULL values in join results.

Files
- sql_joins.sql: SQL queries demonstrating different JOIN types
- sql_queries.sql: Additional SQL queries for practice
- sql_joins_outputs/: Output results from join queries
- sql_queries_outputs/: Output results from additional queries

Important points
- Understand the difference between INNER and OUTER joins.
- Be careful with NULL values in join results.
- Use appropriate join types based on data requirements.

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
