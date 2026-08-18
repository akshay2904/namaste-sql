"""PySpark solution for: The Floor Price
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter for actual payments (amount > 0 and not null)
filtered_df = cloud_costs.filter(
    (F.col("amount").isNotNull()) & (F.col("amount") > 0)
)

# Group by uppercased provider and calculate minimum amount
result_df = (
    filtered_df
    .withColumn("provider", F.upper(F.col("provider")))
    .groupBy("provider")
    .agg(F.min("amount").alias("min_amount"))
    .orderBy(F.col("min_amount").asc(), F.col("provider").asc())
)

result_df.select("provider", "min_amount")
