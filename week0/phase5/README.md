
# Week 0 - Phase 5: Advanced Data Analytics with PySpark

## Overview
This phase focuses on performing advanced analytical tasks using PySpark on the Olist Brazilian E-commerce dataset. You'll learn to clean data, perform joins, and use window functions for complex analytics like ranking, running totals, and customer segmentation.

## Prerequisites
- PySpark environment (Databricks or local Spark setup)
- Basic knowledge of Python and SQL
- Understanding of data cleaning and transformation

## Datasets
The notebook uses the following Olist datasets (stored in `/Volumes/workspace/default/olist/`):
- `olist_customers_dataset.csv`: Customer information including IDs and locations
- `olist_orders_dataset.csv`: Order details with timestamps and statuses
- `olist_order_items_dataset.csv`: Items in each order with prices
- `olist_order_payments_dataset.csv`: Payment information
- `olist_products_dataset.csv`: Product details
- `olist_sellers_dataset.csv`: Seller information
- `olist_order_reviews_dataset.csv`: Customer reviews
- `product_category_name_translation.csv`: Category name translations

## Tasks Covered

### 1. Data Loading and Cleaning
- Load all datasets using Spark CSV reader
- Remove duplicates and null values from key columns
- Join tables to create a comprehensive dataset

### 2. Analytical Tasks

#### Task 1: Top 3 Customers per City
- Calculate total spend per customer
- Use window functions to rank customers within each city
- Output: city, customer_id, total_spend, rank

#### Task 2: Running Total of Sales
- Calculate daily sales amounts
- Compute cumulative (running) total using window functions
- Output: date, daily_sales, running_total

#### Task 3: Top Products per Category
- Aggregate sales per product
- Join with category information
- Rank products using DENSE_RANK within categories
- Output: category, product_id, total_sales, rank

#### Task 4: Customer Lifetime Value
- Calculate total value per customer over time
- Analyze customer purchasing patterns

#### Task 5: Customer Segmentation
- Segment customers based on spending patterns
- Use clustering or rule-based segmentation

#### Task 6: Final Reporting Table
- Create a comprehensive report combining multiple analytics
- Present key business insights

## Files
- `week0_phase5.ipynb`: Main Jupyter notebook with PySpark code
- `week0_phase5_problem_statement.pdf`: Detailed problem statement and requirements

## How to Run
1. Open the notebook in a PySpark-enabled environment (e.g., Databricks)
2. Ensure the Olist datasets are available at the specified path
3. Run cells sequentially, starting from data loading
4. Each task builds on the previous ones
5. Review outputs and modify queries as needed for deeper analysis

## Key Concepts Learned
- PySpark DataFrame operations
- Window functions (rank, dense_rank, running totals)
- Data cleaning and preprocessing
- Complex joins and aggregations
- Analytical thinking for business insights

## Notes
- The notebook uses Databricks file system paths; adjust for local environments
- Focus on understanding the analytical logic rather than just running code
- Experiment with different window function parameters to see their effects