"""
Customer Loyalty Score  (hard)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/customer_loyalty

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("customer_loyalty").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_orders_rows = [{"order_id": "1", "customer_id": "1", "amount": "120", "order_date": "2024-01-05"}, {"order_id": "2", "customer_id": "1", "amount": "85", "order_date": "2024-01-12"}, {"order_id": "3", "customer_id": "1", "amount": "200", "order_date": "2024-01-20"}, {"order_id": "4", "customer_id": "2", "amount": "50", "order_date": "2024-01-03"}, {"order_id": "5", "customer_id": "2", "amount": "75", "order_date": "2024-01-14"}]
orders = _make_df(_orders_rows, ['order_id', 'customer_id', 'amount', 'order_date']).select(
    F.col("order_id").cast("int").alias("order_id"),
    F.col("customer_id").cast("int").alias("customer_id"),
    F.col("amount").cast("int").alias("amount"),
    F.col("order_date")
)

_ratings_rows = [{"rating_id": "1", "customer_id": "1", "score": "4"}, {"rating_id": "2", "customer_id": "1", "score": "5"}, {"rating_id": "3", "customer_id": "2", "score": "3"}, {"rating_id": "4", "customer_id": "2", "score": "4"}, {"rating_id": "5", "customer_id": "3", "score": "5"}]
ratings = _make_df(_ratings_rows, ['rating_id', 'customer_id', 'score']).select(
    F.col("rating_id").cast("int").alias("rating_id"),
    F.col("customer_id").cast("int").alias("customer_id"),
    F.col("score").cast("int").alias("score")
)

# ---- solution ----
order_stats = (
    orders
    .groupBy("customer_id")
    .agg(
        F.count("*").alias("total_orders"),
        F.round(F.avg("amount"), 2).alias("avg_order_value"),
    )
)

rating_stats = (
    ratings
    .groupBy("customer_id")
    .agg(F.round(F.avg("score"), 2).alias("avg_rating"))
)

result = (
    order_stats
    .join(rating_stats, on="customer_id")
    .withColumn(
        "loyalty_score",
        F.round(
            F.col("total_orders") * 0.3
            + F.col("avg_order_value") * 0.5
            + F.col("avg_rating") * 0.2,
            2,
        )
    )
    .select("customer_id", "total_orders", "avg_order_value", "avg_rating", "loyalty_score")
    .orderBy(F.col("loyalty_score").desc())
)

result.show()


spark.stop()
