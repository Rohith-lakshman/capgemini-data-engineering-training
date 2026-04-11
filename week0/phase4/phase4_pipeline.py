from pyspark.sql import SparkSession
from pyspark.sql.functions import col, sum, count, when

# STEP 1: Create Spark Session
spark = SparkSession.builder \
    .appName("Phase4_ETL_Pipeline") \
    .getOrCreate()

# STEP 2: Extract (Read CSV)
customers = spark.read.option("header", "true").csv("samples/customers.csv")
orders = spark.read.option("header", "true").csv("samples/orders.csv")

# STEP 3: Data Cleaning

# Convert data types
customers = customers.withColumn("customer_id", col("customer_id").cast("int")) \
                     .withColumn("age", col("age").cast("int"))

orders = orders.withColumn("customer_id", col("customer_id").cast("int")) \
               .withColumn("amount", col("amount").cast("int"))

# Remove null customer_id
customers = customers.dropna(subset=["customer_id"])
orders = orders.dropna(subset=["customer_id"])

# Remove duplicates
customers = customers.dropDuplicates()
orders = orders.dropDuplicates()

# Filter invalid values
customers = customers.filter(col("age") > 0)
orders = orders.filter(col("amount") > 0)

# STEP 4: Join
df = customers.join(orders, on="customer_id", how="inner")

# ---------------- TASK 1 ----------------
# Daily Sales -date, total_sales
daily_sales = df.groupBy("order_date") \
    .agg(sum("amount").alias("total_sales"))

print("DAILY SALES")
daily_sales.show()

# ---------------- TASK 2 ----------------
# City-wise Revenue  city, total_revenue
city_revenue = df.groupBy("city") \
    .agg(sum("amount").alias("total_revenue"))

print("CITY-WISE REVENUE")
city_revenue.show()

# ---------------- TASK 3 ----------------
# Top 5 Customers - customer_name, total_spend
top_customers = df.groupBy("customer_name") \
    .agg(sum("amount").alias("total_spend")) \
    .orderBy(col("total_spend").desc()) \
    .limit(5)

print("TOP 5 CUSTOMERS")
top_customers.show()

# ---------------- TASK 4 ----------------
# Repeat Customers (>1 order)
repeat_customers = df.groupBy("customer_id") \
    .agg(count("order_id").alias("order_count")) \
    .filter(col("order_count") > 1)

print("REPEAT CUSTOMERS")
repeat_customers.show()

# ---------------- TASK 5 ----------------
# Customer Segmentation
customer_spend = df.groupBy("customer_name", "city") \
    .agg(sum("amount").alias("total_spend"))

segmented = customer_spend.withColumn(
    "segment",
    when(col("total_spend") > 10000, "Gold")
    .when((col("total_spend") >= 5000) & (col("total_spend") <= 10000), "Silver")
    .otherwise("Bronze")
)

print("CUSTOMER SEGMENTATION ")
segmented.show()

# ---------------- TASK 6 ----------------
# Final Reporting Table
final_df = df.groupBy("customer_name", "city") \
    .agg(
        sum("amount").alias("total_spend"),
        count("order_id").alias("order_count")
    )

# Add segmentation
final_df = final_df.withColumn(
    "segment",
    when(col("total_spend") > 10000, "Gold")
    .when((col("total_spend") >= 5000) & (col("total_spend") <= 10000), "Silver")
    .otherwise("Bronze")
)

print("FINAL REPORT")
final_df.show()

# ---------------- TASK 7 ----------------


import os
os.makedirs("outputs", exist_ok=True)

# Use pandas to avoid winutils error
final_df.toPandas().to_csv("outputs/final_report.csv", index=False)

print("Final report saved in outputs/final_report.csv")

spark.stop()