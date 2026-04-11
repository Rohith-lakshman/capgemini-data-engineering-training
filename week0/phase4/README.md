# Phase 4 – ETL Pipeline (SQL + Python)

##  Overview

This project demonstrates a simple ETL (Extract, Transform, Load) pipeline using SQL and Python (SQLite).
It processes customer and order data, performs cleaning, transformations, and generates business insights.

---

##  Steps in Pipeline

### 1. Extract

* Read data from tables (`customers`, `orders`)

### 2. Clean

* Remove null `customer_id`
* Remove duplicates
* Filter invalid values (age > 0, amount > 0)

### 3. Transform

* Join customers and orders using `customer_id`
* Apply aggregations

### 4. Analyze (7 Tasks)

* Daily Sales
* City-wise Revenue
* Top 5 Customers
* Repeat Customers
* Customer Segmentation
* Final Report

### 5. Load

* Save final output into database / CSV file

---

##  How to Run

```bash
python run_sql.py
```

---

##  Outputs

* Console will show all 7 task results
* Final report saved as `final_report.csv`

---

#  Reflection Questions

### 1. Why is cleaning done before joining tables?

Cleaning ensures only valid and correct data is used, otherwise joins produce wrong results.

---

### 2. What would go wrong if null keys are not removed?

Rows with null keys will not join properly and may create missing or incorrect data.

---

### 3. How did you decide join order?

Customers is the main table and orders depend on it, so we join orders to customers using `customer_id`.

---

### 4. Which step was most difficult and why?

Data cleaning is hardest because identifying invalid and duplicate data requires careful checking.

---

### 5. How is SQL logic similar to PySpark?

Both use similar operations like filter, join, groupBy, and aggregation.

---

### 6. What challenges will appear with large data?

* Slow processing
* Memory issues
* Need for distributed systems like Spark



### 7. Can you explain your pipeline in simple steps?

* Load data
* Clean data
* Join tables
* Apply calculations
* Generate reports
* Save results

---

##  Conclusion

This phase shows how important data cleaning and transformation are before generating insights.
