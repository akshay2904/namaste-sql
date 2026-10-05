"""PySpark solution for: The Above Average
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Define window spec to calculate average price per category
category_window = Window.partitionBy("category")

# Calculate average price per category and filter products above average
result = (
    products
    .withColumn("avg_price", F.avg("price").over(category_window))
    .filter(F.col("price") > F.col("avg_price"))
    .select("product_name", "category", "price", "avg_price")
)
