# 📊 Week 1 - Day 3: Conditional Logic with CASE & WHEN

## 🎯 Overview

Day 3 teaches **conditional logic** - the ability to transform data based on multiple conditions. This is essential for business rules, dynamic calculations, and data categorization that powers real-world analytics.

**Difficulty**: ⭐⭐ Intermediate  
**Time Estimate**: 60-75 minutes  
**Key Skills**: CASE statements, conditional aggregations, window functions for ranking

---

## 🎓 Learning Objectives

By the end of this day, you will be able to:
- ✅ Write CASE statements with multiple conditions
- ✅ Implement nested CASE logic for complex rules
- ✅ Use CASE within aggregate functions
- ✅ Solve real-world business problems with CASE
- ✅ Understand RANK, DENSE_RANK window functions
- ✅ Optimize conditional queries

---

## 📚 Core Concepts

### **1. CASE Statement Syntax**

The CASE expression evaluates multiple conditions and returns a result based on the first matching condition.

**Basic Syntax**:

```sql
SELECT column1, column2,
  CASE
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    ...
    WHEN conditionN THEN resultN
    ELSE default_result
  END AS new_column
FROM table;
```

**Important Rules**:
1. CASE evaluates conditions **in order** - first match wins
2. If no condition matches, ELSE result is returned
3. If no ELSE clause and no match → NULL
4. All THEN results should be same data type
5. CASE can return any type: number, string, date, boolean

**Example 1: Simple Categorization**

```sql
SELECT 
  emp_id,
  emp_name,
  salary,
  CASE
    WHEN salary < 50000 THEN 'Junior'
    WHEN salary < 100000 THEN 'Mid'
    WHEN salary < 150000 THEN 'Senior'
    ELSE 'Executive'
  END AS salary_level
FROM employees;
```

**Output**:
```
emp_id  emp_name  salary  salary_level
1       Karthik   95000   Mid
2       Prathik   55000   Junior
3       Srikanth  102000  Senior
```

### **2. Multiple Conditions (AND/OR)**

Combine multiple conditions with AND/OR for complex logic.

**Example: Salary Hike (from files)**

```sql
SELECT 
  emp_id,
  emp_name,
  salary,
  experience,
  performance_rating,
  CASE
    -- Experience >= 8 AND Performance 'A' → 20% hike
    WHEN experience >= 8 AND performance_rating = 'A' 
      THEN ROUND(salary * 1.20, 2)
    
    -- Experience >= 5 AND Performance 'B' → 15% hike  
    WHEN experience >= 5 AND performance_rating = 'B' 
      THEN ROUND(salary * 1.15, 2)
    
    -- Performance 'C' → No hike
    WHEN performance_rating = 'C' 
      THEN salary
    
    -- All others → 10% hike
    ELSE ROUND(salary * 1.10, 2)
  END AS new_salary,
  
  -- Calculate hike amount
  CASE
    WHEN experience >= 8 AND performance_rating = 'A' 
      THEN ROUND(salary * 0.20, 2)
    WHEN experience >= 5 AND performance_rating = 'B' 
      THEN ROUND(salary * 0.15, 2)
    WHEN performance_rating = 'C' 
      THEN 0
    ELSE ROUND(salary * 0.10, 2)
  END AS hike_amount

FROM Employee
ORDER BY new_salary DESC;
```

**Key Insights**:
- 🎯 Multiple conditions allow business rule implementation
- 🎯 Order matters - evaluate most specific conditions first
- 🎯 Hike logic tied to both experience AND performance
- 🎯 Can calculate derived column (hike_amount) separately

### **3. Department & Performance Bonus Calculation (from files)**

Complex business logic combining multiple dimensions:

```sql
SELECT 
  emp_id,
  emp_name,
  department,
  salary,
  performance_rating,
  
  CASE 
    -- Finance department bonuses
    WHEN department = 'Finance' AND performance_rating = 'A' 
      THEN ROUND(salary * 0.20, 2)
    WHEN department = 'Finance' AND performance_rating = 'B' 
      THEN ROUND(salary * 0.15, 2)
    WHEN department = 'Finance' AND performance_rating = 'C' 
      THEN ROUND(salary * 0.05, 2)
    
    -- Engineering department bonuses
    WHEN department = 'Engineering' AND performance_rating = 'A' 
      THEN ROUND(salary * 0.18, 2)
    WHEN department = 'Engineering' AND performance_rating = 'B' 
      THEN ROUND(salary * 0.12, 2)
    WHEN department = 'Engineering' AND performance_rating = 'C' 
      THEN ROUND(salary * 0.03, 2)
    
    -- HR department bonuses
    WHEN department = 'HR' AND performance_rating = 'A' 
      THEN ROUND(salary * 0.15, 2)
    WHEN department = 'HR' AND performance_rating = 'B' 
      THEN ROUND(salary * 0.10, 2)
    WHEN department = 'HR' AND performance_rating = 'C' 
      THEN ROUND(salary * 0.02, 2)
    
    -- Marketing department bonuses
    WHEN department = 'Marketing' AND performance_rating = 'A' 
      THEN ROUND(salary * 0.22, 2)
    WHEN department = 'Marketing' AND performance_rating = 'B' 
      THEN ROUND(salary * 0.16, 2)
    WHEN department = 'Marketing' AND performance_rating = 'C' 
      THEN ROUND(salary * 0.06, 2)
    
    -- Default: Flat 10% for other departments
    ELSE ROUND(salary * 0.10, 2)
  END AS bonus_amount

FROM Employee
ORDER BY department, bonus_amount DESC;
```

**Pattern Insights**:
- Different departments have different bonus percentages
- Performance ratings matter across all departments
- Matrix of department × performance determines bonus
- ELSE clause as safety net for unexpected departments

**Output Example**:
```
emp_id  emp_name    department   salary  performance  bonus_amount
1       Karthik     Engineering  95000   A            17100.00
5       Anil        Engineering  88000   A            15840.00
3       Vinay       Finance      78000   B            11700.00
```

### **4. Nested CASE Statements**

CASE statements can be nested for complex hierarchical logic:

```sql
SELECT 
  emp_id,
  emp_name,
  salary,
  experience,
  performance_rating,
  
  CASE 
    WHEN experience >= 12 THEN
      CASE
        WHEN performance_rating = 'A' THEN 'Senior Manager'
        WHEN performance_rating = 'B' THEN 'Senior Lead'
        ELSE 'Senior'
      END
    WHEN experience >= 8 THEN
      CASE
        WHEN performance_rating = 'A' THEN 'Manager'
        WHEN performance_rating = 'B' THEN 'Lead'
        ELSE 'Mid'
      END
    ELSE
      CASE
        WHEN performance_rating = 'A' THEN 'High Performer'
        WHEN performance_rating = 'B' THEN 'Solid'
        ELSE 'Junior'
      END
  END AS job_level

FROM Employee;
```

**Use Cases for Nested CASE**:
- ✓ Hierarchical decision trees
- ✓ Multi-level filtering
- ✓ Complex role assignments

### **5. CASE in Aggregate Functions**

Combine CASE with SUM, COUNT, AVG for sophisticated reporting:

**Example: Revenue Breakdown by Status**

```sql
SELECT 
  order_date,
  COUNT(*) as total_orders,
  
  -- Count by status
  SUM(CASE WHEN status = 'Completed' THEN 1 ELSE 0 END) as completed_orders,
  SUM(CASE WHEN status = 'Pending' THEN 1 ELSE 0 END) as pending_orders,
  SUM(CASE WHEN status = 'Cancelled' THEN 1 ELSE 0 END) as cancelled_orders,
  
  -- Revenue by status
  SUM(CASE WHEN status = 'Completed' THEN amount ELSE 0 END) as completed_revenue,
  SUM(CASE WHEN status = 'Pending' THEN amount ELSE 0 END) as pending_revenue,
  SUM(CASE WHEN status = 'Cancelled' THEN amount ELSE 0 END) as cancelled_revenue,
  
  -- Overall totals
  SUM(amount) as total_amount

FROM orders
GROUP BY order_date
ORDER BY order_date DESC;
```

**Output**:
```
order_date  total  completed  pending  cancelled  completed_rev  pending_rev  cancelled_rev  total_amount
2024-01-10  15     12         2        1          4200           500          0               4700
2024-01-09  18     16         1        1          5100           300          200             5600
2024-01-08  12     10         2        0          3800           400          0               4200
```

**Benefits**:
- Single query gives complete picture
- Easy to spot trends
- Automated status breakdown
- Better performance than multiple queries

### **6. Ranking with Window Functions**

While technically window functions, ranking is often used with CASE.

**ROW_NUMBER()**: Sequential numbering (1, 2, 3...)

```sql
SELECT 
  emp_name,
  salary,
  ROW_NUMBER() OVER (ORDER BY salary DESC) as rank
FROM Employee
LIMIT 5;
```

**Output**:
```
emp_name   salary   rank
Srikanth   102000   1
Karthik    95000    2
Suresh     92000    3
Chaitanya  91000    4
Deepak     83000    5
```

**RANK()**: Ranking with gaps for ties (1, 1, 3...)

```sql
SELECT 
  emp_name,
  salary,
  RANK() OVER (ORDER BY salary DESC) as rank
FROM Employee
LIMIT 5;
```

**Output** (if top 2 have same salary):
```
emp_name   salary   rank
Srikanth   102000   1
Karthik    95000    2
Karthik2   95000    2      ← Ties get same rank
Chaitanya  91000    4      ← Skip rank 3!
```

**DENSE_RANK()**: Ranking without gaps (1, 1, 2...)

```sql
SELECT 
  emp_name,
  salary,
  DENSE_RANK() OVER (ORDER BY salary DESC) as rank
FROM Employee
LIMIT 5;
```

**Output** (if top 2 have same salary):
```
emp_name   salary   rank
Srikanth   102000   1
Karthik    95000    2
Karthik2   95000    2      ← Ties get same rank
Chaitanya  91000    3      ← NO gap!
```

**When to Use Each**:

| Function | Use When |
|----------|----------|
| **ROW_NUMBER()** | Need unique position (pagination) |
| **RANK()** | Performance rankings (skip for ties) |
| **DENSE_RANK()** | Categories/tiers (no skipping) |

### **7. CASE with IN / BETWEEN for Ranges**

**Example: Salary Band Classification**

```sql
SELECT 
  emp_id,
  emp_name,
  salary,
  CASE
    WHEN salary BETWEEN 40000 AND 60000 THEN 'Band A'
    WHEN salary BETWEEN 60001 AND 80000 THEN 'Band B'
    WHEN salary BETWEEN 80001 AND 100000 THEN 'Band C'
    ELSE 'Band D (Executive)'
  END AS salary_band
FROM Employee;
```

**Example: Department Group**

```sql
SELECT 
  emp_name,
  department,
  CASE
    WHEN department IN ('Engineering', 'IT', 'QA') THEN 'Technical'
    WHEN department IN ('Sales', 'Marketing') THEN 'Business'
    WHEN department IN ('HR', 'Finance') THEN 'Support'
    ELSE 'Other'
  END AS department_group
FROM Employee;
```

---

## 💼 Real-World Scenarios from Files

### **Scenario 1: Salary Hike Based on Experience & Performance**

**Business Rule**:
- 8+ years + Performance 'A' = 20% raise
- 5+ years + Performance 'B' = 15% raise
- Performance 'C' = No raise
- Others = 10% raise

```sql
SELECT *,
  CASE
    WHEN experience >= 8 AND performance_rating = 'A' 
      THEN ROUND(salary * 1.20, 2)
    WHEN experience >= 5 AND performance_rating = 'B' 
      THEN ROUND(salary * 1.15, 2)
    WHEN performance_rating = 'C' 
      THEN salary
    ELSE ROUND(salary * 1.10, 2)
  END AS new_salary
FROM Employee
ORDER BY new_salary DESC;
```

### **Scenario 2: Bonus by Department & Performance**

**Business Rule**:
- Finance: A=20%, B=15%, C=5%; Others=10%
- Engineering: A=18%, B=12%, C=3%; Others=10%
- HR & Marketing: Custom percentages

See full implementation above.

### **Scenario 3: Customer Segmentation**

```sql
SELECT 
  customer_id,
  customer_name,
  total_purchases,
  CASE
    WHEN total_purchases >= 10 AND lifetime_value > 10000 THEN 'VIP'
    WHEN total_purchases >= 5 AND lifetime_value > 5000 THEN 'Premium'
    WHEN total_purchases >= 1 THEN 'Regular'
    ELSE 'Prospect'
  END AS customer_segment
FROM customers
ORDER BY customer_segment, lifetime_value DESC;
```

---

## 🎯 Practice Problems

### **Problem 1: Employee Promotion Eligibility**

```sql
SELECT 
  emp_id,
  emp_name,
  department,
  salary,
  experience,
  performance_rating,
  CASE
    WHEN experience >= 5 AND performance_rating = 'A' 
      THEN 'Eligible for Promotion'
    WHEN experience >= 3 AND performance_rating = 'A' 
      THEN 'Consider for Promotion'
    ELSE 'Not Eligible'
  END AS promotion_status
FROM Employee
ORDER BY department, promotion_status;
```

### **Problem 2: Sales Commission**

```sql
SELECT 
  salesperson_id,
  salesperson_name,
  total_sales,
  CASE
    WHEN total_sales >= 100000 THEN ROUND(total_sales * 0.10, 2)
    WHEN total_sales >= 50000 THEN ROUND(total_sales * 0.08, 2)
    WHEN total_sales >= 25000 THEN ROUND(total_sales * 0.05, 2)
    ELSE ROUND(total_sales * 0.02, 2)
  END AS commission
FROM salespeople
ORDER BY commission DESC;
```

### **Problem 3: Risk Assessment**

```sql
SELECT 
  loan_id,
  customer_id,
  loan_amount,
  credit_score,
  employment_history,
  CASE
    WHEN credit_score >= 750 AND employment_history >= 5 THEN 'Low Risk'
    WHEN credit_score >= 700 AND employment_history >= 3 THEN 'Medium Risk'
    WHEN credit_score >= 650 THEN 'High Risk'
    ELSE 'Very High Risk'
  END AS risk_level
FROM loan_applications
ORDER BY risk_level;
```

---

## ⚠️ Common Mistakes

| Mistake | Problem | Solution |
|---------|---------|----------|
| Missing ELSE | Returns NULL unexpectedly | Always include ELSE clause |
| Type mismatch | Can't compare different types | Ensure all THEN values are same type |
| Wrong order | Catches wrong condition first | Put most specific conditions first |
| Missing parentheses | Syntax error in complex CASE | Use clear formatting with indentation |
| CASE on wrong column | Filters wrong data | Carefully check which column to evaluate |

---

## 💡 Best Practices

1. **Use clear, readable formatting**:
   ```sql
   -- Good: Easy to read
   CASE
     WHEN condition1 THEN result1
     WHEN condition2 THEN result2
   END
   
   -- Bad: Hard to read
   CASE WHEN condition1 THEN result1 WHEN condition2 THEN result2 END
   ```

2. **Order conditions from specific to general**:
   ```sql
   -- Good: Most specific first
   CASE
     WHEN experience > 15 THEN 'Executive'
     WHEN experience > 10 THEN 'Senior'
     WHEN experience > 5 THEN 'Mid'
     ELSE 'Junior'
   END
   
   -- Bad: General catches everything
   CASE
     WHEN experience > 5 THEN 'Mid+'  -- Catches executives too!
     WHEN experience > 15 THEN 'Executive'
   END
   ```

3. **Always include ELSE**:
   ```sql
   -- Best: Explicit else value
   CASE WHEN x = 1 THEN 'One' ELSE 'Other' END
   
   -- Risky: Missing ELSE returns NULL
   CASE WHEN x = 1 THEN 'One' END
   ```

4. **Document complex logic**:
   ```sql
   -- Calculate bonus: 20% for A+ performers, 10% for others
   SUM(CASE 
     WHEN performance = 'A' AND experience > 5 THEN salary * 0.20
     ELSE salary * 0.10
   END) as total_bonus
   ```

---

## 📊 Expected Outcomes

By end of Day 3, you'll understand:

1. ✓ CASE statement syntax and logic
2. ✓ Simple and complex conditional expressions
3. ✓ CASE within aggregate functions
4. ✓ Real-world business rule implementation
5. ✓ Window functions for ranking
6. ✓ When to use CASE vs other approaches

---

## 🧪 Self-Check

Before moving to Day 4, answer:

1. What's the difference between RANK() and DENSE_RANK()?
2. Can you write a 5-condition CASE statement?
3. How would you calculate bonuses with CASE inside SUM()?
4. When would nested CASE be necessary?
5. What happens if no WHEN condition matches and no ELSE exists?

---

## 📚 Learning Path

**From Week 1**:
- Day 1: Pipeline debugging (data understanding)
- Day 2: Joins (combining tables)
- **Day 3: CASE (transforming data)** ← You are here
- Day 4: Aggregations (summarizing data)
- Day 5: Real analysis project (applying all concepts)

---

## ⏱️ Time Allocation

| Activity | Time |
|----------|------|
| Concept Review | 20 min |
| Study Examples | 20 min |
| Practice Problems | 15 min |
| Explore Files | 5 min |
| **Total** | **60 min** |

---

## 📖 Referenced Files

- `Sql_queires_case_and _when.sql` - CASE examples from files
- `sql_queires_case_and_when_outputs/` - Expected query results
- `sql_queries_ROW_NUMBER_RANK_DENSE_RANK.sql` - Ranking examples
- `sql_queries_ROW_NUMBER_RANK_DENSE_RANK_outputs/` - Ranking results

---

**Master CASE statements and you'll solve 80% of real-world SQL problems! 🎯**

Ready to practice? Try implementing the scenarios from the provided SQL files!
