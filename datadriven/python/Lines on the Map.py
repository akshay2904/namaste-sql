"""PySpark solution for: Lines on the Map
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

result = (
    orders
    .filter(F.col("region").isNotNull())  # Ignore rows with no region
    .groupBy("region")  # Group by region
    .agg(
        F.count("order_id").alias("order_count"),  # Count orders per region
        F.sum("profit").alias("total_profit")    # Sum profit per region
    )
    .filter(F.col("order_count") >= 5)  # Filter regions with at least 5 orders
    .orderBy(F.col("total_profit").desc(), F.col("region"))  # Sort by total profit (desc), then region
)

result.show()  # Display the result
