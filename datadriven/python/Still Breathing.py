"""PySpark solution for: Still Breathing
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import Window
from pyspark.sql import functions as F
from pyspark.sql import types as T

# Define the schema of the api_tokens DataFrame
api_tokens_schema = T.StructType([
    T.StructField('token_id', T.IntegerType()),
    T.StructField('owner_id', T.IntegerType()),
    T.StructField('scope', T.StringType()),
    T.StructField('status', T.StringType()),
    T.StructField('issued', T.StringType()),
    T.StructField('expires', T.StringType()),
    T.StructField('last_used', T.StringType()),
    T.StructField('requests', T.IntegerType())
])

# Create a sample api_tokens DataFrame
api_tokens = spark.createDataFrame([
    (1043, 197, 'write', 'revoked', '2025-02-02', '2027-02-02', '2026-02-02', 47),
    (1086, 294, 'admin', 'expired', '2025-03-03', '2027-03-03', '2026-03-03', 94),
    (1129, 391, 'read:users', 'Active', '2025-04-04', '2027-04-04', '2026-04-04', 141),
    (1172, 488, 'write:orders', 'REVOKED', '2025-05-05', '2027-05-05', '2026-05-05', 188),
    (1215, 585, 'read:analytics', 'active', '2025-06-06', '2027-06-06', '2026-06-06', 235),
    (1230, 100, 'read:users', 'active', '2025-07-07', '2027-07-07', '2026-07-07', 282),
    (1245, 585, 'read:analytics', 'active', '2025-08-08', '2027-08-08', '2026-08-08', 329),
    (1260, 1555, 'read:users', 'active', '2025-09-09', '2027-09-09', '2026-09-09', 376),
    (1275, 2040, 'read:analytics', 'active', '2025-10-10', '2027-10-10', '2026-10-10', 423)
], schema=api_tokens_schema)

# Filter the api_tokens DataFrame to only include tokens with status 'active'
active_tokens = api_tokens.filter(F.col('status') == 'active')

# Filter the active_tokens DataFrame to only include tokens issued before 2026-11-01
issued_before = active_tokens.filter(F.col('issued') < '2026-11-01')

# Filter the issued_before DataFrame to only include tokens with expiration date after 2026-11-01 or null
not_expired = issued_before.filter((F.col('expires').isNull()) | (F.col('expires') > '2026-11-01'))

# Select only the owner_id column and remove duplicates
owners = not_expired.select('owner_id').distinct()

# Sort the owners DataFrame by owner_id
owners = owners.orderBy('owner_id')

owners.show()
