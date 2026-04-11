import os
os.environ["PYSPARK_PYTHON"] = "C:\\Python311\\python.exe"
os.environ["PYSPARK_DRIVER_PYTHON"] = "C:\\Python311\\python.exe"
from pyspark.sql import SparkSession
from pyspark.sql.functions import col

# create spark session
spark = SparkSession.builder.appName("Phase3A").getOrCreate()

# dataset
data = [
    (1, "Ravi", "Hyderabad", 25),
    (2, None, "Chennai", 32),
    (None, "Arun", "Hyderabad", 28),
    (4, "Meena", None, 30),
    (4, "Meena", None, 30),
    (5, "John", "Bangalore", -5)
]

columns = ["customer_id", "name", "city", "age"]

df = spark.createDataFrame(data, columns)

# -----------------------------
# BEFORE CLEANING
# -----------------------------
print("Before Cleaning Count:", df.count())
df.show()

# -----------------------------
# CLEANING
# -----------------------------

# 1. Remove rows with null customer_id
df_clean = df.dropna(subset=["customer_id"])

# 2. Fill missing name and city
df_clean = df_clean.fillna({
    "name": "Unknown",
    "city": "Unknown"
})

# 3. Remove duplicates
df_clean = df_clean.dropDuplicates()

# 4. Remove invalid age (age <= 0)
df_clean = df_clean.filter(col("age") > 0)

# -----------------------------
# AFTER CLEANING
# -----------------------------
print("After Cleaning Count:", df_clean.count())
df_clean.show()

# -----------------------------
# VALIDATION
# -----------------------------
print("Customers per City:")
df_clean.groupBy("city").count().show()

# stop spark
spark.stop()