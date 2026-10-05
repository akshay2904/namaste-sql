"""PySpark solution for: Alert Severity
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import Window
import pyspark.sql.functions as F

# Define window partitioned by topic, ordered by casted offset
window_spec = Window.partitionBy("topic").orderBy(F.col("offset").cast("int"))

# Add window functions: lag, dense_rank, row_number
df = stream_msgs.withColumn(
    "prev_offset", F.lag("offset").over(window_spec)
).withColumn(
    "msg_rank", F.dense_rank().over(window_spec)
).withColumn(
    "msg_row_num", F.row_number().over(window_spec)
)

# Filter rows that have a predecessor
result = df.filter(F.col("prev_offset").isNotNull()).select(
    "topic", "offset", "prev_offset", "msg_rank", "msg_row_num"
)
