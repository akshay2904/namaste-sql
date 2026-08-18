"""PySpark solution for: Top Percentile API Tokens
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Define the window
window = Window.partitionBy("scope").orderBy(F.col("requests").asc())

# Calculate the percentile rank
ranked = api_tokens.withColumn("pct_rank", F.percent_rank().over(window))

# Filter and round the results
result = ranked.filter(F.col("pct_rank") >= 0.95) \
                .select("token_id", "scope", "requests", F.round("pct_rank", 2).alias("percentile_rank")) \
                .orderBy("scope", "requests", ascending=[True, False])

result.show()
