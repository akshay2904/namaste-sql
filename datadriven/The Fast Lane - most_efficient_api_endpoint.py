"""PySpark solution for: The Fast Lane
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

api_calls.stat_with_value = F.sum(F.when(api_calls.status == 200, 1).otherwise(0))
api_calls.stat_with_value = api_calls.stat_with_value.cast("double")

efficiency_df = (
    api_calls
    .groupBy("endpoint")
    .agg(
        F.count("*").alias("call_count"),
        F.avg("latency").alias("avg_latency"),
        F.sum(F.when(api_calls.status == 200, 1).otherwise(0)).cast("double").alias("successful_calls")
    )
    .withColumn("efficiency_ratio", F.col("successful_calls") / F.col("avg_latency"))
    .filter(F.col("call_count") >= 5)
    .orderBy(F.col("efficiency_ratio").desc(), F.col("endpoint"))
    .select("endpoint", "call_count", "avg_latency", "efficiency_ratio")
)

efficiency_df.show()
