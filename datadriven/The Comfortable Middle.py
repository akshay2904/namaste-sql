"""PySpark solution for: The Comfortable Middle
Auto-translated from the SQL solution in the matching .sql file."""

import pyspark.sql.functions as F
from pyspark.sql import Window

# Compute team average amounts
team_avg = cost_allocs.groupBy("team_name").agg(F.avg("amount").alias("avg_amount"))

# Rank allocations within each team by amount descending
window_spec = Window.partitionBy("team_name").orderBy(F.col("amount").desc())
ranked = cost_allocs.select(
    "team_name",
    "amount",
    F.dense_rank().over(window_spec).alias("rnk")
)

# Join and filter: above team average and outside top 3
result = ranked.join(team_avg, "team_name") \
    .filter((F.col("amount") > F.col("avg_amount")) & (F.col("rnk") > 3)) \
    .select("team_name", "amount")

result.show()
