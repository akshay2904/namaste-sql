"""PySpark solution for: Top Error-Service Pair
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Define the ranking window
window = Window.orderBy(F.col("distinct_errors").desc())

# Join tables, filter, aggregate, rank, and select top rank
result = (
    err_tracks
    .join(alert_events, "svc_name")
    .filter(F.col("resolved").isNotNull())
    .groupBy((F.concat(F.col("err_type"), F.lit("-"), F.col("svc_name"))).alias("reporter_identity"))
    .agg(F.countDistinct("err_id").alias("distinct_errors"))
    .withColumn("rnk", F.rank().over(window))
    .filter(F.col("rnk") == 1)
    .orderBy("reporter_identity")
    .select("reporter_identity", "distinct_errors")
)

result.show()  # Added to display the result
