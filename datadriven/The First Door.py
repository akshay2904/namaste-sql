"""PySpark solution for: The First Door
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import Window
import pyspark.sql.functions as F

window_spec = Window.partitionBy("user_id").orderBy(F.col("event_timestamp").asc(), F.col("event_type").asc())

ranked = event_data.withColumn("rn", F.row_number().over(window_spec))

result = ranked.filter(F.col("rn") == 1) \
    .select("user_id", F.col("event_type").alias("first_channel")) \
    .orderBy("user_id")

result.show(truncate=False)
