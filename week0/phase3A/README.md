\# Phase 3A – Data Quality \& Cleaning Challenge



\## Objective



This phase focuses on handling \*\*messy real-world data\*\* by applying data cleaning techniques before performing any analysis or aggregation.





\## Dataset Description



The dataset contains customer information with intentional issues:



\* Missing values (NULLs)

\* Duplicate records

\* Invalid values (negative age)





\## Files in this Folder



\* `phase3a.sql` - SQL script for data cleaning and analysis

\* `run\_sql.py` - Python script to execute SQL and display results

\* `mydb.db` - SQLite database (created during execution)





\## Data Issues Identified



\* NULL values in `customer\_id`, `name`, and `city`

\* Duplicate records

\* Invalid age values (age ≤ 0)



\---



\## Cleaning Steps Performed



1\. Removed rows with NULL `customer\_id`

2\. Replaced NULL values in:



&#x20;  \* `name` → "Unknown"

&#x20;  \* `city` → "Unknown"

3\. Removed duplicate rows

4\. Filtered invalid age values (age ≤ 0)



\---



\## Validation Performed



\* Row count before cleaning

\* Row count after cleaning

\* Final cleaned dataset verification



\---



\## Aggregation Task



\* Calculated \*\*number of customers per city\*\*



\---



\## How to Run



\### Step 1: Navigate to folder



cd week0/phase3A





\### Step 2: Run Python script



python run\_sql.py



\---



\## Expected Output



\* Total rows before cleaning

\* Cleaned dataset

\* Total rows after cleaning

\* Customer count per city



\---



\## Key Learnings



\* Real-world data is often messy

\* Data cleaning is essential before analysis

\* Invalid or missing data leads to incorrect results

\* Validation ensures data accuracy



\---



\## Reflection



1. What happens if cleaning is skipped?

ANS. Wrong results and incorrect insights



2\. Which issue impacts most?

ANS. NULL keys and invalid values (break joins \& aggregations)



3\. How would this affect Business impact?

ANS. Leads to wrong decisions (e.g., wrong top customers, wrong revenue)



4\. Can you define a Cleaning checklist

Remove NULL keys

Fill missing values

Remove duplicates

Validate data ranges

Verify counts before/after



\## Conclusion



This phase demonstrates the importance of \*\*data quality and preprocessing\*\* in building reliable data pipelines.



