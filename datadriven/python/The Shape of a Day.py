"""PySpark solution for: The Shape of a Day
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

hourly = api_calls\
    .withColumn("call_date", F.col("call_time").cast("date"))\
    .withColumn("call_hour", F.hour("call_time"))\
    .groupBy("call_date", "call_hour")\
    .agg(F.count("*").alias("call_count"))

result = hourly\
    .groupBy("call_hour")\
    .agg(F.avg("call_count").alias("avg_count"))\
    .orderBy(F.col("avg_count").desc(), "call_hour")

result.show()
