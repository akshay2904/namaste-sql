"""PySpark solution for: First Impressions
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Define window to rank views per user by viewed_at
user_view_window = Window.partitionBy("user_id").orderBy(F.col("viewed_at").asc())

# Rank views and filter to the first three per user
ranked_views = page_views.withColumn("view_order", F.row_number().over(user_view_window)).filter(F.col("view_order") <= 3)

# Count appearances and rank pages by count in descending order
count_window = Window.orderBy(F.col("appearance_count").desc())  # <--- FIX: Define window for ordering
page_counts = ranked_views.groupBy("page_url").agg(F.count("*").alias("appearance_count")) \
    .withColumn("rnk", F.dense_rank().over(count_window))  # <--- FIX: Use defined window

# Filter to top 3, including ties at the third position
top_pages = page_counts.filter(F.col("rnk") <= 3).orderBy(F.col("appearance_count").desc())

# Select and show the result
top_pages.select("page_url", "appearance_count").show()
