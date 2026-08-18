"""PySpark solution for: API Token Churn Rate
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Compute fraction of tokens with expired dates (expires is not null and before today)
churn_rate = (
    api_tokens
    .agg(
        (
            F.sum(
                F.when(
                    F.col("expires").isNotNull() & (F.to_date(F.col("expires")) < F.current_date()),
                    1
                ).otherwise(0)
            ).cast("double") / F.count("*")
        ).alias("churn_rate")
    )
)

churn_rate.show()
