import sqlite3

conn = sqlite3.connect("phase4.db")
cursor = conn.cursor()

# Run SQL file
with open("phase4.sql", "r") as file:
    cursor.executescript(file.read())

# Function to print results
def print_query(title, query):
    print(f"\n=== {title} ===")
    cursor.execute(query)
    rows = cursor.fetchall()
    for row in rows:
        print(row)

# Task 1
print_query("Daily Sales", "SELECT * FROM daily_sales")

# Task 2
print_query("City-wise Revenue", "SELECT * FROM city_revenue")

# Task 3
print_query("Top 5 Customers", "SELECT * FROM top_customers")

# Task 4
print_query("Repeat Customers", "SELECT * FROM repeat_customers")

# Task 5
print_query("Customer Segmentation", "SELECT * FROM customer_segmentation")

# Task 6 & 7
print_query("Final Report", "SELECT * FROM final_report")

conn.close()