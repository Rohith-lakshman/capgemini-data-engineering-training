import sqlite3

conn = sqlite3.connect("mydb.db")
cursor = conn.cursor()

# Read SQL file
with open("phase3a_queries.sql", "r") as file:
    sql_script = file.read()

# Execute full script
cursor.executescript(sql_script)

print("\n--- BEFORE CLEANING COUNT ---")
cursor.execute("SELECT COUNT(*) FROM customers")
print(cursor.fetchone()[0])

print("\n--- DATA AFTER CLEANING ---")
cursor.execute("SELECT * FROM customers")
rows = cursor.fetchall()
for row in rows:
    print(row)

print("\n--- AFTER CLEANING COUNT ---")
cursor.execute("SELECT COUNT(*) FROM customers")
print(cursor.fetchone()[0])

print("\n--- VALIDATION: CUSTOMERS PER CITY ---")
cursor.execute("""
    SELECT city, COUNT(*) 
    FROM customers 
    GROUP BY city
""")
rows = cursor.fetchall()
for row in rows:
    print(row)

conn.close()