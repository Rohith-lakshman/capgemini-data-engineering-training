from pyspark.sql import SparkSession
from pyspark.sql.functions import col, when, count, percent_rank
from pyspark.sql.window import Window
from pyspark.ml.feature import Bucketizer

spark = SparkSession.builder.appName("Phase4A_Segmentation").getOrCreate()

# Sample Data (after cleaning stage)
data = [
    (101, "Alice",   "USA",   12000),
    (102, "Bob",     "INDIA", 7000),
    (103, "Charlie", "UK",    3000),
    (104, "David",   "INDIA", 15000),
    (105, "Eve",     "USA",   5000),
]
columns = ["customer_id", "name", "country", "total_spend"]
df = spark.createDataFrame(data, columns)

print("ORIGINAL DATA")
df.show()


# 1. CONDITIONAL LOGIC SEGMENTATION

df_cond = df.withColumn(
    "segment",
    when(col("total_spend") > 10000, "Gold")
    .when((col("total_spend") >= 5000) & (col("total_spend") <= 10000), "Silver")
    .otherwise("Bronze")
)

print("CONDITIONAL SEGMENTATION")
df_cond.show()

# Group by segment
print("COUNT BY SEGMENT (CONDITIONAL)")
df_cond.groupBy("segment").agg(count("*").alias("customer_count")).show()


# 2. BUCKETIZER (MLlib)

splits = [-float("inf"), 5000, 10000, float("inf")]
bucketizer = Bucketizer(splits=splits, inputCol="total_spend", outputCol="bucket")
df_bucket = bucketizer.transform(df)

print("BUCKETIZER OUTPUT")
df_bucket.show()


# 3. QUANTILE-BASED SEGMENTATION

quantiles = df.approxQuantile("total_spend", [0.33, 0.66], 0)
q1 = quantiles[0]
q2 = quantiles[1]

df_quantile = df.withColumn(
    "segment",
    when(col("total_spend") <= q1, "Bronze")
    .when((col("total_spend") > q1) & (col("total_spend") <= q2), "Silver")
    .otherwise("Gold")
)

print(" QUANTILE SEGMENTATION")
df_quantile.show()

# 4. WINDOW FUNCTION (PERCENT RANK)

window = Window.orderBy("total_spend")
df_window = df.withColumn("rank_pct", percent_rank().over(window))
df_window = df_window.withColumn(
    "segment",
    when(col("rank_pct") >= 0.66, "Gold")
    .when(col("rank_pct") >= 0.33, "Silver")
    .otherwise("Bronze")
)

print("WINDOW SEGMENTATION")
df_window.show()


# 5. COMPARISON VIEW

print("FINAL COMPARISON")
final_df = (
    df_cond.select("customer_id", "total_spend", col("segment").alias("conditional"))
    .join(df_quantile.select("customer_id", col("segment").alias("quantile")), "customer_id")
    .join(df_window.select("customer_id", col("segment").alias("window")), "customer_id")
)
final_df.show()

spark.stop()
