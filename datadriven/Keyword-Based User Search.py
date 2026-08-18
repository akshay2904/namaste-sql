"""PySpark solution for: Keyword-Based User Search
Auto-translated from the SQL solution in the matching .sql file."""

import pyspark.sql.functions as F

search_queries = search_queries.withColumn(
    "search_term_lower", F.lower("search_term")
)

filtered_df = search_queries.filter(
    (F.col("search_term_lower").like("%desk%") |
     F.col("search_term_lower").like("%monitor%") |
     F.col("search_term_lower").like("%cable%") |
     F.col("search_term_lower").like("%mouse%")) &
    ~F.col("search_term_lower").like("%desks%") &
    ~F.col("search_term_lower").like("%monitors%") &
    ~F.col("search_term_lower").like("%cables%") &
    ~F.col("search_term_lower").like("%mouses%")
)

result = filtered_df.select("user_id").distinct()

result.show()
