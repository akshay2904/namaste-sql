"""PySpark solution for: Verbose by Design
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Get distinct endpoints
endpoints_df = api_calls.select("endpoint").distinct()

# Use a recursive approach by generating a sequence up to max slashes + 1
# First, count slashes in each endpoint to determine max iterations needed
slash_counts = endpoints_df.withColumn(
    "slash_count", 
    F.length(F.col("endpoint")) - F.length(F.regexp_replace(F.col("endpoint"), "/", ""))
)

max_slashes = slash_counts.agg(F.max("slash_count")).collect()[0][0]

# Generate segments using arrays
segments_df = endpoints_df.select(
    "endpoint",
    F.explode(F.split(F.col("endpoint"), "/")).alias("seg")
).filter(F.col("seg") != "")

# Calculate trimmed length and word count per endpoint
result_df = segments_df.groupBy("endpoint").agg(
    F.count("*").alias("word_count")
).withColumn(
    "trimmed_len", F.length(F.regexp_replace(F.col("endpoint"), "^/+|/+$", ""))
)

# Order by word_count descending, then endpoint
result_df = result_df.orderBy(F.desc("word_count"), "endpoint")

result_df.select("endpoint", "trimmed_len", "word_count")
