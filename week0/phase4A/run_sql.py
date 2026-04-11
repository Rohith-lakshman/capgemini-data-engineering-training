import sqlite3

# connect to database
conn = sqlite3.connect("phase4a.db")
cursor = conn.cursor()

# run SQL file
with open("phase4a.sql", "r") as file:
    cursor.executescript(file.read())

# -------------------------------
# TASK 1: CONDITIONAL SEGMENTATION
# -------------------------------
print("\n=== TASK 1: CONDITIONAL SEGMENTATION ===")
cursor.execute("""
SELECT customer_id, name, country, total_spend,
CASE
    WHEN total_spend > 10000 THEN 'Gold'
    WHEN total_spend BETWEEN 5000 AND 10000 THEN 'Silver'
    ELSE 'Bronze'
END AS segment
FROM customers;
""")
for row in cursor.fetchall():
    print(row)

# -------------------------------
# TASK 2: COUNT BY SEGMENT
# -------------------------------
print("\n=== TASK 2: COUNT BY SEGMENT ===")
cursor.execute("""
SELECT segment, COUNT(*) FROM (
    SELECT CASE
        WHEN total_spend > 10000 THEN 'Gold'
        WHEN total_spend BETWEEN 5000 AND 10000 THEN 'Silver'
        ELSE 'Bronze'
    END AS segment
    FROM customers
) GROUP BY segment;
""")
for row in cursor.fetchall():
    print(row)

# -------------------------------
# TASK 3: QUANTILE (APPROX)
# -------------------------------
print("\n=== TASK 3: QUANTILE SEGMENTATION ===")
cursor.execute("""
SELECT customer_id, total_spend,
CASE
    WHEN total_spend <= 5000 THEN 'Bronze'
    WHEN total_spend <= 10000 THEN 'Silver'
    ELSE 'Gold'
END AS segment
FROM customers;
""")
for row in cursor.fetchall():
    print(row)

# -------------------------------
# TASK 4: WINDOW SEGMENTATION
# -------------------------------
print("\n=== TASK 4: WINDOW SEGMENTATION ===")
cursor.execute("""
SELECT customer_id, name, total_spend,
CASE
    WHEN rank_pct >= 0.66 THEN 'Gold'
    WHEN rank_pct >= 0.33 THEN 'Silver'
    ELSE 'Bronze'
END AS segment
FROM (
    SELECT *,
    PERCENT_RANK() OVER (ORDER BY total_spend) AS rank_pct
    FROM customers
);
""")
for row in cursor.fetchall():
    print(row)

# -------------------------------
# TASK 5: FINAL COMPARISON
# -------------------------------
print("\n=== TASK 5: FINAL COMPARISON ===")
cursor.execute("""
SELECT c.customer_id, c.total_spend,
CASE
    WHEN c.total_spend > 10000 THEN 'Gold'
    WHEN c.total_spend BETWEEN 5000 AND 10000 THEN 'Silver'
    ELSE 'Bronze'
END AS conditional,
CASE
    WHEN c.total_spend <= 5000 THEN 'Bronze'
    WHEN c.total_spend <= 10000 THEN 'Silver'
    ELSE 'Gold'
END AS quantile,
CASE
    WHEN pr >= 0.66 THEN 'Gold'
    WHEN pr >= 0.33 THEN 'Silver'
    ELSE 'Bronze'
END AS window
FROM (
    SELECT *, PERCENT_RANK() OVER (ORDER BY total_spend) AS pr
    FROM customers
) c;
""")
for row in cursor.fetchall():
    print(row)

# close connection
conn.close()