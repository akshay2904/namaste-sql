"""PySpark solution for: The Cannibalization Report
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Find first transaction date for each product
first_transactions = transactions.groupBy("product_id").agg(
    F.min("transaction_date").alias("first_sale_date")
)

# Filter products with first sale in last 6 months
recent_products = products.join(
    first_transactions, 
    "product_id", 
    "inner"
).withColumn(
    "six_months_ago", F.current_timestamp() - F.expr("interval 6 months")
).filter(
    F.col("first_sale_date") > F.col("six_months_ago")
).select(
    "product_id", "product_name", "category", "first_sale_date"
)

# Calculate pre-entry and post-entry sales windows
window_pre = Window.partitionBy("category").orderBy(F.col("transaction_date"))
window_post = Window.partitionBy("category").orderBy(F.col("transaction_date"))

# Calculate pre-entry sales (30 days before first sale)
pre_sales = transactions.withColumn(
    "transaction_date", F.to_date("transaction_date")
).join(
    recent_products, 
    transactions["product_id"] == recent_products["product_id"], 
    "cross"
).filter(
    F.col("transaction_date") < F.col("first_sale_date") + F.expr("interval 1 day")
).filter(
    F.col("transaction_date") >= F.col("first_sale_date") - F.expr("interval 30 days")
).groupBy(
    recent_products["product_id"], 
    recent_products["category"]
).agg(
    F.sum("total_amount").alias("pre_entry_sales")
)

# Calculate post-entry sales (30 days after first sale)
post_sales = transactions.withColumn(
    "transaction_date", F.to_date("transaction_date")
).join(
    recent_products, 
    transactions["product_id"] == recent_products["product_id"], 
    "cross"
).filter(
    F.col("transaction_date") <= F.col("first_sale_date") + F.expr("interval 31 days")
).filter(
    F.col("transaction_date") > F.col("first_sale_date")
).groupBy(
    recent_products["product_id"], 
    recent_products["category"]
).agg(
    F.sum("total_amount").alias("post_entry_sales")
)

# Combine results and calculate percentage change
result = recent_products.join(
    pre_sales, 
    ["product_id", "category"], 
    "inner"
).join(
    post_sales, 
    ["product_id", "category"], 
    "inner"
).withColumn(
    "pct_change", 
    (F.col("post_entry_sales") - F.col("pre_entry_sales")) / F.col("pre_entry_sales") * 100
).select(
    "product_name", 
    "category", 
    "pre_entry_sales", 
    "post_entry_sales", 
    "pct_change"
)
