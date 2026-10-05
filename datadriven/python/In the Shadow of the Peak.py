"""PySpark solution for: In the Shadow of the Peak
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Derive the second highest amount by first excluding the max for each provider
second_highest = cloud_costs.withColumn("provider_lower", F.lower(F.col("provider"))) \
    .withColumn("max_amount_per_provider", F.max("amount").over(Window.partitionBy("provider_lower"))) \
    .filter(F.col("amount") < F.col("max_amount_per_provider")) \
    .groupBy("provider_lower") \
    .agg(F.max("amount").alias("second_highest")) \
    .withColumnRenamed("provider_lower", "provider") \
    .orderBy(F.col("second_highest").desc())

# Display the result
second_highest.show()
