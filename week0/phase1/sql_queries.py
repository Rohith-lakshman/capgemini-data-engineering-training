import sqlite3

# create database
conn = sqlite3.connect("mydb.db")
cursor = conn.cursor()

# read your SQL file
with open("sql_queries.sql", "r") as file:
    sql_script = file.read()

# execute all SQL
cursor.executescript(sql_script)

# fetch output (example)
print("All Customers:")
for row in cursor.execute("SELECT * FROM customers"):
    print(row)

print("\nCustomers from Chennai:")
for row in cursor.execute("SELECT * FROM customers WHERE city='Chennai'"):
    print(row)

print("\nAge > 25:")
for row in cursor.execute("SELECT * FROM customers WHERE age > 25"):
    print(row)
print("\nspefici columns:")
for row in cursor.execute("SELECT customer_name,city FROM customers "):
    print(row)
print("\nCity Count:")
for row in cursor.execute("SELECT city, COUNT(*) FROM customers GROUP BY city"):
    print(row)

conn.close()