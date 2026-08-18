"""PySpark solution for: Still Standing
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

unexpired_tokens = api_tokens.filter(
    (api_tokens.expires.isNull()) | (api_tokens.expires > F.current_date())
).filter(api_tokens.status != 'expired')

busiest_tokens = unexpired_tokens.orderBy(api_tokens.requests.desc()).limit(5)

result = busiest_tokens.select('token_id', 'issued')
