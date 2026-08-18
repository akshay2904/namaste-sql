"""PySpark solution for: Latency Gap to 10th Fastest
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import Window
import pyspark.sql.functions as F

# Calculate average response time per server
server_avg = (
    server_logs
    .groupBy("server_name")
    .agg(F.avg("response_time_ms").alias("avg_rt"))
)

# Rank servers by average response time (ascending, tie-break by server_name)
ranked = (
    server_avg
    .withColumn(
        "rnk",
        F.row_number().over(
            Window.orderBy(F.col("avg_rt").asc(), F.col("server_name").asc())
        )
    )
)

# Get avg for web-prod-01 and the 10th ranked server, then compute absolute difference
target_row = server_avg.filter(F.col("server_name") == "web-prod-01").select("avg_rt").first()
tenth_row = ranked.filter(F.col("rnk") == 10).select("avg_rt").first()

# Handle potential None values gracefully
target_avg = target_row[0] if target_row is not None else 0.0
tenth_avg = tenth_row[0] if tenth_row is not None else 0.0

latency_gap = abs(target_avg - tenth_avg)

# Create DataFrame with the result
output_df = spark.createDataFrame([(latency_gap,)], ["latency_gap"])
output_df.show()
