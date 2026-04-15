# 📚 Week 0: Learning Pathway 1 - Associate Data Engineering Fundamentals

## 🎯 Overview

Week 0 provides the **foundational knowledge for data engineering**, progressively taking you from basic SQL and PySpark concepts to building complete **ETL pipelines** and working with **real-world e-commerce datasets**. By the end of this week, you'll have hands-on experience with data extraction, transformation, loading, and advanced analytics.

---

## 📊 Course Structure

This week consists of **6 progressive phases**, each building upon the previous knowledge:

| Phase | Title | Duration | Difficulty | Key Topics |
|-------|-------|----------|------------|-----------|
| **1** | SQL to PySpark Basics | 30-45 min | ⭐ Beginner | SELECT, WHERE, GROUP BY, COUNT operations |
| **2** | SQL to PySpark Bridge | 45-60 min | ⭐⭐ Intermediate | JOINs, Aggregations, Real-world datasets |
| **3** | ETL & Pipeline Fundamentals | 60-90 min | ⭐⭐ Intermediate | Extract, Transform, Load workflow |
| **4** | ETL Pipeline with SQL + Python | 60-75 min | ⭐⭐ Intermediate | End-to-end pipeline with business analysis |
| **5** | Advanced Analytics with Olist Dataset | 90-120 min | ⭐⭐⭐ Advanced | Window functions, Customer segmentation, CLV |
| **6** | (Capstone/Advanced Project) | Variable | ⭐⭐⭐ Advanced | Comprehensive project integration |

---

## 🔍 Detailed Phase Descriptions

### **Phase 1: SQL to PySpark Basics**
**Folder**: `phase1/`

Learn the fundamental operations in SQL and their equivalent PySpark DataFrame operations.

**Key Learning Objectives**:
- ✅ Understand DataFrames as equivalent to tables
- ✅ Master basic SELECT, WHERE, and GROUP BY operations
- ✅ Learn COUNT aggregations
- ✅ Map SQL concepts to PySpark syntax

**Files**:
- `pyspark_code.py` - PySpark implementations
- `sql_queries.py` - Python script to execute SQL
- `sql_queries.sql` - SQL query examples
- `week0_phase1_problem_statement.pdf` - Assignment details
- `outputs/` - Query execution results

**Sample Dataset**:
```
customers table:
- customer_id (INT)
- customer_name (VARCHAR)
- city (VARCHAR)
- age (INT)
```

**Recommended Time**: 30-45 minutes

---

### **Phase 2: SQL to PySpark Bridge**
**Folder**: `phase2/`

Bridge SQL and PySpark by working with more complex operations on realistic datasets.

**Key Learning Objectives**:
- ✅ Perform JOIN operations on multiple tables
- ✅ Implement aggregations (SUM, AVG, MAX)
- ✅ Solve real-world business problems
- ✅ Work with CSV data in PySpark

**Files**:
- `pyspark_code.py` - PySpark implementations
- `run_sql.py` - Execute SQL queries
- `phase2.sql` - Full SQL implementation
- `sql_queries.sql` - Individual SQL queries
- `samples/` - Sample CSV files (customers.csv, orders.csv)
- `outputs/` - Result sets

**Sample Dataset**:
```
customers: customer_id, customer_name, city
orders: order_id, customer_id, amount
```

**Business Tasks**:
1. Calculate total order amount per customer
2. Identify top 3 customers by spending
3. Find customers with no orders
4. Generate city-wise revenue reports

**Recommended Time**: 45-60 minutes

---

### **Phase 3: ETL & Pipeline Fundamentals**
**Folder**: `phase3/`

Understand the complete ETL workflow and begin building structured data pipelines.

**Key Learning Objectives**:
- ✅ Master the Extract, Transform, Load (ETL) process
- ✅ Handle data quality (dropna, filtering)
- ✅ Perform multi-table joins
- ✅ Apply business logic transformations
- ✅ Structure data for analytics

**Files**:
- `phase3_pipeline.py` - Complete ETL pipeline
- `phase3_etl.sql` - SQL transformations
- `run_sql.py` - Pipeline execution
- `samples/` - Sample data files
- `outputs/` - Final output reports

**ETL Workflow**:

```
1. EXTRACT
   └─ Load CSV files → Spark DataFrames

2. TRANSFORM
   └─ Remove null values
   └─ Filter invalid records
   └─ Join customers with orders
   └─ Perform aggregations (SUM, COUNT, AVG)

3. LOAD
   └─ Display results
   └─ Save to outputs/final_report
```

**Business Tasks**:
1. Total order amount per customer
2. Top customers by spending
3. Customer-wise order count
4. City-wise revenue analysis

**Recommended Time**: 60-90 minutes

---

### **Phase 4: ETL Pipeline with SQL + Python**
**Folder**: `phase4/`

Build a complete end-to-end ETL pipeline with comprehensive business analysis and reporting.

**Key Learning Objectives**:
- ✅ Implement data cleaning and validation
- ✅ Handle duplicate records and null values
- ✅ Build production-ready pipelines
- ✅ Generate business intelligence reports
- ✅ Export results to CSV and databases

**Files**:
- `phase4_pipeline.py` - Full Python ETL implementation
- `phase4.sql` - SQL analysis queries
- `run_sql.py` - Execution script
- `final_report.csv` - Output report
- `samples/` - Sample datasets
- `outputs/` - Intermediate and final results

**Pipeline Steps**:

```
EXTRACT
├─ Load customers table
└─ Load orders table

CLEAN
├─ Remove null customer_id
├─ Remove duplicate records
└─ Filter invalid values (age > 0, amount > 0)

TRANSFORM
├─ Join customers and orders
├─ Aggregate by customer/city/date
└─ Calculate KPIs

ANALYZE (7 Key Tasks)
├─ Daily sales analysis
├─ City-wise revenue breakdown
├─ Top 5 customers identification
├─ Repeat customer analysis
├─ Customer segmentation
├─ Product performance analysis
└─ Final comprehensive report

LOAD
└─ Save to database/CSV
```

**How to Run**:
```bash
python run_sql.py
```

**Output Files**:
- `final_report.csv` - Master analysis report
- `outputs/` - Intermediate result sets

**Recommended Time**: 60-75 minutes

---

### **Phase 5: Advanced Analytics with Olist E-commerce Dataset**
**Folder**: `phase5/`

Master advanced analytical techniques using PySpark with a **real-world Brazilian e-commerce dataset**.

**Difficulty**: ⭐⭐⭐⭐ Advanced  
**Estimated Time**: 90-120 minutes

**Key Learning Objectives**:
- ✅ Load and clean large-scale datasets
- ✅ Perform complex multi-table joins (6+ tables)
- ✅ Implement window functions (RANK, DENSE_RANK, LAG, LEAD)
- ✅ Calculate Customer Lifetime Value (CLV)
- ✅ Design rule-based customer segmentation
- ✅ Handle real-world data quality issues

**Files**:
- `week0_phase5.ipynb` - Jupyter notebook with complete analysis
- `week0_phase5_problem_statement.pdf` - Assignment details

**Olist Brazilian E-commerce Dataset**:

| Dataset | Records | Contents |
|---------|---------|----------|
| **olist_customers_dataset.csv** | ~119K | Customer IDs, locations (city, state, zip code) |
| **olist_orders_dataset.csv** | ~99K | Order IDs, timestamps, delivery status |
| **olist_order_items_dataset.csv** | ~112K | Products per order with unit prices |
| **olist_products_dataset.csv** | ~32K | Product IDs, categories, dimensions, weight |
| **olist_order_payments_dataset.csv** | ~103K | Payment methods and amounts |
| **olist_sellers_dataset.csv** | ~3.6K | Seller information and location |

**Advanced Topics Covered**:

1. **Data Loading & Cleaning**
   - Handle missing values at scale
   - Parse timestamps
   - Validate data consistency

2. **Complex Multi-table Joins**
   - Join 6+ tables efficiently
   - Manage key relationships
   - Optimize join performance

3. **Window Functions**
   - `RANK()` - Dense ranking of products by sales
   - `DENSE_RANK()` - Non-skipping rankings
   - Cumulative aggregations
   - Partitioning strategies

4. **Advanced Aggregations**
   - Total sales per customer
   - Average order value per city
   - Product performance metrics
   - Repeat purchase analysis

5. **Customer Segmentation**
   - High-value vs. low-value customers
   - Frequent vs. occasional buyers
   - Geographic segmentation
   - Behavioral patterns

6. **Customer Lifetime Value (CLV)**
   - Calculate total value per customer
   - Identify VIP customers
   - Predict customer retention

**Real-World Skills Gained**:
- Working with enterprise-scale datasets
- Building analytical dashboards
- Creating business intelligence reports
- Handling production data quality issues

**Recommended Time**: 90-120 minutes

---

### **Phase 6: Capstone/Advanced Project**
**Folder**: `phase6/`

*Capstone project bringing together all concepts from Phases 1-5.*

---

## 📋 Prerequisites

Before starting Week 0, ensure you have:
- ✅ Installed Python 3.8+
- ✅ Installed PySpark
- ✅ Installed Jupyter Notebook
- ✅ Installed either SQLite or MySQL
- ✅ Basic understanding of SQL (SELECT, WHERE, JOIN)
- ✅ Python fundamentals (variables, loops, functions)

---

## 🚀 How to Use This Week

### **Step 1: Start with Phase 1**
- Go to `phase1/` and read its README
- Execute SQL queries first (sql_queries.sql)
- Compare outputs with PySpark implementations
- Understand the SQL-to-PySpark mapping

### **Step 2: Progress Through Phases**
- Complete each phase sequentially
- Compare your results with provided outputs/
- Take time to understand the concepts
- Don't rush to the next phase

### **Step 3: Build Your Pipeline**
- Phases 3-4 are where you build ETL pipelines
- These are practical, hands-on projects
- Focus on the workflow (Extract → Transform → Load)
- Practice writing clean, modular code

### **Step 4: Apply Advanced Analytics** (Phase 5)
- Work with real datasets
- Implement window functions
- Perform customer analysis
- Generate business insights

### **Step 5: Complete the Capstone** (Phase 6)
- Integrate all concepts
- Build an end-to-end solution
- Present your findings

---

## 🔧 Tools & Technologies

| Tool | Purpose |
|------|---------|
| **Python** | Primary programming language |
| **PySpark** | Distributed data processing |
| **SQL** | Data querying and manipulation |
| **Jupyter Notebook** | Interactive coding environment |
| **SQLite/MySQL** | Database management |
| **Pandas** | Data manipulation and analysis |

---

## 📈 Expected Outcomes

After completing Week 0, you will be able to:

1. **Write SQL queries** for common data operations
2. **Translate SQL** to PySpark DataFrame operations
3. **Build complete ETL pipelines** from scratch
4. **Clean and transform** real-world datasets
5. **Perform complex joins** on multiple tables
6. **Implement window functions** for advanced analytics
7. **Segment customers** based on business rules
8. **Generate business reports** and insights
9. **Handle production data** quality issues
10. **Work with large-scale datasets** efficiently

---

## ⏱️ Time Breakdown

| Phase | Time | Cumulative |
|-------|------|-----------|
| Phase 1 | 30-45 min | 30-45 min |
| Phase 2 | 45-60 min | 1.25-2 hours |
| Phase 3 | 60-90 min | 2.5-3.5 hours |
| Phase 4 | 60-75 min | 4-5 hours |
| Phase 5 | 90-120 min | 6-7 hours |
| **Total** | | **~6-7 hours** |

---

## 💡 Tips for Success

1. **Don't Skip Basics**: Phase 1 might seem simple, but it's fundamental
2. **Understand Concepts**: Don't just memorize SQL syntax
3. **Experiment**: Try modifying queries to see different results
4. **Compare Outputs**: Always check your results against provided outputs
5. **Ask Questions**: If concepts aren't clear, revisit the material
6. **Build Incrementally**: Don't try to do everything at once

---

## 🆘 Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| "No module named 'pyspark'" | Install PySpark: `pip install pyspark` |
| Database connection errors | Check database is running and credentials |
| CSV file not found | Verify path is correct (use absolute paths) |
| Schema errors | Ensure data types match table definitions |

---

## 📚 Additional Resources

- [PySpark Documentation](https://spark.apache.org/docs/latest/api/python/)
- [SQL Tutorial](https://www.w3schools.com/sql/)
- [ETL Best Practices](https://en.wikipedia.org/wiki/Extract,_transform,_load)
- [Data Engineering Concepts](https://en.wikipedia.org/wiki/Data_engineering)

---

## 🎓 Next Steps

After completing Week 0:
- Move to Week 1 for intermediate SQL concepts
- Continue to Week 2 for advanced architecture patterns
- Start building your own data engineering projects

---

**Happy Learning! 🚀**
