"""
Cohort Retention Analysis  (hard)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/cohort_retention

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("cohort_retention").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_user_activity_rows = [{"user_id": "1", "signup_date": "2024-01-05", "activity_date": "2024-01-10"}, {"user_id": "1", "signup_date": "2024-01-05", "activity_date": "2024-02-15"}, {"user_id": "1", "signup_date": "2024-01-05", "activity_date": "2024-03-20"}, {"user_id": "1", "signup_date": "2024-01-05", "activity_date": "2024-04-08"}, {"user_id": "2", "signup_date": "2024-01-12", "activity_date": "2024-01-20"}]
user_activity = _make_df(_user_activity_rows, ['user_id', 'signup_date', 'activity_date']).select(
    F.col("user_id").cast("int").alias("user_id"),
    F.col("signup_date"),
    F.col("activity_date")
)

df = user_activity  # single input table also bound as df

# ---- solution ----
result = (
    df
    .withColumn("cohort_month", F.date_format(F.col("signup_date"), "yyyy-MM"))
    .withColumn(
        "months_since_signup",
        F.months_between(
            F.to_date(F.col("activity_date")),
            F.to_date(F.col("signup_date"))
        ).cast("int")
    )
    .filter((F.col("months_since_signup") >= 0) & (F.col("months_since_signup") <= 3))
    .groupBy("cohort_month", "months_since_signup")
    .agg(F.countDistinct("user_id").alias("active_users"))
    .orderBy("cohort_month", "months_since_signup")
)

result.show(truncate=False)

spark.stop()
