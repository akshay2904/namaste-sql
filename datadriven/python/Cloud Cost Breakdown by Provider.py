"""PySpark solution for: Cloud Cost Breakdown by Provider
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter for years 2022-2025, extract year, aggregate, and sort
result = (
    cost_allocs
    .filter((F.substring("period", 1, 4) >= "2022") & (F.substring("period", 1, 4) <= "2025"))
    .withColumn("yr", F.substring("period", 1, 4))
    .groupBy("category", "yr")
    .agg(
        F.sum("amount").alias("total_spend"),
        F.sum(F.when(F.col("region") == "us-east-1", F.col("amount")).otherwise(0)).alias("us_east_spend"),
        F.count("*").alias("entry_count")
    )
    .orderBy(F.desc("total_spend"), "category", "yr")
)
