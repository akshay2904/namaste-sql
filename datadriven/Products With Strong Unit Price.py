"""PySpark solution for: Products With Strong Unit Price
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

result = transactions.join(products, "product_id", "inner") \
    .groupBy("product_id", "product_name") \
    .agg((F.sum("total_amount") / F.sum("quantity")).alias("avg_unit_price")) \
    .filter(F.col("avg_unit_price") >= 100) \
    .withColumn("product_name", F.lower(F.col("product_name"))) \
    .select("product_id", "product_name", F.col("avg_unit_price")) \
    .orderBy("product_id")
