"""PySpark solution for: Radio Silence
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F, Window

# Convert commit_at to timestamp for date difference calculations
repo_commits = repo_commits.withColumn('commit_ts', F.to_timestamp('commit_at'))

# Window to get previous commit timestamp per repo ordered by commit time
window_spec = Window.partitionBy('repo_name').orderBy('commit_ts')
repo_commits = repo_commits.withColumn(
    'prev_commit_ts',
    F.lag('commit_ts').over(window_spec)
)

# Calculate gap in days using unix timestamps (seconds)
repo_commits = repo_commits.withColumn(
    'gap_days',
    (F.unix_timestamp('commit_ts') - F.unix_timestamp('prev_commit_ts')) / 86400.0
)

# Filter out first commits (null gaps), aggregate per repo
result = (
    repo_commits
    .filter(F.col('gap_days').isNotNull())
    .groupBy('repo_name')
    .agg(F.max('gap_days').alias('longest_silence'))
    .filter(F.col('longest_silence') > 5)
)

# Add dense rank ordered by longest silence descending
window_rank = Window.orderBy(F.desc('longest_silence'), 'repo_name')
result = result.withColumn(
    'silence_rank',
    F.dense_rank().over(window_rank)
).select('repo_name', 'longest_silence', 'silence_rank')

result.show()
