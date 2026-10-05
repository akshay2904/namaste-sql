"""PySpark solution for: Honeymoon Phase
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Calculate signup year and transaction year
users_with_year = users.withColumn("signup_year", F.year(F.col("signup_date")))
transactions_with_year = transactions.withColumn("transaction_year", F.year(F.col("transaction_date")))

# Join, calculate same year flag, group and aggregate
result = (
    transactions_with_year
    .join(users_with_year, "user_id")
    .withColumn("same_year", F.col("transaction_year") == F.col("signup_year"))
    .groupBy("signup_year")
    .agg(
        F.round(
            (100.0 * F.sum(F.col("same_year").cast("integer"))) / F.count("*"),
            2
        ).alias("same_year_pct")
    )
    .orderBy("signup_year")
)

# Display result
result.show()
