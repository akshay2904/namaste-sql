"""PySpark solution for: Where the Money Sits
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

result = (
    cost_allocs
    .groupBy("team_name")
    .agg(
        F.sum(F.when(F.col("category") == "compute", 1).otherwise(0)).alias("compute_count"),
        F.sum("amount").alias("total_cost")
    )
)
