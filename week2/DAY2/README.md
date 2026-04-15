# 📊 Week 2 - Day 2: Data Lakes & PySpark

## 🎯 Overview

Day 2 focuses on **modern data lake architecture** and **PySpark fundamentals** for processing large-scale datasets. You'll understand the shift from traditional data warehouses to flexible, scalable data lakes, and learn how to leverage PySpark for distributed data processing.

**Difficulty**: ⭐⭐⭐ Advanced  
**Time Estimate**: 75-90 minutes  
**Key Skills**: PySpark operations, data lake design, distributed processing

---

## 🎓 Learning Objectives

By the end of this day, you will be able to:
- ✅ Understand data lake vs. data warehouse architectures
- ✅ Work with PySpark DataFrames
- ✅ Perform transformations on large datasets
- ✅ Choose between CSV and Parquet formats
- ✅ Implement efficient data pipelines
- ✅ Handle distributed data processing

---

## 📚 Core Concepts

### **1. Data Lake vs Data Warehouse**

**Traditional Data Warehouse**:
```
Source Systems
    ↓
  [Extract → Transform → Load]
    ↓
  SCHEMA ON WRITE
  (Define structure first)
    ↓
  Optimized Tables
    ↓
  Fast Queries
```

**Modern Data Lake**:
```
Source Systems
    ↓
  [Store Raw Data]
    ↓
  SCHEMA ON READ
  (Define structure when querying)
    ↓
  Flexible Storage
  (Images, Logs, JSON, CSV, etc.)
    ↓
  On-Demand Processing
```

**Key Differences**:

| Aspect | Data Warehouse | Data Lake |
|--------|---|---|
| **Data Model** | Structured, predefined | Raw, any format |
| **Schema** | Defined before loading | Interpreted during reading |
| **Cost** | High (specialized storage) | Low (object storage like S3) |
| **Speed** | Fast (pre-optimized) | Variable (depends on query) |
| **Flexibility** | Low (fixed schema) | High (evolving schema) |
| **Processing** | Direct queries | Transform then query |
| **Governance** | Strict | Evolving |
| **Time to value** | Slow (design required) | Fast (store anything) |

**When to Use**:

```
Use Data Lake for:
✓ Exploratory analysis
✓ Machine learning
✓ Multiple schemas
✓ Raw data archival
✓ Cost-sensitive organizations

Use Data Warehouse for:
✓ Business analytics
✓ Static reports
✓ High concurrency
✓ Real-time dashboards
✓ Heavily audited organizations
```

### **2. Data Lake Architecture**

**Typical Data Lake Setup**:

```
┌─────────────────────────────────────────────────┐
│         DATA LAKE STORAGE LAYER                 │
│  (S3, ADLS, GCS - Object Storage)               │
│                                                 │
│  raw/                  Data ingested as-is      │
│  |-- sales/                                     │
│  |-- customers/                                 │
│  |-- logs/                                      │
│                                                 │
│  processed/            After transformation     │
│  |-- sales_clean/                               │
│  |-- customer_features/                         │
│                                                 │
│  analytics/            Analytics-ready          │
│  |-- sales_summary/                             │
│  |-- revenue_dashboard/                         │
└─────────────────────────────────────────────────┘
        ↓                    ↓                ↓
┌──────────────┐   ┌──────────────┐  ┌──────────────┐
│  PySpark     │   │   SQL        │  │   Python     │
│  Notebooks   │   │   Queries    │  │   ML Models  │
└──────────────┘   └──────────────┘  └──────────────┘
        ↓                    ↓                ↓
    ┌─────────────────────────────────┐
    │   ANALYTICS & INSIGHTS          │
    │   (Reports, Dashboards, ML)     │
    └─────────────────────────────────┘
```

### **3. PySpark Fundamentals**

**What is PySpark?**

PySpark is the **Python API for Apache Spark** - a distributed computing framework that:
- ✓ Processes data across multiple machines
- ✓ Handles datasets larger than memory
- ✓ Provides SQL, streaming, and ML libraries
- ✓ Optimizes execution automatically

**Basic Operations**:

```python
from pyspark.sql import SparkSession
from pyspark.sql.functions import col, sum, count, avg

# Create Spark Session
spark = SparkSession.builder.appName("DataLakeProcessing").getOrCreate()

# Read data
df = spark.read.csv("data/sales.csv", header=True, inferSchema=True)

# Select columns
df_selected = df.select("customer_id", "amount", "date")

# Filter data
df_filtered = df.filter(col("amount") > 1000)

# Group and aggregate
summary = df.groupBy("category").agg(
    sum("amount").alias("total_sales"),
    count("*").alias("order_count")
)

# Display results
summary.show()

# Write to Parquet
summary.write.parquet("output/summary")
```

### **4. Data Type Management**

**Infer Schema** (automatic, slower):
```python
df = spark.read.csv("data.csv", header=True, inferSchema=True)
```

**Explicit Schema** (faster, more control):
```python
from pyspark.sql.types import StructType, StructField, StringType, IntegerType

schema = StructType([
    StructField("customer_id", IntegerType()),
    StructField("amount", IntegerType()),
    StructField("date", StringType())
])

df = spark.read.schema(schema).csv("data.csv", header=True)
```

### **5. Transformations vs Actions**

**Transformations** (Lazy - not executed immediately):
- `filter()` - Remove rows
- `select()` - Choose columns
- `join()` - Combine DataFrames
- `groupBy()` - Aggregate
- `withColumn()` - Add/modify columns

**Actions** (Force computation):
- `show()` - Display data
- `collect()` - Get all data
- `write()` - Save to storage
- `count()` - Count rows

### **6. CSV vs Parquet**

**CSV**:
```
Pros:  Human readable, universal support
Cons:  Large files, slow to read, no schema
```

**Parquet**:
```
Pros:  10x smaller, 15x faster, schema included
Cons:  Binary format, not human readable
```

**Performance Comparison**:
```
File Size:    CSV: 1.2 GB  →  Parquet: 150 MB
Read Speed:   CSV: 30 sec  →  Parquet: 2 sec
```

---

## 💼 Real-World Pipeline Example

```python
from pyspark.sql.functions import col, to_date, sum, count

# 1. Read raw data
orders = spark.read.csv("data/orders.csv", header=True, inferSchema=True)
customers = spark.read.csv("data/customers.csv", header=True, inferSchema=True)

# 2. Clean orders
orders_clean = orders \
    .dropDuplicates() \
    .filter(col("amount") > 0) \
    .withColumn("order_date", to_date(col("date"), "yyyy-MM-dd"))

# 3. Join with customers
orders_enriched = orders_clean.join(customers, on="customer_id", how="left")

# 4. Aggregate
daily_summary = orders_enriched \
    .groupBy("order_date", "category") \
    .agg(
        sum("amount").alias("total_sales"),
        count("*").alias("order_count")
    )

# 5. Save results
daily_summary.write.mode("overwrite").parquet("data/summary")
```

---

## 🗂️ Files in This Module

- **week2_day2_datalakes.ipynb** - Interactive Jupyter notebook with hands-on examples
- **End_To_End_Pipeline_6.ipynb** - Complete end-to-end pipeline implementation
- **README.md** - This documentation

---

## 📋 Hands-On Lab Tasks

### **Task 1: Read and Explore Data**
- [ ] Load a CSV file into PySpark
- [ ] Print schema and first 5 rows
- [ ] Count total rows

### **Task 2: Basic Transformations**
- [ ] Filter data by criteria
- [ ] Select specific columns
- [ ] Add a new column with calculation

### **Task 3: Aggregations**
- [ ] Group by category
- [ ] Calculate sum and count
- [ ] Find top 5 items by sales

### **Task 4: Joins**
- [ ] Join two DataFrames
- [ ] Join with LEFT strategy
- [ ] Verify join results

### **Task 5: Data Pipeline**
- [ ] Read raw data
- [ ] Clean (remove NULLs, duplicates)
- [ ] Transform (join, aggregate)
- [ ] Save to Parquet

---

## 💡 Pro Tips

1. **Use Parquet for storage**, CSV only for import/export
2. **Cache frequently used DataFrames**: `df.cache()`
3. **Partition data for faster queries**: `.partitionBy("date")`
4. **Use column references for type safety**: `col("amount")`
5. **Check execution plans**: `df.explain()`

---

## ⚠️ Common Issues

| Issue | Solution |
|-------|----------|
| "No PySpark module" | Install: `pip install pyspark` |
| All columns read as strings | Use `inferSchema=True` |
| Out of memory errors | Use Parquet, partition data |
| Slow queries | Check for unnecessary shuffles, use Parquet |

---

## 📈 Expected Outcomes

By end of Day 2, you'll understand:

1. ✓ Data Lake architecture and benefits
2. ✓ PySpark DataFrame basics
3. ✓ Transformations and actions
4. ✓ CSV vs Parquet trade-offs
5. ✓ Building simple data pipelines
6. ✓ Performance optimization

---

## 🎓 Next Steps

After Day 2:
- ✓ Ready for Day 3 (Medallion Architecture)
- ✓ Can build simple data pipelines
- ✓ Understanding distributed data processing
- ✓ Prepared for real-world data engineering

---

**Data Lakes and PySpark power modern data engineering! 🚀**

Open the Jupyter notebooks and run through the examples!

"""



file\_path = "/mnt/data/README\_week2\_day2.md"

Path(file\_path).write\_text(content)



file\_path

