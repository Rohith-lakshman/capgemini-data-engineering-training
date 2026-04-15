# 📊 Week 1 - Day 4: Advanced Aggregations & Grouping

## 🎯 Overview

Day 4 builds on the grouping concepts from Week 0 and explores **complex aggregation scenarios** that real-world data engineers face daily. You'll learn to handle multi-dimensional grouping, post-aggregation filtering, and conditional aggregations that power business intelligence.

---

## 🎓 Learning Objectives

By the end of this day, you will be able to:
- ✅ Write GROUP BY queries with multiple columns
- ✅ Distinguish WHERE vs HAVING for efficient filtering
- ✅ Use aggregate functions (SUM, AVG, COUNT, MAX, MIN)
- ✅ Count distinct values safely
- ✅ Implement conditional aggregations using CASE within aggregates
- ✅ Solve complex reporting requirements

---

## 📚 Core Concepts

### **1. GROUP BY Fundamentals**

**Basic Syntax**:
```sql
SELECT column1, column2, aggregate_function(column3)
FROM table
GROUP BY column1, column2;
```

**Rules**:
- Every column in SELECT must either be grouped or aggregated
- GROUP BY columns must appear in SELECT
- NULL values form their own group
- Group order doesn't guarantee result order (use ORDER BY)

**Example 1: Total Sales per Department**
```sql
SELECT department, SUM(salary) as total_salary
FROM employees
GROUP BY department;
```

**Output**:
```
department  total_salary
Finance     450000
Engineering 550000
HR          200000
```

### **2. Multiple Column Grouping**

Group by **multiple dimensions** for detailed analysis.

**Example: Sales by Department AND Performance Rating**
```sql
SELECT department, performance_rating,
  COUNT(*) as employee_count,
  AVG(salary) as avg_salary,
  MAX(salary) as max_salary,
  MIN(salary) as min_salary
FROM employees
GROUP BY department, performance_rating
ORDER BY department, performance_rating;
```

**Output**:
```
department  performance_rating  emp_count  avg_salary  max_salary  min_salary
Finance     A                   4          95000       102000      92000
Finance     B                   3          70000       78000       61000
Finance     C                   1          47000       47000       47000
Engineering A                   3          85000       95000       72000
...
```

**Use Cases**:
- Sales by region and product
- Employee counts by department and level
- Revenue by customer segment and geography
- Order volume by channel and status

### **3. WHERE vs HAVING**

**Critical Difference**:

| Aspect | WHERE | HAVING |
|--------|-------|--------|
| **Timing** | Before grouping | After grouping |
| **Filters** | Individual rows | Groups as a whole |
| **Use Case** | Exclude rows before aggregation | Include/exclude groups based on aggregate values |
| **Performance** | Better (filters early) | Slower (filters after aggregation) |

**Visual Example**:

```
Raw Data
├─ Row 1: Finance, 95000 ──┐
├─ Row 2: Finance, 55000 ──┼─ [WHERE] filters these rows
├─ Row 3: Finance, 78000 ──┤
├─ Row 4: Engineering, 88000
└─ Row 5: Engineering, 72000
         ↓
[GROUP BY department]
├─ Finance Group: (95000 + 55000 + 78000) = 228000
├─ Engineering Group: (88000 + 72000) = 160000
         ↓
[HAVING] Filters groups
├─ Finance: 228000 ✓ (> 200000)
├─ Engineering: 160000 ✗ (< 200000)
```

**Example: WHERE vs HAVING**

```sql
-- WRONG: Can't use WHERE with aggregate
SELECT department, SUM(salary) as total
FROM employees
WHERE SUM(salary) > 200000  -- ERROR!
GROUP BY department;

-- CORRECT: Use HAVING for aggregate filtering
SELECT department, SUM(salary) as total
FROM employees
GROUP BY department
HAVING SUM(salary) > 200000;
```

**Example: WHERE and HAVING Together**

```sql
-- GOOD: Filter rows first, then group
SELECT department, performance_rating,
  COUNT(*) as emp_count,
  AVG(salary) as avg_salary
FROM employees
WHERE salary > 50000  -- Filter rows first (WHERE)
GROUP BY department, performance_rating
HAVING COUNT(*) > 2  -- Filter groups (HAVING)
ORDER BY department;
```

**Performance Impact**:

```sql
-- SLOW: Groups all employees, then filters
SELECT department, COUNT(*) as emp_count
FROM employees
GROUP BY department
HAVING COUNT(*) > 5;
-- Aggregates all data, then filters

-- FAST: Filters first, then groups
SELECT department, COUNT(*) as emp_count
FROM employees
WHERE status = 'Active'  -- Reduce rows early
GROUP BY department
HAVING COUNT(*) > 5;
-- Fewer rows to aggregate
```

### **4. Aggregate Functions**

**Common Functions** (Work with numbers):

| Function | Purpose | NULL Handling |
|----------|---------|----------------|
| `COUNT(*)` | Count all rows | Includes NULLs |
| `COUNT(column)` | Count non-NULL values | Excludes NULLs |
| `SUM(column)` | Total of numeric column | NULLs ignored |
| `AVG(column)` | Average of numeric column | NULLs ignored |
| `MAX(column)` | Highest value | NULLs ignored |
| `MIN(column)` | Lowest value | NULLs ignored |
| `STDDEV(column)` | Standard deviation | NULLs ignored |

**String Aggregates** (Vary by database):

```sql
-- MySQL
SELECT department, GROUP_CONCAT(emp_name, ', ')
FROM employees
GROUP BY department;

-- PostgreSQL
SELECT department, STRING_AGG(emp_name, ', ')
FROM employees
GROUP BY department;

-- SQL Server
SELECT department, STRING_AGG(emp_name, ', ') WITHIN GROUP (ORDER BY emp_name)
FROM employees
GROUP BY department;
```

### **5. Distinct in Aggregates**

Count **unique values** safely:

```sql
-- Wrong: Might count some customers twice
SELECT COUNT(customer_id) FROM orders;

-- Correct: Count unique customers
SELECT COUNT(DISTINCT customer_id) from orders;
```

**Example: Unique Customer Count per City**

```sql
SELECT city,
  COUNT(DISTINCT customer_id) as unique_customers,
  COUNT(*) as total_orders,
  SUM(amount) as revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY city
ORDER BY revenue DESC;
```

---

## 💼 Real-World Examples

### **Example 1: Sales Performance Report**

**Requirement**: Analyze sales by region, product, and month

```sql
SELECT 
  region,
  product,
  EXTRACT(YEAR_MONTH FROM sale_date) as month,
  COUNT(*) as transaction_count,
  SUM(amount) as total_sales,
  AVG(amount) as avg_transaction,
  MAX(amount) as highest_sale,
  MIN(amount) as lowest_sale,
  COUNT(DISTINCT customer_id) as unique_customers
FROM sales
GROUP BY region, product, EXTRACT(YEAR_MONTH FROM sale_date)
ORDER BY region, product, month;
```

### **Example 2: Department Budget Variance**

**Requirement**: Compare budget vs actual spend with variance

```sql
SELECT 
  department,
  YEAR(hire_date) as hire_year,
  COUNT(*) as headcount,
  SUM(salary) as total_payroll,
  AVG(salary) as avg_salary,
  MAX(salary) - MIN(salary) as salary_range,
  STDDEV(salary) as salary_stddev
FROM employees
GROUP BY department, YEAR(hire_date)
HAVING COUNT(*) > 5
ORDER BY department, hire_year;
```

### **Example 3: Customer Lifetime Value**

**Requirement**: Calculate CLV and segment customers

```sql
SELECT 
  c.customer_id,
  c.customer_name,
  COUNT(o.order_id) as order_count,
  SUM(o.amount) as lifetime_value,
  AVG(o.amount) as avg_order_value,
  MAX(o.sale_date) as last_purchase_date,
  CASE
    WHEN SUM(o.amount) > 10000 THEN 'VIP'
    WHEN SUM(o.amount) > 5000 THEN 'Premium'
    ELSE 'Standard'
  END as customer_segment
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(o.order_id) > 0
ORDER BY lifetime_value DESC;
```

### **Example 4: Conditional Aggregations with CASE**

**Requirement**: Break down revenue by order status

```sql
SELECT 
  order_date,
  SUM(amount) as total_revenue,
  SUM(CASE WHEN status = 'Completed' THEN amount ELSE 0 END) as completed_revenue,
  SUM(CASE WHEN status = 'Pending' THEN amount ELSE 0 END) as pending_revenue,
  SUM(CASE WHEN status = 'Cancelled' THEN amount ELSE 0 END) as cancelled_revenue,
  COUNT(*) as total_orders,
  COUNT(CASE WHEN status = 'Completed' THEN 1 END) as completed_count
FROM orders
GROUP BY order_date
ORDER BY order_date DESC;
```

**Output Shows**:
```
order_date  total  completed  pending  cancelled  total_orders  completed_count
2024-01-10  5000   3500       1500     0          10            8
2024-01-09  4200   4200       0        0          9             9
2024-01-08  6800   5300       800      700        12            10
```

### **Example 5: Ranking Groups**

**Requirement**: Find top 3 departments by total sales

```sql
WITH dept_sales AS (
  SELECT 
    department,
    SUM(salary) as total_salary,
    COUNT(*) as emp_count
  FROM employees
  GROUP BY department
)
SELECT 
  ROW_NUMBER() OVER (ORDER BY total_salary DESC) as rank,
  department,
  total_salary,
  emp_count
FROM dept_sales
LIMIT 3;
```

---

## 🎯 Practice Problems

### **Problem 1: Identify Departments Over Budget**

```sql
-- Requirement:
-- Show departments where average salary > 80000
-- Order by average salary descending

-- Your Solution:
SELECT 
  department,
  COUNT(*) as emp_count,
  AVG(salary) as avg_salary,
  MAX(salary) as max_salary
FROM employees
GROUP BY department
HAVING AVG(salary) > 80000
ORDER BY avg_salary DESC;
```

### **Problem 2: Product Performance Report**

```sql
-- Requirement:
-- Find products sold:
-- - More than 100 times
-- - With total revenue > 50000
-- Show rank by revenue

-- Your Solution:
SELECT 
  product,
  COUNT(*) as sales_count,
  SUM(amount) as total_revenue,
  AVG(amount) as avg_sale,
  ROW_NUMBER() OVER (ORDER BY SUM(amount) DESC) as rank
FROM sales
GROUP BY product
HAVING COUNT(*) > 100 AND SUM(amount) > 50000
ORDER BY total_revenue DESC;
```

### **Problem 3: Customer Segmentation**

```sql
-- Requirement:
-- Segment customers by purchase frequency and value
-- Count customers in each segment

-- Your Solution:
SELECT 
  CASE
    WHEN COUNT(*) >= 10 AND SUM(amount) > 5000 THEN 'VIP'
    WHEN COUNT(*) >= 5 AND SUM(amount) > 2000 THEN 'Loyal'
    WHEN SUM(amount) > 1000 THEN 'Growing'
    ELSE 'New'
  END as segment,
  COUNT(*) as customer_count,
  AVG(amount) as avg_order_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id
GROUP BY segment;
```

---

## ⚠️ Common Mistakes

| Mistake | Problem | Solution |
|--------|---------|----------|
| Missing GROUP BY column | Ambiguous results | Add all non-aggregate columns |
| Using WHERE instead of HAVING | Filtering rows instead of groups | Use HAVING for aggregate filters |
| COUNT(*) with NULLs | Counting NULLs as rows | Use COUNT(column) to exclude NULLs |
| ORDER BY without column | Results random | Explicitly ORDER BY columns |
| Forgetting NULLs in joins | Missing data in aggregates | Use LEFT JOIN, check for NULLs |

---

## 💡 Best Practices

1. **Always filter early (WHERE)** before grouping for performance
2. **Use HAVING for aggregate conditions**, not WHERE
3. **Verify row counts** - Compare GROUP BY results with raw data
4. **Use COUNT(DISTINCT)** when counting unique entities
5. **Be careful with JOINs** - Can create duplicate rows before grouping
6. **Document complex aggregations** - Add comments explaining logic
7. **Test with small datasets first** - Verify logic before big queries

---

## 🔧 Implementation Tips

**Debugging GROUP BY Issues**:

```sql
-- Step 1: Check raw data
SELECT * FROM employees LIMIT 10;

-- Step 2: Count rows
SELECT COUNT(*) FROM employees;

-- Step 3: Simple GROUP BY
SELECT department, COUNT(*)
FROM employees
GROUP BY department;

-- Step 4: Check GROUP BY values
SELECT DISTINCT department FROM employees;

-- Step 5: Add aggregates carefully
SELECT department, 
  COUNT(*) as cnt,
  SUM(salary) as total
FROM employees
GROUP BY department;
```

**Performance Optimization**:

```sql
-- SLOW: Grouping large dataset
SELECT department, salary, COUNT(*)
FROM employees
GROUP BY department, salary;

-- FAST: Filter first, then group
SELECT department, salary, COUNT(*)
FROM employees
WHERE status = 'Active'
GROUP BY department, salary;

-- Use indexes on GROUP BY columns
CREATE INDEX idx_dept_salary ON employees(department, salary);
```

---

## 📊 Expected Outcomes

After Day 4, you should be able to:

1. ✅ Write multi-dimensional GROUP BY queries
2. ✅ Use HAVING to filter groups effectively
3. ✅ Choose correct aggregate functions
4. ✅ Handle edge cases (NULLs, duplicates)
5. ✅ Create advanced reports with aggregations
6. ✅ Optimize GROUP BY queries for performance
7. ✅ Debug aggregation issues
8. ✅ Solve real-world reporting problems

---

## 🧪 Self-Check Questions

Before moving to Day 5, ensure you can answer:

1. What's the difference between WHERE and HAVING?
2. Can you COUNT(DISTINCT customer_id) efficiently?
3. How do NULLs behave in GROUP BY?
4. What happens if you GROUP BY two columns?
5. When should you use SUM(CASE WHEN ...)?
6. How do you rank groups by aggregate values?
7. What's the performance impact of filtering after GROUP BY?

---

## 📖 Learning Resources

Concepts reinforced from:
- **Week 0, Phase 1-4**: Basic SQL grouping
- **Week 1, Day 2**: Complex joins (important for GROUP BY accuracy)
- **Week 1, Day 3**: CASE statements within aggregates

---

## 🎓 Next Steps

After Day 4:
- ✅ Ready for Day 5 real-world data analysis
- ✅ Have mastered aggregation fundamentals
- ✅ Can write production-quality reports
- ✅ Ready for Week 2 advanced concepts

---

## ⏱️ Time Allocation

| Activity | Time |
|----------|------|
| Concept Review | 15 min |
| Examples Study | 20 min |
| Practice Problems | 15 min |
| Real-world Scenarios | 10 min |
| **Total** | **60 min** |

---

**Master GROUP BY, WHERE vs HAVING, and aggregate functions - they're essential for every data engineer! 📊**
