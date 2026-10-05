"""PySpark solution for: Product Transaction Counts
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

result = (products
          .join(transactions, on="product_id", how="inner")
          .groupBy("product_id", "product_name")
          .agg(F.count("*").alias("transaction_count"))
          .orderBy("product_id")
          .select("product_name", "transaction_count"))
