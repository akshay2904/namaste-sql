"""
Mask PII Data  (medium)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/mask_pii

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("mask_pii").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_customers_rows = [{"customer_id": "1", "name": "Alice Johnson", "email": "alice@gmail.com", "phone": "555-123-4567"}, {"customer_id": "2", "name": "Bob Smith", "email": "bob.smith@yahoo.com", "phone": "555-987-6543"}, {"customer_id": "3", "name": "Carol White", "email": "carol@company.org", "phone": "555-234-5678"}, {"customer_id": "4", "name": "Dave Brown", "email": "dave@hotmail.com", "phone": "555-876-5432"}, {"customer_id": "5", "name": "Eve Davis", "email": "eve.davis@outlook.com", "phone": "555-345-6789"}]
customers = _make_df(_customers_rows, ['customer_id', 'name', 'email', 'phone']).select(
    F.col("customer_id").cast("int").alias("customer_id"),
    F.col("name"),
    F.col("email"),
    F.col("phone")
)

df = customers  # single input table also bound as df

# ---- solution ----
result = (
    df
    .withColumn(
        "masked_email",
        F.concat(
            F.substring(F.col("email"), 1, 3),
            F.lit("***@"),
            F.regexp_extract(F.col("email"), "@(.+)$", 1),
        )
    )
    .withColumn(
        "masked_phone",
        F.concat(
            F.lit("***-***-"),
            F.substring(F.col("phone"), F.length(F.col("phone")) - 3, 4),
        )
    )
    .select("customer_id", "name", "masked_email", "masked_phone")
    .orderBy("customer_id")
)

result.show(truncate=False)

spark.stop()
