import sqlite3

conn = sqlite3.connect("phase2.db")
cursor = conn.cursor()

# Execute SQL file
with open("phase2.sql", "r") as file:
    sql_script = file.read()

cursor.executescript(sql_script)

# ---- PRINT ALL OUTPUTS ---- #

print("\n1. Total order amount per customer:")
for row in cursor.execute("""
SELECT c.customer_name, SUM(o.order_amount)
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
"""):
    print(row)

print("\n2. Top 3 customers by total spend:")
for row in cursor.execute("""
SELECT c.customer_name, SUM(o.order_amount) AS total_spend
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY total_spend DESC
LIMIT 3
"""):
    print(row)

print("\n3. Customers with no orders:")
for row in cursor.execute("""
SELECT c.customer_name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL
"""):
    print(row)

print("\n4. City-wise total revenue:")
for row in cursor.execute("""
SELECT c.city, SUM(o.order_amount)
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.city
"""):
    print(row)

print("\n5. Average order amount per customer:")
for row in cursor.execute("""
SELECT c.customer_name, AVG(o.order_amount)
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
"""):
    print(row)

print("\n6. Customers with more than one order:")
for row in cursor.execute("""
SELECT c.customer_name, COUNT(o.order_id)
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
HAVING COUNT(o.order_id) > 1
"""):
    print(row)

print("\n7. Customers sorted by total spend:")
for row in cursor.execute("""
SELECT c.customer_name, SUM(o.order_amount)
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY SUM(o.order_amount) DESC
"""):
    print(row)

conn.close()