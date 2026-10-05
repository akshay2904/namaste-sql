"""PySpark solution for: Top Per Category
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Define the window to partition by category and order by rating
window = Window.partitionBy("category").orderBy(F.col("rating").desc())

# Rank products by rating within each category, skipping those with no rating
ranked_products = products.where(F.col("rating").isNotNull()).\
    withColumn("rank", F.rank().over(window))

# Select top-rated products (rank 1) and required columns
top_rated_products = ranked_products.filter(F.col("rank") == 1).\
    select("product_name", "category", "rating")

# Sort the result as per the SQL solution's ORDER BY clause
result = top_rated_products.orderBy("category", F.col("rating").desc(), "product_name")

# Show the result (for demonstration; in a real app, you'd likely write to a table or file)
result.show()
