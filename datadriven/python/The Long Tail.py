"""PySpark solution for: The Long Tail
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Define window to rank latency descending per upper-case HTTP method
windowSpec = Window.partitionBy("method").orderBy(F.col("latency").desc())

result = (
    api_calls.filter(F.col("latency").isNotNull())
    .withColumn("method", F.upper(F.col("method")))
    .withColumn("rn", F.row_number().over(windowSpec))
    .filter(F.col("rn") <= 5)
    .groupBy("method")
    .agg(F.round(F.avg("latency"), 2).alias("slowest_five_avg"))
    .orderBy(F.col("slowest_five_avg").desc())
)
