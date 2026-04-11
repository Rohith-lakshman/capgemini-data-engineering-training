# 🚀 Capgemini Data Engineering Training
### PySpark · SQL · ETL Pipelines · Databricks · Olist Dataset

![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Apache Spark](https://img.shields.io/badge/Apache%20Spark-E25A1C?style=for-the-badge&logo=apachespark&logoColor=white)
![Databricks](https://img.shields.io/badge/Databricks-FF3621?style=for-the-badge&logo=databricks&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![Status](https://img.shields.io/badge/Status-Active-brightgreen?style=for-the-badge)

---

## 📌 About This Repository

This repository documents my complete **Data Engineering training journey** at **Capgemini**, progressing from SQL fundamentals to building production-grade ETL pipelines on **Databricks** using a real-world e-commerce dataset.

Each phase is a hands-on, week-by-week progression — no theory without code, no code without purpose.

> **Core philosophy:** *Clean before you join. Filter before you aggregate. Validate before you trust.*

---

## 🗂️ Repository Structure

```
capgemini-data-engineering-training/
│
├── Week0/          → Environment setup & PySpark orientation
├── Week1/          → Phase 1: SQL to PySpark foundations
├── Week2/          → Phase 2 & 3: Bridge pack + ETL pipeline thinking
├── Week3/          → Phase 3A & 4: Data quality + Business pipeline
├── Week4/          → Phase 4A & 5: Segmentation + Databricks/Olist capstone
├── sqloutputs.png  → Visual reference of SQL query outputs
└── README.md       → This file
```

---

## 📚 Phase-by-Phase Breakdown

---

### 🟣 Phase 0 — Environment Setup (`Week0/`)

**Objective:** Get Databricks Community Edition running and verify the environment.

**What was done:**
- Created a Databricks Community Edition account
- Launched a Spark cluster with default settings
- Created a notebook and ran a smoke test
- Verified file system access using `dbutils`

```python
# Verify Databricks is working
print("Spark version:", spark.version)
display(dbutils.fs.ls('/FileStore/'))
```

**Outcome:** ✅ Cluster running, notebook ready, environment confirmed.

---

### 🔵 Phase 1 — SQL to PySpark Foundations (`Week1/`)

**Objective:** Build confidence mapping SQL queries to PySpark DataFrame operations using small, clean sample data.

**Key concepts learned:**
| SQL | PySpark Equivalent |
|-----|-------------------|
| `SELECT col` | `df.select("col")` |
| `WHERE age > 25` | `df.filter(df.age > 25)` |
| `GROUP BY city` | `df.groupBy("city").count()` |
| `ORDER BY spend DESC` | `df.orderBy(df.spend.desc())` |
| `JOIN ON id` | `df.join(df2, "customer_id")` |

**Sample starter data used:**
```python
customers = spark.createDataFrame([
    (1, "Ravi",  "Hyderabad", 25),
    (2, "Sita",  "Chennai",   32),
    (3, "Arun",  "Hyderabad", 28)
], ["customer_id", "customer_name", "city", "age"])
```

**Exercises completed:**
1. Show all customers
2. Filter customers from Chennai
3. Filter customers with age > 25
4. Select only `customer_name` and `city`
5. Count customers city-wise

**Outcome:** ✅ Comfortable with `show()`, `select()`, `filter()`, `groupBy()` — SQL ↔ PySpark mental model established.

---

### 🟢 Phase 2 — Bridge Pack: Real Sample Files (`Week2/`)

**Objective:** Bridge SQL knowledge to real-world PySpark workflows using `/samples/` datasets. Introduced light data cleaning.

**Datasets used:**
- `/samples/customers.csv`
- `/samples/orders.csv`

**Critical pattern introduced — clean before joining:**
```python
# Always remove null keys before joining
customers = customers.dropna(subset=["customer_id"])
orders    = orders.dropna(subset=["customer_id"])

# Now safe to join
joined = customers.join(orders, "customer_id", "inner")
```

**Exercises completed:**
1. Total order amount per customer
2. Top 3 customers by total spend
3. Customers with **no orders** (LEFT JOIN + null filter)
4. City-wise total revenue
5. Average order amount per customer
6. Customers with more than 1 order
7. Sort by total spend descending

**Outcome:** ✅ Join logic, null handling, and aggregations on real files.

---

### 🟡 Phase 3 — ETL Pipeline Thinking (`Week2/` + `Week3/`)

**Objective:** Stop writing isolated queries. Think like a data engineer — read → clean → filter → join → aggregate → save.

**The ETL mental model:**
```
EXTRACT          TRANSFORM                          LOAD
  │                   │                               │
Read CSV  →  Clean nulls  →  Filter invalids  →  Save output
              Drop dupes      Join tables
              Cast types      Aggregate
                              Validate
```

**Core data cleaning methods:**
```python
# Drop rows where the key column is null
df = df.dropna(subset=["customer_id"])

# Remove exact duplicate rows
df = df.dropDuplicates()

# Filter out invalid values
df = df.filter(df.age > 0)
df = df.filter(df.amount > 0)

# Fill missing non-key values
df = df.fillna({"city": "Unknown", "age": 0})
```

**Order of operations rule (non-negotiable):**
```
✅ Clean   BEFORE  Join
✅ Filter  BEFORE  Aggregate
✅ Validate BEFORE  Process
```

---

### 🔴 Phase 3A — Data Quality Challenge (`Week3/`)

**Objective:** Work with intentionally messy data. Identify, fix, and validate all issues.

**The messy dataset:**
```python
data = [
    (1,    "Ravi",  "Hyderabad", 25),
    (2,    None,    "Chennai",   32),   # ← missing name
    (None, "Arun",  "Hyderabad", 28),   # ← missing key (CRITICAL)
    (4,    "Meena", None,        30),   # ← missing city
    (4,    "Meena", None,        30),   # ← duplicate row
    (5,    "John",  "Bangalore", -5)    # ← invalid age
]
```

**Issues found & fixes applied:**

| Issue | Impact | Fix |
|-------|--------|-----|
| Null `customer_id` | Can't join — row is useless | `dropna(subset=["customer_id"])` |
| Null `city` | Wrong city-wise counts | `fillna({"city": "Unknown"})` |
| Duplicate row (row 4 = row 5) | Double-counted in aggregations | `dropDuplicates()` |
| Invalid age (-5) | Corrupts averages and filters | `filter(df.age > 0)` |

```python
# Complete cleaning pipeline
df = df.dropna(subset=["customer_id"])   # Step 1: remove key nulls
df = df.dropDuplicates()                  # Step 2: dedup
df = df.filter(df.age > 0)               # Step 3: remove invalid values
df = df.fillna({"city": "Unknown"})      # Step 4: handle non-critical nulls

# Always validate with row counts
print("Before:", original_count, "| After:", df.count())
```

**Outcome:** ✅ From 6 dirty rows → 4 clean, trustworthy rows.

---

### 🟠 Phase 4 — Business Pipeline Mini Project (`Week3/`)

**Objective:** Build a complete end-to-end business pipeline. All 7 tasks feed into a single final reporting table.

**Pipeline architecture:**
```
Raw CSV files
     │
     ▼
 Data Cleaning  ──────────────────────────────────────────┐
     │                                                      │
     ├──▶ Task 1: Daily Sales       (date, total_sales)     │
     ├──▶ Task 2: City Revenue      (city, total_revenue)   │
     ├──▶ Task 3: Top 5 Customers   (name, total_spend)     │
     ├──▶ Task 4: Repeat Customers  (id, order_count)       │
     ├──▶ Task 5: Segmentation      (name, spend, segment)  │
     │                                                      │
     └──▶ Task 6: Final Report ◀────────────────────────────┘
                    │
                    ▼
           Task 7: Save as CSV
```

**Customer segmentation logic:**
```python
from pyspark.sql.functions import when

df = df.withColumn(
    "segment",
    when(df.total_spend > 10000, "Gold")
    .when((df.total_spend >= 5000) & (df.total_spend <= 10000), "Silver")
    .otherwise("Bronze")
)
```

**Final reporting table output:**
```
customer_name | city       | total_spend | order_count | segment
─────────────────────────────────────────────────────────────────
Ravi Kumar    | Hyderabad  | 15200.00    | 8           | Gold
Sita Reddy    | Chennai    | 7500.00     | 4           | Silver
Arun Verma    | Bangalore  | 3200.00     | 2           | Bronze
```

**Save output:**
```python
final_df.write.mode("overwrite").csv("/samples/output/report")
```

---

### 🟤 Phase 4A — Bucketing & Segmentation Deep Dive (`Week4/`)

**Objective:** Learn 4 different ways to convert continuous numerical values into categories, and understand when to use each.

**Method 1 — Conditional Logic (most common in production):**
```python
from pyspark.sql.functions import when

df = df.withColumn("segment",
    when(df.total_spend > 10000, "Gold")
    .when((df.total_spend >= 5000) & (df.total_spend <= 10000), "Silver")
    .otherwise("Bronze")
)
```

**Method 2 — SQL CASE statement:**
```sql
SELECT *,
  CASE
    WHEN total_spend > 10000             THEN 'Gold'
    WHEN total_spend BETWEEN 5000 AND 10000 THEN 'Silver'
    ELSE 'Bronze'
  END AS segment
FROM customers
```

**Method 3 — MLlib Bucketizer (ML pipelines):**
```python
from pyspark.ml.feature import Bucketizer

splits = [-float("inf"), 5000, 10000, float("inf")]
bucketizer = Bucketizer(splits=splits, inputCol="total_spend", outputCol="bucket")
df = bucketizer.transform(df)
```

**Method 4 — Quantile-based (adaptive, handles data drift):**
```python
# Thresholds calculated from actual data distribution
quantiles = df.approxQuantile("total_spend", [0.33, 0.66], 0)
low, high = quantiles[0], quantiles[1]

df = df.withColumn("segment",
    when(df.total_spend >= high, "Gold")
    .when(df.total_spend >= low, "Silver")
    .otherwise("Bronze")
)
```

**When to use which:**

| Method | Use When |
|--------|----------|
| `when()` conditional | Business rules have fixed, meaningful thresholds |
| SQL CASE | Working in SparkSQL / notebook environments |
| Bucketizer | Part of an MLlib ML pipeline |
| `approxQuantile` | Distribution changes over time (seasonal data, growth) |

> ⚠️ **Fixed thresholds fail** when data distribution shifts — e.g. during a sale season everyone crosses ₹10,000 and your Bronze bucket empties out. Use quantile-based segmentation when balance matters more than absolute values.

---

### 🔮 Phase 5 — Databricks + Olist Capstone (`Week4/`)

**Objective:** Apply everything learned to a real-world multi-table e-commerce dataset. Full pipeline from raw ingestion to final business report on Databricks.

**Dataset:** [Olist Brazilian E-Commerce Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) — 100k+ orders, 9 interrelated tables.

**Dataset upload:**
```python
# After uploading all CSVs to /FileStore/olist/ in Databricks
display(dbutils.fs.ls('/FileStore/olist/'))

# Load tables
orders    = spark.read.option("header","true").csv("/FileStore/olist/olist_orders_dataset.csv")
customers = spark.read.option("header","true").csv("/FileStore/olist/olist_customers_dataset.csv")
items     = spark.read.option("header","true").csv("/FileStore/olist/olist_order_items_dataset.csv")
products  = spark.read.option("header","true").csv("/FileStore/olist/olist_products_dataset.csv")
```

**Task 1 — Top 3 Customers per City (Window Function):**
```python
from pyspark.sql.window import Window
from pyspark.sql.functions import sum as _sum, rank, desc

# Step 1: Calculate total spend per customer
spend_df = items.groupBy("customer_id").agg(_sum("price").alias("total_spend"))

# Step 2: Join with customer city info
spend_city = spend_df.join(customers, "customer_id")

# Step 3: Rank within each city
window = Window.partitionBy("customer_city").orderBy(desc("total_spend"))
result = spend_city.withColumn("rank", rank().over(window)).filter("rank <= 3")

# Output: city | customer_id | total_spend | rank
```

**Task 2 — Running Total of Daily Sales:**
```python
from pyspark.sql.functions import to_date, sum as _sum
from pyspark.sql.window import Window

daily = items.groupBy(to_date("shipping_limit_date").alias("date")) \
             .agg(_sum("price").alias("daily_sales"))

window = Window.orderBy("date").rowsBetween(Window.unboundedPreceding, 0)
result = daily.withColumn("running_total", _sum("daily_sales").over(window))

# Output: date | daily_sales | running_total
```

**Task 3 — Top Products per Category (DENSE_RANK):**
```python
from pyspark.sql.functions import dense_rank

# Aggregate → join with category → rank
window = Window.partitionBy("product_category_name").orderBy(desc("total_sales"))
result = product_sales \
    .join(products, "product_id") \
    .withColumn("rank", dense_rank().over(window)) \
    .filter("rank <= 3")
```

**Task 4 — Customer Lifetime Value (CLV):**
```python
clv = items.join(orders, "order_id") \
           .groupBy("customer_id") \
           .agg(_sum("price").alias("total_spend"))

# Output: customer_id | total_spend
```

**Task 5 — Customer Segmentation:**
```python
clv = clv.withColumn("segment",
    when(clv.total_spend > 10000, "Gold")
    .when((clv.total_spend >= 5000) & (clv.total_spend <= 10000), "Silver")
    .otherwise("Bronze")
)
```

**Task 6 — Final Reporting Table:**
```python
final_df = clv \
    .join(customers, "customer_id") \
    .join(order_counts, "customer_id") \
    .select("customer_id", "customer_city", "total_spend", "segment", "total_orders")

final_df.write.mode("overwrite").csv("/FileStore/olist/output/final_report")
```

**Final output schema:**
```
customer_id | customer_city | total_spend | segment | total_orders
```

---

## 🧠 Key Concepts Summary

### Window Functions — when and why
Window functions let you compute values *across related rows* without collapsing the dataset like `groupBy` does.

| Function | Behaviour | Example Use |
|----------|-----------|-------------|
| `ROW_NUMBER()` | Always unique, no ties | Pagination |
| `RANK()` | Ties share rank, next skips | Top-N with gaps |
| `DENSE_RANK()` | Ties share rank, no gap | Top-N per category |
| `SUM() OVER` | Running/cumulative total | Revenue tracking |
| `LAG() / LEAD()` | Previous/next row value | Period comparison |

### Fact vs Dimension Tables
| | Fact Table | Dimension Table |
|--|-----------|-----------------|
| **Contains** | Transactions / events | Descriptive attributes |
| **Keys** | Foreign keys | Primary keys |
| **Size** | Large, grows constantly | Small, relatively stable |
| **Examples** | `orders`, `payments` | `customers`, `products` |

### ETL Order of Operations
```
1. EXTRACT   → Read raw data
2. CLEAN     → Remove nulls, dupes, invalid values
3. FILTER    → Remove out-of-scope records
4. JOIN      → Combine related tables (after cleaning!)
5. AGGREGATE → Group and summarise
6. VALIDATE  → Check counts and business rules
7. LOAD      → Write final output
```

---

## 🛠️ Tech Stack

| Tool | Purpose |
|------|---------|
| **Python 3.x** | Primary language |
| **Apache PySpark** | Distributed data processing |
| **Spark SQL** | SQL-style queries on DataFrames |
| **Databricks Community Edition** | Cloud notebook environment |
| **Olist Dataset (Kaggle)** | Real-world capstone dataset |
| **MLlib Bucketizer** | ML-based segmentation |

---

## ⚙️ Getting Started

### Prerequisites
- Python 3.8+
- [Databricks Community Edition](https://community.cloud.databricks.com/) (free)
- Kaggle account (for Phase 5 dataset)

### Run locally (Phases 1–4)
```bash
pip install pyspark
```
```python
from pyspark.sql import SparkSession
spark = SparkSession.builder.appName("training").getOrCreate()
```

### Run on Databricks (Phase 5)
1. Sign up at [community.cloud.databricks.com](https://community.cloud.databricks.com/)
2. Create a cluster (default settings)
3. Upload the Olist CSVs to `/FileStore/olist/`
4. Import notebooks from `Week4/` and run cell by cell

---

## 📈 Progress Tracker

| Phase | Topic | Status |
|-------|-------|--------|
| Phase 0 | Environment Setup | ✅ Complete |
| Phase 1 | SQL → PySpark Foundations | ✅ Complete |
| Phase 2 | Bridge Pack + Real Files | ✅ Complete |
| Phase 3 | ETL Pipeline Thinking | ✅ Complete |
| Phase 3A | Data Quality Challenge | ✅ Complete |
| Phase 4 | Business Pipeline Mini Project | ✅ Complete |
| Phase 4A | Bucketing & Segmentation | ✅ Complete |
| Phase 5 | Databricks + Olist Capstone | ✅ Complete |

---

## 🙋 Author

**TANGELLA ROHITH LAKSHMAN KUMAR**
Data Engineering Trainee @ Capgemini


---

*Built phase by phase. Every line of code here was written to understand, not to copy.*
