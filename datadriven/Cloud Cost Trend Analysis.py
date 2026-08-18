"""PySpark solution for: Cloud Cost Trend Analysis
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F, Window

window_spec = Window.partitionBy("svc_name").orderBy("bill_date")

result = (
    cloud_costs
    .withColumn("price_change", F.col("amount") - F.lag("amount").over(window_spec))
    .select("svc_name", "bill_date", "amount", "price_change")
    .orderBy("svc_name", "bill_date")
)

result.show()
