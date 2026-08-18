"""PySpark solution for: Latest Commit Build Cost
Auto-translated from the SQL solution in the matching .sql file."""

import pyspark.sql.functions as F
from pyspark.sql.window import Window

# Filter commits to repos with CI build history
repos_with_ci = ci_builds.select("repo_name").distinct()
filtered_commits = repo_commits.join(repos_with_ci, "repo_name", "inner")

# Rank commits per author by most recent commit
window_spec = Window.partitionBy("author").orderBy(F.col("commit_at").desc())
ranked_commits = filtered_commits.withColumn("rn", F.row_number().over(window_spec))

# Keep only the most recent commit per author
latest_commits = ranked_commits.filter(F.col("rn") == 1)

# Join with CI builds and aggregate total build seconds per author
result = (latest_commits
    .join(ci_builds, "repo_name", "inner")
    .groupBy("author")
    .agg(F.sum("dur_secs").alias("total_build_seconds"))
    .orderBy("author"))

result.show()
