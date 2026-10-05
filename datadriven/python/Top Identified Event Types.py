"""PySpark solution for: Top Identified Event Types
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

result = (
    event_data
    .groupBy("event_type")
    .agg(
        F.count("*").alias("total_events"),
        F.sum(F.when(F.col("user_id").isNotNull(), 1).otherwise(0)).alias("identified_events"),
        F.sum(F.when(F.col("user_id").isNull(), 1).otherwise(0)).alias("anonymous_events")
    )
    .filter(F.col("identified_events") > F.col("anonymous_events"))
    .orderBy(F.col("total_events").desc(), F.col("event_type").asc())
    .limit(3)
    .select("event_type", "total_events")
)
