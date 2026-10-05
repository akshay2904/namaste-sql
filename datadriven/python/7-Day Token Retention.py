"""PySpark solution for: 7-Day Token Retention
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter active tokens with traffic
active_tokens = api_tokens.filter(
    (F.lower(F.col("status")) == "active") & (F.col("requests") > 0)
).select("token_id", "owner_id", "issued", "expires")

# Self-join to find day7 active owners, avoiding duplicates via distinct owner join
result = (
    active_tokens.alias("a")
    .join(
        active_tokens.alias("b"),
        (F.col("b.owner_id") == F.col("a.owner_id"))
        & (F.to_date(F.col("b.issued")) <= F.date_add(F.to_date(F.col("a.issued")), 7))
        & (
            F.col("b.expires").isNull()
            | (F.to_date(F.col("b.expires")) >= F.date_add(F.to_date(F.col("a.issued")), 7))
        ),
        "left",
    )
    .select(
        F.col("a.issued").alias("the_date"),
        F.col("a.owner_id"),
        F.col("b.owner_id").alias("b_owner_id"),
    )
    .groupBy("the_date")
    .agg(
        F.countDistinct("owner_id").alias("active_day0"),
        F.countDistinct("b_owner_id").alias("active_day7"),
    )
    .orderBy("the_date")
    .limit(7)
)

result.show()
