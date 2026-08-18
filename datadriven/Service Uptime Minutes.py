"""PySpark solution for: Service Uptime Minutes
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Calculate the first check date for each service
svc_start = svc_health.groupBy("svc_name").agg(F.min("checked").alias("first_check"))

# Join alert events with service start dates and filter/alert by conditions
downtime_df = alert_events.join(svc_start, "svc_name") \
    .withColumn("downtime_minutes", F.when(F.col("resolved").isNotNull(),
                                         (F.unix_timestamp(F.col("resolved")) - F.unix_timestamp(F.col("fired_at"))) / 60)) \
    .filter(F.col("resolved").isNotNull()) \
    .filter(F.col("fired_at") <= F.date_add(F.col("first_check"), 365)) \
    .groupBy("svc_name") \
    .agg(F.sum("downtime_minutes").cast("integer").alias("total_downtime_minutes"))

downtime_df.show()
