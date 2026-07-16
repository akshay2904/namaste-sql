"""
ETL Job Statistics  (hard)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/etl_job_stats

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("etl_job_stats").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_etl_jobs_rows = [{"job_id": "1", "job_name": "ingest_customers", "pipeline": "pipeline_a", "start_time": "2024-01-01 08:00:00", "end_time": "2024-01-01 08:05:30", "status": "success", "rows_processed": "10000"}, {"job_id": "2", "job_name": "transform_orders", "pipeline": "pipeline_a", "start_time": "2024-01-01 09:00:00", "end_time": "2024-01-01 09:12:00", "status": "success", "rows_processed": "25000"}, {"job_id": "3", "job_name": "load_warehouse", "pipeline": "pipeline_a", "start_time": "2024-01-01 10:00:00", "end_time": "2024-01-01 10:03:00", "status": "failed", "rows_processed": "0"}, {"job_id": "4", "job_name": "ingest_products", "pipeline": "pipeline_b", "start_time": "2024-01-02 08:00:00", "end_time": "2024-01-02 08:02:45", "status": "success", "rows_processed": "5000"}, {"job_id": "5", "job_name": "transform_inventory", "pipeline": "pipeline_b", "start_time": "2024-01-02 09:00:00", "end_time": "2024-01-02 09:08:20", "status": "success", "rows_processed": "12000"}]
etl_jobs = _make_df(_etl_jobs_rows, ['job_id', 'job_name', 'pipeline', 'start_time', 'end_time', 'status', 'rows_processed']).select(
    F.col("job_id").cast("int").alias("job_id"),
    F.col("job_name"),
    F.col("pipeline"),
    F.col("start_time"),
    F.col("end_time"),
    F.col("status"),
    F.col("rows_processed").cast("int").alias("rows_processed")
)

df = etl_jobs  # single input table also bound as df

# ---- solution ----
agg_df = (
    df
    .withColumn(
        "duration_seconds",
        F.unix_timestamp(F.col("end_time")) - F.unix_timestamp(F.col("start_time"))
    )
    .groupBy("pipeline")
    .agg(
        F.count("job_id").alias("total_runs"),
        F.round(
            F.sum(F.when(F.col("status") == "success", 1).otherwise(0)) * 100.0 / F.count("job_id"),
            2
        ).alias("success_rate"),
        F.round(F.avg("duration_seconds"), 2).alias("avg_duration_seconds"),
        F.round(F.avg("rows_processed"), 2).alias("avg_rows_processed"),
    )
)

w = Window.orderBy(F.col("success_rate").desc())

result = (
    agg_df
    .withColumn("rank", F.dense_rank().over(w))
    .select("pipeline", "total_runs", "success_rate", "avg_duration_seconds", "avg_rows_processed", "rank")
    .orderBy("rank")
)

result.show(truncate=False)

spark.stop()
