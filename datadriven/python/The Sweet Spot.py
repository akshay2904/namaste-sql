"""PySpark solution for: The Sweet Spot
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter products: in stock, rating >= 4.0, category contains 'Electronics'
filtered = products.filter(
    (F.col("in_stock") == 1) &
    (F.col("rating") >= 4.0) &
    (F.col("category").contains("Electronics"))
)

# Select product name and price, sort by price ascending
result = filtered.select("product_name", "price").orderBy("price")

result.show()
