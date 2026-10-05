"""PySpark solution for: Below the Peaks
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F, Window

# Calculate team averages
team_avg = cost_allocs.groupBy("team_name").agg(F.avg("amount").alias("avg_amount"))

# Rank allocations within each team by amount descending
window_spec = Window.partitionBy("team_name").orderBy(F.col("amount").desc())
ranked = cost_allocs.select(
    "team_name",
    "amount",
    F.row_number().over(window_spec).alias("rn")
)

# Join ranked allocations with team averages and filter
result = ranked.join(team_avg, "team_name", "inner") \
    .filter((F.col("amount") > F.col("avg_amount")) & (F.col("rn") > 5)) \
    .select("team_name", "amount")

result.show()
