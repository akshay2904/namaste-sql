"""PySpark solution for: Pairwise Latency Maximum
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Cross join with itself (with replacement)
cross_joined = api_calls.filter(F.col("latency").isNotNull()) \
    .withColumnRenamed("latency", "latency_1") \
    .crossJoin(api_calls.filter(F.col("latency").isNotNull()) \
                 .withColumnRenamed("latency", "latency_2"))

# Calculate max latency
result_df = cross_joined.withColumn("max_latency", F.greatest(F.col("latency_1"), F.col("latency_2"))) \
    .select("latency_1", "latency_2", "max_latency")

# Order by latency values and limit to 100 rows
ordered_df = result_df.orderBy(F.col("latency_1"), F.col("latency_2")) \
    .limit(100)

ordered_df.show()
