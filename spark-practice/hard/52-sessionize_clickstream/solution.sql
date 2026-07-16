WITH lagged AS (
    SELECT
        event_id,
        user_id,
        page,
        event_time,
        LAG(event_time) OVER (PARTITION BY user_id ORDER BY event_time) AS prev_time
    FROM clickstream
),
flagged AS (
    SELECT
        event_id,
        user_id,
        page,
        event_time,
        CASE
            WHEN prev_time IS NULL
                 OR UNIX_TIMESTAMP(event_time) - UNIX_TIMESTAMP(prev_time) > 1800
            THEN 1
            ELSE 0
        END AS new_session_flag
    FROM lagged
)
SELECT
    event_id,
    user_id,
    page,
    event_time,
    SUM(new_session_flag) OVER (
        PARTITION BY user_id
        ORDER BY event_time
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS session_id
FROM flagged
ORDER BY user_id, event_time
