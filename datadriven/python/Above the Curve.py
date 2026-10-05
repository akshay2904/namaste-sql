"""PySpark solution for: Above the Curve
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Calculate total spend per user
totals = transactions.groupBy("user_id").agg(F.sum("total_amount").alias("total"))

# Compute average spend across all users using an empty window
avg_window = Window.partitionBy()
totals_with_avg = totals.withColumn("avg_total", F.avg("total").over(avg_window))

# Filter users spending above average and calculate the difference
result = (
    totals_with_avg
    .filter(F.col("total") > F.col("avg_total"))
    .withColumn("above_avg", F.col("total") - F.col("avg_total"))
    .orderBy(F.col("total").desc())
    .select("user_id", "total", "above_avg")
)
