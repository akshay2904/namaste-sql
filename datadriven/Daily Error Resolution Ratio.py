"""PySpark solution for: Daily Error Resolution Ratio
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Filter errors with exact 'TypeError' type and count distinct errors per day
reports = (
    err_tracks
    .filter(F.col("err_type") == "TypeError")
    .withColumn("report_date", F.to_date("first_at"))
    .groupBy("report_date")
    .agg(F.countDistinct("err_id").alias("reported_count"))
)

# Filter alerts with non-null resolved timestamps and count distinct alerts per day
resolutions = (
    alert_events
    .filter(F.col("resolved").isNotNull())
    .withColumn("resolved_date", F.to_date("resolved"))
    .groupBy("resolved_date")
    .agg(F.countDistinct("alert_id").alias("resolved_count"))
)

# Join reports with resolutions, filling null resolved counts with 0
result = (
    reports
    .join(resolutions, reports["report_date"] == resolutions["resolved_date"], "left")
    .fillna(0, subset=["resolved_count"])
    .withColumn(
        "resolved_ratio",
        F.round(F.col("resolved_count") / F.col("reported_count"), 2)
    )
    .select(
        "report_date",
        "reported_count",
        "resolved_count",
        "resolved_ratio"
    )
    .orderBy("report_date")
)

result.show()
