"""PySpark solution for: Repos with More Builds Than Commits
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Join ci_builds and repo_commits on repo_name
joined_df = ci_builds.join(repo_commits, "repo_name")

# Count distinct builds and commits per repo, filter and rank
result_df = joined_df.groupBy("repo_name") \
    .agg(
        F.countDistinct("build_id").alias("build_count"),
        F.countDistinct("commit_id").alias("commit_count")
    ) \
    .filter(F.col("build_count") >= F.col("commit_count")) \
    .select("repo_name", "build_count") \
    .orderBy(F.col("build_count").desc())

# Show result (in a real script, you'd likely write to a table or file instead)
result_df.show()
