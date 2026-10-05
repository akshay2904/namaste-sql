"""PySpark solution for: Rate Limit Rules Per Endpoint
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

rate_limits.groupBy("endpoint") \
    .agg(F.min("allowed").alias("min_allowed"), F.max("allowed").alias("max_allowed")) \
    .withColumn("summary", F.concat(F.lit("Allowed > "), F.col("min_allowed"), 
                                   F.lit(" AND Allowed <= "), F.col("max_allowed"), 
                                   F.lit(" => Endpoint = "), F.col("endpoint"))) \
    .orderBy("endpoint") \
    .select("endpoint", "min_allowed", "max_allowed", "summary")
