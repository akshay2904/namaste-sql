"""PySpark solution for: Cheapest Line for Network-Heavy Teams
Auto-translated from the SQL solution in the matching .sql file."""

import pyspark.sql.functions as F
from pyspark.sql.functions import col, lower, sum, min, when

# Aggregate by lowercased team name: sum network and ml amounts
team_cat = cost_allocs.groupBy(lower(col("team_name")).alias("team")) \
    .agg(
        sum(when(col("category") == "network", col("amount")).otherwise(0)).alias("net"),
        sum(when(col("category") == "ml", col("amount")).otherwise(0)).alias("ml")
    )

# Filter teams where network spending > ml spending
heavy = team_cat.filter(col("net") > col("ml")).select("team")

# Join back to original data on lowercased team name, filter network category
result = cost_allocs.withColumn("team_name", lower(col("team_name"))) \
    .join(heavy, col("team_name") == col("team"), "inner") \
    .filter(col("category") == "network") \
    .groupBy("team_name") \
    .agg(min("amount").alias("amount")) \
    .orderBy("amount", ascending=True) \
    .limit(1) \
    .select("team_name", "amount")

result.show()
