"""PySpark solution for: Priciest Item in Each Category
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Define the window specification
window_spec = Window.partitionBy("category").orderBy(F.col("price").desc())

# Apply the window specification to the data
ranked_products = products.withColumn("rnk", F.dense_rank().over(window_spec))

# Filter the top-ranked products
top_priced_products = ranked_products.filter(F.col("rnk") == 1)

# Select the desired columns and order the results
result = top_priced_products.select("category", "product_name", "price").orderBy("category", "product_name")

result.show()
