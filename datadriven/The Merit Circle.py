"""PySpark solution for: The Merit Circle
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Assuming 'spark' is the SparkSession and 'products' is the DataFrame

products.orderBy(F.col("rating").desc_nulls_last(), F.col("product_name").asc()) \
         .limit(10) \
         .select("product_name", "rating") \
         .show()
