"""PySpark solution for: Back From the Brink
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Normalize case and define window for next status
ordered_deploys = deploy_logs.withColumn("author", F.lower(F.col("author"))) \
                              .withColumn("status", F.lower(F.col("status"))) \
                              .withColumn("next_status",
                                          F.lead("status").over(
                                              Window.partitionBy("author").orderBy("deploy_at")))

# Filter and count distinct authors with 'rolled_back' -> 'success' transition
recovery_count = ordered_deploys.filter((F.col("status") == "rolled_back") &
                                        (F.col("next_status") == "success")) \
                                 .agg(F.countDistinct("author").alias("recovery_count"))

# Select the count (to match output format with a single column)
recovery_count = recovery_count.select(F.col("recovery_count"))

# Show result (assuming you want to display or collect the result)
recovery_count.show()
