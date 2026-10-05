"""PySpark solution for: Find the Fifth Largest Cost
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Calculate the fifth-highest distinct amount
distinct_amounts = cloud_costs.select("amount").distinct()
fifth_highest = (
    distinct_amounts
    .select(
        "amount",
        F.row_number().over(
            Window.orderBy(F.col("amount").desc())
        ).alias("rn")
    )
    .filter(F.col("rn") == 5)
    .select("amount")
)

# Filter rows where amount equals the fifth-highest amount
result = cloud_costs.join(fifth_highest, on="amount", how="inner")
result = result.select(
    "cost_id", "provider", "svc_name", "region", "amount", "acct_id", "bill_date"
).orderBy("cost_id")

result.show()
