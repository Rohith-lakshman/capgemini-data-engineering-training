#  Phase 3 – Final ETL & Pipeline (SQL to PySpark)

##  Objective

This phase focuses on building a complete **ETL (Extract, Transform, Load) pipeline** using SQL and PySpark.
The goal is to move from writing individual queries to implementing a structured data engineering workflow.


##  Dataset Description

### customers.csv

 customer_id
 customer_name
 city
 age

### orders.csv

 order_id
 customer_id
 order_amount
 order_date

---

##  ETL Workflow

### 1. Extract

 Load CSV files into SQL / PySpark DataFrames

### 2. Transform

 Remove null values (`dropna`)
 Filter invalid data
 Perform joins between customers and orders
 Apply aggregations (SUM, COUNT, AVG)

### 3. Load

 Display results
 Save final output to `outputs/final_report`

---

##  SQL Tasks

Total order amount per customer
 Top customers by spending
 Customers with no orders
City-wise revenue
Average order value
Repeat customers
Final reporting table

---

##  PySpark Tasks

 Read CSV using `spark.read.csv()`
 Clean data using `dropna()` and filters
 Perform joins using `join()`
 Aggregations using `groupBy()`
 Sorting using `orderBy()`
 Save output using `write.csv()`


##  How to Run SQL File

### Step 1: Run using Python (SQLite)


python run_sql.py


### OR using SQLite CLI

sqlite3 mydb.db
.read phase3.sql


##  How to Run PySpark File

python phase3_pipeline.py


## ✅ Output

The pipeline generates:
*
 Daily sales report
 City-wise revenue
 Repeat customers
 Highest spending customers
 Final aggregated report

---

##  Learning Outcome

 Understanding ETL pipeline design
 SQL to PySpark conversion
 Data cleaning and transformation
 Real-world data engineering workflow

