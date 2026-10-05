"""PySpark solution for: Price Rank
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Define the window specification
window_spec = Window.partitionBy('category').orderBy(F.col('price').desc())

# Apply the window function and filter out null prices
ranked_products = products.filter(F.col('price').isNotNull()) \
                          .withColumn('position', F.dense_rank().over(window_spec)) \
                          .select('product_name', 'category', 'price', 'position')

# Show the result
ranked_products.show()
