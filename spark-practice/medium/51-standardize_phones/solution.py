"""
Standardize Phone Numbers  (medium)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/standardize_phones

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("standardize_phones").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_contacts_rows = [{"contact_id": "1", "name": "Alice Johnson", "phone": "(555) 123-4567"}, {"contact_id": "2", "name": "Bob Smith", "phone": "555-234-5678"}, {"contact_id": "3", "name": "Carol White", "phone": "5553456789"}, {"contact_id": "4", "name": "Dave Brown", "phone": "555.456.7890"}, {"contact_id": "5", "name": "Eve Davis", "phone": "(555) 567-8901"}]
contacts = _make_df(_contacts_rows, ['contact_id', 'name', 'phone']).select(
    F.col("contact_id").cast("int").alias("contact_id"),
    F.col("name"),
    F.col("phone")
)

df = contacts  # single input table also bound as df

# ---- solution ----
result = (
    df
    .withColumn("original_phone", F.col("phone"))
    .withColumn("digits", F.regexp_replace(F.col("phone"), "[^0-9]", ""))
    .withColumn(
        "standardized_phone",
        F.concat(
            F.substring(F.col("digits"), 1, 3),
            F.lit("-"),
            F.substring(F.col("digits"), 4, 3),
            F.lit("-"),
            F.substring(F.col("digits"), 7, 4),
        )
    )
    .select("contact_id", "name", "original_phone", "standardized_phone")
    .orderBy("contact_id")
)

result.show(truncate=False)

spark.stop()
