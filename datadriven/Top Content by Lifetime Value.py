"""PySpark solution for: Top Content by Lifetime Value
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Calculate lifetime value for each content item based on creator's page views
creator_views = (
    content_items
    .join(page_views, page_views.user_id == content_items.creator_id)
    .groupBy(content_items.content_id, content_items.title)
    .agg(F.sum(F.col("dur_ms")).alias("lifetime_value"))
)

# Rank content items by lifetime value in descending order, allowing ties
ranked_window = Window.orderBy(F.col("lifetime_value").desc())
ranked = creator_views.withColumn("rnk", F.rank().over(ranked_window))

# Select top three ranks, ordering by lifetime value and content ID
top_ranks = (
    ranked
    .filter(F.col("rnk") <= 3)
    .orderBy(F.col("lifetime_value").desc(), F.col("content_id"))
    .select("content_id", "title", "lifetime_value")
)

# Display result (assuming SparkSession is already initialized as 'spark')
top_ranks.show()
