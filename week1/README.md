# 📚 Week 1: Intermediate SQL & Data Manipulation

## 🎯 Overview

Week 1 focuses on **intermediate SQL concepts** essential for professional data engineering work. You'll master complex query writing, advanced filtering, conditional logic, and hands-on data analysis with real datasets. This week bridges the gap between basic SQL (Week 0) and advanced architectures (Week 2).

---

## 📊 Weekly Structure

Week 1 is organized as a **5-day intensive curriculum**, each day introducing new SQL concepts and practical challenges:

| Day | Title | Duration | Difficulty | Core Topics |
|-----|-------|----------|-----------|------------|
| **1** | Multi-Phase Pipeline Challenge | 45-60 min | ⭐⭐ Intermediate | Pipeline repair, debugging SQL |
| **2** | Advanced SQL JOINs | 60-75 min | ⭐⭐ Intermediate | INNER, LEFT, RIGHT, FULL OUTER JOINs |
| **3** | Conditional Logic: CASE & WHEN | 60-75 min | ⭐⭐ Intermediate | Complex conditional expressions, salary/bonus logic |
| **4** | Advanced Aggregations & Grouping | 45-60 min | ⭐⭐ Intermediate | GROUP BY, HAVING, complex aggregations |
| **5** | Real-World Data Analysis Project | 75-90 min | ⭐⭐ Intermediate | Data exploration, KPI calculation, reporting |

---

## 🔍 Daily Breakdown

### **Day 1: Multi-Phase Pipeline Challenge**
**Folder**: `DAY1/`

Start the week with a **hands-on debugging challenge** to reinforce pipeline concepts.

**Learning Objectives**:
- ✅ Identify and fix broken SQL pipelines
- ✅ Understand data flow from source to destination
- ✅ Debug query logic and data inconsistencies
- ✅ Think like a production data engineer

**Files**:
- `day1_broken_pipeline_starter.py` - Starter code with intentional bugs
- `Day1_MultiPhase_Pipeline_Challenge.pdf` - Challenge description and hints

**Challenge Overview**:

This is a **"broken pipeline" scenario** where you must:
1. Analyze the provided pipeline code
2. Identify logical errors or missing transformations
3. Fix the issues to produce correct results
4. Validate your output against expected results

**Key Skills Practiced**:
- Code review and debugging
- SQL logic validation
- Understanding data dependencies
- Writing defensive data pipelines

**Typical Issues to Fix**:
- Missing WHERE clauses
- Incorrect JOIN conditions
- Data type mismatches
- Aggregation errors
- Missing filtering steps

**Recommended Time**: 45-60 minutes

---

### **Day 2: Advanced SQL JOINs**
**Folder**: `DAY2/`

Master all **JOIN types** - the foundation of multi-table queries.

**Learning Objectives**:
- ✅ Understand INNER, LEFT, RIGHT, FULL OUTER JOINs
- ✅ Know when to use each JOIN type
- ✅ Write efficient joins on large datasets
- ✅ Troubleshoot join-related errors
- ✅ Combine multiple joins in complex queries

**Files**:
- `sql_joins.sql` - Complete JOIN examples and use cases
- `sql_joins_outputs/` - Query results and expected outputs
- `README.md` - Daily instructions (in this file)

**Sample Database Schema**:

```sql
employees:
  - emp_id (PRIMARY KEY)
  - emp_name
  - manager_id (FOREIGN KEY - self-reference for hierarchy)
  - dept_id (FOREIGN KEY)

departments:
  - dept_id (PRIMARY KEY)
  - dept_name

projects:
  - project_id (PRIMARY KEY)
  - project_name
  - emp_id (FOREIGN KEY)
```

**JOIN Types Explained**:

#### **1. INNER JOIN** (Default)
Returns records that exist in **both tables**

```sql
SELECT e.emp_name AS EMPLOYEE, d.dept_name
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id;
```

**Use Case**: Find all employees and their departments (employees without departments excluded)

#### **2. LEFT JOIN** (LEFT OUTER JOIN)
Returns **all records from LEFT table** + matching records from RIGHT

```sql
SELECT e.emp_name AS EMPLOYEE, m.emp_name AS MANAGER
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.emp_id;
```

**Use Case**: Find all employees and their managers (even those without managers)

#### **3. RIGHT JOIN** (RIGHT OUTER JOIN)
Returns **all records from RIGHT table** + matching records from LEFT

```sql
SELECT e.emp_name, d.dept_name
FROM employees e
RIGHT JOIN departments d ON e.dept_id = d.dept_id;
```

**Use Case**: Find all departments and their employees (even empty departments)

#### **4. FULL OUTER JOIN** (FULL JOIN)
Returns **all records from BOTH tables**

```sql
SELECT e.emp_name, d.dept_name
FROM employees e
FULL OUTER JOIN departments d ON e.dept_id = d.dept_id;
```

**Use Case**: Get complete view of employees and departments (matching or not)

**Practical Exercises**:

1. **List all employees with their managers** (even those without)
2. **Find employees assigned to projects**
3. **Find departments with NO employees**
4. **Create a complete employee-manager-department hierarchy**
5. **Identify employees in departments that have projects**

**Key Concepts**:

| JOIN Type | Returns | Use When |
|-----------|---------|----------|
| INNER | Matching records only | Want results with ALL fields populated |
| LEFT | All LEFT + matches | Want all records from primary table |
| RIGHT | All RIGHT + matches | Want all records from secondary table |
| FULL | All from both | Want complete picture of both tables |

**Common Pitfalls**:
- ❌ Using INNER JOIN when you need LEFT JOIN (losing data)
- ❌ Wrong join condition (joining on wrong column)
- ❌ Forgetting table aliases in complex queries
- ❌ Not understanding NULL values in joined results

**Recommended Time**: 60-75 minutes

---

### **Day 3: Conditional Logic with CASE & WHEN**
**Folder**: `DAY3/`

Learn **conditional expressions** to transform and categorize data dynamically.

**Learning Objectives**:
- ✅ Write CASE statements with multiple conditions
- ✅ Implement nested CASE logic
- ✅ Use CASE for data categorization and business rules
- ✅ Calculate conditional aggregations
- ✅ Handle edge cases and NULL values

**Files**:
- `Sql_queires_case_and _when.sql` - CASE statement examples
- `sql_queires_case_and_when_outputs/` - Expected results
- `sql_queries_ROW_NUMBER_RANK_DENSE_RANK.sql` - Additional ranking queries
- `sql_queries_ROW_NUMBER_RANK_DENSE_RANK_outputs/` - Ranking results

**CASE Statement Syntax**:

```sql
SELECT column1, column2,
  CASE
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    ELSE default_result
  END AS new_column
FROM table;
```

**Real-World Examples**:

#### **Example 1: Salary Hike Calculation**

```sql
SELECT emp_id, emp_name, salary, experience, performance_rating,
  CASE
    WHEN experience >= 8 AND performance_rating = 'A' THEN ROUND(salary * 1.20, 2)
    WHEN experience >= 5 AND performance_rating = 'B' THEN ROUND(salary * 1.15, 2)
    WHEN performance_rating = 'C' THEN salary
    ELSE ROUND(salary * 1.10, 2)
  END AS new_salary
FROM Employee;
```

**Business Logic**:
- ✓ 8+ years + Performance 'A' → 20% raise
- ✓ 5+ years + Performance 'B' → 15% raise
- ✓ Performance 'C' → No raise
- ✓ Others → 10% raise

#### **Example 2: Department-wise Bonus**

```sql
SELECT emp_id, emp_name, department, salary, performance_rating,
  CASE 
    WHEN department = 'Finance' AND performance_rating = 'A' THEN ROUND(salary * 0.20, 2)
    WHEN department = 'Finance' AND performance_rating = 'B' THEN ROUND(salary * 0.15, 2)
    WHEN department = 'Finance' AND performance_rating = 'C' THEN ROUND(salary * 0.05, 2)
    
    WHEN department = 'Engineering' AND performance_rating = 'A' THEN ROUND(salary * 0.18, 2)
    WHEN department = 'Engineering' AND performance_rating = 'B' THEN ROUND(salary * 0.12, 2)
    WHEN department = 'Engineering' AND performance_rating = 'C' THEN ROUND(salary * 0.03, 2)
    
    ELSE ROUND(salary * 0.10, 2)  -- Other departments, flat 10%
  END AS bonus_amount
FROM Employee;
```

#### **Example 3: Employee Classification**

```sql
SELECT emp_name, salary, experience,
  CASE
    WHEN salary > 80000 AND experience > 10 THEN 'Senior High Earner'
    WHEN salary > 80000 THEN 'High Earner'
    WHEN experience > 10 THEN 'Experienced'
    ELSE 'Junior'
  END AS employee_category
FROM Employee
ORDER BY salary DESC;
```

**Employee Ranking Concepts**:

Also included in Day 3 are window functions for **ranking employees**:

| Function | Purpose | Example |
|----------|---------|---------|
| `ROW_NUMBER()` | Sequential numbering (1, 2, 3...) | Top 3 employees by salary |
| `RANK()` | Ranking with gaps on ties (1, 1, 3...) | Sales rankings with ties |
| `DENSE_RANK()` | Ranking without gaps (1, 1, 2...) | Product rankings |

```sql
SELECT emp_name, salary,
  ROW_NUMBER() OVER (ORDER BY salary DESC) AS rn,
  RANK() OVER (ORDER BY salary DESC) AS rank,
  DENSE_RANK() OVER (ORDER BY salary DESC) AS dense_rank
FROM Employee;
```

**Key Concepts**:

1. **Simple CASE**: One-to-one mapping (good for categorization)
2. **Searched CASE**: Multiple independent conditions (flexible)
3. **Nested CASE**: CASE within CASE for complex logic
4. **NULL Handling**: CASE evaluates NULL carefully

**Common Patterns**:

```sql
-- Pattern 1: Categories/Buckets
CASE
  WHEN age < 25 THEN 'Young'
  WHEN age < 35 THEN 'Mid'
  WHEN age < 50 THEN 'Senior'
  ELSE 'Executive'
END

-- Pattern 2: Yes/No flags
CASE
  WHEN salary > 100000 THEN 'Yes'
  ELSE 'No'
END

-- Pattern 3: Conditional calculations
CASE
  WHEN country = 'USA' THEN salary * 0.87
  WHEN country = 'UK' THEN salary * 0.80
  ELSE salary
END
```

**Practical Exercises**:

1. Create salary bands (Junior, Mid, Senior, Lead)
2. Calculate bonuses based on multiple criteria
3. Flag employees for promotions
4. Categorize customers by lifetime value
5. Calculate tax based on salary brackets

**Recommended Time**: 60-75 minutes

---

### **Day 4: Advanced Aggregations & Grouping** ⚠️
**Folder**: `DAY4/`

*(README currently empty - Recommended content below)*

This day focuses on **complex GROUP BY operations** and **aggregate functions**.

**Learning Objectives** (Recommended):
- ✅ Master GROUP BY with multiple columns
- ✅ Use HAVING clause for post-aggregation filtering
- ✅ Implement complex aggregate functions
- ✅ Handle NULL values in aggregations

**Recommended Topics**:
- `GROUP BY` with multiple columns
- `HAVING` vs `WHERE` filtering
- `COUNT(DISTINCT ...)` for unique values
- Conditional aggregations with CASE
- `SUM()`, `AVG()`, `MIN()`, `MAX()`
- String aggregations (GROUP_CONCAT, STRING_AGG)

**Sample Exercises**:
```sql
-- Group by multiple columns
SELECT department, performance_rating, 
  COUNT(*) as emp_count,
  AVG(salary) as avg_salary
FROM Employee
GROUP BY department, performance_rating
HAVING COUNT(*) > 2;
```

**Recommended Time**: 45-60 minutes

---

### **Day 5: Real-World Data Analysis Project**
**Folder**: `DAY5/`

Apply all concepts from Days 1-4 in a **real data analysis project**.

**Learning Objectives**:
- ✅ Work with real datasets (retail/sales data)
- ✅ Perform exploratory data analysis (EDA)
- ✅ Calculate key performance indicators (KPIs)
- ✅ Generate business insights
- ✅ Create data reports

**Files**:
- `Big Sales.csv` - Real retail/sales dataset
- `README.md` - Project description

**Dataset: Big Sales.csv**

Real-world retail data with fields:
- `Item_Identifier` - Product ID
- `Item_Weight` - Product weight
- `Item_Fat_Content` - Low Fat / Regular
- `Item_Visibility` - Shelf visibility
- `Item_Type` - Category (Dairy, Meat, Snacks, etc.)
- `Item_MRP` - Maximum Retail Price
- `Outlet_Identifier` - Store ID
- `Outlet_Establishment_Year` - When store opened
- `Outlet_Size` - Small / Medium / High
- `Outlet_Location_Type` - Tier 1 / 2 / 3
- `Outlet_Type` - Supermarket / Grocery
- `Item_Outlet_Sales` - Sales amount

**Analysis Tasks** (Recommended):

1. **Store Performance Analysis**
   ```sql
   SELECT Outlet_Identifier, Outlet_Type, 
     COUNT(*) as items_sold,
     SUM(Item_Outlet_Sales) as total_sales,
     AVG(Item_Outlet_Sales) as avg_item_sales
   FROM BigSales
   GROUP BY Outlet_Identifier, Outlet_Type
   ORDER BY total_sales DESC;
   ```

2. **Product Category Analysis**
   ```sql
   SELECT Item_Type,
     COUNT(*) as products,
     SUM(Item_Outlet_Sales) as category_sales,
     AVG(Item_MRP) as avg_price
   FROM BigSales
   GROUP BY Item_Type
   ORDER BY category_sales DESC;
   ```

3. **Store Size Impact**
   ```sql
   SELECT Outlet_Size,
     AVG(Item_Outlet_Sales) as avg_sales,
     SUM(Item_Outlet_Sales) as total_sales
   FROM BigSales
   GROUP BY Outlet_Size;
   ```

4. **Location Tier Performance**
   ```sql
   SELECT Outlet_Location_Type,
     COUNT(DISTINCT Outlet_Identifier) as store_count,
     AVG(Item_Outlet_Sales) as avg_sales_per_item
   FROM BigSales
   GROUP BY Outlet_Location_Type;
   ```

5. **Product Mix Analysis**
   ```sql
   SELECT Item_Type, 
     SUM(CASE WHEN Item_Fat_Content = 'Low Fat' THEN Item_Outlet_Sales ELSE 0 END) as low_fat_sales,
     SUM(CASE WHEN Item_Fat_Content = 'Regular' THEN Item_Outlet_Sales ELSE 0 END) as regular_sales
   FROM BigSales
   GROUP BY Item_Type;
   ```

**Key Metrics to Calculate** (KPIs):
- Total revenue by store / category / date
- Average transaction value
- Product mix (% of sales by category)
- Best/worst performing items
- Store size effectiveness
- Location tier profitability
- Growth trends

**Deliverables** (Recommended):
1. ✓ Data exploration summary
2. ✓ Top 10 stores by sales
3. ✓ Top 5 products
4. ✓ Store size vs. sales analysis
5. ✓ Location tier performance comparison
6. ✓ Category-wise sales breakdown
7. ✓ Final business recommendations

**Recommended Time**: 75-90 minutes

---

## 📋 Prerequisites

Before Week 1, ensure you have:
- ✅ Completed Week 0 (SQL basics, PySpark fundamentals)
- ✅ Installed SQL database (MySQL/SQLite)
- ✅ Comfortable with SELECT, WHERE, GROUP BY
- ✅ Understanding of JOINs (at least conceptual)
- ✅ Installed SQLiteStudio or MySQL Workbench (optional but helpful)

---

## 🚀 How to Use This Week

### **Day-by-Day Approach**

**Day 1 Morning** (0.75-1 hour):
- Read Day 1 challenge description
- Analyze the broken pipeline code
- Identify bugs (don't fix yet!)
- Write down your findings

**Day 1 Afternoon**:
- Fix identified issues
- Test your corrections
- Compare with expected outputs

**Days 2-4** (4-5 hours total):
- Read concept explanation
- Study provided SQL examples
- Reproduce examples in your SQL editor
- Modify examples to deepen understanding
- Solve practice problems

**Day 5** (1.5-2 hours):
- Import the BigSales dataset
- Write exploratory queries
- Calculate KPIs
- Create summary reports
- Draw business conclusions

---

## 🔧 Tools You'll Use

| Tool | Purpose |
|------|---------|
| **SQL Database** | MySQL, SQLite, PostgreSQL |
| **SQL Editor** | SQLiteStudio, MySQL Workbench, DBeaver |
| **Python** | Optional - data import and automation |
| **Jupyter Notebook** | Optional - interactive analysis |
| **Excel/CSV** | Result export and visualization |

---

## 📈 Expected Outcomes

By end of Week 1, you'll be able to:

1. **Debug broken pipelines** and fix data flow issues
2. **Write complex JOINs** combining 3+ tables
3. **Implement conditional logic** using CASE statements
4. **Calculate bonuses, hikes, and rankings** dynamically
5. **Perform group analysis** on multiple dimensions
6. **Explore real datasets** and extract insights
7. **Generate business reports** from raw data
8. **Optimize queries** for performance
9. **Handle edge cases** (NULLs, duplicates)
10. **Think like a data analyst** solving real problems

---

## 💡 Best Practices

1. **Always use aliases** for readability:
   ```sql
   SELECT e.emp_name, d.dept_name 
   FROM employees e JOIN departments d ON e.dept_id = d.dept_id;
   ```

2. **Test JOINs incrementally**:
   - Start with INNER JOIN
   - Then add LEFT/RIGHT if needed
   - Verify row counts match expectations

3. **Use CASE for data transformation**:
   ```sql
   -- Good: Clear business logic
   CASE WHEN salary > 100000 THEN 'Senior' ELSE 'Junior' END
   ```

4. **Always verify aggregations**:
   ```sql
   -- Bad: Easy to miss edge cases
   SELECT emp_id, SUM(salary) FROM employees GROUP BY emp_id;
   
   -- Good: Check for duplicates
   SELECT emp_id, COUNT(*), SUM(salary) FROM employees GROUP BY emp_id;
   ```

5. **Use GROUP BY with HAVING for filtering**:
   ```sql
   GROUP BY department
   HAVING COUNT(*) > 5  -- Filter groups, not rows!
   ```

---

## 🆘 Common Mistakes

| Mistake | Fix |
|--------|-----|
| Wrong JOIN type | Trace data flow - which table needs all records? |
| CASE returns NULL | Add ELSE clause or check NULL handling |
| JOIN produces duplicates | Check if tables have one-to-many relationships |
| GROUP BY errors | All non-aggregated columns must be in GROUP BY |
| Wrong JOIN condition | Verify using WHERE to check relationship |

---

## 📚 Daily Checklists

### Day 1 Checklist
- [ ] Read challenge description carefully
- [ ] Analyze provided code
- [ ] Identify at least 3 bugs
- [ ] Fix each bug one by one
- [ ] Test against expected output
- [ ] Document what you learned

### Day 2 Checklist
- [ ] Understand INNER JOIN concept
- [ ] Practice LEFT JOIN with employee-manager example
- [ ] Try RIGHT JOIN with departments
- [ ] Combine multiple JOINs
- [ ] Verify row counts increase/decrease appropriately
- [ ] Solve all practice exercises

### Day 3 Checklist
- [ ] Write simple CASE statements
- [ ] Try nested CASE logic
- [ ] Calculate salary hikes correctly
- [ ] Handle NULL values properly
- [ ] Understand RANK() vs DENSE_RANK()
- [ ] Complete ranking exercises

### Day 4 Checklist
- [ ] Master GROUP BY with multiple columns
- [ ] Distinguish WHERE vs HAVING
- [ ] Count distinct values properly
- [ ] Use aggregate functions correctly
- [ ] Validate group counts

### Day 5 Checklist
- [ ] Import BigSales CSV successfully
- [ ] Explore dataset structure
- [ ] Write exploratory queries
- [ ] Calculate all required KPIs
- [ ] Generate summary reports
- [ ] Document business insights

---

## 🎓 Next Steps

After completing Week 1:
- ✓ Move to Week 2 for **advanced concepts** (CTEs, Medallion Architecture, Data Lakes, Window Functions)
- ✓ Start thinking about **data quality** and **pipeline optimization**
- ✓ Begin learning **distributed processing** concepts from PySpark

---

## 📞 Getting Help

If you're stuck:
1. Review the concept explanation in this README
2. Check the provided SQL examples
3. Compare your query with expected output
4. Trace data flow step-by-step
5. Use comments in SQL to document your logic

---

**Happy Learning! 📊**

Start with Day 1 and move sequentially through the week. Each day builds on previous knowledge!
