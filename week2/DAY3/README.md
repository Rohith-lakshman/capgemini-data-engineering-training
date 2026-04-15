# 🏅 Medallion Architecture with PySpark & Delta Lake

## 📌 Overview

This project demonstrates the **Medallion Architecture** (Bronze → Silver → Gold) using **PySpark** and **Delta Lake** on a sample e-commerce orders dataset. The goal is to progressively refine raw, messy data into clean, analytics-ready tables.

---

## 🏗️ Architecture

```
Raw Data
   ↓
[BRONZE LAYER]  →  Store raw data as-is
   ↓
[SILVER LAYER]  →  Clean, deduplicate, and fix data types
   ↓
[GOLD LAYER]    →  Aggregated, business-ready insights
```

---

## 📂 Project Structure

```
week2_day3_medallion_architecture.ipynb   # Main notebook
README.md                                  # This file
```

---

## 📊 Dataset

A synthetic e-commerce orders dataset is created inline with **11 records** (including intentional data quality issues for learning purposes).

| Column        | Type   | Description                        |
|---------------|--------|------------------------------------|
| `order_id`    | int    | Unique order identifier            |
| `customer_id` | string | Customer identifier                |
| `product`     | string | Product name                       |
| `category`    | string | Product category                   |
| `city`        | string | Delivery city                      |
| `date`        | string | Order date (YYYY-MM-DD)            |
| `amount`      | string | Order amount in INR (raw string)   |
| `quantity`    | int    | Number of units ordered            |

### ⚠️ Intentional Data Quality Issues

The raw dataset includes these issues (to practise cleaning):

- `None` value in `amount` (order 102)
- `None` value in `city` (order 107)
- **Negative amount** `-45000` (order 108)
- **Duplicate row** (order 109 appears twice)
- **Updated record** — order 103 appears with a newer date and revised amount

---

## 🔄 Layers Explained

### 🥉 Bronze Layer — Raw Ingestion

- Ingests data **as-is** with no transformations.
- Saved to: `bronze.orders_raw`
- Purpose: Preserve the original data for auditability and reprocessing.

```python
df.write.mode("overwrite") \
    .option("mergeSchema", "true") \
    .saveAsTable("bronze.orders_raw")
```

---

### 🥈 Silver Layer — Cleaned & Validated

Applies the following transformations to produce a clean dataset:

| Step | Action |
|------|--------|
| **Type casting** | `amount` → float, `quantity` → int, `date` → date |
| **Fix negatives** | Negative `amount` values converted to positive using `abs()` |
| **Fill nulls** | `amount` nulls → `0`, `city` nulls → `"Unknown"` |
| **Deduplication** | Removes exact duplicate rows with `dropDuplicates()` |
| **Latest record** | For updated records, keeps only the most recent entry per `order_id` using a window function (`row_number()` ordered by `date DESC`) |

- Saved to: `silver.orders_cleaned`

```python
# Key window logic to keep only the latest version of each order
window_spec = Window.partitionBy("order_id").orderBy(col("date").desc())
silver_df = silver_df.withColumn("rn", row_number().over(window_spec)) \
                     .filter(col("rn") == 1) \
                     .drop("rn")
```

---

### 🥇 Gold Layer — Business Aggregations

Produces ready-to-use analytical tables from the Silver layer:

| Gold Table | Description |
|------------|-------------|
| `gold.total_sales_by_product` | Total sales revenue grouped by product |
| `gold.total_sales_by_category` | Total sales revenue grouped by category |
| `gold.total_sales_by_city` | Total sales revenue grouped by city |
| `gold.total_orders_by_customer` | Total number of orders per customer |
| `gold.top_customer` | Customer with the highest number of orders |

> **Note:** `gold.top_selling_product` is computed and displayed but not saved to a table in the current version.

---

## ⚙️ Prerequisites

| Requirement | Details |
|-------------|---------|
| Platform | Databricks (recommended) or any PySpark environment |
| PySpark | 3.x |
| Delta Lake | Enabled via Databricks Runtime or `delta-spark` package |
| Catalog | Unity Catalog or Hive Metastore (schemas: `bronze`, `silver`, `gold`) |

---

## 🚀 How to Run

1. Open the notebook `week2_day3_medallion_architecture.ipynb` in **Databricks**.
2. Attach it to a cluster with **Delta Lake** support.
3. Run all cells **top to bottom** in order.
4. The three schemas (`bronze`, `silver`, `gold`) will be created automatically.
5. Verify the results by querying the tables:

```sql
SELECT * FROM bronze.orders_raw;
SELECT * FROM silver.orders_cleaned;
SELECT * FROM gold.total_sales_by_product;
```

---

## 🐛 Known Issues / Improvements

- `gold.top_selling_product` is derived but **not persisted** to a Gold table — consider saving it.
- Variable is named `sliver_df` (typo) instead of `silver_df` throughout — worth fixing for clarity.
- The dataset is hardcoded inline; consider reading from an external source (CSV, ADLS, S3) for real-world use.
- No schema enforcement on the Bronze layer — adding an explicit schema improves reliability.

---

## 📚 Concepts Covered

- ✅ Medallion Architecture (Bronze / Silver / Gold)
- ✅ PySpark DataFrame transformations
- ✅ Data type casting
- ✅ Null handling and data imputation
- ✅ Deduplication strategies
- ✅ Window functions for SCD (Slowly Changing Dimensions)
- ✅ Delta Lake table writes
- ✅ Aggregations and business metric computation

---

## 👤 Author

**Week 2 – Day 3 | Data Engineering Training**