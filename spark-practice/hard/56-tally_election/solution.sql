WITH vote_counts AS (
    SELECT
        district,
        candidate,
        COUNT(*) AS votes
    FROM votes
    GROUP BY district, candidate
),
ranked AS (
    SELECT
        district,
        candidate,
        votes,
        RANK() OVER (PARTITION BY district ORDER BY votes DESC) AS rnk
    FROM vote_counts
)
SELECT
    district,
    candidate,
    votes
FROM ranked
WHERE rnk = 1
ORDER BY district
