"""
Flatten Nested Structs  (hard)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/flatten_structs

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("flatten_structs").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_orders_rows = [{"order_id": "1", "customer_name": "Alice Johnson", "address": "{\"street\":\"123 Main St\",\"city\":\"New York\",\"zip\":\"10001\"}", "items_count": "3"}, {"order_id": "2", "customer_name": "Bob Smith", "address": "{\"street\":\"456 Oak Ave\",\"city\":\"Chicago\",\"zip\":\"60601\"}", "items_count": "1"}, {"order_id": "3", "customer_name": "Carol White", "address": "{\"street\":\"789 Pine Rd\",\"city\":\"Los Angeles\",\"zip\":\"90001\"}", "items_count": "5"}, {"order_id": "4", "customer_name": "Dave Brown", "address": "{\"street\":\"321 Elm St\",\"city\":\"Houston\",\"zip\":\"77001\"}", "items_count": "2"}, {"order_id": "5", "customer_name": "Eve Davis", "address": "{\"street\":\"654 Maple Dr\",\"city\":\"Phoenix\",\"zip\":\"85001\"}", "items_count": "4"}]
orders = _make_df(_orders_rows, ['order_id', 'customer_name', 'address', 'items_count']).select(
    F.col("order_id").cast("int").alias("order_id"),
    F.col("customer_name"),
    F.col("address"),
    F.col("items_count").cast("int").alias("items_count")
)

df = orders  # single input table also bound as df

# ---- solution ----
json_schema = "struct<street:string,city:string,zip:string>"

result = (
    df
    .withColumn("addr", F.from_json(F.col("address"), json_schema))
    .select(
        "order_id", "customer_name",
        F.col("addr.street").alias("street"),
        F.col("addr.city").alias("city"),
        F.col("addr.zip").alias("zip"),
        "items_count",
    )
    .orderBy("order_id")
)

result.show(truncate=False)

spark.stop()
