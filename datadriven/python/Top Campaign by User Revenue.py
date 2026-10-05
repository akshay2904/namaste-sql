"""PySpark solution for: Top Campaign by User Revenue
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Define the window specification
window_spec = Window.partitionBy("user_id").orderBy(F.col("revenue").desc())

# Rank campaigns by revenue per user, filtering for clicked ads
ranked = ad_impressions \
    .filter(F.col("clicked") == 1) \
    .withColumn("rnk", F.dense_rank().over(window_spec)) 

# Select distinct top-ranked campaigns per user
result = ranked \
    .filter(F.col("rnk") == 1) \
    .select("user_id", "ad_campaign").distinct()

# Show (or return) the result
result.show()
