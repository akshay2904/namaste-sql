"""PySpark solution for: Ghost Products
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Perform a left anti join to find products with no matching transactions
result = (
    products
    .join(transactions, products.product_id == transactions.product_id, "left_anti")
    .select("product_name")
    .orderBy("product_name")
)

result.show()
