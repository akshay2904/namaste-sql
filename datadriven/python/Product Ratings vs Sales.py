"""PySpark solution for: Product Ratings vs Sales
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Join products and transactions on product_id
joined = products.join(transactions, "product_id")

# Filter out products with no rating
filtered = joined.filter(products.rating.isNotNull())

# Group by category and calculate avg_rating and total_revenue
result = filtered.groupBy("category").agg(
    F.avg("rating").alias("avg_rating"),
    F.sum("total_amount").alias("total_revenue")
).orderBy("category")

# Show the result
result.show()
