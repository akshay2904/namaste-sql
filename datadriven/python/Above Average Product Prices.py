"""PySpark solution for: Above Average Product Prices
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Calculate the base price (minimum total amount) for each product
base_prices = transactions.groupBy("product_id").agg(
    F.min("total_amount").alias("base_price")
)

# Compute global average base price using an empty window and filter products exceeding it
result = (
    base_prices
    .withColumn("avg_base_price", F.avg("base_price").over(Window.partitionBy()))
    .filter(F.col("base_price") > F.col("avg_base_price"))
    .select("product_id", "base_price")
)
