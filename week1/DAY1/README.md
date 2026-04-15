# 📚 Week 1 - Day 1: Multi-Phase Pipeline Challenge

## 🎯 Overview

Day 1 starts the week with a **hands-on debugging challenge** that simulates real-world data engineering work. You'll encounter a broken ETL pipeline and must identify and fix issues - a critical skill for production data engineers.

**Difficulty**: ⭐⭐ Intermediate  
**Time Estimate**: 45-60 minutes  
**Key Skills**: Pipeline debugging, SQL validation, data flow analysis

---

## 🎓 Learning Objectives

By the end of this challenge, you will:
- ✅ Understand how data flows through multi-phase pipelines
- ✅ Identify logical errors in SQL and data processing code
- ✅ Debug data quality issues systematically
- ✅ Think like a production data engineer
- ✅ Validate data at each stage of processing
- ✅ Write defensive pipeline code

---

## 📖 What is a Data Pipeline?

A **data pipeline** is a series of connected processing steps:

```
Raw Data → [Phase 1] → [Phase 2] → [Phase 3] → ... → Analysis Output
            extract    transform   validate       load
```

Each phase:
- Receives input from the previous phase
- Performs specific transformations
- Produces output for the next phase
- Can fail if assumptions are violated

---

## 🔴 The Challenge

You're given `day1_broken_pipeline_starter.py` - a multi-phase pipeline with **intentional bugs**.

### **Your Mission**:

1. ✓ **Analyze** the provided broken code
2. ✓ **Identify** at least 3-5 bugs or logical errors
3. ✓ **Document** what each bug causes
4. ✓ **Fix** each issue systematically
5. ✓ **Validate** your fixes produce correct results
6. ✓ **Verify** output matches expected results in `outputs/`

---

## 🏗️ Pipeline Architecture

A typical multi-phase pipeline looks like:

```
PHASE 0: Data Ingestion
├─ Load CSV/database data
├─ Validate file exists and readable
└─ Output: Raw dataframe/table

PHASE 1: Data Cleaning
├─ Remove NULL values
├─ Remove duplicates
├─ Standardize data types
└─ Output: Cleaned dataframe

PHASE 2: Data Transformation
├─ Join multiple tables
├─ Calculate derived columns
├─ Apply business rules
└─ Output: Enriched dataframe

PHASE 3: Data Validation
├─ Check data quality
├─ Validate business logic
├─ Flag invalid records
└─ Output: Validated dataframe

PHASE 4: Analysis
├─ Aggregate data
├─ Calculate metrics
├─ Generate insights
└─ Output: Analysis results

PHASE 5: Output/Load
├─ Save to database
├─ Export to CSV/JSON
├─ Generate reports
└─ Output: Final deliverables
```

---

## 🔍 Common Pipeline Bugs

### **Bug Category 1: Data Quality Issues**

```python
# BUG: Not removing duplicates
df = df.drop_duplicates()  # Commented out!
# Impact: Inflated counts, doubled amounts, invalid analysis

# FIX:
df = df.drop_duplicates()  # Must be called

# BUG: Not handling NULLs
result = df[df['amount'] > 0]  # NULL doesn't match > 0
# Impact: NULL rows silently disappear, confusing results

# FIX:
result = df[df['amount'] > 0].dropna(subset=['amount'])
```

### **Bug Category 2: Join Errors**

```python
# BUG: Wrong join column
df = customers.join(orders, on='customer_name')  # Should be customer_id!
# Impact: Wrong customers matched to orders, corrupted data

# FIX:
df = customers.join(orders, on='customer_id')

# BUG: Not handling unmatched records
df = customers.merge(orders, how='inner')  # Loses customers with no orders
# Impact: Incomplete analysis, missing business insights

# FIX:
df = customers.merge(orders, how='left')  # Keep all customers
```

### **Bug Category 3: Logic Errors**

```python
# BUG: Aggregation error
total = df.groupby('department')['salary'].count()
# Impact: Counts employees, not unique values

# FIX - depends on requirement:
total = df.groupby('department')['salary'].sum()  # Total payroll
# OR
unique = df.groupby('department')['employee_id'].count()  # Employee count

# BUG: Wrong filter
df = df[df['status'] == 'COMPLETED']  # Typo: should check actual values
# Impact: Might filter out ALL records if value doesn't exist

# FIX:
print(df['status'].unique())  # Check actual values first
df = df[df['status'] == 'Completed']  # Correct capitalization
```

### **Bug Category 4: Type Conversion Errors**

```python
# BUG: Implicit type issues
df['amount'] = df['amount_str']  # String arithmetic fails later
# Impact: Type errors when calculating totals

# FIX:
df['amount'] = df['amount_str'].astype(float)

# BUG: Date parsing
df['date'] = df['date_str']  # Still a string!
# Impact: Can't do date comparisons

# FIX:
df['date'] = pd.to_datetime(df['date_str'], format='%Y-%m-%d')
```

### **Bug Category 5: Missing Validations**

```python
# BUG: No validation
def load_data(filepath):
    return pd.read_csv(filepath)  # What if file doesn't exist?

# FIX:
import os
def load_data(filepath):
    if not os.path.exists(filepath):
        raise FileNotFoundError(f"File not found: {filepath}")
    return pd.read_csv(filepath)

# BUG: No quality checks
df = df.groupby('customer').agg(...)  # Might be empty!

# FIX:
if df.empty:
    raise ValueError("No data to process")
df = df.groupby('customer').agg(...)
```

---

## 🧪 Debugging Methodology

### **Step 1: Understand the Expected Outcome**
```python
# Read the problem statement
# Check outputs/ for expected results
# Understand what the pipeline SHOULD produce
expected_output = pd.read_csv('outputs/expected_result.csv')
print("Expected shape:", expected_output.shape)
print("Expected columns:" expected_output.columns.tolist())
```

### **Step 2: Run Pipeline Phase by Phase**
```python
# Don't run everything at once!
# Test each phase independently

print("=== Phase 0: Load ===")
df = load_data('input/data.csv')
print(f"Loaded {len(df)} rows, {len(df.columns)} columns")
print(f"Columns: {df.columns.tolist()}")

print("\n=== Phase 1: Clean ===")
initial_rows = len(df)
df = df.dropna()
print(f"Dropped {initial_rows - len(df)} null rows")

print("\n=== Phase 2: Transform ===")
df = transform(df)
print(df.head())

# Continue for each phase
```

### **Step 3: Validate Intermediate Results**
```python
# After each phase, check:

# 1. Row count reasonable?
print(f"Rows: {len(df)}")
if len(df) == 0:
    raise ValueError("All data was filtered!")

# 2. No unexpected NULLs?
print(df.isnull().sum())

# 3. Data types correct?
print(df.dtypes)

# 4. Values in expected range?
print(f"Amount range: {df['amount'].min()} to {df['amount'].max()}")
if df['amount'].min() < 0:
    print("WARNING: Negative amounts found!")

# 5. Counts reasonable?
print(f"Unique customers: {df['customer_id'].nunique()}")
```

### **Step 4: Compare with Expected Output**
```python
# Load expected results
expected = pd.read_csv('outputs/expected_result.csv')
actual = df  # Your pipeline result

# Compare shapes
assert actual.shape == expected.shape, \
    f"Shape mismatch: {actual.shape} vs {expected.shape}"

# Compare column names
assert set(actual.columns) == set(expected.columns), \
    "Column mismatch"

# Compare values (sort first!)
expected_sorted = expected.sort_values('customer_id').reset_index(drop=True)
actual_sorted = actual.sort_values('customer_id').reset_index(drop=True)
assert expected_sorted.equals(actual_sorted), \
    "Values don't match"

print("✓ Pipeline output matches expected results!")
```

---

## 📋 Debugging Checklist

### **Before Running Any Code**
- [ ] Read the problem statement completely
- [ ] Examine input data structure
- [ ] Check expected output files
- [ ] Note what each phase should do
- [ ] Identify assumptions

### **While Debugging**
- [ ] Run one phase at a time
- [ ] Print shape/columns after each step
- [ ] Check for NULLs and duplicates
- [ ] Verify data types (especially dates, amounts)
- [ ] Use `.head()` to inspect data
- [ ] Compare counts before/after transformations

### **After Each Fix**
- [ ] Re-run the phase
- [ ] Verify row count is reasonable
- [ ] Check for unintended data loss
- [ ] Compare with expected output incrementally

### **Final Validation**
- [ ] Entire pipeline runs without errors
- [ ] Output matches expected results exactly
- [ ] Document what bugs you found
- [ ] Note how you fixed each one

---

## 💻 Sample Debugging Code

```python
import pandas as pd
import numpy as np

def debug_pipeline():
    """Run pipeline with debugging output"""
    
    # Phase 0: Load
    print("=" * 50)
    print("PHASE 0: LOAD DATA")
    print("=" * 50)
    df = pd.read_csv('input/data.csv')
    print(f"✓ Loaded {len(df)} rows, {len(df.columns)} columns")
    print(f"Columns: {df.columns.tolist()}")
    print(f"Null counts:\n{df.isnull().sum()}\n")
    
    # Phase 1: Clean
    print("=" * 50)
    print("PHASE 1: CLEAN")
    print("=" * 50)
    print(f"Before: {len(df)} rows")
    
    # Remove duplicates
    df = df.drop_duplicates()
    print(f"After removing duplicates: {len(df)} rows")
    
    # Remove nulls
    df = df.dropna()
    print(f"After removing nulls: {len(df)} rows")
    print()
    
    # Phase 2: Transform
    print("=" * 50)
    print("PHASE 2: TRANSFORM")
    print("=" * 50)
    print("Before transformation:")
    print(df.head())
    
    # Your transformations here
    df['amount'] = df['amount'].astype(float)  # Fix types
    df['date'] = pd.to_datetime(df['date'])     # Parse dates
    
    print("\nAfter transformation:")
    print(df.head())
    print(f"Data types: {df.dtypes}\n")
    
    # Phase 3: Validate
    print("=" * 50)
    print("PHASE 3: VALIDATE")
    print("=" * 50)
    
    # Check for negative values
    if (df['amount'] < 0).any():
        print("⚠️  WARNING: Negative amounts found")
        print(df[df['amount'] < 0])
    else:
        print("✓ All amounts positive")
    
    # Check for future dates
    today = pd.Timestamp.today()
    if (df['date'] > today).any():
        print("⚠️  WARNING: Future dates found")
    else:
        print("✓ All dates in past")
    
    # Phase 4: Analyze
    print("\n" + "=" * 50)
    print("PHASE 4: ANALYZE")
    print("=" * 50)
    
    result = df.groupby('category').agg({
        'amount': ['sum', 'mean', 'count']
    })
    print(result)
    
    return df

if __name__ == "__main__":
    result_df = debug_pipeline()
```

---

## 🎯 Typical Issues You'll Find

Based on similar challenges, expect to debug:

1. **Load Phase**:
   - File not found or path incorrect
   - Wrong encoding/delimiter for CSV
   - Missing required columns

2. **Clean Phase**:
   - Duplicate removal not working (commented out)
   - Null handling too aggressive/passive
   - Type conversions missing

3. **Transform Phase**:
   - Wrong join keys
   - Join type (INNER vs LEFT) wrong
   - Missing intermediate validation

4. **Analysis Phase**:
   - Aggregation function wrong (COUNT vs SUM)
   - GROUP BY columns missing
   - Filters too restrictive

5. **Output Phase**:
   - File not being saved
   - Column order wrong
   - Rounding/formatting not matching

---

## 📝 Deliverables

When you complete this challenge, provide:

1. ✓ **Fixed Code**: Corrected `day1_broken_pipeline_starter.py`
2. ✓ **Bug Report**: List each bug found
3. ✓ **Fixes Applied**: How you fixed each bug
4. ✓ **Validation Results**: Output matches expected
5. ✓ **Key Learnings**: What you learned

---

## 💡 Pro Tips

1. **Diff your code against expected output**:
   ```python
   expected = pd.read_csv('outputs/expected_result.csv')
   actual = your_result_df
   
   # Find differences
   diff = pd.concat([expected, actual]).drop_duplicates(keep=False)
   print(diff)
   ```

2. **Use assertions to catch bugs early**:
   ```python
   assert len(df) > 0, "Pipeline produced empty dataset!"
   assert df['amount'].min() >= 0, "Negative amounts found!"
   assert df.isnull().sum().sum() == 0, "NULLs still present!"
   ```

3. **Log each transformation**:
   ```python
   logging.info(f"Cleaned data: {len(df)} rows, {len(df.columns)} columns")
   ```

4. **Keep intermediate results**:
   ```python
   df_phase1 = df.copy()
   df_phase2 = transform(df_phase1.copy())
   # Easy to debug by comparing phase1 and phase2
   ```

---

## 🆘 Getting Unstuck

If you can't find a bug:

1. **Print everything**:
   ```python
   print("Before:", df.head())
   print("After:", df.head())
   print("Shape:", df.shape)
   print("Nulls:", df.isnull().sum())
   ```

2. **Compare row counts**:
   ```python
   print(f"Started with: {initial_count}")
   print(f"After phase 1: {len(df)}")
   print(f"Lost: {initial_count - len(df)}")
   ```

3. **Check intermediate files**:
   ```python
   df.to_csv('debug_phase1.csv', index=False)
   # Now open in Excel to examine
   ```

4. **Review the problem statement** - What should this phase do?

---

## 🎓 Lessons Learned

By debugging this pipeline, you learn:
- ✅ Real data is messy (NULLs, duplicates, wrong types)
- ✅ Each phase must validate its inputs
- ✅ Debugging requires systematic thinking
- ✅ Production pipelines need extensive validation
- ✅ Small bugs have big downstream impacts
- ✅ Always test edge cases

---

## 📚 Reference Materials

- Expected output files in `outputs/`
- Problem statement in `Day1_MultiPhase_Pipeline_Challenge.pdf`
- Week 0 concepts (ETL, transformations)
- Week 1 SQL fundamentals (joins, aggregations)

---

## ⏱️ Time Breakdown

| Activity | Time |
|----------|------|
| Read problem statement | 10 min |
| Analyze broken code | 15 min |
| Identify bugs | 10 min |
| Fix bugs | 15 min |
| Validate results | 10 min |
| **Total** | **60 min** |

---

**This is what real data engineering looks like - understanding data flow, identifying issues, and fixing them methodically! 🔧**

Good luck with your debugging! 🎯
