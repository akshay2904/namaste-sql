"""
Top N per Group  (medium)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/top_n_per_group

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("top_n_per_group").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_employees_rows = [{"department": "Engineering", "employee": "Alice", "salary": "95000"}, {"department": "Engineering", "employee": "Bob", "salary": "88000"}, {"department": "Engineering", "employee": "Charlie", "salary": "102000"}, {"department": "Engineering", "employee": "Diana", "salary": "91000"}, {"department": "Marketing", "employee": "Eve", "salary": "75000"}]
employees = _make_df(_employees_rows, ['department', 'employee', 'salary']).select(
    F.col("department"),
    F.col("employee"),
    F.col("salary").cast("int").alias("salary")
)

df = employees  # single input table also bound as df

# ---- solution ----
window = Window.partitionBy("department").orderBy(F.desc("salary"))

result = df \
    .withColumn("rank", F.rank().over(window)) \
    .filter(F.col("rank") <= 2) \
    .orderBy("department", "rank")

result.show(truncate=False)

spark.stop()
