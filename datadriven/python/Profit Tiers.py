"""PySpark solution for: Profit Tiers
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

orders.withColumn("tier", F.when(F.col("profit") > 100, "high")
                              .when(F.col("profit") >= 0, "moderate")
                              .otherwise("negative")) \
      .groupBy("tier") \
      .count() \
      .withColumnRenamed("count", "order_count") \
      .show()
