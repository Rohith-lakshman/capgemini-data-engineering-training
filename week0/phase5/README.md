# Phase 5: Advanced Data Analytics with PySpark & Olist E-commerce Dataset

## 📊 Overview
Phase 5 focuses on **advanced analytical tasks using PySpark window functions** on the real-world **Olist Brazilian E-commerce dataset**. You'll master data cleaning, complex joins, and sophisticated analytics including customer ranking, cumulative sales tracking, product analysis, and customer segmentation.

**Difficulty Level**: ⭐⭐⭐⭐ Advanced  
**Estimated Time**: 60-90 minutes  
**Key Focus**: Window Functions, Aggregations, Multi-table Joins

## 🎯 Learning Objectives
By completing this phase, you will learn:
- ✅ Data loading and cleaning at scale using PySpark
- ✅ Complex multi-table joins with DataFrames
- ✅ Window functions: `RANK()`, `DENSE_RANK()`, and cumulative aggregations
- ✅ Partitioning and ordering data for analytical queries
- ✅ Customer Lifetime Value (CLV) calculation
- ✅ Rule-based customer segmentation
- ✅ Real-world e-commerce analytics workflows

## 📦 Olist Brazilian E-commerce Dataset
Olist is a Brazilian online marketplace with **real transaction data**. The dataset contains:

| Dataset | Records | Purpose |
|---------|---------|---------|
| **olist_customers_dataset.csv** | ~119K | Customer IDs, locations (city, state, zip code) |
| **olist_orders_dataset.csv** | ~99K | Order IDs, timestamps, delivery status |
| **olist_order_items_dataset.csv** | ~112K | Products per order with unit prices |
| **olist_products_dataset.csv** | ~32K | Product IDs, categories, dimensions, weight |
| **olist_order_payments_dataset.csv** | ~103K | Payment methods and amounts |
| **olist_sellers_dataset.csv** | ~3.6K | Seller information and location |
| **olist_order_reviews_dataset.csv** | ~99K | Review scores and comments (1-5 stars) |
| **product_category_name_translation.csv** | ~71 | Portuguese→English category translations |

### Dataset Schema Relationships
```
customers ──┬──→ orders ──┬──→ order_items ──→ products
            │             └──→ payments
            └──────────────→ reviews
            
sellers ──→ order_items ──→ orders
```

## 🏗️ Project Structure

```
phase5/
├── README.md                              # This file
├── week0_phase5.ipynb                     # Main PySpark Jupyter notebook
├── week0_phase5_problem_statement.pdf     # Detailed requirements
└── outputs/                               # Results directory (auto-created)
    ├── task1_top_customers.csv
    ├── task2_running_totals.csv
    ├── task3_top_products.csv
    ├── task4_clv.csv
    ├── task5_segmentation.csv
    └── task6_final_report.csv
```

## 📋 Tasks & Implementation Details

### **Task 1: Top 3 Customers per City** 🏙️
**Objective**: Identify high-value customers in each city using window functions

**Approach**:
1. Aggregate total spending by customer and city
2. Use `RANK()` window function partitioned by city
3. Filter for rank ≤ 3

**Code Pattern**:
```python
from pyspark.sql.functions import sum, rank
from pyspark.sql.window import Window

customer_spend = df.groupBy("customer_city", "customer_id") \
    .agg(sum("price").alias("total_spend"))

window_city = Window.partitionBy("customer_city") \
    .orderBy(col("total_spend").desc())

top_customers = customer_spend.withColumn("rank", rank().over(window_city)) \
    .filter(col("rank") <= 3)

top_customers.show()
```

**Output Columns**: `customer_city`, `customer_id`, `total_spend`, `rank`

**Business Use Case**: Targeting marketing campaigns to high-value customers in specific regions

---

### **Task 2: Running Total of Sales** 📈
**Objective**: Track cumulative daily sales over time

**Approach**:
1. Extract date from order timestamp
2. Aggregate daily sales amounts
3. Use `SUM()` window function with cumulative ordering

**Code Pattern**:
```python
from pyspark.sql.functions import to_date, sum

df = df.withColumn("order_date", to_date(col("order_purchase_timestamp")))

daily_sales = df.groupBy("order_date") \
    .agg(sum("price").alias("daily_sales"))

window_date = Window.orderBy("order_date")

running_total = daily_sales.withColumn(
    "running_total", 
    sum("daily_sales").over(window_date)
)

running_total.show()
```

**Output Columns**: `order_date`, `daily_sales`, `running_total`

**Window Frame**: Unbounded preceding to current row (default cumulative behavior)

**Business Use Case**: Revenue tracking, sales performance monitoring, growth analysis

---

### **Task 3: Top Products per Category** 🏆
**Objective**: Rank products within their categories by total sales

**Approach**:
1. Aggregate sales by product and category
2. Join with category translation table
3. Use `DENSE_RANK()` partitioned by category

**Code Pattern**:
```python
from pyspark.sql.functions import dense_rank

product_sales = df.groupBy("product_id", "product_category_name") \
    .agg(sum("price").alias("total_sales"))

product_sales = product_sales.join(category, "product_category_name")

window_category = Window.partitionBy("product_category_name_english") \
    .orderBy(col("total_sales").desc())

top_products = product_sales.withColumn(
    "rank", 
    dense_rank().over(window_category)
)

top_products.show()
```

**Output Columns**: `product_category_name_english`, `product_id`, `total_sales`, `rank`

**Rank vs Dense Rank**: DENSE_RANK doesn't skip numbers after ties (1,1,2,3 vs 1,1,3,4)

**Business Use Case**: Best-selling products per category, inventory management, promotions planning

---

### **Task 4: Customer Lifetime Value (CLV)** 💰
**Objective**: Calculate total spending per customer across all orders

**Approach**:
1. Group by customer_id
2. Sum all purchase amounts

**Code Pattern**:
```python
clv = df.groupBy("customer_id") \
    .agg(sum("price").alias("total_spend"))

clv.show()
```

**Output Columns**: `customer_id`, `total_spend`

**Metric Importance**: CLV is critical for:
- Customer acquisition cost justification
- Retention strategy ROI
- Profitability analysis
- Churn prediction

---

### **Task 5: Customer Segmentation** 🎯
**Objective**: Categorize customers into business segments based on spending

**Segmentation Rules**:
- **Gold**: total_spend > 10,000 (VIP customers)
- **Silver**: 5,000 ≤ total_spend ≤ 10,000 (Valuable customers)
- **Bronze**: total_spend < 5,000 (Emerging customers)

**Code Pattern**:
```python
from pyspark.sql.functions import when

segmentation = clv.withColumn(
    "segment",
    when(col("total_spend") > 10000, "Gold")
    .when((col("total_spend") >= 5000) & (col("total_spend") <= 10000), "Silver")
    .otherwise("Bronze")
)

segmentation.show()
```

**Output Columns**: `customer_id`, `total_spend`, `segment`

**Real-World Application**:
```
Gold (VIP)     → Premium support, exclusive offers, personal account manager
Silver (High)  → Early access to sales, loyalty rewards, birthday discounts
Bronze (Basic) → Standard support, seasonal promotions
```

---

### **Task 6: Final Reporting Table** 📊
**Objective**: Create a comprehensive 360° customer view combining all analytics

**Approach**:
1. Start with segmentation data (CLV + segment)
2. Join with customer location data
3. Join with order count aggregation
4. Select key business metrics

**Code Pattern**:
```python
from pyspark.sql.functions import count

total_orders = orders.groupBy("customer_id") \
    .agg(count("order_id").alias("total_orders"))

final_df = segmentation.join(customers, "customer_id") \
    .join(total_orders, "customer_id") \
    .select(
        "customer_id",
        "customer_city",
        "total_spend",
        "segment",
        "total_orders"
    )

final_df.show()
```

**Output Columns**: `customer_id`, `customer_city`, `total_spend`, `segment`, `total_orders`

**Example Output**:
```
customer_id | customer_city | total_spend | segment | total_orders
------------|---------------|-----------|---------|---------------
cust_001    | Sao Paulo     | 15000     | Gold    | 5
cust_002    | Rio Janeiro   | 7500      | Silver  | 3
cust_003    | Brasilia      | 2000      | Bronze  | 1
```

---

## 🚀 How to Run

### **Option 1: Databricks (Recommended)**
```python
# 1. Upload datasets to Databricks
# 2. Open week0_phase5.ipynb
# 3. Update the path if needed:
#    /Volumes/workspace/default/olist/ → your actual path
# 4. Run all cells sequentially
```

### **Option 2: Local PySpark Environment**
```bash
# 1. Install PySpark
pip install pyspark

# 2. Download Olist dataset
# Download from: https://www.kaggle.com/olistbr/brazilian-ecommerce

# 3. Update paths in notebook
# Replace: /Volumes/workspace/default/olist/
# With: /path/to/your/olist/datasets/

# 4. Run Jupyter
jupyter notebook week0_phase5.ipynb
```

### **Step-by-Step Execution**
1. **Cell 1**: Data Loading - Read all 8 CSV files
2. **Cell 2**: Data Cleaning - Drop duplicates and nulls
3. **Cell 3**: DataFrame Join - Create comprehensive master dataset
4. **Cells 4-9**: Run Tasks 1-6 sequentially
5. **Cells 10+**: Optional - Export results to outputs folder

## 🔑 Key Concepts & Window Functions

### **Window Functions Explained**

A window function performs calculations across a set of rows related to the current row.

**Basic Syntax**:
```python
function_name().over(Window.partitionBy(...).orderBy(...))
```

### **Function Types**

| Function | Purpose | Example |
|----------|---------|---------|
| `RANK()` | Ranking with ties | 1, 1, 3, 4 |
| `DENSE_RANK()` | Continuous ranking | 1, 1, 2, 3 |
| `ROW_NUMBER()` | Sequential numbering | 1, 2, 3, 4 |
| `SUM()` | Cumulative aggregation | 100, 350, 700, 1200 |
| `AVG()` | Running average | 100, 175, 233, 300 |
| `LAG()` / `LEAD()` | Previous/next row values | Compare trends |

### **Partition vs Order By**

```python
# PARTITION BY: Divides data into groups
Window.partitionBy("city")           # Separate window per city

# ORDER BY: Defines row order within partition
Window.orderBy(col("sales").desc()) # Order by sales descending

# Combined: Top customers PER city
Window.partitionBy("city").orderBy(col("sales").desc())
```

## 📊 Data Cleaning Operations

### **Step 1: Remove Duplicates**
```python
customers = customers.dropDuplicates()
orders = orders.dropDuplicates()
order_items = order_items.dropDuplicates()
```
Why: Prevents double-counting and incorrect aggregations

### **Step 2: Handle Null Keys**
```python
customers = customers.dropna(subset=["customer_id"])
orders = orders.dropna(subset=["order_id", "customer_id"])
order_items = order_items.dropna(subset=["order_id", "product_id"])
```
Why: Key columns cannot be null for joins to work correctly

### **Step 3: Multi-table Join**
```python
df = orders.join(customers, "customer_id") \
    .join(order_items, "order_id") \
    .join(products, "product_id")
```
Why: Creates comprehensive dataset with all necessary columns for analysis

## 💡 Advanced Tips & Tricks

### **Tip 1: Performance Optimization**
```python
# Use broadcast for small tables
from pyspark.sql.functions import broadcast

df = df.join(broadcast(category), "product_category_name")
```

### **Tip 2: Export Results**
```python
# Save to CSV
top_customers.coalesce(1).write.mode("overwrite") \
    .csv("outputs/task1_top_customers")
```

### **Tip 3: Cache Large DataFrames**
```python
# Cache frequently used DataFrames
df.cache()
df.count()  # Trigger computation
```

### **Tip 4: Handle Data Type Issues**
```python
# Convert string numbers to proper types
df = df.withColumn("price", col("price").cast("double"))
```

## ⚙️ Common Issues & Solutions

| Error | Cause | Solution |
|-------|-------|----------|
| `FileNotFoundError` | Dataset path incorrect | Verify path in environment |
| `AnalysisException` | Column name mismatch | Check exact column names with `.printSchema()` |
| `OutOfMemory` | Large dataset | Use Databricks or increase memory |
| `Null values in output` | Missing joins | Use `join` instead of `inner_join` explicitly |
| `Rank showing as 1` | Missing `orderBy` in window | Add `.orderBy(col("metric").desc())` |

## 📈 Expected Outputs Summary

| Task | Primary Metric | Typical Result Count |
|------|---|---|
| Task 1 | Top 3 customers/city | ~300-350 rows (100 cities × 3) |
| Task 2 | Daily & cumulative sales | ~200-250 unique dates |
| Task 3 | Top products/category | ~70-100 rows (varies by category) |
| Task 4 | Customer CLV | ~119K rows (one per customer) |
| Task 5 | Segmentation | ~119K rows with segment labels |
| Task 6 | Full report | Full customer base with all metrics |

## 🎓 Real-World Business Applications

| Industry | Application | Techniques Used |
|----------|-------------|-----------------|
| **E-commerce** | Customer lifetime value, churn prediction | CLV, segmentation, window functions |
| **Banking** | Risk tier assignment, fraud detection | Ranking, cumulative analysis |
| **SaaS** | Usage analytics, tier recommendations | Running totals, product ranking |
| **Retail** | Inventory optimization, promotion targeting | Top products, customer segments |
| **Telecom** | Customer churn analysis, revenue attribution | Ranking, dense rank, joins |

## 📚 Learning Progression

```
Phase 1-2: Basics (SQL, Python)
    ↓
Phase 3-4: Intermediate (PySpark basics, segmentation)
    ↓
Phase 5: ADVANCED (Window functions, real datasets) ← YOU ARE HERE
    ↓
Phase 6: Production (Pipelines, optimization)
```

## 🔍 Self-Assessment Checklist

Before moving to Phase 6, confirm you can:
- [ ] Understand and explain window function syntax
- [ ] Differentiate between RANK, DENSE_RANK, ROW_NUMBER
- [ ] Perform multi-table joins correctly
- [ ] Calculate CLV and segment customers
- [ ] Use PARTITION BY and ORDER BY effectively
- [ ] Handle null values and duplicates in data
- [ ] Export results for further analysis
- [ ] Explain real-world business use cases

## 📖 Files Overview

| File | Purpose | Key Content |
|------|---------|------------|
| **week0_phase5.ipynb** | Main notebook | All 6 tasks with executable cells |
| **week0_phase5_problem_statement.pdf** | Requirements | Original problem statement |
| **README.md** | This guide | Complete learning reference |

## 🚀 Next Steps

### Immediate Next Steps
1. ✅ Run the notebook end-to-end
2. ✅ Modify window functions to explore different rankings
3. ✅ Change segmentation thresholds to see impact

### Advanced Challenges
1. **Add more segments**: Create 5-tier system with Platinum tier
2. **Time-based analysis**: Add order frequency and recency (RFM analysis)
3. **Geographic insights**: Compare segmentation across states/regions
4. **Product analysis**: Find product bundles frequently bought together
5. **Performance metrics**: Benchmark query execution times

### Path Forward
- **Phase 6**: Production pipelines, error handling, scheduling
- **Capstone**: Build complete data warehouse with these techniques
- **Focus**: Master window functions for any analytical role

## 📞 Key Takeaways

✔️ Window functions enable sophisticated analytics without leaving PySpark  
✔️ Multi-table joins create comprehensive business views  
✔️ Customer segmentation drives business strategy  
✔️ Real data (Olist) teaches practical e-commerce challenges  
✔️ Ranking functions (RANK, DENSE_RANK) solve common business problems  

---

**Last Updated**: April 2026  
**Dataset Source**: [Olist Brazilian E-commerce Dataset](https://www.kaggle.com/olistbr/brazilian-ecommerce)  
**License**: CC BY-SA 4.0  
**Questions?** Review window function documentation and experiment with parameters