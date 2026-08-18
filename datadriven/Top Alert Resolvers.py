"""PySpark solution for: Top Alert Resolvers
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Filter resolved alerts with acknowledger and create resolved flag (1/0)
resolved_alerts = alert_events \
    .filter(F.col("status") == "resolved") \
    .filter(F.col("ack_by").isNotNull()) \
    .withColumn("resolved_flag", F.lit(1))  # Flag for aggregation

# Group by svc_name, sum resolved flags, sort in descending order
top_responders = resolved_alerts \
    .groupBy("svc_name") \
    .agg(F.sum("resolved_flag").alias("total_resolved")) \
    .orderBy(F.col("total_resolved").desc()) \
    .limit(10)  # Assuming top 10 as per typical 'top' context, adjust if needed

# Show the result (optional, for verification)
top_responders.show()
