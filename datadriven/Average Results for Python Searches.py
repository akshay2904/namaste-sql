"""PySpark solution for: Average Results for Python Searches
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter for search terms containing 'keyboard' (case-insensitive)
keyboard_searches = search_queries.filter(
    F.lower(F.col("search_term")).contains("keyboard")
)

# Compute average of results_count
avg_results = keyboard_searches.agg(
    F.avg("results_count").alias("avg_results")
)

# The HAVING condition is implicitly satisfied if any matching rows exist.
# In the original SQL, if no rows match, AVG returns NULL. 
# We can replicate this behavior directly, since an empty DataFrame
# would simply not produce a row with a result.

avg_results.show()
