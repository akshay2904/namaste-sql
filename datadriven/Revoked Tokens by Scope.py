"""PySpark solution for: Revoked Tokens by Scope
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Filter and transform the data before grouping
filtered_tokens = api_tokens \
    .filter( 
        (F.lower(F.col("status")) == "revoked") &  # Case-insensitive status match
        (F.col("issued") <= "2026-12-31") &        # Issued by December 2026
        (F.col("expires").isNull() | (F.col("expires") >= "2026-12-01"))  # Expires after or null
    )

# Group by scope and count the blocked tokens
blocked_counts = filtered_tokens \
    .groupBy("scope") \
    .agg(F.count("*").alias("blocked_count")) \
    .orderBy("scope")

# Show the results (assuming you want to display or save them)
blocked_counts.show()
