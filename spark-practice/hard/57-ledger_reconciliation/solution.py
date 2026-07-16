"""
Ledger Reconciliation  (hard)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/ledger_reconciliation

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("ledger_reconciliation").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_system_ledger_rows = [{"txn_id": "1001", "amount": "250.00", "category": "payroll"}, {"txn_id": "1002", "amount": "80.50", "category": "utilities"}, {"txn_id": "1003", "amount": "1200.00", "category": "rent"}, {"txn_id": "1004", "amount": "45.00", "category": "office_supplies"}, {"txn_id": "1005", "amount": "320.75", "category": "software"}]
system_ledger = _make_df(_system_ledger_rows, ['txn_id', 'amount', 'category']).select(
    F.col("txn_id").cast("int").alias("txn_id"),
    F.col("amount").cast("double").alias("amount"),
    F.col("category")
)

_bank_ledger_rows = [{"txn_id": "1001", "amount": "250.00", "category": "payroll"}, {"txn_id": "1002", "amount": "82.00", "category": "utilities"}, {"txn_id": "1003", "amount": "1200.00", "category": "rent"}, {"txn_id": "1005", "amount": "320.75", "category": "software"}, {"txn_id": "1006", "amount": "155.00", "category": "travel"}]
bank_ledger = _make_df(_bank_ledger_rows, ['txn_id', 'amount', 'category']).select(
    F.col("txn_id").cast("int").alias("txn_id"),
    F.col("amount").cast("double").alias("amount"),
    F.col("category")
)

# ---- solution ----
# Rename amount columns before joining so both are accessible after
sys_df  = system_ledger.select(F.col("txn_id"), F.col("amount").alias("system_amount"))
bank_df = bank_ledger.select(F.col("txn_id"), F.col("amount").alias("bank_amount"))

joined = sys_df.join(bank_df, on="txn_id", how="full")

result = (
    joined
    .withColumn("variance", F.col("bank_amount") - F.col("system_amount"))
    .filter(
        (F.col("system_amount") != F.col("bank_amount"))
        | F.col("system_amount").isNull()
        | F.col("bank_amount").isNull()
    )
    .select("txn_id", "system_amount", "bank_amount", "variance")
    .orderBy("txn_id")
)

result.show()


spark.stop()
