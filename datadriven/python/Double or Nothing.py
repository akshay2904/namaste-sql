"""PySpark solution for: Double or Nothing
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

(products.alias("p1")
 .join(products.alias("p2"), 
      (F.col("p1.category") == F.col("p2.category")) & (F.col("p1.product_id") < F.col("p2.product_id")), 
      "inner")
 .where((F.col("p1.price") >= 2 * F.col("p2.price")) | (F.col("p2.price") >= 2 * F.col("p1.price")))
 .select(F.col("p1.product_name").alias("product_1"), 
         F.col("p2.product_name").alias("product_2"), 
         F.col("p1.category"), 
         F.col("p1.price").alias("price_1"), 
         F.col("p2.price").alias("price_2"))
 .show())
