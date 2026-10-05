"""PySpark solution for: Top Products per Category
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Join transactions and products on product_id
product_sales = transactions.join(products, "product_id") \
    .groupBy(products.category, products.product_name) \
    .agg(F.sum(transactions.total_amount).alias("total_sales"))

# Rank products by total sales within each category, then by product name
ranked = product_sales.withColumn("rn", 
                                  F.row_number().over(
                                      Window.partitionBy(products.category)
                                             .orderBy(F.col("total_sales").desc(), 
                                                      products.product_name)
                                  ))

# Select top 5 products per category
top_5_products = ranked.filter(F.col("rn") <= 5) \
    .select(products.category, products.product_name, F.col("total_sales")) \
    .orderBy(products.category, F.col("total_sales").desc(), products.product_name)

top_5_products.show()
