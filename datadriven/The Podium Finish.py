"""PySpark solution for: The Podium Finish
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

product_qty = transactions.join(products, transactions.product_id == products.product_id) \
    .groupBy(products.category, products.product_name) \
    .agg(F.sum(transactions.quantity).alias('total_quantity'))

window = Window.partitionBy(product_qty.category) \
    .orderBy(product_qty.total_quantity.desc(), product_qty.product_name.asc())

ranked = product_qty.withColumn('rank', F.row_number().over(window))

result = ranked.filter(ranked.rank <= 2) \
    .orderBy(ranked.category, ranked.rank) \
    .select('category', 'product_name', 'total_quantity', 'rank')
