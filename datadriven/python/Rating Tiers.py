"""PySpark solution for: Rating Tiers
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Create a WindowSpec to partition by category and order by rating in descending order
window = Window.partitionBy("category").orderBy(F.col("rating").desc())

# Apply the DENSE_RANK function to the window, filtering out products with no rating
result = products.filter(F.col("rating").isNotNull()) \
                 .withColumn("position", F.dense_rank().over(window)) \
                 .select("product_name", "category", "rating", "position")
