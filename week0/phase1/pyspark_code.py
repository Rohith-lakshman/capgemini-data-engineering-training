from pyspark.sql import SparkSession
from pyspark.sql.functions import col

#start spark
spark=SparkSession.builder.appName("phase1").getOrCreate()

# Create DataFrame
customers = spark.createDataFrame([
    (1, "Ravi", "Hyderabad", 25),
    (2, "Sita", "Chennai", 32),
    (3, "Arun", "Hyderabad", 28)
], ["customer_id", "customer_name", "city", "age"])

# 1. Show all customers
print("All Customers:")
customers.show()

# 2. Customers from Chennai
print("Customers from Chennai:")
customers.filter(col("city") == "Chennai").show()

# 3. Customers with age > 25
print("Customers age > 25: ")
customers.filter(col("age")>25).show()

# 4. Select specific columns
print("selected columns:")
customers.select("customer_name","city").show()

# 5. Count customers city-wise
print("City-wise Count:")
customers.groupBy("city").count().show()