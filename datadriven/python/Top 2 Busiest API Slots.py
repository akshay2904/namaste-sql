"""PySpark solution for: Top 2 Busiest API Slots
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

segmented = api_calls.filter(api_calls.call_time.isNotNull()) \
    .withColumn("day_of_week", F.dayofweek(api_calls.call_time).cast("integer")) \
    .withColumn("time_segment", F.when(F.hour(api_calls.call_time) < 12, "Morning")
                .when(F.hour(api_calls.call_time) <= 15, "Early Afternoon")
                .otherwise("Late Afternoon")) \
    .groupBy("day_of_week", "time_segment") \
    .count() \
    .withColumnRenamed("count", "call_count")

ranked = segmented.withColumn("rnk", F.dense_rank().over(Window.orderBy(F.col("call_count").desc())))

result = ranked.filter(ranked.rnk <= 2).select("day_of_week", "time_segment", "call_count")
