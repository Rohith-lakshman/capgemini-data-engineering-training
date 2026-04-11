# Phase 4A – Bucketing & Segmentation in PySpark

## Objective

Understand how continuous data is converted into meaningful categories (bucketing/segmentation) and implement multiple approaches using PySpark.

---

## Dataset

A small customer dataset with 5 records used to demonstrate all segmentation methods.

| customer_id | name    | country | total_spend |
|-------------|---------|---------|-------------|
| 101         | Alice   | USA     | 12000       |
| 102         | Bob     | INDIA   | 7000        |
| 103         | Charlie | UK      | 3000        |
| 104         | David   | INDIA   | 15000       |
| 105         | Eve     | USA     | 5000        |

---

## Methods Implemented

### 1. Conditional Logic (`when / otherwise`)

The most common and readable approach. Uses fixed business-defined thresholds.

```python
df_cond = df.withColumn(
    "segment",
    when(col("total_spend") > 10000, "Gold")
    .when((col("total_spend") >= 5000) & (col("total_spend") <= 10000), "Silver")
    .otherwise("Bronze")
)
```

| Threshold        | Segment |
|------------------|---------|
| total_spend > 10000  | Gold    |
| 5000 ≤ total_spend ≤ 10000 | Silver  |
| total_spend < 5000   | Bronze  |

**Result:**

| name    | total_spend | segment |
|---------|-------------|---------|
| Alice   | 12000       | Gold    |
| Bob     | 7000        | Silver  |
| Charlie | 3000        | Bronze  |
| David   | 15000       | Gold    |
| Eve     | 5000        | Silver  |

---

### 2. Group By Segment — Customer Count

```python
df_cond.groupBy("segment").agg(count("*").alias("customer_count")).show()
```

| segment | customer_count |
|---------|----------------|
| Gold    | 2              |
| Silver  | 2              |
| Bronze  | 1              |

---

### 3. MLlib Bucketizer

Splits the continuous column into numeric bucket indices. Useful inside ML pipelines.

```python
splits = [-float("inf"), 5000, 10000, float("inf")]
bucketizer = Bucketizer(splits=splits, inputCol="total_spend", outputCol="bucket")
df_bucket = bucketizer.transform(df)
```

| Bucket Index | Range              |
|--------------|--------------------|
| 0.0          | total_spend < 5000 |
| 1.0          | 5000 ≤ total_spend ≤ 10000 |
| 2.0          | total_spend > 10000 |

> Note: Bucketizer outputs numeric indices, not labels. Map them to labels for readability.

---

### 4. Quantile-Based Segmentation

Thresholds are derived from the actual data distribution (33rd and 66th percentiles), so segments are always roughly balanced.

```python
quantiles = df.approxQuantile("total_spend", [0.33, 0.66], 0)
q1, q2 = quantiles[0], quantiles[1]
```

Segments are then assigned using the computed `q1` and `q2` values instead of hardcoded numbers.

---

### 5. Window Function — Percent Rank

Ranks each row relative to the full dataset and assigns segments based on rank position.

```python
window = Window.orderBy("total_spend")
df_window = df.withColumn("rank_pct", percent_rank().over(window))
```

| rank_pct | Segment |
|----------|---------|
| ≥ 0.66   | Gold    |
| ≥ 0.33   | Silver  |
| < 0.33   | Bronze  |

---

## Final Comparison

Side-by-side view of how each method segments the same customers.

| customer_id | total_spend | conditional | quantile | window |
|-------------|-------------|-------------|----------|--------|
| 101         | 12000       | Gold        | Gold     | Gold   |
| 102         | 7000        | Silver      | Silver   | Silver |
| 103         | 3000        | Bronze      | Bronze   | Bronze |
| 104         | 15000       | Gold        | Gold     | Gold   |
| 105         | 5000        | Silver      | Bronze   | Silver |

> Eve (5000) shows a difference — conditional and window treat 5000 as Silver, while quantile may place it in Bronze depending on the computed threshold. This highlights how method choice affects boundary cases.

---

## Reflection

**Why convert continuous values into categories?**
Categories are easier to act on. A label like "Gold" is more actionable in a campaign or dashboard than a raw spend number.

**Business segmentation vs technical bucketing?**
Business segmentation uses domain-driven thresholds that carry real meaning. Technical bucketing (quantiles, Bucketizer) divides data mathematically without business context.

**When do fixed thresholds fail?**
When data distribution shifts over time — e.g., inflation raises average spend, making yesterday's Gold threshold capture too many or too few customers.

**Quantile vs fixed rules?**
Quantiles always produce balanced groups regardless of distribution. Fixed rules can create very skewed segments if data is not evenly spread around the thresholds.

**Best method for real-world projects?**
- `when/otherwise` — for business-defined rules, most readable and maintainable
- Quantile-based — for balanced groups or exploratory analysis
- MLlib Bucketizer — when bucketing is a preprocessing step inside an ML pipeline
- Window percent_rank — when relative ranking matters more than absolute thresholds

---

## How to Run

```bash
python phase4a_pyspark.py
```

**Requirements:** Python 3.x, PySpark (`pip install pyspark`)
