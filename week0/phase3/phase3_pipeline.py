from pyspark.sql import SparkSession
from pyspark.sql.functions import sum, count

# STEP 1: EXTRACT

spark = SparkSession.builder.appName("Phase3_ETL").getOrCreate()

customers = spark.read.option("header", True).csv("samples/customers.csv")
orders = spark.read.option("header", True).csv("samples/orders.csv")

# STEP 2: TRANSFORM


# Type casting
customers = customers.withColumn("customer_id", customers["customer_id"].cast("int"))
orders = orders.withColumn("customer_id", orders["customer_id"].cast("int"))
orders = orders.withColumn("order_amount", orders["order_amount"].cast("int"))

# Cleaning
orders = orders.dropna(subset=["customer_id"])

# 1. Daily sales
print("Daily sales:")
daily_sales = orders.groupBy("order_date").agg(sum("order_amount").alias("daily_sales"))
daily_sales.show()

# 2. City-wise revenue
print("2. City-wise revenue:")
city_revenue = customers.join(orders, "customer_id") \
    .groupBy("city") \
    .agg(sum("order_amount").alias("revenue"))
city_revenue.show()

# 3. Repeat customers (>2 orders)
print("3. Repeat customers (>2 orders):")
repeat_customers = orders.groupBy("customer_id") \
    .agg(count("*").alias("order_count")) \
    .filter("order_count > 2")
repeat_customers.show()

# 4. Highest spending customer per city
print("4. Highest spending customer per city:")
customer_spend = customers.join(orders, "customer_id") \
    .groupBy("city", "customer_name") \
    .agg(sum("order_amount").alias("total_spend"))

customer_spend.orderBy("total_spend", ascending=False).show()

# 5. Final reporting table
print(" 5. Final reporting table:")
final_df = customers.join(orders, "customer_id") \
    .groupBy("customer_name", "city") \
    .agg(
        sum("order_amount").alias("total_spend"),
        count("order_id").alias("order_count")
    )

final_df.show()

# STEP 3: LOAD

final_df.show(truncate=False)

spark.stop()