import sqlite3

conn = sqlite3.connect("phase3.db")
cursor = conn.cursor()

# Run SQL file
with open("phase3_etl.sql", "r") as f:
    cursor.executescript(f.read())

# ======================
# SHOW ALL OUTPUTS
# ======================

print("\n1. Daily Sales:")
for row in cursor.execute("""
SELECT order_date, SUM(order_amount)
FROM orders
GROUP BY order_date
"""):
    print(row)

print("\n2. City Revenue:")
for row in cursor.execute("""
SELECT c.city, SUM(o.order_amount)
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.city
"""):
    print(row)

print("\n3. Repeat Customers (>1 orders):")
for row in cursor.execute("""
SELECT customer_id, COUNT(*)
FROM orders
GROUP BY customer_id
HAVING COUNT(*) > 1
"""):
    print(row)

print("\n4. Highest Spending Customers:")
for row in cursor.execute("""
SELECT c.city, c.customer_name, SUM(o.order_amount) AS total
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.city, c.customer_name
ORDER BY total DESC
"""):
    print(row)

print("\n5. Final Report:")
for row in cursor.execute("""
SELECT c.customer_name, c.city,
       SUM(o.order_amount), COUNT(o.order_id)
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name, c.city
"""):
    print(row)

conn.close()