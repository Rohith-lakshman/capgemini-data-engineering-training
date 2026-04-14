# Week 2 - Day 1: Advanced SQL Concepts

## Overview
This folder contains SQL query examples and their output results for Day 1 of Week 2 in the Capgemini Data Engineering Training. The focus is on practicing advanced SQL techniques that are essential for data analysis and manipulation.

## Topics Covered
- **Common Table Expressions (CTEs)**: Temporary named result sets that can be referenced within a SELECT, INSERT, UPDATE, or DELETE statement.
- **Window Functions: LAG and LEAD**: Functions to access data from previous or subsequent rows in the result set without using self-joins.
- **Subqueries**: Queries nested inside another query to perform complex data retrieval.

## Files Description
- `sql_CTEqueries.sql`: SQL scripts demonstrating Common Table Expressions (CTEs) using sample tables like Employees, Departments, and Orders.
- `sql_CTEqueries_outputs`: Output results from the CTE queries, showing query execution and result tables.
- `sql_LAG_LEAD.sql`: SQL scripts demonstrating LAG and LEAD window functions using a sales table with customer orders.
- `sql_LAG_LEAD_outputs`: Output results from the LAG and LEAD queries, illustrating how these functions work on ordered data.
- `sql_subqueries.sql`: SQL scripts demonstrating subqueries using the same sample tables as CTEs.
- `sql_subqueries_outputs`: Output results from the subquery examples, showing how subqueries filter and retrieve data.

## How to Use
1. Open the `.sql` files in a SQL editor or database client (e.g., MySQL Workbench, pgAdmin).
2. Execute the queries against a database with the provided table schemas.
3. Compare your results with the outputs in the corresponding `_outputs` files to verify correctness.
4. Experiment by modifying the queries to deepen your understanding.

## Sample Tables
The examples use these tables:
- **Employees**: Employee details (ID, name, department, salary, manager).
- **Departments**: Department information (ID, name).
- **Orders**: Order records (ID, employee ID, amount, date).
- **Sales**: Customer sales data (ID, customer ID, date, amount) - used for LAG/LEAD examples.

## Notes
- The `_outputs` files contain formatted query results for reference.
- These concepts build on basic SQL knowledge and are crucial for advanced data engineering tasks.
- Practice running these queries in a real database environment to gain hands-on experience.
