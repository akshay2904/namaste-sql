"""PySpark solution for: Split Metric Sums
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

result = employee_metrics.filter(F.col("metric_id") != 5) \
                         .withColumn("label", F.when(F.col("metric_id") < 5, "below_5").otherwise("above_5")) \
                         .groupBy("label") \
                         .agg(F.sum("metric_value").cast("DOUBLE").alias("total")) \
                         .select("label", "total")
