"""PySpark solution for: Recent Price Drops
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Join products with transactions on product_id and filter recent transactions
recent_transactions = (
    products.join(
        transactions, 
        products.product_id == transactions.product_id, 
        "inner"
    )
    .withColumn("transaction_date", F.to_date("transaction_date"))
    .filter(
        F.col("transaction_date") >= F.current_date() - 1 
    )
    .select(  # Specify the table for clarity to avoid ambiguity
        products.product_id, 
        products.product_name
    )
)

# Get in-stock products
in_stock_products = (
    products.filter(
        F.col("in_stock") == 1 
    )
    .select(
        "product_id", 
        "product_name"
    )
)

# Combine and remove duplicates
result = (
    recent_transactions.unionByName(in_stock_products)  # Using unionByName for column name matching
    .distinct()
)

# Display or show the result (uncomment based on your spark setup)
# result.show()
