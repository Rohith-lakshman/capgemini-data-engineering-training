# Phase 4A: Customer Segmentation - Advanced Partitioning & Windowing Techniques

## Overview
Phase 4A focuses on **customer segmentation and data partitioning strategies** using multiple advanced techniques in both **SQL and PySpark**. This phase demonstrates how to categorize customers into meaningful segments (Gold, Silver, Bronze) based on spending patterns using different algorithmic approaches.

## Learning Objectives
By completing this phase, you will learn:
- ✅ Conditional logic-based segmentation (CASE WHEN statements)
- ✅ Machine Learning-based bucketing (MLlib Bucketizer)
- ✅ Quantile-based segmentation (percentile-based categorization)
- ✅ Window functions for ranking and relative positioning (PERCENT_RANK)
- ✅ Comparison of different segmentation methodologies
- ✅ Implementation in both SQL and PySpark frameworks

## Dataset
The phase uses a customer dataset with the following structure:

| Column | Type | Description |
|--------|------|-------------|
| customer_id | INT | Unique customer identifier |
| name | TEXT | Customer name |
| country | TEXT | Customer country |
| total_spend | INT | Total spending amount in currency units |

### Sample Data
```
101, Alice,   USA,    12000
102, Bob,     INDIA,   7000
103, Charlie, UK,      3000
104, David,   INDIA,  15000
105, Eve,     USA,     5000
```

## Segmentation Techniques

### 1. **Conditional Logic Segmentation**
Uses simple threshold-based CASE WHEN logic to categorize customers:
- **Gold**: total_spend > 10,000
- **Silver**: 5,000 ≤ total_spend ≤ 10,000
- **Bronze**: total_spend < 5,000

**Use Case**: Quick, interpretable categorization based on predefined thresholds

### 2. **Bucketizer (MLlib)**
Employs Machine Learning-based binning with predefined splits:
- **Splits**: [-∞, 5000, 10000, +∞]
- Assigns each customer to a discrete bucket/bin

**Use Case**: Statistical binning for feature engineering in ML pipelines

### 3. **Quantile-Based Segmentation**
Uses statistical quantiles (percentiles) to dynamically segment data:
- **Bronze**: 33rd percentile and below
- **Silver**: Between 33rd and 66th percentileile
- **Gold**: Above 66th percentile

**Use Case**: Ensures balanced segments regardless of data distribution; better for relative ranking

### 4. **Window Function Segmentation**
Uses `PERCENT_RANK()` window function for ranking-based segmentation:
- Calculates the percentile rank of each customer's spending
- **Gold**: rank ≥ 66%
- **Silver**: rank ≥ 33% and < 66%
- **Bronze**: rank < 33%

**Use Case**: Rank-based partitioning for competitive analysis and relative performance

### 5. **Comparison View**
Combines all segmentation methods to compare results:
- Shows how each technique categorizes the same customers
- Highlights differences in segmentation approaches

## Project Structure

```
phase4A/
├── phase4a_pyspark.py      # PySpark implementation
├── phase4a.sql             # SQL queries
├── run_sql.py              # SQLite runner script
├── README.md               # This file
└── outputs/
    ├── pyspark_outputs/    # PySpark execution results
    └── sql_outputs/        # SQL execution results
```

## How to Run

### Option 1: Run SQL Queries with SQLite
```bash
python run_sql.py
```

**Output**: Executes all 5 tasks and displays results in console
- Creates `phase4a.db` database file
- Runs CREATE TABLE and INSERT statements
- Executes all segmentation queries

### Option 2: Run PySpark Implementation
```bash
python phase4a_pyspark.py
```

**Output**: Displays segmentation results for all 4 techniques
- Requires: `pyspark` installed
- Shows comparisons between methods
- Displays customer counts per segment

## Expected Outputs

### Conditional Segmentation
```
Customer | Total_Spend | Segment
---------|-------------|--------
Alice    | 12000       | Gold
Bob      | 7000        | Silver
Charlie  | 3000        | Bronze
David    | 15000       | Gold
Eve      | 5000        | Silver
```

### Count by Segment
```
Gold:   2 customers
Silver: 2 customers
Bronze: 1 customer
```

### Comparison View
Shows how each segmentation method (Conditional, Quantile, Window) categorizes the same customer

## Key Concepts

### Segmentation vs. Partitioning
- **Segmentation**: Logical grouping of data based on business rules
- **Partitioning**: Physical/logical division of data for processing efficiency

### When to Use Each Technique

| Technique | Best For | Pros | Cons |
|-----------|----------|------|------|
| **Conditional Logic** | Simple, fixed rules | Easy to understand, deterministic | Requires manual threshold adjustment |
| **Bucketizer** | ML feature engineering | Integrates with ML pipelines | Complex setup for simple cases |
| **Quantile-Based** | Balanced segments | Automatic distribution, scalable | Less intuitive thresholds |
| **Window Functions** | Ranking, relative analysis | Works with large datasets, flexible | Requires SQL/PySpark knowledge |

## SQL Concepts Covered
- `CASE WHEN BETWEEN ... THEN ... ELSE` statements
- `PERCENT_RANK()` window function
- `OVER (ORDER BY ...)` clause
- Subqueries and CTEs for complex transformations
- `GROUP BY` for aggregation

## PySpark Concepts Covered
- `when()`, `otherwise()` for conditional logic
- `Bucketizer` from `pyspark.ml.feature`
- `approxQuantile()` for statistical quantile calculation
- Window functions: `Window.orderBy()`, `percent_rank()`
- DataFrame joins and column aliasing

## Advanced Exercises

1. **Add more segmentation levels**: Create 5-tier segmentation (Platinum, Gold, Silver, Bronze, Iron)
2. **Dynamic threshold adjustment**: Modify thresholds based on country or date ranges
3. **Multi-criteria segmentation**: Combine total_spend with customer_age or purchase_frequency
4. **Performance testing**: Compare execution time across segmentation techniques
5. **Real-world data**: Apply to large customer datasets and analyze distribution

## Files Reference

### [phase4a_pyspark.py](phase4a_pyspark.py)
- **Lines 1-10**: Setup SparkSession and sample data
- **Lines 15-30**: Conditional Logic Segmentation
- **Lines 35-40**: Bucketizer implementation
- **Lines 45-60**: Quantile-based Segmentation
- **Lines 65-80**: Window Function Segmentation
- **Lines 85-95**: Comparison view combining all methods

### [phase4a.sql](phase4a.sql)
- **Task 1**: Conditional segmentation CASE WHEN logic
- **Task 2**: Aggregation with COUNT by segment
- **Task 3**: Quantile-style manual approximation
- **Task 4**: Window function with PERCENT_RANK
- **Task 5**: Final comparison query joining all methods

### [run_sql.py](run_sql.py)
- SQLite database connection and execution
- Reads and executes SQL file
- Prints formatted results for each task

## Dependencies

### For PySpark execution:
```bash
pip install pyspark
```

### For SQL execution:
```bash
# SQLite is included in Python standard library
python run_sql.py
```

## Common Errors & Solutions

| Error | Cause | Solution |
|-------|-------|----------|
| SparkSession not found | PySpark not installed | `pip install pyspark` |
| Database file conflicts | Previous runs created `phase4a.db` | Delete `phase4a.db` before re-running |
| SQL syntax errors | SQLite doesn't support all SQL dialects | Use SQLite-compatible syntax |

## Comparison: SQL vs PySpark

| Aspect | SQL | PySpark |
|--------|-----|---------|
| Ease of use | Simpler for standard queries | More verbose but flexible |
| Performance | Fast for structured data | Distributed, scales better |
| Integration | Works with databases | Integrates with Python ML libraries |
| Bucketing | Not available | MLlib Bucketizer built-in |

## Real-World Applications

1. **E-commerce**: Segment customers for targeted marketing campaigns
2. **Banking**: Risk assessment and customer tier classification
3. **SaaS**: Customer LTV-based segment for retention strategies
4. **Retail**: Inventory allocation based on customer segments
5. **Telecommunications**: Service tier assignment based on usage patterns

## Next Steps

- **Phase 5**: Dashboard and visualization of segmentation results
- **Phase 6**: Production-level implementation with error handling and logging
- **Advanced**: Implement clustering algorithms (K-means) for automatic segment detection

## Key Takeaways

✔️ Multiple segmentation techniques serve different use cases  
✔️ Quantile-based segmentation provides automatic, balanced segments  
✔️ Window functions enable rank-based analysis at scale  
✔️ Always compare methods to choose the best for your business context  
✔️ Both SQL and PySpark have their strengths for segmentation tasks  

---

**Last Updated**: April 2026  
**Difficulty Level**: ⭐⭐⭐ Intermediate  
**Estimated Time**: 30-45 minutes
