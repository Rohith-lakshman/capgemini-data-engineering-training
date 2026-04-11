from pyspark.sql import SparkSession
from pyspark.sql.functions import col, sum, avg, count

spark = SparkSession.builder.appName("Phase2").getOrCreate()

customers = spark.read.option("header", "true").csv("samples/customers.csv")
orders = spark.read.option("header", "true").csv("samples/orders.csv")


customers = customers.dropna(subset=["customer_id"])
orders = orders.dropna(subset=["customer_id"])

orders = orders.withColumn("amount", col("amount").cast("double"))

print("1. Toatal amount spent by each customer:")
orders.groupBy("customer_id").agg(sum("amount").alias("total_amount")).show()

print("2. TOP 3 customers by total spent :")
orders.groupBy("customer_id")\
    .agg(sum("amount").alias("total"))\
    .orderBy(col("total").desc())\
    .limit(3).show()
    
print("3 customer with no orders: ")
customers.join(orders,"customer_id","left_anti").show()

print("4. city-wise total revenue:")
customers.join(orders,"customer_id")\
    .groupBy("city")\
        .agg(sum("amount").alias("revenue"))\
        .show()

print("5. average order amount per customer: ")
orders.groupBy("customer_id")\
    .agg(avg("amount").alias("avg_amount"))\
        .show()

print("6. customer with more than one order: ")
orders.groupBy("customer_id")\
    .agg(count("*").alias("cnt"))\
    .filter(col("cnt")>1)\
    .show()

print("7. sort customers by totla spend descending: ")
orders.groupBy("customer_id")\
    .agg(sum("amount").alias("total_amount"))\
    .orderBy(col("total_amount").desc())\
    .show()

