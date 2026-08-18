"""PySpark solution for: 7-Check Rolling Average
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Define a 7-check window (6 preceding rows + current row) per service ordered by check timestamp
window_spec = (
    Window.partitionBy("svc_name")
    .orderBy("checked")
    .rowsBetween(-6, 0)
)

result = (
    svc_health
    .withColumn("rolling_avg", F.avg("latency").over(window_spec))
    .select("svc_name", "checked", "latency", "rolling_avg")
    .orderBy("svc_name", "checked")
)
