"""PySpark solution for: Keys That Never Die
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

perpetual_pct = (
    api_tokens
    .withColumn("is_perpetual", F.when(F.col("expires").isNull(), 1).otherwise(0))
    .agg(
        ((F.sum("is_perpetual") / F.count("*")) * 100.0).alias("perpetual_pct")
    )
    .withColumn("perpetual_pct", F.round(F.col("perpetual_pct"), 2))
    .select("perpetual_pct")
)
perpetual_pct.show()
